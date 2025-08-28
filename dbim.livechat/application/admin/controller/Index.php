<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/17
 * Time: 11:33 AM
 */
namespace app\admin\controller;

use app\admin\model\Admin;
use app\common\utils\JsonRes;
use think\App;
use app\admin\model\sysconfigModel;

class Index extends Base
{
    public function index()
    {   
        // var_dump(123123);
        $config = new sysconfigModel();
        $list = $config->getSysConfigList();
        // var_dump($list);
        $this->assign([
            'sysconfigList' => $list['data']
        ]);
        return $this->fetch();
    }

    public function home()
    {
        // 注册商户数
        $sellerNum = db('seller')->count();
        // 客服总数
        $KeFuNum = db('kefu')->count();
        // 累计服务人数
        $serviceNum = db('customer_service_log')->count();
        // 正在服务人数
        $nowServiceNum = db('now_service')->count();

        $this->assign([
            'seller_num' => $sellerNum,
            'kefu_num' => $KeFuNum,
            'service_num' => $serviceNum,
            'now_service_num' => $nowServiceNum,
            'tp_version' => App::VERSION
        ]);

        return $this->fetch();
    }

    public function sysconfig()
    {
        if (request()->isAjax()) {
            $limit = input('param.limit');
            $config = new sysconfigModel();
            $list = $config->getSysConfig($limit);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);

        }

        return $this->fetch();
    }

    // 修改密码
    public function editPwd()
    {
        if (request()->isPost()) {
            $param = input('post.');

            if ($param['new_password'] != $param['rep_password']) {
                return JsonRes::failed('两次密码输入不一致',-1);
            }

            // 检测旧密码
            $admin = new Admin();
            $sellerInfo = $admin->getAdminInfo(session('admin_user_id'));

            if(0 != $sellerInfo['code'] || empty($sellerInfo['data'])){
                return JsonRes::failed('管理员不存在',-2);
            }

            if(md5($param['password'] . config('service.salt')) != $sellerInfo['data']['admin_password']){
                return JsonRes::failed('旧密码错误',-3);
            }

            try {

                db('admin')->where('admin_id', session('admin_user_id'))->setField('admin_password',
                    md5($param['new_password'] . config('service.salt')));
            } catch (\Exception $e) {
                return JsonRes::failed($e->getMessage(),-4,0);
            }
            return JsonRes::success('修改密码成功');
        }

        return $this->fetch('pwd');
    }
}