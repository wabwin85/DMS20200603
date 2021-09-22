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
            if (!setting.value) {
                setting.value = $.fn.FrameTextArea.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            if (!setting.readonly) {
                //DOM
                var html = '';
                html += '<textarea id="' + controlId + '_Control" class="k-textbox ' + setting.className + '" style="' + setting.style + '" rows="' + setting.rows + '"></textarea>';

                $(this).append(html);

                if (setting.resize == false) {
                    $('#' + controlId + '_Control').css('resize', 'none');
                }

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
            } else {
                var e = $.fn.FrameSpan(controlId + '_Control');
                $(this).append(e);

                //Value
                $('#' + controlId + '_Control').html(setting.value);
            }
        }
    };

    $.fn.FrameTextArea.defaults = $.extend({}, {
        type: 'FrameTextArea',
        style: "width: 100%; ",
        className: '',
        value: '',
        resize: false,
        rows: 2,
        height: "auto",
        readonly: false,
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameTextArea.methods = {
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
        setRows: function (my, value) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').attr("rows", value);
            }
        },
        setHeight: function (my, value) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').height(value);
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
        focus: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                var v = $('#' + controlId + '_Control').val();
                $('#' + controlId + '_Control').focus().val(v);
            }
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