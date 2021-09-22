(function ($) {
    //FrameNumeric Start
    $.fn.FrameNumeric = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameNumeric.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameNumeric.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameNumeric.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            if (!setting.readonly) {
                //DOM
                var html = '';
                html += '<input id="' + controlId + '_Control" type="number" class="' + setting.className + '" style="' + setting.style + '" />';

                $(this).append(html);

                $('#' + controlId + '_Control').kendoNumericTextBox({
                    decimals: setting.decimals,
                    format: setting.format,
                    max: setting.max,
                    min: setting.min,
                    spinners: setting.spinners,
                    step: setting.step,
                    placeholder: setting.placeholder,
                    value: setting.value
                });

                //Value
                //$('#' + controlId + '_Control').data("kendoNumericTextBox").value(setting.value);

                //Change
                if (typeof (setting.onChange) != 'undefined') {
                    $('#' + controlId + '_Control').unbind('change');
                    $('#' + controlId + '_Control').data("kendoNumericTextBox").setOptions({
                        change: setting.onChange
                    });
                }

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            } else {
                var e = $.fn.FrameSpan(controlId + '_Control');
                $(this).append(e);

                //Value
                $('#' + controlId + '_Control').html(kendo.toString(setting.value, setting.format));
            }
        }
    };

    $.fn.FrameNumeric.defaults = $.extend({}, {
        type: 'FrameNumeric',
        decimals: 2,
        format: 'n',
        max: null,
        min: null,
        spinners: false,
        step: 1,
        style: "width: 100%; ",
        className: '',
        value: null,
        placeholder: '',
        readonly: false,
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameNumeric.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoNumericTextBox").value(value);
            } else {
                $('#' + controlId + '_Control').html(kendo.toString(value, $(my).data('format')));
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_Control').data("kendoNumericTextBox").value();
            } else {
                return $(my).data('value');
            }
        },
        getControl: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_Control').data("kendoNumericTextBox");
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoNumericTextBox").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoNumericTextBox").enable(true);
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameNumeric End
})(jQuery);