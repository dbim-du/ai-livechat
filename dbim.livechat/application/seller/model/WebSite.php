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
use think\model\concern\SoftDelete;

class WebSite extends Model
{
    use SoftDelete;
    protected $pk = 'web_id';
    protected $table = 'v2_seller_web';
    protected $autoWriteTimestamp = 'datetime';

    /**
     * 获取列表
     * @param $limit
     * @param $where
     * @return array
     */
    public function getWebList($limit, $where = [])
    {
        try {
            $res = $this->where(['seller_id'=>session('seller_user_id')])
                 ->where(function($query) use ($where){$query->whereOr($where);})
                 ->paginate($limit);
        }catch (\Exception $e) {
            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }

    public function WebListAll()
    {
        try {
            $res = $this->where(['seller_id'=>session('seller_user_id')])->select()->toArray();
        }catch (\Exception $e) {
            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }

    /**
     * 添加站点
     * @param $param
     * @return array
     */
    public function addWebSite($param)
    {
        try {
            $where[]=['web_name','=',$param['web_name']];
            $where1[]=['web_url','=',$param['web_url']];
            $has = $this->where('seller_id', session('seller_user_id'))
                ->where(function($query) use ($where){$query->whereOr($where);})
                ->findOrEmpty()->toArray();
            if(!empty($has)) {
                return ['code' => -2, 'data' => '', 'msg' => '应用名称已存在'];
            }

            $has1 = $this->where('seller_id', session('seller_user_id'))
                ->where(function($query) use ($where1){$query->whereOr($where1);})
                ->findOrEmpty()->toArray();
            if(!empty($has1)) {
                return ['code' => -2, 'data' => '', 'msg' => '应用URL已存在'];
            }

            $this->save($param);
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => '添加站点成功'];
    }


    /**
     * 获取客服信息
     * @param $keFuId
     * @return array
     */
    public function getWebSiteById($webId)
    {
        try {

            $info = $this->where('web_id', $webId)
                ->where('seller_id', session('seller_user_id'))
                ->findOrEmpty()->toArray();
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => [], 'msg' => $e->getMessage()];
        }
        return ['code' => 0, 'data' => $info, 'msg' => 'ok'];
    }

    /**
     * 编辑客服
     * @param $param
     * @return array
     */
    public function editWebSite($param)
    {
        try {
            $where[]=['web_name','=',$param['web_name']];
            $where1[]=['web_url','=',$param['web_url']];
            $has = $this->where('web_id','<>',$param['web_id'])->where('seller_id', session('seller_user_id'))
                       ->where(function($query) use ($where){$query->whereOr($where);})
                       ->findOrEmpty()->toArray();;
            if(!empty($has)) {
                return ['code' => -2, 'data' => '', 'msg' => '应用名称已存在'];
            }

            $has1 = $this->where('web_id','<>',$param['web_id'])->where('seller_id', session('seller_user_id'))
                       ->where(function($query) use ($where1){$query->whereOr($where1);})
                       ->findOrEmpty()->toArray();;
            if(!empty($has1)) {
                return ['code' => -2, 'data' => '', 'msg' => '应用URL已存在'];
            }


            $this->save($param, ['web_id' => $param['web_id']]);
        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => '编辑站点成功'];
    }

    /**
     * 删除站点
     * @param $keFuId
     * @return array
     */
    public function delWebSite($webSiteId)
    {
        try {
            $has = $this->where('web_id', $webSiteId)->where('seller_id', session('seller_user_id'))
                ->find();
            if($has){
            $this::destroy($webSiteId);
            }

        }catch (\Exception $e) {

            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => '删除站点成功'];
    }

}