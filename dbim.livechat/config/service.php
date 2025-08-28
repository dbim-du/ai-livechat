<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/16
 * Time: 11:35 PM
 */
return [

    // 加密盐
    'salt' => '~NickBai!@#123',

    // 通信协议
    'protocol' => ENVCONST['protocol'],

    // socket server
    'socket' => ENVCONST['socket'],

    // 初始化问候语
    'hello_word' => '您好，DBIM 客服为您服务',

    // 当前系统域名
    'domain' => ENVCONST['domain'],

    // 聊天信息一次展示多少条
    'log_page' => 10,

    // 是否开启商户注册
    'reg_flag' => true,

    // api接口
    'api_url' => ENVCONST['api_url']
];