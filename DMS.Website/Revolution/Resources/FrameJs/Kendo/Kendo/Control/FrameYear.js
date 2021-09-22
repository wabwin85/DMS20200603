(function ($) {
    //FrameYear Start
    $.fn.FrameYear = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameYear.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameYear.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameYear.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();
            
            if (!setting.readonly) {
                //HTML
                var html = '';
                html += '<select id="' + controlId + '_Control" class="' + setting.className + '" style="' + setting.style + '"></select>';

                $(this).append(html);

                var optionLabel = '';
                if (setting.selectType == 'all') {
                    optionLabel = '全部';
                } else if (setting.selectType == 'select') {
                    optionLabel = '请选择';
                }

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

                $('#' + controlId + '_Control').kendoDropDownList({
                    height: setting.height,
                    dataTextField: 'Value',
                    dataValueField: 'Key',
                    dataSource: yearDataSource,
                    noDataTemplate: '',
                    optionLabel: optionLabel,
                    value: setting.value,
                    change: setting.onChange,
                });

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            } else {
                var e = $.fn.FrameSpan(controlId + '_Control');
                $(this).append(e);

                //Value
                $('#' + controlId + '_Control').html(setting.value);
            }
        }
    };

    $.fn.FrameYear.defaults = $.extend({}, {
        type: 'FrameYear',
        style: "width: 100%; ",
        className: '',
        height: 200,
        startYear: 'auto', //auto: 2000; shift: minus current year
        startShift: 0,
        endYear: 'auto', //auto:current year; shift: plus current year
        endShift: 0,
        selectType: '',
        value: '',
        readonly: false,
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameYear.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoDropDownList").value(value);
            } else {
                $('#' + controlId + '_Control').html(value.Year);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");
                        
            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_Control').data("kendoDropDownList").value();
            } else {
                return $(my).data('value');
            }
        },
        getControl: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_Control').data("kendoDropDownList");
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoDropDownList").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoDropDownList").enable(true);
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameYear End
})(jQuery);