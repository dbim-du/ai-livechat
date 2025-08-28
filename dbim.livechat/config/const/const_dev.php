<?php
CONST SERVERHOST = "https://wmgtestapi.lychessclub.work";
CONST ENVCONST = [
    // 数据库
    'database'=>[
        'host'        => '127.0.0.1',
        'user'        => 'root',
        'password'    => '123456',
        'database'    => 'olivechat',
        'port'        => '3306',
        'charset'     => 'utf8',
    ],
    // 当前系统域名
    'domain' => 'http://192.168.53.133:8081',//'https://livechat.lychessclub.work',
    // api接口
    'api_url' => 'https://livechat.lychessclub.work/index/test/receive',
    // websocket 对外服务端口
    'socket_port' => 2020,
    // socket server
    //'socket' => 'livechatwss.lychessclub.work',
    'socket' => '192.168.53.133:2020',
    // 通信协议0
    'protocol' => 'ws://',
    'dbim_api_host' => 'http://wmgtestapi.lychessclub.work',
    'SERVER_URL' => [
        'SendVal' => SERVERHOST. '/QEL/Tool/SendValCode',
        //'Reg' => SERVERHOST . '/QEL/Entrance/Register',
        'Reg' => SERVERHOST . '/Official/Entrance/Register',
        'SendEmailCode' => SERVERHOST . '/Official/Tool/SendEmailValCode',
        'LogIn' => SERVERHOST . '/QEL/Entrance/LoginEmail',
        'FindPwd' => SERVERHOST . '/QEL/Entrance/Forget',
        'UpdatePwd' => SERVERHOST . '/QEL/Account/UpdatePwd',
        'MemberInfo' => SERVERHOST . '/QEL/Account/MemberInfoSubmit',
        'DashboardInfoGet' => SERVERHOST . '/QEL/Account/DashboardInfoGet',
        'MerchantInfoGet' => SERVERHOST . '/QEL/Account/MerchantInfoGet',
        'MerchantInfoSubmit' => SERVERHOST . '/QEL/Account/MerchantInfoSubmit',
        'SubscribeView' => SERVERHOST . '/QEL/Account/SubscribeView',   
        ],
    // 插入商户信息到 dify 数据库
    'dify_db_config' => [
            'type'        => 'pgsql',
            'hostname'    => '127.0.0.1',
            'database'    => 'dify',
            'username'    => 'postgres',
            'password'    => 'p2DXFwYyAAHjBhDL',//'p2DXFwYyAAHjBhDL',//'difyai123456',
            'hostport'    => '5433',
            'charset'     => 'utf8',
            'schema'      => 'public',         // PostgreSQL 模式名
        ],
    // loginDify_PassWord 用户登录 Dify 密码
    'loginDify_PassWord' => 'dbimlivechat2025',

    // Dify 主账号的 工作空间 ID
    'tenant_id' => '6ba8bf32-42d1-4ebc-b1ff-25a530baa1bb',

    // LiveChat Bot 机器人客服 kefu_id
    'robot_kefu_id' => 35,
    // LiveChat Bot 机器人客服 kefu_code
    'robot_kefu_code' => '688c5a9b09554',
    // LiveChat Bot 机器人客服 kefu_name
    'robot_kefu_name' => 'dbim_bot01',
    // LiveChat Bot 机器人客服 kefu_avatar
    'robot_kefu_avatar' => '/static/common/images/kefu/3.png',
    // LiveChat Bot 机器人客服 max_service_num
    'robot_max_service_num' => 10000,
    // LiveChat Bot 机器人客服 max_service_num
    'robot_seller_id' => 36,
    // LiveChat Bot 机器人客服 问候语 
    'robot_hello_word' => 'DBiM AI 智能客服为您服务',

];
?>