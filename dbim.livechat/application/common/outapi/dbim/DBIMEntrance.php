<?php

namespace app\common\outapi\dbim;

class DBIMEntrance{

    function Login(){
//        'SERVER_URL' => [
//            'SendVal' => SERVERHOST. '/QEL/Tool/SendValCode',
//            'Reg' => SERVERHOST . '/QEL/Entrance/Register',
//            'LogIn' => SERVERHOST . '/QEL/Entrance/LoginEmail',
//            'FindPwd' => SERVERHOST . '/QEL/Entrance/Forget',
//            'UpdatePwd' => SERVERHOST . '/QEL/Account/UpdatePwd',
//            'MemberInfo' => SERVERHOST . '/QEL/Account/MemberInfoSubmit',
//            'DashboardInfoGet' => SERVERHOST . '/QEL/Account/DashboardInfoGet',
//            'MerchantInfoGet' => SERVERHOST . '/QEL/Account/MerchantInfoGet',
//            'MerchantInfoSubmit' => SERVERHOST . '/QEL/Account/MerchantInfoSubmit',
//            'SubscribeView' => SERVERHOST . '/QEL/Account/SubscribeView',
    }

    function Register(){
        return json_encode(['code'=> 0,'msg'=> '',data=>'']);
    }

    function LoginEmail($email,$pwd){
        $postData = [
            'email' => $email,
            'loginPwd' => MD5($pwd),
        ];
        return getServerA('/QEL/Entrance/LoginEmail',$postData);
    }
}
