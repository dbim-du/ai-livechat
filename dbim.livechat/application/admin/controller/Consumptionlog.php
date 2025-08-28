<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/28
 * Time: 8:23 PM
 */
namespace app\admin\controller;

use app\common\utils\JsonRes;
use app\admin\model\ConsumptionLogModel;

class Consumptionlog extends Base
{
    /**
     * 商家消费记录
     */
    public function index()
    {
        if(request()->isAjax()) {
            $limit = input('param.limit');
            //$xf_type = input('param.xf_type');
            // $con_project = input('param.con_project');
            $seller_name = input('param.seller_name');
            $xf_type = input('param.xf_type');
            //var_dump('$xf_type:'.$xf_type);
            //$con_project = 2;
            $consumptionlog = new ConsumptionLogModel();
            $list = $consumptionlog->getConsumptionLogList($limit, $xf_type, $seller_name);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        return $this->fetch();
    }

    









}