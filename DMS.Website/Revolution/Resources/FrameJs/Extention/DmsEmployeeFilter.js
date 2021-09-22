(function ($) {
    //DmsEmployeeFilter Start
    $.fn.DmsEmployeeFilter = function (param1, param2, param3) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.DmsEmployeeFilter.methods[param1];
            if (func) {
                return func(this, param2, param3);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.DmsEmployeeFilter.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.DmsEmployeeFilter.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            if (!setting.readonly) {
                //DOM
                var html = '';
                html += '<select id="' + controlId + '_Control" class="' + setting.className + '" style="' + setting.style + '"></select>';

                $(this).append(html);

                var optionLabel = '';
                if (setting.selectType == 'all') {
                    optionLabel = '全部';
                } else if (setting.selectType == 'select') {
                    optionLabel = '请选择';
                }

                var filtering;
                var opening;
                if (setting.serferFilter) {
                    opening = function () {
                        var message = setting.checkRequire.call(this, $('#' + controlId).data('parameters'));
                        if (message.length > 0) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: message,
                            });
                        }
                    };

                    filtering= function (e) {
                        if (e.filter.value.length == 0) {
                            $('#' + controlId + '_Control').data("kendoDropDownList").setDataSource([]);
                        } else {
                            var requestData = {};
                            requestData.DelegateBusiness = setting.delegateBusiness;
                            requestData.Parameters = $('#' + controlId).data('parameters');
                            requestData.QryString = e.filter.value;

                            FrameWindow.ShowLoading();
                            FrameUtil.SubmitAjax({
                                business: 'Util.EmployeeFilter',
                                method: 'Filter',
                                url: Common.AppHandler,
                                data: requestData,
                                callback: function (responseData) {
                                    $('#' + controlId + '_Control').data("kendoDropDownList").setDataSource(responseData.RstResult);

                                    FrameWindow.HideLoading();
                                },
                            });
                        }
                    };
                } else {
                    opening = function () { };
                    filtering = function (e) { };
                }

                if (setting.dataSource.length == 0 && setting.value.Key != '') {
                    var item = {};
                    eval("item." + setting.dataKey + " = '" + setting.value.Key + "'");
                    eval("item." + setting.dataValue + " = '" + setting.value.Value + "'");
                    setting.dataSource.push(item);
                }

                $('#' + controlId + '_Control').kendoDropDownList({
                    height: setting.height,
                    dataTextField: setting.dataValue,
                    dataValueField: setting.dataKey,
                    dataSource: setting.dataSource,
                    optionLabel: optionLabel,
                    noDataTemplate: '',
                    clearButton: true,
                    minLength: 1,
                    filter: setting.filter,
                    template: setting.template,
                    value: setting.value.Key,
                    text: setting.value.Value,
                    change: setting.onChange,
                    open: opening,
                    filtering: filtering
                });
                
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

    $.fn.DmsEmployeeFilter.defaults = $.extend({}, {
        type: 'DmsEmployeeFilter',
        delegateBusiness: '',
        parameters: {},
        style: "width: 100%; ",
        className: '',
        height: 200,
        value: { Key: '', Value: '' },
        dataSource: [],
        dataKey: '',
        dataValue: '',
        template: '',
        selectType: '',
        filter: 'none',
        readonly: false,
        serferFilter: false,
        checkRequire: function (parameters) {
            var message = [];
            return message;
        },
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.DmsEmployeeFilter.methods = {
        setDataSource: function (my, value) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Control').data("kendoDropDownList").setDataSource(value);
            }
        },
        setParameters: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('parameters', value);
        },
        setParameter: function (my, key, value) {
            var controlId = $(my).attr("id");

            var parameters = $(my).data('parameters');
            eval("parameters." + key + " = value");

            $(my).data('parameters', parameters);
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
    //DmsEmployeeFilter End
})(jQuery);