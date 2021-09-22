(function ($) {
    //FrameDatePicker Start
    $.fn.FrameDatePicker = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameDatePicker.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameDatePicker.defaults, param1);
            $('#' + controlId).data({
                type: 'DatePicker'
            });

            $('#' + controlId).empty();

            //DOM
            var e = document.createElement("input");
            e.id = controlId + '_Control';
            e.type = 'text';
            e.style.cssText = setting.style;
            e.className = setting.className;
            $('#' + controlId).append(e);

            $('#' + controlId + '_Control').kendoDatePicker({
                format: setting.format,
                depth: setting.depth,
                start: setting.start
            });

            //Value
            $('#' + controlId + '_Control').data("kendoDatePicker").value(setting.value);

            //Change
            if (typeof (setting.onChange) != 'undefined') {
                $('#' + controlId + '_Control').unbind('change');
                $('#' + controlId + '_Control').on('change', setting.onChange);
            }

            //Click
            $('#' + controlId + '_Control').removeAttr("onfocus");
            $('#' + controlId + '_Control').click(function () { $('#' + controlId + '_Control').data("kendoDatePicker").open(); });

            //Blur
            //TODO Blur

            //Focus
            //TODO Focus
        }
    };

    $.fn.FrameDatePicker.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: '',
        value: '',
        className: '',
        format: "yyyy-MM-dd",
        depth: "month",
        start: "month",
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameDatePicker.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoDatePicker").value(value);
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            if ($('#' + controlId + '_Control').data("kendoDatePicker").value() != null) {
                return $('#' + controlId + '_Control').data("kendoDatePicker").value().Format('yyyy-MM-dd');
            } else {
                return null;
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoDatePicker").enable(false);
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoDatePicker").enable(true);
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameDatePicker End
})(jQuery);