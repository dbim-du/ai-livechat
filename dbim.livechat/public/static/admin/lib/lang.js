layui.define(['form','jquery','cookie','laylang'], function(){
    var form = layui.form;
    var laylang = layui.laylang;

    var langKey = 'lang';

    var $ = layui.jquery;

    var langDic = {
        'zh-cn':'简体中文',
        'en-us':'English',
    };


    if($('#lang-nav').length > 0){
        function showCurLang(){
            var curLang =laylang.getLang();
            var text = langDic[curLang];
            $('#lang-nav').find('.show-lang').html(text);
        };
        showCurLang();

        $('#lang-nav .layui-nav-child dd a').click(function(){
            var langCode = $(this).attr('data-code');
            laylang.setLang(langCode);
            window.location.reload();
        });


    }

    if(document.getElementById('languageselect')!=undefined){
        document.getElementById('languageselect').value = laylang.getLang();
        form.render('select(language)');
        // 监听语言切换的选择事件
        form.on('select(language)', function(data){
            var language = data.value;
            laylang.setLang(language);
            console.log(language);
            window.location.reload();
        });
    }
});