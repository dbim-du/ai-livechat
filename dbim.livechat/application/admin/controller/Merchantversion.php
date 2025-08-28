<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/28
 * Time: 8:23 PM
 */
namespace app\admin\controller;

use app\admin\model\MerchantVersionModel;
use app\common\utils\JsonRes;
use app\admin\validate\MerchantVersionValidate;
use app\model\OperateLog;

class Merchantversion extends Base
{
    /**
     * 商家版本列表
     */
    public function index()
    {
        if(request()->isAjax()) {

            $limit = input('param.limit');
            $character = input('param.character');

            $merchantVersion = new MerchantVersionModel();
            $list = $merchantVersion->getMerchantVersionList($limit, $character);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        return $this->fetch();
    }

    /**
     * 添加商家版本
     */
    public function addMerchantVersion()
    {
        if(request()->isPost()) {

            $param = input('post.');

            $validate = new MerchantVersionValidate();
            if(!$validate->check($param)) {
                return ['code' => -3, 'data' => '', 'msg' => $validate->getError()];
            }

            isset($param['status']) ? $param['status']= 1 : $param['status'] = -1;
            $merchantVersion = new MerchantVersionModel();
            $res = $merchantVersion->addMerchantVersion($param);
            
            // 记录操作日志
            (new OperateLog())->writeOperateLog([
                'operator' => session('admin_user_name'),
                'operator_ip' => request()->ip(),
                'operate_method' => 'MerchantVersion/addMerchantVersion',
                'operate_title' => '添加商家版本',
                'operate_desc' => '添加商家版本 ' . $param['character']
                    . ' , 开通所需消耗金币数量: ' . $param['goldcoinNum'] . ' , 权益限制： ' . $param['equity_statement']
                    . ' , 图标徽章: ' . $param['badge'] . ' , 状态： ' . $param['status'],
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
     * 编辑商家版本
     */
    public function editMerchantVersion()
    {
        $merchantVersion = new MerchantVersionModel();
        if(request()->isPost()) {

            $param = input('post.');

            $validate = new MerchantVersionValidate();
            if(!$validate->scene('edit')->check($param)) {
                return ['code' => -3, 'data' => '', 'msg' => $validate->getError()];
            }

            isset($param['status']) ? $param['status']= 1 : $param['status'] = -1;
           
            $res = $merchantVersion->editMerchantVersion($param);

            // 记录操作日志
            (new OperateLog())->writeOperateLog([
                'operator' => session('admin_user_name'),
                'operator_ip' => request()->ip(),
                'operate_method' => 'MerchantVersion/editMerchantVersion',
                'operate_title' => '编辑商家版本',
                'operate_desc' => '商家版本Id ' . $param['merchant_id'] . '编辑商家版本 ' . $param['character']
                    . ' , 开通所需消耗金币数量: ' . $param['goldcoinNum'] . ' , 权益限制： ' . $param['equity_statement']
                    . ' , 图标徽章: ' . $param['badge'] . ' , 状态： ' . $param['status'],
                'operate_time' => date('Y-m-d H:i:s')
            ]);

            if(0 != $res['code']) {
                return ['code' => -1, 'data' => '', 'msg' => $res['msg']];
            }
            return JsonRes::success($res['msg']);
        }

        $merchantId = input('param.merchant_id');

        $this->assign([
            'merchantversion' => $merchantVersion->getMerchantVersion($merchantId)['data']
        ]);

        return $this->fetch('edit');
    }

    /**
     * 删除商家版本
     * @return \think\response\Json
     */
    public function delMerchantVersion()
    {
        if(request()->isAjax()) {

            $merchantId = input('param.merchant_id');

            $merchantVersion = new MerchantVersionModel();

            // 记录操作日志
            (new OperateLog())->writeOperateLog([
                'operator' => session('admin_user_name'),
                'operator_ip' => request()->ip(),
                'operate_method' => 'MerchantVersion/delMerchantVersion',
                'operate_title' => '删除商家版本',
                'operate_desc' => '删除了商家版本： ' . $merchantVersion->getMerchantVersion($merchantId)['data']['character'],
                'operate_time' => date('Y-m-d H:i:s')
            ]);

            $res = $merchantVersion->delMerchantVersion($merchantId);

            return JsonRes::success($res['msg']);
        }
    }

    









}