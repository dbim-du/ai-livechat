layui.use(['form','jquery','cookie'], function(){
    var form = layui.form;
    var langKey = 'lang';

    var $ = layui.jquery;
    var cookie = layui.cookie;

    var langDic = {
        'zh-cn':'简体中文',
        'en-us':'English',
    };



    var getLang = function(){
        if($.cookie(langKey))
            return $.cookie(langKey);
        return 'zh-cn';
    };

    var setLang = function(lang){
        $.cookie(langKey, lang,{path:'/',expires:36500});
    }

    console.log($('#lang-nav').length);
    if($('#lang-nav').length > 0){
        function showCurLang(){
            var curLang =getLang();
            var text = langDic[curLang];
            $('#lang-nav').find('.show-lang').html(text);
        };
        showCurLang();

        $('#lang-nav .layui-nav-child dd a').click(function(){
            var langCode = $(this).attr('data-code');
            setLang(langCode);
            window.location.reload();
        });


    }

    if(document.getElementById('languageselect')!=null){
        document.getElementById('languageselect').value = getLang();
        form.render('select(language)');
        // 监听语言切换的选择事件
        form.on('select(language)', function(data){
            var language = data.value;
            setLang(language);
            console.log(language);
            window.location.reload();
        });
    }
});