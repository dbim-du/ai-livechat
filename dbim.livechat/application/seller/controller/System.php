<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/3/3
 * Time: 11:44 AM
 */
namespace app\seller\controller;

use app\common\utils\JsonRes;
use app\seller\model\Style;
use app\seller\model\System as SystemModel;
use app\seller\validate\SystemValidate;
use think\Lang;

class System extends Base
{
    public function index()
    {
        if(request()->isPost()) {

            $param = input('post.');

            $validate = new SystemValidate();
            if(!$validate->check($param)) {
                return JsonRes::failed($validate->getError(),-3);
            }

            isset($param['hello_status']) ? $param['hello_status']= 1 : $param['hello_status'] = 0;
            isset($param['relink_status']) ? $param['relink_status']= 1 : $param['relink_status'] = 0;
            isset($param['auto_link']) ? $param['auto_link']= 1 : $param['auto_link'] = 0;
            isset($param['robot_open']) ? $param['robot_open']= 1 : $param['robot_open'] = 0;
            isset($param['pre_input']) ? $param['pre_input']= 1 : $param['pre_input'] = 0;
            isset($param['auto_remark']) ? $param['auto_remark']= 1 : $param['auto_remark'] = 0;

            $sys = new SystemModel();
            $res = $sys->editSystem($param);
            return JsonRes::success($res['msg']);
            exit;
        }

        $system = new SystemModel();
        $data = $system->getSellerConfig()['data'];
        $this->assign([
            'system' => $data,
            'lang' => langdetect(),
        ]);

        return $this->fetch();
    }

    public function myStyle()
    {
        $styleModel = new Style();
        if (request()->isPost()) {

            $param = input('post.');
            $styleModel->editStyle($param);
            return JsonRes::success('设置成功');
        }

        $myStyle = $styleModel->getSellerStyle();
        if (empty($myStyle)) {

            $myStyle = $styleModel->initStyle();
        }

        $this->assign([
            'baseCss1' => getBaseCss(1) . 'right:' . $myStyle['box_margin'] . 'px;background:' . $myStyle['box_color'] . ';',
            'baseCss2' => getBaseCss(2) . 'bottom:' . $myStyle['box_margin'] . 'px;background:' . $myStyle['box_color'] . ';',
            'style' => $myStyle
        ]);

        return $this->fetch('style');
    }
}