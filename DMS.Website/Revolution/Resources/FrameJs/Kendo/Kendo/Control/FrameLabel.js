(function ($) {
    //FrameLabel Start
    $.fn.FrameLabel = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameLabel.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameLabel.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameLabel.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            var e = $.fn.FrameSpan(controlId + '_Control');
            $(this).append(e);

            //Value
            $('#' + controlId + '_Control').html(setting.value);
        }
    };

    $.fn.FrameLabel.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: '',
        value: ''
    });

    $.fn.FrameLabel.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            $('#' + controlId + '_Control').html(value);
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            return $(my).data('value');
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameLabel End
})(jQuery);