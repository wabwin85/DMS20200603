var DealerOrderDetail = {};

DealerOrderDetail = function () {
    var that = {};

    var business = 'Report.DealerOrderDetail';

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
                    onChange:that.ChangeBrand

                });
                $('#QryProductLine').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: ''
                });
                $('#QryOrderDate').FrameDatePickerRange({
                    value: model.QryOrderDate
                });
                //产品型号
                $('#QryCFN').FrameTextBox({
                    value: model.QryCFN
                });
                
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnExportOrderDetail').FrameButton({
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
                    field: "ChineseName", title: "经销商名称", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SAPCode", title: "ERPCode", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "ERPCode" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OrderNo", title: "订单编号", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Order_Type", title: "订单类型", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "IDENTITY_NAME", title: "操作人", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "操作人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubmitDate", title: "订单日期", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RDD", title: "期望到货日期", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "期望到货日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OrderStatus", title: "订单状态", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ConfirmDate", title: "订单处理时间", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单处理时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Remark", title: "订单备注", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单备注" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "InvoiceComment", title: "发票备注", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "发票备注" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ArticleNumber", title: "产品编号", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFNChineseName", title: "产品中文名称", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFNEnglishName", title: "产品英文名称", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "POD_LotNumber", title: "批号", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "POD_QRCode", title: "二维码", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RequiredQty", title: "订购数量", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "订购数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount", title: "订单金额小计", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单金额小计" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ReceiptQty", title: "已发货数量", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "已发货数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ReceiptAmount", title: "已发货金额小计", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "已发货金额小计" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "POD_CurRegNo", title: "注册证编号-1", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-1" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "POD_CurManuName", title: "生产企业(注册证-1)", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业(注册证-1)" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "POD_LastRegNo", title: "注册证编号-2", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-2" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "POD_LastManuName", title: "生产企业(注册证-2)", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业(注册证-2)" },
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

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'OrderDetailExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'ExportType', 'ExportOrderDetail');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryBrand', data.QryBrand.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryOrderDateStart', data.QryOrderDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryOrderDateEnd', data.QryOrderDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryCFN', data.QryCFN);
        startDownload(urlExport, 'OrderDetailExportByDealer');
    }
    var setLayout = function () {
    }

    return that;
}();
