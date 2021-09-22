(function ($) {
    //DmsApplyBasic Start
    $.fn.DmsApplyBasic = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.DmsApplyBasic.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.DmsApplyBasic.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.DmsApplyBasic.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            //HTML
            var html = '';
            html += '<div class="col-xs-12">';
            html += '  <div class="row" style="background-color: #f9f9f9;">';
            html += '     <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '         <div class="col-xs-4 col-label">单据编号</div>';
            html += '         <div class="col-xs-8 col-field">';
            html += '             <div id="' + controlId + '_ApplyNo_Control"></div>';
            html += '         </div>';
            html += '     </div>';
            html += '     <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '         <div class="col-xs-4 col-label">申请人</div>';
            html += '         <div class="col-xs-8 col-field">';
            html += '             <div id="' + controlId + '_ApplyUser_Control"></div>';
            html += '         </div>';
            html += '     </div>';
            html += '     <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '         <div class="col-xs-4 col-label">申请日期</div>';
            html += '         <div class="col-xs-8 col-field">';
            html += '             <div id="' + controlId + '_ApplyDate_Control"></div>';
            html += '         </div>';
            html += '     </div>';
            html += '     <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '         <div class="col-xs-4 col-label">状态</div>';
            html += '         <div class="col-xs-8 col-field">';
            html += '             <div id="' + controlId + '_Status_Control"></div>';
            html += '         </div>';
            html += '     </div>';
            html += '  </div>';
            html += '</div>';

            $(this).append(html);

            $('#' + controlId + '_ApplyDate_Control').html(setting.value.ApplyDate);
            $('#' + controlId + '_ApplyUser_Control').html(setting.value.ApplyUser);
            $('#' + controlId + '_ApplyNo_Control').html(setting.value.ApplyNo);
            $('#' + controlId + '_Status_Control').html(setting.value.Status);
        }
    };

    $.fn.DmsApplyBasic.defaults = $.extend({}, {
        type: 'DmsApplyBasic',
        value: { 'ApplyDate': '', 'ApplyUser': '', 'ApplyNo': '', 'Status': '' }
    });

    $.fn.DmsApplyBasic.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            $('#' + controlId + '_ApplyDate_Control').html(value.ApplyDate);
            $('#' + controlId + '_ApplyUser_Control').html(value.ApplyUser);
            $('#' + controlId + '_ApplyNo_Control').html(value.ApplyNo);
            $('#' + controlId + '_Status_Control').html(value.Status);
        },
        getValue: function (my) {
            return $(my).data('value');
        }
    };
    //DmsApplyBasic End
})(jQuery);