<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Date: 2019/3/1
 * Time: 14:22
 */
namespace app\seller\model;

use app\common\utils\JsonRes;
use app\model\Service;
use think\Db;
use think\Exception;
use think\Model;

class KeFu extends Model
{
    protected $table = 'v2_kefu';
    protected $autoWriteTimestamp = 'datetime';
    protected $pk = 'kefu_id';

    /**
     * 获取分组列表
     * @param $limit
     * @param $where
     * @return array
     */
    public function getKeFuList($limit, $where = [])
    {
        try {

            $res = $this->alias('a')->field('a.*,b.group_name')
                 ->where('a.seller_id', session('seller_user_id'))
                 ->where($where)
                 ->leftJoin(['v2_group' => 'b'], 'a.group_id = b.group_id')
                 ->paginate($limit);
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }

    /**
     * 添加客服
     * @param $param
     * @return array
     */
    public function addKeFu($param,$webSites)
    {
        $has = $this->where('kefu_name', $param['kefu_name'])
            ->where('seller_id', session('seller_user_id'))
            ->findOrEmpty()->toArray();
        if(!empty($has)) {
            return JsonRes::failed('客服已经存在',-1);
        }
        Db::startTrans();
        try{
            $this->save($param);
            $kefu_id = $this->kefu_id;
            $data = [];
            $now = date('Y-m-d H:i:s');
            foreach ($webSites as $v) {
                $data[] = [
                    'dify_apps_id' => $v,
                    'kf_id' => $kefu_id,
                    'seller_id'=>$param['seller_id'],
                    'create_time'=>$now,
                ];
            }
            $kfWeb = new KeFuWeb();
            $kfWeb->insertAll($data);
            Db::commit();
            return JsonRes::success('操作成功');
        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();
            throw new Exception( $e->getMessage());
        }
    }

    /**
     * 获取分组中客服的数量
     * @param $groupId
     * @return array
     */
    public function getKeFuUserByGroup($groupId)
    {
        try {

            $res = $this->where('seller_id', session('seller_user_id'))->where('group_id', $groupId)->count();
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => 0, 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }

    /**
     * 获取客服信息
     * @param $keFuId
     * @return array
     */
    public function getKeFuById($keFuId)
    {
        try {

            $info = $this->where('kefu_id', $keFuId)
                ->where('seller_id', session('seller_user_id'))
                ->findOrEmpty()->toArray();
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
    }

    /**
     * 编辑客服
     * @param $param
     * @return array
     */
    public function editKeFu($param,$webSites)
    {
        try {
            $seller_id =session('seller_user_id');
            $has = $this->where('kefu_name', $param['kefu_name'])
                ->where('seller_id', $seller_id)
                ->where('kefu_id', '<>', $param['kefu_id'])
                ->findOrEmpty()->toArray();
            if(!empty($has)) {
                return ['code' => -2, 'data' => '', 'msg' => '客服名已经存在'];
            }

            $this->save($param, ['kefu_id' => $param['kefu_id']]);

            // 删除 web应用ID
            $kfWeb = new KeFuWeb();
            $kfWeb->where('seller_id', $seller_id)->where('kf_id', $param['kefu_id'])->delete();

            // 添加 web应用ID
            $data = [];
            $now = date('Y-m-d H:i:s');
            foreach ($webSites as $v) {
                $data[] = [
                    'dify_apps_id' => $v,
                    'kf_id' => $param['kefu_id'],
                    'seller_id'=>$seller_id,
                    'create_time'=>$now,
                ];
            }

            $kfWeb->insertAll($data);






        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => '编辑客服成功'];
    }

    /**
     * 删除客服
     * @param $keFuId
     * @return array
     */
    public function delKeFu($keFuId)
    {
        try {

            $this->where('kefu_id', $keFuId)->where('seller_id', session('seller_user_id'))->delete();
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => '删除客服成功'];
    }

    /**
     * 获取商家在线客服
     * @return array
     */
    public function getOnlineKeFu()
    {
        try {

            $keFu = $this->where('seller_id', session('seller_user_id'))->whereIn('online_status', [1, 2])
                ->where('kefu_status', 1)
                ->select()->toArray();

            $serviceModel = new Service();
            $serviceLogModel = new ServiceLog();
            foreach ($keFu as $key => $vo) {
                $keFu[$key]['service_num'] = $serviceModel->getNowServiceNum($vo['kefu_code'])['data'];
                $keFu[$key]['total_service_num'] = $serviceLogModel->getKeFuTotalServiceNum($vo['kefu_code'])['data'];
            }
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $keFu, 'msg' => 'ok'];
    }

    /**
     * 获取商户客服
     * @return array
     */
    public function getSellerKeFu()
    {
        try {

            $keFu = $this->where('seller_code', session('seller_code'))->select()->toArray();
        }catch (\Exception $e) {
            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }
        return ['code' => 0, 'data' => $keFu, 'msg' => 'ok'];
    }


    public function  getSellerKeFuNew($seller_id)
    {
        $sql = 'select a.kefu_id,a.kefu_code,a.kefu_name,a.seller_code,c.web_id,c.web_name,c.web_code,c.web_url from v2_kefu as a,v2_kefu_web as b,v2_seller_web as c
where a.kefu_id = b.kf_id and b.web_id = c.web_id and a.seller_id = :seller_id  order by a.kefu_id;';
        $kefuList = $this->query($sql,['seller_id'=>$seller_id]);
        return $kefuList;
    }
}