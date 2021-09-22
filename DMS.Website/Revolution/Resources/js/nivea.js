$.fn.gridToggle = function (option) {
    var setting = $.extend({}, {
        callback: function () { }
    }, option);

    $(this).bind('click', function () {
        var target = $(this).data('target');
        if (!$('#' + target).is(":visible")) {
            $('#' + target).slideDown(function () {
                setting.callback.call(this);
            });
            $(this).find('i').removeClass('fa-angle-double-down');
            $(this).find('i').addClass('fa-angle-double-up');
        } else {
            $('#' + target).slideUp(function () {
                setting.callback.call(this);
            });
            $(this).find('i').removeClass('fa-angle-double-up');
            $(this).find('i').addClass('fa-angle-double-down');
        }
    })
}