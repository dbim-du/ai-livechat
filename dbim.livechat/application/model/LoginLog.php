<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/9/29
 * Time: 10:39 PM
 */
namespace app\model;

use think\facade\Log;
use think\Model;
use think\facade\Request;

class LoginLog extends Model
{
    protected $table = 'v2_login_log';

    /**
     * 写登录日志
     * @param $user
     * @param $status
     */
    public function writeLoginLog($user, $status)
    {
        try {
            if(ENVNAME == 'dev'){
                $area = '127.0.0.1';
            }else{
                $area = getLocationByIp(request()->ip());
            }
                $this->insert([
                    'login_user' => $user,
                    'login_ip' => request()->ip(),
                    'login_area' => $area,
                    'login_user_agent' => Request::header('user-agent'),
                    'login_time' => date('Y-m-d H:i:s'),
                    'login_status' => $status
                ]);
            } catch (\Exception $e) {
                Log::error($e->getMessage());
            }
    }

    /**
     * 登录日志明细
     * @param $limit
     * @return array
     */
    public function loginLogList($limit)
    {
        try {

            $log = $this->order('log_id', 'desc')->paginate($limit);
        } catch (\Exception $e) {
            Log::error($e->getMessage());
            return ['code' => -1, 'data' => '', 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => $log, 'msg' => 'ok'];
    }
}