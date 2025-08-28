<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/28
 * Time: 8:23 PM
 */
namespace app\admin\controller;

use app\admin\model\BuypackageModel;
use app\common\utils\JsonRes;
use app\admin\validate\BuypackageValidate;
use app\model\OperateLog;

class Buypackage extends Base
{
    /**
     * 购买套餐列表
     */
    public function index()
    {
        if(request()->isAjax()) {

            $limit = input('param.limit');
            $packageName = input('param.packageName');

            $buypackage = new BuypackageModel();
            $list = $buypackage->getBuyPackgeList($limit, $packageName);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        return $this->fetch();
    }

    /**
     * 添加套餐
     */
    public function addBuypackage()
    {
        if(request()->isPost()) {

            $param = input('post.');

            $validate = new BuypackageValidate();
            if(!$validate->check($param)) {
                return ['code' => -3, 'data' => '', 'msg' => $validate->getError()];
            }

            isset($param['status']) ? $param['status']= 1 : $param['status'] = -1;
            $buypackage = new BuypackageModel();
            $res = $buypackage->addBuyPackge($param);
            
            // 记录操作日志
            (new OperateLog())->writeOperateLog([
                'operator' => session('admin_user_name'),
                'operator_ip' => request()->ip(),
                'operate_method' => 'Buypackage/addBuypackage',
                'operate_title' => '添加套餐',
                'operate_desc' => '添加套餐 ' . $param['package_name']
                    . ' , 规格 ' . $param['specification'] . ' , 消耗金币数量： ' . $param['goldcoinNum']
                    . ' , 获得Tokens数量 ' . $param['tokensNum']. ' , 套餐说明： ' . $param['description']
                    . ' , 状态： ' . $param['status'],
                'operate_time' => date('Y-m-d H:i:s')
            ]);

            if(0 != $res['code']) {
                return ['code' => -1, 'data' => '', 'msg' => $res['msg']];
            }
            return JsonRes::success($res['msg']);
        }

        return $this->fetch('add');
    }

    /**
     * 编辑购买套餐
     */
    public function editBuypackage()
    {
        $buypackage = new BuypackageModel();
        if(request()->isPost()) {

            $param = input('post.');

            $validate = new BuypackageValidate();
            if(!$validate->scene('edit')->check($param)) {
                return ['code' => -3, 'data' => '', 'msg' => $validate->getError()];
            }

            isset($param['status']) ? $param['status']= 1 : $param['status'] = -1;
           
            $res = $buypackage->editBuyPackge($param);

            // 记录操作日志
            (new OperateLog())->writeOperateLog([
                'operator' => session('admin_user_name'),
                'operator_ip' => request()->ip(),
                'operate_method' => 'Buypackage/editBuypackage',
                'operate_title' => '编辑套餐',
                'operate_desc' => '套餐Id: ' . $param['package_id']. '编辑套餐 ' . $param['package_name']
                    . ' , 规格 ' . $param['specification'] . ' , 消耗金币数量： ' . $param['goldcoinNum']
                    . ' , 获得Tokens数量 ' . $param['tokensNum']. ' , 套餐说明： ' . $param['description']
                    . ' , 状态： ' . $param['status'],
                'operate_time' => date('Y-m-d H:i:s')
            ]);

            if(0 != $res['code']) {
                return ['code' => -1, 'data' => '', 'msg' => $res['msg']];
            }
            return JsonRes::success($res['msg']);
        }

        $packageId = input('param.package_id');

        $this->assign([
            'buypackage' => $buypackage->getBuyPackge($packageId)['data']
        ]);

        return $this->fetch('edit');
    }

    /**
     * 删除套餐
     * @return \think\response\Json
     */
    public function delBuypackage()
    {
        if(request()->isAjax()) {

            $packageId = input('param.package_id');

            $buypackage = new BuypackageModel();

            // 记录操作日志
            (new OperateLog())->writeOperateLog([
                'operator' => session('admin_user_name'),
                'operator_ip' => request()->ip(),
                'operate_method' => 'Buypackage/delBuypackage',
                'operate_title' => '删除套餐',
                'operate_desc' => '删除了套餐： ' . $buypackage->getBuyPackge($packageId)['data']['package_name'],
                'operate_time' => date('Y-m-d H:i:s')
            ]);

            $res = $buypackage->delBuyPackge($packageId);

            return JsonRes::success($res['msg']);
        }
    }












}