<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2020/5/17
 * Time: 9:18 PM
 */
namespace app\service;

use app\model\BlackList;
use app\model\Chat;
use app\model\ComQuestion;
use app\model\Customer;
use app\model\CustomerQueue;
use app\model\KeFu;
use app\model\Queue;
use app\model\Service;
use app\model\ServiceLog;
use app\model\System;
use app\utils\Common;
use app\utils\Distribution;
use app\utils\DistributionRobot;
use app\utils\IPLocation;
use \GatewayWorker\Lib\Gateway;
use app\model\SystemConfigList;

class SocketEvents
{
    public static function customerIn($clientId, $data, $db)
    {

        if (empty($data['customer_id']) || empty($data['customer_name']
                || empty($data['customer_avatar']))) {

            Gateway::sendToClient($clientId, json_encode([
                'cmd' => 'customerIn',
                'data' => [
                    'code' => 204,
                    'data' => [],
                    'msg' => '您的浏览器版本过低，或者开启了隐身模式'
                ]
            ]));

            return ;
        }

        // 处理ip黑名单问题
        $ip = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '127.0.0.1';
        $blackListModel = new BlackList($db);
        $isIn = $blackListModel->checkBlackList($ip, $data['seller_code']);
        if (0 == $isIn['code']) {
            // 发送断开连接
            Gateway::sendToClient($clientId, json_encode([
                'cmd' => 'customerIn',
                'data' => [
                    'code' => 201,
                    'data' => [],
                    'msg' => '黑名单用户'
                ]
            ]));
            return;
        }

        // 更新访客队列
        $updateData = [
            'customer_id' => $data['customer_id'],
            'client_id' => $clientId,
            'customer_name' => $data['customer_name'],
            'customer_avatar' => $data['customer_avatar'],
            'customer_ip' => $ip,
            'seller_code' => $data['seller_code'],
            'create_time' => date('Y-m-d H:i:s')
        ];

        $customerQueueModel = new CustomerQueue($db);
        $customerQueueModel->updateQueue($updateData);

        // 更新访客信息
        $customer = new Customer($db);
        $location = IPLocation::getLocationByIp($ip, 2);
        $customer->updateCustomer([
            'customer_id' => $data['customer_id'],
            'client_id' => $clientId,
            'customer_name' => $data['customer_name'],
            'customer_avatar' => $data['customer_avatar'],
            'customer_ip' => $ip,
            'seller_code' => $data['seller_code'],
            'create_time' => date('Y-m-d H:i:s'),
            'online_status' => 1,
            'province' => $location['province'],
            'city' => $location['city']
        ]);

        // 绑定关系
        $_SESSION['id'] = $data['customer_id'];
        Gateway::bindUid($clientId, $data['customer_id']);

        Gateway::sendToClient($clientId, json_encode([
            'cmd' => 'customerIn',
            'data' => [
                'code' => 0,
                'data' => [],
                'msg' => 'login success'
            ]
        ]));
    }

    /**
     *  Dify Rot 客服 对接 客户聊天
     */
    private static function difyRobotSendMsg($appcode, $customerModel, $sessionId, $customer, $db)
    {
        // 1、获取 Robot客服信息
       $robot_kefuInfo = [
            'kefu_id' => ENVCONST['robot_kefu_id'],
            'kefu_code' => ENVCONST['robot_kefu_code'],
            'kefu_name'=> ENVCONST['robot_kefu_name'],
            'kefu_avatar'=> ENVCONST['robot_kefu_avatar'],
            'max_service_num'=> ENVCONST['robot_max_service_num'],
            'seller_id'=> ENVCONST['robot_seller_id'],
       ];

        // 2、记录服务日志
        $serviceLog = new ServiceLog($db);
        $logId = $serviceLog->addServiceLog([
            'customer_id' => $customer['customer_id'],
            'client_id' => $sessionId,
            'customer_name' => $customer['customer_name'],
            'customer_avatar' => $customer['customer_avatar'],
            'customer_ip' => $customer['customer_ip'],
            'kefu_code' => ltrim(ENVCONST['robot_kefu_code']),
            'seller_code' => $customer['seller_code'],
            'start_time' => date('Y-m-d H:i:s'),
            'protocol' => 'ws'
        ]);


        try {
           

            $customer['log_id'] = $logId['data'];
            // // 通知客服链接访客
            // Gateway::sendToUid($dsInfo['data']['kefu_code'], json_encode([
            //     'cmd' => 'customerLink',
            //     'data' => $customer
            // ]));

            // 3、确定客服收到消息, 通知访客连接成功,完成闭环
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userInit',
                'data' => [
                    'code' => 0,
                    'data' => $robot_kefuInfo,
                    'msg' => 'Robot、分配客服成功'
                ]
            ]));

            unset($customer['log_id']);

        } catch (\Exception $e) {
            // var_dump($e->getMessage());
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userInit',
                'data' => [
                    'code' => 400,
                    'data' => [],
                    'msg' => '请重新尝试分配客服'
                ]
            ]));

            if (0 == Gateway::isUidOnline($robot_kefuInfo['kefu_code'])) {
                // 将当前异常客服状态重置
                (new KeFu($db))->keFuOffline($robot_kefuInfo['kefu_code']);
            }

            return ;
        }


        // notice service log 可能会出现写入错误
        $robot_kefuInfo['log_id'] = $logId['data'];
        
        // 组装 发送配置
        $sysConfig = [
            'code' => 0,
            'data' => [
                'hello_status' => 1,
                'hello_word' => ENVCONST['robot_hello_word']
            ]
        ];

        $dsInfo = [
            'code' => 0,
            'data' => $robot_kefuInfo
        ];

        // 4、发送问候语
        $commonModel = new Common($db);
        $commonModel->checkHelloWord($customer, $sysConfig, $dsInfo, $sessionId);

         // 5、记录服务数据
        $service = new Service($db);
        $service->addServiceCustomer($robot_kefuInfo['kefu_code'], $customer['customer_id'], $robot_kefuInfo['log_id'], $sessionId);

        $customer['pre_kefu_code'] = $robot_kefuInfo['kefu_code'];
        // 更新访客表
        $customerModel->updateCustomer($customer);

        // 从队列中移除访客
        $queue = new Queue($db);
        $queue->removeCustomerFromQueue($customer['customer_id'], $sessionId);

        
    }

    /**
     *  Dify Rot 客服 对接 客户聊天
     */
    private static function difyRobotSendMsg_Robot($appcode, $customerModel, $sessionId, $customer, $db)
    {
        // 1、获取 Robot客服信息
       $robot_kefuInfo = [
            'kefu_id' => ENVCONST['robot_kefu_id'],
            'kefu_code' => ENVCONST['robot_kefu_code'],
            'kefu_name'=> ENVCONST['robot_kefu_name'],
            'kefu_avatar'=> ENVCONST['robot_kefu_avatar'],
            'max_service_num'=> ENVCONST['robot_max_service_num'],
            'seller_id'=> ENVCONST['robot_seller_id'],
       ];

        // 2、记录服务日志
        $serviceLog = new ServiceLog($db);
        $logId = $serviceLog->addServiceLog([
            'customer_id' => $customer['customer_id'],
            'client_id' => $sessionId,
            'customer_name' => $customer['customer_name'],
            'customer_avatar' => $customer['customer_avatar'],
            'customer_ip' => $customer['customer_ip'],
            'kefu_code' => ltrim(ENVCONST['robot_kefu_code']),
            'seller_code' => $customer['seller_code'],
            'start_time' => date('Y-m-d H:i:s'),
            'protocol' => 'ws'
        ]);


        try {
           

            $customer['log_id'] = $logId['data'];
            // // 通知客服链接访客
            // Gateway::sendToUid($dsInfo['data']['kefu_code'], json_encode([
            //     'cmd' => 'customerLink',
            //     'data' => $customer
            // ]));

            // 3、确定客服收到消息, 通知访客连接成功,完成闭环
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userInit',
                'data' => [
                    'code' => 0,
                    'data' => $robot_kefuInfo,
                    'msg' => 'Robot、分配客服成功'
                ]
            ]));

            unset($customer['log_id']);

        } catch (\Exception $e) {
            // var_dump($e->getMessage());
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userInitRobot',
                'data' => [
                    'code' => 400,
                    'data' => [],
                    'msg' => '请重新尝试分配客服'
                ]
            ]));

            if (0 == Gateway::isUidOnline($robot_kefuInfo['kefu_code'])) {
                // 将当前异常客服状态重置
                (new KeFu($db))->keFuOffline($robot_kefuInfo['kefu_code']);
            }

            return ;
        }


        // notice service log 可能会出现写入错误
        $robot_kefuInfo['log_id'] = $logId['data'];
        
        // 组装 发送配置
        $sysConfig = [
            'code' => 0,
            'data' => [
                'hello_status' => 1,
                'hello_word' => ENVCONST['robot_hello_word']
            ]
        ];

        $dsInfo = [
            'code' => 0,
            'data' => $robot_kefuInfo
        ];

        // 4、发送问候语
        $commonModel = new Common($db);
        $commonModel->checkHelloWord($customer, $sysConfig, $dsInfo, $sessionId);

         // 5、记录服务数据
        $service = new Service($db);
        $service->addServiceCustomer($robot_kefuInfo['kefu_code'], $customer['customer_id'], $robot_kefuInfo['log_id'], $sessionId);

        $customer['pre_kefu_code'] = $robot_kefuInfo['kefu_code'];
        // 更新访客表
        $customerModel->updateCustomer($customer);

        // 从队列中移除访客
        $queue = new Queue($db);
        $queue->removeCustomerFromQueue($customer['customer_id'], $sessionId);


    }


    /**
     * 处理访客接入客服分配
     * @param $sessionId
     * @param $data
     * @param $db
     */
    public static function userInit($sessionId, $data, $db)
    {

        // 系统配置
        $list = new SystemConfigList($db);
        $list_data = $list->getSysConfigList();
        $_SESSION['sysconfigList'] = $list_data['data'];

        
        $customerModel = new Customer($db);
        $data = json_decode($data, true);
        // echo $data;
        $data = $data['data'];

        if (empty($data['uid']) || empty($data['name'] || empty($data['avatar']))) {

            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userInit',
                'data' => [
                    'code' => 204,
                    'data' => [],
                    'msg' => '您的浏览器版本过低，或者开启了隐身模式'
                ]
            ]));

            return ;
        }

        // 处理ip黑名单问题
        $ip = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '127.0.0.1';
        $blackListModel = new BlackList($db);
        $isIn = $blackListModel->checkBlackList($ip, $data['seller']);
        if (0 == $isIn['code']) {
            // 发送断开连接
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userInit',
                'data' => [
                    'code' => 201,
                    'data' => [],
                    'msg' => '黑名单用户'
                ]
            ]));
            return;
        }

        // 固定链接维护用户
        if (isset($data['type']) && 2 == $data['type']) {

            $_SESSION['id'] = $data['uid'];
            Gateway::bindUid($sessionId, $data['uid']);
        }

        $location = IPLocation::getLocationByIp($ip, 2);
        $customer = [
            'customer_id' => $data['uid'],
            'customer_name' => $data['name'],
            'customer_avatar' => $data['avatar'],
            'customer_ip' => $ip,
            'seller_code' => $data['seller'],
            'client_id' => $sessionId,
            'create_time' => date('Y-m-d H:i:s'),
            'online_status' => 1,
            'protocol' => 'ws',
            'province' => $location['province'],
            'city' => $location['city'],
            'appcode' => $data['appcode'],
        ];

        try {

            // 尝试分配新访客进入服务
            $api_token = self::getdifyAppId($data['appcode'],$db);
            if ($api_token['code'] == 0) {
                $_SESSION['api_token'] = $api_token['data'];
            }

            // 尝试分配新访客进入服务
            $distributionModel = new Distribution($db);
            $dsInfo = $distributionModel->customerDistribution($customer);

            // 存储分配的 Robot 客服信息
            $_SESSION['kefu'] = $dsInfo['data'];

            switch ($dsInfo['code']) {

                case 200:

                    // 记录服务日志
                    $serviceLog = new ServiceLog($db);
                    $logId = $serviceLog->addServiceLog([
                        'customer_id' => $customer['customer_id'],
                        'client_id' => $sessionId,
                        'customer_name' => $customer['customer_name'],
                        'customer_avatar' => $customer['customer_avatar'],
                        'customer_ip' => $customer['customer_ip'],
                        'kefu_code' => ltrim($dsInfo['data']['kefu_code'], 'KF_'),
                        'seller_code' => $customer['seller_code'],
                        'start_time' => date('Y-m-d H:i:s'),
                        'protocol' => 'ws'
                    ]);

                    try {

                        if (0 == Gateway::isUidOnline($dsInfo['data']['kefu_code'])) {
                            throw new \Exception("444客服不在线");
                        }

                        $customer['log_id'] = $logId['data'];
                        // 通知客服链接访客
                        Gateway::sendToUid($dsInfo['data']['kefu_code'], json_encode([
                            'cmd' => 'customerLink',
                            'data' => $customer
                        ]));

                        // 确定客服收到消息, 通知访客连接成功,完成闭环
                        Gateway::sendToClient($sessionId, json_encode([
                            'cmd' => 'userInit',
                            'data' => [
                                'code' => 0,
                                'data' => $dsInfo['data'],
                                'msg' => '11、分配客服成功'
                            ]
                        ]));

                        unset($customer['log_id']);

                    } catch (\Exception $e) {
                        // var_dump($e->getMessage());
                        Gateway::sendToClient($sessionId, json_encode([
                            'cmd' => 'userInit',
                            'data' => [
                                'code' => 400,
                                'data' => [],
                                'msg' => '请重新尝试分配客服'
                            ]
                        ]));

                        if (0 == Gateway::isUidOnline($dsInfo['data']['kefu_code'])) {
                            // 将当前异常客服状态重置
                            (new KeFu($db))->keFuOffline(ltrim($dsInfo['data']['kefu_code'], 'KF_'));
                        }

                        return ;
                    }

                    // notice service log 可能会出现写入错误
                    $dsInfo['data']['log_id'] = $logId['data'];

                    // 获取商户的配置
                    $system = new System($db);
                    $sysConfig = $system->getSellerConfig($customer['seller_code']);

                    // 对该访客的问候标识
                    $commonModel = new Common($db);
                    if ($dsInfo['data']['greetings']!=''&&$dsInfo['data']['greetings']!=null) {
                        $sysConfig['data']['hello_word'] = $dsInfo['data']['greetings'];
                    }
                    $commonModel->checkHelloWord($customer, $sysConfig, $dsInfo, $sessionId);

                    // 常见问题检测
                    $commonModel->checkCommonQuestion($customer);

                    // 记录服务数据
                    $service = new Service($db);
                    $service->addServiceCustomer(ltrim($dsInfo['data']['kefu_code'], 'KF_'), $customer['customer_id'],
                        $dsInfo['data']['log_id'], $sessionId);

                    $customer['pre_kefu_code'] = ltrim($dsInfo['data']['kefu_code'], 'KF_');
                    // 更新访客表
                    $customerModel->updateCustomer($customer);

                    // 从队列中移除访客
                    $queue = new Queue($db);
                    $queue->removeCustomerFromQueue($customer['customer_id'], $sessionId);

                    break;

                case 201:

                    // // 通知访客没有客服在线
                    // Gateway::sendToClient($sessionId, json_encode([
                    //     'cmd' => 'userInit',
                    //     'data' => [
                    //         'code' => 201,
                    //         'data' => [],
                    //         //'msg' => '暂无客服在线，请稍后再来1'
                    //         'msg' => $dsInfo['msg']
                    //     ]
                    // ]));

                    // 当 没有客服在线的时候，就调用机器人
                    $SocketEvents_ = new SocketEvents($db);
                    $SocketEvents_->difyRobotSendMsg($data['appcode'], $customerModel, $sessionId, $customer, $db);

                    break;

                case 202:

                    // 通知访客客服全忙
                    Gateway::sendToClient($sessionId, json_encode([
                        'cmd' => 'userInit',
                        'data' => [
                            'code' => 202,
                            'data' => [],
                            'msg' => '客服全忙，请稍后再来'
                        ]
                    ]));

                    break;

                case 203:

                    // 通知访客客服全忙
                    Gateway::sendToClient($sessionId, json_encode([
                        'cmd' => 'userInit',
                        'data' => [
                            'code' => 500,
                            'data' => [],
                            'msg' => '系统异常，无法提供服务'
                        ]
                    ]));

                    break;
            }

        } catch (\Exception $e) {

            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userInit',
                'data' => [
                    'code' => 401,
                    'data' => [],
                    'msg' => '请重新尝试分配客服'
                ]
            ]));
        }

        unset($customerModel, $customer, $analysis, $dsInfo);
    }

    /**
     * 处理访客接入 Robot 客服分配
     * @param $sessionId
     * @param $data
     * @param $db
     */
    public static function userRobotInit($sessionId, $data, $db)
    {
        // 系统配置
        $list = new SystemConfigList($db);
        $list_data = $list->getSysConfigList();
        $_SESSION['sysconfigList'] = $list_data['data'];

        $customerModel = new Customer($db);
        $data = json_decode($data, true);
        $data = $data['data'];

        if (empty($data['uid']) || empty($data['name'] || empty($data['avatar']))) {

            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userRobotInit',
                'data' => [
                    'code' => 204,
                    'data' => [],
                    'msg' => '您的浏览器版本过低，或者开启了隐身模式'
                ]
            ]));

            return ;
        }

        // 处理ip黑名单问题
        $ip = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '127.0.0.1';
        $blackListModel = new BlackList($db);
        $isIn = $blackListModel->checkBlackList($ip, $data['seller']);

        if (0 == $isIn['code']) {
            // 发送断开连接
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userRobotInit',
                'data' => [
                    'code' => 201,
                    'data' => [],
                    'msg' => '黑名单用户'
                ]
            ]));
            return;
        }


        


        // 固定链接维护用户
        if (isset($data['type']) && 2 == $data['type']) {

            $_SESSION['id'] = $data['uid'];
            Gateway::bindUid($sessionId, $data['uid']);
        }

        $location = IPLocation::getLocationByIp($ip, 2);
        $customer = [
            'customer_id' => $data['uid'],
            'customer_name' => $data['name'],
            'customer_avatar' => $data['avatar'],
            'customer_ip' => $ip,
            'seller_code' => $data['seller'],
            'client_id' => $sessionId,
            'create_time' => date('Y-m-d H:i:s'),
            'online_status' => 1,
            'protocol' => 'ws',
            'province' => $location['province'],
            'city' => $location['city'],
            'appcode' => $data['appcode'],
        ];

        try {

            // 尝试分配新访客进入服务
            $api_token = self::getdifyAppId($data['appcode'],$db);
            if ($api_token['code']==0) {
                $_SESSION['api_token'] = $api_token['data'];
            }

            // // 尝试分配新访客进入服务
            // $distributionModel = new Distribution($db);
            // $dsInfo = $distributionModel->customerDistribution($customer);

            // Robot 客服 尝试分配新访客进入服务
            $distributionModel = new DistributionRobot($db);
            $dsInfo = $distributionModel->customerDistribution($customer);

            // 存储分配的 Robot 客服信息
            $_SESSION['kefu'] = $dsInfo['data'];

            switch ($dsInfo['code']) {

                case 200:

                    // 记录服务日志
                    $serviceLog = new ServiceLog($db);
                    $logId = $serviceLog->addServiceLog([
                        'customer_id' => $customer['customer_id'],
                        'client_id' => $sessionId,
                        'customer_name' => $customer['customer_name'],
                        'customer_avatar' => $customer['customer_avatar'],
                        'customer_ip' => $customer['customer_ip'],
                        'kefu_code' => ltrim($dsInfo['data']['kefu_code'], 'KF_'),
                        'seller_code' => $customer['seller_code'],
                        'start_time' => date('Y-m-d H:i:s'),
                        'protocol' => 'ws'
                    ]);

                    try {

                        // if (0 == Gateway::isUidOnline($dsInfo['data']['kefu_code'])) {
                        //     throw new \Exception("444客服不在线");
                        // }

                        $customer['log_id'] = $logId['data'];
                        // 通知客服链接访客
                        Gateway::sendToUid($dsInfo['data']['kefu_code'], json_encode([
                            'cmd' => 'customerLink',
                            'data' => $customer
                        ]));

                        // 确定客服收到消息, 通知访客连接成功,完成闭环
                        Gateway::sendToClient($sessionId, json_encode([
                            'cmd' => 'userInitRobot',
                            'data' => [
                                'code' => 0,
                                'data' => $dsInfo['data'],
                                'msg' => '11、分配客服成功:' //. json_encode($_SESSION['kefu'])
                            ]
                        ]));

                        // 发送第一次心跳 隐藏 / 显示 转人工 按钮
                        $data_frist['data'] = $data;
                        self::pingPong($sessionId, json_encode($data_frist), $db);

                        unset($customer['log_id']);

                    } catch (\Exception $e) {
                        // var_dump($e->getMessage());
                        Gateway::sendToClient($sessionId, json_encode([
                            'cmd' => 'userInitRobot',
                            'data' => [
                                'code' => 400,
                                'data' => [],
                                'msg' => '请重新尝试分配客服：' . $e->getMessage()
                            ]
                        ]));

                        if (0 == Gateway::isUidOnline($dsInfo['data']['kefu_code'])) {
                            // 将当前异常客服状态重置
                            (new KeFu($db))->keFuOffline(ltrim($dsInfo['data']['kefu_code'], 'KF_'));
                        }

                        return ;
                    }

                    // notice service log 可能会出现写入错误
                    $dsInfo['data']['log_id'] = $logId['data'];

                    // 获取商户的配置
                    $system = new System($db);
                    $sysConfig = $system->getSellerConfig($customer['seller_code']);

                    // 对该访客的问候标识
                    $commonModel = new Common($db);
                    if ($dsInfo['data']['greetings']!=''&&$dsInfo['data']['greetings']!=null) {
                        $sysConfig['data']['hello_word'] = $dsInfo['data']['greetings'];
                    }
                    $commonModel->checkHelloWord($customer, $sysConfig, $dsInfo, $sessionId);

                    // 常见问题检测
                    $commonModel->checkCommonQuestion($customer);

                    // 记录服务数据
                    $service = new Service($db);
                    $service->addServiceCustomer(ltrim($dsInfo['data']['kefu_code'], 'KF_'), $customer['customer_id'],
                        $dsInfo['data']['log_id'], $sessionId);

                    $customer['pre_kefu_code'] = ltrim($dsInfo['data']['kefu_code'], 'KF_');
                    // 更新访客表
                    $customerModel->updateCustomer($customer);

                    // 从队列中移除访客
                    $queue = new Queue($db);
                    $queue->removeCustomerFromQueue($customer['customer_id'], $sessionId);

                    

                    break;

                case 201:

                    // // 通知访客没有客服在线
                    // Gateway::sendToClient($sessionId, json_encode([
                    //     'cmd' => 'userInit',
                    //     'data' => [
                    //         'code' => 201,
                    //         'data' => [],
                    //         //'msg' => '暂无客服在线，请稍后再来1'
                    //         'msg' => $dsInfo['msg']
                    //     ]
                    // ]));

                    // 当 没有客服在线的时候，就调用机器人
                    $SocketEvents_ = new SocketEvents($db);
                    $SocketEvents_->difyRobotSendMsg($data['appcode'], $customerModel, $sessionId, $customer, $db);

                    break;

                case 202:

                    // 通知访客客服全忙
                    Gateway::sendToClient($sessionId, json_encode([
                        'cmd' => 'userInitRobot',
                        'data' => [
                            'code' => 202,
                            'data' => [],
                            'msg' => '客服全忙，请稍后再来'
                        ]
                    ]));

                    break;

                case 203:

                    // 通知访客客服全忙
                    Gateway::sendToClient($sessionId, json_encode([
                        'cmd' => 'userInitRobot',
                        'data' => [
                            'code' => 500,
                            'data' => [],
                            'msg' => '系统异常，无法提供服务'
                        ]
                    ]));

                    break;
            }

        } catch (\Exception $e) {

            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userInitRobot',
                'data' => [
                    'code' => 401,
                    'data' => [],
                    'msg' => '请重新尝试分配客服'
                ]
            ]));
        }

        unset($customerModel, $customer, $analysis, $dsInfo);
    }

    /**
     * 客服初始化
     * @param $sessionId
     * @param $data
     * @param $db
     * @param $config
     */
    public static function init($sessionId, $data, $db, $config)
    {
        $data = json_decode($data, true);
        $data = $data['data'];
        // 通知先前登陆的客服下线
        if ($config['single_login'] && 1 == Gateway::isUidOnline($data['uid'])) {
            Gateway::sendToUid($data['uid'], json_encode([
                'cmd' => 'SSO',
                'data' => [
                    'code' => 0,
                    'data' => [],
                    'msg' => '其他地方登录'
                ]
            ]));
        }

        // 绑定关系
        $_SESSION['id'] = $data['uid'];
        Gateway::bindUid($sessionId, $data['uid']);

        // 设置客服在线
        $kefu = new KeFu($db);
        $kefu->setKeFuStatus(ltrim($data['uid'], 'KF_'));

        Gateway::sendToUid($data['uid'], json_encode([
            'cmd' => 'init',
            'data' => [
                'code' => 0,
                'data' => '',
                'msg' => 'login success'
            ]
        ]));
    }

    public static function getRealIP()
    {
        $ip = '';
        if (isset($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
        } elseif (isset($_SERVER['HTTP_X_REAL_IP'])) {
            $ip = $_SERVER['HTTP_X_REAL_IP'];
        } elseif (isset($_SERVER['REMOTE_ADDR'])) {
            $ip = $_SERVER['REMOTE_ADDR'];
        } else {
            $ip = '127.0.0.1';
        }
        return $ip;
    }

    /**
     * 直接咨询指定客服
     * @param $sessionId
     * @param $data
     * @param $db
     */
    public static function directLinkKF($sessionId, $data, $db)
    {
        $data = json_decode($data, true);
        $data = $data['data'];

        $customerModel = new Customer($db);
        $kefuModel = new KeFu($db);


        // 处理ip黑名单问题
        // $ip = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '127.0.0.1';
        $ip = SocketEvents::getRealIP();
        // var_dump($ip);
        $blackListModel = new BlackList($db);
        $isIn = $blackListModel->checkBlackList($ip, $data['seller']);
        if (0 == $isIn['code']) {
            // 发送断开连接
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'customerIn',
                'data' => [
                    'code' => 201,
                    'data' => [],
                    'msg' => '黑名单用户'
                ]
            ]));
            return;
        }

        $location = IPLocation::getLocationByIp($ip, 2);
        $customer = [
            'customer_id' => $data['uid'],
            'customer_name' => $data['name'],
            'customer_avatar' => $data['avatar'],
            'customer_ip' => $ip,
            'seller_code' => $data['seller'],
            'client_id' => $sessionId,
            'create_time' => date('Y-m-d H:i:s'),
            'online_status' => 1,
            'protocol' => 'ws',
            'province' => $location['province'],
            'city' => $location['city'],
            'appcode' => $data['appcode'],
        ];

        // 检测客服账号的合法性
        $kefuInfo = $kefuModel->getKeFuInfoByCode($data['kefu_code']);
        if (empty($kefuInfo['data'])) {
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'customerIn',
                'data' => [
                    'code' => 201,
                    'data' => [],
                    'msg' => '暂无客服在线，请稍后再来 - 001'
                ]
            ]));

            return ;
        }

        // 检测连接客服是否在线
        if (0 == $kefuInfo['data']['online_status']) {
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'customerIn',
                'data' => [
                    'code' => 201,
                    'data' => [],
                    'msg' => '暂无客服在线，请稍后再来 - 002'
                ]
            ]));

            return ;
        }

        // 检测客服的是否达到了最大服务限制
        $nowServiceModel = new Service($db);
        $serviceNum = $nowServiceModel->getNowServiceNum($data['kefu_code']);

        if (0 != $serviceNum['code']) {
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'customerIn',
                'data' => [
                    'code' => 201,
                    'data' => [],
                    'msg' => '暂无客服在线，请稍后再来 - 003'
                ]
            ]));

            return ;
        }

        if ($serviceNum['data'] >= $kefuInfo['data']['max_service_num']) {
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userInit',
                'data' => [
                    'code' => 202,
                    'data' => [],
                    'msg' => '客服全忙，请稍后再来'
                ]
            ]));

            return ;
        }

        // 固定链接维护用户
        if (isset($data['type']) && 2 == $data['type']) {

            $_SESSION['id'] = $data['uid'];
            Gateway::bindUid($sessionId, $data['uid']);
        }

        // 记录服务日志
        $serviceLog = new ServiceLog($db);
        $logId = $serviceLog->addServiceLog([
            'customer_id' => $customer['customer_id'],
            'client_id' => $sessionId,
            'customer_name' => $customer['customer_name'],
            'customer_avatar' => $customer['customer_avatar'],
            'customer_ip' => $customer['customer_ip'],
            'kefu_code' => $data['kefu_code'],
            'seller_code' => $customer['seller_code'],
            'start_time' => date('Y-m-d H:i:s'),
            'protocol' => 'ws'
        ]);

        try {

            if (0 == Gateway::isUidOnline('KF_' . $data['kefu_code'])) {
                throw new \Exception("555客服不在线");
            }

            $customer['log_id'] = $logId['data'];
            // 通知客服链接访客
            Gateway::sendToUid('KF_' . $data['kefu_code'], json_encode([
                'cmd' => 'customerLink',
                'data' => $customer
            ]));

            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userInit',
                'data' => [
                    'code' => 0,
                    'data' => [
                        'kefu_avatar' => $kefuInfo['data']['kefu_avatar'],
                        'kefu_code' => 'KF_' . $kefuInfo['data']['kefu_code'],
                        'kefu_name' => $kefuInfo['data']['kefu_name']
                    ],
                    'msg' => '2、分配客服成功'
                ]
            ]));
            unset($customer['log_id']);

        } catch (\Exception $e) {

            var_dump($e->getMessage());

            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'userInit',
                'data' => [
                    'code' => 400,
                    'data' => [],
                    'msg' => '请重新尝试分配客服'
                ]
            ]));

            if (0 == Gateway::isUidOnline('KF_' . $data['kefu_code'])) {
                // 将当前异常客服状态重置
                (new KeFu($db))->keFuOffline($data['kefu_code']);
            }

            return ;
        }

        // notice service log 可能会出现写入错误
        $dsInfo['data']['log_id'] = $logId['data'];
        $dsInfo['data']['kefu_avatar'] = $kefuInfo['data']['kefu_avatar'];

        // 获取商户的配置
        $system = new System($db);
        $sysConfig = $system->getSellerConfig($customer['seller_code']);

        // 对该访客的问候标识
        $commonModel = new Common($db);
        $commonModel->checkHelloWord($customer, $sysConfig, $dsInfo, $sessionId);

        // 常见问题检测
        $commonModel->checkCommonQuestion($customer);

        // 记录服务数据
        $service = new Service($db);
        $service->addServiceCustomer($data['kefu_code'], $customer['customer_id'],
            $dsInfo['data']['log_id'], $sessionId);

        $customer['pre_kefu_code'] = $data['kefu_code'];
        // 更新访客表
        $customerModel->updateCustomer($customer);

        // 从队列中移除访客
        $queue = new Queue($db);
        $queue->removeCustomerFromQueue($customer['customer_id'], $sessionId);
    }

    /**
     * 客服发送消息
     */
    public static function krfySendMessage($data,$sessionId,$chatLogId,$chatMessage)
    {
        // 访客离线
        if (0 == Gateway::isUidOnline($data['to_id'])) {
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'afterSend',
                'data' => [
                    'code' => 0,
                    'data' => $chatLogId,
                    'msg' => $data['content']
                ]
            ]));

            return ;
        } else {
            Gateway::sendToUid($data['to_id'], json_encode([
                'cmd' => 'chatMessage',
                'data' => $chatMessage
            ]));
        }
    }

    /**
     * 机器人 客服 回消息
     */
    public function robotMessage($db,$to_id,$to_name,$seller_code,$content) { 
        $data = [];
        // $data['from_id'] = ENVCONST['robot_kefu_code'];
        // $data['from_name'] = ENVCONST['robot_kefu_name'];
        // $data['from_avatar'] = ENVCONST['robot_kefu_avatar'];

        // $_SESSION['kefu']
        $kefu = $_SESSION['kefu'];
        $data['from_id'] = ltrim($kefu['kefu_code'], 'KF_');
        $data['from_name'] = $kefu['kefu_name'];
        $data['from_avatar'] = $kefu['kefu_avatar'];


        $data['to_id'] = $to_id;
        $data['to_name'] = $to_name;
        $data['seller_code'] = $seller_code;
        $data['content'] = $content;

        // 聊天信息入库
        $chatLogId = self::writeChatLog($data, $db);
        $chatMessage = [
            'name' => $data['from_name'],
            'avatar' => $data['from_avatar'],
            'id' => $data['from_id'],
            'time' => date('Y-m-d H:i:s'),
            'content' => htmlspecialchars($data['content']),
            'protocol' => 'ws',
            'chat_log_id' => $chatLogId,
        ];

        // 客服发送消息
        self::krfySendMessage($data,$data['from_id'],$chatLogId,$chatMessage);

        // // 消息设置为 已读
        // $data['mid'] = $chatLogId;
        // $data['uid'] = $data['from_id'];
        // self::readMessage($data, $db);


    }

    /**
     * 根据 appcode 查询 app_id
     */
    public static function getdifyAppId($appcode,$db) { 
        $api_token = '';
        // 尝试分配新访客进入服务
        $distributionModel = new Distribution($db);
        $rows = $distributionModel->selDifyApp_($appcode);
        if (count($rows)<1) {
            return ['code' => -1, 'data' => '', 'msg' => '$appcode:'.$appcode.'未找到对应的应用'];
        }
        $app_id = $rows[0]['app_id'];

        // 1、sql 参数
        $sql_param = [
            'app_id' => $app_id
        ];
        // 2、判断 Dify 数据库 当前App应用 是否存在 key（执行带参数绑定的SQL）
        $sql = "SELECT * FROM api_tokens WHERE app_id = $1";// PostgreSQL使用$1, $2等作为参数占位符
        $api_tokens_list = $distributionModel->selDifyApp_DataList($sql, $sql_param);
        if (count($api_tokens_list)<1) {
            // return ['code' => -2, 'data' => '', 'msg' => '未找到应用的 APIKey 密钥'];

            // 4、创建 Dify App Key 并 返回创建的 AppKey
            $AppKey_data = self::createDifyAppKey($app_id,$db);
            if ($AppKey_data != null) {
                $api_token = $AppKey_data['data']['token'];
            }


        }else {
            $api_token = $api_tokens_list[0]['token'];
        }
        return ['code' => 0, 'data' => $api_token, 'msg' => '成功'];

    }


    /**
     * 处理聊天消息
     * @param $sessionId
     * @param $data
     * @param $db
     */
    public static function chatMessage($sessionId, $data_, $db)
    {
        // 是否是 访客 发送的消息
        $is_fangke = true;

        // var_dump('聊天事件');
        $data_ = json_decode($data_, true);
        $data = $data_['data'];

        try {
            // $data['content'] = $data['content'] . Gateway::getUidByClientId($sessionId);
            // 聊天信息入库
            $chatLogId = self::writeChatLog($data, $db);

            $chatMessage = [
                'name' => $data['from_name'],
                'avatar' => $data['from_avatar'],
                'id' => $data['from_id'],
                'time' => date('Y-m-d H:i:s'),
                'content' => htmlspecialchars($data['content']),
                'protocol' => 'ws',
                'chat_log_id' => $chatLogId,
            ];

            // 客服发送的消息
            if (strstr(Gateway::getUidByClientId($sessionId), "KF_") !== false) {
            
                $is_fangke = false;
                // 客服发送消息
                self::krfySendMessage($data,$sessionId,$chatLogId,$chatMessage);

            } else { // 访客发送的消息
                $is_fangke = true;

                // 检测自身的标识是否存在，不在，重新绑定
                if (0 == Gateway::isUidOnline($data['from_id'])) {
                    $_SESSION['id'] = $data['from_id'];
                    Gateway::bindUid($data['from_id'], $sessionId);
                }

                if (1 == Gateway::isUidOnline($data['to_id'])) {

                    Gateway::sendToUid($data['to_id'], json_encode([
                        'cmd' => 'chatMessage',
                        'data' => $chatMessage
                    ]));
                }

                
            }

            // 确定客服收到消息, 通知访客连接成功,完成闭环
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'afterSend',
                'data' => [
                    'code' => 0,
                    'data' => $chatLogId,
                    'msg' => $data['content'] 
                ]
            ]));

            


        } catch (\Exception $e) {
            Gateway::sendToClient($sessionId, json_encode([
                'cmd' => 'afterSend',
                'data' => [
                    'code' => 400,
                    'data' => $e->getMessage(),
                    'msg' => '消息发送失败'
                ]
            ]));
        }

        // 如果是 访客 发送的消息（判断 消息接收者 是否是 机器人客服）
        if ($is_fangke) {
            // 判断 消息接收者 是否是 机器人客服
            if ($data['kefy_type'] == 2) { // 是 机器人客服
                // 消息设置为 已读
                $data_['data']['mid'] = $chatLogId;
                $data_['data']['uid'] = $sessionId;
                
                self::readMessage(json_encode($data_), $db);

                // 设置消息为已读
                Gateway::sendToClient($sessionId, json_encode([
                    'cmd' => 'readMessage',
                    'data' => [
                        'mid' => $chatLogId,
                    ]
                ]));


                // 提交数据到 dify

                $postDifyUrl = '';
                if (count($_SESSION['sysconfigList'])>0) {
                    $postDifyUrl = $_SESSION['sysconfigList'][2]['web_url'].'/v1/chat-messages';
                }

                if ($postDifyUrl =='') {
                    return ;
                }

                $postData = [
                    'inputs' => [], 
                    'query' => $data['content'], //'唐僧有几个徒弟？', // 访客 发起的 聊天内容
                    'response_mode' => "blocking",
                    'conversation_id' => '',
                    'user' => $sessionId, // 访客 客户端 id
                    'files' => [],
                ]; 

                if ($_SESSION['api_token']==null || $_SESSION['api_token']=='') {
                    return ;
                }

                $headers = [
                    'Content-Type: application/json', 
                    //'Authorization: Bearer app-ZzyY1qKZRP3vZAqd6RDq0Gai'// $_SESSION['api_token']
                    'Authorization: Bearer ' . $_SESSION['api_token']
                ];
                
                try {
                    
                    $result = self::callApi($postDifyUrl, $postData, $headers);
                    // print_r($result);


                    // // 设置消息为已读
                    // Gateway::sendToClient($sessionId, json_encode([
                    //     'cmd' => 'readMessage',
                    //     'data' => [
                    //         'mid' => $chatLogId,
                    //         'msg' => '// 设置消息为已读:' . json_encode($result)
                    //     ]
                    // ]));


                    // 获取回复
                    $answer = $result['data']['answer'];
                    // 使用 strstr 查找 </think> 之后的全部内容
                    $result_answer = strstr($answer, '</think>');
                    if ($result_answer !== false) {
                        // 去除 </think> 标签本身（获取标签后的内容） 
                        $result_answer = substr($result_answer, strlen('</think>'));

                        // 去除可能存在的换行符或空白字符 
                        $result_answer = ltrim($result_answer, "\n\r\t ");
                    }else {
                        $result_answer = $answer;
                    }

                    // Dify 机器人 发送消息
                    self::robotMessage($db, $data['from_id'], $data['from_name'], $data['seller_code'], self:: unicode_to_utf8($result_answer));




                } catch (\Exception $e) {
                    // echo "API Error: " . $e->getMessage();

                    // self::robotMessage($db, $data['from_id'], $data['from_name'], $data['seller_code'], "API Error: " . $e->getMessage());

                    // 确定客服收到消息, 通知访客连接成功,完成闭环
                    Gateway::sendToClient($sessionId, json_encode([
                        'cmd' => 'chatMessage',
                        'data' => [
                            'code' => 0,
                            'data' => '001',
                            'msg' => '当前客服坐席繁忙, 请稍后再试！'
                        ]
                    ]));
                }

            }

        }

    }

    /**
     * 处理已读未读
     * @param $data
     * @param $db
     */
    public static function readMessage($data_, $db)
    {
        $data_ = json_decode($data_, true);
        $data = $data_['data'];

        $chat = new Chat($db);
        $res = $chat->updateReadStatusBatch($data['mid']);

        // if (0 == $res['code']) {
        //     // 确定客服收到消息, 通知访客连接成功,完成闭环
        //     Gateway::sendToClient($data['uid'], json_encode([
        //         'cmd' => 'readMessage',
        //         'data' => [
        //             'mid' => $data['mid'],
        //         ]
        //     ]));
        // }
        
        if (0 == $res['code'] && 1 == Gateway::isUidOnline($data['uid'])) {
            Gateway::sendToUid($data['uid'], json_encode([
                'cmd' => 'readMessage',
                'data' => [
                    'mid' => $data['mid']
                ]
            ]));
        }
    }

    /**
     * 主动关闭访客
     * @param $data
     * @param $db
     */
    public static function closeUser($data, $db)
    {
        $data = json_decode($data, true);

        $service = new Service($db);
        $serviceInfo = $service->getServiceInfo(ltrim($data['data']['kefu_code'], 'KF_'), $data['data']['customer_id']);

        if(!empty($serviceInfo['data'])) {

            $log = new ServiceLog($db);
            $log->updateEndTime($serviceInfo['data']['service_log_id']);

            $service->removeServiceCustomer($serviceInfo['data']['service_id']);
            // 通知访客
            if (1 == Gateway::isUidOnline($serviceInfo['data']['customer_id'])) {
                Gateway::sendToUid($serviceInfo['data']['customer_id'], json_encode([
                    'cmd' => 'isClose',
                    'data' => [
                        'msg' => '客服下班了,稍后再来吧。'
                    ]
                ]));
            }
        }
    }

    /**
     * 处理常见问题
     * @param $data
     * @param $clientId
     * @param $db
     */
    public static function comQuestion($clientId, $data, $db)
    {
        $data = json_decode($data, true);
        // 查询这条常见问题的答复
        $question = new ComQuestion($db);
        $info = $question->getSellerAnswer($data['data']['seller_code'], $data['data']['question_id']);

        // TODO 常见问题入库
        Gateway::sendToClient($clientId, json_encode([
            'cmd' => 'answerComQuestion',
            'data' => [
                'time' => date('Y-m-d H:i:s'),
                'avatar' => '/static/common/images/robot.jpg',
                'content' => $info['data']['answer'],
                'read_flag' => 2
            ]
        ]));
    }

    /**
     * 处理转接
     * @param $data
     * @param $clientId
     * @param $db
     */
    public static function changeGroup($clientId, $data, $db)
    {
        $message = json_decode($data, true);

        try {

            // 上一次服务的客服设置结束时间，并开启本次服务客服的log
            $service = new Service($db);
            $serviceInfo = $service->getServiceInfo(ltrim($message['data']['from_kefu_id'], 'KF_'),
                $message['data']['customer_id']);

            if(empty($serviceInfo['data'])) {
                Gateway::sendToClient($clientId, json_encode([
                    'cmd' => 'changeGroupCB',
                    'data' => [
                        'code' => 410,
                        'data' => [],
                        'msg' => '转接失败'
                    ]
                ]));

                return ;
            }

            $log = new ServiceLog($db);
            $log->updateEndTime($serviceInfo['data']['service_log_id']);

            $logId = $log->addServiceLog([
                'customer_id' => $message['data']['customer_id'],
                'client_id' => $serviceInfo['data']['client_id'],
                'customer_name' => $message['data']['customer_name'].'_03',
                'customer_avatar' => $message['data']['customer_avatar'],
                'customer_ip' => $message['data']['customer_ip'],
                'kefu_code' => $message['data']['to_kefu_id'],
                'seller_code' => $message['data']['seller_code'],
                'start_time' => date('Y-m-d H:i:s'),
                'protocol' => 'ws',
            ]);

            if(0 != $logId['code']) {
                Gateway::sendToClient($clientId, json_encode([
                    'cmd' => 'changeGroupCB',
                    'data' => [
                        'code' => 420,
                        'data' => [],
                        'msg' => '转接失败'
                    ]
                ]));

                return ;
            }

            // 更新当前服务的客服id 为转接的客服id 和 新的 log id
            $service->addServiceCustomer(
                ltrim($message['data']['from_kefu_id'], 'KF_'),
                $message['data']['customer_id'],
                $logId['data'],
                $serviceInfo['data']['client_id'],
                $message['data']['to_kefu_id']
            );

            // 访客的上次服务客服改为新的客服
            $customer = new Customer($db);
            $customer->updateCustomer([
                'customer_id' => $message['data']['customer_id'],
                'seller_code' => $message['data']['seller_code'],
                'pre_kefu_code' => $message['data']['to_kefu_id']
            ]);

            // 通知新客服接收转接用户
            try {

                if (1 == Gateway::isUidOnline('KF_' . $message['data']['to_kefu_id'])) {
                    Gateway::sendToUid('KF_' . $message['data']['to_kefu_id'], json_encode([
                        'cmd' => 'reLink',
                        'data' => [
                            'customer_id' => $message['data']['customer_id'],
                            'customer_name' => $message['data']['customer_name'],
                            'customer_avatar' => $message['data']['customer_avatar'],
                            'customer_ip' => $message['data']['customer_ip'],
                            'seller_code' => $message['data']['seller_code'],
                            'create_time' => date('Y-m-d H:i:s'),
                            'online_status' => 1,
                            'protocol' => 'ws',
                            'log_id' => $logId['data']
                        ]
                    ]));
                }
            } catch (\Exception $e) {
                Gateway::sendToClient($clientId, json_encode([
                    'cmd' => 'changeGroupCB',
                    'data' => [
                        'code' => 430,
                        'data' => [],
                        'msg' => '转接失败'
                    ]
                ]));

                return ;
            }

            // 通知访客，信息被转接
            try {

                if (1 == Gateway::isUidOnline($message['data']['customer_id'])) {

                    // Gateway::sendToUid($message['data']['customer_id'], json_encode([
                    //     'cmd' => 'reLink',
                    //     'data' => [
                    //         'kefu_code' => 'KF_' . $message['data']['to_kefu_id'],
                    //         'kefu_name' => $message['data']['to_kefu_name'],
                    //         'msg' => '您已被转接:' . json_encode($message)
                    //     ]
                    // ]));

                    // 查询 转接 到的客服的 信息
                    $kefuModel = new KeFu($db);
                    $kefu_ = $kefuModel->getKeFuById($message['data']['to_kefu_id']);

                    $kefy_type = $kefu_['data']['kefy_type'];
                    if ($kefu_['code'] == 0) {

                        // 存储分配的 Robot 客服信息
                        $_SESSION['kefu'] = $kefu_['data'];

                        $greetings = null;
                       
                        if ($kefu_['data']['greetings'] === '' || $kefu_['data']['greetings'] === null) {
                            $greetings = ENVCONST['robot_hello_word'];
                        }else{
                            $greetings = $kefu_['data']['greetings'];
                        }
                        // 发送转接后的问候语
                        Gateway::sendToUid($message['data']['customer_id'], json_encode([
                            'cmd' => 'hello',
                            'data' => [
                                'avatar' => $kefu_['data']['kefu_avatar'],
                                'time' => date('Y-m-d H:i:s'),
                                'content' => $greetings,
                                'protocol' => 'ws',
                                'chat_log_id' => '-1',
                                
                            ]
                        ]));

                        Gateway::sendToUid($message['data']['customer_id'], json_encode([
                            'cmd' => 'reLink',
                            'data' => [
                                'kefu_code' => 'KF_' . $message['data']['to_kefu_id'],
                                'kefu_name' => $message['data']['to_kefu_name'],
                                'kefy_type' => $kefy_type,
                                'msg' => '您已被转接'
                                // 'msg' => '您已被转接$_SESSION[kefu]:' . json_encode($_SESSION['kefu'])
                            ]
                        ]));
                    }
                    



                }
            } catch (\Exception $e) {
                Gateway::sendToClient($clientId, json_encode([
                    'cmd' => 'changeGroupCB',
                    'data' => [
                        'code' => 440,
                        'data' => [],
                        'msg' => '转接失败'
                    ]
                ]));

                return ;
            }

            Gateway::sendToClient($clientId, json_encode([
                'cmd' => 'changeGroupCB',
                'data' => [
                    'code' => 0,
                    'data' => [],
                    'msg' => '转接成功'
                ]
            ]));

        } catch (\Exception $e) {

            Gateway::sendToClient($clientId, json_encode([
                'cmd' => 'changeGroupCB',
                'data' => [
                    'code' => 450,
                    'data' => [],
                    'msg' => '转接失败'
                ]
            ]));

        }
    }

    /**
     * 手动接待访客
     * @param $data
     * @param $clientId
     * @param $db
     */
    public static function linkByKF($clientId, $data, $db)
    {
        $message = json_decode($data, true);
        if (0 == Gateway::isUidOnline($message['data']['customer_id'])) {
            Gateway::sendToClient($clientId, json_encode([
                'cmd' => 'linkKFCB',
                'data' => [
                    'code' => 401,
                    'data' => '',
                    'msg' => '接待失败,该访客不在线或者已经被接待'
                ]
            ]));

            return ;
        }

        if (0 == Gateway::isUidOnline($message['data']['kefu_code'])) {
            Gateway::sendToClient($clientId, json_encode([
                'cmd' => 'linkKFCB',
                'data' => [
                    'code' => 402,
                    'data' => '',
                    'msg' => '您不在线'
                ]
            ]));

            return ;
        }

        try {

            // 检测该访客是否还在线
            $has = $db->select('*')->from('v2_customer_queue')
                ->where('customer_id="' . $message['data']['customer_id'] . '" AND seller_code="' . $message['data']['seller_code'] . '"')
                ->row();
            if(empty($has)) {
                Gateway::sendToClient($clientId, json_encode([
                    'cmd' => 'linkKFCB',
                    'data' => [
                        'code' => 403,
                        'data' => '',
                        'msg' => '接待失败,该访客不在线或者已经被接待'
                    ]
                ]));

                return ;
            }

            // 记录服务日志
            $serviceLog = new ServiceLog($db);
            $logId = $serviceLog->addServiceLog([
                'customer_id' => $message['data']['customer_id'],
                'client_id' => $has['client_id'],
                'customer_name' => $message['data']['customer_name'].'_04',
                'customer_avatar' => $message['data']['customer_avatar'],
                'customer_ip' => $message['data']['customer_ip'],
                'kefu_code' => ltrim($message['data']['kefu_code'], 'KF_'),
                'seller_code' => $message['data']['seller_code'],
                'start_time' => date('Y-m-d H:i:s'),
                'protocol' => 'ws'
            ]);

            // 通知客服连接访客
            $message['data']['log_id'] = $logId['data'];

            // 记录服务数据
            $service = new Service($db);
            $service->addServiceCustomer(ltrim($message['data']['kefu_code'], 'KF_'), $message['data']['customer_id'],
                $logId['data'], $has['client_id']);

            // 更新访客表
            $customerModel = new Customer($db);
            $customerModel->updateCustomer([
                'customer_id' => $message['data']['customer_id'],
                'seller_code' => $message['data']['seller_code'],
                'pre_kefu_code' => ltrim($message['data']['kefu_code'], 'KF_')
            ]);

            // 从队列中移除访客
            $queue = new Queue($db);
            $queue->removeCustomerFromQueue($message['data']['customer_id'], $has['client_id']);

            // 通知访客
            try {

                Gateway::sendToUid($message['data']['customer_id'], json_encode([
                    'cmd' => 'linkByKF',
                    'data' => [
                        'kefu_code' => $message['data']['kefu_code'],
                        'kefu_name' => $message['data']['kefu_name']
                    ]
                ]));

                // 通知客服动态删除访客列表
                $onlineKeFu = $db->select('*')->from('v2_kefu')
                    ->where('seller_code="' . $message['data']['seller_code'] . '" AND `online_status`=1')
                    ->query();
                foreach ($onlineKeFu as $key => $vo) {
                    if ($vo['kefu_code'] == $message['data']['kefu_code']) {
                        continue;
                    }
                    Gateway::sendToUid('KF_' . $vo['kefu_code'], json_encode([
                        'cmd' => 'removeQueue',
                        'data' => [
                            'customer_id' => $message['data']['customer_id']
                        ]
                    ]));
                }
            } catch (\Exception $e) {

                Gateway::sendToClient($clientId, json_encode([
                    'cmd' => 'linkKFCB',
                    'data' => [
                        'code' => 404,
                        'data' => '',
                        'msg' => '接待失败'
                    ]
                ]));

                return ;
            }
        } catch (\Exception $e) {

            Gateway::sendToClient($clientId, json_encode([
                'cmd' => 'linkKFCB',
                'data' => [
                    'code' => 405,
                    'data' => $e->getMessage(),
                    'msg' => '接待失败'
                ]
            ]));

            return ;
        }

        Gateway::sendToClient($clientId, json_encode([
            'cmd' => 'linkKFCB',
            'data' => [
                'code' => 0,
                'data' => [
                    'customer_id' => $message['data']['customer_id'],
                    'client_id' => $has['client_id'],
                    'customer_name' => $message['data']['customer_name'],
                    'customer_avatar' => $message['data']['customer_avatar'],
                    'customer_ip' => $message['data']['customer_ip'],
                    'protocol' => 'ws',
                    'create_time' => date('Y-m-d H:i:s'),
                    'log_id' => $logId['data']
                ],
                'msg' => '接待成功'
            ]
        ]));
    }

    /**
     * 评价客服
     * @param $clientId
     * @param $data
     */
    public static function praiseKf($clientId, $data)
    {
        $message = json_decode($data, true);

        if (1 == Gateway::isUidOnline($message['data']['customer_id'])) {
            Gateway::sendToUid($message['data']['customer_id'], json_encode([
                'cmd' => 'praiseKf',
                'data' => [
                    'service_log_id' => $message['data']['service_log_id']
                ]
            ]));

            Gateway::sendToClient($clientId, json_encode([
                'cmd' => 'praiseKfCB',
                'data' => [
                    'code' => 0,
                    'data' => [],
                    'msg' => '发送成功'
                ]
            ]));
        } else {

            Gateway::sendToClient($clientId, json_encode([
                'cmd' => 'praiseKfCB',
                'data' => [
                    'code' => -1,
                    'data' => [],
                    'msg' => '访客已经离线'
                ]
            ]));
        }
    }

    /**
     * 访客正在输入
     * @param $data
     * @param $ws
     */
    public static function typing($data)
    {
        $message = json_decode($data, true);
        if (1 == Gateway::isUidOnline($message['data']['to_id'])) {
            Gateway::sendToUid($message['data']['to_id'], json_encode([
                'cmd' => 'typing',
                'data' => [
                    'name' => $message['data']['from_name'],
                    'avatar' => $message['data']['from_avatar'],
                    'id' => $message['data']['from_id'],
                    'time' => date('Y-m-d H:i:s'),
                    'content' => $message['data']['content']
                ]
            ]));
        }
    }

    /**
     * 客户端退出
     * @param $clientId
     * @param $db
     */
    public static function disConnect($clientId, $db)
    {
        $uid = $_SESSION['id'];
        // 客服刷新不删除客服标识
        if (strstr($uid, "KF_") !== false) {
            return;
        }

        // 通知该访客的客服，置灰头像
        $service = new Service($db);
        $keFu = $service->findNowServiceKeFu($uid, $clientId);
        if(0 != $keFu['code'] || empty($keFu['data'])) {
            // 从队列中移除访客
            $queue = new Queue($db);
            $queue->removeCustomerFromQueue($uid, $clientId);

            $customer = new Customer($db);
            $customer->updateStatusByClient($uid, $clientId);

            return ;
        }

        if (1 == Gateway::isUidOnline('KF_' . $keFu['data']['kefu_code'])) {
            Gateway::sendToUid('KF_' . $keFu['data']['kefu_code'], json_encode([
                'cmd' => 'offline',
                'data' => [
                    'customer_id' => $uid
                ]
            ]));
        }

        // 更新服务时间
        $serviceLog = new ServiceLog($db);
        $serviceLog->updateEndTime($keFu['data']['service_log_id']);

        // 更新访客状态
        $customer = new Customer($db);
        $customer->updateCustomerStatus($uid, $keFu['data']['kefu_code']);

        // 移除正在服务的状态
        $service->removeServiceCustomer($keFu['data']['service_id']);
    }

    /**
     * 消息撤回
     * @param $data
     * @param $db
     */
    public static function rollBackMessage($data, $db)
    {
        $message = json_decode($data, true);

        // TODO 这里消息直接做物理删除，需要软删除的自己扩展
        $chatLog = new Chat($db);
        $chatLog->deleteMsg($message['data']['mid'], $message['data']['kid'], $message['data']['uid']);

        if (1 == Gateway::isUidOnline($message['data']['uid'])) {
            Gateway::sendToUid($message['data']['uid'], json_encode([
                'cmd' => 'rollBackMessage',
                'data' => [
                    'mid' => $message['data']['mid']
                ]
            ]));
        }
    }

    /**
     * 写聊天日志
     * @param $data
     * @param $db
     * @return int|string
     */
    public static function writeChatLog($data, $db)
    {
        $chatLog = new Chat($db);
        return $chatLog->addChatLog([
            'from_id' => $data['from_id'],
            'from_name' => $data['from_name'],
            'from_avatar' => $data['from_avatar'],
            'to_id' => $data['to_id'],
            'to_name' => $data['to_name'],
            'seller_code' => $data['seller_code'],
            'content' => $data['content'],
            'create_time' => date('Y-m-d H:i:s')
        ]);
    }



    /**
     * 使用 cURL 提交 API 请求
     * @param string $url API 地址
     * @param array $data 提交数据 
     * @param array $headers 请求头（可选）
     * @return array 返回解析后的数据 
     */
    public static function callApi($url, $data = [], $headers = []) {
        
        $ch = curl_init();
        
        // 设置 cURL 选项
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // 禁用SSL验证（仅测试用）
        
        // 如果是 POST 请求 
        if (!empty($data)) {
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, is_array($data) ? json_encode($data) : $data);
            $headers[] = 'Content-Type: application/json';
        }
        
        // 添加请求头 
        if (!empty($headers)) {
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        }
        
        // 执行请求
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        // 检查错误
        if (curl_errno($ch)) {
            // throw new \Exception('cURL Error: ' . curl_error($ch));
            return [
                'status' => -1,
                'data' => '机器人请求失败'
            ];
        }
        
        curl_close($ch);
        
        // 解析 JSON 响应 
        $result = json_decode($response, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            return $response; // 如果不是 JSON，返回原始响应 
        }
        
        return [
            'status' => $httpCode,
            'data' => $result
        ];
    }
    

    /**
     * 获取 utf8 编码的字符串
     */
    function unicode_to_utf8($str) {
        return preg_replace_callback('/u([0-9a-fA-F]{4})/', function($match) {
            return mb_convert_encoding(pack('H*', $match[1]), 'UTF-8', 'UCS-2BE');
        }, $str);
    }


    /**
     * Socket 握手信息
     */
    public static function pingPong($clientId, $data, $db)
    {
        $data = json_decode($data, true);
        $customer = [
            'customer_id' => $data['data']['uid'],
            'seller_code' => $data['data']['seller'],
            'appcode' => $data['data']['appcode'],
        ];

        // 尝试分配新访客进入服务
        $distributionModel = new Distribution($db);
        $dsInfo = $distributionModel->customerDistribution($customer);

        switch ($dsInfo['code']) {

            case 200:
                // 有人工客服在线
                Gateway::sendToClient($clientId, json_encode([
                    'cmd' => 'pong',
                    'data' => true,
                    // 'msg' => json_encode($dsInfo)
                ]));
                break;
            case 201:
                // 没有人工客服在线
                Gateway::sendToClient($clientId, json_encode([
                    'cmd' => 'pong',
                    'data' => false,
                    // 'msg' => json_encode($dsInfo)
                ]));
                break;
        }
    }


    /**
     * 判断 如果 Dify App 未创建 AppKey 则创建 AppKey
     */
    public static function createDifyAppKey($app_id, $db)
    {   
        #region 1、查询 Dify 中 管理员 账号信息
        // 1、查询 Dify 中 管理员 账号信息
        $sql_account = 'SELECT email from accounts as a WHERE a."id" = (select account_id from tenant_account_joins WHERE "role" = $1 LIMIT 1);';
        // 1、sql 参数
        $sql_param = [
            'role' => 'owner'
        ];
        $distributionModel = new Distribution($db);
        $admin_account_list = $distributionModel->selDifyApp_DataList($sql_account, $sql_param);
        if (count($admin_account_list)<1) {
            return null;
        }
        #endregion

        #region 2、登录 Dify 获取 登录用户 token
        // 2、登录 Dify 获取 登录用户 token
        $email = $admin_account_list[0]['email'];
        $headers = 
        [
            'Content-Type: application/json', 
        ];
        $postDifyUrl = $_SESSION['sysconfigList'][2]['web_url'].'/console/api/login';
        $postData = 
        [
            'email' => $email, 
            'password' => ENVCONST['loginDify_PassWord'], //配置文件密码
            'language' => 'zh-Hans',
            'remember_me' => true,
        ]; 
        $result = self::callApi($postDifyUrl, $postData, $headers);
        #endregion

        // return $result;

        #region 3、不存在则 调用API接口 创建 一个 AppKey
        // 3、不存在则 调用API接口 创建 一个 AppKey
        if ($result['status'] == 200) {
            $postDifyUrl_CreateKey = $_SESSION['sysconfigList'][2]['web_url'].'/console/api/apps/'.$app_id.'/api-keys';
            $authorization_CreateKey = 'Bearer '.$result['data']['data']['access_token'];
            $headers_CreateKey = 
            [
                'Content-Type: application/json', 
                'Authorization: '. $authorization_CreateKey,
            ];
            $result_CreateKey = self::callApi($postDifyUrl_CreateKey, $postData, $headers_CreateKey);
            return $result_CreateKey;
        }

        return null;


        #endregion

    }


}