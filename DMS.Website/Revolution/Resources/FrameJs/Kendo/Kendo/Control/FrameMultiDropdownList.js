(function ($) {
    //FrameMultiDropdownList Start
    $.fn.FrameMultiDropdownList = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameMultiDropdownList.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var my = $(this);

            var setting = $.extend({}, $.fn.FrameMultiDropdownList.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameMultiDropdownList.defaults.value;
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

                $('#' + controlId + '_Control').kendoMultiSelect({
                    autoClose: false,
                    value: setting.value,
                    height: setting.height,
                    dataTextField: setting.dataValue,
                    dataValueField: setting.dataKey,
                    dataSource: setting.dataSource,
                    placeholder: optionLabel,
                    minLength: 1,
                    noDataTemplate: '',
                    filter: setting.filter,
                    clearButton: false,
                    autoBind: setting.autoBind,
                    itemTemplate: setting.template
                });

                if (setting.serferFilter) {
                    $('#' + controlId + '_Control').data("kendoMultiSelect").bind("filtering", setting.onFiltering);
                }

                //Change
                if (typeof (setting.onChange) != 'undefined') {
                    $('#' + controlId + '_Control').data("kendoMultiSelect").bind("change", setting.onChange);
                }

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            } else {
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

                $('#' + controlId + '_Control').kendoMultiSelect({
                    value: setting.value,
                    dataTextField: setting.dataValue,
                    dataValueField: setting.dataKey,
                    autoBind: false,
                    noDataTemplate: ''
                });

                $('#' + controlId + '_Control').data("kendoMultiSelect").readonly(true);

                my.find('span.k-select').remove();
                my.find('li.k-button').css({ "padding-right": "5.6px" });
            }
        }
    };

    $.fn.FrameMultiDropdownList.defaults = $.extend({}, {
        type: 'FrameMultiDropdownList',
        style: "width: 100%; ",
        className: '',
        height: 200,
        value: [],
        dataSource: [],
        dataKey: 'Key',
        dataValue: 'Value',
        template: '',
        selectType: '',
        optionLabel: '',
        filter: 'none',
        readonly: false,
        autoBind: true,
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameMultiDropdownList.methods = {
        setDataSource: function (my, value) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                if (!value) {
                    value = [];
                }
                $('#' + controlId + '_Control').data("kendoMultiSelect").setDataSource(value);
            }
        },
        setValue: function (my, value) {
            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoMultiSelect").value(value);
            } else {
                $('#' + controlId + '_Control').data("kendoMultiSelect").value(value);
            }
        },
        clear: function (my) {
            var controlId = $(my).attr("id");

            $(my).data('value', []);

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoMultiSelect").value([]);
            } else {
                $('#' + controlId + '_Control').data("kendoMultiSelect").value([]);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            var value = [];

            if (!$(my).data('readonly')) {
                var data = $('#' + controlId + '_Control').data("kendoMultiSelect").dataItems();
                $.each(data, function (i, n) {
                    var item = {};
                    item.Key = n[$(my).data('dataKey')];
                    item.Value = n[$(my).data('dataValue')];

                    value.push(item);
                });
            } else {
                value = $(my).data('value');
            }

            return value;
        },
        getControl: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                return $('#' + controlId + '_Control').data("kendoMultiSelect");
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoMultiSelect").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoMultiSelect").enable();
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameMultiDropdownList End
})(jQuery);