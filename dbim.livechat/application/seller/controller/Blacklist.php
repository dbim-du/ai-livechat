<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/28
 * Time: 8:23 PM
 */
namespace app\seller\controller;

use app\common\utils\JsonRes;
use app\seller\model\BlackList as BlackListModel;

class Blacklist extends Base
{
    // 分组列表
    public function index()
    {
        if(request()->isAjax()) {

            $limit = input('param.limit');
            $ip = input('param.ip');

            $listModel = new BlackListModel();
            $list = $listModel->getBlackList($limit, $ip);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        return $this->fetch();
    }

    // 删除分组
    public function delBlacklist()
    {
        if(request()->isAjax()) {

            $listId = input('param.list_id');
            $listModel = new BlackListModel();

            $res = $listModel->delBlackList($listId);
            return JsonRes::success($res['msg']);
        }
    }
}