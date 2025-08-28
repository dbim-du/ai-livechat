<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/28
 * Time: 8:23 PM
 */
namespace app\admin\controller;

use app\admin\model\KeFu;
use app\admin\model\Seller as SellerModel;
use app\admin\model\System;
use app\admin\validate\SellerValidate;
use app\common\utils\JsonRes;
use app\model\OperateLog;
use app\admin\model\MerchantVersionModel;

class Seller extends Base
{
    // 商户列表
    public function index()
    {
        if(request()->isAjax()) {

            $limit = input('param.limit');
            $sellerName = input('param.seller_name');
            $sellerStatus = input('param.seller_status');

            $where = [];
            if (!empty($sellerName)) {
                $where[] = ['seller_name', '=', $sellerName];
            }

            if ('' != $sellerStatus) {
                $where[] = ['seller_status', '=', $sellerStatus];
            }

            $seller = new SellerModel();
            $list = $seller->getSellers($limit, $where);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        $mvmodel = new MerchantVersionModel();
        //$getAllMerchantVersion_Data = $mvmodel->getAllMerchantVersion()['data'];
        //var_dump($getAllMerchantVersion_Data);
        $this->assign([
            'mvmodel' => $mvmodel->getAllMerchantVersion()['data'],
        ]);

        return $this->fetch();
    }

    // 添加商户 MerchantVersionModel
    public function addSeller()
    {
        if(request()->isPost()) {

            $param = input('post.');

            $validate = new SellerValidate();
            if(!$validate->check($param)) {
                return ['code' => -3, 'data' => '', 'msg' => $validate->getError()];
            }

            isset($param['seller_status']) ? $param['seller_status']= 1 : $param['seller_status'] = 0;
            $param['seller_code'] = uniqid();
            $param['seller_password'] = md5($param['seller_password'] . config('service.salt'));

            $seller = new SellerModel();
            $res = $seller->addSeller($param);

            if(0 == $res['code']) {

                $system = new System();
                $system->initSellerConfig([
                    'hello_word' => config('service.hello_word'),
                    'seller_id' => $res['data'],
                    'seller_code' => $param['seller_code'],
                    'hello_status' => 1,
                    'relink_status' => 1,
                    'auto_link' => 0,
                    'auto_link_time' => 30
                ]);
            }

            // 记录操作日志
            (new OperateLog())->writeOperateLog([
                'operator' => session('admin_user_name'),
                'operator_ip' => request()->ip(),
                'operate_method' => 'seller/addSeller',
                'operate_title' => '添加商户',
                'operate_desc' => '添加商户： ' . $param['seller_name']
                    . ' , 商户id： ' . $param['seller_code'] . ' , 商户默认状态为： ' . $param['seller_status'],
                'operate_time' => date('Y-m-d H:i:s')
            ]);

            return JsonRes::success($res['msg']);
        }

        $mvmodel = new MerchantVersionModel();
        $this->assign([
            'mvmodel' => $mvmodel->getAllMerchantVersion()['data'],
        ]);

        return $this->fetch('add');
    }

    // 编辑商户
    public function editSeller()
    {
        if(request()->isPost()) {

            $param = input('post.');

            $validate = new SellerValidate();
            if(!$validate->scene('edit')->check($param)) {
                return ['code' => -3, 'data' => '', 'msg' => $validate->getError()];
            }

            isset($param['seller_status']) ? $param['seller_status']= 1 : $param['seller_status'] = 0;
            $editPwd = '';
            if(isset($param['seller_password']) && !empty($param['seller_password'])) {
                $editPwd = '修改了密码';
                $param['seller_password'] = md5($param['seller_password'] . config('service.salt'));
            } else {
                unset($param['seller_password']);
            }

            $seller = new SellerModel();
            $res = $seller->editSeller($param);

            // 记录操作日志
            (new OperateLog())->writeOperateLog([
                'operator' => session('admin_user_name'),
                'operator_ip' => request()->ip(),
                'operate_method' => 'seller/editSeller',
                'operate_title' => '编辑商户',
                'operate_desc' => '编辑商户： ' . $param['seller_name']
                    . ' , 商户状态改为： ' . $param['seller_status'] . ' , ' . $editPwd,
                'operate_time' => date('Y-m-d H:i:s')
            ]);

            return JsonRes::success($res['msg']);
        }

        $sellerId = input('param.seller_id');
        $seller = new SellerModel();
        $mvmodel = new MerchantVersionModel();

        $this->assign([
            'seller' => $seller->getSellerById($sellerId)['data'],
            'mvmodel' => $mvmodel->getAllMerchantVersion()['data'],
        ]);

        return $this->fetch('edit');
    }

    /**
     * 删除商户
     * @return \think\response\Json
     */
    public function delSeller()
    {
        if(request()->isAjax()) {

            $sellerId = input('param.id');

            $seller = new SellerModel();

            // 记录操作日志
            (new OperateLog())->writeOperateLog([
                'operator' => session('admin_user_name'),
                'operator_ip' => request()->ip(),
                'operate_method' => 'seller/delSeller',
                'operate_title' => '删除商户',
                'operate_desc' => '删除了商户： ' . $seller->getSellerById($sellerId)['data']['seller_name'],
                'operate_time' => date('Y-m-d H:i:s')
            ]);

            $res = $seller->delSeller($sellerId);

            return JsonRes::success($res['msg']);
        }
    }

    /**
     * 客服列表
     * @return mixed|\think\response\Json
     */
    public function showKeFuList()
    {
        $sellerId = input('param.seller_id');

        if (request()->isAjax()) {

            $limit = input('param.limit');
            $sellerId = input('param.seller_id');

            $where = [];
            if(!empty($sellerId)) {
                $where[] = ['a.seller_id', '=', $sellerId];
            }

            $keFu = new KeFu();
            $list = $keFu->getKeFuList($limit, $where);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        $this->assign([
            'seller_id' => $sellerId
        ]);

        return $this->fetch('kefu');
    }
}