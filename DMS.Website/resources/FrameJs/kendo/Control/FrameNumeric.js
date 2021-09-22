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
            $('#' + controlId).data({
                type: 'Numeric'
            });

            $('#' + controlId).empty();

            //DOM
            var e = document.createElement("input");
            e.id = controlId + '_Control';
            e.type = 'text';
            e.style.cssText = setting.style;
            e.className = setting.className;
            $('#' + controlId).append(e);

            $('#' + controlId + '_Control').kendoNumericTextBox({
                decimals: setting.decimals,
                format: setting.format,
                max: setting.max,
                min: setting.min,
                spinners: setting.spinners,
                step: setting.step,
            });

            //Value
            $('#' + controlId + '_Control').data("kendoNumericTextBox").value(setting.value);

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

    $.fn.FrameNumeric.defaults = $.extend({}, {
        decimals: 2,
        format: 'n',
        max: null,
        min: null,
        spinners: false,
        step: 1,
        style: "width: 100%; ",
        className: '',
        value: '',
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameNumeric.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoNumericTextBox").value(value);
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            return $('#' + controlId + '_Control').data("kendoNumericTextBox").value();
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoNumericTextBox").enable(false);
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoNumericTextBox").enable(true);
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