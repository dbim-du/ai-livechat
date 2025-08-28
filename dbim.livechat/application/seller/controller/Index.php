<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Date: 2019/3/1
 * Time: 10:04
 */
namespace app\seller\controller;

use app\common\utils\JsonRes;
use app\common\outapi\dbim\DBIMAccount;
use app\model\Queue;
use app\model\Seller;
use app\admin\model\Seller as SellerModel;
use app\seller\model\Msg;
use app\seller\model\ServiceLog;
use app\seller\model\KeFu as KeFuModel;
use app\admin\model\BuypackageModel;
use app\admin\model\ConsumptionLogModel;
use app\admin\model\MerchantVersionModel;
use app\admin\model\sysconfigModel;

class Index extends Base
{
    public function index()
    {
        // 系统配置
        $list = (new sysconfigModel())->getSysConfigList();
        $_SESSION['sysconfigList'] = $list['data'];

        // 获取未读留言消息
        $noRead = (new Msg())->getNoReadMsgCount()['data'];

        $this->assign([
            'no_read' => $noRead,
            'sysconfigList' => $list['data'],
            //'sysconfigList01' => $_SESSION['sysconfigList']  其他页面 可以直接这样在 session 中取
        ]);

        return $this->fetch();
    }

    public function home()
    {
        // 累计接待量
        $log = new ServiceLog();
        $totalNum = $log->getTotalServiceNum()['data'];

        // 今日接待量
        $todayNum = $log->getTodayServiceNum()['data'];

        // 在线客服
        $keFu = new KeFuModel();
        $onlineKeFu = $keFu->getOnlineKeFu()['data'];

        // 今日在线访客数
        $customer = new Queue();
        $onlineCustomerNum = $customer->getOnlineCustomer(session('seller_code'))['data'];

        // 商户信息
        $seller = new Seller();
        $sellerInfo = $seller->getSellerInfo(session('seller_code'))['data'];

        // 15天接待统计
        $days15 = [];
        for ($i = 15; $i > 0; $i--) {
            $days15[] = date('Y-m-d', strtotime('-' . $i . ' days'));
        }

        $start = $days15[0];
        $end = $days15[14] . ' 23:59:59';

        $fifteenNum = $this->census($start, $end, $days15);

        $this->assign([
            'total_num' => number_format($totalNum),
            'today_num' => number_format($todayNum),
            'online_kefu' => number_format(count($onlineKeFu)),
            'kefu' => $onlineKeFu,
            'customer_num' => $onlineCustomerNum,
            'fifteenDays' => json_encode($days15),
            'fifteenNum' => json_encode(array_values($fifteenNum)),
            'seller' => $sellerInfo,
            'sysconfigList' => $_SESSION['sysconfigList']  // 其他页面 可以直接这样在 session 中取
        ]);

        return $this->fetch();
    }

    /**
     * 升级商业版
     */
    public function shengji()
    {
        $merchantVersion = new MerchantVersionModel();
        $versionModel = $merchantVersion->getMerchantVersion(2);

        $goldcoinNum = $versionModel['data']["goldcoinNum"];// 扣除金币
        $tokensNum = $versionModel['data']["tokensNum"];// 获得Tokens

        if (request()->isPost()) {
            // 1、修改商家表 商家版本ID
            // 2、向资金消费记录表 添加消费数据：（1、扣除金币，2、获得升级赠送Tokens）


            // 1、修改商家表 商家版本ID
            $seller = new Seller();
            $sellerInfo = $seller->getSellerInfo(session('seller_code'));

            // 判断余额是否充足
            if ($sellerInfo['data']['goldcoinNum']<$goldcoinNum) {
                return ['code' => -1, 'data' => '', 'msg' => '当前金币余额不足'];
            }

            // 扣除金币、获得Tokens、修改商家版本ID
            $sellerInfo['data']['goldcoinNum'] = $sellerInfo['data']['goldcoinNum'] - $goldcoinNum;
            $sellerInfo['data']['tokensNum'] = $sellerInfo['data']['tokensNum'] + $tokensNum;
            $sellerInfo['data']['merchantversion_Id'] = 2;
            $seller = new SellerModel();
            $res = $seller->editSeller($sellerInfo['data']);
            if ($res['code']!=0) {
                return $res;
            }


            // 2、向资金消费记录表 添加消费数据：（1、扣除金币，2、获得升级赠送Tokens）
            $clmodel = new ConsumptionLogModel();
            $seller_user_id = session('seller_user_id');
            $order_code = $clmodel->CreateOrderNumber('SJ',$seller_user_id);

            $pudt=date('Y-m-d H:i:s');
            // 扣除金币 消费记录
            (new ConsumptionLogModel())->addConsumptionLog([
                'order_code' => $order_code,
                'type' => 1,
                'con_project' =>"升级商业版：扣除金币",
                'seller_id' => $seller_user_id,
                'consumption_num' => -$goldcoinNum,
                'create_time' => $pudt,
                'update_time' => $pudt
            ]);
            // 增加Tokens 消费记录
            (new ConsumptionLogModel())->addConsumptionLog([
                'order_code' => $order_code,
                'type' => 2,
                'con_project' =>"升级商业版：增加Tokens",
                'seller_id' => $seller_user_id,
                'consumption_num' => $tokensNum,
                'create_time' => $pudt,
                'update_time' => $pudt
            ]);


            session('merchantversion_Id', 2);

            return json(['code' => 0, 'data' => '', 'msg' => '升级成功']);


        }


        $this->assign([
            'goldcoinNum' => number_format($goldcoinNum),
            'tokensNum' => number_format($tokensNum),
        ]);

        return $this->fetch();
    }

    /**
     * 购买Tokens
     */
    public function buytokens()
    {
        $buypackage = new BuypackageModel();
        $buypackageList = $buypackage->getAllBuyPackge()['data'];

        if (request()->isPost()) {

            $package_id = input('param.package_id');

            // 1、根据商家ID 查询商家信息
            // 2、判断商家 金币余额是否满足 购买条件
            // 3、扣除用户金币，添加用户Tokens
            // 4、向资金消费记录表 添加一条数据


            // 1、根据商家ID 查询商家信息
            $seller = new Seller();
            $sellerInfo = $seller->getSellerInfo(session('seller_code'));

             // 2、判断商家 金币余额是否满足 购买条件
            $packageModel = null;
            foreach ($buypackageList as $buypackage) {
                if ($buypackage['package_id'] == $package_id) {
                    $packageModel = $buypackage;
                }
            }
            if ($sellerInfo['data']['goldcoinNum']<$packageModel['goldcoinNum']) {
                return ['code' => -1, 'data' => '', 'msg' => '当前金币余额不足'];
            }

            // 3、扣除用户金币，添加用户Tokens.
            // 扣除金币
            $sellerInfo['data']['goldcoinNum'] = $sellerInfo['data']['goldcoinNum'] - $packageModel['goldcoinNum'];
            // 添加Tokens
            $sellerInfo['data']['tokensNum'] = $sellerInfo['data']['tokensNum'] + $packageModel['tokensNum'];

            $seller = new SellerModel();
            $res = $seller->editSeller($sellerInfo['data']);

            if ($res['code']!=0) {
                return $res;
            }

            // 4、向资金消费记录表 添加一条数据

            $clmodel = new ConsumptionLogModel();
            $seller_user_id = session('seller_user_id');
            $order_code = $clmodel->CreateOrderNumber('GMTC',$seller_user_id);

            $pudt=date('Y-m-d H:i:s');
            // 扣除金币 消费记录
            (new ConsumptionLogModel())->addConsumptionLog([
                'order_code' => $order_code,
                'type' => 1,
                'con_project' =>"购买Tokens套餐：".$packageModel['package_name'].'扣除金币',
                'seller_id' => $seller_user_id,
                'consumption_num' => -$packageModel['goldcoinNum'],
                'create_time' => $pudt,
                'update_time' => $pudt
            ]);
            // 增加Tokens 消费记录
            (new ConsumptionLogModel())->addConsumptionLog([
                'order_code' => $order_code,
                'type' => 2,
                'con_project' =>"购买Tokens套餐：".$packageModel['package_name'].'增加Tokens',
                'seller_id' => $seller_user_id,
                'consumption_num' => $packageModel['tokensNum'],
                'create_time' => $pudt,
                'update_time' => $pudt
            ]);


            return json(['code' => 0, 'data' => '', 'msg' => '购买成功']);
        }





        

        $this->assign([
            'buypackage' => $buypackageList
        ]);

        return $this->fetch();
    }

    // 如何接入
    public function howToUse()
    {
        $kefuModel = new \app\seller\model\KeFu();
//        $kefuList = $kefuModel->getSellerKeFu()['data'];
        $kefuList = $kefuModel->getSellerKeFuNew(session('seller_user_id'));

        $this->assign([
            'loginDify_PassWord' => ENVCONST['loginDify_PassWord'],
            'sysconfigList' => (new sysconfigModel())->getSysConfigList()['data'],
            'domain' => config('service_socketio.domain'),
            'seller_code' => session('seller_code'),
            'kefu' => $kefuList
        ]);

        return $this->fetch('doc');
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
            $seller = new Seller();
            $sellerInfo = $seller->getSellerInfo(session('seller_code'));

            if(0 != $sellerInfo['code'] || empty($sellerInfo['data'])){
                return json(['code' => -2, 'data' => '', 'msg' => '商户不存在']);
            }

            if(md5($param['password'] . config('service.salt')) != $sellerInfo['data']['seller_password']){
                return json(['code' => -3, 'data' => '', 'msg' => '旧密码错误']);
            }

            try {

                db('seller')->where('seller_id', session('seller_user_id'))->setField('seller_password',
                    md5($param['new_password'] . config('service.salt')));
            } catch (\Exception $e) {
                return json(['code' => -4, 'data' => '', 'msg' => $e->getMessage()]);
            }

            return json(['code' => 0, 'data' => '', 'msg' => '修改密码成功']);
        }

        return $this->fetch('pwd');
    }

    private function census($start, $end, $days)
    {
        $sql = "SELECT DATE_FORMAT(start_time, '%Y-%m-%d') as create_time2,count(service_log_id) as s_num from v2_customer_service_log WHERE start_time > '"
            . $start . "' and start_time < '" . $end . "' and seller_code = '" . session('seller_code') . "' GROUP BY create_time2;";

        $all = db('v2_customer_service_log')->query($sql);

        $num = [];
        foreach ($days as $vo) {
            $num[$vo] = 0;
        }

        foreach ($all as $key => $vo) {
            if (isset($num[$vo['create_time2']])) {
                $num[$vo['create_time2']] = $vo['s_num'];
            }
        }

        return $num;
    }
}