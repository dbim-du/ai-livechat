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

class MerchantVersionValidate extends Validate
{
    protected $rule =   [
        'character'  => 'require',
        'goldcoinNum'   => 'require',
        'equity_statement' => 'require',
        'badge' => 'require',
    ];

    protected $message  =   [
        'character.require' => '商家版本不能为空',
        'goldcoinNum.require'   => '消耗金币数量不能为空',
        'equity_statement.require'  => '权益限制不能为空',
        'badge.require'  => '图标徽章不能为空'
    ];

    protected $scene = [
        'edit'  =>  ['character', 'goldcoinNum', 'equity_statement', 'badge']
    ];
}