(function ($) {
    //FrameRadio Start
    $.fn.FrameRadio = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameRadio.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameRadio.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameRadio.defaults.value;
            }
            if (!setting.dataSource) {
                setting.dataSource = $.fn.FrameRadio.defaults.dataSource;
            }
            $(this).data(setting);

            $(this).empty();

            if (!setting.readonly) {
                //HTML
                var html = '';
                var breakStr = '';
                if (setting.direction == 'horizontal') {
                    breakStr = '&nbsp;&nbsp;';
                } else {
                    breakStr = '<br />';
                }

                for (i = 0; i < setting.dataSource.length; i++) {
                    html += '<input id="' + controlId + '_Control_' + i + '" name="' + controlId + '_Control" value="' + eval("setting.dataSource[i]." + setting.dataKey) + '" type="radio" class="' + setting.inputClass + '">';
                    html += '<label class="' + setting.labelClass + '" for="' + controlId + '_Control_' + i + '">&nbsp;' + eval("setting.dataSource[i]." + setting.dataValue) + '</label>';

                    if (i != setting.dataSource.length - 1) {
                        html += breakStr;
                    }
                }

                $(this).append(html);

                //Value
                if ($.trim(setting.value.Key) != '') {
                    //移除所有选中项
                    $(this).find("input[type='radio']").each(function () {
                        $(this).removeAttr("checked");
                    })
                    //重新复制html内容，否则第二次赋值会无效
                    $(this).html($(this).html());
                    //赋值
                    $(this).find("input[type='radio']").each(function () {
                        if ($(this).val() == setting.value.Key) {
                            $(this).attr("checked", "checked");
                        }
                    })
                }

                //Change
                if (typeof (setting.onChange) != 'undefined') {
                    $(this).unbind('change');
                    $(this).on('change', setting.onChange);
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

    $.fn.FrameRadio.defaults = $.extend({}, {
        type: 'FrameRadio',
        value: { Key: '', Value: '' },
        dataSource: [],
        dataKey: 'Key',
        dataValue: 'Value',
        direction: 'horizontal',//horizontal, vertical
        inputClass: 'k-radio',
        labelClass: 'k-radio-label',
        readonly: false,
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameRadio.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                //移除所有选中项
                $(my).find("input[type='radio']").each(function () {
                    $(this).removeAttr("checked");
                })
                //重新复制html内容，否则第二次赋值会无效
                $(my).html($(my).html());
                //赋值
                $(my).find("input[type='radio']").each(function () {
                    if ($(this).val() == value.Key) {
                        $(this).attr("checked", "checked");
                    }
                })
            } else {
                $('#' + controlId + '_Control').html(value.Value);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            var value = { Key: '', Value: '' };

            if (!$(my).data('readonly')) {
                value.Key = $(my).find("input[type='radio']:checked").length == 0 ? '' : $(my).find("input[type='radio']:checked").val();
                $.each($(my).data('dataSource'), function (i, n) {
                    if (eval("n." + $(my).data('dataKey')) == value.Key) {
                        value.Value = eval("n." + $(my).data('dataValue'));
                    }
                })
            } else {
                value = $(my).data('value');
            }

            return value;
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $(my).find("input[type='radio']").attr("disabled", true);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $(my).find("input[type='radio']").removeAttr("disabled");
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameRadio End
})(jQuery);