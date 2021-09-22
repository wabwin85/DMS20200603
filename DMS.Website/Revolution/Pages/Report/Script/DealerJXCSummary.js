var DealerJXCSummary = {};

DealerJXCSummary = function () {
    var that = {};

    var business = 'Report.DealerJXCSummary';

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
                //$('#QryDealerJXSummaryYear').FrameTextBox({
                //    value: model.QryOrderDate,
                //    p
                //});
                $('#QryDealerJXSummaryYear').FrameDatePicker({
                    //min: nextDate,
                    format: "yyyy",
                    start: "decade",
                    depth: "decade",
                    value: ''
                });
                //$('#QryDealerJXSummaryYear_Control').onChange()

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnExportSummaryRpt').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportOrderDetail();
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
                    field: "RDS_Attribute_Name", title: "产品线", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RDS_DMA_ChineseName", title: "经销商中文名称", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RDS_DMA_EnglishName", title: "经销商英文名称", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RDS_DMA_SAP_Code", title: "ERPCode", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "ERPCode" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DMA_SystemStartDate", title: "经销商开帐日期", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商开帐日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order01", title: "（1月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（1月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder01", title: "（1月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（1月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales01", title: "（1月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（1月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation01", title: "（1月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（1月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order02", title: "（2月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（2月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder02", title: "（2月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（2月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales02", title: "（2月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（2月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation02", title: "（2月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（2月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order03", title: "（3月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（3月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder03", title: "（3月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（3月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales03", title: "（3月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（3月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation03", title: "（3月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（3月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order04", title: "（4月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（4月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder04", title: "（4月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（4月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales04", title: "（4月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（4月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation04", title: "（4月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（4月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order05", title: "（5月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（5月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder05", title: "（5月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（5月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales05", title: "（5月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（5月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation05", title: "（5月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（5月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order06", title: "（6月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（6月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder06", title: "（6月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（6月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales06", title: "（6月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（6月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation06", title: "（6月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（6月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order07", title: "（7月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（7月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder07", title: "（7月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（7月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales07", title: "（7月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（7月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation07", title: "（7月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（7月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order08", title: "（8月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（8月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder08", title: "（8月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（8月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales08", title: "（8月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（8月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation08", title: "（8月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（8月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order09", title: "（9月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（9月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder09", title: "（9月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（9月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales09", title: "（9月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（9月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation09", title: "（9月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（9月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order10", title: "（10月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（10月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder10", title: "（10月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（10月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales10", title: "（10月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（10月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation10", title: "（10月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（10月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order11", title: "（11月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（11月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder11", title: "（11月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（11月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales11", title: "（11月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（11月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation11", title: "（11月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（11月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order12", title: "（12月）订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（12月）订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrder12", title: "（12月）发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（12月）发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sales12", title: "（12月）销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（12月）销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Operation12", title: "（12月）报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "（12月）报台总台数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "YOrder", title: "订单总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "YPurchaseOrder", title: "发货总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "发货总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "YSales", title: "销售总金额", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "YOperation", title: "报台总台数", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "报台总台数" },
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


    that.ExportOrderDetail = function () {
        var data = that.GetModel();
        var QryDealerJXSummaryYear = data.QryDealerJXSummaryYear;
        if (data.InventDate = null || data.InventDate == "" || data.InventDate == undefined) {
            var QryDealerJXSummaryYear = "";
        }
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerJXCSumaryExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'ExportType', 'ExportDealerJXCSumary');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryBrand', data.QryBrand.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerJXSummaryYear', QryDealerJXSummaryYear);
        startDownload(urlExport, 'DealerJXCSumaryExportByDealer');
    }
    var setLayout = function () {
    }

    return that;
}();
