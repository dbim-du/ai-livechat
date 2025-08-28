<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Date: 2019/3/1
 * Time: 14:02
 */
namespace app\seller\validate;

use think\Validate;

class WebSiteValidate extends Validate
{
    protected $rule =   [
        'web_name'  => 'require',
        'web_url'  => 'require',
    ];

    protected $message  =   [
        'web_name.require' => '站点名称不能为空',
        'web_url.require'   => '站点url不能为空',
    ];

    protected $scene = [
        'edit'  =>  ['web_name', 'web_url', 'max_service_num']
    ];
}