var HospitalAOPSearch = {};

HospitalAOPSearch = function () {
    var that = {};

    var business = 'AOP.HospitalAOPSearch';

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
                    value: model.QryProductLine,
                    onChange: that.ChangeProductLine
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
                //产品分类
                $('#QrySubProduct').FrameDropdownList({
                    dataSource: model.LstSubProduct,
                    dataKey: 'Code',
                    dataValue: 'Namecn',
                    selectType: 'select',
                    value: model.QrySubProduct,
                    onChange: that.ChangeSubProduct
                });
                //指标产品分类
                $('#QryQtSubProduct').FrameDropdownList({
                    dataSource: model.LstQtSubProduct,
                    dataKey: 'CQ_Code',
                    dataValue: 'CQ_NameCN',
                    selectType: 'select',
                    value: model.QryQtSubProduct
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

    that.ChangeProductLine = function () {

        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeProductLine',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                
                //产品分类
                $('#QrySubProduct').FrameDropdownList({
                    dataSource: model.LstSubProduct,
                    dataKey: 'Code',
                    dataValue: 'Namecn',
                    selectType: 'select',
                    value: model.QrySubProduct,
                    onChange: that.ChangeSubProduct
                });
                //指标产品分类
                $('#QryQtSubProduct').FrameDropdownList({
                    dataSource: model.LstQtSubProduct,
                    dataKey: 'CQ_Code',
                    dataValue: 'CQ_NameCN',
                    selectType: 'select',
                    value: model.QryQtSubProduct
                });
                FrameWindow.HideLoading();
            }
        });
        
    }

    that.ChangeSubProduct = function () {
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeSubProduct',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                //指标产品分类
                $('#QryQtSubProduct').FrameDropdownList({
                    dataSource: model.LstQtSubProduct,
                    dataKey: 'CQ_Code',
                    dataValue: 'CQ_NameCN',
                    selectType: 'select',
                    value: model.QryQtSubProduct
                });
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
                    field: "CC_NameCN", title: "合同分类", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "合同分类" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PCTName", title: "指标分类", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "指标分类" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_HospitalName", title: "医院名称", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Year", title: "年份", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "年份" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month1", title: "一月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "一月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month2", title: "二月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "二月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month3", title: "三月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "三月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month4", title: "四月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "四月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month5", title: "五月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "五月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month6", title: "六月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "六月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month7", title: "七月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "七月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month8", title: "八月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "八月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month9", title: "九月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "九月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month10", title: "十月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "十月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month11", title: "十一月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "十一月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month12", title: "十二月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "十二月" },
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
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'HospitalAOPSearchExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubProduct', data.QrySubProduct.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QtSubProduct', data.QryQtSubProduct.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Year', data.QryYear);
        startDownload(urlExport, 'HospitalAOPSearchExport');//下载名称
    }

    var setLayout = function () {
    }

    return that;
}();
