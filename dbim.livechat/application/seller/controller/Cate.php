<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2019/3/2
 * Time: 7:28 PM
 */
namespace app\seller\controller;

use app\common\utils\JsonRes;
use app\seller\model\Word;

class Cate extends Base
{
    // 常用语列表
    public function index()
    {
        if(request()->isAjax()) {

            $limit = input('param.limit');
            $cateName = input('param.cate_name');
            $where = [];

            if (!empty($cateName)) {
                $where[] = ['cate_name', '=', $cateName];
            }

            $cateModel = new \app\seller\model\Cate();
            $list = $cateModel->getCateList($limit, $where);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        return $this->fetch();
    }

    // 添加常用语分类
    public function add()
    {
        if(request()->isPost()) {

            $param = input('post.');

            if(!isset($param['cate_name']) || empty($param['cate_name'])) {
                return JsonRes::failed('请输入分类名称',-1);
            }

            $param['seller_id'] = session('seller_user_id');
            isset($param['status']) ? $param['status']= 1 : $param['status'] = 2;

            $cateModel = new \app\seller\model\Cate();
            $res = $cateModel->addCate($param);
            return JsonRes::success($res['msg']);
        }

        return $this->fetch('add');
    }

    // 编辑常用语
    public function edit()
    {
        $cateModel = new \app\seller\model\Cate();

        if(request()->isPost()) {

            $param = input('post.');

            if(!isset($param['cate_name']) || empty($param['cate_name'])) {
                return JsonRes::failed('请输入分类名称',-1);
            }

            isset($param['status']) ? $param['status']= 1 : $param['status'] = 2;

            $cateModel = new \app\seller\model\Cate();
            $res = $cateModel->editCate($param);
            return JsonRes::success($res['msg']);
        }

        $cateId = input('param.cate_id');

        $this->assign([
            'cate' => $cateModel->getCateInfoByCateId($cateId)['data']
        ]);

        return $this->fetch('edit');
    }

    // 删除常用语
    public function del()
    {
        if(request()->isAjax()) {

            $cateId = input('param.cate_id');
            $cateModel = new \app\seller\model\Cate();

            $res = $cateModel->delCate($cateId);
            return JsonRes::success($res['msg']);
        }
    }
}