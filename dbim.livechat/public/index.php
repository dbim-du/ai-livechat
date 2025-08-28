<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------

// [ 应用入口文件 ]
namespace think;

require_once __DIR__ . '/../config/environment.php';
require_once __DIR__ . '/../config/const/const_'.ENVNAME.'.php';
//exit;

ini_set('display_errors', 'On');

// 加载基础文件
require __DIR__ . '/../thinkphp/base.php';

// 支持事先使用静态方法设置Request对象和Config对象

//CONST ENVNAME = 'dev';
//require '../config/environment.php';

// 执行应用并响应
Container::get('app')->run()->send();
