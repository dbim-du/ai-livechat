<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/3/17
 * Time: 4:48 PM
 */
namespace app\admin\model;

use think\Model;

class ConsumptionLogModel extends Model
{
    protected $table = 'v2_sj_consumption_log';

    /**
     * 商家消费记录
     * @param $limit
     * @param $xf_type 消费类型：01：金币，02：Tokens， 
     * @param $con_project 01、购买tokens，02：客服聊天消费，03：Tokens 套餐购买，04、充值，
     * @param $seller_id 消费商家ID 
     * @return array
     */
    public function getConsumptionLogList($limit, $xf_type, $seller_name)
    {
        try {

            $where = [];
            if(!empty($xf_type)) {
               $where[] = ['a.type', '=', $xf_type];
            }
            // if  ('' != $con_project){
            //     $where[] = ['a.con_project', '=', $con_project];
            // }
            if (!empty($seller_name)) {
                $where[] = ['b.seller_name', 'like', '%' . $seller_name . '%'];
            } 

            if (count($where)>0) {
                $res = $this->alias('a')->field('a.*,b.seller_name')
                ->where($where)
                ->leftJoin(['v2_seller' => 'b'], 'a.seller_id = b.seller_id')
                ->order('a.consumption_id','desc')
                ->paginate($limit);
            }else {
                $res = $this->alias('a')->field('a.*,b.seller_name')
                ->leftJoin(['v2_seller' => 'b'], 'a.seller_id = b.seller_id')
                ->order('a.consumption_id','desc')
                ->paginate($limit);
            }

        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }
        //var_dump(json_encode($res));
        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }

    /**
     * 根据ID 获取消费详细信息
     * @param $id
     * @return array
     */
    public function getConsumptionLog($id)
    {
        try {
            $info = $this->where('consumption_id', $id)->findOrEmpty()->toArray();
        } catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
    }


    /**
     * 增加商家消费记录
     * @param $packageData
     * @return array
     */
    public function addConsumptionLog($param)
    {
        try {
            $this->insert($param);
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => '添加成功'];
    }

    /**
     * 生成 复杂的订单编号（推荐）
     * 示例输出：ORD20231015000123A1B2C3
     */
    function CreateOrderNumber($prefix = 'ORD', $userId = 0) {
    // 前缀 + 年月日 + 用户ID + 随机字符串 
    $datePart = date('Ymd');
    $userIdPart = str_pad($userId, 6, '0', STR_PAD_LEFT);
    $randomPart = strtoupper(substr(md5(uniqid()), 0, 6));
    
    $orderNumber = $prefix . $datePart . $userIdPart . $randomPart;
    return $orderNumber;
}
 




}