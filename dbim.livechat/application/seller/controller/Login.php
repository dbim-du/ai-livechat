<?php
namespace app\seller\controller;

use app\common\outapi\dbim\DBIMAccount;
use app\common\outapi\dbim\DBIMEntrance;
use app\common\utils\JsonRes;
use app\model\KeFu;
use app\model\Seller;
use think\Controller;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;
use think\response\Json;

class Login extends Controller
{
    public function index()
    {
        $this->assign([
            'seller' => input('param.u'),
            'version' => config('version.version')
        ]);
		
		if(request()->isMobile()){
			return $this->fetch('mobile');
        }

        return $this->fetch();
    }

    public function doLogin()
    {
        if(request()->isAjax()){
            $email = input('post.email','');
            $password = input('post.password','');
            $captcha = input("post.captcha");
            if($password == '' || $email == ''){
                return JsonRes::failed('用户/密码不能为空',-3);
            }
            // if(!captcha_check($captcha)){
            //     return JsonRes::failed('验证码错误',-3);
            // }

            
            $dbimEntrance = new DBIMEntrance();
            $loginRes = $dbimEntrance->LoginEmail($email,$password);
            if ($loginRes['code'] != 0) {
                return JsonRes::failed($loginRes['msg'],-3);
            }
            $token = $loginRes['data']['token'];
            
            session('dbim_token', $token);

            $dbimAcc = new DBIMAccount();
            $dashRes =$dbimAcc->DashboardInfoGet();
            if ($dashRes['code'] != 0) {
                return JsonRes::failed($dashRes['msg'],-3);
            }
            
            $seller = new Seller();
            $sellerInfo = $seller->getSellerInfoByDBIMId($dashRes);
            
            if (date("Y-m-d H:i:s") > $sellerInfo['valid_time']) {
                return JsonRes::failed('商户使用期已过',-5);
            }

            // 设置session标识状态
            session('seller_user_name', $sellerInfo['seller_name']);
            session('seller_user_id', $sellerInfo['seller_id']);
            session('seller_dbim_id', $sellerInfo['dbim_meb_id']);
            session('seller_code', $sellerInfo['seller_code']);
            session('merchantversion_Id', $sellerInfo['merchantversion_Id']);
            session('token', $token);
            return JsonRes::success('登录成功',url('index/index'));
        }
        $this->error('非法访问');
    }

    // 商户注册
    public function reg()
    {
        // var_dump(123123);
        // if(session('seller_user_name')){
        //     $this->redirect(url('/seller/index'));
        // }

        if(!config('service.reg_flag')) {
            $this->error('禁止商户注册');
        }

        if(request()->isPost()) {
            $param = input('post.');
            $seller = new Seller();
           return $seller->dbimRegister($param);
        }

        return $this->fetch();
    }

    /**
     * 发送短信验证码
     * @return void
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function sms(){
        $param = input('post.');
        $phone = $param['phone'];
        $captcha = $param['captcha'];
        $act = $param['act'];

        $act_legal = array(
            'reg' => '注册新用户',
            'find' => '找回密码',
            'modify' => '修改手机号',
            'deal_apply'=>'提现',
            'deal_set'=>'设置提现账号',
            'bind'=>"绑定",
        );

        $re['status'] = 0;

//非法请求
        if(!in_array($act,array_keys($act_legal))){
            $re['msg'] = '非法请求';
        }
        else{
            if($act=='reg' || $act=='find'){
                $phone =  sfilter($phone);
            }
            //不是注册和找回密码时，自动提取手机号
            else{
                $phone = Db("seller")->where('phone', $phone)->find();
            }
            //图片验证码
//            if(!captcha_check($captcha)){
//                $re['msg'] = '请先输入正确的图片验证码';
//            }
            if(!is_mobile($phone)){
                $re['msg'] = '请输入正确的手机号';
            }
            //1个手机号60秒内只能发送一次
//   else if($_SESSION['sms'][$act]['phone']==$phone && Common::gmtime() - $_SESSION['sms'][$act]['send_time'] < 60){
//      $re['msg'] = '1个手机号1分钟内只能发送1次验证码';
//   }
            else{
                $now = time();
                $sms_captcha = get_rand_number();
                //云通讯发送短信
                $_SESSION['sms'][$act]['send_time'] = $now;
                $_SESSION['sms'][$act]['phone'] = $phone;
                $_SESSION['sms'][$act]['captcha'] = encrypt($sms_captcha);
                $re['status'] = 1;
                $codeType=$act;
                switch($codeType){
                    case 'reg':$codeType=1;
                        break;
                    case 'login':$codeType=2;
                        break;
                    case 'find':$codeType=3;
                        break;
                }
                $reg_data=[
                    'phoneNo'=>$phone,
                    'codeType'=>$codeType,
                ];

                $return = curlPost(ENVCONST['SERVER_URL']['SendVal'],$reg_data);
                $re = json_decode($return,true);
                if($re['code']=='0'){
                    $_SESSION['sms'][$act]['send_time'] = $now;
                    $_SESSION['sms'][$act]['phone'] = $phone;
                    $_SESSION['sms'][$act]['captcha'] = encrypt($sms_captcha);
                    $re['status'] = 1;
                }else{
                    $re['status'] = 0;
                }
            }
        }
        echo json_encode($re);
        exit;
    }

    /**
     * 发送邮箱验证码
     * @return void
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     * @throws DbException
     */
    public function sendEmail(){
        $param = input('post.');
        $email = $param['register_email'];
        $act = $param['act'];

        if(!is_email($param['register_email'])) {
            return JsonRes::failed('邮箱错误',-1);
        }

        $reg_data = [
            'email' => $email,
            'codeType' => 1
        ];

        $return = json_decode(curlPost(ENVCONST['SERVER_URL'][$act], $reg_data), true);
        //$return['code'] = 0;
        if ($return['code'] == 0) {
            return JsonRes::success('发送成功');
        } else {
            return JsonRes::failed($return['msg'],-1);
            //return JsonRes::failed('注册失败',-1);
        }
    }

    public function loginOut()
    {
        session('seller_user_name', null);
        session('seller_user_id', null);
        session('seller_code', null);

        $this->redirect(url('login/index'));
    }

    public function loginError()
    {
        return $this->fetch('error');
    }
}