var TransferEditor = {};

TransferEditor = function () {
    var that = {};

    var business = 'Transfer.TransferEditor';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstBuArr = "";
    var LstStatusArr = "";
    var LstTypeArr = "";
    var LstDealerArr = "";

    that.Init = function () {
        var data = {};
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstBuArr = model.LstBu;
                LstStatusArr = model.LstStatus;
                LstTypeArr = model.LstType;
                LstDealerArr = model.LstDealer;
                $("#DealerListType").val(model.DealerListType);
                //产品线
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                //经销商
                if (model.hidInitDealerId != "" || model.hidInitDealerId != null) {
                    $.each(model.LstDealer, function (index, val) {
                        if (model.hidInitDealerId === val.Id)
                            model.QryDealer = { Key: val.Id, Value: val.ChineseShortName };
                    })
                }
                //$('#QryDealer').FrameDropdownList({
                //    dataSource: model.LstDealer,
                //    dataKey: 'Id',
                //    dataValue: 'ChineseShortName',
                //    selectType: 'all',
                //    value: model.QryDealer
                //});
                //if (model.IsDealer) {
                //    $('#QryDealer').FrameDropdownList('disable');
                //}
                $('#QryDealer').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    parameters: { "IsAll": true },//是否查全部
                    business: 'Util.DealerScreenFilter',
                    method: 'DealerFilter',
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'none',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealer,
                });
                if (model.IsDealer) {
                    $("#QryDealer").DmsDealerFilter('disable');
                }
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
                    value: model.QryType
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
                    value: model.QryType
                });

                //按钮控制*******************
                if (model.ShowSerch) {
                    $('#BtnQuery').FrameButton({
                        text: '查询',
                        icon: 'search',
                        onClick: function () {
                            that.Query();
                        }
                    });
                }
                else {
                    $('#BtnQuery').remove();
                }

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
                if (model.IsDealer) {
                    $('#Btnordinary').FrameButton({
                        text: '普通库移库',
                        icon: 'plus',
                        onClick: function () {
                            that.OpenPage("1");
                        }
                    });
                    //该功能隐藏
                    //$('#Btnconsignment').FrameButton({
                    //    text: '寄售库移库',
                    //    icon: 'plus',
                    //    onClick: function () {
                    //        that.OpenPage("2");
                    //    }
                    //});
                }
                else {
                    $('#Btnordinary').remove();
                    //$('#Btnconsignment').remove();
                }
                //**********************

                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

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
        StartDate: { type: "StartDate", format: "{0:yyyy-MM-dd}" }, EndDate: { type: "EndDate", format: "{0:yyyy-MM-dd}" }
    };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 15);

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "ToDealerDmaName", title: "经销商", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                 {
                     field: "SubCompanyName", title: "分子公司", width: '70px',
                     headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                     attributes: { "class": "table-td-cell" }
                 },
                  {
                      field: "BrandName", title: "品牌", width: '60px',
                      headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                      attributes: { "class": "table-td-cell" }

                  },
                {
                    field: "TransferNumber", title: "移库单号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "移库单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalQyt", title: "总数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "总数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TransferDate", title: "出库日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "出库日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TransferUserName", title: "出库人", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "出库人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Type", title: "移库单类型", width: '100px', template: function (gridrow) {
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
                        } else {
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "移库单类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Status", title: "状态", width: '100px', template: function (gridrow) {
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
                        } else {
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "明细", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "打印", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-print' style='font-size: 14px; cursor: pointer;' name='print'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                input: true,
                numeric: false
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

                    openInfo(data.Id, data.Type, data.TransferNumber);
                });

                $("#RstResultList").find("i[name='print']").on('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    openPrintPage(data.Id);
                })
            }
        });
    }

    that.ExcelImport = function () {
        top.createTab({
            id: 'M_TRANSFEREDITOR_EXCELEXPORT',
            title: '经销商移库-Excel导入',
            url: 'Revolution/Pages/Transfer/TransferEditorImport.aspx'
        });
    };
    var openInfo = function (InstanceId, Type, OrderNo) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '经销商移库-' + ValidateDataType(OrderNo),
                url: 'Revolution/Pages/Transfer/TransferEditorInfo.aspx?InstanceId=' + InstanceId + '&&Type=' + Type + '&&IsNewApply=false',
                refresh: true
            });
        } else {
        }
    }

    var openPrintPage = function (id) {
        window.open("TransferPrint.aspx?id=" + id, 'newwindow',
        'status=no,width=850px,height=550px,scrollbars=yes,resizable=yes,location=no,top=50,left=100');
    }

    that.OpenPage = function (obj) {
        if ("1" === obj) {//普通移库
            top.createTab({
                id: 'M_TRANSFER_TRANSFEREDITOR_TRANSFER_NEW',
                title: '经销商移库 - 普通移库',
                url: 'Revolution/Pages/Transfer/TransferEditorInfo.aspx?Type=Transfer&&IsNewApply=true',
                refresh: true
            });
        }
        else if ("2" === obj) {//寄售移库
            top.createTab({
                id: 'M_TRANSFER_TRANSFEREDITOR_CONSIGNMENT_NEW',
                title: '经销商移库 - 寄售移库',
                url: 'Revolution/Pages/Transfer/TransferEditorInfo.aspx?Type=TransferConsignment&&IsNewApply=true',
                refresh: true
            });
        }
    };
    //历史移库单导出
    that.Export = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'TransferEditorExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferDateStart', data.QryApplyDate.StartDate == null ? "" : data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferDateEnd', data.QryApplyDate.EndDate == null ? "" : data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferNumber', data.QryTransferNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'Status', data.QryTransferStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Cfn', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'LotNumber', data.QryLotNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferType', data.QryTransferType.Key);
        startDownload(urlExport, 'TransferEditorExport');//下载名称
    }

    var setLayout = function () {
    }

    return that;
}();
