<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2020/4/22
 * Time: 9:38 PM
 */
namespace app\model;

class KeFu extends BaseModel
{
    protected $table = 'v2_kefu';

    /**
     * 通过客服code获取客服信息
     * @param $code
     * @return array
     */
    public function getKeFuInfoByCode($code)
    {
        try {

            $kefuInfo = $this->db->select('*')->from($this->table)
                ->where('kefu_code="' . $code . '" AND kefu_status=1')
                ->row();
        } catch (\Exception $e) {
            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $kefuInfo, 'msg' => 'ok'];
    }

    // /**
    //  * 通过客服code获取客服信息 列表
    //  */
    // public function getKeFuInfoByCode_New($code, $appcode)
    // {
    //     try {

    //         $kfu = $this->db->select('*')->from($this->table)
    //         ->where('kefu_code="' . $code . '" AND kefu_status=1')
    //         ->toArray();

            

    //         $kefuInfo = $this->db->select('*')->from($this->table)
    //             ->where('kefu_code="' . $code . '" AND kefu_status=1')
    //             ->query();
    //     } catch (\Exception $e) {
    //         return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
    //     }

    //     return ['code' => 0, 'data' => $kefuInfo, 'msg' => 'ok'];
    // }


    /**
     * 设置客服离线状态
     * @param $keFuCode
     * @return array
     */
    public function keFuOffline($keFuCode)
    {
        try {

            $sql = 'UPDATE ' . $this->table . ' SET online_status = 0 WHERE kefu_code = "' . $keFuCode . '"';
            $this->db->query($sql);
        } catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => [], 'msg' => 'ok'];
    }

    /**
     * 设置客服在线状态
     * @param $keFuCode
     * @return array
     */
    public function setKeFuStatus($keFuCode)
    {
        try {

            $sql = 'UPDATE ' . $this->table . ' SET online_status = 1,last_login_time = "' . date('Y-m-d H:i:s')
                . '" WHERE kefu_code = "' . $keFuCode . '"';
            $this->db->query($sql);
        } catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => [], 'msg' => 'ok'];
    }

    /**
     * 查询群组下，在线的客服信息
     * @param $groupId
     * @return array
     */
    public function getOnlineKeFuByGroup($groupId)
    {
        try {

            $kefuInfo = $this->db->select('kefu_id,kefu_code,kefu_name,kefu_avatar,max_service_num,seller_id,kefy_type,greetings')->from($this->table)
                ->where('group_id=' . $groupId . ' AND kefu_status=1 AND online_status=1 AND kefy_type=1')
                ->query();

            // $kefuInfo = $this->db->select('kefu_id,kefu_code,kefu_name,kefu_avatar,max_service_num,seller_id')->from($this->table)
            //     ->where('group_id=' . $groupId . ' AND kefu_status=1 AND online_status=1')
            //     ->query();
        } catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $kefuInfo, 'msg' => 'ok'];
    }

    /**
     * 查询商家所有，Robot 客服信息
     * @param $sellerId
     * @return array
     */
    public function getRobotKeFuList($sellerId)
    {
        try {

            $kefuInfo = $this->db->select('kefu_id,kefu_code,kefu_name,kefu_avatar,max_service_num,seller_id,kefy_type,greetings')->from($this->table)
                ->where('seller_id=' . $sellerId . ' AND kefu_status=1 AND kefy_type=0')
                ->query();
        } catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $kefuInfo, 'msg' => 'ok'];
    }

    /**
     * 获取客服信息
     * @param $keFuId
     * @return array
     */
    public function getKeFuById($kefu_code)
    {
        try {

            $info = $this->db->select('*')->from($this->table)
                ->where('kefu_code="' . $kefu_code . '"')
                ->row();

            return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        
    }
}