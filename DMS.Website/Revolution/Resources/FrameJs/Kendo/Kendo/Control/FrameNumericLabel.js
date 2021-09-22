(function ($) {
    //FrameNumericLabel Start
    $.fn.FrameNumericLabel = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameNumericLabel.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameNumericLabel.defaults, param1);
            $(this).data(setting);

            $(this).empty();

            $(this).append('<span class="frame-label" style="width: 100%;" />');

            //Value
            $(this).find(".frame-label").html(kendo.toString(setting.value, setting.format));
        }
    };

    $.fn.FrameNumericLabel.defaults = $.extend({}, {
        style: "width: 100%; ",
        value: 0,
        className: '',
        format: 'N2'
    });

    $.fn.FrameNumericLabel.methods = {
        setValue: function (my, value) {
            $(my).data('value', value);
            $(my).find(".frame-label").html(kendo.toString(value, $(my).data('format')));
        },
        getValue: function (my) {
            return $(my).data('value');
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameNumericLabel End
})(jQuery);