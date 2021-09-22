var DealerOrderDetailReport_New = {};

DealerOrderDetailReport_New = function () {
    var that = {};

    var business = 'Report.DealerOrderDetailReport_New';

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

                $('#QryProductModel').FrameTextBox({
                    value: model.QryProductModel
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

    //经销商订单明细报表 
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'StartDate', data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'EndDate', data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductModel', data.QryProductModel);

        FrameUtil.StartDownload({
            url: urlExport,
            cookie: 'DealerOrderDetailReport_NewExport',
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
                    field: "ChineseName", title: "经销商名称", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "SAPCode", title: "经销商ERP Account", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商ERP Account" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "OrderNo", title: "订单编号", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单编号" }
                },
                {
                    field: "Order_Type", title: "订单类型", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单类型" }
                },
                {
                    field: "IDENTITY_NAME", title: "操作人", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "操作人" }
                },
                {
                    field: "SubmitDate", title: "订单日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单日期" }
                },
                {
                    field: "RDD", title: "期望到货日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "期望到货日期" }
                },
                {
                    field: "OrderStatus", title: "订单状态", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单状态" }
                },
                {
                    field: "ConfirmDate", title: "订单处理时间", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单处理时间" }
                },
                {
                    field: "Remark", title: "订单备注", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单备注" }
                },
                {
                    field: "InvoiceComment", title: "发票备注", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "发票备注" }
                },
                {
                    field: "ArticleNumber", title: "产品编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" }
                },
                {
                    field: "CFNChineseName", title: "产品中文名称", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名称" }
                },
                {
                    field: "CFNEnglishName", title: "产品英文名称", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名称" }
                },
                {
                    field: "POD_LotNumber", title: "批号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" }
                },
                {
                    field: "POD_QRCode", title: "二维码", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "RequiredQty", title: "订购数量", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订购数量" }
                },
                {
                    field: "Amount", title: "订单金额小计", width: '150px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单金额小计" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "ReceiptQty", title: "已发货数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "已发货数量" }
                },
                {
                    field: "ReceiptAmount", title: "已发货金额小计", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "已发货金额小计" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "POD_CurRegNo", title: "注册证编号-1", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-1" }
                },
                {
                    field: "POD_CurManuName", title: "生产企业（注册证-1）", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业（注册证-1）" }
                },
                {
                    field: "POD_LastRegNo", title: "注册证编号-2", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-2" }
                },
                {
                    field: "POD_LastManuName", title: "生产企业（注册证-2）", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业（注册证-2）" }
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
