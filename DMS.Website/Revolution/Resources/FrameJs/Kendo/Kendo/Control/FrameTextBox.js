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
            if (!setting.value) {
                setting.value = $.fn.FrameTextBox.defaults.value;
            }
            if (!setting.dataSource) {
                setting.dataSource = $.fn.FrameRadio.defaults.dataSource;
            }
            $(this).data(setting);

            $(this).empty();
            
            if (!setting.readonly) {
                //DOM
                var html = '';
                html += '<input id="' + controlId + '_Control" class="k-textbox ' + setting.className + '" style="' + setting.style + '" placeholder="' + setting.placeholder + '" />';

                $(this).append(html);

                if (setting.password) {
                    $('#' + controlId + '_Control').attr('type', 'password');
                } else {
                    $('#' + controlId + '_Control').attr('type', 'text');
                }

                //Value
                $('#' + controlId + '_Control').val(setting.value);

                //Change
                if (typeof (setting.onChange) != 'undefined') {
                    $('#' + controlId + '_Control').unbind('change');
                    $('#' + controlId + '_Control').on('change', setting.onChange);
                }

                //Keyup
                if (typeof (setting.onKeyup) != 'undefined') {
                    $('#' + controlId + '_Control').unbind('keyup');
                    $('#' + controlId + '_Control').on('keyup', setting.onKeyup);
                }

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            } else {
                var e = $.fn.FrameSpan(controlId + '_Control');
                $(this).append(e);

                //Value
                $('#' + controlId + '_Control').html(setting.value);
            }
        }
    };

    $.fn.FrameTextBox.defaults = $.extend({}, {
        type: 'FrameTextBox',
        style: "width: 100%; ",
        password: false,
        className: '',
        placeholder: '',
        value: '',
        readonly: false,
        onChange: function () { },
        onKeyup: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameTextBox.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').val(value);
            } else {
                $('#' + controlId + '_Control').html(value);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                return $.trim($('#' + controlId + '_Control').val());
            } else {
                return $(my).data('value');
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').attr("disabled", true);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').removeAttr("disabled");
            }
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