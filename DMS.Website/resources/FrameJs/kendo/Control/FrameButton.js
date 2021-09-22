(function ($) {
    //FrameButton Start
    $.fn.FrameButton = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameButton.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameButton.defaults, param1);

            $('#' + controlId).kendoButton({
                click: setting.onClick
            });
        }
    };

    $.fn.FrameButton.defaults = $.extend({}, {
        onClick: function () { }
    });

    $.fn.FrameButton.methods = {
        disable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId).data("kendoButton").enable(false);
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId).data("kendoButton").enable();
        }
    };
    //FrameButton End
})(jQuery);