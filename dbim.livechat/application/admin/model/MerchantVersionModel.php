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

class MerchantVersionModel extends Model
{
    protected $table = 'v2_sj_merchant_version';

    /**
     * 商家版本配置列表
     * @param $limit
     * @param $character
     * @return array
     */
    public function getMerchantVersionList($limit, $character)
    {
        try {
            if (!empty($character)) {
                $res = $this->where('character', 'like', '%' . $character . '%')->order('merchant_id', 'desc')->paginate($limit);
            } else {

                $res = $this->order('merchant_id', 'desc')->paginate($limit);
            }

        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }

    /**
     * 增加商家版本
     * @param $packageData
     * @return array
     */
    public function addMerchantVersion($merchantVersion)
    {
        try {

            $has = $this->where('character', $merchantVersion['character'])->findOrEmpty()->toArray();
            if(!empty($has)) {
                return ['code' => -2, 'data' => '', 'msg' => '商家版本名称已经存在'];
            }
            $merchantVersion['create_time'] = date('Y-m-d H:i:s');
            $merchantVersion['update_time'] = date('Y-m-d H:i:s');

            $id = $this->insertGetId($merchantVersion);
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $id, 'msg' => '添加套餐成功'];
    }

    /**
     * 编辑商家版本
     * @param $merchantVersion
     * @return array
     */
    public function editMerchantVersion($merchantVersion)
    {
        try {
            $has = $this->where('character', $merchantVersion['character'])->where('merchant_id', '<>', $merchantVersion['merchant_id'])
                ->findOrEmpty()->toArray();
            if(!empty($has)) {
                return ['code' => -2, 'data' => '', 'msg' => '商家版本名称已经存在'];
            }

            $this->save($merchantVersion, ['merchant_id' => $merchantVersion['merchant_id']]);
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => '编辑商家版本成功'];
    }

    /**
     * 删除商家版本
     * @param $merchantId
     * @return array
     */
    public function delMerchantVersion($merchantId)
    {
        try {
            // 删除商家版本
            $this->where('merchant_id', $merchantId)->delete();

        } catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => '删除成功'];
    }

    
    /**
     * 根据ID 获取版本信息
     * @param $id
     * @return array
     */
    public function getMerchantVersion($id)
    {
        try {

            $info = $this->where('merchant_id', $id)->findOrEmpty()->toArray();
        } catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
    }


    /**
     * 获取所有商家版本
     * @return array
     */
    public function getAllMerchantVersion()
    {
        try {

            $info = $this->select()->toArray();
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
    }

   
}