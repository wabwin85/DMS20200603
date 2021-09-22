(function ($) {
    $.getModel = function () {
        var model = {};
        $('.FrameControl').each(function () {
            var controlId = $(this).attr("id");
            if (controlId == undefined) {
                if ($(this).attr("type") == 'hidden') {
                    eval("model." + controlId + " = '" + $(this).val() + "'");
                } else {
                    //$("#dropdownlist").data("kendoDropDownList");
                    var type = $(this).data('type');
                    if (typeof (type) == 'undefined') {
                        eval("model." + controlId + " = null");
                    } else {
                        eval("model." + controlId + " = $(this).Frame" + type + "('getValue')");
                    }
                }
            }
        });

        return model;
    }

    //FrameSpan Start
    $.fn.FrameSpan = function (id) {
        var e = document.createElement("span");
        e.id = id;
        e.className = $.fn.FrameSpan.defaults.className;
        e.style.cssText = $.fn.FrameSpan.defaults.style;

        return e;
    };

    $.fn.FrameSpan.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: ''
    });
    //FrameSpan End

    //FrameLabel Start
    $.fn.FrameLabel = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameLabel.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameLabel.defaults, param1);
            $('#' + controlId).data({
                type: 'Label'
            });

            $('#' + controlId).empty();

            var e = $.fn.FrameSpan(controlId + '_Label');
            $('#' + controlId).append(e);

            //Value
            $('#' + controlId + '_Label').html(setting.value);
        }
    };

    $.fn.FrameLabel.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: ''
    });

    $.fn.FrameLabel.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Label').html(value);
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            return $('#' + controlId + '_Label').html();
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameLabel End

    //FrameTextBox Start
    $.fn.FrameTextBox = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameTextBox.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameTextBox.defaults, param1);
            $('#' + controlId).data({
                mode: setting.mode,
                type: 'TextBox'
            });

            $('#' + controlId).empty();
            if (setting.mode == 'view') {
                //DOM
                var e = $.fn.FrameSpan(controlId + '_TextBox');
                $('#' + controlId).append(e);

                //Value
                $('#' + controlId + '_TextBox').html(setting.value);
            } else {
                //DOM
                var e = document.createElement("input");
                e.id = controlId + '_TextBox';
                e.type = 'text';
                e.style.cssText = setting.style;
                e.className = 'k-textbox ' + setting.className;
                $('#' + controlId).append(e);

                //Value
                $('#' + controlId + '_TextBox').val(setting.value);

                //Change
                if (typeof (setting.onChange) != 'undefined') {
                    $('#' + controlId + '_TextBox').unbind('change');
                    $('#' + controlId + '_TextBox').on('change', setting.onChange);
                }

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            }
        }
    };

    $.fn.FrameTextBox.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: '',
        mode: 'edit',
        value: '',
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameTextBox.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                $('#' + controlId + '_TextBox').html(value);
            } else {
                $('#' + controlId + '_TextBox').val(value);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                return $('#' + controlId + '_TextBox').html();
            } else {
                return $('#' + controlId + '_TextBox').val();
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_TextBox').attr("disabled", true);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_TextBox').removeAttr("disabled");
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameTextBox End

    //FrameNumeric Start
    $.fn.FrameNumeric = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameNumeric.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameNumeric.defaults, param1);
            $('#' + controlId).data({
                mode: setting.mode,
                type: 'Numeric'
            });

            $('#' + controlId).empty();
            if (setting.mode == 'view') {
                //DOM
                var e = $.fn.FrameSpan(controlId + '_Numeric');
                $('#' + controlId).append(e);

                //Value
                $('#' + controlId + '_Numeric').html(setting.value);
            } else {
                //DOM
                var e = document.createElement("input");
                e.id = controlId + '_Numeric';
                e.type = 'text';
                e.style.cssText = setting.style;
                e.className = setting.className;
                $('#' + controlId).append(e);

                $('#' + controlId + '_Numeric').kendoNumericTextBox({
                    decimals: setting.decimals,
                    format: setting.format,
                    max: setting.max,
                    min: setting.min,
                    spinners: setting.spinners,
                    step: setting.step,
                });

                //Value
                $('#' + controlId + '_Numeric').data("kendoNumericTextBox").value(setting.value);

                //Change
                if (typeof (setting.onChange) != 'undefined') {
                    $('#' + controlId + '_Numeric').unbind('change');
                    $('#' + controlId + '_Numeric').on('change', setting.onChange);
                }

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            }
        }
    };

    $.fn.FrameNumeric.defaults = $.extend({}, {
        decimals: 2,
        format: 'n',
        max: null,
        min: null,
        spinners: false,
        step: 1,
        style: "width: 100%; ",
        className: '',
        mode: 'edit',
        value: '',
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameNumeric.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                $('#' + controlId + '_Numeric').html(value);
            } else {
                $('#' + controlId + '_Numeric').data("kendoNumericTextBox").value(value);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                return $('#' + controlId + '_Numeric').html();
            } else {
                return $('#' + controlId + '_Numeric').data("kendoNumericTextBox").value();
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_Numeric').data("kendoNumericTextBox").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_Numeric').data("kendoNumericTextBox").enable(true);
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameNumeric End

    //FrameTextArea Start
    $.fn.FrameTextArea = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameTextArea.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameTextArea.defaults, param1);
            $('#' + controlId).data({
                mode: setting.mode,
                type: 'TextArea'
            });

            $('#' + controlId).empty();
            if (setting.mode == 'view') {
                //DOM
                var e = $.fn.FrameSpan(controlId + '_TextArea');
                $('#' + controlId).append(e);

                //Value
                $('#' + controlId + '_TextArea').html(setting.value);
            } else {
                //DOM
                var e = document.createElement("textarea");
                e.id = controlId + '_TextArea';
                e.style.cssText = setting.style;
                if (setting.resize == false) {
                    e.style.resize = 'none';
                }
                e.className = 'k-textbox ' + setting.className;
                e.rows = setting.rows;
                $('#' + controlId).append(e);

                $('#' + controlId + '_TextArea').height(setting.height);

                //Value
                $('#' + controlId + '_TextArea').val(setting.value);

                //Change
                if (typeof (setting.onChange) != 'undefined') {
                    $('#' + controlId + '_TextArea').unbind('change');
                    $('#' + controlId + '_TextArea').on('change', setting.onChange);
                }

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
                $('#' + controlId + '_TextArea').focus(function () {
                    $('#' + controlId + '_TextArea').select();
                });
            }
        }
    };

    $.fn.FrameTextArea.defaults = $.extend({}, $.fn.FrameTextBox.defaults, {
        resize: false,
        rows: 2,
        height: "auto"
    });

    $.fn.FrameTextArea.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                $('#' + controlId + '_TextArea').html(value);
            } else {
                $('#' + controlId + '_TextArea').val(value);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                return $('#' + controlId + '_TextArea').html();
            } else {
                return $('#' + controlId + '_TextArea').val();
            }
        },
        setRows: function (my, value) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_TextArea').attr("rows", value);
            }
        },
        setHeight: function (my, value) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_TextArea').height(value);
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_TextArea').attr("disabled", true);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_TextArea').removeAttr("disabled");
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameTextArea End

    //FrameDatePicker Start
    $.fn.FrameDatePicker = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameDatePicker.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameDatePicker.defaults, param1);
            $('#' + controlId).data({
                mode: setting.mode,
                type: 'DatePicker'
            });

            $('#' + controlId).empty();
            if (setting.mode == 'view') {
                //DOM
                var e = $.fn.FrameSpan(controlId + '_DatePicker');
                $('#' + controlId).append(e);

                //Value
                $('#' + controlId + '_DatePicker').html(setting.value);
            } else {
                //DOM
                var e = document.createElement("input");
                e.id = controlId + '_DatePicker';
                e.type = 'text';
                e.style.cssText = setting.style;
                e.className = setting.className;
                $('#' + controlId).append(e);

                $('#' + controlId + '_DatePicker').kendoDatePicker({
                    format: setting.format,
                    depth: setting.depth,
                    start: setting.start
                });

                //Value
                $('#' + controlId + '_DatePicker').data("kendoDatePicker").value(setting.value);

                //Change
                if (typeof (setting.onChange) != 'undefined') {
                    $('#' + controlId + '_DatePicker').unbind('change');
                    $('#' + controlId + '_DatePicker').on('change', setting.onChange);
                }

                //Click
                $('#' + controlId + '_DatePicker').removeAttr("onfocus");
                $('#' + controlId + '_DatePicker').click(function () { $('#' + controlId + '_DatePicker').data("kendoDatePicker").open(); });

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            }
        }
    };

    $.fn.FrameDatePicker.defaults = $.extend({}, $.fn.FrameTextBox.defaults, {
        className: '',
        format: "yyyy-MM-dd",
        depth: "month",
        start: "month"
    });

    $.fn.FrameDatePicker.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                $('#' + controlId + '_DatePicker').html(value);
            } else {
                $('#' + controlId + '_DatePicker').data("kendoDatePicker").value(value);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                return $('#' + controlId + '_DatePicker').html();
            } else {
                return $('#' + controlId + '_DatePicker').data("kendoDatePicker").value();
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_DatePicker').data("kendoDatePicker").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_DatePicker').data("kendoDatePicker").enable(true);
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameDatePicker End

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
                mode: setting.mode,
                type: 'DropdownList'
            });

            $('#' + controlId).empty();
            if (setting.mode == 'view') {
                //DOM
                var e = document.createElement("input");
                e.id = controlId + '_DropdownList_Value';
                e.type = 'hidden';
                $('#' + controlId).append(e);

                e = $.fn.FrameSpan(controlId + '_DropdownList_ValueDisplay');
                $('#' + controlId).append(e);

                //Value
                $('#' + controlId + '_DropdownList_Value').val(setting.value);
                $('#' + controlId + '_DropdownList_ValueDisplay').html(setting.valueDisplay);
            } else {
                //DOM
                var e = document.createElement("select");
                e.id = controlId + '_DropdownList';
                e.style.cssText = setting.style;
                e.className = setting.className;
                $('#' + controlId).append(e);

                var optionLabel = '';
                if (setting.selectType == 'all') {
                    optionLabel = '全部';
                } else if (setting.selectType == 'select') {
                    optionLabel = '请选择';
                }

                $('#' + controlId + '_DropdownList').kendoDropDownList({
                    dataTextField: setting.dataValue,
                    dataValueField: setting.dataKey,
                    dataSource: setting.dataSource,
                    optionLabel: optionLabel,
                    noDataTemplate: ''
                });

                //Value
                if ($.trim(setting.value) != '') {
                    //$('#' + controlId + '_DropdownList').data("kendoDropDownList").value(setting.value);
                    $('#' + controlId + '_Control').data("kendoDropDownList").value(setting.value);      
                }

                //Change
                if (typeof (setting.onChange) != 'undefined') {
                    $('#' + controlId + '_DropdownList').unbind('change');
                    $('#' + controlId + '_DropdownList').on('change', setting.onChange);
                }

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            }
        }
    };

    $.fn.FrameDropdownList.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: '',
        mode: 'edit',
        value: '',
        valueDisplay: '',
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

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_DropdownList').data("kendoDropDownList").setDataSource(value);
            }
        },
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                $('#' + controlId + '_DropdownList_Value').val(value);
            } else {
                $('#' + controlId + '_DropdownList').data("kendoDropDownList").value(value);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                return $('#' + controlId + '_DropdownList_Value').val();
            } else {
                return $('#' + controlId + '_DropdownList').data("kendoDropDownList").value();
            }
        },
        getText: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                return $('#' + controlId + '_DropdownList_ValueDisplay').html();
            } else {
                return $('#' + controlId + '_DropdownList').data("kendoDropDownList").text();
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_DropdownList').data("kendoDropDownList").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_DropdownList').data("kendoDropDownList").enable();
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

    //FrameSwitch Start
    $.fn.FrameSwitch = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameSwitch.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameSwitch.defaults, param1);
            $('#' + controlId).data({
                mode: setting.mode,
                type: 'Switch'
            });

            $('#' + controlId).empty();
            if (setting.mode == 'view') {
                //DOM
                var e = document.createElement("input");
                e.id = controlId + '_Switch_Value';
                e.type = 'hidden';
                $('#' + controlId).append(e);

                e = $.fn.FrameSpan(controlId + '_Switch_ValueDisplay');
                $('#' + controlId).append(e);

                //Value
                $('#' + controlId + '_Switch_Value').val(setting.value);
                $('#' + controlId + '_Switch_ValueDisplay').html(setting.valueDisplay);
            } else {
                //DOM
                var e = document.createElement("input");
                e.id = controlId + '_Switch';
                e.type = 'checkbox';
                e.style.cssText = setting.style;
                $('#' + controlId).append(e);

                $('#' + controlId + '_Switch').kendoMobileSwitch({
                    onLabel: setting.onLabel,
                    offLabel: setting.offLabel
                });

                //Value
                $('#' + controlId + '_Switch').data("kendoMobileSwitch").check(setting.value);

                //Change
                if (typeof (setting.onChange) != 'undefined') {
                    $('#' + controlId + '_Switch').unbind('change');
                    $('#' + controlId + '_Switch').on('change', setting.onChange);
                }

                //Blur
                //TODO Blur

                //Focus
                //TODO Focus
            }
        }
    };

    $.fn.FrameSwitch.defaults = $.extend({}, {
        className: '',
        mode: 'edit',
        onLabel: "是",
        offLabel: "否",
        value: false,
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameSwitch.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                $('#' + controlId + '_Switch_Value').val(value);
            } else {
                $('#' + controlId + '_Switch').data("kendoMobileSwitch").check(value);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') == 'view') {
                return $('#' + controlId + '_Switch_Value').val();
            } else {
                return $('#' + controlId + '_Switch').data("kendoMobileSwitch").check();
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_Switch').data("kendoMobileSwitch").enable(false);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if ($(my).data('mode') != 'view') {
                $('#' + controlId + '_Switch').data("kendoMobileSwitch").enable(true);
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameSwitch End

    //FrameButton Start
    $.fn.FrameButton = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameButton.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameButton.defaults, param1);

            $('#' + controlId).kendoButton({
                click: setting.onClick
            });
        }
    };

    $.fn.FrameButton.defaults = $.extend({}, {
        onClick: function () { }
    });

    $.fn.FrameButton.methods = {
        disable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId).data("kendoButton").enable(false);
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            $('#' + controlId).data("kendoButton").enable();
        }
    };
    //FrameButton End
})(jQuery);