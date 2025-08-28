<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/2/28
 * Time: 8:23 PM
 */
namespace app\seller\controller;

use app\common\utils\JsonRes;
use app\model\Seller;
use \app\seller\model\WebSite as WebSiteModel;
use app\seller\model\Group as GroupModel;
use app\seller\validate\KeFuValidate;
use app\seller\validate\WebSiteValidate;

class WebSite extends Base
{
    // 站点列表
    public function index()
    {
        if(request()->isAjax()) {

            $limit = input('param.limit');
            $Name = input('param.name');

            $where = [];
            if(!empty($Name)) {
                $where[] = ['web_name', 'like', '%' . $Name . '%'];
                //$where[] = ['web_url', 'like', '%' . $Name . '%'];
            }

            $webSite = new WebSiteModel();
            $list = $webSite->getWebList($limit, $where);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        return $this->fetch();
    }

    // 添加站点
    public function addWebSite()
    {
        if(request()->isPost()) {

            $param = input('post.');

            $canMake = ['code'=>0,'data'=>1];//(new Seller())->checkCanAddKeFu(session('seller_user_id'));
            if (0 != $canMake['code']) {
                return ['code' => -4, 'data' => '', 'msg' => '系统错误'];
            }

            if (empty($canMake['data'])) {
                return ['code' => -5, 'data' => '', 'msg' => '站点数量已达上限，请联系管理员增加'];
            }

            $validate = new WebSiteValidate();
            if(!$validate->check($param)) {
                return ['code' => -3, 'data' => '', 'msg' => $validate->getError()];
            }
            $data['web_name'] = $param['web_name'];
            $data['web_url'] =  $param['web_url'];
            $data['seller_id'] = session('seller_user_id');

            $webSite = new WebSiteModel();
            $res = $webSite->addWebSite($data);
            if(0 != $res['code']) {
                return $res;
            }

            //return JsonRes::success('',$res);
            return JsonRes::success($res['msg']);
        }

        $group = new GroupModel();
        $this->assign([
            'group' => $group->getSellerGroup()['data']
        ]);

        return $this->fetch('add');
    }

    // 编辑站点
    public function editWebSite()
    {
        $site = new WebSiteModel();

        if(request()->isPost()) {
            $param = input('post.');

            if($param['web_id'] == 0){
                $validate = new WebSiteValidate();
                if(!$validate->check($param)) {
                    return ['code' => -3, 'data' => '', 'msg' => $validate->getError()];
                }
                $param['seller_id'] = session('seller_user_id');
                $param['web_code'] = uniqid();
                $res = $site->addWebSite($param);
                if(0 != $res['code']) {
                    return $res;
                }
            }
            else{
                $res = $site->editWebSite($param);
                if(0 != $res['code']) {
                    return $res;
                }
            }
            return JsonRes::success($res['msg']);
            //return JsonRes::success('',$res['data'],$res['msg']);
            //return JsonRes::success('',$res);
        }

        $webId = input('param.web_id','0');
        $siteEnt = $site->getWebSiteById($webId)['data'];

        if(empty($siteEnt)){
            $siteEnt = [
                'web_id' => 0,
            ];
        }
        $this->assign([
            'website' => $siteEnt,
        ]);

        return $this->fetch('edit');
    }

    // 删除客服
    public function delWebSite()
    {
        if(request()->isAjax()) {

            $webId = input('param.web_id');
            $webSiteModel = new WebSiteModel();

            $res = $webSiteModel->delWebSite($webId);

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
                return JsonRes::success_page($base,5);
            } catch (\Exception $e) {
                return JsonRes::success_page([],0);
            }
        }

        $this->assign([
            'start' => date('Y-m') . '-01',
            'end' => date('Y-m-d')
        ]);

        return $this->fetch('all');
    }
}