<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/10/24
 * Time: 9:56 PM
 */
namespace app\model;

use think\Model;

class KeFuWeb extends Model
{
    protected $table = 'v2_kefu_web';

    /**
     * 根据 dify_apps_id 获取 拥有此app权限的 客服列表
     * @param $dify_apps_id
     * @return array
     */
    public function getKeFuWebList($dify_apps_id)
    {
        try {

            $res = $this->field('kf_id')->where('dify_apps_id', $dify_apps_id)->select()->toArray();
        } catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }



   
}