var ReturnPositionSearch = {};

ReturnPositionSearch = function () {
    var that = {};

    var business = 'Inventory.ReturnPositionSearch';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#WinIDCode').val('');
                $('#WinProductline').val('');
                $('#Winamount').val('');
                //$('#QryDealer').FrameDropdownList({
                //    dataSource: model.LstDealer,
                //    dataKey: 'Id',
                //    dataValue: 'ChineseShortName',
                //    selectType: 'all',
                //    filter: 'contains',
                //    value: model.QryDealer,
                //    onChange: that.DealerChange
                //});
                $('#QryDealer').DmsDealerFilter({
                    dataSource: model.LstDealer,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealer
                });
                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryProductLine
                });
                $('#WinProductLine').FrameDropdownList({
                    dataSource: model.LstWinProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.WinProductLine
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });

                $('#BtnNew').FrameButton({
                    text: '新增',
                    icon: 'plus',
                    onClick: function () {
                        $('#WinIDCode').val('');
                        $('#WinProductline').val('');
                        $('#Winamount').val('');
                        Inserttde();
                    }
                });

                //弹出窗体
                $('#BtnSubmit').FrameButton({
                    text: '提交',
                    icon: 'upload',
                    onClick: function () {
                        that.Submit();
                    }
                });

                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'times',
                    onClick: function () {
                        $("#winPromotionType").data("kendoWindow").close();
                    }
                });

                if (model.IsDealer == true) {
                    if (model.DealerType == "T1" || model.DealerType == "LP") {
                        $('#QryDealer').FrameDropdownList('disable');
                        $('#BtnNew').remove();
                        var gridResult = $("#RstResultList").data("kendoGrid");
                        gridResult.hideColumn(8); //修改
                    }
                }

                //$("#RstResultList").data("kendoGrid").setOptions({
                //    dataSource: model.RstResultList
                //});

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    //导出
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'ReturnPositionSearchExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        startDownload(urlExport, 'ReturnPositionSearchExport');

    }

    //返回服务端分页数据，第一个参数为映射business页面，第二个参数为business页面查询方法，第三个参数为需要格式化参数类型，如日期类型，无需处理则传入null或不传，第四个参数每页显示条目，不传默认为10条
    //var fields = { DC_CreatedDate: { type: "date" } };
    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 20);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "SAPCode", title: "经销商SAPCode", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商SAPCode" }
                },
                {
                    field: "DealerName", title: "经销商名称", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: 130,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" }
                },
                {
                    field: "BrandName", title: "品牌", width:120,
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" }
                },
                {
                    field: "Year", title: "年份", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "年份" }
                },
                {
                    field: "Amount", title: "汇总金额", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "汇总金额" }
                },
                {
                    title: "明细",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 50,
                    template: "#if ($('\\#SAPCode').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "修改",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 50,
                    template: "#if ($('\\#SAPCode').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='update'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $('#WinIDCode').val(data.SAPCode);
                    $('#WinProductline').val(data.ProductLineID);
                    ShowDetails();
                });

                $("#RstResultList").find("i[name='update']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $('#WinIDCode').val(data.DealerId);
                    $('#WinProductline').val(data.ProductLineID);
                    $('#Winamount').val(data.Amount);
                    Inserttde();
                });
            }
        });
    }

    var kendoDetailSource = GetKendoDataSource(business, 'QueryDetail', null, 20);
    var createDetailList = function () {
        $("#RstWinDetail").kendoGrid({
            dataSource: kendoDetailSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 450,
            columns: [
                {
                    field: "CreateUserName", title: "操作人", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "操作人" }
                },
                {
                    field: "CreateDate", title: "操作时间", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "操作时间" }
                },
                {
                    field: "ChineseName", title: "经销商名称", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "ReturnNbr", title: "退货单号", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "退货单号" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "Years", title: "年份", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "年份" }
                },
                {
                    field: "DRP_Quarter", title: "账期", width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "账期" }
                },
                {
                    field: "DetailAmount", title: "金额明细", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "金额明细" }
                },
                {
                    field: "DRP_Type", title: "操作类型", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "操作类型" }
                },
                {
                    field: "DRP_Desc", title: "操作备注", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "操作备注" }
                },
                {
                    field: "SubmitBeginDate", title: "额度开始使用时间", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "额度开始使用时间" }
                },
                {
                    field: "DRP_SubmitEndDate", title: "额度终止使用时间", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "额度终止使用时间" }
                },
                {
                    field: "DRP_ExpBeginDate", title: "产品效期开始时间", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品效期开始时间" }
                },
                {
                    field: "ExpEndDate", title: "产品效期终止时间", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品效期终止时间" }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {

            }
        });
    }

    var ShowDetails = function () {

        createDetailList();
        $("#winDetailLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: 480,
            actions: [
                "Maximize",
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("退货单明细").center().open();
    }

    var Inserttde = function () {
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitPromotionType',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //$('#WinDealer').FrameDropdownList({
                //    dataSource: model.LstDealer,
                //    dataKey: 'Id',
                //    dataValue: 'ChineseShortName',
                //    selectType: 'all',
                //    filter: 'contains',
                //    value: model.WinDealer
                //});
                $('#WinDealer').DmsDealerFilter({
                    dataSource: model.LstWinDealer,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.WinDealer,
                    onChange: that.ChangeDealer
                });
                $("#WinProductLine_Control").data("kendoDropDownList").value(data.WinProductline);
                $('#WinProductLine').FrameDropdownList('enable');
                if (data.WinIDCode != '' && data.WinProductline != '') {
                    $('#WinDealer').DmsDealerFilter('disable');
                    $("#WinProductLine_Control").data("kendoDropDownList").value(data.WinProductline);
                    $('#WinProductLine').FrameDropdownList('disable');
                }
                $('#WinYears').FrameTextBox({
                    value: ''
                });
                $('#WinQuarter').FrameDropdownList({
                    dataSource: [{ Key: "1", Value: "第一季度" }, { Key: "2", Value: "第二季度" }, { Key: "3", Value: "第三季度" }, { Key: "4", Value: "第四季度" }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: []
                });
                $('#WinAmount').FrameTextBox({
                    value: ''
                });
                $('#WinRemark').FrameTextArea({
                    value: ''
                });

                FrameWindow.HideLoading();

                $("#winPromotionType").kendoWindow({
                    title: "Title",
                    width: 450,
                    actions: [
                        "Close"
                    ],
                    resizable: false,
                    //modal: true,
                }).data("kendoWindow").title("退货单明细修改").center().open();
            }
        });

    }

    that.ChangeDealer = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeDealer',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.ExecuteMessage == 'true') {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '不能设定二级退货额度！',
                        callback: function () {
                        }
                    });
                    $("#WinDealer_Control").data("kendoDropDownList").value('');
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.Submit = function () {
        var data = that.GetModel();
        if (checkNumber(data.WinAmount)) {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Submit',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                    if (model.IsSuccess == true)
                        $("#winPromotionType").data("kendoWindow").close();
                    FrameWindow.HideLoading();
                }
            });
        }
        else {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请输入正确数据！',
                callback: function () {
                }
            });
        }
    }

    var checkNumber = function (theObj) {
        var reg = /^(\-|\+)?\d+(\.\d+)?$/;
        if (reg.test(theObj)) {
            return true;
        }
        return false;
    }

    var setLayout = function () {
    }

    return that;
}();