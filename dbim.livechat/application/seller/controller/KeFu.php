<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/28
 * Time: 8:23 PM
 */
namespace app\seller\controller;

use PDO;
use app\common\utils\JsonRes;
use app\model\Seller;
use app\seller\model\KeFu as KeFuModel;
use app\seller\model\Group as GroupModel;
use app\seller\model\KeFuWeb;
use app\seller\validate\KeFuValidate;
use app\seller\model\WebSite;
use think\Db;
use think\Exception;
use app\admin\model\sysconfigModel;
use app\seller\model\DifyData;

class KeFu extends Base
{
    // 客服列表
    public function index()
    {
        if(request()->isAjax()) {

            $limit = input('param.limit');
            $keFuName = input('param.kefu_name');
            $groupId = input('param.group_id');

            $where = [];
            if(!empty($keFuName)) {
                $where[] = ['a.kefu_name', 'like', '%' . $keFuName . '%'];
            }

            if(!empty($groupId)) {
                $where[] = ['a.group_id', '=', $groupId];
            }

            $keFu = new KeFuModel();
            $list = $keFu->getKeFuList($limit, $where);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }

            return JsonRes::success_page([],0);
        }

        

        $group = new GroupModel();
        $webSite = new WebSite();
        $this->assign([
            'group' => $group->getSellerGroup()['data'],
            'website'=>$webSite->WebListAll()['data'],
            'sysconfigList' => (new sysconfigModel())->getSysConfigList()['data']
        ]);

        return $this->fetch();
    }

     // 插入商家数据 到 dify
    public function addSellerToDify()
    {
        //var_dump(123456);
        //return JsonRes::failed('Dify 数据添加失败',-1);

        if(request()->isPost()) {
            $param = input('post.');
            try {
                if ((new DifyData())->insertDifyData($param['name'],$param['email'])) {
                    return JsonRes::success('操作成功');
                }
                return JsonRes::failed('Dify 用户可能已存在',-1);
            } catch (\Throwable $th) {
                return JsonRes::failed('Dify 数据添加失败',-1);
            }
        }
    }

    // 添加客服
    public function addKeFu()
    {
        // 插入 商家账户信息
        //(new DifyData())->insertDifyData($name,$email);
        // 已经插入数据 测试成功
        //(new DifyData())->insertDifyData('dalige7','455496757@qq.com');



        //echo "正在连接数据库...<br/>";
        if(request()->isPost()) {

            $param = input('post.');

            $canMake = (new Seller())->checkCanAddKeFu(session('seller_user_id'));
            if (0 != $canMake['code']) {
                return JsonRes::failed('系统错误',-4);
            }

            if (empty($canMake['data'])) {
                return JsonRes::failed('客服坐席数量已达上限，请联系管理员增加',-5);
            }

            $validate = new KeFuValidate();
            if (!$validate->check($param)) {
                return JsonRes::failed($validate->getError(),-3);
            }

            isset($param['kefu_status']) ? $param['kefu_status'] = 1 : $param['kefu_status'] = 0;
            $param['kefu_code'] = uniqid();
            $param['kefu_password'] = md5($param['kefu_password'] . config('service.salt'));
            $param['seller_id'] = session('seller_user_id');
            $param['seller_code'] = session('seller_code');
            
            // 如果选择的是 机器人客服 在线状态默认为 在线，机器人客服 不离线
            if ($param['kefy_type'] == 0) { // 机器人客服
                $param['online_status'] = 1;
            }else {
                $param['online_status'] = 0;
            }

            $webSites = $param['websites'];

            $keFu = new KeFuModel();
            $res = $keFu->addKeFu($param, $webSites);
            return $res;
        }

        // 系统配置
        $this->assign([
            'loginDify_PassWord' => ENVCONST['loginDify_PassWord'],
            'group' => (new GroupModel())->getSellerGroup()['data'],
            'sysconfigList' => (new sysconfigModel())->getSysConfigList()['data']
        ]);

        return $this->fetch('add');
    }

    // 编辑客服
    public function editKeFu()
    {
        if(request()->isPost()) {

            $param = input('post.');

            $validate = new KeFuValidate();
            if(!$validate->scene('edit')->check($param)) {
                return ['code' => -3, 'data' => '', 'msg' => $validate->getError()];
            }

            isset($param['kefu_status']) ? $param['kefu_status']= 1 : $param['kefu_status'] = 0;
            if(!empty(trim($param['kefu_password']))) {          
                $param['kefu_password'] = md5($param['kefu_password'] . config('service.salt'));
            } else {
            	unset($param['kefu_password']);
            }

            $webSites = $param['websites'];

            // 如果选择的是 机器人客服 在线状态默认为 在线，机器人客服 不离线
            if ($param['kefy_type'] == 0) {// 机器人客服
                $param['online_status'] = 1;
            }

            $keFu = new KeFuModel();
            $res = $keFu->editKeFu($param,$webSites);

            return JsonRes::success($res['msg']);
        }

        $keFuId = input('param.kefu_id');
        $keFu = new KeFuModel();
        $group = new GroupModel();
        $webSite = new WebSite();
        $kfWeb = new KeFuWeb();

        $kfWebData = $kfWeb->getKeFuWebList($keFuId)['data'];
        $this->assign([
            'loginDify_PassWord' => ENVCONST['loginDify_PassWord'],
            'kefu' => $keFu->getKeFuById($keFuId)['data'],
            'group' => $group->getSellerGroup()['data'],
            'website'=>$webSite->WebListAll()['data'],
            'kfWeb'=> json_encode($kfWebData) ,// 对象转 json 字符串 存储到前端隐藏域  //$kfWeb->getKeFuWebList($keFuId)['data'],
            'sysconfigList' => (new sysconfigModel())->getSysConfigList()['data']
        ]);

        return $this->fetch('edit');
    }

    // 删除客服
    public function delKeFu()
    {
        if(request()->isAjax()) {

            $keFuId = input('param.kefu_id');
            $keFu = new KeFuModel();

            $res = $keFu->delKeFu($keFuId);

            return JsonRes::success($res['msg']);
        }
    }

    // 点赞
    public function praise()
    {
        if(request()->isAjax()) {

            try {

                // 所有的客服
                $users = db('kefu')->field('kefu_code,kefu_name')->where('seller_code', session('seller_code'))->select();
                $userArr = [];
                foreach($users as $key => $vo) {

                    $userArr[$vo['kefu_code']]['kefu_code'] = $vo['kefu_code'];
                    $userArr[$vo['kefu_code']]['kefu_name'] = $vo['kefu_name'];
                    $userArr[$vo['kefu_code']]['star1'] = 0; // 非常不满意
                    $userArr[$vo['kefu_code']]['star2'] = 0; // 不满意
                    $userArr[$vo['kefu_code']]['star3'] = 0; // 一般
                    $userArr[$vo['kefu_code']]['star4'] = 0; // 满意
                    $userArr[$vo['kefu_code']]['star5'] = 0; // 非常满意
                }

                $start = input('param.start', date('Y-m') . '-01');
                $end = input('param.end', date('Y-m-d'));

                $result = db('praise')->where('add_time', '>=', $start)->where('add_time', '<=', $end . ' 23:59:59')
                    ->where('seller_code', session('seller_code'))
                    ->select();
                foreach($result as $key=>$vo) {
                    if(isset($userArr[$vo['kefu_code']])) {

                        switch ($vo['star']) {
                            case 1:
                                $userArr[$vo['kefu_code']]['star1'] += 1;
                                break;
                            case 2:
                                $userArr[$vo['kefu_code']]['star2'] += 1;
                                break;
                            case 3:
                                $userArr[$vo['kefu_code']]['star3'] += 1;
                                break;
                            case 4:
                                $userArr[$vo['kefu_code']]['star4'] += 1;
                                break;
                            case 5:
                                $userArr[$vo['kefu_code']]['star5'] += 1;
                                break;
                        }
                    }
                }

                $returnUser = [];
                foreach($userArr as $vo) {
                    $total = $vo['star5'] + $vo['star4'] + $vo['star3'] + $vo['star2'] + $vo['star1'];
                    if(0 == $total) {
                        $vo['percent'] = '0%';
                    }else {
                        $vo['percent'] = round(($vo['star5'] + $vo['star4']) / $total * 100, 2) . '%';
                    }

                    $returnUser[] = $vo;
                }
                return JsonRes::success_page($returnUser,count($userArr));
            } catch (\Exception $e) {
                return JsonRes::success_page([],0);
            }
        }

        $this->assign([
            'start' => date('Y-m') . '-01',
            'end' => date('Y-m-d')
        ]);

        return $this->fetch();
    }

    // 总体客服分析
    public function praiseAll()
    {
        if(request()->isAjax()){

            $start = input('param.start', date('Y-m') . '-01');
            $end = input('param.end', date('Y-m-d'));
            $base = [
                1 => ['title' => '非常不满意', 'star_total' => 0, 'percent' => '0%'],
                2 => ['title' => '不满意', 'star_total' => 0, 'percent' => '0%'],
                3 => ['title' => '一般', 'star_total' => 0, 'percent' => '0%'],
                4 => ['title' => '满意', 'star_total' => 0, 'percent' => '0%'],
                5 => ['title' => '非常满意', 'star_total' => 0, 'percent' => '0%']
            ];

            try {

                $result = db('praise')->field('count(*) as star_total, star')->where('add_time', '>=', $start)
                    ->where('add_time', '<=', $end . ' 23:59:59')
                    ->group('star')->order('star desc')->where('seller_code', session('seller_code'))->select();

                $total = 0;
                foreach($result as $key => $vo) {
                    if(array_key_exists($vo['star'], $base)) {
                        $base[$vo['star']]['star_total'] = $vo['star_total'];
                    }

                    $total += $vo['star'];
                }

                foreach($base as $key => $vo) {
                    if(0 != $total) {
                        $base[$key]['percent'] = round($vo['star_total'] / $total * 100, 2) . '%';
                    }
                }

                return json(['code' => 0, 'msg' => 'ok', 'count' => 5, 'data' => $base]);
            } catch (\Exception $e) {

                return json(['code' => 0, 'msg' => 'ok', 'count' => 0, 'data' => []]);
            }
        }

        $this->assign([
            'start' => date('Y-m') . '-01',
            'end' => date('Y-m-d')
        ]);

        return $this->fetch('all');
    }
}