(function ($) {
    //FrameDatePickerRange Start
    $.fn.FrameDatePickerRange = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameDatePickerRange.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameDatePickerRange.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameDatePickerRange.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            if (!setting.readonly) {
                //HTML
                var html = '';
                html += '<div class="col-xs-12">';
                html += '   <div class="row">';
                html += '       <div class="col-xs-5" style="width: 47% !important">';
                html += '           <div class="row">';
                html += '               <input type="text" id="' + controlId + '_StartDate_Control" class="' + setting.className + '" style="' + setting.style + '" />';
                html += '           </div>';
                html += '       </div>';
                html += '       <div class="col-xs-2 text-center" style="width: 6% !important; padding: 0;">';
                html += '           <div class="row" style="margin: 0px;">-</div>';
                html += '       </div>';
                html += '       <div class="col-xs-5" style="width: 47% !important">';
                html += '           <div class="row">';
                html += '               <input type="text" id="' + controlId + '_EndDate_Control" class="' + setting.className + '" style="' + setting.style + '" />';
                html += '           </div>';
                html += '       </div>';
                html += '   </div>';
                html += '</div>';

                $(this).append(html);

                var start = $('#' + controlId + '_StartDate_Control').kendoDatePicker({
                    format: setting.format,
                    depth: setting.depth,
                    start: setting.start,
                    min: setting.min,
                    max: setting.max
                }).data("kendoDatePicker");

                var end = $('#' + controlId + '_EndDate_Control').kendoDatePicker({
                    format: setting.format,
                    depth: setting.depth,
                    start: setting.start,
                    min: setting.min,
                    max: setting.max
                }).data("kendoDatePicker");

                //Value
                start.value(setting.value.StartDate);
                end.value(setting.value.EndDate);

                if (start.value()) {
                    end.min(new Date(start.value()));
                } else {
                    end.min(new Date(1900, 1, 1));
                }
                if (end.value()) {
                    start.max(new Date(end.value()));
                } else {
                    start.max(new Date(2099, 12, 31));
                }

                //Change
                $('#' + controlId + '_StartDate_Control').unbind('change');
                $('#' + controlId + '_StartDate_Control').on('change', function () {
                    var startDate = start.value();

                    if (startDate) {
                        end.min(new Date(startDate));
                    } else {
                        end.min(new Date(1900, 1, 1));
                    }

                    if (typeof (setting.onChangeStartDate) != 'undefined') {
                        setting.onChangeStartDate.call(this);
                    }
                });
                $('#' + controlId + '_EndDate_Control').unbind('change');
                $('#' + controlId + '_EndDate_Control').on('change', function () {
                    var endDate = end.value();

                    if (endDate) {
                        start.max(new Date(endDate));
                    } else {
                        start.max(new Date(2099, 12, 31));
                    }

                    if (typeof (setting.onChangeEndDate) != 'undefined') {
                        setting.onChangeEndDate.call(this);
                    }
                });

                //Click
                $('#' + controlId + '_StartDate_Control').removeAttr("onfocus");
                $('#' + controlId + '_StartDate_Control').click(function () { start.open(); });
                $('#' + controlId + '_EndDate_Control').removeAttr("onfocus");
                $('#' + controlId + '_EndDate_Control').click(function () { end.open(); });

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            } else {
                var e = $.fn.FrameSpan(controlId + '_Control');
                $(this).append(e);

                //Value
                //if (setting.value.StartDate != '' && setting.value.EndDate != '') {
                //    $('#' + controlId + '_Control').html(setting.value.StartDate + ' - ' + setting.value.EndDate);
                //} else {
                //    $('#' + controlId + '_Control').html('');
                //}
                var label = '';
                label += setting.value.StartDate == '' ? setting.startLabel : setting.value.StartDate;
                label += ' - ';
                label += setting.value.EndDate == '' ? setting.endLabel : setting.value.EndDate;
                $('#' + controlId + '_Control').html(label);
            }
        }
    };

    $.fn.FrameDatePickerRange.defaults = $.extend({}, {
        type: 'FrameDatePickerRange',
        style: "width: 100%; ",
        className: '',
        value: { 'StartDate': '', 'EndDate': '' },
        format: "yyyy-MM-dd",
        min: '1900-01-01',
        max: '2099-12-31',
        depth: "month",
        start: "month",
        startLabel: "",
        endLabel: "",
        readonly: false,
        onChangeStartDate: function () { },
        onChangeEndDate: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameDatePickerRange.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_StartDate_Control').data("kendoDatePicker").value(value.StartDate);
                $('#' + controlId + '_EndDate_Control').data("kendoDatePicker").value(value.EndDate);
            } else {
                var label = '';
                label += value.StartDate == '' ? $(my).data('startLabel') : value.StartDate;
                label += ' - ';
                label += value.EndDate == '' ? $(my).data('endLabel') : value.EndDate;
                $('#' + controlId + '_Control').html(label);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            var value = {};

            if ($(my).data('readonly')) {
                value = $(my).data('value');
            } else {
                if ($('#' + controlId + '_StartDate_Control').data("kendoDatePicker").value() != null) {
                    value.StartDate = kendo.toString($('#' + controlId + '_StartDate_Control').data("kendoDatePicker").value(), $(my).data('format'));
                } else {
                    value.StartDate = '';
                }
                if ($('#' + controlId + '_EndDate_Control').data("kendoDatePicker").value() != null) {
                    value.EndDate = kendo.toString($('#' + controlId + '_EndDate_Control').data("kendoDatePicker").value(), $(my).data('format'));
                } else {
                    value.EndDate = '';
                }
            }

            return value;
        },
        getControlStartDate: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_StartDate_Control').data("kendoDatePicker");
            }
        },
        getControlEndDate: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_EndDate_Control').data("kendoDatePicker");
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_StartDate_Control').data("kendoDatePicker").enable(false);
                $('#' + controlId + '_EndDate_Control').data("kendoDatePicker").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if (!$('#' + controlId).data('readonly')) {
                $('#' + controlId + '_StartDate_Control').data("kendoDatePicker").enable(true);
                $('#' + controlId + '_EndDate_Control').data("kendoDatePicker").enable(true);
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameDatePickerRange End
})(jQuery);