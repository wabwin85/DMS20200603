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
            var my = $(this);

            var setting = $.extend({}, $.fn.FrameDropdownList.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameDropdownList.defaults.value;
            }
            my.data(setting);

            my.empty();

            if (!setting.readonly) {
                //DOM
                var html = '';
                html += '<select id="' + controlId + '_Control" class="' + setting.className + '" style="' + setting.style + '"></select>';

                my.append(html);

                var optionLabel = setting.optionLabel;
                if (optionLabel == '') {
                    if (setting.selectType == 'all') {
                        optionLabel = '全部';
                    } else if (setting.selectType == 'select') {
                        optionLabel = '请选择';
                    }
                }

                if ((setting.dataSource == null || setting.dataSource.length == 0) && $.trim(setting.value.Key) != '') {
                    setting.dataSource = [];
                    setting.dataSource.push(setting.value);
                }

                $('#' + controlId + '_Control').kendoDropDownList({
                    value: setting.value,
                    height: setting.height,
                    dataTextField: setting.dataValue,
                    dataValueField: setting.dataKey,
                    dataSource: setting.dataSource,
                    optionLabel: optionLabel,
                    minLength: 1,
                    noDataTemplate: '',
                    filter: setting.filter,
                    autoBind: setting.autoBind,
                    template: setting.template
                });

                if (setting.serferFilter) {
                    $('#' + controlId + '_Control').data("kendoDropDownList").bind("filtering", setting.onFiltering);
                }

                //Value
                $('#' + controlId + '_Control').data("kendoDropDownList").value(setting.value.Key);
                $('#' + controlId + '_Control').data("kendoDropDownList").text(setting.value.Value);

                //Change
                if (typeof (setting.onChange) != 'undefined') {
                    $('#' + controlId + '_Control').unbind('change');
                    $('#' + controlId + '_Control').on('change', setting.onChange);
                }

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            } else {
                var e = $.fn.FrameSpan(controlId + '_Control');
                $(this).append(e);

                //Value
                $('#' + controlId + '_Control').html(setting.value.Value);
            }
        }
    };

    $.fn.FrameDropdownList.defaults = $.extend({}, {
        type: 'FrameDropdownList',
        style: "width: 100%; ",
        className: '',
        height: 200,
        value: { Key: '', Value: '' },
        dataSource: [],
        dataKey: 'Key',
        dataValue: 'Value',
        template: '',
        selectType: '',
        optionLabel: '',
        filter: 'none',
        readonly: false,
        serferFilter: false,
        autoBind: true,
        onFiltering: function (e) { },
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameDropdownList.methods = {
        setDataSource: function (my, value) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                if (!value) {
                    value = [];
                }
                $('#' + controlId + '_Control').data("kendoDropDownList").setDataSource(value);
            }
        },
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoDropDownList").value(value.Key);
            } else {
                $('#' + controlId + '_Control').html(value.Value);
            }
        },
        clear: function (my) {
            var controlId = $(my).attr("id");

            $(my).data('value', { Key: '', Value: '' });

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoDropDownList").value('');
            } else {
                $('#' + controlId + '_Control').html('');
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            var value = {};

            if (!$(my).data('readonly')) {
                value.Key = $('#' + controlId + '_Control').data("kendoDropDownList").value();
                value.Value = $('#' + controlId + '_Control').data("kendoDropDownList").text();
            } else {
                value = $(my).data('value');
            }

            return value;
        },
        setIndex: function (my, value) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoDropDownList").select(value);

                var v = {};
                v.Key = $('#' + controlId + '_Control').data("kendoDropDownList").value();
                v.Value = $('#' + controlId + '_Control').data("kendoDropDownList").text();

                $(my).data('value', v);
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
                $('#' + controlId + '_Control').data("kendoDropDownList").enable();
            }
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