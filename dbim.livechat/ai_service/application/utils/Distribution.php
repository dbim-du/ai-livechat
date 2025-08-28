<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2020/5/17
 * Time: 9:25 PM
 */
namespace app\utils;

use app\model\BaseModel;
use app\model\Customer;
use app\model\Group;
use app\model\KeFu;
use app\model\Seller;
use app\model\Service;
// use app\model\DifyDataNew;
use app\model\KeFuWeb;
// use think\Db;
// use think\view\driver\Think;
use Workerman\Worker;
use Workerman\Connection\TcpConnection;

class Distribution extends BaseModel
{
    /**
     * 用户上线后触发分配客服
     * @param $param
     * @return array
     */
    public function customerDistribution($param)
    {
        if(empty($param)) {
            return ['code' => -1, 'data' => '', 'msg' => '参数缺失'];
        }

        // step one 优先找上次服务的用户给访客服务
        $preInfo = self::findPreKeFuService($param);
        if(0 != $preInfo['code']) {
            return $preInfo;
        }
        
        // ⭐第一次的 所有 访客 都会 先执行这个 方法，因为 没有上一次服务的 客服信息
        // step two 寻找该商户下前置业务组下是否有在线的空闲客服
        return self::findFreeKeFu($preInfo['data'],$param['appcode']);
    }

    /**
     * 优先寻找该访客在该商户下，上次为其服务的客服，再次给他服务【该客服要在 前置服务组 】
     * @param $param
     * @return array
     */
    private function findPreKeFuService($param)
    {
       
        // 获取该访客的所属商户信息
        $seller = new Seller($this->db);
        $info = $seller->getSellerInfo($param['seller_code']);

        if(0 != $info['code'] || empty($info['data'])) {
            return ['code' => -2, 'data' => '', 'msg' => '商户不存在'];
        }

        if(0 == $info['data']['seller_status']) {
            return ['code' => -4, 'data' => '', 'msg' => '商户被禁用'];
        }

        // 1、查询 上次服务的客服 编号
        $customerModel = new Customer($this->db);
        $preKefu = $customerModel->getCustomerInfoById($param['customer_id'], $param['seller_code']);

        if(0 != $preKefu['code'] || empty($preKefu['data'])) {
            return ['code' => 0, 'data' => $info, 'msg' => 'next step'];
        }

        // 2、如果($preKefu 为空，这个查询也是 空) 查询 客服基本信息
        $kefu = new KeFu($this->db);
        $kefuInfo = $kefu->getKeFuInfoByCode($preKefu['data']['pre_kefu_code'], $param['appcode']);

        if(0 != $kefuInfo['code'] || empty($kefuInfo['data'])) {
            return ['code' => 0, 'data' => $info, 'msg' => 'next step'];
        }

        // 查询 客服分组信息
        $groupModel = new Group($this->db);
        $groupInfo = $groupModel->getGroupInfoById($kefuInfo['data']['group_id']);
        if(0 != $groupInfo['code'] || empty($groupInfo['data'])) {
            return ['code' => -10, 'data' => '', 'msg' => '获取分组信息异常'];
        }

        // 3、上次服务的客服，并不在前置服务分组中，重新分配（验证 appcode 权限）
        if(1 != $groupInfo['data']['first_service']) {
            return ['code' => 0, 'data' => $info, 'msg' => 'next step'];
        }

        // 4、上次服务的客服不在线，重新分配（验证 appcode 权限）
        if(1 != $kefuInfo['data']['online_status']) {
            return ['code' => 0, 'data' => $info, 'msg' => 'next step'];
        }

        $service = new Service($this->db);
        $num = $service->getNowServiceNum($kefuInfo['data']['kefu_code']);
        if(0 != $num['code']) {
            return ['code' => 0, 'data' => $info, 'msg' => 'next step'];
        }

        // 上次服务的客服，现在忙，重新分配
        $freeNumber = $kefuInfo['data']['max_service_num'] - $num['data'];
        if($freeNumber <= 0) {
            return ['code' => 0, 'data' => $info, 'msg' => 'next step'];
        }

        return ['code' => 200, 'data' => [
            'kefu_code' => 'KF_' . $kefuInfo['data']['kefu_code'],
            'kefu_name' => $kefuInfo['data']['kefu_name'],
            'kefu_avatar' => $kefuInfo['data']['kefu_avatar']
        ], 'msg' => '上次的客服继续服务'];
    }

    /**
     * 寻找该商户下空闲的客服去服务
     * @param $info
     * @return array
     */
    private function findFreeKeFu($info,$appcode)
    {
        $groupModel = new Group($this->db);
        $groupInfo = $groupModel->getFirstServiceGroup($info['data']['seller_id']);
        if(0 != $groupInfo['code'] || empty($groupInfo['data'])) {
            return ['code' => -5, 'data' => '', 'msg' => '该商户下没配置前置服务组'];
        }

        $kefu = new KeFu($this->db);
        $kefuInfo = $kefu->getOnlineKeFuByGroup($groupInfo['data']['group_id']);
        if(0 != $kefuInfo['code']) {
            return ['code' => -6, 'data' => '', 'msg' => '查询分组客服失败'];
        }

        if(empty($kefuInfo['data'])) {
            return ['code' => 201, 'data' => '', 'msg' => '暂无客服上班1'];
        }

        // ================== 客服关联 dify 应用 ======================
        try {
            
            // 如果 客户端 关联了应用就返回关联应用的客服，
            // 如果没有关联应用就返回所有客服列表
            // 筛选出一个 客服 联系 客户

            // 1、根据 appcode 查询 dify_app 的 app_id
            $rows = self::selDifyApp_($appcode);
            if (count($rows)>0) {

                // 2、根据 app_id 查询 v2_kefu_web 的 所有 kf_id 列表
                $KeFuWeb = new KeFuWeb($this->db);
                $kf_ids = $KeFuWeb->getKfIdList($rows[0]['app_id']);

                // 3、将 $kefuInfo['data'] 集合中 排除 所有 不包含 此 kf_id 的数据
                if (count($kf_ids)>0) {

                    $In_kefuInfo = $this->filterArray($kefuInfo['data'], $kf_ids);
                    $kefuInfo['data'] = $In_kefuInfo;
                }

            }
        
        } catch (\Exception $e) {
            return ['code' => 201, 'data' => '', 'msg' => '暂无客服上班3'.$e];
        }

        // ================== 客服关联 dify 应用 ======================

        // TODO 此处执行策略 -- v1.1暂时在此处定死一种策略，后面做动态切换
        $distributionObj = Factory::getObject("circle");
        $distributionObj->setDb($this->db);
        $res = $distributionObj->doDistribute($kefuInfo['data']);

        if (0 != $res['code']) {
            return $res;
        }

        return ['code' => 200, 'data' => $res['data'], 'msg' => 'ok'];
    }


    /**
     * 筛选 arrayA 中，arrayB 中存在的元素
     */
    private function filterArray($arrayA, $arrayB)
    {
        $arrayData=[];
        for ($i=0; $i < count($arrayA); $i++) { 
            for ($j=0; $j < count($arrayB); $j++) { 
                if ($arrayA[$i]['kefu_id']==$arrayB[$j]['kf_id']) {
                    $arrayData[] = $arrayA[$i];
                }
            }
        }
        return $arrayData;
    }






    /**
     * dify 数据库连接
     */
    private function difyConnect()  
    {
        $config_ = ENVCONST['dify_db_config'];
        $pg = pg_connect("host={$config_['hostname']} port={$config_['hostport']} 
                    dbname={$config_['database']} 
                    user={$config_['username']} 
                    password={$config_['password']}");
        return $pg;
    }

    /**
     * 关闭 dify 数据库连接、释放资源
     */
    private function difyClose($result,$pg)  
    {
        // 释放结果集
        pg_free_result($result);

        // 关闭连接(如果是持久连接则不需要)
        pg_close($pg);
    }

    /**
     * 1、根据 appcode 查询 dify_app 的 app_id
     */
    public function selDifyApp_($app_code)
    {
        // $config_ = ENVCONST['dify_db_config'];
        // $pg = pg_connect("host={$config_['hostname']} port={$config_['hostport']} 
        //             dbname={$config_['database']} 
        //             user={$config_['username']} 
        //             password={$config_['password']}");

        $pg = $this->difyConnect();
        
        if (!$pg) {
            return ['code' => 201, 'data' => '', 'msg' => '数据库连接失败'. pg_last_error()];
        }

        // 1、查询 sites Dify 应用信息
        $data_sites = [
            'code' => $app_code
        ];
        // 执行带参数绑定的SQL 
        $sql_sites = "SELECT * FROM sites WHERE code = $1";// PostgreSQL使用$1, $2等作为参数占位符
        $result = pg_query_params($pg, $sql_sites, [$data_sites['code']]);

        if (!$result) {
            return ['code' => 201, 'data' => '', 'msg' => '查询执行失败'. pg_last_error($pg)];
        }
        // 获取查询结果
        $rows = [];
        while ($row = pg_fetch_assoc($result)) {
            $rows[] = $row;
        }

        // // 释放结果集
        // pg_free_result($result);

        // // 关闭连接(如果是持久连接则不需要)
        // pg_close($pg);

        // 关闭 dify 数据库连接、释放资源
        $this->difyClose($result,$pg);

        return $rows;
    }


    /**
     * 查询 dify_app 数据列表的 通用查询方法
     */
    public function selDifyApp_DataList($sql,$sql_param)
    {
        $pg = $this->difyConnect();
        
        if (!$pg) {
            return ['code' => 201, 'data' => '', 'msg' => '数据库连接失败'. pg_last_error()];
        }

        // // 1、查询 sites Dify 应用信息
        // $data_sites = [
        //     'code' => $app_code
        // ];
        // 执行带参数绑定的SQL 
        // $sql = "SELECT * FROM sites WHERE code = $1";// PostgreSQL使用$1, $2等作为参数占位符
        // $result = pg_query_params($pg, $sql, [$data_sites['code']]);
        $result = pg_query_params($pg, $sql, $sql_param);

        if (!$result) {
            return ['code' => 201, 'data' => '', 'msg' => '查询执行失败'. pg_last_error($pg)];
        }
        // 获取查询结果
        $rows = [];
        while ($row = pg_fetch_assoc($result)) {
            $rows[] = $row;
        }

        // 关闭 dify 数据库连接、释放资源
        $this->difyClose($result,$pg);

        return $rows;
    }



}