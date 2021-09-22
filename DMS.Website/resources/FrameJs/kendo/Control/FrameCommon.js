(function ($) {
    $.getModel = function (panel) {
        var model = {};

        if (typeof (panel) == 'undefined') {
            $('.FrameControl').each(function () {
                var controlId = $(this).attr("id");
                if ($(this).attr("type") == 'hidden') {
                    eval("model." + controlId + " = '" + $(this).val() + "'");
                } else {
                    //$("#dropdownlist").data("kendoDropDownList");
                    var type = $(this).data('type');
                    if (typeof (type) == 'undefined') {
                        eval("model." + controlId + " = null");
                    } else {
                        eval("model." + controlId + " = $(this).Frame" + type + "('getValue')");
                    }
                }
            });
        } else {
            $('#' + panel).find('.FrameControl').each(function () {
                var controlId = $(this).attr("id");
                if ($(this).attr("type") == 'hidden') {
                    eval("model." + controlId + " = '" + $(this).val() + "'");
                } else {
                    //$("#dropdownlist").data("kendoDropDownList");
                    var type = $(this).data('type');
                    if (typeof (type) == 'undefined') {
                        eval("model." + controlId + " = null");
                    } else {
                        eval("model." + controlId + " = $(this).Frame" + type + "('getValue')");
                    }
                }
            });
        }

        return model;
    }
})(jQuery);