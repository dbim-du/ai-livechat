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

class BuypackageModel extends Model
{
    protected $table = 'v2_sj_buy_package';

    /**
     * 套餐列表
     * @param $limit
     * @param $packageName
     * @return array
     */
    public function getBuyPackgeList($limit, $packageName)
    {
        try {
            if (!empty($packageName)) {
                $res = $this->where('package_name', 'like', '%' . $packageName . '%')->order('package_id', 'desc')->paginate($limit);
            } else {

                $res = $this->order('package_id', 'desc')->paginate($limit);
            }

        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }

    /**
     * 增加套餐
     * @param $packageData
     * @return array
     */
    public function addBuyPackge($packageData)
    {
        try {

            $has = $this->where('package_name', $packageData['package_name'])->findOrEmpty()->toArray();
            if(!empty($has)) {
                return ['code' => -2, 'data' => '', 'msg' => '套餐名称已经存在'];
            }
            //$packageData['status']  = 1;
            $packageData['create_time'] = date('Y-m-d H:i:s');
            $packageData['update_time'] = date('Y-m-d H:i:s');

            $id = $this->insertGetId($packageData);
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $id, 'msg' => '添加套餐成功'];
    }

    /**
     * 编辑套餐
     * @param $packageData
     * @return array
     */
    public function editBuyPackge($packageData)
    {
        try {
            $has = $this->where('package_name', $packageData['package_name'])->where('package_id', '<>', $packageData['package_id'])
                ->findOrEmpty()->toArray();
            if(!empty($has)) {
                return ['code' => -2, 'data' => '', 'msg' => '套餐名称已经存在'];
            }

            $this->save($packageData, ['package_id' => $packageData['package_id']]);
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => '编辑套餐成功'];
    }

    /**
     * 删除套餐
     * @param $sellerId
     * @return array
     */
    public function delBuyPackge($packageId)
    {
        try {
            // 删除商户信息
            $this->where('package_id', $packageId)->delete();

        } catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => '删除成功'];
    }

    
    /**
     * 获取套餐信息
     * @param $id
     * @return array
     */
    public function getBuyPackge($id)
    {
        try {

            $info = $this->where('package_id', $id)->findOrEmpty()->toArray();
        } catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
    }


    /**
     * 获取所有套餐
     * @return array
     */
    public function getAllBuyPackge()
    {
        try {

            $info = $this->select()->toArray();
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
    }

   
}