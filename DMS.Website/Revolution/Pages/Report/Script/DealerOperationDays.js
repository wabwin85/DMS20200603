var DealerOperationDays = {};

DealerOperationDays = function () {
    var that = {};

    var business = 'Report.DealerOperationDays';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                //品牌
                $('#QryBrand').FrameDropdownList({
                    dataSource: model.LstBrand,
                    dataKey: 'Id',
                    dataValue: 'ATTRIBUTE_NAME',
                    selectType: 'select',
                    value: model.QryBrand,
                    onChange: that.ChangeBrand

                });
                $('#QryProductLine').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: ''
                });
                $('#QryUseDate').FrameDatePickerRange({
                    value: model.QryUseDate
                });
                //产品型号
                $('#QryWorkDay').FrameTextBox({
                    value: model.QryWorkDay
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnExportDodRpt').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportDodRpt();
                    }
                });

                createResultList();

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });

    }

    that.ChangeBrand = function () {
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeBrand',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //产品线
                if (model.LstProductline == null || model.LstProductline.length <= 0) {
                    $('#QryProductLine').FrameDropdownList({
                        dataSource: [],
                        dataKey: 'Key',
                        dataValue: 'Value',
                        selectType: 'select',
                        value: ''
                    });
                }
                else {
                    $('#QryProductLine').FrameDropdownList({
                        dataSource: model.LstProductline,
                        dataKey: 'Key',
                        dataValue: 'Value',
                        selectType: 'select',
                        value: model.QryProductLine
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    }
    //主信息查询
    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 15);

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [

                {
                    field: "SubCompanyName", title: "分子公司", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "BrandName", title: "品牌", width: 60,
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell" }

                },
                {
                    field: "DMA_ChineseName", title: "经销商名称", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" },
                    attributes: { "class": "table-td-cell" }
                },
                //{
                //    field: "ProductLineName", title: "产品线", width: 150,
                //    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                //    attributes: { "class": "table-td-cell" }
                //},
                {
                    field: "POReceiptInUseDays", title: "收货操作天数", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "收货操作天数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "POReceiptRate", title: "收货操作频率", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "收货操作频率" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShipmentInUseDays", title: "销售操作天数", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售操作天数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShipmentRate", title: "销售操作频率", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售操作频率" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "InventoryAdjustInUseDays", title: "库存调整天数", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "库存调整天数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "InventoryAdjustRate", title: "库存调整频率", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "库存调整频率" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TransferInUseDays", title: "移库操作天数", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "移库操作天数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TransferRate", title: "移库操作频率", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "移库操作频率" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RentInUseDays", title: "借货出库操作天数", width: 130,
                    headerAttributes: { "class": "text-center text-bold", "title": "借货出库操作天数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RentRate", title: "借货出库操作频率", width: 130,
                    headerAttributes: { "class": "text-center text-bold", "title": "借货出库操作频率" },
                    attributes: { "class": "table-td-cell" }
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


    that.ExportDodRpt = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DodRptExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'ExportType', 'ExportDodRpt');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryBrand', data.QryBrand.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryUseDateStart', data.QryUseDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryUseDateEnd', data.QryUseDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryWorkDay', data.QryWorkDay);
        startDownload(urlExport, 'DodRptExportByDealer');
    }
    var setLayout = function () {
    }

    return that;
}();
