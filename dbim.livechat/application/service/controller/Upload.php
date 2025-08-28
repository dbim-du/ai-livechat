<?php
/**
 * Created by PhpStorm.
 * User: 1609123282
 * Date: 2019/2/27
 * Time: 16:58
 */
namespace app\service\controller;

use app\common\utils\JsonRes;

class Upload extends Base
{
    //上传图片
    public function uploadImg()
    {
        $file = request()->file('file');

        $fileInfo = $file->getInfo();

        // 检测图片格式
        $ext = explode('.', $fileInfo['name']);
        $ext = array_pop($ext);

        $extArr = explode('|', 'jpg|png|gif|jpeg');
        if(!in_array($ext, $extArr)){
            return JsonRes::failed('只能上传jpg|png|gif|jpeg的文件',-3);
        }

        // 移动到框架应用根目录/public/uploads/ 目录下
        $info = $file->move('./uploads');
        if($info){
            $src =  '/uploads' . '/' . date('Ymd') . '/' . $info->getFilename();
            return JsonRes::success('',['src'=> $src]);
        }else{
            // 上传失败获取错误信息
            return JsonRes::failed($file->getError(),-1);
        }
    }

    //上传文件
    public function uploadFile()
    {
        $file = request()->file('file');

        $fileInfo = $file->getInfo();

        // 检测图片格式
        $ext = explode('.', $fileInfo['name']);
        $ext = array_pop($ext);

        $extArr = explode('|', 'zip|rar|txt|doc|docx|xls|xlsx');
        if(!in_array($ext, $extArr)){
            return JsonRes::failed('只能上传zip|rar|txt|doc|docx|xls|xlsx的文件',-3);
        }

        // 移动到框架应用根目录/public/uploads/ 目录下
        $info = $file->move('./uploads');
        if($info){
            $src =  '/uploads' . '/' . date('Ymd') . '/' . $info->getFilename();
            return JsonRes::success('',['src' => $src, 'name' => $fileInfo['name'] ]);
        }else{
            // 上传失败获取错误信息
            return JsonRes::failed($file->getError(),-1);
        }
    }
}