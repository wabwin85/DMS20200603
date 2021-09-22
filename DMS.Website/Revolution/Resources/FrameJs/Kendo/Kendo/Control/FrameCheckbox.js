(function ($) {
    //FrameCheckbox Start
    $.fn.FrameCheckbox = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.FrameCheckbox.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.FrameCheckbox.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameCheckbox.defaults.value;
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
                    html += '<input id="' + controlId + '_Control_' + i + '" name="' + controlId + '_Control" value="' + eval("setting.dataSource[i]." + setting.dataKey) + '" type="checkbox" class="' + setting.inputClass + '" data-display="' + eval("setting.dataSource[i]." + setting.dataValue) + '">';
                    html += '<label class="' + setting.labelClass + '" for="' + controlId + '_Control_' + i + '">&nbsp;' + eval("setting.dataSource[i]." + setting.dataValue) + '</label>';

                    if (i != setting.dataSource.length - 1) {
                        html += breakStr;
                    }
                }

                $(this).append(html);

                //Value

                //移除所有选中项
                $(this).find("input[type='checkbox']").each(function () {
                    $(this).removeAttr("checked");
                })
                //重新复制html内容，否则第二次赋值会无效
                $(this).html($(this).html());
                $.each(setting.value, function (i, n) {
                    if ($.trim(setting.value[i].Key) != '') {
                        //赋值
                        $('#' + controlId).find("input[type='checkbox']").each(function () {
                            if ($(this).val() == setting.value[i].Key) {
                                $(this).attr("checked", "checked");
                            }
                        })
                    }
                })

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

                var h = '';
                //Value
                $.each(setting.value, function (i, n) {
                    h += setting.value[i].Value + '; ';
                })
                if (h != '') {
                    h.substring(0, h.length - 2)
                }
                $('#' + controlId + '_Control').html(h);
            }
        }
    };

    $.fn.FrameCheckbox.defaults = $.extend({}, {
        type: 'FrameCheckbox',
        value: [],//[{ Key: '', Value: '' }],
        dataSource: [],
        dataKey: 'Key',
        dataValue: 'Value',
        direction: 'horizontal',//horizontal, vertical
        inputClass: 'k-checkbox',
        labelClass: 'k-checkbox-label',
        readonly: false,
        onChange: function () { },
        onBlur: function () { },
        onFocus: function () { }
    });

    $.fn.FrameCheckbox.methods = {
        setValue: function (my, value) {
            var controlId = $(my).attr("id");

            $(my).data('value', value);

            if (!$(my).data('readonly')) {
                //移除所有选中项
                $(my).find("input[type='checkbox']").each(function () {
                    $(this).removeAttr("checked");
                })
                //重新复制html内容，否则第二次赋值会无效
                $(my).html($(my).html());
                //赋值

                $.each(value, function (i, n) {
                    if ($.trim(value[i].Key) != '') {
                        //赋值
                        $(my).find("input[type='checkbox']").each(function () {
                            if ($(this).val() == value[i].Key) {
                                $(this).attr("checked", "checked");
                            }
                        })
                    }
                })
            } else {
                var h = '';
                //Value
                $.each(value, function (i, n) {
                    h += value[i].Value + '; ';
                })
                if (h != '') {
                    h.substring(0, h.length - 2)
                }
                $('#' + controlId + '_Control').html(h);
            }
        },
        getValue: function (my) {
            var controlId = $(my).attr("id");

            var value = [];

            if (!$(my).data('readonly')) {
                $(my).find("input[type='checkbox']:checked").each(function (i, n) {
                    var v = {};
                    v.Key = $(this).val();
                    v.Value = $(this).data('display');

                    value.push(v);
                })
            } else {
                value = $(my).data('value');
            }

            return value;
        },
        selectAll: function (my) {
            var controlId = $(my).attr("id");
            
            if (!$(my).data('readonly')) {
                var value = [];

                //移除所有选中项
                $(my).find("input[type='checkbox']").each(function () {
                    $(this).removeAttr("checked");
                })
                //重新复制html内容，否则第二次赋值会无效
                $(my).html($(my).html());
                //赋值
                $(my).find("input[type='checkbox']").each(function (i, n) {
                    $(this).attr("checked", "checked");
                    var v = {};
                    v.Key = $(this).val();
                    v.Value = $(this).data('display');

                    value.push(v);
                })

                $(my).data('value', value);
            }
        },
        clear: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                //移除所有选中项
                $(my).find("input[type='checkbox']").each(function () {
                    $(this).removeAttr("checked");
                })
                //重新复制html内容，否则第二次赋值会无效
                $(my).html($(my).html());

                $(my).data('value', []);
            }
        },
        disable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $(my).find("input[type='checkbox']").attr("disabled", true);
            }
        },
        enable: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $(my).find("input[type='checkbox']").removeAttr("disabled");
            }
        },
        error: function (my) {
            //TODO Focus
        },
        removeError: function (my) {
            //TODO Focus
        }
    };
    //FrameCheckbox End
})(jQuery);