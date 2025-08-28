<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/28
 * Time: 9:33 PM
 */
namespace app\admin\validate;

use think\Validate;

class BuypackageValidate extends Validate
{
    protected $rule =   [
        'package_name'  => 'require',
        'specification'   => 'require',
        'goldcoinNum' => 'require',
        'tokensNum' => 'require',
        'description' => 'require',
    ];

    protected $message  =   [
        'package_name.require' => '套餐名称不能为空',
        'specification.require'   => '规格不能为空',
        'goldcoinNum.require'  => '消耗金币数量不能为空',
        'tokensNum.require'  => '获得Tokens数量不能为空',
        'description.require'  => '套餐说明不能为空'
    ];

    protected $scene = [
        'edit'  =>  ['package_name', 'specification', 'goldcoinNum', 'tokensNum', 'description']
    ];
}