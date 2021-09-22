var ProductOperationLogReport_New = {};

ProductOperationLogReport_New = function () {
    var that = {};

    var business = 'Report.ProductOperationLogReport_New';

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

                $('#QryProductModel').FrameTextBox({
                    value: model.QryProductModel
                });

                $('#QryBatchNo').FrameTextBox({
                    value: model.QryBatchNo
                });
               
                $('#QryOperDate').FrameDatePickerRange({
                    value: model.QryOperDate
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

    //进销存操作日志报表  
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductModel', data.QryProductModel);
        urlExport = Common.UpdateUrlParams(urlExport, 'BatchNo', data.QryBatchNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'StartDate', data.QryOperDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'EndDate', data.QryOperDate.EndDate);

        FrameUtil.StartDownload({
            url: urlExport,
            cookie: 'ProductOperationLogReport_NewExport',
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
                    field: "DealerCnName", title: "经销商中文名称", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商中文名称" }
                },
                {
                    field: "DealerEngName", title: "经销商英文名称", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商英文名称" }
                },
                {
                    field: "SapCode", title: "经销商ERP Account", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商ERP Account" }
                },
                {
                    field: "ONumber", title: "单据号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单据号" }
                },
                {
                    field: "SubmitDate", title: "单据提交时间", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单据提交时间" }
                },
                {
                    field: "SubmitUserName", title: "提交人", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "提交人" }
                },
                {
                    field: "OType", title: "单据类型", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单据类型" }
                },
                {
                    field: "OStatus", title: "单据状态", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单据状态" }
                },
                {
                    field: "FromWarehouse", title: "从仓库", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "从仓库" }
                },
                {
                    field: "ToWarehouse", title: "到仓库", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "到仓库" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "CFN_Property1", title: "产品等级", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品等级" }
                },
                {
                    field: "CfnNumber", title: "产品编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" }
                },
                {
                    field: "CfnCnName", title: "产品中文名", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" }
                },
                {
                    field: "CfnEngName", title: "产品英文名", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" }
                },
                {
                    field: "LTM_LotNumber", title: "产品批号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品批号" }
                },
                {
                    field: "QRCode", title: "二维码", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "ExpiredDate", title: "产品有效期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" }
                },
                {
                    field: "LotQty", title: "产品数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品数量" }
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
