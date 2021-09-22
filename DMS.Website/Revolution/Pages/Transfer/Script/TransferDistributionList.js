var TransferDistributionList = {};

TransferDistributionList = function () {
    var that = {};

    var business = 'Transfer.TransferDistributionList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstProductArr = "";
    var LstStatusArr = "";
    var LstDealerArr = "";

    that.Init = function () {
        var data = {};
        createTDLResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstProductArr = model.LstProductLine;
                LstStatusArr = model.LstTransferStatus;
                LstDealerArr = model.LstDealer;
                //产品线
                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryProductLine
                });
                //经销商
                $('#QryFromDealerName').DmsDealerFilter({
                    dataSource: model.LstFromDealer,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryFromDealerName,
                    onChange: that.ChangeFromDealer
                });
                //借入经销商
                $('#QryToDealerName').FrameDropdownList({
                    dataSource: model.LstToDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'select',
                    filter: 'contains',
                    value: model.QryToDealerName
                });
                $('#QryTransferDate').FrameDatePickerRange({
                    value: model.QryTransferDate
                });
                //状态
                $('#QryTransferStatus').FrameDropdownList({
                    dataSource: model.LstTransferStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryTransferStatus
                });
                //借货出库单号
                $('#QryTransferNumber').FrameTextBox({
                    value: model.QryTransferNumber
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
                })

                //非经销商不显示
                //经销商，类型DealerType.LP、LS不显示
                if (model.IsDealer) {
                    $('#BtnNew').FrameButton({
                        text: '新增',
                        icon: 'plus',
                        onClick: function () {
                            openInfo();
                        }
                    });
                }
                else {
                    $('#BtnNew').remove();
                }

                $("#RstTDLResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstTDLResultList
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
        var grid = $("#RstTDLResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    that.ChangeFromDealer = function () {

        var data = that.GetModel();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeFromDealer',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryToDealerName').FrameDropdownList({
                    dataSource: model.LstToDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'select',
                    filter: 'contains',
                    value: model.QryToDealerName
                });
                FrameWindow.HideLoading();
            }
        });

    }

    that.Export = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'TransferDistributionExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'FromDealerDmaId', data.QryFromDealerName.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'ToDealerDmaId', data.QryToDealerName.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferDateStart', data.QryTransferDate.StartDate == null ? "" : data.QryTransferDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferDateEnd', data.QryTransferDate.EndDate == null ? "" : data.QryTransferDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'TransferNumber', data.QryTransferNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'Status', data.QryTransferStatus.Key);
        startDownload(urlExport, 'TransferDistributionExport');//下载名称
    }

    var fields = {
        TransferDate: { type: "date", format: "{0:yyyy-MM-dd}" }
    };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 15);

    var createTDLResultList = function () {
        $("#RstTDLResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 450,
            columns: [
                {
                    field: "ProductLine", title: "产品线", width: 120, template: function (gridrow) {
                        var ProductLine = "";
                        if (LstProductArr.length > 0) {
                            if (gridrow.ProductLine != "") {
                                $.each(LstProductArr, function () {
                                    if (this.Key == gridrow.ProductLine) {
                                        ProductLine = this.Value;
                                        return false;
                                    }
                                })
                            }
                            return ProductLine;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "BrandName", title: "品牌", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "FromDealerDmaId", title: "一级经销商", width: 'auto', template: function (gridrow) {
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
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "一级经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TransferNumber", title: "分销出库单号", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "分销出库单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ToDealerDmaName", title: "二级经销商", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "借入经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalQyt", title: "总数量", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "总数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TransferDate", title: "出库日期", width: 100, format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "出库日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TransferUserName", title: "出库人", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "出库人" },
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

                $("#RstTDLResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    openInfo(data.Id, data.FromDealerDmaId);
                });

            }
        });
    }

    var openInfo = function (InstanceId, FromDealer) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '分销出库明细',
                url: 'Revolution/Pages/Transfer/TransferDistributionListInfo.aspx?IsNew=false&&InstanceId=' + InstanceId + '&&FromDealer=' + FromDealer,
                refresh: true
            });
        } else {
            top.createTab({
                id: 'M_TRANSFER_DISTRIBUTION_NEW',
                title: '分销出库新增',
                url: 'Revolution/Pages/Transfer/TransferDistributionListInfo.aspx?IsNew=true',
                refresh: true
            });
        }
    }


    var setLayout = function () {
    }

    return that;
}();
