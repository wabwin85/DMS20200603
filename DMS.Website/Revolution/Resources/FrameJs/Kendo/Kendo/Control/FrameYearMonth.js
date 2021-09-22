(function ($) {
    //FrameYearMonth Start
    $.fn.FrameYearMonth = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameYearMonth.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameYearMonth.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameYearMonth.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();
            
            if (!setting.readonly) {
                //HTML
                var html = '';
                html += '<div class="col-xs-12">';
                html += '   <div class="row">';
                html += '       <div class="col-xs-1" style="width: 54% !important">';
                html += '           <div class="row">';
                html += '               <select id="' + controlId + '_Year_Control" class="' + setting.className + '" style="' + setting.style + '"></select>';
                html += '           </div>';
                html += '       </div>';
                html += '       <div class="col-xs-1 center" style="width: 6% !important; padding: 0;">';
                html += '           <div class="row" style="margin: 0px;">&nbsp;</div>';
                html += '       </div>';
                html += '       <div class="col-xs-1" style="width: 40% !important">';
                html += '           <div class="row">';
                html += '               <select id="' + controlId + '_Month_Control" class="' + setting.className + '" style="' + setting.style + '"></select>';
                html += '           </div>';
                html += '       </div>';
                html += '   </div>';
                html += '</div>';

                $(this).append(html);

                var monthDataSource = [
                    { 'Key': '01', 'Value': '01' },
                    { 'Key': '02', 'Value': '02' },
                    { 'Key': '03', 'Value': '03' },
                    { 'Key': '04', 'Value': '04' },
                    { 'Key': '05', 'Value': '05' },
                    { 'Key': '06', 'Value': '06' },
                    { 'Key': '07', 'Value': '07' },
                    { 'Key': '08', 'Value': '08' },
                    { 'Key': '09', 'Value': '09' },
                    { 'Key': '10', 'Value': '10' },
                    { 'Key': '11', 'Value': '11' },
                    { 'Key': '12', 'Value': '12' }
                ];

                var currentDate = new Date();
                var yearDataSource = [];

                var startYear;
                var endYear;
                if (setting.startYear == 'shift') {
                    startYear = currentDate.getFullYear() - setting.startShift;
                } else if (setting.startYear == 'auto') {
                    startYear = 2000;
                } else {
                    startYear = parseInt(setting.startYear);
                }
                if (setting.endYear == 'shift') {
                    endYear = currentDate.getFullYear() + setting.endShift;
                } else if (setting.endYear == 'auto') {
                    endYear = currentDate.getFullYear();
                } else {
                    endYear = parseInt(setting.endYear);
                }

                for (var i = startYear; i <= endYear; i++) {
                    yearDataSource.push({ 'Key': i.toString(), 'Value': i.toString() });
                }

                var year = $('#' + controlId + '_Year_Control').kendoDropDownList({
                    height: setting.heightYear,
                    dataTextField: 'Value',
                    dataValueField: 'Key',
                    dataSource: yearDataSource,
                    noDataTemplate: ''
                }).data("kendoDropDownList");
                var month = $('#' + controlId + '_Month_Control').kendoDropDownList({
                    height: setting.heightMonth,
                    dataTextField: 'Value',
                    dataValueField: 'Key',
                    dataSource: monthDataSource,
                    noDataTemplate: ''
                }).data("kendoDropDownList");

                //Value
                if ($.trim(setting.value.Year) != '') {
                    year.value(setting.value.Year);
                }
                if ($.trim(setting.value.Month) != '') {
                    month.value(setting.value.Month);
                }

                //Change
                $('#' + controlId + '_Year_Control').unbind('change');
                $('#' + controlId + '_Year_Control').on('change', function () {
                    setting.onChangeYear.call(this);
                });
                $('#' + controlId + '_Month_Control').unbind('change');
                $('#' + controlId + '_Month_Control').on('change', function () {
                    setting.onChangeMonth.call(this);
                });

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            } else {
                var e = $.fn.FrameSpan(controlId + '_Control');
                $(this).append(e);

                //Value
                $('#' + controlId + '_Control').html(setting.value.Year + ' - ' + setting.value.Month);
            }
        }
    };

    $.fn.FrameYearMonth.defaults = $.extend({}, {
        type: 'FrameYearMonth',
        style: "width: 100%; ",
        className: '',
        heightYear: 200,
        heightMonth: 200,
        startYear: 'auto', //auto: 2000; shift: minus current year
        startShift: 0,
        endYear: 'auto', //auto:current year; shift: plus current year
        endShift: 0,
        value: { 'Year': '', 'Month': '' },
        readonly: false,
        onChangeYear: function () { },
        onChangeMonth: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameYearMonth.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Year_Control').data("kendoDropDownList").value(value.Year);
                $('#' + controlId + '_Month_Control').data("kendoDropDownList").value(value.Month);
            } else {
                $('#' + controlId + '_Control').html(value.Year + ' - ' + value.Month);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            var value = {};
            
            if (!$(my).data('readonly')) {
                value.Year = $('#' + controlId + '_Year_Control').data("kendoDropDownList").value();
                value.Month = $('#' + controlId + '_Month_Control').data("kendoDropDownList").value();
            } else {
                return $(my).data('value');
            }

            return value;
        },
        getControlYear: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_Year_Control').data("kendoDropDownList");
            }
        },
        getControlMonth: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_Month_Control').data("kendoDropDownList");
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Year_Control').data("kendoDropDownList").enable(false);
                $('#' + controlId + '_Month_Control').data("kendoDropDownList").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Year_Control').data("kendoDropDownList").enable(true);
                $('#' + controlId + '_Month_Control').data("kendoDropDownList").enable(true);
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameYearMonth End
})(jQuery);