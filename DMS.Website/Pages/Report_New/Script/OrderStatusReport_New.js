var OrderStatusReport_New = {};

OrderStatusReport_New = function () {
    var that = {};

    var business = 'Report.OrderStatusReport_New';

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

                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'ProductLineID',
                    dataValue: 'ProductLineName',
                    selectType: 'all',
                    value: model.QryProductLine
                });

                $('#QryApplyDate').FrameDatePickerRange({
                    value: model.QryApplyDate
                }); 

                $('#QryIsInclude').FrameSwitch({
                    value: model.QryIsInclude
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

    //订单状态报表
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'StartDate', data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'EndDate', data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'IsInclude', data.QryIsInclude);

        FrameUtil.StartDownload({
            url: urlExport,
            cookie: 'OrderStatusReport_NewExport',
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
                    field: "ATTRIBUTE_NAME", title: "产品线", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "ChineseName", title: "经销商名称", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "SAPCode", title: "经销商ERP Account", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商ERP Account" }
                },
                {
                    field: "year", title: "年度", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "年度" }
                },
                {
                    field: "month", title: "月度", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "月度" }
                },
                {
                    field: "OrderNo", title: "订单编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单编号" }
                },
                {
                    field: "OrderType", title: "订单类型", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单类型" }
                },
                {
                    field: "OrderStatus", title: "订单状态", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单状态" }
                },
                {
                    field: "CustomerFaceNbr", title: "产品编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" }
                },
                {
                    field: "LotNumber", title: "批号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" }
                },
                {
                    field: "QRCode", title: "二维码", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "POD_RequiredQty", title: "订购数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订购数量" }
                },
                {
                    field: "POD_ReceiptQty", title: "已发货数量", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "已发货数量" }
                },
                {
                    field: "ReceiptQty", title: "未发货数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "未发货数量" }
                },
                {
                    field: "POD_CFN_Price", title: "未发货单价", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "未发货单价" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "waitAmount", title: "未发货金额", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "未发货金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "SubmitDate", title: "订单日期", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单日期" }
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
