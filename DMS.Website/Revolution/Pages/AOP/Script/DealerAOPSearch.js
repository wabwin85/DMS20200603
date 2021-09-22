var DealerAOPSearch = {};

DealerAOPSearch = function () {
    var that = {};

    var business = 'AOP.DealerAOPSearch';

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
                
                //产品线
                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductline,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryProductLine
                });
                //经销商
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
                if (model.DisableDealer) {
                    $('#QryDealer').FrameDropdownList('disable');
                }
                //市场类型
                $('#QryMarketType').FrameDropdownList({
                    dataSource: model.LstMarketType,
                    dataKey: 'MarketTypeId',
                    dataValue: 'MarketTypeName',
                    selectType: 'select',
                    value: model.QryMarketType
                });
                //年份
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

                $('#BtnExport').FrameButton({
                    text: '导出授权',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
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
                    field: "DealerName", title: "经销商名称", width: 250, 
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "BrandName", title: "品牌", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell" }

                },
                {
                    field: "ProductLineName", title: "产品线", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubBUName", title: "产品分类", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "MarketType", title: "市场类型", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "市场类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Year", title: "年份", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "年份" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_1", title: "一月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "一月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_2", title: "二月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "二月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_3", title: "三月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "三月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_4", title: "四月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "四月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_5", title: "五月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "五月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_6", title: "六月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "六月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_7", title: "七月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "七月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_8", title: "八月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "八月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_9", title: "九月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "九月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_10", title: "十月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "十月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_11", title: "十一月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "十一月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_12", title: "十二月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "十二月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount_Y", title: "合计", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "合计" },
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

    //导出授权
    that.Export = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerAOPSearchExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'MarketType', data.QryMarketType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Year', data.QryYear);
        startDownload(urlExport, 'DealerAOPSearchExport');//下载名称
    }

    var setLayout = function () {
    }

    return that;
}();
