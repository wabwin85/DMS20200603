(function ($) {
    //FrameControl Start
    $.fn.FrameControl = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameControl.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        }
    };

    $.fn.FrameControl.methods = {
        getValue: function (my) {
            var controlId = $(my).attr("id");
            if ($(my).attr("type") == 'hidden') {
                return $(my).val();
            } else {
                var type = $(my).data('type');
                if (typeof (type) == 'undefined') {
                    return null;
                } else {
                    var rtn = '';
                    eval("rtn = $(my)." + type + "('getValue')");
                    return rtn;
                }
            }
        }
    };
    //FrameControl End
})(jQuery);