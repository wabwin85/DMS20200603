var AOPDealerReport = {};

AOPDealerReport = function () {
    var that = {};

    var business = 'Report.AOPDealerReport';

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
                $('#QryYear').FrameTextBox({
                    value: model.QryYear
                });
                

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnExportAOPDealerRpt').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportAOPDealerRpt();
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
                    field: "ATTRIBUTE_NAME", title: "产品线", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DMA_ChineseName", title: "经销商", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Year", title: "年度", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "年度" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_1", title: "1月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "1月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_2", title: "2月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "2月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_3", title: "3月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "3月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_4", title: "4月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "4月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_5", title: "5月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "5月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_6", title: "6月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "6月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_7", title: "7月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "7月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_8", title: "8月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "8月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_9", title: "9月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "9月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_10", title: "10月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "10月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_11", title: "11月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "11月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_12", title: "12月", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "12月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AOPD_Amount_Y", title: "全年", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "全年" },
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


    that.ExportAOPDealerRpt = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'AOPDealerRptExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'ExportType', 'ExportAOPDealerRpt');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryBrand', data.QryBrand.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryYear', data.QryYear);
        startDownload(urlExport, 'AOPDealerRptExportByDealer');
    }
    var setLayout = function () {
    }

    return that;
}();
