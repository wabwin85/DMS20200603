var ShipmentInitList = {};

ShipmentInitList = function () {
    var that = {};

    var business = 'Shipment.ShipmentInitList';

    //下拉框数据源
    var LstDealer;
    var LstStatus;

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        createImportResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryShipmentInitStatus').FrameDropdownList({
                    dataSource: model.LstInitStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryShipmentInitStatus
                });
                LstStatus = model.LstInitStatus;
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
                LstDealer = model.LstDealerName;
                $('#QrySubmitDate').FrameDatePickerRange({
                    value: model.QrySubmitDate
                });
                $('#QryShipmentInitNo').FrameTextBox({
                    value: model.QryShipmentInitNo
                });

                $('#BtnSearch').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnImport').FrameButton({
                    text: '导入',
                    icon: 'file',
                    onClick: function () {
                        that.ShowImport();
                    }
                });
                $('#BtnExportError').FrameButton({
                    text: '导出错误数据',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });
                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'file-excel-o',
                    onClick: function () {
                        $("#winDetailImportResultLayout").data("kendoWindow").close();
                    }
                });

                if (model.IsDealer) {
                    $('#QryDealer_Control').data("kendoDropDownList").value(model.QryDealer.Key);
                    $('#QryDealer').DmsDealerFilter('disable');
                }

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Query = function () {
        var grid = $("#RstImportResult").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    var fields = { SubmitDate: { type: "date", format: "{0: yyyy-MM-dd}" } }
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 20);
    var createImportResultList = function () {
        $("#RstImportResult").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 400,
            columns: [
                {
                    field: "OrderNo", title: "编号",
                    headerAttributes: { "class": "text-center text-bold", "title": "编号" }
                },
                {
                    field: "OperType", title: "操作类型",
                    headerAttributes: { "class": "text-center text-bold", "title": "操作类型" }
                },
                {
                    field: "DmaId", title: "经销商", template: function (gridRow) {
                        var dealerName = "";
                        if (LstDealer.length > 0) {
                            if (gridRow.DmaId != "") {
                                $.each(LstDealer, function () {
                                    if (this.Id == gridRow.DmaId) {
                                        dealerName = this.ChineseName;
                                        return false;
                                    }
                                })
                            }
                        }
                        return dealerName;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "SubmitDate", title: "导入时间", format: "{0: yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "导入时间" }
                },
                {
                    field: "TotalQty", title: "导入总数量",
                    headerAttributes: { "class": "text-center text-bold", "title": "导入总数量" }
                },
                {
                    field: "InitStatus", title: "导入状态", template: function (gridRow) {
                        var status = "";
                        if (LstStatus.length > 0) {
                            if (gridRow.InitStatus != "") {
                                $.each(LstStatus, function () {
                                    if (this.Key == gridRow.InitStatus) {
                                        status = this.Value;
                                        return false;
                                    }
                                })
                            }
                        }
                        return status;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "导入状态" }
                },
                {
                    title: "明细",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='detail'></i>#}#",
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

                $("#RstImportResult").find("i[name='detail']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    $('#WinSelectNo').val(data.OrderNo);
                    $('#WinSelectStatus').val(data.InitStatus);
                    that.ShowDetails();
                    that.QueryDetail();
                });

            },
            page: function (e) {
            }
        });
    }

    var fieldsDetail = { ShipmentDate: { type: "date", format: "{0: yyyy-MM-dd}" }, ExpiredDate: { type: "date", format: "{0: yyyy-MM-dd}" } }
    var kendoDetailResult = GetKendoDataSource(business, 'QueryDetail', fieldsDetail, 20);

    //20190120 解决页面加载kendoWindow触发页面访问后台之后，再次点击其他详情数据错乱，无法刷新问题
    that.QueryDetail = function () {
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryDetailInit',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess == true) {
                    $("#RstWinDetailResult").data("kendoGrid").setOptions({
                        dataSource: model.RstWinDetailResult
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    }
    that.ShowDetails = function () {
        $("#RstWinDetailResult").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 245,
            columns: [
                {
                    field: "LineNbr", title: "行号", width: 45,
                    headerAttributes: { "class": "text-center text-bold", "title": "行号" }
                },
                {
                    field: "TypeFlg", title: "结果", width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "结果" }
                },
                {
                    field: "ShipmentDate", title: "销量日期", format: "{0:yyyy-MM-dd}",
                    width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "销量日期" }
                },
                {
                    field: "HospitalName", title: "医院", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院" }
                },
                {
                    field: "HospitalOffice", title: "科室", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "科室" }
                },
                {
                    field: "Warehouse", title: "仓库", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" }
                },
                {
                    field: "UPN", title: "产品编号", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" }
                },
                {
                    field: "UOM", title: "包装", width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "包装" }
                },
                {
                    field: "UOMQty", title: "包装数", width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "包装数" }
                },
                {
                    field: "LotNumber", title: "批号", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" }
                },
                {
                    field: "QrCode", title: "二维码", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "ExpiredDate", title: "产品有效期", format: "{0:yyyy-MM-dd}",
                    width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" }
                },
                {
                    field: "InvQty", title: "可用库存", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "可用库存" }
                },
                {
                    field: "ShipmentQty", title: "销售数量", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售数量" }
                },
                {
                    field: "InvRemnantQty", title: "剩余库存", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "剩余库存" }
                },
                {
                    field: "UnitPrice", title: "销售单价", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单价" }
                }
                ,
                {
                    field: "ErrorType", title: "错误类型", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "错误类型" }
                }
                ,
                {
                    field: "ErrorMassage", title: "错误描述", width: 230,
                    headerAttributes: { "class": "text-center text-bold", "title": "错误描述" }
                }
                ,
                {
                    field: "ProposedMassage", title: "建议修改", width: 230,
                    headerAttributes: { "class": "text-center text-bold", "title": "建议修改" }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            }
        });
        var data = { WinSelectNo: $("#WinSelectNo").val(), WinSelectStatus: $("#WinSelectStatus").val() };
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ShowDetailCnt',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#spWrongCnt').text(model.WinWrongCnt);
                    $('#spCorrectCnt').text(model.WinCorrectCnt);
                    $('#spInProcessCnt').text(model.WinInProcessCnt);
                    $('#spSumQty').text(model.WinSumQty);
                    $('#spSumPrice').text(model.WinSumPrice);
                }
                FrameWindow.HideLoading();
            }
        });

        $("#winDetailImportResultLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: 355,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("销售单导入结果查询").center().open();
    }

    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'ShipmentInitListExport');
        //urlExport = Common.UpdateUrlParams(urlExport, 'ShipmentListExportType', type);
        urlExport = Common.UpdateUrlParams(urlExport, 'WinSelectNo', data.WinSelectNo);
        startDownload(urlExport, 'ShipmentInitListExport');

    }

    that.ShowImport = function () {
        top.createTab({
            id: 'M_ShipmentInitList_New',
            title: '销售出库单导入',
            url: 'Revolution/Pages/Shipment/ShipmentInit.aspx'
        });
    }

    var setLayout = function () {
    }

    return that;
}();