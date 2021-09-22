(function ($) {
    //FrameSwitch Start
    $.fn.FrameSwitch = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameSwitch.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameSwitch.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameSwitch.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            if (!setting.readonly) {
                //DOM
                var e = document.createElement("input");
                e.id = controlId + '_Control';
                e.type = 'checkbox';
                e.style.cssText = setting.style;
                $(this).append(e);

                $('#' + controlId + '_Control').kendoMobileSwitch({
                    onLabel: setting.onLabel,
                    offLabel: setting.offLabel,
                    change: setting.onChange,
                    checked: setting.value
                });

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            } else {
                //DOM
                var e = document.createElement("input");
                e.id = controlId + '_Control';
                e.type = 'checkbox';
                e.style.cssText = setting.style;
                $(this).append(e);

                $('#' + controlId + '_Control').kendoMobileSwitch({
                    onLabel: setting.onLabel,
                    offLabel: setting.offLabel,
                    change: setting.onChange,
                    checked: setting.value
                });
                $('#' + controlId + '_Control').data("kendoMobileSwitch").enable(false);
            }
        }
    };

    $.fn.FrameSwitch.defaults = $.extend({}, {
        type: 'FrameSwitch',
        className: '',
        onLabel: "是",
        offLabel: "否",
        value: false,
        readonly: false,
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameSwitch.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoMobileSwitch").check(value);
            } else {
                $('#' + controlId + '_Control').data("kendoMobileSwitch").check(value);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_Control').data("kendoMobileSwitch").check();
            } else {
                return $(my).data('value');
            }
        },
        getText: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_Control').data("kendoMobileSwitch").check() ? $(my).data('onLabel') : $(my).data('offLabel');
            }
        },
        getControl: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_Control').data("kendoMobileSwitch");
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoMobileSwitch").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoMobileSwitch").enable(true);
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameSwitch End
})(jQuery);