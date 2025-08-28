<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/3/3
 * Time: 11:54 AM
 */
namespace app\seller\model;

use think\Model;

class System extends Model
{
    protected $table = 'v2_system';

    /**
     * 获取商家的配置
     * @return array
     */
    public function getSellerConfig()
    {
        $res = $this->where('seller_id', session('seller_user_id'))->findOrEmpty()->toArray();
        if(empty($res)) {
            $this->insert([
                'hello_word' => config('service.hello_word'),
                'seller_id' => session('seller_user_id'),
                'seller_code' => session('seller_code'),
                'hello_status' => 1,
                'relink_status' => 1,
                'auto_link' => 0,
                'auto_link_time' => 30
            ]);
            $res = $this->where('seller_id', session('seller_user_id'))->findOrEmpty()->toArray();
        }
        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }

    /**
     * 编辑系统设置
     * @param $param
     * @return array
     */
    public function editSystem($param)
    {
        try {
            $this->save($param, ['seller_id' => session('seller_user_id')]);
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => '编辑成功'];
    }
}