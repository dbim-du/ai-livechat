<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Email: 2097984975@qq.com
 * Date: 2020/7/5
 * Time: 10:07 PM
 */
namespace app\service\controller;

use app\common\utils\JsonRes;
use app\model\KeFuCate;

class Cate extends Base
{
    public function addKeFuCate()
    {
        if (request()->isPost()) {

            $param = input('post.');

            if (empty($param)) {
                return JsonRes::failed('请输入分类名称',-1);
            }

            $cateModel = new KeFuCate();
            $has = $cateModel->getKeFuCateInfoByName($param['cate_name'], session('kf_seller_id'), session('kf_id'));
            if (0 != $has['code']) {
                return JsonRes::success('',$has);
            }

            if (!empty($has['data'])) {
                return JsonRes::failed('该分类已经存在',-2);
            }

            $res = $cateModel->addKeFuCate([
                'cate_name' => $param['cate_name'],
                'kefu_id' => session('kf_id'),
                'seller_id' => session('kf_seller_id'),
                'create_time' => date('Y-m-d H:i:s')
            ]);

            return JsonRes::success('',$res);
        }
    }

    public function editKeFuCate()
    {
        if (request()->isPost()) {

            $param = input('post.');

            if (empty($param['cate_name'])) {
                return JsonRes::failed('请输入分类名称',-1);
            }

            $cateModel = new KeFuCate();
            $has = $cateModel->getKeFuCateInfoByName($param['cate_name'], session('kf_seller_id'), session('kf_id'));
            if (0 != $has['code']) {
                return JsonRes::success('',$has);
            }

            if (!empty($has['data']) && $has['data']['cate_id'] != $param['cate_id']) {
                return JsonRes::failed('该分类已经存在',-2);
            }

            $res = $cateModel->editKeFuCate([
                'cate_name' => $param['cate_name']
            ], [
                'kefu_id' => session('kf_id'),
                'seller_id' => session('kf_seller_id'),
                'cate_id' => $param['cate_id']
            ]);

            return JsonRes::success('',$res);
        }
    }

    public function delKeFuCate()
    {
        if (request()->isPost()) {

            $cateId = input('post.cate_id');
            $cateModel = new KeFuCate();

            $res = $cateModel->delKeFuCate([
                'kefu_id' => session('kf_id'),
                'seller_id' => session('kf_seller_id'),
                'cate_id' => $cateId
            ]);

            return JsonRes::success('',$res);
        }
    }
}