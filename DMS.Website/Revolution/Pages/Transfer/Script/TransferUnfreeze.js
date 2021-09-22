var TransferUnfreeze = {};

TransferUnfreeze = function () {
    var that = {};

    var business = 'Transfer.TransferUnfreeze';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstStatusArr = "";
    var LstTypeArr = "";
    var LstDealerArr = "";

    that.Init = function () {
        var data = {};

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstStatusArr = model.LstStatus;
                LstTypeArr = model.LstType;
                LstDealerArr = model.LstDealer;
                //产品线
                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryProductLine
                });
                //经销商
                $('#QryDealer').DmsDealerFilter({
                    dataSource: model.LstDealerName,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealer
                });
                //移库单号
                $('#QryTransferNumber').FrameTextBox({
                    value: model.QryTransferNumber
                });

                $('#QryApplyDate').FrameDatePickerRange({
                    value: model.QryApplyDate
                });
                //状态
                $('#QryTransferStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryTransferStatus
                });
                //产品型号
                $('#QryCFN').FrameTextBox({
                    value: model.QryCFN
                });
                //批号/二维码
                $('#QryLotNumber').FrameTextBox({
                    value: model.QryLotNumber
                });

                //移库单类型
                $('#QryTransferType').FrameDropdownList({
                    dataSource: model.LstType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryTransferType
                });

                createResultList();

                //按钮控制*******************
                if (model.ShowSearch) {
                    $('#BtnQuery').FrameButton({
                        text: '查询',
                        icon: 'search',
                        onClick: function () {
                            that.Query();
                        }
                    });
                }

                $('#BtnInsert').FrameButton({
                    text: '冻结库移库',
                    icon: 'plus',
                    onClick: function () {
                        that.openInfo('00000000-0000-0000-0000-000000000000', 'Transfer');
                    }
                });
                $('#BtnHistoryExport').FrameButton({
                    text: '历史移库单导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });
                $('#BtnExcelImport').FrameButton({
                    text: 'Excel导入',
                    icon: 'file-code-o',
                    onClick: function () {
                        that.ExcelImport();
                    }
                });
                //**********************

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
            grid.dataSource.page(1);
            return;
        }
    }

    var fields = {
        TransferDate: { type: "date", format: "{0:yyyy-MM-dd HH:mm:ss}" }
    };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 15);

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 420,
            columns: [
                {
                    field: "FromDealerDmaId", title: "经销商", width: 220, template: function (gridRow) {
                        var dealerName = "";
                        if (LstDealerArr.length > 0) {
                            if (gridRow.FromDealerDmaId != "") {
                                $.each(LstDealerArr, function () {
                                    if (this.Id == gridRow.FromDealerDmaId) {
                                        dealerName = this.ChineseShortName;
                                        return false;
                                    }
                                })
                            }
                        }
                        return dealerName;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "BrandName", title: "品牌", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell" }

                },
                {
                    field: "TransferNumber", title: "移库单号", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "移库单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ToDealerDmaId", title: "经销商", width: 220, template: function (gridRow) {
                        var dealerName = "";
                        if (LstDealerArr.length > 0) {
                            if (gridRow.ToDealerDmaId != "") {
                                $.each(LstDealerArr, function () {
                                    if (this.Id == gridRow.ToDealerDmaId) {
                                        dealerName = this.ChineseShortName;
                                        return false;
                                    }
                                })
                            }
                        }
                        return dealerName;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalQyt", title: "总数量", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "总数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TransferDate", title: "出库日期", width: 130, format: "{0:yyyy-MM-dd HH:mm:ss}",
                    headerAttributes: { "class": "text-center text-bold", "title": "出库日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TransferUserName", title: "出库人", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "出库人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Type", title: "移库单类型", width: 100, template: function (gridrow) {
                        var Name = "";
                        if (LstTypeArr.length > 0) {
                            if (gridrow.Type != "") {
                                $.each(LstTypeArr, function () {
                                    if (this.Key == gridrow.Type) {
                                        Name = this.Value;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "移库单类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Status", title: "状态", width: 100, template: function (gridrow) {
                        var Name = "";
                        if (LstStatusArr.length > 0) {
                            if (gridrow.Status != "") {
                                $.each(LstStatusArr, function () {
                                    if (this.Key == gridrow.Status) {
                                        Name = this.Value;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "明细", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
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

                    that.openInfo(data.Id, data.Type, data.TransferNumber);
                });
            }
        });
    }

    that.openInfo = function (InstanceId, Type, OrderNo) {
        if (InstanceId) {
            var IsNew = InstanceId == '00000000-0000-0000-0000-000000000000' ? true : false;
            top.createTab({
                id: 'M_' + (InstanceId == '00000000-0000-0000-0000-000000000000' ? 'TRANSFER_TRANSFERUNFREEZE_TRANSFER_NEW' : InstanceId),
                title: '移库单明细 -' + ((OrderNo == null || OrderNo == undefined) ? 'New' : OrderNo),
                url: 'Revolution/Pages/Transfer/TransferUnfreezeInfo.aspx?IsNew=' + IsNew + '&&InstanceId=' + InstanceId + '&&Type=' + Type,
                refresh: true
            });
        }
    }

    var openPrintPage = function (id) {
        window.open("TransferPrint.aspx?id=" + id, 'newwindow',
        'status=no,width=850px,height=550px,scrollbars=yes,resizable=yes,location=no,top=50,left=100');
    }

    //历史移库单导出
    that.Export = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'TransferUnfreezeExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferDateStart', data.QryApplyDate.StartDate == null ? "" : data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferDateEnd', data.QryApplyDate.EndDate == null ? "" : data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferNumber', data.QryTransferNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'Status', data.QryTransferStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Cfn', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'LotNumber', data.QryLotNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferType', data.QryTransferType.Key);
        startDownload(urlExport, 'TransferUnfreezeExport');//下载名称
    }

    that.ExcelImport = function () {
        top.createTab({
            id: 'M_IMPORTTRANSFERUNFREEZE',
            title: '冻结库解冻-Excel导入',
            url: 'Revolution/Pages/Transfer/TransferUnfreezeImport.aspx'
        });
    };

    var setLayout = function () {
    }

    return that;
}();
