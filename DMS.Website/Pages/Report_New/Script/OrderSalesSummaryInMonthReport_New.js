var OrderSalesSummaryInMonthReport_New = {};

OrderSalesSummaryInMonthReport_New = function () {
    var that = {};

    var business = 'Report.OrderSalesSummaryInMonthReport_New';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                var currentDate = new Date();
                var yearDataSource = [];

                var startYear = 2014;
                var endYear = currentDate.getFullYear();

                for (var i = startYear; i <= endYear; i++) {
                    yearDataSource.push({ 'Key': i.toString(), 'Value': i.toString() });
                }

                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'ProductLineID',
                    dataValue: 'ProductLineName',
                    selectType: 'all',
                    value: model.QryProductLine
                });

                $('#QryYear').FrameDropdownList({
                    dataSource: yearDataSource,
                    dataKey: 'Key',
                    dataValue: 'Value',
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
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });

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
        var data = FrameUtil.GetModel();
        console.log(data);

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Query',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

                FrameWindow.HideLoading();
            }
        });
    }

    //经销商销售报表
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Year', data.QryYear.Key);

        FrameUtil.StartDownload({
            url: urlExport,
            cookie: 'OrderSalesSummaryInMonthReport_NewExport',
            business: business
        });
    }

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "ProductLineName", title: "产品线", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "ChineseName", title: "经销商中文名称", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商中文名称" }
                },
                {
                    field: "SAPCode", title: "经销商ERP Account", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商ERP Account" }
                },
                {
                    field: "ParentDealerName", title: "上级经销商", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "上级经销商" }
                },
                {
                    field: "Type", title: "订单类型", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单类型" }
                },
                {
                    field: "SAPShipmentDate", title: "发货日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "发货日期" }
                },
                {
                    field: "Years", title: "年度", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "年度" }
                },
                {
                    field: "OneAmount", title: "一月订单金额", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "一月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "TwoAmount", title: "二月订单金额", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "二月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "ThreeAmount", title: "三月订单金额", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "三月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "FourAmount", title: "四月订单金额", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "四月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "FiveAmount", title: "五月订单金额", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "五月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "SixAmount", title: "六月订单金额", width: '150px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "六月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "SevenAmount", title: "七月订单金额", width: '150px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "七月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "EightAmount", title: "八月订单金额", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "八月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "NineAmount", title: "九月订单金额", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "九月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "TenAmount", title: "十月订单金额", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "十月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "ElevenAmount", title: "十一月订单金额", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "十一月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "TwelveAmount", title: "十二月订单金额", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "十二月订单金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "Amount", title: "金额汇总", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "金额汇总" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
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
            }
        });
    }


    var setLayout = function () {
    }

    return that;
}();
