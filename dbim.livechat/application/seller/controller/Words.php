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

class Words extends Base
{
    // 常用语列表
    public function index()
    {
        if(request()->isAjax()) {
            $limit = input('param.limit');
            $where = [];

            $word = new Word();
            $list = $word->getWordList($limit, $where);

            if(0 == $list['code']) {
                return JsonRes::success_page($list['data']->all(),$list['data']->total());
            }
            return JsonRes::success_page([],0);
        }

        return $this->fetch();
    }

    // 添加常用语
    public function addWord()
    {
        if(request()->isPost()) {

            $param = input('post.');

            if(!isset($param['word']) || empty($param['word'])) {
                return JsonRes::failed('请输入常用语',-1);
            }

            $param['seller_code'] = session('seller_code');

            $word = new Word();
            $res = $word->addWord($param);

            return JsonRes::success($res['msg']);
        }

        $cateModel = new \app\seller\model\Cate();
        $this->assign([
            'cate' => $cateModel->getSellerCate()['data']
        ]);

        return $this->fetch('add');
    }

    // 编辑常用语
    public function editWord()
    {
        $word = new Word();

        if(request()->isPost()) {

            $param = input('post.');

            if(!isset($param['word']) || empty($param['word'])) {
                return JsonRes::failed('请输入常用语',-1);
            }

            $res = $word->editWord($param);

            return JsonRes::success($res['msg']);
        }

        $cateModel = new \app\seller\model\Cate();
        $this->assign([
            'cate' => $cateModel->getSellerCate()['data'],
            'word' => $word->getWordInfoById(input('param.word_id'))['data']
        ]);

        return $this->fetch('edit');
    }

    // 删除常用语
    public function delWord()
    {
        if(request()->isAjax()) {

            $wordId = input('param.word_id');
            $word = new Word();

            $res = $word->delWord($wordId);

            return JsonRes::success($res['msg']);
        }
    }

    // 导入文件
    public function import()
    {
        if (request()->isPost()) {

            $param = input('post.');
            if (empty($param['words'])) {
                return JsonRes::failed('请上传文件',-1);
            }

            $words = file_get_contents(env('ROOT_PATH') . $param['words']);
            $wordModel = new Word();

            $res = $wordModel->batchAddWord($param['cate_id'], $words);

            return JsonRes::success($res['msg']);
        }

        $cateModel = new \app\seller\model\Cate();
        $this->assign([
            'cate' => $cateModel->getSellerCate()['data']
        ]);

        return $this->fetch();
    }

    // 上传文件
    public function uploadFile()
    {
        $file = request()->file('file');

        $fileInfo = $file->getInfo();

        // 检测图片格式
        $ext = explode('.', $fileInfo['name']);
        $ext = array_pop($ext);

        $extArr = explode('|', 'txt');
        if(!in_array($ext, $extArr)){
            return JsonRes::failed('只能上传txt格式的文件',-3);
        }

        // 移动到框架应用根目录/public/uploads/ 目录下
        $info = $file->move('./uploads');
        if($info){
            $src =  'public/uploads' . '/' . date('Ymd') . '/' . $info->getFilename();
            return JsonRes::success('',['src' => $src, 'name' => $fileInfo['name'] ]);
        }else{
            // 上传失败获取错误信息
            return JsonRes::failed($file->getError(),-1);
        }
    }
}