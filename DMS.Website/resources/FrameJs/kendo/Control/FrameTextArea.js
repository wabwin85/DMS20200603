(function ($) {
    //FrameTextArea Start
    $.fn.FrameTextArea = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameTextArea.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameTextArea.defaults, param1);
            $('#' + controlId).data({
                type: 'TextArea'
            });

            $('#' + controlId).empty();

            //DOM
            var e = document.createElement("textarea");
            e.id = controlId + '_Control';
            e.style.cssText = setting.style;
            if (setting.resize == false) {
                e.style.resize = 'none';
            }
            e.className = 'k-textbox ' + setting.className;
            e.rows = setting.rows;
            $('#' + controlId).append(e);

            $('#' + controlId + '_Control').height(setting.height);

            //Value
            $('#' + controlId + '_Control').val(setting.value);

            //Change
            if (typeof (setting.onChange) != 'undefined') {
                $('#' + controlId + '_Control').unbind('change');
                $('#' + controlId + '_Control').on('change', setting.onChange);
            }

            //Blur
            //TODO Blur

            //Focus
            //TODO Focus
        }
    };

    $.fn.FrameTextArea.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: '',
        value: '',
        resize: false,
        rows: 2,
        height: "auto",
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameTextArea.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').val(value);
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            return $('#' + controlId + '_Control').val();
        },
        setRows: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').attr("rows", value);
        },
        setHeight: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').height(value);
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').attr("disabled", true);
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').removeAttr("disabled");
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameTextArea End
})(jQuery);