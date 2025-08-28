<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/28
 * Time: 8:23 PM
 */
namespace app\admin\controller;

use app\admin\model\Admin;
use app\common\utils\JsonRes;

class Manager extends Base
{
    // 管理员列表
    public function index()
    {
        if(request()->isAjax()) {

            $limit = input('param.limit');
            $adminName = input('param.admin_name');

            $admin = new Admin();
            $list = $admin->getAdmins($limit, $adminName);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        return $this->fetch();
    }

    // 添加管理员
    public function addAdmin()
    {
        if(request()->isPost()) {

            $param = input('post.');

            $param['admin_password'] = md5($param['admin_password'] . config('service.salt'));

            $admin = new admin();
            $res = $admin->addAdmin($param);

            return JsonRes::success($res['msg']);
        }

        return $this->fetch('add');
    }

    // 编辑管理员
    public function editAdmin()
    {
        if(request()->isPost()) {

            $param = input('post.');

            if(isset($param['admin_password']) && !empty($param['admin_password'])) {
                $param['admin_password'] = md5($param['admin_password'] . config('service.salt'));
            } else {
                unset($param['admin_password']);
            }

            $admin = new admin();
            $res = $admin->editAdmin($param);

            return JsonRes::success($res['msg']);
        }

        $adminId = input('param.admin_id');
        $admin = new admin();

        $this->assign([
            'admin' => $admin->getAdminById($adminId)['data']
        ]);

        return $this->fetch('edit');
    }

    /**
     * 删除管理员
     * @return \think\response\Json
     */
    public function delAdmin()
    {
        if(request()->isAjax()) {

            $adminId = input('param.id');

            $admin = new admin();
            $res = $admin->delAdmin($adminId);

            return JsonRes::success($res['msg']);
        }
    }
}