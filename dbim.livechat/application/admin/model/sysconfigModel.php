<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Date: 2019/3/4
 * Time: 10:56
 */
namespace app\admin\model;

use think\Model;

class sysconfigModel extends Model
{
    protected $table = 'v2_sj_config';

    /**
     * 获取商户信息
     * @param $limit
     * @param $where
     * @return array
     */
    public function getSysConfig($limit)
    {
        try {
            $res = $this->paginate($limit);
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }

    /**
     * 获取配置信息
     * @param $id
     * @return array
     */
    public function getSysConfigById($id)
    {
        try {
            $info = $this->where('id', $id)->findOrEmpty()->toArray();
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
    }

     /**
     * 获取所有配置信息
     * @param $id
     * @return array
     */
    public function getSysConfigList()
    {
        try {
            $info = $this->select()->toArray();
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
    }
}