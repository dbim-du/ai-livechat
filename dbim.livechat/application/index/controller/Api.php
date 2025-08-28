<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/3/28
 * Time: 8:33 PM
 */
namespace app\index\controller;

use app\common\utils\JsonRes;
use app\model\Chat;
use think\Controller;
use app\model\Group;
use app\model\KeFu;
use app\model\KeFuWeb;
use app\model\Seller;
use app\model\Service;
use app\seller\model\DifyData;

class Api extends Controller
{
    // 获取空闲客服
    public function getFreeKeFu()
    {
        $sellerCode = input('param.code');

        $sellerModel = new Seller();
        $info = $sellerModel->getSellerInfo($sellerCode);

        if(0 != $info['code'] || empty($info['data'])) {
            return JsonRes::failed('商户不存在',-1);
        }

        if(0 == $info['data']['seller_status']) {
            return JsonRes::failed('商户被禁用',-2);
        }

        $groupModel = new Group();
        $groupInfo = $groupModel->getFirstServiceGroup($info['data']['seller_id']);
        if(0 != $groupInfo['code'] || empty($groupInfo['data'])) {
            return JsonRes::failed('该商户下没配置前置服务组',-3);
        }

        $kefu = new KeFu();
        $kefuInfo = $kefu->getOnlineKeFuByGroup($groupInfo['data']['group_id']);
        if(0 != $kefuInfo['code']) {
            return JsonRes::failed('查询分组客服失败',-4);
        }

        if(empty($kefuInfo['data'])) {
            return JsonRes::failed('暂无客服上班',-5);
        }

        $serviceKefu = [];
        $service = new Service();
        foreach($kefuInfo['data'] as $key => $vo) {

            $num = $service->getNowServiceNum($vo['kefu_code']);
            if(0 != $num['code']) {
                return JsonRes::failed('获取当前服务数据失败',-6);
                break;
            }

            $serviceKefu[$key] = [
                'kefu_code' => $vo['kefu_code'],
                'kefu_name' => $vo['kefu_name'],
                'kefu_avatar' => $vo['kefu_avatar'],
                'free_degree' => round(($vo['max_service_num'] - $num['data']) / $vo['max_service_num'], 2) // 空闲度 0.xx
            ];
        }

        // 寻找最空闲的客服
        $returnKefu = [];
        if(!empty($serviceKefu)) {

            $returnKefu = $serviceKefu[0];
            foreach($serviceKefu as $key => $vo) {

                if(0 == $vo['free_degree']) {
                    continue;
                }

                if($vo['free_degree'] > $returnKefu['free_degree']) {
                    $returnKefu = $vo;
                }
            }
        }

        if($returnKefu['free_degree'] <= 0) {
            return JsonRes::failed('客服全忙',-7);
        }
        unset($returnKefu['free_degree']);

        $returnKefu['kefu_code'] = 'KF_' . $returnKefu['kefu_code'];
        $returnKefu['seller_code'] = $sellerCode;

        return JsonRes::failed('ok',200,1,$returnKefu);
    }

    // 客服发消息给 接口端
    public function send2Customer()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $this->curlPost(config('service_socketio.api_url'), $param);

            // 记录聊天日志
            $chatLog = new Chat();
            $chatLogId = $chatLog->addChatLog([
                'from_id' => $param['data']['from_id'],
                'from_name' => $param['data']['from_name'],
                'from_avatar' => $param['data']['from_avatar'],
                'to_id' => $param['data']['to_id'],
                'to_name' => $param['data']['to_name'],
                'seller_code' => $param['data']['seller_code'],
                'content' => $param['data']['content'],
                'create_time' => date('Y-m-d H:i:s'),
                'read_flag' => 2 // 已读
            ]);
            return JsonRes::success('ok',$chatLogId);
        }
    }

    /**
     * 处理转接
     * @return \think\response\Json
     */
    public function doRelink()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $port = config('service_socketio.http_port');
            $relinkInfo = $this->curlPost('http://127.0.0.1:' . $port, $param);
            $relinkInfo = json_decode($relinkInfo, true);

            // 通知转接车成功
            $this->curlPost(config('service_socketio.api_url'), $relinkInfo['data']);

            return JsonRes::success('转接成功');
        }
    }

    /**
     * 处理主动关闭访客
     * @return \think\response\Json
     */
    public function closeUser()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $port = config('service_socketio.http_port');
            $returnInfo = $this->curlPost('http://127.0.0.1:' . $port, $param);
            $returnInfo = json_decode($returnInfo, true);

            // 通知关闭消息
            $this->curlPost(config('service_socketio.api_url'), $returnInfo['data']);

            return JsonRes::success('关闭成功');
        }
    }

    /**
     * 获取商户下的指定分组客服
     * @return \think\response\Json
     */
    public function getSellerKeFuByGroup()
    {
        // $groupId = input('param.group_id');
        // $seller = input('param.seller_code');
        $appcode = input('param.appcode');

        $list = [];

        $keFuModel = new KeFu();
        $KeFuWebModel = new KeFuWeb();
        $difyDataModel = new DifyData();

        // 1、查询 dify app 对应信息
        $difyApp = $difyDataModel->selDifyApp($appcode);
        if ($difyApp!=null) {
            // 2、查询 对应 App 权限的 客服ID列表
            $kefuWebList_kfId = $KeFuWebModel->getKeFuWebList($difyApp['app_id']);
            if ($kefuWebList_kfId['code'] == 0) {
                // 3、根据查询出的 kfId 列表，查询出客服信息
                $list_Data = $keFuModel->getSellerKeFuByApp(array_column($kefuWebList_kfId['data'],'kf_id'));
                // $list_Data = $keFuModel->getSellerKeFuByApp($kefuWebList_kfId['data']);
                $list = $list_Data['data'];
                
                // $list = array_column($kefuWebList_kfId['data'],'kf_id');
            }
            

            
        }
        // $list = $keFuModel->getSellerKeFuByGroup($seller, $groupId, $appcode);
        
        return JsonRes::success('success',$list);
    }

    /**
     * curl post
     * @param $url
     * @param $param
     * @return mixed
     */
    private function curlPost($url, $param)
    {
        $ch = curl_init();
        curl_setopt ($ch, CURLOPT_URL, $url);
        curl_setopt ($ch, CURLOPT_POST, 1);
        curl_setopt ($ch, CURLOPT_HEADER, 0);
        curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt ($ch, CURLOPT_POSTFIELDS, http_build_query($param));
        $return = curl_exec($ch);
        curl_close ($ch);

        return $return;
    }
}