<?php

namespace app\common\utils;

class JsonRes
{
    
    public static function success($msg = '',$data = '',$islang = 1)
    {
        if($islang == 1) {
            $msg = lang($msg);
        }
        return json(['code' => 0, 'data' => $data, 'msg' => $msg]);
    }

    public static function success_page($data = '',$total = 0)
    {
        return json(['code' => 0, 'msg' => 'ok','count' =>$total, 'data' => $data]);
    }

    public static function failed($msg = '',$code = -1,$islang = 1,$data='')
    {
        if($islang == 1) {
            $msg = lang($msg);
        }
        return json(['code' => $code, 'data' => $data, 'msg' =>$msg ]);
    }
}