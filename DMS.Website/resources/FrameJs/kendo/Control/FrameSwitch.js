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
            $('#' + controlId).data({
                type: 'Switch'
            });

            $('#' + controlId).empty();

            //DOM
            var e = document.createElement("input");
            e.id = controlId + '_Control';
            e.type = 'checkbox';
            e.style.cssText = setting.style;
            $('#' + controlId).append(e);

            $('#' + controlId + '_Control').kendoMobileSwitch({
                onLabel: setting.onLabel,
                offLabel: setting.offLabel,
                change: typeof (setting.onChange) != 'undefined'?setting.onChange:""
            });
      
            //Value
            $('#' + controlId + '_Control').data("kendoMobileSwitch").check(setting.value);

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

    $.fn.FrameSwitch.defaults = $.extend({}, {
        className: '',
        onLabel: "是",
        offLabel: "否",
        value: false,
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameSwitch.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoMobileSwitch").check(value);
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            return $('#' + controlId + '_Control').data("kendoMobileSwitch").check();
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoMobileSwitch").enable(false);
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoMobileSwitch").enable(true);
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