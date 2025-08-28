<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2020/4/22
 * Time: 8:57 PM
 */
namespace app\model;

class SystemConfigList extends BaseModel
{
    protected $table = 'v2_sj_config';


    /**
     * 获取所有配置信息
     * @param $id
     * @return array
     */
    public function getSysConfigList()
    {
        try {
            $info = $this->db->select('*')->from($this->table)->query();
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
    }

    
    
}