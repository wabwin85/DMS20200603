(function ($) {
    //FrameSpan Start
    $.fn.FrameSpan = function (id) {
        var html = '';
        html += '<span id="' + id + '" class="frame-label ' + $.fn.FrameSpan.defaults.className + '" style="' + $.fn.FrameSpan.defaults.style + '" />';

        $(this).append(html);

        return html;
    };

    $.fn.FrameSpan.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: ''
    });
    //FrameSpan End
})(jQuery);