(function ($) {
    //FrameButton Start
    $.fn.FrameButton = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        if (typeof param1 == "string") {
            var func = $.fn.FrameButton.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var my = $(this);

            var setting = $.extend({}, $.fn.FrameButton.defaults, param1);

            my.addClass(setting.className);
            my.css(setting.style);
            if (setting.icon == '') {
                my.html(setting.text);
            } else {
                my.html('<i class="fa fa-fw fa-' + setting.icon + '"></i>&nbsp;&nbsp;' + setting.text);
            }

            my.kendoButton({
                click: setting.onClick
            });
        }
    };

    $.fn.FrameButton.defaults = $.extend({}, {
        text: '',
        icon: '',
        style: {},
        className: 'btn-primary',
        onClick: function () { }
    });

    $.fn.FrameButton.methods = {
        disable: function (my) {
            $(my).data("kendoButton").enable(false);
        },
        enable: function (my) {
            $(my).data("kendoButton").enable();
        },
        getControl: function (my) {
            return $(my).data("kendoButton");
        }
    };
    //FrameButton End
})(jQuery);