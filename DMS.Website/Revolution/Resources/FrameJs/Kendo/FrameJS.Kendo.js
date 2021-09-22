(function($) {
    $.fn.extend({
        rowspan: function(colIdx) {
            return this.each(function() {
                var that;
                $("tr", this).each(function(row) {
                    $("td:eq(" + colIdx + ")", this).filter(":visible").each(function(col) {
                        if (that != null && $(this).html() == $(that).html()) {
                            rowspan = $(that).attr("rowSpan");
                            if (rowspan == undefined) {
                                $(that).attr("rowSpan", 1);
                                rowspan = $(that).attr("rowSpan");
                            }
                            rowspan = Number(rowspan) + 1;
                            $(that).attr("rowSpan", rowspan);
                            $(this).hide();
                        } else {
                            that = this;
                        }
                    });
                });
            });
        }
    });
    $.fn.slideLeftHide = function(speed, callback) {
        this.animate({
            width: "hide",
            paddingLeft: "hide",
            paddingRight: "hide",
            marginLeft: "hide",
            marginRight: "hide"
        }, speed, callback);
    };
    $.fn.slideLeftShow = function(speed, callback) {
        this.animate({
            width: "show",
            paddingLeft: "show",
            paddingRight: "show",
            marginLeft: "show",
            marginRight: "show"
        }, speed, callback);
    };
    $.fn.flash = function(color, duration) {
        var current = this.css("color");
        this.animate({
            color: color
        }, duration / 2);
        this.animate({
            color: current
        }, duration / 2);
    };
    $.extend({
        isNullOrEmpty: function(s) {
            var t = typeof s;
            if (t == "undefined" || s == null) {
                return true;
            } else {
                if (t == "string" && s == "") {
                    return true;
                } else {
                    return false;
                }
            }
        }
    });
})(jQuery);

var Common = {};

Common = function() {
    var that = {};
    that.AppVirtualPath = "";
    that.PageHome = "";
    that.GetUrlParam = function(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return decodeURIComponent(r[2]);
        return "";
    };
    that.GetStringParam = function(str, name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = str.match(reg);
        if (r != null) return unescape(r[2]);
        return "";
    };
    that.GetUrlParamList = function() {
        var rtn = {};
        var url = location.href;
        if (url.indexOf("?") !== -1) {
            var str = url.substr(url.indexOf("?") + 1) + "&";
            var strs = str.split("&");
            for (var i = 0; i < strs.length - 1; i++) {
                var key = strs[i].substring(0, strs[i].indexOf("="));
                var val = strs[i].substring(strs[i].indexOf("=") + 1);
                rtn[key] = val;
            }
        }
        return rtn;
    };
    that.UpdateUrlParams = function(url, name, value) {
        var r = url;
        if (r != null && r != "undefined" && r != "") {
            value = encodeURIComponent(value);
            var reg = new RegExp("(^|)" + name + "=([^&]*)(|$)");
            var tmp = name + "=" + value;
            if (url.match(reg) != null) {
                r = url.replace(eval(reg), tmp);
            } else {
                if (url.match("[?]")) {
                    r = url + "&" + tmp;
                } else {
                    r = url + "?" + tmp;
                }
            }
        }
        return r;
    };
    that.StringContains = function(source, words, split) {
        var s = source.split(split);
        for (i = 0; i < s.length; i++) {
            if (s[i] == words) {
                return true;
            }
        }
        return false;
    };
    that.GetTimestamp = function() {
        var timestamp = Date.parse(new Date());
        return timestamp / 1e3;
    };
    that.FormatDate = function(date, fmt) {
        var o = {
            "M+": date.getMonth() + 1,
            "d+": date.getDate(),
            "h+": date.getHours(),
            "m+": date.getMinutes(),
            "s+": date.getSeconds(),
            "q+": Math.floor((date.getMonth() + 3) / 3),
            S: date.getMilliseconds()
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o) if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
        return fmt;
    };
    return that;
}();

(function($) {
    $.fn.FrameButton = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        if (typeof param1 == "string") {
            var func = $.fn.FrameButton.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var my = $(this);
            var setting = $.extend({}, $.fn.FrameButton.defaults, param1);
            my.addClass(setting.className);
            my.css(setting.style);
            if (setting.icon == "") {
                my.html(setting.text);
            } else {
                my.html('<i class="fa fa-fw fa-' + setting.icon + '"></i>&nbsp;&nbsp;' + setting.text);
            }
            my.kendoButton({
                click: setting.onClick
            });
        }
    };
    $.fn.FrameButton.defaults = $.extend({}, {
        text: "",
        icon: "",
        style: {},
        className: "btn-primary",
        onClick: function() {}
    });
    $.fn.FrameButton.methods = {
        disable: function(my) {
            $(my).data("kendoButton").enable(false);
        },
        enable: function(my) {
            $(my).data("kendoButton").enable();
        },
        getControl: function(my) {
            return $(my).data("kendoButton");
        }
    };
})(jQuery);

(function($) {
    $.fn.FrameControl = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameControl.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        }
    };
    $.fn.FrameControl.methods = {
        getValue: function(my) {
            var controlId = $(my).attr("id");
            if ($(my).attr("type") == "hidden") {
                return $(my).val();
            } else {
                var type = $(my).data("type");
                if (typeof type == "undefined") {
                    return null;
                } else {
                    var rtn = "";
                    eval("rtn = $(my)." + type + "('getValue')");
                    return rtn;
                }
            }
        }
    };
})(jQuery);

(function($) {
    $.fn.FrameDatePicker = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameDatePicker.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameDatePicker.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameDatePicker.defaults.value;
            }
            $(this).data(setting);
            $(this).empty();
            if (!setting.readonly) {
                var html = "";
                html += '<input id="' + controlId + '_Control" type="text" class="' + setting.className + '" style="' + setting.style + '" />';
                $(this).append(html);
                setting.min = $.isNullOrEmpty(setting.min) ? "1900-01-01" : setting.min;
                setting.max = $.isNullOrEmpty(setting.max) ? "2099-12-31" : setting.max;
                $("#" + controlId + "_Control").kendoDatePicker({
                    format: setting.format,
                    depth: setting.depth,
                    start: setting.start,
                    min: setting.min,
                    max: setting.max
                });
                $("#" + controlId + "_Control").data("kendoDatePicker").value(setting.value);
                $("#" + controlId + "_Control").data("kendoDatePicker").bind("change", setting.onChange);
                $("#" + controlId + "_Control").removeAttr("onfocus");
                $("#" + controlId + "_Control").click(function() {
                    $("#" + controlId + "_Control").data("kendoDatePicker").open();
                });
            } else {
                var e = $.fn.FrameSpan(controlId + "_Control");
                $(this).append(e);
                $("#" + controlId + "_Control").html(setting.value);
            }
        }
    };
    $.fn.FrameDatePicker.defaults = $.extend({}, {
        type: "FrameDatePicker",
        style: "width: 100%; ",
        className: "",
        value: "",
        format: "yyyy-MM-dd",
        min: "1900-01-01",
        max: "2099-12-31",
        depth: "month",
        start: "month",
        readonly: false,
        onChange: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameDatePicker.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoDatePicker").value(value);
            } else {
                $("#" + controlId + "_Control").html(value);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                if ($("#" + controlId + "_Control").data("kendoDatePicker").value() != null) {
                    return kendo.toString($("#" + controlId + "_Control").data("kendoDatePicker").value(), $(my).data("format"));
                } else {
                    return null;
                }
            } else {
                return $(my).data("value");
            }
        },
        getControl: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Control").data("kendoDatePicker");
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoDatePicker").enable(false);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoDatePicker").enable(true);
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameDatePickerRange = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameDatePickerRange.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameDatePickerRange.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameDatePickerRange.defaults.value;
            }
            $(this).data(setting);
            $(this).empty();
            if (!setting.readonly) {
                var html = "";
                html += '<div class="col-xs-12">';
                html += '   <div class="row">';
                html += '       <div class="col-xs-5" style="width: 47% !important">';
                html += '           <div class="row">';
                html += '               <input type="text" id="' + controlId + '_StartDate_Control" class="' + setting.className + '" style="' + setting.style + '" />';
                html += "           </div>";
                html += "       </div>";
                html += '       <div class="col-xs-2 text-center" style="width: 6% !important; padding: 0;">';
                html += '           <div class="row" style="margin: 0px;">-</div>';
                html += "       </div>";
                html += '       <div class="col-xs-5" style="width: 47% !important">';
                html += '           <div class="row">';
                html += '               <input type="text" id="' + controlId + '_EndDate_Control" class="' + setting.className + '" style="' + setting.style + '" />';
                html += "           </div>";
                html += "       </div>";
                html += "   </div>";
                html += "</div>";
                $(this).append(html);
                var start = $("#" + controlId + "_StartDate_Control").kendoDatePicker({
                    format: setting.format,
                    depth: setting.depth,
                    start: setting.start,
                    min: setting.min,
                    max: setting.max
                }).data("kendoDatePicker");
                var end = $("#" + controlId + "_EndDate_Control").kendoDatePicker({
                    format: setting.format,
                    depth: setting.depth,
                    start: setting.start,
                    min: setting.min,
                    max: setting.max
                }).data("kendoDatePicker");
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
                $("#" + controlId + "_StartDate_Control").unbind("change");
                $("#" + controlId + "_StartDate_Control").on("change", function() {
                    var startDate = start.value();
                    if (startDate) {
                        end.min(new Date(startDate));
                    } else {
                        end.min(new Date(1900, 1, 1));
                    }
                    if (typeof setting.onChangeStartDate != "undefined") {
                        setting.onChangeStartDate.call(this);
                    }
                });
                $("#" + controlId + "_EndDate_Control").unbind("change");
                $("#" + controlId + "_EndDate_Control").on("change", function() {
                    var endDate = end.value();
                    if (endDate) {
                        start.max(new Date(endDate));
                    } else {
                        start.max(new Date(2099, 12, 31));
                    }
                    if (typeof setting.onChangeEndDate != "undefined") {
                        setting.onChangeEndDate.call(this);
                    }
                });
                $("#" + controlId + "_StartDate_Control").removeAttr("onfocus");
                $("#" + controlId + "_StartDate_Control").click(function() {
                    start.open();
                });
                $("#" + controlId + "_EndDate_Control").removeAttr("onfocus");
                $("#" + controlId + "_EndDate_Control").click(function() {
                    end.open();
                });
            } else {
                var e = $.fn.FrameSpan(controlId + "_Control");
                $(this).append(e);
                var label = "";
                label += setting.value.StartDate == "" ? setting.startLabel : setting.value.StartDate;
                label += " - ";
                label += setting.value.EndDate == "" ? setting.endLabel : setting.value.EndDate;
                $("#" + controlId + "_Control").html(label);
            }
        }
    };
    $.fn.FrameDatePickerRange.defaults = $.extend({}, {
        type: "FrameDatePickerRange",
        style: "width: 100%; ",
        className: "",
        value: {
            StartDate: "",
            EndDate: ""
        },
        format: "yyyy-MM-dd",
        min: "1900-01-01",
        max: "2099-12-31",
        depth: "month",
        start: "month",
        startLabel: "",
        endLabel: "",
        readonly: false,
        onChangeStartDate: function() {},
        onChangeEndDate: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameDatePickerRange.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_StartDate_Control").data("kendoDatePicker").value(value.StartDate);
                $("#" + controlId + "_EndDate_Control").data("kendoDatePicker").value(value.EndDate);
            } else {
                var label = "";
                label += value.StartDate == "" ? $(my).data("startLabel") : value.StartDate;
                label += " - ";
                label += value.EndDate == "" ? $(my).data("endLabel") : value.EndDate;
                $("#" + controlId + "_Control").html(label);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            var value = {};
            if ($(my).data("readonly")) {
                value = $(my).data("value");
            } else {
                if ($("#" + controlId + "_StartDate_Control").data("kendoDatePicker").value() != null) {
                    value.StartDate = kendo.toString($("#" + controlId + "_StartDate_Control").data("kendoDatePicker").value(), $(my).data("format"));
                } else {
                    value.StartDate = "";
                }
                if ($("#" + controlId + "_EndDate_Control").data("kendoDatePicker").value() != null) {
                    value.EndDate = kendo.toString($("#" + controlId + "_EndDate_Control").data("kendoDatePicker").value(), $(my).data("format"));
                } else {
                    value.EndDate = "";
                }
            }
            return value;
        },
        getControlStartDate: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_StartDate_Control").data("kendoDatePicker");
            }
        },
        getControlEndDate: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_EndDate_Control").data("kendoDatePicker");
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_StartDate_Control").data("kendoDatePicker").enable(false);
                $("#" + controlId + "_EndDate_Control").data("kendoDatePicker").enable(false);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$("#" + controlId).data("readonly")) {
                $("#" + controlId + "_StartDate_Control").data("kendoDatePicker").enable(true);
                $("#" + controlId + "_EndDate_Control").data("kendoDatePicker").enable(true);
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameDropdownList = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameDropdownList.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
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
                var html = "";
                html += '<select id="' + controlId + '_Control" class="' + setting.className + '" style="' + setting.style + '"></select>';
                my.append(html);
                var optionLabel = setting.optionLabel;
                if (optionLabel == "") {
                    if (setting.selectType == "all") {
                        optionLabel = "全部";
                    } else if (setting.selectType == "select") {
                        optionLabel = "请选择";
                    }
                }
                if ((setting.dataSource == null || setting.dataSource.length == 0) && $.trim(setting.value.Key) != "") {
                    setting.dataSource = [];
                    setting.dataSource.push(setting.value);
                }
                $("#" + controlId + "_Control").kendoDropDownList({
                    value: setting.value,
                    height: setting.height,
                    dataTextField: setting.dataValue,
                    dataValueField: setting.dataKey,
                    dataSource: setting.dataSource,
                    optionLabel: optionLabel,
                    minLength: 1,
                    noDataTemplate: "",
                    filter: setting.filter,
                    autoBind: setting.autoBind,
                    template: setting.template
                });
                if (setting.serferFilter) {
                    $("#" + controlId + "_Control").data("kendoDropDownList").bind("filtering", setting.onFiltering);
                }
                $("#" + controlId + "_Control").data("kendoDropDownList").value(setting.value.Key);
                $("#" + controlId + "_Control").data("kendoDropDownList").text(setting.value.Value);
                if (typeof setting.onChange != "undefined") {
                    $("#" + controlId + "_Control").unbind("change");
                    $("#" + controlId + "_Control").on("change", setting.onChange);
                }
            } else {
                var e = $.fn.FrameSpan(controlId + "_Control");
                $(this).append(e);
                $("#" + controlId + "_Control").html(setting.value.Value);
            }
        }
    };
    $.fn.FrameDropdownList.defaults = $.extend({}, {
        type: "FrameDropdownList",
        style: "width: 100%; ",
        className: "",
        height: 200,
        value: {
            Key: "",
            Value: ""
        },
        dataSource: [],
        dataKey: "Key",
        dataValue: "Value",
        template: "",
        selectType: "",
        optionLabel: "",
        filter: "none",
        readonly: false,
        serferFilter: false,
        autoBind: true,
        onFiltering: function(e) {},
        onChange: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameDropdownList.methods = {
        setDataSource: function(my, value) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                if (!value) {
                    value = [];
                }
                $("#" + controlId + "_Control").data("kendoDropDownList").setDataSource(value);
            }
        },
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoDropDownList").value(value.Key);
            } else {
                $("#" + controlId + "_Control").html(value.Value);
            }
        },
        clear: function(my) {
            var controlId = $(my).attr("id");
            $(my).data("value", {
                Key: "",
                Value: ""
            });
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoDropDownList").value("");
            } else {
                $("#" + controlId + "_Control").html("");
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            var value = {};
            if (!$(my).data("readonly")) {
                value.Key = $("#" + controlId + "_Control").data("kendoDropDownList").value();
                value.Value = $("#" + controlId + "_Control").data("kendoDropDownList").text();
            } else {
                value = $(my).data("value");
            }
            return value;
        },
        setIndex: function(my, value) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoDropDownList").select(value);
                var v = {};
                v.Key = $("#" + controlId + "_Control").data("kendoDropDownList").value();
                v.Value = $("#" + controlId + "_Control").data("kendoDropDownList").text();
                $(my).data("value", v);
            }
        },
        getControl: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Control").data("kendoDropDownList");
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoDropDownList").enable(false);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoDropDownList").enable();
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameMultiDropdownList = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameMultiDropdownList.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
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
                var html = "";
                html += '<select id="' + controlId + '_Control" class="' + setting.className + '" style="' + setting.style + '"></select>';
                my.append(html);
                var optionLabel = setting.optionLabel;
                if (optionLabel == "") {
                    if (setting.selectType == "all") {
                        optionLabel = "全部";
                    } else if (setting.selectType == "select") {
                        optionLabel = "请选择";
                    }
                }
                $("#" + controlId + "_Control").kendoMultiSelect({
                    autoClose: false,
                    value: setting.value,
                    height: setting.height,
                    dataTextField: setting.dataValue,
                    dataValueField: setting.dataKey,
                    dataSource: setting.dataSource,
                    placeholder: optionLabel,
                    minLength: 1,
                    noDataTemplate: "",
                    filter: setting.filter,
                    clearButton: false,
                    autoBind: setting.autoBind,
                    itemTemplate: setting.template
                });
                if (setting.serferFilter) {
                    $("#" + controlId + "_Control").data("kendoMultiSelect").bind("filtering", setting.onFiltering);
                }
                if (typeof setting.onChange != "undefined") {
                    $("#" + controlId + "_Control").data("kendoMultiSelect").bind("change", setting.onChange);
                }
            } else {
                var html = "";
                html += '<select id="' + controlId + '_Control" class="' + setting.className + '" style="' + setting.style + '"></select>';
                my.append(html);
                var optionLabel = setting.optionLabel;
                if (optionLabel == "") {
                    if (setting.selectType == "all") {
                        optionLabel = "全部";
                    } else if (setting.selectType == "select") {
                        optionLabel = "请选择";
                    }
                }
                $("#" + controlId + "_Control").kendoMultiSelect({
                    value: setting.value,
                    dataTextField: setting.dataValue,
                    dataValueField: setting.dataKey,
                    autoBind: false,
                    noDataTemplate: ""
                });
                $("#" + controlId + "_Control").data("kendoMultiSelect").readonly(true);
                my.find("span.k-select").remove();
                my.find("li.k-button").css({
                    "padding-right": "5.6px"
                });
            }
        }
    };
    $.fn.FrameMultiDropdownList.defaults = $.extend({}, {
        type: "FrameMultiDropdownList",
        style: "width: 100%; ",
        className: "",
        height: 200,
        value: [],
        dataSource: [],
        dataKey: "Key",
        dataValue: "Value",
        template: "",
        selectType: "",
        optionLabel: "",
        filter: "none",
        readonly: false,
        autoBind: true,
        onChange: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameMultiDropdownList.methods = {
        setDataSource: function(my, value) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                if (!value) {
                    value = [];
                }
                $("#" + controlId + "_Control").data("kendoMultiSelect").setDataSource(value);
            }
        },
        setValue: function(my, value) {
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoMultiSelect").value(value);
            } else {
                $("#" + controlId + "_Control").data("kendoMultiSelect").value(value);
            }
        },
        clear: function(my) {
            var controlId = $(my).attr("id");
            $(my).data("value", []);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoMultiSelect").value([]);
            } else {
                $("#" + controlId + "_Control").data("kendoMultiSelect").value([]);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            var value = [];
            if (!$(my).data("readonly")) {
                var data = $("#" + controlId + "_Control").data("kendoMultiSelect").dataItems();
                $.each(data, function(i, n) {
                    var item = {};
                    item.Key = n[$(my).data("dataKey")];
                    item.Value = n[$(my).data("dataValue")];
                    value.push(item);
                });
            } else {
                value = $(my).data("value");
            }
            return value;
        },
        getControl: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Control").data("kendoMultiSelect");
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoMultiSelect").enable(false);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoMultiSelect").enable();
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {})(jQuery);

(function($) {
    $.fn.FrameLabel = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameLabel.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameLabel.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameLabel.defaults.value;
            }
            $(this).data(setting);
            $(this).empty();
            var e = $.fn.FrameSpan(controlId + "_Control");
            $(this).append(e);
            $("#" + controlId + "_Control").html(setting.value);
        }
    };
    $.fn.FrameLabel.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: "",
        value: ""
    });
    $.fn.FrameLabel.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            $("#" + controlId + "_Control").html(value);
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            return $(my).data("value");
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameNumeric = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameNumeric.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameNumeric.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameNumeric.defaults.value;
            }
            $(this).data(setting);
            $(this).empty();
            if (!setting.readonly) {
                var html = "";
                html += '<input id="' + controlId + '_Control" type="number" class="' + setting.className + '" style="' + setting.style + '" />';
                $(this).append(html);
                $("#" + controlId + "_Control").kendoNumericTextBox({
                    decimals: setting.decimals,
                    format: setting.format,
                    max: setting.max,
                    min: setting.min,
                    spinners: setting.spinners,
                    step: setting.step,
                    placeholder: setting.placeholder,
                    value: setting.value
                });
                if (typeof setting.onChange != "undefined") {
                    $("#" + controlId + "_Control").unbind("change");
                    $("#" + controlId + "_Control").data("kendoNumericTextBox").setOptions({
                        change: setting.onChange
                    });
                }
            } else {
                var e = $.fn.FrameSpan(controlId + "_Control");
                $(this).append(e);
                $("#" + controlId + "_Control").html(kendo.toString(setting.value, setting.format));
            }
        }
    };
    $.fn.FrameNumeric.defaults = $.extend({}, {
        type: "FrameNumeric",
        decimals: 2,
        format: "n",
        max: null,
        min: null,
        spinners: false,
        step: 1,
        style: "width: 100%; ",
        className: "",
        value: null,
        placeholder: "",
        readonly: false,
        onChange: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameNumeric.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoNumericTextBox").value(value);
            } else {
                $("#" + controlId + "_Control").html(kendo.toString(value, $(my).data("format")));
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Control").data("kendoNumericTextBox").value();
            } else {
                return $(my).data("value");
            }
        },
        getControl: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Control").data("kendoNumericTextBox");
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoNumericTextBox").enable(false);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoNumericTextBox").enable(true);
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameNumericLabel = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameNumericLabel.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameNumericLabel.defaults, param1);
            $(this).data(setting);
            $(this).empty();
            $(this).append('<span class="frame-label" style="width: 100%;" />');
            $(this).find(".frame-label").html(kendo.toString(setting.value, setting.format));
        }
    };
    $.fn.FrameNumericLabel.defaults = $.extend({}, {
        style: "width: 100%; ",
        value: 0,
        className: "",
        format: "N2"
    });
    $.fn.FrameNumericLabel.methods = {
        setValue: function(my, value) {
            $(my).data("value", value);
            $(my).find(".frame-label").html(kendo.toString(value, $(my).data("format")));
        },
        getValue: function(my) {
            return $(my).data("value");
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameRadio = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameRadio.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
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
                var html = "";
                var breakStr = "";
                if (setting.direction == "horizontal") {
                    breakStr = "&nbsp;&nbsp;";
                } else {
                    breakStr = "<br />";
                }
                for (i = 0; i < setting.dataSource.length; i++) {
                    html += '<input id="' + controlId + "_Control_" + i + '" name="' + controlId + '_Control" value="' + eval("setting.dataSource[i]." + setting.dataKey) + '" type="radio" class="' + setting.inputClass + '">';
                    html += '<label class="' + setting.labelClass + '" for="' + controlId + "_Control_" + i + '">&nbsp;' + eval("setting.dataSource[i]." + setting.dataValue) + "</label>";
                    if (i != setting.dataSource.length - 1) {
                        html += breakStr;
                    }
                }
                $(this).append(html);
                if ($.trim(setting.value.Key) != "") {
                    $(this).find("input[type='radio']").each(function() {
                        $(this).removeAttr("checked");
                    });
                    $(this).html($(this).html());
                    $(this).find("input[type='radio']").each(function() {
                        if ($(this).val() == setting.value.Key) {
                            $(this).attr("checked", "checked");
                        }
                    });
                }
                if (typeof setting.onChange != "undefined") {
                    $(this).unbind("change");
                    $(this).on("change", setting.onChange);
                }
            } else {
                var e = $.fn.FrameSpan(controlId + "_Control");
                $(this).append(e);
                $("#" + controlId + "_Control").html(setting.value.Value);
            }
        }
    };
    $.fn.FrameRadio.defaults = $.extend({}, {
        type: "FrameRadio",
        value: {
            Key: "",
            Value: ""
        },
        dataSource: [],
        dataKey: "Key",
        dataValue: "Value",
        direction: "horizontal",
        inputClass: "k-radio",
        labelClass: "k-radio-label",
        readonly: false,
        onChange: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameRadio.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $(my).find("input[type='radio']").each(function() {
                    $(this).removeAttr("checked");
                });
                $(my).html($(my).html());
                $(my).find("input[type='radio']").each(function() {
                    if ($(this).val() == value.Key) {
                        $(this).attr("checked", "checked");
                    }
                });
            } else {
                $("#" + controlId + "_Control").html(value.Value);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            var value = {
                Key: "",
                Value: ""
            };
            if (!$(my).data("readonly")) {
                value.Key = $(my).find("input[type='radio']:checked").length == 0 ? "" : $(my).find("input[type='radio']:checked").val();
                $.each($(my).data("dataSource"), function(i, n) {
                    if (eval("n." + $(my).data("dataKey")) == value.Key) {
                        value.Value = eval("n." + $(my).data("dataValue"));
                    }
                });
            } else {
                value = $(my).data("value");
            }
            return value;
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $(my).find("input[type='radio']").attr("disabled", true);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $(my).find("input[type='radio']").removeAttr("disabled");
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameCheckbox = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameCheckbox.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameCheckbox.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameCheckbox.defaults.value;
            }
            $(this).data(setting);
            $(this).empty();
            if (!setting.readonly) {
                var html = "";
                var breakStr = "";
                if (setting.direction == "horizontal") {
                    breakStr = "&nbsp;&nbsp;";
                } else {
                    breakStr = "<br />";
                }
                for (i = 0; i < setting.dataSource.length; i++) {
                    html += '<input id="' + controlId + "_Control_" + i + '" name="' + controlId + '_Control" value="' + eval("setting.dataSource[i]." + setting.dataKey) + '" type="checkbox" class="' + setting.inputClass + '" data-display="' + eval("setting.dataSource[i]." + setting.dataValue) + '">';
                    html += '<label class="' + setting.labelClass + '" for="' + controlId + "_Control_" + i + '">&nbsp;' + eval("setting.dataSource[i]." + setting.dataValue) + "</label>";
                    if (i != setting.dataSource.length - 1) {
                        html += breakStr;
                    }
                }
                $(this).append(html);
                $(this).find("input[type='checkbox']").each(function() {
                    $(this).removeAttr("checked");
                });
                $(this).html($(this).html());
                $.each(setting.value, function(i, n) {
                    if ($.trim(setting.value[i].Key) != "") {
                        $("#" + controlId).find("input[type='checkbox']").each(function() {
                            if ($(this).val() == setting.value[i].Key) {
                                $(this).attr("checked", "checked");
                            }
                        });
                    }
                });
                if (typeof setting.onChange != "undefined") {
                    $(this).unbind("change");
                    $(this).on("change", setting.onChange);
                }
            } else {
                var e = $.fn.FrameSpan(controlId + "_Control");
                $(this).append(e);
                var h = "";
                $.each(setting.value, function(i, n) {
                    h += setting.value[i].Value + "; ";
                });
                if (h != "") {
                    h.substring(0, h.length - 2);
                }
                $("#" + controlId + "_Control").html(h);
            }
        }
    };
    $.fn.FrameCheckbox.defaults = $.extend({}, {
        type: "FrameCheckbox",
        value: [],
        dataSource: [],
        dataKey: "Key",
        dataValue: "Value",
        direction: "horizontal",
        inputClass: "k-checkbox",
        labelClass: "k-checkbox-label",
        readonly: false,
        onChange: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameCheckbox.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $(my).find("input[type='checkbox']").each(function() {
                    $(this).removeAttr("checked");
                });
                $(my).html($(my).html());
                $.each(value, function(i, n) {
                    if ($.trim(value[i].Key) != "") {
                        $(my).find("input[type='checkbox']").each(function() {
                            if ($(this).val() == value[i].Key) {
                                $(this).attr("checked", "checked");
                            }
                        });
                    }
                });
            } else {
                var h = "";
                $.each(value, function(i, n) {
                    h += value[i].Value + "; ";
                });
                if (h != "") {
                    h.substring(0, h.length - 2);
                }
                $("#" + controlId + "_Control").html(h);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            var value = [];
            if (!$(my).data("readonly")) {
                $(my).find("input[type='checkbox']:checked").each(function(i, n) {
                    var v = {};
                    v.Key = $(this).val();
                    v.Value = $(this).data("display");
                    value.push(v);
                });
            } else {
                value = $(my).data("value");
            }
            return value;
        },
        selectAll: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                var value = [];
                $(my).find("input[type='checkbox']").each(function() {
                    $(this).removeAttr("checked");
                });
                $(my).html($(my).html());
                $(my).find("input[type='checkbox']").each(function(i, n) {
                    $(this).attr("checked", "checked");
                    var v = {};
                    v.Key = $(this).val();
                    v.Value = $(this).data("display");
                    value.push(v);
                });
                $(my).data("value", value);
            }
        },
        clear: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $(my).find("input[type='checkbox']").each(function() {
                    $(this).removeAttr("checked");
                });
                $(my).html($(my).html());
                $(my).data("value", []);
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $(my).find("input[type='checkbox']").attr("disabled", true);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $(my).find("input[type='checkbox']").removeAttr("disabled");
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameSpan = function(id) {
        var html = "";
        html += '<span id="' + id + '" class="frame-label ' + $.fn.FrameSpan.defaults.className + '" style="' + $.fn.FrameSpan.defaults.style + '" />';
        $(this).append(html);
        return html;
    };
    $.fn.FrameSpan.defaults = $.extend({}, {
        style: "width: 100%; ",
        className: ""
    });
})(jQuery);

(function($) {
    $.fn.FrameSwitch = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameSwitch.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameSwitch.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameSwitch.defaults.value;
            }
            $(this).data(setting);
            $(this).empty();
            if (!setting.readonly) {
                var e = document.createElement("input");
                e.id = controlId + "_Control";
                e.type = "checkbox";
                e.style.cssText = setting.style;
                $(this).append(e);
                $("#" + controlId + "_Control").kendoMobileSwitch({
                    onLabel: setting.onLabel,
                    offLabel: setting.offLabel,
                    change: setting.onChange,
                    checked: setting.value
                });
            } else {
                var e = document.createElement("input");
                e.id = controlId + "_Control";
                e.type = "checkbox";
                e.style.cssText = setting.style;
                $(this).append(e);
                $("#" + controlId + "_Control").kendoMobileSwitch({
                    onLabel: setting.onLabel,
                    offLabel: setting.offLabel,
                    change: setting.onChange,
                    checked: setting.value
                });
                $("#" + controlId + "_Control").data("kendoMobileSwitch").enable(false);
            }
        }
    };
    $.fn.FrameSwitch.defaults = $.extend({}, {
        type: "FrameSwitch",
        className: "",
        onLabel: "是",
        offLabel: "否",
        value: false,
        readonly: false,
        onChange: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameSwitch.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoMobileSwitch").check(value);
            } else {
                $("#" + controlId + "_Control").data("kendoMobileSwitch").check(value);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Control").data("kendoMobileSwitch").check();
            } else {
                return $(my).data("value");
            }
        },
        getText: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Control").data("kendoMobileSwitch").check() ? $(my).data("onLabel") : $(my).data("offLabel");
            }
        },
        getControl: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Control").data("kendoMobileSwitch");
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoMobileSwitch").enable(false);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoMobileSwitch").enable(true);
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameTextArea = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameTextArea.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameTextArea.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameTextArea.defaults.value;
            }
            $(this).data(setting);
            $(this).empty();
            if (!setting.readonly) {
                var html = "";
                html += '<textarea id="' + controlId + '_Control" class="k-textbox ' + setting.className + '" style="' + setting.style + '" rows="' + setting.rows + '"></textarea>';
                $(this).append(html);
                if (setting.resize == false) {
                    $("#" + controlId + "_Control").css("resize", "none");
                }
                $("#" + controlId + "_Control").height(setting.height);
                $("#" + controlId + "_Control").val(setting.value);
                if (typeof setting.onChange != "undefined") {
                    $("#" + controlId + "_Control").unbind("change");
                    $("#" + controlId + "_Control").on("change", setting.onChange);
                }
            } else {
                var e = $.fn.FrameSpan(controlId + "_Control");
                $(this).append(e);
                $("#" + controlId + "_Control").html(setting.value);
            }
        }
    };
    $.fn.FrameTextArea.defaults = $.extend({}, {
        type: "FrameTextArea",
        style: "width: 100%; ",
        className: "",
        value: "",
        resize: false,
        rows: 2,
        height: "auto",
        readonly: false,
        onChange: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameTextArea.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").val(value);
            } else {
                $("#" + controlId + "_Control").html(value);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $.trim($("#" + controlId + "_Control").val());
            } else {
                return $(my).data("value");
            }
        },
        setRows: function(my, value) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").attr("rows", value);
            }
        },
        setHeight: function(my, value) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").height(value);
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").attr("disabled", true);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").removeAttr("disabled");
            }
        },
        focus: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                var v = $("#" + controlId + "_Control").val();
                $("#" + controlId + "_Control").focus().val(v);
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameTextBox = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameTextBox.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameTextBox.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameTextBox.defaults.value;
            }
            if (!setting.dataSource) {
                setting.dataSource = $.fn.FrameRadio.defaults.dataSource;
            }
            $(this).data(setting);
            $(this).empty();
            if (!setting.readonly) {
                var html = "";
                html += '<input id="' + controlId + '_Control" class="k-textbox ' + setting.className + '" style="' + setting.style + '" placeholder="' + setting.placeholder + '" />';
                $(this).append(html);
                if (setting.password) {
                    $("#" + controlId + "_Control").attr("type", "password");
                } else {
                    $("#" + controlId + "_Control").attr("type", "text");
                }
                $("#" + controlId + "_Control").val(setting.value);
                if (typeof setting.onChange != "undefined") {
                    $("#" + controlId + "_Control").unbind("change");
                    $("#" + controlId + "_Control").on("change", setting.onChange);
                }
                if (typeof setting.onKeyup != "undefined") {
                    $("#" + controlId + "_Control").unbind("keyup");
                    $("#" + controlId + "_Control").on("keyup", setting.onKeyup);
                }
            } else {
                var e = $.fn.FrameSpan(controlId + "_Control");
                $(this).append(e);
                $("#" + controlId + "_Control").html(setting.value);
            }
        }
    };
    $.fn.FrameTextBox.defaults = $.extend({}, {
        type: "FrameTextBox",
        style: "width: 100%; ",
        password: false,
        className: "",
        placeholder: "",
        value: "",
        readonly: false,
        onChange: function() {},
        onKeyup: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameTextBox.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").val(value);
            } else {
                $("#" + controlId + "_Control").html(value);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $.trim($("#" + controlId + "_Control").val());
            } else {
                return $(my).data("value");
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").attr("disabled", true);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").removeAttr("disabled");
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameYearMonth = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameYearMonth.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameYearMonth.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameYearMonth.defaults.value;
            }
            $(this).data(setting);
            $(this).empty();
            if (!setting.readonly) {
                var html = "";
                html += '<div class="col-xs-12">';
                html += '   <div class="row">';
                html += '       <div class="col-xs-1" style="width: 54% !important">';
                html += '           <div class="row">';
                html += '               <select id="' + controlId + '_Year_Control" class="' + setting.className + '" style="' + setting.style + '"></select>';
                html += "           </div>";
                html += "       </div>";
                html += '       <div class="col-xs-1 center" style="width: 6% !important; padding: 0;">';
                html += '           <div class="row" style="margin: 0px;">&nbsp;</div>';
                html += "       </div>";
                html += '       <div class="col-xs-1" style="width: 40% !important">';
                html += '           <div class="row">';
                html += '               <select id="' + controlId + '_Month_Control" class="' + setting.className + '" style="' + setting.style + '"></select>';
                html += "           </div>";
                html += "       </div>";
                html += "   </div>";
                html += "</div>";
                $(this).append(html);
                var monthDataSource = [ {
                    Key: "01",
                    Value: "01"
                }, {
                    Key: "02",
                    Value: "02"
                }, {
                    Key: "03",
                    Value: "03"
                }, {
                    Key: "04",
                    Value: "04"
                }, {
                    Key: "05",
                    Value: "05"
                }, {
                    Key: "06",
                    Value: "06"
                }, {
                    Key: "07",
                    Value: "07"
                }, {
                    Key: "08",
                    Value: "08"
                }, {
                    Key: "09",
                    Value: "09"
                }, {
                    Key: "10",
                    Value: "10"
                }, {
                    Key: "11",
                    Value: "11"
                }, {
                    Key: "12",
                    Value: "12"
                } ];
                var currentDate = new Date();
                var yearDataSource = [];
                var startYear;
                var endYear;
                if (setting.startYear == "shift") {
                    startYear = currentDate.getFullYear() - setting.startShift;
                } else if (setting.startYear == "auto") {
                    startYear = 2e3;
                } else {
                    startYear = parseInt(setting.startYear);
                }
                if (setting.endYear == "shift") {
                    endYear = currentDate.getFullYear() + setting.endShift;
                } else if (setting.endYear == "auto") {
                    endYear = currentDate.getFullYear();
                } else {
                    endYear = parseInt(setting.endYear);
                }
                for (var i = startYear; i <= endYear; i++) {
                    yearDataSource.push({
                        Key: i.toString(),
                        Value: i.toString()
                    });
                }
                var year = $("#" + controlId + "_Year_Control").kendoDropDownList({
                    height: setting.heightYear,
                    dataTextField: "Value",
                    dataValueField: "Key",
                    dataSource: yearDataSource,
                    noDataTemplate: ""
                }).data("kendoDropDownList");
                var month = $("#" + controlId + "_Month_Control").kendoDropDownList({
                    height: setting.heightMonth,
                    dataTextField: "Value",
                    dataValueField: "Key",
                    dataSource: monthDataSource,
                    noDataTemplate: ""
                }).data("kendoDropDownList");
                if ($.trim(setting.value.Year) != "") {
                    year.value(setting.value.Year);
                }
                if ($.trim(setting.value.Month) != "") {
                    month.value(setting.value.Month);
                }
                $("#" + controlId + "_Year_Control").unbind("change");
                $("#" + controlId + "_Year_Control").on("change", function() {
                    setting.onChangeYear.call(this);
                });
                $("#" + controlId + "_Month_Control").unbind("change");
                $("#" + controlId + "_Month_Control").on("change", function() {
                    setting.onChangeMonth.call(this);
                });
            } else {
                var e = $.fn.FrameSpan(controlId + "_Control");
                $(this).append(e);
                $("#" + controlId + "_Control").html(setting.value.Year + " - " + setting.value.Month);
            }
        }
    };
    $.fn.FrameYearMonth.defaults = $.extend({}, {
        type: "FrameYearMonth",
        style: "width: 100%; ",
        className: "",
        heightYear: 200,
        heightMonth: 200,
        startYear: "auto",
        startShift: 0,
        endYear: "auto",
        endShift: 0,
        value: {
            Year: "",
            Month: ""
        },
        readonly: false,
        onChangeYear: function() {},
        onChangeMonth: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameYearMonth.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Year_Control").data("kendoDropDownList").value(value.Year);
                $("#" + controlId + "_Month_Control").data("kendoDropDownList").value(value.Month);
            } else {
                $("#" + controlId + "_Control").html(value.Year + " - " + value.Month);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            var value = {};
            if (!$(my).data("readonly")) {
                value.Year = $("#" + controlId + "_Year_Control").data("kendoDropDownList").value();
                value.Month = $("#" + controlId + "_Month_Control").data("kendoDropDownList").value();
            } else {
                return $(my).data("value");
            }
            return value;
        },
        getControlYear: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Year_Control").data("kendoDropDownList");
            }
        },
        getControlMonth: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Month_Control").data("kendoDropDownList");
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Year_Control").data("kendoDropDownList").enable(false);
                $("#" + controlId + "_Month_Control").data("kendoDropDownList").enable(false);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Year_Control").data("kendoDropDownList").enable(true);
                $("#" + controlId + "_Month_Control").data("kendoDropDownList").enable(true);
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameYear = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameYear.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameYear.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameYear.defaults.value;
            }
            $(this).data(setting);
            $(this).empty();
            if (!setting.readonly) {
                var html = "";
                html += '<select id="' + controlId + '_Control" class="' + setting.className + '" style="' + setting.style + '"></select>';
                $(this).append(html);
                var optionLabel = "";
                if (setting.selectType == "all") {
                    optionLabel = "全部";
                } else if (setting.selectType == "select") {
                    optionLabel = "请选择";
                }
                var currentDate = new Date();
                var yearDataSource = [];
                var startYear;
                var endYear;
                if (setting.startYear == "shift") {
                    startYear = currentDate.getFullYear() - setting.startShift;
                } else if (setting.startYear == "auto") {
                    startYear = 2e3;
                } else {
                    startYear = parseInt(setting.startYear);
                }
                if (setting.endYear == "shift") {
                    endYear = currentDate.getFullYear() + setting.endShift;
                } else if (setting.endYear == "auto") {
                    endYear = currentDate.getFullYear();
                } else {
                    endYear = parseInt(setting.endYear);
                }
                for (var i = startYear; i <= endYear; i++) {
                    yearDataSource.push({
                        Key: i.toString(),
                        Value: i.toString()
                    });
                }
                $("#" + controlId + "_Control").kendoDropDownList({
                    height: setting.height,
                    dataTextField: "Value",
                    dataValueField: "Key",
                    dataSource: yearDataSource,
                    noDataTemplate: "",
                    optionLabel: optionLabel,
                    value: setting.value,
                    change: setting.onChange
                });
            } else {
                var e = $.fn.FrameSpan(controlId + "_Control");
                $(this).append(e);
                $("#" + controlId + "_Control").html(setting.value);
            }
        }
    };
    $.fn.FrameYear.defaults = $.extend({}, {
        type: "FrameYear",
        style: "width: 100%; ",
        className: "",
        height: 200,
        startYear: "auto",
        startShift: 0,
        endYear: "auto",
        endShift: 0,
        selectType: "",
        value: "",
        readonly: false,
        onChange: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameYear.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoDropDownList").value(value);
            } else {
                $("#" + controlId + "_Control").html(value.Year);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Control").data("kendoDropDownList").value();
            } else {
                return $(my).data("value");
            }
        },
        getControl: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Control").data("kendoDropDownList");
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoDropDownList").enable(false);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Control").data("kendoDropDownList").enable(true);
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameCalendarRange = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameCalendarRange.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var setting = $.extend({}, $.fn.FrameCalendarRange.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameCalendarRange.defaults.value;
            }
            $(this).data(setting);
            $(this).empty();
            if (!setting.readonly) {
                var html = "";
                html += '<div class="col-xs-12">';
                html += '   <div class="row">';
                html += '       <div class="col-xs-1" style="width: 38% !important">';
                html += '           <div class="row">';
                html += '               <select id="' + controlId + '_Year_Control" class="calendar-range-year ' + setting.className + '" style="' + setting.style + '"></select>';
                html += "           </div>";
                html += "       </div>";
                html += '       <div class="col-xs-1 center" style="width: 6% !important; padding: 0;">';
                html += '           <div class="row" style="margin: 0px;">&nbsp;</div>';
                html += "       </div>";
                html += '       <div class="col-xs-1" style="width: 25% !important">';
                html += '           <div class="row">';
                html += '               <select id="' + controlId + '_StartMonth_Control" class="calendar-range-start-month ' + setting.className + '" style="' + setting.style + '"></select>';
                html += "           </div>";
                html += "       </div>";
                html += '       <div class="col-xs-1 center" style="width: 6% !important; padding: 0;">';
                html += '           <div class="row" style="margin: 0px;">-</div>';
                html += "       </div>";
                html += '       <div class="col-xs-1" style="width: 25% !important">';
                html += '           <div class="row">';
                html += '               <select id="' + controlId + '_EndMonth_Control" class="calendar-range-end-month ' + setting.className + '" style="' + setting.style + '"></select>';
                html += "           </div>";
                html += "       </div>";
                html += "   </div>";
                html += "</div>";
                $(this).append(html);
                if (setting.yearDataSource.length == 0) {
                    var currentDate = new Date();
                    var startYear;
                    var endYear;
                    if (setting.startYear == "shift") {
                        startYear = currentDate.getFullYear() - setting.startShift;
                    } else if (setting.startYear == "auto") {
                        startYear = 2e3;
                    } else {
                        startYear = parseInt(setting.startYear);
                    }
                    if (setting.endYear == "shift") {
                        endYear = currentDate.getFullYear() + setting.endShift;
                    } else if (setting.endYear == "auto") {
                        endYear = currentDate.getFullYear();
                    } else {
                        endYear = parseInt(setting.endYear);
                    }
                    for (var i = startYear; i <= endYear; i++) {
                        setting.yearDataSource.push({
                            Key: i.toString(),
                            Value: i.toString()
                        });
                    }
                }
                var year = $("#" + controlId + "_Year_Control").kendoDropDownList({
                    height: setting.heightYear,
                    dataTextField: "Value",
                    dataValueField: "Key",
                    dataSource: setting.yearDataSource,
                    noDataTemplate: ""
                }).data("kendoDropDownList");
                var startMonth = $("#" + controlId + "_StartMonth_Control").kendoDropDownList({
                    height: setting.heightMonth,
                    dataTextField: "Value",
                    dataValueField: "Key",
                    dataSource: setting.monthDataSource,
                    noDataTemplate: ""
                }).data("kendoDropDownList");
                var endMonth = $("#" + controlId + "_EndMonth_Control").kendoDropDownList({
                    height: setting.heightMonth,
                    dataTextField: "Value",
                    dataValueField: "Key",
                    dataSource: setting.monthDataSource,
                    noDataTemplate: ""
                }).data("kendoDropDownList");
                if ($.trim(setting.value.Year) != "") {
                    year.value(setting.value.Year);
                }
                if ($.trim(setting.value.StartMonth) != "") {
                    startMonth.value(setting.value.StartMonth);
                }
                if ($.trim(setting.value.EndMonth) != "") {
                    endMonth.value(setting.value.EndMonth);
                }
                $("#" + controlId + "_Year_Control").unbind("change");
                $("#" + controlId + "_Year_Control").on("change", function() {
                    setting.onChangeYear.call(this);
                });
                $("#" + controlId + "_StartMonth_Control").unbind("change");
                $("#" + controlId + "_StartMonth_Control").on("change", function() {});
                $("#" + controlId + "_EndMonth_Control").unbind("change");
                $("#" + controlId + "_EndMonth_Control").on("change", function() {});
            } else {
                var e = $.fn.FrameSpan(controlId + "_Control");
                $(this).append(e);
                $("#" + controlId + "_Control").html(setting.value.Year + "&nbsp;&nbsp;" + setting.value.StartMonth + "&nbsp;-&nbsp;" + setting.value.EndMonth);
            }
        }
    };
    $.fn.FrameCalendarRange.defaults = $.extend({}, {
        type: "FrameCalendarRange",
        style: "width: 100%; ",
        className: "",
        heightYear: 200,
        heightMonth: 200,
        value: {
            Year: "",
            StartMonth: "",
            EndMonth: ""
        },
        yearDataSource: [],
        startYear: "auto",
        startShift: 0,
        endYear: "auto",
        endShift: 0,
        monthDataSource: [ {
            Key: "1",
            Value: "1"
        }, {
            Key: "2",
            Value: "2"
        }, {
            Key: "3",
            Value: "3"
        }, {
            Key: "4",
            Value: "4"
        }, {
            Key: "5",
            Value: "5"
        }, {
            Key: "6",
            Value: "6"
        }, {
            Key: "7",
            Value: "7"
        }, {
            Key: "8",
            Value: "8"
        }, {
            Key: "9",
            Value: "9"
        }, {
            Key: "10",
            Value: "10"
        }, {
            Key: "11",
            Value: "11"
        }, {
            Key: "12",
            Value: "12"
        } ],
        onChangeYear: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameCalendarRange.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Year_Control").data("kendoDropDownList").value(value.Year);
                $("#" + controlId + "_StartMonth_Control").data("kendoDropDownList").value(value.StartMonth);
                $("#" + controlId + "_EndMonth_Control").data("kendoDropDownList").value(value.EndMonth);
            } else {
                $("#" + controlId + "_Control").html(value.Year + "&nbsp;&nbsp;" + value.StartMonth + "&nbsp;-&nbsp;" + value.EndMonth);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            var value = {};
            if (!$(my).data("readonly")) {
                value.Year = $("#" + controlId + "_Year_Control").data("kendoDropDownList").value();
                value.StartMonth = $("#" + controlId + "_StartMonth_Control").data("kendoDropDownList").value();
                value.EndMonth = $("#" + controlId + "_EndMonth_Control").data("kendoDropDownList").value();
            } else {
                return $(my).data("value");
            }
            return value;
        },
        getControlYear: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_Year_Control").data("kendoDropDownList");
            }
        },
        getControlStartMonth: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_StartMonth_Control").data("kendoDropDownList");
            }
        },
        getControlEndMonth: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $("#" + controlId + "_EndMonth_Control").data("kendoDropDownList");
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Year_Control").data("kendoDropDownList").enable(false);
                $("#" + controlId + "_StartMonth_Control").data("kendoDropDownList").enable(false);
                $("#" + controlId + "_EndMonth_Control").data("kendoDropDownList").enable(false);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $("#" + controlId + "_Year_Control").data("kendoDropDownList").enable(true);
                $("#" + controlId + "_StartMonth_Control").data("kendoDropDownList").enable(true);
                $("#" + controlId + "_EndMonth_Control").data("kendoDropDownList").enable(true);
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

(function($) {
    $.fn.FrameEditableContent = function(param1, param2) {
        if (typeof $(this) == "undefined" || $(this).length == 0) {
            return;
        }
        var controlId = $(this).attr("id");
        if (typeof param1 == "string") {
            var func = $.fn.FrameEditableContent.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log("error: none method");
                return "";
            }
        } else {
            var my = $(this);
            var setting = $.extend({}, $.fn.FrameEditableContent.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.FrameEditableContent.defaults.value;
            }
            $(this).data(setting);
            $(this).empty();
            if (!setting.readonly) {
                var dom = $('<div contenteditable="' + setting.editType + '" class="editable-content k-textbox ' + setting.className + '" style="' + setting.style + '"></div>');
                dom.css({
                    "overflow-y": "auto",
                    "min-height": setting.minHeight,
                    "max-height": setting.maxHeight
                });
                $(this).append(dom);
                my.find(".editable-content").html(setting.value);
            } else {
                var dom = $('<span class="frame-label" style="width: 100%;" />');
                $(this).append(dom);
                my.find(".frame-label").html(setting.value);
            }
        }
    };
    $.fn.FrameEditableContent.defaults = $.extend({}, {
        type: "FrameEditableContent",
        editType: "true",
        style: "width: 100%;",
        className: "",
        minHeight: "30px",
        maxHeight: "300px",
        value: "",
        readonly: false,
        onChange: function() {},
        onBlur: function() {},
        onFocus: function() {}
    });
    $.fn.FrameEditableContent.methods = {
        setValue: function(my, value) {
            var controlId = $(my).attr("id");
            $(my).data("value", value);
            if (!$(my).data("readonly")) {
                $(my).find(".editable-content").html(value);
            } else {
                $(my).find(".frame-label").html(value);
            }
        },
        getValue: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                return $.trim($(my).find(".editable-content").html());
            } else {
                return $(my).data("value");
            }
        },
        disable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $(my).find(".editable-content").attr("contenteditable", "false");
                $(my).find(".editable-content").attr("disabled", true);
            }
        },
        enable: function(my) {
            var controlId = $(my).attr("id");
            if (!$(my).data("readonly")) {
                $(my).find(".editable-content").attr("contenteditable", $(my).data("editType"));
                $(my).find(".editable-content").removeAttr("disabled");
            }
        },
        error: function(my) {},
        removeError: function(my) {}
    };
})(jQuery);

var FrameWindow = {};

FrameWindow = function() {
    var that = {};
    that.ShowLoading = function() {
        $("#loadingToast").show();
    };
    that.HideLoading = function() {
        $("#loadingToast").hide();
    };
    that.ShowMessage = function(option) {
        var setting = $.extend({}, {
            target: "this",
            title: "",
            message: ""
        }, option);
        var b;
        if (setting.target == "top") {
            b = top.bootbox;
        } else if (setting.target == "parent") {
            b = parent.bootbox;
        } else {
            b = bootbox;
        }
        return b.dialog({
            title: setting.title,
            message: setting.message,
            closeButton: false
        });
    };
    that.ShowAlert = function(option) {
        var setting = $.extend({}, {
            target: "this",
            alertType: "info",
            title: "",
            message: "",
            okLabel: "确定",
            callback: function() {}
        }, option);
        var msg = "";
        if (Object.prototype.toString.call(setting.message) === "[object Array]") {
            for (i = 0; i < setting.message.length; i++) {
                msg += setting.message[i] + "<br />";
            }
        } else {
            msg = setting.message;
        }
        if (typeof msg == "undefined" || msg == "") {
            msg = "出错了，请联系管理员";
        }
        var b;
        if (setting.target == "top") {
            b = top.bootbox;
        } else if (setting.target == "parent") {
            b = parent.bootbox;
        } else {
            b = bootbox;
        }
        if (setting.title == "") {
            if (setting.alertType == "error") {
                setting.title = '<span style="color: #d15b47;"><i class="fa fa-times-circle" />&nbsp;出错啦</span>';
            } else if (setting.alertType == "warning") {
                setting.title = '<span style="color: #ffb752;"><i class="fa fa-warning" />&nbsp;警告</span>';
            } else {
                setting.title = '<span style="color: #428bca;"><i class="fa fa-info-circle" />&nbsp;提示信息</span>';
            }
        }
        b.alert({
            title: setting.title,
            message: msg,
            callback: setting.callback,
            buttons: {
                ok: {
                    label: setting.okLabel
                }
            }
        });
    };
    that.ShowConfirm = function(option) {
        var setting = $.extend({}, {
            target: "this",
            message: "",
            confirmLabel: "确定",
            cancelLabel: "取消",
            confirmCallback: function() {},
            cancelCallback: function() {}
        }, option);
        var msg = "";
        if (Object.prototype.toString.call(setting.message) === "[object Array]") {
            for (i = 0; i < setting.message.length; i++) {
                msg += setting.message[i] + "<br />";
            }
        } else {
            msg = setting.message;
        }
        var b;
        if (setting.target == "top") {
            b = top.bootbox;
        } else if (setting.target == "parent") {
            b = parent.bootbox;
        } else {
            b = bootbox;
        }
        var title = '<span style="color: #d15b47;"><i class="fa fa-question-circle" />&nbsp;确认</span>';
        b.confirm({
            title: title,
            message: msg,
            callback: function(result) {
                if (result == true) {
                    setting.confirmCallback.call(this);
                } else {
                    setting.cancelCallback.call(this);
                }
            },
            buttons: {
                confirm: {
                    label: setting.confirmLabel
                },
                cancel: {
                    label: setting.cancelLabel
                }
            }
        });
    };
    that.ShowPrompt = function(option) {
        var setting = $.extend({}, {
            target: "this",
            title: "",
            message: "",
            confirmLabel: "确定",
            cancelLabel: "取消",
            confirmCallback: function() {
                return true;
            },
            cancelCallback: function() {}
        }, option);
        var b;
        if (setting.target == "top") {
            b = top.bootbox;
        } else if (setting.target == "parent") {
            b = parent.bootbox;
        } else {
            b = bootbox;
        }
        var dialog = b.prompt({
            title: setting.title,
            inputType: "textarea",
            callback: function(result) {
                if (result == null) {
                    setting.cancelCallback.call(this);
                } else {
                    return setting.confirmCallback.call(this, $.trim(result));
                }
            },
            buttons: {
                confirm: {
                    label: setting.confirmLabel
                },
                cancel: {
                    label: setting.cancelLabel
                }
            }
        });
        dialog.find("textarea").css("resize", "none");
        if (setting.message != "") {
            $("<span>" + setting.message + "</span>").insertBefore(dialog.find(".bootbox-body"));
        }
    };
    that.OpenWindow = function(option) {
        var setting = $.extend({}, {
            target: "this",
            title: "",
            url: "",
            width: 800,
            height: 600,
            maxed: false,
            actions: [ "Maximize", "Close" ],
            callback: function() {}
        }, option);
        var timestamp = Common.GetTimestamp();
        var myWindow;
        var maxHeight;
        if (setting.target == "top") {
            $(top.document.body).append('<div id="ModelWinow_' + timestamp + '"></div>');
            myWindow = top.$("#ModelWinow_" + timestamp);
            maxHeight = $(top.window).height() - 30;
        } else if (setting.target == "parent") {
            $(parent.document.body).append('<div id="ModelWinow_' + timestamp + '"></div>');
            myWindow = parent.$("#ModelWinow_" + timestamp);
            maxHeight = $(parent.window).height() - 30;
        } else {
            $(document.body).append('<div id="ModelWinow_' + timestamp + '"></div>');
            myWindow = $("#ModelWinow_" + timestamp);
            maxHeight = $(window).height() - 30;
        }
        var onClose = function() {
            var returnValue = myWindow.data("returnValue");
            if (returnValue) {
                setting.callback.call(this, returnValue);
            } else {
                setting.callback.call(this);
            }
            myWindow.data("kendoWindow").destroy();
        };
        setting.url = Common.UpdateUrlParams(setting.url, "timestamp", timestamp);
        myWindow.kendoWindow({
            width: setting.width,
            height: setting.height,
            maxHeight: maxHeight,
            modal: true,
            resizable: false,
            title: setting.title,
            content: setting.url,
            iframe: true,
            actions: setting.actions,
            close: onClose
        });
        if (setting.maxed) {
            myWindow.data("kendoWindow").center().open().maximize();
        } else {
            myWindow.data("kendoWindow").center().open();
        }
    };
    that.CloseWindow = function(option) {
        var setting = $.extend({}, {
            target: "this"
        }, option);
        var myWindow;
        var timestamp = Common.GetUrlParam("timestamp");
        if (setting.target == "top") {
            myWindow = top.$("#ModelWinow_" + timestamp);
        } else if (setting.target == "parent") {
            myWindow = parent.$("#ModelWinow_" + timestamp);
        } else {
            myWindow = $("#ModelWinow_" + timestamp);
        }
        myWindow.data("kendoWindow").close();
    };
    that.SetWindowReturnValue = function(option) {
        var setting = $.extend({}, {
            target: "this",
            value: {}
        }, option);
        var myWindow;
        var timestamp = Common.GetUrlParam("timestamp");
        if (setting.target == "top") {
            myWindow = top.$("#ModelWinow_" + timestamp);
        } else if (setting.target == "parent") {
            myWindow = parent.$("#ModelWinow_" + timestamp);
        } else {
            myWindow = $("#ModelWinow_" + timestamp);
        }
        myWindow.data("returnValue", setting.value);
    };
    that.ReloadWindow = function(option) {
        var setting = $.extend({}, {
            target: "this",
            title: "",
            url: ""
        }, option);
        var myWindow;
        var timestamp = Common.GetUrlParam("timestamp");
        if (setting.target == "top") {
            myWindow = top.$("#ModelWinow_" + timestamp);
        } else if (setting.target == "parent") {
            myWindow = parent.$("#ModelWinow_" + timestamp);
        } else {
            myWindow = $("#ModelWinow_" + timestamp);
        }
        if (setting.title != "") {
            myWindow.data("kendoWindow").title(setting.title);
        }
        if (setting.url != "") {
            var url = Common.UpdateUrlParams(setting.url, "timestamp", Common.GetUrlParam("timestamp"));
            myWindow.find(".k-content-frame").attr("src", url);
        }
    };
    return that;
}();

var FrameUtil = {};

FrameUtil = function() {
    var that = {};
    that.AjaxTimeout = 6e4;
    that.GetModel = function(panel) {
        var model = {};
        if (typeof panel == "undefined") {
            $(".FrameControl").each(function() {
                var controlId = $(this).attr("id");
                if ($(this).attr("type") == "hidden") {
                    eval("model." + controlId + " = '" + $(this).val() + "'");
                } else {
                    var type = $(this).data("type");
                    if (typeof type == "undefined") {
                        eval("model." + controlId + " = null");
                    } else {
                        eval("model." + controlId + " = $(this)." + type + "('getValue')");
                    }
                }
            });
        } else {
            $("#" + panel).find(".FrameControl").each(function() {
                var controlId = $(this).attr("id");
                if ($(this).attr("type") == "hidden") {
                    eval("model." + controlId + " = '" + $(this).val() + "'");
                } else {
                    var type = $(this).data("type");
                    if (typeof type == "undefined") {
                        eval("model." + controlId + " = null");
                    } else {
                        eval("model." + controlId + " = $(this)." + type + "('getValue')");
                    }
                }
            });
        }
        return model;
    };
    that.SubmitAjax = function(option) {
        var setting = $.extend({}, {
            business: "",
            method: "",
            url: "",
            async: true,
            data: {},
            callback: function() {},
            failCallback: function() {}
        }, option);
        setting.url = Common.UpdateUrlParams(setting.url, "Business", setting.business);
        setting.url = Common.UpdateUrlParams(setting.url, "Method", setting.method);
        $.ajax({
            type: "Post",
            url: setting.url,
            timeout: that.AjaxTimeout,
            data: JSON.stringify(setting.data),
            contentType: "application/json; charset=utf-8",
            async: setting.async,
            dataType: "json",
            success: function(model) {
                try {
                    if (model.IsSuccess == true) {
                        setting.callback.call(this, model);
                    } else {
                        FrameWindow.ShowAlert({
                            target: "top",
                            alertType: "error",
                            message: model.ExecuteMessage,
                            callback: function() {
                                setting.failCallback.call(this, model);
                            }
                        });
                        FrameWindow.HideLoading();
                    }
                } catch (e) {
                    console.log(e.stack);
                    FrameWindow.ShowAlert({
                        target: "top",
                        alertType: "error",
                        message: e.name + "：" + e.message
                    });
                    FrameWindow.HideLoading();
                }
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                console.log(XMLHttpRequest);
                if (textStatus == "timeout") {
                    FrameWindow.ShowAlert({
                        target: "top",
                        alertType: "error",
                        message: "系统超时，请稍后再试"
                    });
                    FrameWindow.HideLoading();
                } else if (textStatus == "parsererror" && XMLHttpRequest.responseText.indexOf("Login.aspx") != -1) {
                    FrameWindow.ShowAlert({
                        target: "top",
                        alertType: "error",
                        message: "登陆超时，请重新登陆！",
                        callback: function() {
                            window.location.reload();
                        }
                    });
                    FrameWindow.HideLoading();
                } else {
                    FrameWindow.ShowAlert({
                        target: "top",
                        alertType: "error",
                        message: errorThrown
                    });
                    FrameWindow.HideLoading();
                }
            }
        });
    };
    that.LoadAjaxHtml = function(option) {
        var setting = $.extend({}, {
            url: "",
            callback: function() {}
        }, option);
        $.ajax({
            url: setting.url,
            type: "get",
            async: false,
            success: function(res) {
                setting.callback.call(this, res);
            }
        });
    };
    that.StartDownload = function(option) {
        var setting = $.extend({}, {
            url: "",
            cookie: "",
            business: "",
            method: "GET",
            data: null
        }, option);
        setting.cookie += "_" + Common.GetTimestamp();
        setting.url = Common.UpdateUrlParams(setting.url, "DownloadCookie", setting.cookie);
        setting.url = Common.UpdateUrlParams(setting.url, "Business", setting.business);
        setting.url = Common.UpdateUrlParams(setting.url, "Method", setting.method);
        var timestamp = Common.GetTimestamp();
        setting.url = Common.UpdateUrlParams(setting.url, "timestamp", timestamp);
        $.fileDownload(setting.url, {
            preparingMessageTitle: '<span style="color: #428bca;"><i class="fa fa-info-circle" />&nbsp;提示信息</span>',
            preparingMessageHtml: '<p><i class="fa fa-spin fa-spinner"></i>&nbsp;下载中，请等待...</p>',
            failMessageHtml: "下载出错",
            cookieName: "fileDownload_" + setting.cookie,
            httpMethod: setting.method,
            data: setting.data
        });
    };
    return that;
}();

(function($) {
    $.extend({
        fileDownload: function(fileUrl, options) {
            var defaultFailCallback = function(responseHtml, url) {
                alert("A file download error has occurred, please try again.");
            };
            var settings = $.extend({
                preparingMessageTitle: "提示信息",
                preparingMessageHtml: "下载中，请等待...",
                failMessageHtml: "下载出错",
                androidPostUnsupportedMessageHtml: "Unfortunately your Android browser doesn't support this type of file download. Please try again with a different browser.",
                successCallback: function(url) {},
                failCallback: defaultFailCallback,
                httpMethod: "GET",
                data: null,
                checkInterval: 100,
                cookieName: "fileDownload",
                cookieValue: "true",
                cookiePath: "/",
                popupWindowTitle: "Initiating file download...",
                encodeHTMLEntities: true
            }, options);
            var userAgent = (navigator.userAgent || navigator.vendor || window.opera).toLowerCase();
            var isIos = false;
            var isAndroid = false;
            var isOtherMobileBrowser = false;
            if (/ip(ad|hone|od)/.test(userAgent)) {
                isIos = true;
            } else if (userAgent.indexOf("android") != -1) {
                isAndroid = true;
            } else {
                isOtherMobileBrowser = /avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|playbook|silk|iemobile|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(userAgent) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-/i.test(userAgent.substr(0, 4));
            }
            var httpMethodUpper = settings.httpMethod.toUpperCase();
            if (isAndroid && httpMethodUpper != "GET") {
                alert(settings.androidPostUnsupportedMessageHtml);
                return;
            }
            var $preparingDialog = FrameWindow.ShowMessage({
                target: "this",
                title: settings.preparingMessageTitle,
                message: settings.preparingMessageHtml
            });
            var internalCallbacks = {
                onSuccess: function(url) {
                    $preparingDialog.modal("hide");
                    settings.successCallback(url);
                },
                onFail: function(responseHtml, url) {
                    $preparingDialog.modal("hide");
                    if (settings.failMessageHtml) {
                        FrameWindow.ShowAlert({
                            target: "this",
                            alertType: "error",
                            message: settings.failMessageHtml
                        });
                        if (settings.failCallback != defaultFailCallback) {
                            settings.failCallback(responseHtml, url);
                        }
                    } else {
                        settings.failCallback(responseHtml, url);
                    }
                }
            };
            var $iframe, downloadWindow, formDoc, $form;
            if (httpMethodUpper === "GET") {
                if (settings.data !== null) {
                    if (settings.data !== null && typeof settings.data !== "string") {
                        settings.data = $.param(settings.data);
                    }
                    var qsStart = fileUrl.indexOf("?");
                    if (qsStart != -1) {
                        if (fileUrl.substring(fileUrl.length - 1) !== "&") {
                            fileUrl = fileUrl + "&";
                        }
                    } else {
                        fileUrl = fileUrl + "?";
                    }
                    fileUrl = fileUrl + settings.data;
                }
                if (isIos || isAndroid) {
                    downloadWindow = window.open(fileUrl);
                    downloadWindow.document.title = settings.popupWindowTitle;
                    window.focus();
                } else if (isOtherMobileBrowser) {
                    window.location(fileUrl);
                } else {
                    $iframe = $("<iframe>").hide().attr("src", fileUrl).appendTo("body");
                }
            } else {
                var formInnerHtml = "";
                if (settings.data !== null) {
                    formInnerHtml += '<input type="hidden" id="FormData" name="FormData" />';
                }
                if (isOtherMobileBrowser) {
                    $form = $("<form>").appendTo("body");
                    $form.hide().attr("method", settings.httpMethod).attr("action", fileUrl).html(formInnerHtml);
                    $form.find("#FormData").val(JSON.stringify(settings.data));
                } else {
                    if (isIos) {
                        downloadWindow = window.open("about:blank");
                        downloadWindow.document.title = settings.popupWindowTitle;
                        formDoc = downloadWindow.document;
                        window.focus();
                    } else {
                        $iframe = $("<iframe style='display: none' src='about:blank'></iframe>").appendTo("body");
                        formDoc = getiframeDocument($iframe);
                    }
                    formDoc.write("<html><head></head><body><form method='" + settings.httpMethod + "' action='" + fileUrl + "'>" + formInnerHtml + "</form>" + settings.popupWindowTitle + "</body></html>");
                    $form = $(formDoc).find("form");
                    $form.find("#FormData").val(JSON.stringify(settings.data));
                }
                $form.submit();
            }
            setTimeout(checkFileDownloadComplete, settings.checkInterval);
            function checkFileDownloadComplete() {
                if (document.cookie.indexOf(settings.cookieName + "=" + settings.cookieValue) != -1) {
                    internalCallbacks.onSuccess(fileUrl);
                    var date = new Date(1e3);
                    document.cookie = settings.cookieName + "=; expires=" + date.toUTCString() + "; path=" + settings.cookiePath;
                    cleanUp(false);
                    return;
                }
                if (downloadWindow || $iframe) {
                    try {
                        var formDoc;
                        if (downloadWindow) {
                            formDoc = downloadWindow.document;
                        } else {
                            formDoc = getiframeDocument($iframe);
                        }
                        if (formDoc && formDoc.body != null && formDoc.body.innerHTML.length > 0) {
                            var isFailure = true;
                            if ($form && $form.length > 0) {
                                var $contents = $(formDoc.body).contents().first();
                                if ($contents.length > 0 && $contents[0] === $form[0]) {
                                    isFailure = false;
                                }
                            }
                            if (isFailure) {
                                internalCallbacks.onFail(formDoc.body.innerHTML, fileUrl);
                                cleanUp(true);
                                return;
                            }
                        }
                    } catch (err) {
                        internalCallbacks.onFail("", fileUrl);
                        cleanUp(true);
                        return;
                    }
                }
                setTimeout(checkFileDownloadComplete, settings.checkInterval);
            }
            function getiframeDocument($iframe) {
                var iframeDoc = $iframe[0].contentWindow || $iframe[0].contentDocument;
                if (iframeDoc.document) {
                    iframeDoc = iframeDoc.document;
                }
                return iframeDoc;
            }
            function cleanUp(isFailure) {
                setTimeout(function() {
                    if (downloadWindow) {
                        if (isAndroid) {
                            downloadWindow.close();
                        }
                        if (isIos) {
                            if (isFailure) {
                                downloadWindow.focus();
                                downloadWindow.close();
                            } else {
                                downloadWindow.focus();
                            }
                        }
                    }
                }, 0);
            }
            function htmlSpecialCharsEntityEncode(str) {
                return str.replace(/[<>&\r\n"']/gm, function(match) {
                    return "&" + {
                        "<": "lt;",
                        ">": "gt;",
                        "&": "amp;",
                        "\r": "#13;",
                        "\n": "#10;",
                        '"': "quot;",
                        "'": "apos;"
                    }[match];
                });
            }
        }
    });
})(jQuery);