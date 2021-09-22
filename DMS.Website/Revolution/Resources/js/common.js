/**********************************************
* 公用js方法
************************************************/
//namespace
var dms = {};
if (typeof $ === 'undefined') {
    alert("请在页面上引用jquery.js");
}

//用于kendo DataSource按条件删除数据，可极大提高效率
kendo.data.ObservableArray.prototype.removeIf = function (callback) {
    var i = this.length;
    while (i--) {
        if (callback(this[i], i)) {
            this.splice(i, 1);
        }
    }
}

dms.config = {
    frameJSControlPrefix: "_Control"
};

dms.common = {
    ToLowerCaseFn: function (obj) {
        if (obj != null) {
            return obj.toLowerCase();
        }
        else {
            return obj;
        }
    },
    isNullorEmpty: function(value) {
        return !(value && value != '');
    },
    convertToFrameJsControl: function(controlid) {
        return controlid + dms.config.frameJSControlPrefix;
    },
    showErrorNoice: function (msg, callbackFn) {
        var notice = $("#pnlNotification").data("kendoNotification");
        notice.options.autoHideAfter = 2000;
        notice.hide();
        notice.show(msg, "error");
        if (typeof (callbackFn) == 'function') {
            notice.callbackFn = callbackFn;
        }

    },
    showSuccesssNoice: function (msg, callbackFn) {
        var notice = $("#pnlNotification").data("kendoNotification");
        notice.options.autoHideAfter = 1000;
        notice.hide();
        notice.show(msg, "success");
        if (typeof (callbackFn) == 'function') {
            notice.callbackFn = callbackFn;
        }
    },
    getQueryString: function (name) {
        var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
        var r = window.location.search.substr(1).match(reg);
        if (r != null) {
            return unescape(r[2]);
        }
        return null;
    },
    textboxRequired: function (value, controlId) {
        var obj = $("#" + controlId);
        var result;
        if (value == "") {
            if (!obj.hasClass("has-error")) {
                obj.addClass("has-error");
            }
            result = false;
        } else {
            if (obj.hasClass("has-error")) {
                obj.removeClass("has-error");
            }
            result = true;
        }
        return result;
    },
    kendoControlRequired: function (value, controlId) {
        var obj = $("#" + controlId);
        var result;
        if (value == "") {
            if (!obj.parent().hasClass("has-error")) {
                obj.parent().addClass("has-error");
            }
            result = false;
        } else {
            if (obj.parent().hasClass("has-error")) {
                obj.parent().removeClass("has-error");
            }
            result = true;
        }
        return result;
    },
    //将字符串数组转换为字符串格式，已逗号隔开；
    convertArrToStr: function (value) {
        var data = "";
        value = $.isArray(value) ? value : [value];

        for (var idx = 0; idx < value.length; idx++) {
            data += value[idx];
            if (idx < value.length - 1) {//最后一个不加逗号
                data += ",";
            }
        }
        return data;
    },

    //生成新的guid
    newGuid: function () {
        var guid = "";
        for (var i = 1; i <= 32; i++) {
            var n = Math.floor(Math.random() * 16.0).toString(16);
            guid += n;
            if ((i == 8) || (i == 12) || (i == 16) || (i == 20))
                guid += "-";
        }
        return guid;
    },
    //生成Empty的guid
    emptyGuid: function () {
        return "00000000-0000-0000-0000-000000000000";
    },

    //明细页面保存或提交后跳转到列表页面等待时间（延迟跳转，单位毫秒）
    delayedMillisec: function () {
        return 2000;
    },
    //获取自定义的"data-*"字段属性的内容
    getValidateMsg: function (input, msgfield) {
        return input.data(msgfield);
    },

    //时间段查询条件，当开始时间变化时调用；用于限制开始结束日期的先后；
    startDateChange: function (start, end) {
        var startDate = start.value(),
        endDate = end.value();

        if (startDate) {
            startDate = new Date(startDate);
            startDate.setDate(startDate.getDate());
            end.min(startDate);
        } else if (endDate) {
            start.max(new Date(endDate));
        } else {
            endDate = new Date();
            start.max(endDate);
            end.min(endDate);
        }
    },
    //时间段查询条件，当结束时间变化时调用；用于限制开始结束日期的先后；
    endDateChange: function (start, end) {
        var endDate = end.value(),
        startDate = start.value();

        if (endDate) {
            endDate = new Date(endDate);
            endDate.setDate(endDate.getDate());
            start.max(endDate);
        } else if (startDate) {
            end.min(new Date(startDate));
        } else {
            endDate = new Date();
            start.max(endDate);
            end.min(endDate);
        }
    },
    dateInit: function (dateId) {
        $("#" + dateId).kendoDatePicker({
            culture: "zh-CN",
            format: "yyyy-MM-dd"
        }).data("kendoDatePicker");
    },
    rangSelectionDateinit: function (startId, endId) {
        function startchange() {
            dms.common.startDateChange(start, end);
        }
        function endchange() {
            dms.common.endDateChange(start, end);
        }

        var start = $("#" + startId).kendoDatePicker({
            culture: "zh-CN",
            format: "yyyy-MM-dd",
            change: startchange
        }).data("kendoDatePicker");

        var end = $("#" + endId).kendoDatePicker({
            culture: "zh-CN",
            format: "yyyy-MM-dd",
            change: endchange
        }).data("kendoDatePicker");

        start.max(end.value());
        end.min(start.value());
    },

    //实现整个页面的遮罩
    showMask: function (callback) {
        var bh = document.body.offsetHeight; //$(document).height(); //$("html").height();
        var bw = document.body.offsetWidth;//$(document).width(); //$("html").width();
        var zIndex = 9999;
        if ($(".k-window:visible").length > 0) {
            zIndex = parseInt($(".k-window:visible").css("z-index")) + 1;
        }
        $("#fullmask").css({
            height: bh,
            width: bw,
            display: "block",
            zIndex: zIndex
        });
        kendo.ui.progress($("#fullmask"), true);

        if (typeof callback === "function") {
            setTimeout(callback, 200);
        }
    },
    //关闭整个页面的遮罩
    hideMask: function () {
        $("#fullmask").hide();
        kendo.ui.progress($("#fullmask"), false);
    },

    alertErrorMsg: function (msg) {
        dms.common.alert('数据请求失败，请尝试刷新页面后再操作。错误代码：' + msg.status);
    },
    alertOption: function (option) {
        var setting = $.extend({}, {
            target: 'this',
            alertType: 'info',
            message: '',
            callback: function () { }
        }, option);

        var msg = '';
        if (Object.prototype.toString.call(setting.message) === '[object Array]') {
            for (i = 0; i < setting.message.length; i++) {
                msg += setting.message[i] + '<br />';
            }
        } else {
            msg = setting.message;
        }

        var b;
        if (setting.target == 'top') {
            b = top.bootbox;
        } else if (setting.target == 'parent') {
            b = parent.bootbox;
        } else {
            b = bootbox;
        }

        var title;
        if (setting.alertType == 'error') {
            title = '<span style="color: #d15b47;"><i class="fa fa-exclamation-circle" />&nbsp;出错啦</span>';
        } else if (setting.alertType == 'warning') {
            title = '<span style="color: #ffb752;"><i class="fa fa-exclamation-triangle" />&nbsp;警告</span>';
        } else {
            title = '<span style="color: #428bca;"><i class="fa fa-info-circle" />&nbsp;提示信息</span>';
        }

        b.alert({
            title: title,
            message: msg,
            //animate: false,
            callback: setting.callback,
            buttons: {
                ok: {
                    label: '确定'
                }
            }
        });
    },
    alert: function (msg, callbackFn) {
        var callback = function () { };

        if (typeof (callbackFn) == 'function') {
            callback = callbackFn;
        }

        var option = {
            target: '',
            alertType: 'info',
            message: msg,
            callback: callback
        };

        this.alertOption(option);
    },
    alertError: function (msg, callbackFn) {
        var callback = function () { };

        if (typeof (callbackFn) == 'function') {
            callback = callbackFn;
        }

        var option = {
            target: '',
            alertType: 'error',
            message: msg,
            callback: callback
        };

        this.alertOption(option);
    },
    confirm: function (messsage, func, isShow) {
        if (isShow == undefined) {
            isShow = true;
        }
        if (isShow) {
            bootbox.confirm({
                title: '<span style="color: #428bca;"><i class="fa fa-info-circle" />&nbsp;提醒</span>',
                message: messsage,
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times "></i>&nbsp;取消'
                    },
                    confirm: {
                        label: '<i class="fa fa-check"></i>&nbsp;确定'
                    }
                },
                callback: func
            });
        }
        else {
            func(true);
        }
    },
    isInteger: function (str) {
        var regu = /^[-]{0,1}[0-9]{1,}$/;
        return regu.test(str);
    },
    isDecimal: function (str) {
        if (dms.common.isInteger(str)) return true;
        var re = /^[-]{0,1}(\d+)[\.]+(\d+)$/;
        if (re.test(str)) {
            if (RegExp.$1 == 0 && RegExp.$2 == 0) return false;
            return true;
        } else {
            return false;
        }
    },
    bindNumericTextBox: function (id, dec, min, max, format) {
        if (typeof (dec) == "undefined") {
            dec = 2;
        }
        if (typeof (format) == "undefined") {
            format = "n0";
        }
        var numeric = $("#" + id).kendoNumericTextBox({
            culture: "zh-CN",
            decimals: dec,
            format: format
        }).data("kendoNumericTextBox");

        if (typeof (min) != "undefined") {
            numeric.min(min);
        }
        if (typeof (max) != "undefined") {
            numeric.max(max);
        }
    },
    reloadGrid: function (id) {
        if ($("#" + id) != null) {
            var grid = $("#" + id).data("kendoGrid");
            if (grid) {
                grid.dataSource.page(1);
                return;
            }
        }
    },
    refreshGrid: function (id) {
        var obj = $("#" + id);
        if (obj != null) {
            var grid = obj.data("kendoGrid");
            if (grid) {
                grid.dataSource.read();
                return;
            }
        }
    },
    //GridAutoHeight
    AutoGridHeight: function () {
        return (window.innerHeight - $("#searchPanel").innerHeight() - 50 - 50)
    },

    resizeImg: function (img) {
        var $img = $(img);
        var w = parseFloat($img.css("width").replace("px", ""));
        var mxW = $img.css("max-width").replace("px", "");
        var h = parseFloat($img.css("height").replace("px", ""));
        var mxH = $img.css("max-height").replace("px", "");

        if (mxW.indexOf("%") > -1) {
            mxW = parseFloat($img.parent("div").css("width").replace("px", "")) * parseFloat(mxW.replace("%", "")) / 100;
        }

        if (mxH.indexOf("%") > -1) {
            mxH = parseFloat($img.parent("div").css("height").replace("px", "")) * parseFloat(mxH.replace("%", "")) / 100;
        }

        if (mxW !== "none" && w > parseFloat(mxW)) {
            $img.css("width", parseFloat(mxW));
        }

        if (mxH !== "none" && h > parseFloat(mxH)) {
            $img.css("height", parseFloat(mxH));
        }
    }
}

//kendo DropDownList多级联动
dms.select = {
    //DropDownList重新绑定dataSource
    rebindDropDownList: function (dataList, filterKey, filterValue, targetWidget, defaultValue) {
        var newArray = [];

        if (filterValue === undefined || filterValue == "") {
            newArray = dataList;
        } else {
            $.each(dataList, function (index, value) {
                if (value[filterKey] == filterValue) {
                    newArray.push(value);
                }
            });
        }

        var newDataSource = new kendo.data.DataSource({
            data: newArray
        });

        targetWidget.setDataSource(newDataSource);
        dms.select.selectDropDownList(targetWidget, defaultValue);
    },

    //DropDownList选择某一项
    selectDropDownList: function (targetWidget, defaultValue) {
        if (defaultValue) {
            targetWidget.value(defaultValue);
        } else {
            targetWidget.value("");//默认选择第一个“选择XX...”
        }
    },

    //Array过滤后取某字段值（filterKey2, filterValue2可选，用于多对多需要用到两个key值的情况）
    getValueInArray: function (dataList, filterKey, filterValue, targetKey, filterKey2, filterValue2) {
        var item = new Object();
        $.each(dataList, function (index, value) {
            if (value[filterKey] == filterValue) {
                if (filterKey2) {
                    if (value[filterKey2] == filterValue2) {
                        item = value;
                        return false;
                    }
                } else {
                    item = value;
                    return false;
                }
            }
        });
        return item[targetKey];
    }
}

//数据绑定
dms.DataBind = {
    //获取字典项的kendo.data.DataSource类型数据（不绑定具体的控件）
    getDictDataSource: function (dictType) {
        var ds = new kendo.data.DataSource({
            transport: {
                read: {
                    type: "post",
                    url: "/ServiceHandlers/CommonService.ashx",
                    dataType: "json"
                },
                parameterMap: function (options, operation) {
                    if (operation == "read") {
                        var para = {
                            jsonMessageString: JSON.stringify({
                                ActionName: "Common", Parameters: {
                                    OperateType: "GetDictionaryData",
                                    DictType: dictType
                                }
                            })
                        };
                        return para;
                    }
                }
            },
            schema: {
                model: {
                    id: "Key"
                },
                data: function (res) {
                    return res.Result.data;
                }
            }
        });
        return ds;
    },
    bindProvince: function (controlId) {
        $("#" + controlId).kendoComboBox({
            placeholder: "--  请选择省份  --",
            dataTextField: "Description",
            dataValueField: "TerId",
            clearButton: true,
            filter: "contains",
            autoBind: true,
            height: 260,
            dataSource: {
                transport: {
                    read: {
                        type: "post",
                        url: "/Service/Service.asmx/GetProvinces",
                        dataType: "json",
                        contentType: "application/json"
                    }
                },
                schema: {
                    data: function (res) {
                        var response = $.parseJSON(res.d);
                        return response;
                    }
                }
            }, change: function (e) {
                var result = false;
                var val = this.value();
                $.each(this.dataSource.data(), function (index, obj) {
                    if (obj.TerId == val) {
                        result = true;
                    }
                });
                if (!result) {
                    this.value("");
                }
            }
        });
    },
    bindCity: function (controlId, parentId) {
        $("#" + controlId).kendoComboBox({
            placeholder: "--  请选择城市  --",
            cascadeFrom: parentId,
            dataTextField: "Description",
            dataValueField: "TerId",
            filter: "contains",
            autoBind: false,
            clearButton: true,
            height: 260,
            dataSource: {
                serverFiltering: true,
                transport: {
                    read: {
                        type: "post",
                        url: "/Service/Service.asmx/GetCities",
                        dataType: "json",
                        contentType: "application/json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var para = {
                                ProvinceId: $("#" + parentId).val()
                            };
                            return kendo.stringify(para);
                        }
                    }
                },
                schema: {
                    data: function (res) {
                        var response = $.parseJSON(res.d);
                        return response;
                    }
                }
            }, change: function (e) {
                var result = false;
                var val = this.value();
                $.each(this.dataSource.data(), function (index, obj) {
                    if (obj.TerId == val) {
                        result = true;
                        return;
                    }
                });
                if (!result) {
                    this.value("");
                }
            }
        });
    },
    // 获取登陆用户授权的经销商列表DropDrownList
    // OCD User 根据表Cache_UsersOfDealer，来获取user对应的Dealer
    // Dealer  获取经销商自己和其对应的区域商；
    bindDealerAuth: function (controlId, selVal, fnCallbak) {
        $("#" + controlId).kendoComboBox({
            placeholder: "-- 请输入经销商关键词 --",
            dataTextField: "DMA_ChineseName",
            dataValueField: "DMA_ID",
            clearButton: true,
            filter: "contains",
            autoBind: true,
            minLength: 1,
            height: 260,
            dataSource: {
                serverFiltering: true,
                transport: {
                    read: {
                        type: "post",
                        url: "/ServiceHandlers/CommonService.ashx",
                        dataType: "json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var parameter = {
                                jsonMessageString: kendo.stringify({
                                    ActionName: "Common",
                                    Parameters: {
                                        OperateType: "GetDealerListByAuth",
                                        filter: options.filter ? kendo.stringify(options.filter) : null
                                    }
                                })
                            };
                            return parameter;
                        }
                    }
                },
                schema: {
                    parse: function (res) {
                        return res.Result;
                    },
                    data: function (d) {
                        return d.data;
                    }
                }
            }, change: function (e) {
                if (fnCallbak != undefined) {
                    var obj = e.sender.dataItem();
                    if (typeof (obj) == "undefined" || obj == null) {
                        obj = { DMA_ID: "", DMA_ChineseName: "" };
                    }
                    fnCallbak(obj);
                }
            }, dataBound: function (e) {
                //刷新后赋值
                if (typeof (selVal) != "undefined" && selVal != "" && selVal != null) {
                    $("#" + controlId).data("kendoComboBox").value(selVal);
                    $("#" + controlId).data("kendoComboBox").enable(false);
                } else {
                    $("#" + controlId).data("kendoComboBox").enable(true);
                }
                //针对setDataSource(重新绑定)方法，需要从新初始化默认值
                selVal = "";
            }
        });
    },
    bindDealerAuth2: function (controlId, selVal) {
        $("#" + controlId).kendoComboBox({
            placeholder: "-- 请输入经销商关键词 --",
            dataTextField: "DMA_ChineseName",
            dataValueField: "DMA_ChineseName",
            clearButton: true,
            filter: "contains",
            autoBind: false,
            minLength: 1,
            height: 260,
            dataSource: {
                serverFiltering: true,
                transport: {
                    read: {
                        type: "post",
                        url: "/ServiceHandlers/CommonService.ashx",
                        dataType: "json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var parameter = {
                                jsonMessageString: kendo.stringify({
                                    ActionName: "Common",
                                    Parameters: {
                                        OperateType: "GetDealerListByAuth2",
                                        filter: options.filter ? kendo.stringify(options.filter) : null
                                    }
                                })
                            };
                            return parameter;
                        }
                    }
                },
                schema: {
                    parse: function (res) {
                        return res.Result;
                    },
                    data: function (d) {
                        return d.data;
                    }
                }
            }
        });
    },
    bindDealerHospital: function (controlId, selVal) {
        if (selVal) {
            $("#" + controlId).val(selVal);
        }
        var ctl = $("#" + controlId).kendoComboBox({
            placeholder: "-- 请输入医院关键词 --",
            dataTextField: "HOS_HospitalName",
            dataValueField: "HOS_ID",
            clearButton: true,
            filter: "contains",
            autoBind: true,
            minLength: 1,
            height: 260,
            dataSource: {
                serverFiltering: true,
                transport: {
                    read: {
                        type: "post",
                        url: "/ServiceHandlers/CommonService.ashx",
                        dataType: "json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var parameter = {
                                jsonMessageString: kendo.stringify({
                                    ActionName: "Common",
                                    Parameters: {
                                        OperateType: "GetDealerHospital",
                                        id: $("#" + controlId).val(),
                                        filter: options.filter ? kendo.stringify(options.filter) : null
                                    }
                                })
                            };
                            return parameter;
                        }
                    }
                },
                schema: {
                    parse: function (res) {
                        return res.Result;
                    },
                    data: function (d) {
                        return d.data;
                    }
                }
            }
            , change: function (e) {
                var result = false;
                var val = this.value();
                $.each(this.dataSource.data(), function (index, obj) {
                    if (obj.HOS_ID == val) {
                        result = true;
                        return;
                    }
                });
                if (!result) {
                    this.value("");
                }
            }
            , open: function (e) {
                // handle the event
            }
            , filtering: function (e) {
                //get filter descriptor
                var filter = e.filter;

                // handle the event
            }
            , dataBound: function (e) {
                //刷新后赋值
                if (typeof (selVal) != "undefined" && selVal != "" && selVal != null) {
                    $("#" + controlId).data("kendoComboBox").value(selVal);
                }
                //针对setDataSource(重新绑定)方法，需要从新初始化默认值
                selVal = "";
            }
        }).data('kendoComboBox');
        return ctl;
    },
    // 获取系统中当前所有的经销商，不加任何过滤
    bindAllDealer: function (controlId, selVal, fnCallbak) {
        if (selVal) {
            $("#" + controlId).val(selVal);
        }
        $("#" + controlId).kendoComboBox({
            placeholder: "-- 请输入经销商关键词 --",
            dataTextField: "DMA_ChineseName",
            dataValueField: "DMA_ID",
            clearButton: true,
            filter: "contains",
            autoBind: true,
            minLength: 1,
            height: 260,
            dataSource: {
                serverFiltering: true,
                transport: {
                    read: {
                        type: "post",
                        url: "/ServiceHandlers/CommonService.ashx",
                        dataType: "json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var parameter = {
                                jsonMessageString: kendo.stringify({
                                    ActionName: "Common",
                                    Parameters: {
                                        OperateType: "GetAllDealer",
                                        id: $("#" + controlId).val(),//selVal,
                                        filter: options.filter.filters.length > 0 ? options.filter.filters[0].value : ""
                                    }
                                })
                            };
                            return parameter;
                        }
                    }
                },
                schema: {
                    data: function (d) {
                        return d.Result.data;
                    }
                }
            }, change: function (e) {
                if (fnCallbak != undefined) {
                    var obj = e.sender.dataItem();
                    if (typeof (obj) == "undefined" || obj == null) {
                        obj = { DMA_ID: "", DMA_ChineseName: "" };
                    }
                    fnCallbak(obj);
                }
                //var result = false;
                //var val = this.value();
                //$.each(this.dataSource.data(), function (index, obj) {
                //    if (obj.HOS_ID == val) {
                //        result = true;
                //        return;
                //    }
                //});
                //if (!result) {
                //    this.value("");
                //}
            }, dataBound: function (e) {
                //刷新后赋值
                if (typeof (selVal) != "undefined" && selVal != "" && selVal != null) {
                    $("#" + controlId).data("kendoComboBox").value(selVal);
                }
                //针对setDataSource(重新绑定)方法，需要从新初始化默认值
                selVal = "";
            },
            filtering: function (e) {
                //get filter descriptor
                var filter = e.filter;

                // handle the event
            }
        });
    },
    //绑定下级经销商
    bindSubDealer: function (controlId, productLineId, parentDealerId, selVal, fnCallbak) {
        if (typeof (productLineId) == "undefined" || productLineId == null) {
            productLineId = "";
        }
        if (typeof (parentDealerId) == "undefined" || parentDealerId == null) {
            parentDealerId = "";
        }
        $("#" + controlId).kendoComboBox({
            placeholder: "-- 请输入经销商关键词 --",
            dataTextField: "DMA_ChineseName",
            dataValueField: "DMA_ID",
            clearButton: true,
            filter: "contains",
            autoBind: true,
            minLength: 1,
            height: 260,
            dataSource: {
                transport: {
                    read: {
                        type: "post",
                        url: "/ServiceHandlers/CommonService.ashx",
                        dataType: "json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var parameter = {
                                jsonMessageString: kendo.stringify({
                                    ActionName: "Common",
                                    Parameters: {
                                        OperateType: "GetSubDealer",
                                        parentDealerId: parentDealerId,
                                        productLineId: productLineId
                                    }
                                })
                            };
                            return parameter;
                        }
                    }
                },
                schema: {
                    data: function (d) {
                        return d.Result.data;
                    }
                }
            }, dataBound: function (e) {
                //刷新后赋值
                if (typeof (selVal) != "undefined" && selVal != "" && selVal != null) {
                    $("#" + controlId).data("kendoComboBox").value(selVal);
                }
                //针对setDataSource(重新绑定)方法，需要从新初始化默认值
                selVal = "";
            }
        });
    },
    bindProductlineAuth: function (controlId, selVal, fnCallbak) {
        var ctl = $("#" + controlId).kendoComboBox({
            placeholder: "-- 请选择产品线 --",
            dataTextField: "AttributeName",
            dataValueField: "Id",
            clearButton: true,
            filter: "contains",
            autoBind: true,
            minLength: 1,
            height: 260,
            dataSource: {
                serverFiltering: false,
                transport: {
                    read: {
                        type: "post",
                        url: "/ServiceHandlers/CommonService.ashx",
                        dataType: "json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var parameter = {
                                jsonMessageString: kendo.stringify({
                                    ActionName: "Common",
                                    Parameters: {
                                        OperateType: "GetProductListByAuth",
                                        filter: options.filter ? kendo.stringify(options.filter) : null
                                    }
                                })
                            };
                            return parameter;
                        }
                    }
                },
                schema: {
                    parse: function (res) {
                        return res.Result;
                    },
                    data: function (d) {
                        return d.data;
                    }
                }
            },
            change: function (e) {
                if (fnCallbak != undefined) {
                    var obj = e.sender.dataItem();
                    if (typeof (obj) == "undefined" || obj == null) {
                        obj = { Id: "", AttributeName: "" };
                    }
                    fnCallbak(obj);
                }
            },
            dataBound: function (e) {
                //刷新后赋值
                if (typeof (selVal) != "undefined" && selVal != "" && selVal != null) {
                    $("#" + controlId).data("kendoComboBox").value(selVal);
                }
                //针对setDataSource(重新绑定)方法，需要从新初始化默认值
                selVal = "";
            }
        }).data('kendoComboBox');
        return ctl;
    },
    bindPCTNameAuth: function (controlId, selVal, fnCallbak) {
        var ctl = $("#" + controlId).kendoComboBox({
            placeholder: "-- 请选择产品分类 --",
            dataTextField: "AttributeName",
            dataValueField: "Id",
            clearButton: true,
            filter: "contains",
            autoBind: true,
            minLength: 1,
            height: 260,
            dataSource: {
                serverFiltering: true,
                transport: {
                    read: {
                        type: "post",
                        url: "/ServiceHandlers/CommonService.ashx",
                        dataType: "json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var parameter = {
                                jsonMessageString: kendo.stringify({
                                    ActionName: "Common",
                                    Parameters: {
                                        OperateType: "GetPCTListByAuth",
                                        filter: options.filter.filters.length > 0 ? options.filter.filters[0].value : $("#" + controlId).data("kendoComboBox").text()
                                    }
                                })
                            };
                            return parameter;
                        }
                    }
                },
                schema: {
                    parse: function (res) {
                        return res.Result;
                    },
                    data: function (d) {
                        return d.data;
                    }
                }
            },
            change: function (e) {
                if (fnCallbak != undefined) {
                    var obj = e.sender.dataItem();
                    if (typeof (obj) == "undefined" || obj == null) {
                        obj = { Id: "", AttributeName: "" };
                    }
                    fnCallbak(obj);
                }
            },
            dataBound: function (e) {
                //刷新后赋值
                if (typeof (selVal) != "undefined" && selVal != "" && selVal != null) {
                    $("#" + controlId).data("kendoComboBox").value(selVal);
                }
                //针对setDataSource(重新绑定)方法，需要从新初始化默认值
                selVal = "";
            }
        }).data('kendoComboBox');
        return ctl;
    },
    bindDatePeriod: function (controlId, period) {
        $("#" + controlId).kendoComboBox({
            dataTextField: "Value",
            dataValueField: "Key",
            clearButton: true,
            filter: "contains",
            autoBind: true,
            height: 260,
            dataSource: {
                transport: {
                    read: {
                        type: "post",
                        url: "/ServiceHandlers/CommonService.ashx",
                        dataType: "json"
                        //contentType: "application/json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var parameter = {
                                jsonMessageString: kendo.stringify({
                                    ActionName: "Report",
                                    Parameters: {
                                        OperateType: "GetDatePeriod",
                                        period: period,
                                        spacing: 2
                                    }
                                })
                            };
                            return parameter;
                        }
                    }
                },
                schema: {
                    parse: function (res) {
                        return res.Result;
                    },
                    data: function (d) {
                        return d.data;
                    }
                }
            }, change: function (e) {
                var result = false;
                var val = this.value();
                $.each(this.dataSource.data(), function (index, obj) {
                    if (obj.Key == val) {
                        result = true;
                    }
                });
                if (!result) {
                    this.value("");
                }
            },
            dataBound: function (e) {
                this.select(0);
            }
        });
    },
    //绑定医院和销售岗位
    bindHospitalAndPosition: function (controlId, dealerId, productLineID) {
        $("#" + controlId).kendoDropDownList({
            optionLabel: "--  请输入医院编号或医院名称关键字  --",
            dataTextField: "HosHospitalName",
            dataValueField: "ID",
            autoBind: true,
            fixedGroupTemplate: "销售岗位： #: data #",
            groupTemplate: "销售岗位： #: data #",
            filter: "contains",
            minLength: 1,
            height: 320,
            dataSource: {
                transport: {
                    read: {
                        type: "post",
                        url: "/ServiceHandlers/CommonService.ashx",
                        dataType: "json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var parameter = {
                                jsonMessageString: kendo.stringify({
                                    ActionName: "Common",
                                    Parameters: {
                                        OperateType: "GetHospitalAndPosition",
                                        DealerId: dealerId,
                                        productLineId: productLineID
                                    }
                                })
                            };
                            return parameter;
                        }

                    }
                },
                schema: {
                    data: function (res) {
                        //var response = $.parseJSON(res.Result.data);
                        return res.Result.data;
                    }
                },
                group: { field: "TSRPositionName" }
            }
        });
    },
}

$.extend($.expr[":"], {
    "containsCI": function (elem, i, match, array) {
        return (elem.textContent || elem.innerText || "").toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0;
    }
});

dms.kendo = {
    //动态改变kendogrid的列宽；gridid为grid的id；idx为gird的第几列，从0开始计算；width为将要设置的宽度值；
    resizeGridColumnWidth: function (gridid, idx, width) {
        $("#" + gridid + " .k-grid-header-wrap") //header
           .find("colgroup col")
           .eq(idx)
           .css({ width: width });

        $("#" + gridid + " .k-grid-content") //content
           .find("colgroup col")
           .eq(idx)
           .css({ width: width });
    },

    //kendo无法自动解析"HH:mm:ss MM/dd/yyyy"时间字段
    parseDate: function (value) {
        return kendo.parseDate(value, "HH:mm:ss MM/dd/yyyy");
    },

    //调出弹出框
    showBatch: function (e) {
        var element = $(".k-split-button");
        var popup = element.data("kendoPopup");

        if (popup) {
            popup.open();
        }
    }
}


dms.file = {
    // 文件下载(Excel)；生成数据文件，并导出；
    downloadExcel: function (action, param) {
        dms.common.showMask();
        utility.CallService(action, param, function (res) {
            var rtn = res.Result;
            if (rtn.Message == "0" || rtn.Message == "") {
                $("<iframe name='frmDownload' style='width:0;height:0'></iframe>").appendTo('body');
                window.open(rtn.FilePath, "frmDownload");
            }
            else {
                alert("文件下载失败")
            }
            dms.common.hideMask();
        }, function (res) {
            dms.common.hideMask();
        }, null, null, false);
    },

    //文件下载，模板等现成文件的下载；
    //参数filepath 格式： "/resources/SAPPriceTemplate/ZPR0 620.XLSX"
    downloadFile: function (filepath) {
        $("<iframe name='frmDownload' style='width:0;height:0'></iframe>").appendTo('body');
        window.open(filepath, "frmDownload");
    },

    //通过excel文件导入数据；
    //调用前需要在页面定义相应的控件；
    importDataByExcelInit: function (type, winTitle) {
        //文件是否在上传中的标识；
        var IsUploadding = false;

        $("#ImportErrorGrid").kendoGrid({
            // toolbar: kendo.template($("#errormsg_toolbar").html()),
            resizable: true,
            scrollable: false
        });

        $("#files").kendoUpload({
            async: {
                saveUrl: "/ServiceHandlers/UploadFile.ashx?Type=" + type,
                autoUpload: true
            },
            localization: {
                headerStatusUploading: "上传处理中,请稍等..."
            },
            multiple: false,
            error: function onError(e) {
                if (e.XMLHttpRequest.responseText != "") {
                    dms.common.alert(e.XMLHttpRequest.responseText);
                }
                dms.common.hideMask();
                var upload = $("#files").data("kendoUpload");
                upload.enable();
                IsUploadding = false;
            },
            success: function onSuccess(e) {
                if (e.XMLHttpRequest.responseText != "") {
                    var obj = $.parseJSON(e.XMLHttpRequest.responseText);
                    if (obj.result == "Error") {
                        dms.common.alert(obj.msg);
                    }
                    if (obj.result == "DataError") {//如果是导入的数据问题，则刷新列表显示错误内容；
                        var dataSource = new kendo.data.DataSource({
                            data: obj.msg
                        });
                        var grid = $("#ImportErrorGrid").data("kendoGrid");
                        grid.setDataSource(dataSource);
                        //dms.kendo.resizeGridColumnWidth("ImportErrorGrid", 0, 100);
                        $(".k-grid-toolbar #msg_toolbar").show();
                        $("#ImportErrorGrid").show();

                        dms.common.alert("导入数据有问题，详见错误信息列表。");
                    } else if (obj.result == "Success") {
                        var dataSource = $("#ImportErrorGrid").data("kendoGrid").dataSource;
                        dataSource.data([]);
                        $(".k-grid-toolbar #msg_toolbar").hide();
                        $("#ImportErrorGrid").hide();
                        dms.common.alert("数据导入成功，请刷新数据！");
                        //$("#uploadShow").addClass("cd-panel--is-visible");
                    }
                    IsUploadding = false;
                }
                dms.common.hideMask();
                var upload = $("#files").data("kendoUpload");
                upload.enable();
            },
            upload: function onUpload(e) {
                var files = e.files;
                // Check the extension of the file and abort the upload if it is not .xls or .xlsx
                $.each(files, function () {
                    if (this.extension.toLowerCase() != ".xls" && this.extension.toLowerCase() != ".xlsx") {
                        dms.common.alert("只能导入Excel文件！")
                        e.preventDefault();
                        var dataSource = $("#ImportErrorGrid").data("kendoGrid").dataSource;
                        dataSource.data([]);
                        dms.common.hideMask();
                    }
                    else {
                        dms.common.showMask();
                        var upload = $("#files").data("kendoUpload");
                        upload.disable();
                        IsUploadding = true;
                    }
                });
            }
        });
    },
    importDataByExcelInitByID: function (type, winTitle, filesID, ErrorGridID) {
        //文件是否在上传中的标识；
        var IsUploadding = false;

        $("#" + ErrorGridID).kendoGrid({
            // toolbar: kendo.template($("#errormsg_toolbar").html()),
            resizable: true,
            scrollable: false
        });

        $("#" + filesID).kendoUpload({
            async: {
                saveUrl: "/ServiceHandlers/UploadFile.ashx?Type=" + type,
                autoUpload: true
            },
            localization: {
                headerStatusUploading: "上传处理中,请稍等..."
            },
            multiple: false,
            error: function onError(e) {
                if (e.XMLHttpRequest.responseText != "") {
                    dms.common.alert(e.XMLHttpRequest.responseText);
                }
                dms.common.hideMask();
                var upload = $("#" + filesID).data("kendoUpload");
                upload.enable();
                IsUploadding = false;
            },
            success: function onSuccess(e) {
                if (e.XMLHttpRequest.responseText != "") {
                    var obj = $.parseJSON(e.XMLHttpRequest.responseText);
                    if (obj.result == "Error") {
                        dms.common.alert(obj.msg);
                    }
                    if (obj.result == "DataError") {//如果是导入的数据问题，则刷新列表显示错误内容；
                        var dataSource = new kendo.data.DataSource({
                            data: obj.msg
                        });
                        var grid = $("#" + ErrorGridID).data("kendoGrid");
                        grid.setDataSource(dataSource);
                        //dms.kendo.resizeGridColumnWidth("ImportErrorGrid", 0, 100);
                        $(".k-grid-toolbar #msg_toolbar").show();
                        $("#" + ErrorGridID).show();

                        dms.common.alert("导入数据有问题，详见错误信息列表。");
                    } else if (obj.result == "Success") {
                        var dataSource = $("#" + ErrorGridID).data("kendoGrid").dataSource;
                        dataSource.data([]);
                        $(".k-grid-toolbar #msg_toolbar").hide();
                        $("#" + ErrorGridID).hide();
                        dms.common.alert("数据导入成功，请刷新数据！");
                        //$("#uploadShow").addClass("cd-panel--is-visible");
                    }
                    IsUploadding = false;
                }
                dms.common.hideMask();
                var upload = $("#" + filesID).data("kendoUpload");
                upload.enable();
            },
            upload: function onUpload(e) {
                var files = e.files;
                // Check the extension of the file and abort the upload if it is not .xls or .xlsx
                $.each(files, function () {
                    if (this.extension.toLowerCase() != ".xls" && this.extension.toLowerCase() != ".xlsx") {
                        dms.common.alert("只能导入Excel文件！")
                        e.preventDefault();
                        var dataSource = $("#" + ErrorGridID).data("kendoGrid").dataSource;
                        dataSource.data([]);
                        dms.common.hideMask();
                    }
                    else {
                        dms.common.showMask();
                        var upload = $("#" + filesID).data("kendoUpload");
                        upload.disable();
                        IsUploadding = true;
                    }
                });
            }
        });
    }
}

//飞入效果
dms.fly = {
    callFlyAnimation: function (gridId, ev) {
        var ev = ev || window.event;
        var pageX = !ev ? 100 : ev.pageX;
        var pageY = !ev ? 100 : ev.pageY;
        var offset = $("#" + gridId).offset();
        var flyer = $('<div class="fly-item fa fa-cube"></div>');
        flyer.fly({
            start: {
                left: pageX,
                top: pageY
            },
            end: {
                left: offset.left + 10,
                top: offset.top + 10,
                width: 0,
                height: 0
            },
            onEnd: function () {
                this.destory();
            }
        });
    }
}