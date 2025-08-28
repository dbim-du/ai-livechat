<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/16
 * Time: 11:26 PM
 */
namespace app\model;


use app\common\outapi\dbim\DBIMAccount;
use app\common\outapi\dbim\DBIMEntrance;
use app\common\utils\JsonRes;
use think\facade\Log;
use think\Model;

class Seller extends Model
{
    protected $table = 'v2_seller';

    /**
     * 根据商户的标识获取商户信息
     * @param $sellerCode
     * @return array
     */
    public function getSellerInfo($sellerCode)
    {
        try {

            $res = $this->where('seller_code', $sellerCode)->findOrEmpty()->toArray();
        } catch (\Exception $e) {

            Log::error($e->getMessage());
            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }

    /**
     * 根据商户名称 获取商户信息
     * @param $name
     * @return array
     */
    public function getSellerInfoByDBIMId($dashRes)
    {
        $mebInfo = $dashRes['data']['mebInfo'];
        $res = $this->where('dbim_meb_id', $mebInfo['memberId'])->find();
        if($res == null){
            $param = [
                'dbim_meb_id' => $mebInfo['memberId'],
                'seller_code' => uniqid(),
                'seller_name' => $mebInfo['nickName'],
                'seller_email' => $mebInfo['email'],
                'seller_password' => '',
                'seller_avatar' =>  $mebInfo['headImage'],
                'seller_status' => 1,
                'access_url' => '',
                'valid_time' => date('Y-m-d H:i:s', strtotime("+" . config('seller.default_reg_day') . " days")),
                'max_kefu_num' => config('seller.default_max_kefu_num'),
                'max_group_num' => config('seller.default_max_group_num'),
                'create_index_flag' => 1,
                'create_time' => date('Y-m-d H:i:s'),
                'update_time' => date('Y-m-d H:i:s'),
                'merchantversion_Id'=>1
            ];
            
            $sellerId = db('seller')->insertGetId($param);
            $param['seller_id'] =$sellerId;
            $system = [
                'hello_word' => config('service.hello_word'),
                'seller_id' => $sellerId,
                'seller_code' => $param['seller_code'],
                'hello_status' => 1,
                'relink_status' => 1,
                'auto_link' => 0,
                'auto_link_time' => 30
            ];
            db('system')->insert($system);
            return $param;
        }
        return $res;
    }

    /**
     * 根据商户名称 获取商户信息
     * @param $name
     * @return array
     */
    public function getSellerInfoByEmail($email)
    {
        try {
            $res = $this->where('email', $email)->findOrEmpty()->toArray();
        } catch (\Exception $e) {

            Log::error($e->getMessage());
            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $res, 'msg' => 'ok'];
    }

    /**
     * 调用DBIM登录接口
     * @param $email
     * @param $password
     * @return mixed
     */
    public function dbimLogin($email, $password){
        $login_data = [
            'email' => $email,
            'loginPwd' => MD5($password)
        ];
        $return = getServer('LogIn', $login_data);
        return $return;
    }

    public function dbimRegister($param){
        // if(!captcha_check($param['vercode'])) {
        //     return JsonRes::failed('验证码错误',-1);
        // }
        if(!is_email($param['register_email'])) {
            return JsonRes::failed('邮箱错误',-1);
        }

        if(empty($param['register_email']) || empty($param['register_password'])
            || empty($param['register_sms_captcha']) || empty($param['register_name'])) {

            return JsonRes::failed('必填项必须填写',-2);
        }

        $inputPWD = $param['register_password'];
        $password=MD5($inputPWD);

        $sms_captcha = $param['register_sms_captcha'];
        // $reg_data = [
        //     'phoneNo' => $param['phone'],
        //     'email' => $param['register_email'],
        //     'valCode' => $sms_captcha,
        //     'loginPwd' => $param['register_password'],
        //     'nickName' => $param['register_email']
        // ];

        $reg_data = [
            'email' => $param['register_email'],
            'nickName' => $param['register_email'],
            'loginPwd' => $password,
            'valCode' => $sms_captcha
        ];

        $return = json_decode(curlPost(ENVCONST['SERVER_URL']['Reg'], $reg_data), true);
        if ($return['code'] == 0) {
            //return JsonRes::success($return['msg']);

            // 获取用户 DBIM_ID 
            $token = $return['data']['token'];
            session('dbim_token', $token);
            $dbimAcc = new DBIMAccount();
            $dashRes =$dbimAcc->DashboardInfoGet();
            if ($dashRes['code'] != 0) {
                return JsonRes::failed($dashRes['msg'],-3);
            }
            
            $dbim_meb_id = $dashRes['data']['mebInfo']['memberId'];

            $param = [
                'dbim_meb_id' => $dbim_meb_id,
                'seller_code' => uniqid(),
                'seller_name' => $param['register_name'],
                'seller_email' => $param['register_email'],
                //'phone' => '',//$param['phone'],
                'seller_password' => md5($password . config('service.salt')),
                'seller_avatar' => '',
                'seller_status' => 1,
                'access_url' => '',
                'valid_time' => date('Y-m-d H:i:s',
                    strtotime("+" . config('seller.default_reg_day') . " days")),
                'max_kefu_num' => config('seller.default_max_kefu_num'),
                'max_group_num' => config('seller.default_max_group_num'),
                'create_time' => date('Y-m-d H:i:s'),
                'update_time' => date('Y-m-d H:i:s')
            ];

            try {

                //$has = db('seller')->where('phone',$param['phone'])->find();
                $has = db('seller')->where('seller_email',$param['register_email'])->find();
                if (empty($has)) {
                    return JsonRes::failed('该商户已经存在',-5);
                }

                /*$has = db('seller')->where('access_url', $param['access_url'])->find();
                if(!empty($has)) {
                    return JsonRes::failed('该域名已经注册了',-6);
                }*/

                $sellerId = db('seller')->insertGetId($param);

                db('system')->insert([
                    'hello_word' => config('service.hello_word'),
                    'seller_id' => $sellerId,
                    'seller_code' => $param['seller_code'],
                    'hello_status' => 1,
                    'relink_status' => 1,
                    'auto_link' => 0,
                    'auto_link_time' => 30
                ]);
            } catch (\Exception $e) {
                return JsonRes::failed('注册失败：'+$e,-5,0,$e->getMessage());
            }

            $seller = new Seller();
            // 登录
            $seller->dbimRegister_Login($reg_data['email'],$inputPWD,$dashRes);

            
            return JsonRes::success('注册成功！',url('index/index'));
        } else {

            return JsonRes::failed($return['msg'],-1);

        }
    }

    /**
     * 注册后 登录
     */
    public function dbimRegister_Login($email,$password,$dashRes){
        $dbimEntrance = new DBIMEntrance();
            $loginRes = $dbimEntrance->LoginEmail($email,$password);
            if ($loginRes['code'] != 0) {
                return JsonRes::failed($loginRes['msg'],-3);
            }
            $token = $loginRes['data']['token'];

            session('dbim_token', $token);

            $seller = new Seller();
            $sellerInfo = $seller->getSellerInfoByDBIMId($dashRes);

            // 设置session标识状态
            session('seller_user_name', $sellerInfo['seller_name']);
            session('seller_user_id', $sellerInfo['seller_id']);
            session('seller_dbim_id', $sellerInfo['dbim_meb_id']);
            session('seller_code', $sellerInfo['seller_code']);
            session('token', $token);

        
    }

    public function dbimLoginInfo($token){

        $return = getServer(ENVCONST['SERVER_URL']['LogIn'], $login_data);
        return $return;
    }


    /**
     * 检测商户是否可以再建分组
     * @param $sellerId
     * @return array
     */
    public function checkCanAddGroup($sellerId)
    {
        $flag = 0; // 不可建
        try {

            $maxGroupNum = $this->field('max_group_num')->where('seller_id', $sellerId)->find();

            // 目前的已经建的分组数
            $nowGroupNumData = (new Group())->getSellerGroupNum($sellerId);
            if (0 != $nowGroupNumData['code']) {
                return $nowGroupNumData;
            }

            if ($maxGroupNum['max_group_num'] > $nowGroupNumData['data']) {
                $flag = 1;
            }
        } catch (\Exception $e) {
            Log::error($e->getMessage());

            return ['code' => -2, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $flag, 'msg' => 'ok'];
    }

    /**
     * 检测是否可以再添加客服坐席
     * @param $sellerId
     * @return array
     */
    public function checkCanAddKeFu($sellerId)
    {
        $flag = 0; // 不可建
        try {

            $maxKefuNum = $this->field('max_kefu_num')->where('seller_id', $sellerId)->find();

            // 目前的已经建的客服数
            $nowKefuNumData = (new KeFu())->getSellerKeFuNum($sellerId);
            if (0 != $nowKefuNumData['code']) {
                return $nowKefuNumData;
            }

            if ($maxKefuNum['max_kefu_num'] > $nowKefuNumData['data']) {
                $flag = 1;
            }
        } catch (\Exception $e) {
            Log::error($e->getMessage());

            return ['code' => -2, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $flag, 'msg' => 'ok'];
    }

    /**
     * 更新商户信息
     * @param $sellerId
     * @param $param
     * @return array
     */
    public function updateSellerInfo($sellerId, $param)
    {
        try {

            $this->where('seller_id', $sellerId)->update($param);
        } catch (\Exception $e) {
            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => '', 'msg' => 'ok'];
    }
}