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
            if (!setting.value) {
                setting.value = $.fn.FrameDatePicker.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            if (!setting.readonly) {
                //DOM
                var html = '';
                html += '<input id="' + controlId + '_Control" type="text" class="' + setting.className + '" style="' + setting.style + '" />';

                $(this).append(html);
                setting.min = $.isNullOrEmpty(setting.min) ? '1900-01-01' : setting.min;
                setting.max = $.isNullOrEmpty(setting.max) ? '2099-12-31' : setting.max;

                $('#' + controlId + '_Control').kendoDatePicker({
                    format: setting.format,
                    depth: setting.depth,
                    start: setting.start,
                    min: setting.min,
                    max: setting.max
                });

                //Value
                $('#' + controlId + '_Control').data("kendoDatePicker").value(setting.value);

                //Change
                $('#' + controlId + '_Control').data("kendoDatePicker").bind("change", setting.onChange);

                //Click
                $('#' + controlId + '_Control').removeAttr("onfocus");
                $('#' + controlId + '_Control').click(function () { $('#' + controlId + '_Control').data("kendoDatePicker").open(); });

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

    $.fn.FrameDatePicker.defaults = $.extend({}, {
        type: 'FrameDatePicker',
        style: "width: 100%; ",
        className: '',
        value: '',
        format: "yyyy-MM-dd",
        min: '1900-01-01',
        max: '2099-12-31',
        depth: "month",
        start: "month",
        readonly: false,
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameDatePicker.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoDatePicker").value(value);
            } else {
                $('#' + controlId + '_Control').html(value);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                if ($('#' + controlId + '_Control').data("kendoDatePicker").value() != null) {
                    return kendo.toString($('#' + controlId + '_Control').data("kendoDatePicker").value(), $(my).data('format'));
                } else {
                    return null;
                }
            } else {
                return $(my).data('value');
            }
        },
        getControl: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_Control').data("kendoDatePicker");
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoDatePicker").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoDatePicker").enable(true);
            }
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