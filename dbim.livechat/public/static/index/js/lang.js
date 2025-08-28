var langDic = {
    'zh-cn':'简体中文',
    'en-us':'English',
};
var langKey = 'lang';

var getLang = function(){
    var lang = 'zh-cn';

    if(!$.cookie(langKey))
        return lang;

    var clang = $.cookie(langKey);
    if(!langDic[clang])
        return lang;
    return  clang;
};
var setLang = function(lang){
    $.cookie(langKey, lang,{path:'/',expires:36500});
}

var lang = getLang();
$('.lang-main-link span').html(langDic[lang]);

$(".lang-right").mouseover(function(){
    $(this).find('.lang-menu').show();
});
$(".lang-right").mouseout(function(){
    $(this).find('.lang-menu').hide();
});
$('.lang-menu li a').mouseover(function() {
    $(this).addClass('lang-link-active');
})
$('.lang-menu li a').mouseout(function() {
    $(this).removeClass('lang-link-active');
})

$('.lang-menu li a').click(function(){
    var langCode = $(this).attr('lang');
    setLang(langCode);
    window.location.reload();
})



