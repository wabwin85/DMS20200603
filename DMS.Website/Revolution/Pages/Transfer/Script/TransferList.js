var TransferList = {};

TransferList = function () {
    var that = {};

    var business = 'Transfer.TransferList';

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
                $("#hidInitDealerId").val(model.hidInitDealerId);
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
                            model.QryDealerFrom = { Key: val.Id, Value: val.ChineseShortName };
                    })
                }
                //$('#QryDealerFrom').FrameDropdownList({
                //    dataSource: model.LstDealer,
                //    dataKey: 'Id',
                //    dataValue: 'ChineseShortName',
                //    selectType: 'none',
                //    //readonly: model.IsDealer ? true : false,
                //    value: model.QryDealerFrom
                //});
                //if (model.IsDealer) {
                //    $('#QryDealerFrom').FrameDropdownList('disable');
                //}

                $('#QryDealerFrom').DmsDealerFilter({
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
                    value: model.QryDealerFrom,
                });
                if (model.IsDealer)
                    $("#QryDealerFrom").DmsDealerFilter('disable');
                //借入经销商
                $('#QryDealerTo').FrameDropdownList({
                    dataSource: model.LstToDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'all',
                    value: model.QryToDealer
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
                //借货出库单号
                $('#QryTransferNumber').FrameTextBox({
                    value: model.QryTransferNumber
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

                $('#QryLPUploadNo').FrameTextBox({
                    value: model.QryLPUploadNo
                });


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

                $('#BtnExport').FrameButton({
                    text: '出库单导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.export();
                    }
                });

                //非经销商不显示
                //经销商，类型DealerType.LP、LS不显示
                if (model.InsertEnable) {
                    $('#BtnNew').FrameButton({
                        text: '新增',
                        icon: 'plus',
                        onClick: function () {
                            openInfo();
                        }
                    });
                    $('#BtnExcelImport').FrameButton({
                        text: 'Excel导入',
                        icon: 'file-code-o',
                        onClick: function () {
                            that.ExcelImport();
                        }
                    });
                }
                else {
                    $('#BtnNew').remove();
                    $('#BtnExcelImport').remove();
                }

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
                    field: "FromDealerDmaId", title: "借出经销商", width: 'auto', template: function (gridrow) {
                        var Name = "";
                        if (LstDealerArr.length > 0) {
                            if (gridrow.FromDealerDmaId != "") {
                                $.each(LstDealerArr, function () {
                                    if (this.Id == gridrow.FromDealerDmaId) {
                                        Name = this.ChineseName;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        } else {
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "借出经销商" },
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
                    field: "TransferNumber", title: "借货出库单号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "借货出库单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ToDealerDmaName", title: "借入经销商", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "借入经销商" },
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
                    field: "LPUploadNo", title: "平台上传单号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "平台上传单号" },
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

    var openInfo = function (InstanceId, Type, OrderNo) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '借货出库-' + ValidateDataType(OrderNo),
                url: 'Revolution/Pages/Transfer/TransferListInfo.aspx?InstanceId=' + InstanceId + '&&Type=' + Type,
                refresh: true,
            });
        } else {
            top.createTab({
                id: 'M_TRANSFERFER_TRANSFERLIST_NEW',
                title: '借货出库 - 新增',
                url: 'Revolution/Pages/Transfer/TransferListInfo.aspx?IsNew=true',
                refresh: true
            });
        }
    }

    that.ExcelImport = function () {
        top.createTab({
            id: 'M_TRANSFERLIST_EXCELEXPORT',
            title: '借货出库-Excel导入',
            url: 'Revolution/Pages/Transfer/TransferListImport.aspx'
        });
    };
    //出库单导出
    that.export = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'TransferListExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.QryDealerFrom.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerTo', data.QryDealerTo.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferDateStart', data.QryApplyDate.StartDate == null ? "" : data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferDateEnd', data.QryApplyDate.EndDate == null ? "" : data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferNumber', data.QryTransferNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'Status', data.QryTransferStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Cfn', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'LotNumber', data.QryLotNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferType', data.QryTransferType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'LPUploadNo', data.QryLPUploadNo);
        startDownload(urlExport, 'TransferListExport');//下载名称
    }

    var setLayout = function () {
    }

    return that;
}();
