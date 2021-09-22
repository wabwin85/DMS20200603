(function ($) {
    //FrameDropdownList Start
    $.fn.FrameDropdownList = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameDropdownList.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameDropdownList.defaults, param1);
            $('#' + controlId).data({
                type: 'DropdownList'
            });

            $('#' + controlId).empty();

            //DOM
            var e = document.createElement("select");
            e.id = controlId + '_Control';
            e.style.cssText = setting.style;
            e.className = setting.className;
            $('#' + controlId).append(e);

            var optionLabel = '';
            if (setting.selectType == 'all') {
                optionLabel = '全部';
            } else if (setting.selectType == 'select') {
                optionLabel = '请选择';
            }

            $('#' + controlId + '_Control').kendoDropDownList({
                dataTextField: setting.dataValue,
                dataValueField: setting.dataKey,
                dataSource: setting.dataSource,
                optionLabel: optionLabel,
                noDataTemplate: ''
            });

            //Value
            if ($.trim(setting.value) != '') {
                $('#' + controlId + '_Control').data("kendoDropDownList").value(setting.value);
            }

            //Change
            if (typeof (setting.onChange) != 'undefined') {
                $('#' + controlId + '_Control').unbind('change');
                $('#' + controlId + '_Control').on('change', setting.onChange);
            }

            //Blur
            //TODO Blur

            //Focus
            //TODO Focus
        }
    };

    $.fn.FrameDropdownList.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: '',
        value: '',
        dataSource: {},
        dataKey: '',
        dataValue: '',
        selectType: '',
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameDropdownList.methods = {
        setDataSource: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoDropDownList").setDataSource(value);
        },
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoDropDownList").value(value);
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            return $('#' + controlId + '_Control').data("kendoDropDownList").value();
        },
        getText: function (my) {
            var controlId = $(my).attr("id");

            return $('#' + controlId + '_Control').data("kendoDropDownList").text();
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoDropDownList").enable(false);
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data("kendoDropDownList").enable();
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameDropdownList End
})(jQuery);