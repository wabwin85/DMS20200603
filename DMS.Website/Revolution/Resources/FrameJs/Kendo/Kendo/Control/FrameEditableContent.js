(function ($) {
    //FrameEditableContent Start
    $.fn.FrameEditableContent = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameEditableContent.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var my = $(this);

            var setting = $.extend({}, $.fn.FrameEditableContent.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameEditableContent.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            if (!setting.readonly) {
                //DOM
                var dom = $('<div contenteditable="' + setting.editType + '" class="editable-content k-textbox ' + setting.className + '" style="' + setting.style + '"></div>');
                dom.css({
                    "overflow-y": "auto",
                    "min-height": setting.minHeight,
                    "max-height": setting.maxHeight
                });

                $(this).append(dom);

                //Value
                my.find(".editable-content").html(setting.value);

                //Change
                //TODO Change

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            } else {
                //DOM
                var dom = $('<span class="frame-label" style="width: 100%;" />');

                $(this).append(dom);

                //Value
                my.find(".frame-label").html(setting.value);
            }
        }
    };

    $.fn.FrameEditableContent.defaults = $.extend({}, {
        type: 'FrameEditableContent',
        editType: 'true',
        style: "width: 100%;",
        className: '',
        minHeight: '30px',
        maxHeight: '300px',
        value: '',
        readonly: false,
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameEditableContent.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                $(my).find(".editable-content").html(value);
            } else {
                $(my).find(".frame-label").html(value);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $.trim($(my).find(".editable-content").html());
            } else {
                return $(my).data('value');
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $(my).find(".editable-content").attr("contenteditable", "false");
                $(my).find(".editable-content").attr("disabled", true);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $(my).find(".editable-content").attr("contenteditable", $(my).data('editType'));
                $(my).find(".editable-content").removeAttr("disabled");
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameEditableContent End
})(jQuery);