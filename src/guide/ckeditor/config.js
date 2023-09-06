CKEDITOR.editorConfig = function (config) {
    // Define changes to default configuration here. For example:
    // config.language = 'fr';
    //  config.uiColor = '#53627d';
    //  config.extraPlugins = 'cloudservices';
    var base_url = $('head').data('baseurl');
    config.removePlugins = 'easyimage, cloudservices';

    config.toolbarGroups = [{
            name: 'clipboard',
            groups: ['clipboard', 'undo']
        },
        {
            name: 'editing',
            groups: ['find', 'selection', 'spellchecker', 'editing']
        },
        {
            name: 'document',
            groups: ['mode', 'document', 'doctools']
        },
        {
            name: 'forms',
            groups: ['forms']
        },
        {
            name: 'basicstyles',
            groups: ['basicstyles', 'cleanup']
        },
        {
            name: 'paragraph',
            groups: ['list', 'indent', 'blocks', 'align', 'bidi', 'paragraph']
        },
        {
            name: 'links',
            groups: ['links']
        },
        {
            name: 'insert',
            groups: ['insert']
        },
        {
            name: 'styles',
            groups: ['styles']
        },
        {
            name: 'colors',
            groups: ['colors']
        },
        {
            name: 'tools',
            groups: ['tools']
        },
        {
            name: 'others',
            groups: ['others']
        },
        {
            name: 'about',
            groups: ['about']
        }
    ];


    config.removeButtons = 'Anchor,HorizontalRule,PageBreak,Print,SelectAll,Find,Replace,Form,Checkbox,Radio,Flash,IFrame,Smiley,Preview,PasteText,PasteFromWord,Scayt,TextField,Textarea,Select,Button,ImageButton,HiddenField,HiddenField,CopyFormatting,RemoveFormat,About,NewPage,Save,Language,Iframe,SpecialChar';

    config.filebrowserBrowseUrl = base_url + '/ckfinder/ckfinder.html';

    // config.filebrowserImageBrowseUrl = base_url + '/ckfinder.html?type=Images';

    // config.filebrowserFlashBrowseUrl = base_url + '/ckfinder.html?type=Flash';

    config.filebrowserUploadUrl = base_url + '/public/ckfinder/core/connector/php/connector.php?command=QuickUpload&type=Files';

    config.filebrowserImageUploadUrl = base_url + '/public/ckfinder/core/connector/php/connector.php?command=QuickUpload&type=Images';

    config.filebrowserFlashUploadUrl = base_url + '/public/ckfinder/core/connector/php/connector.php?command=QuickUpload&type=Flash';
    config.mathJaxLib = '//cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.4/MathJax.js?config=TeX-AMS_HTML';

};

CKEDITOR.config.allowedContent = true;
