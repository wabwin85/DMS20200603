(function ($) {
    //FrameSpan Start
    $.fn.FrameSpan = function (id) {
        var e = document.createElement("span");
        e.id = id;
        e.className = $.fn.FrameSpan.defaults.className;
        e.style.cssText = $.fn.FrameSpan.defaults.style;

        return e;
    };

    $.fn.FrameSpan.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: ''
    });
    //FrameSpan End
})(jQuery);