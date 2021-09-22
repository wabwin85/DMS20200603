var DealerBuyInReport_New = {};

DealerBuyInReport_New = function () {
    var that = {};

    var business = 'Report.DealerBuyInReport_New';

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

                $('#QrySubmitDate').FrameDatePickerRange({
                    value: model.QrySubmitDate
                });

                $('#QryProductModel').FrameTextBox({
                    value: model.QryProductModel
                });

                $('#QryBatchNo').FrameTextBox({
                    value: model.QryBatchNo
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

    //经销商收货数据报表
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'StartDate', data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'EndDate', data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitStartDate', data.QrySubmitDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitEndDate', data.QrySubmitDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductModel', data.QryProductModel);
        urlExport = Common.UpdateUrlParams(urlExport, 'BatchNo', data.QryBatchNo);

        FrameUtil.StartDownload({
            url: urlExport,
            cookie: 'DealerBuyInReport_NewExport',
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
                    field: "DMA_ChineseName", title: "经销商名称", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "DMA_EnglishName", title: "经销商英文名称", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商英文名称" }
                },
                {
                    field: "DMA_SAP_Code", title: "经销商ERP Account", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商ERP Account" }
                },
                {
                    field: "PRH_PurchaseOrderNbr", title: "原始订单号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "原始订单号" }
                },
                {
                    field: "POH_SubmitDate", title: "订单提交日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单提交日期" }
                },
                {
                    field: "PRH_SAPShipmentID", title: "运单号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "运单号" }
                },
                {
                    field: "PRH_TypeName", title: "收货类型", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "收货类型" }
                },
                {
                    field: "IDENTITY_NAME", title: "操作人", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "操作人" }
                },
                {
                    field: "PRH_PONumber", title: "收货单单号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "收货单单号" }
                },
                {
                    field: "PRH_SAPShipmentDate", title: "发货日期", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "发货日期" }
                },
                {
                    field: "Year", title: "年度", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "年度" }
                },
                {
                    field: "Month", title: "月度", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "月度" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "CFN_Property1", title: "产品等级", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品等级" }
                },
                {
                    field: "CFN_CustomerFaceNbr", title: "产品编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" }
                },
                {
                    field: "CFN_ChineseName", title: "产品中文名", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" }
                },
                {
                    field: "CFN_EnglishName", title: "产品英文名", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" }
                },
                {
                    field: "LTM_LotNumber", title: "产品批号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品批号" }
                },
                {
                    field: "QRCode", title: "二维码", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "LTM_ExpiredDate", title: "产品有效期", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" }
                },
                {
                    field: "PRL_ReceiptQty", title: "发货数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "发货数量" }
                },
                {
                    field: "Price", title: "价格", width: '100px',encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "价格" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "Amount", title: "金额", width: '100px',encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "InvoiceList", title: "系统发票号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "系统发票号" }
                },
                {
                    field: "InvoiceAmount", title: "系统发票金额", width: '100px',encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "系统发票金额" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "PRH_StatusName", title: "是否接收", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "是否接收" }
                },
                {
                    field: "RFU_CurRegNo", title: "注册证编号-1", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-1" }
                },
                {
                    field: "RFU_CurManuName", title: "生产企业（注册证-1）", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业（注册证-1）" }
                },
                {
                    field: "RFU_LastRegNo", title: "注册证编号-2", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-2" }
                },
                {
                    field: "RFU_LastManuName", title: "生产企业（注册证-2）", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业（注册证-2）" }
                },
                {
                    field: "LTM_Type", title: "产品生产日期", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品生产日期" }
                },
                {
                    field: "CFN_Level1Code", title: "Level1 Code", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level1 Code" }
                },
                {
                    field: "CFN_Level1Desc", title: "Level1 Desc", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level1 Desc" }
                },
                {
                    field: "CFN_Level2Code", title: "Level2 Code", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level2 Code" }
                },
                {
                    field: "CFN_Level2Desc", title: "Level2 Desc", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level2 Desc" }
                },
                {
                    field: "CFN_Level3Code", title: "Level3 Code", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level3 Code" }
                },
                {
                    field: "CFN_Level3Desc", title: "Level3 Desc", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level3 Desc" }
                },
                {
                    field: "CFN_Level4Code", title: "Level4 Code", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level4 Code" }
                },
                {
                    field: "CFN_Level4Desc", title: "Level4 Desc", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level4 Desc" }
                },
                {
                    field: "CFN_Level5Code", title: "Level5 Code", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level5 Code" }
                },
                {
                    field: "CFN_Level5Desc", title: "Level5 Desc", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level5 Desc" }
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
