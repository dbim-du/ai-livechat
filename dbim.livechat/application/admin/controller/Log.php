<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/9/29
 * Time: 11:29 PM
 */
namespace app\admin\controller;

use app\common\utils\JsonRes;
use app\model\LoginLog;
use app\model\OperateLog;

class Log extends Base
{
    // 登录日志明细
    public function login()
    {
        if(request()->isAjax()) {

            $limit = input('param.limit');

            $log = new LoginLog();
            $list = $log->loginLogList($limit);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        return $this->fetch();
    }

    // 操作日志明细
    public function operate()
    {
        if(request()->isAjax()) {

            $limit = input('param.limit');

            $log = new OperateLog();
            $list = $log->operateLogList($limit);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        return $this->fetch();
    }
}

