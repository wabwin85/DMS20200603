(function ($) {
    //FrameCalendarRange Start
    $.fn.FrameCalendarRange = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameCalendarRange.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameCalendarRange.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameCalendarRange.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            if (!setting.readonly) {
                //HTML
                var html = '';
                html += '<div class="col-xs-12">';
                html += '   <div class="row">';
                html += '       <div class="col-xs-1" style="width: 38% !important">';
                html += '           <div class="row">';
                html += '               <select id="' + controlId + '_Year_Control" class="calendar-range-year ' + setting.className + '" style="' + setting.style + '"></select>';
                html += '           </div>';
                html += '       </div>';
                html += '       <div class="col-xs-1 center" style="width: 6% !important; padding: 0;">';
                html += '           <div class="row" style="margin: 0px;">&nbsp;</div>';
                html += '       </div>';
                html += '       <div class="col-xs-1" style="width: 25% !important">';
                html += '           <div class="row">';
                html += '               <select id="' + controlId + '_StartMonth_Control" class="calendar-range-start-month ' + setting.className + '" style="' + setting.style + '"></select>';
                html += '           </div>';
                html += '       </div>';
                html += '       <div class="col-xs-1 center" style="width: 6% !important; padding: 0;">';
                html += '           <div class="row" style="margin: 0px;">-</div>';
                html += '       </div>';
                html += '       <div class="col-xs-1" style="width: 25% !important">';
                html += '           <div class="row">';
                html += '               <select id="' + controlId + '_EndMonth_Control" class="calendar-range-end-month ' + setting.className + '" style="' + setting.style + '"></select>';
                html += '           </div>';
                html += '       </div>';
                html += '   </div>';
                html += '</div>';

                $(this).append(html);

                if (setting.yearDataSource.length == 0) {
                    var currentDate = new Date();
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
                        setting.yearDataSource.push({ 'Key': i.toString(), 'Value': i.toString() });
                    }
                }

                var year = $('#' + controlId + '_Year_Control').kendoDropDownList({
                    height: setting.heightYear,
                    dataTextField: 'Value',
                    dataValueField: 'Key',
                    dataSource: setting.yearDataSource,
                    noDataTemplate: ''
                }).data("kendoDropDownList");
                var startMonth = $('#' + controlId + '_StartMonth_Control').kendoDropDownList({
                    height: setting.heightMonth,
                    dataTextField: 'Value',
                    dataValueField: 'Key',
                    dataSource: setting.monthDataSource,
                    noDataTemplate: ''
                }).data("kendoDropDownList");
                var endMonth = $('#' + controlId + '_EndMonth_Control').kendoDropDownList({
                    height: setting.heightMonth,
                    dataTextField: 'Value',
                    dataValueField: 'Key',
                    dataSource: setting.monthDataSource,
                    noDataTemplate: ''
                }).data("kendoDropDownList");

                //Value
                if ($.trim(setting.value.Year) != '') {
                    year.value(setting.value.Year);
                }
                if ($.trim(setting.value.StartMonth) != '') {
                    startMonth.value(setting.value.StartMonth);
                }
                if ($.trim(setting.value.EndMonth) != '') {
                    endMonth.value(setting.value.EndMonth);
                }

                //Change
                $('#' + controlId + '_Year_Control').unbind('change');
                $('#' + controlId + '_Year_Control').on('change', function () {
                    setting.onChangeYear.call(this);
                });
                $('#' + controlId + '_StartMonth_Control').unbind('change');
                $('#' + controlId + '_StartMonth_Control').on('change', function () {

                });
                $('#' + controlId + '_EndMonth_Control').unbind('change');
                $('#' + controlId + '_EndMonth_Control').on('change', function () {

                });

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            } else {
                var e = $.fn.FrameSpan(controlId + '_Control');
                $(this).append(e);

                //Value
                $('#' + controlId + '_Control').html(setting.value.Year + '&nbsp;&nbsp;' + setting.value.StartMonth + '&nbsp;-&nbsp;' + setting.value.EndMonth);
            }
        }
    };

    $.fn.FrameCalendarRange.defaults = $.extend({}, {
        type: 'FrameCalendarRange',
        style: "width: 100%; ",
        className: '',
        heightYear: 200,
        heightMonth: 200,
        value: { 'Year': '', 'StartMonth': '', 'EndMonth': '' },
        yearDataSource: [],
        startYear: 'auto', //auto: 2000; shift: minus current year
        startShift: 0,
        endYear: 'auto', //auto:current year; shift: plus current year
        endShift: 0,
        monthDataSource: [
                    { 'Key': '1', 'Value': '1' },
                    { 'Key': '2', 'Value': '2' },
                    { 'Key': '3', 'Value': '3' },
                    { 'Key': '4', 'Value': '4' },
                    { 'Key': '5', 'Value': '5' },
                    { 'Key': '6', 'Value': '6' },
                    { 'Key': '7', 'Value': '7' },
                    { 'Key': '8', 'Value': '8' },
                    { 'Key': '9', 'Value': '9' },
                    { 'Key': '10', 'Value': '10' },
                    { 'Key': '11', 'Value': '11' },
                    { 'Key': '12', 'Value': '12' }
        ],
        onChangeYear: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameCalendarRange.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Year_Control').data("kendoDropDownList").value(value.Year);
                $('#' + controlId + '_StartMonth_Control').data("kendoDropDownList").value(value.StartMonth);
                $('#' + controlId + '_EndMonth_Control').data("kendoDropDownList").value(value.EndMonth);
            } else {
                $('#' + controlId + '_Control').html(value.Year + '&nbsp;&nbsp;' + value.StartMonth + '&nbsp;-&nbsp;' + value.EndMonth);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            var value = {};

            if (!$(my).data('readonly')) {
                value.Year = $('#' + controlId + '_Year_Control').data("kendoDropDownList").value();
                value.StartMonth = $('#' + controlId + '_StartMonth_Control').data("kendoDropDownList").value();
                value.EndMonth = $('#' + controlId + '_EndMonth_Control').data("kendoDropDownList").value();
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
        getControlStartMonth: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_StartMonth_Control').data("kendoDropDownList");
            }
        },
        getControlEndMonth: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_EndMonth_Control').data("kendoDropDownList");
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Year_Control').data("kendoDropDownList").enable(false);
                $('#' + controlId + '_StartMonth_Control').data("kendoDropDownList").enable(false);
                $('#' + controlId + '_EndMonth_Control').data("kendoDropDownList").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Year_Control').data("kendoDropDownList").enable(true);
                $('#' + controlId + '_StartMonth_Control').data("kendoDropDownList").enable(true);
                $('#' + controlId + '_EndMonth_Control').data("kendoDropDownList").enable(true);
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameCalendarRange End
})(jQuery);