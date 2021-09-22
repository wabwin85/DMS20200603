(function ($) {
    //FrameTextBox Start
    $.fn.FrameTextBox = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameTextBox.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameTextBox.defaults, param1);
            $('#' + controlId).data({
                type: 'TextBox'
            });

            $('#' + controlId).empty();

            //DOM
            var e = document.createElement("input");
            e.id = controlId + '_Control';
            if (setting.password) {
                e.type = 'password';
            } else {
                e.type = 'text';
            }
            e.style.cssText = setting.style;
            e.className = 'k-textbox ' + setting.className;
            $('#' + controlId).append(e);

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

    $.fn.FrameTextBox.defaults = $.extend({}, {
        style: "width: 100%; ",
        password: false,
        className: '',
        value: '',
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameTextBox.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').val(value);
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            return $('#' + controlId + '_Control').val();
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
    //FrameTextBox End
})(jQuery);