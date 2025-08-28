<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Date: 2019/3/1
 * Time: 14:22
 */
namespace app\seller\model;

use app\model\Service;
use think\Model;

class KeFuWeb extends Model
{
    protected $table = 'v2_kefu_web';
    protected $autoWriteTimestamp = 'datetime';
    protected $pk = 'kf_web_id';



    /**
     * 获取列表
     * @param $where
     * @return array
     */
    public function getKeFuWebList($kf_id)
    {
        try {

            // $info = $this->where('seller_id', session('seller_user_id'))->where('kf_id', $kf_id)
            //     ->select()->toArray();

            $info = $this->where('seller_id', session('seller_user_id'))->where('kf_id', $kf_id)
                ->column('dify_apps_id');

        }catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
    }


    /**
     * 根据 dify_apps_id 查询 kefu_id 列表
     */
    public function getKfIdList($dify_apps_id)
    {
        $data = $this->where('dify_apps_id', $dify_apps_id)
        ->select()
        ->toArray();
        return $data;
    }


}