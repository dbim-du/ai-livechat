<?php

namespace app\common\outapi\dbim;

class DBIMAccount
{
    function DashboardInfoGet(){
        return getServerA('/QEL/Account/DashboardInfoGet','');
    }
    function UpdatePwd($data){
        return getServerA('/QEL/Account/UpdatePwd',$data);
    }
}