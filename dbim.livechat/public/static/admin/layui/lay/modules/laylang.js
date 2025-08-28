layui.define(['jquery','cookie'], function(exports){
    var langKey = 'lang';

    var $ = layui.jquery;


    var laylang = {
        getLang : function(){
            if($.cookie(langKey))
                return $.cookie(langKey);
            return 'zh-cn';
        },
        setLang:function(lang){
            $.cookie(langKey, lang,{path:'/',expires:36500});
        }
    };

    exports('laylang', laylang);
});