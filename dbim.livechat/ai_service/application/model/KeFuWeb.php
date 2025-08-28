<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Date: 2019/3/1
 * Time: 14:22
 */
namespace app\model;


class KeFuWeb extends BaseModel
{
    protected $table = 'v2_kefu_web';

    /**
     * 根据 dify_apps_id 查询 kefu_id 列表
     */
    public function getKfIdList($dify_apps_id)
    {
        $data = $this->db
        ->select('*')
        ->from($this->table)
        ->where('dify_apps_id="'.$dify_apps_id.'"')
        // ->row();
        ->query();
        return $data;
    }


}