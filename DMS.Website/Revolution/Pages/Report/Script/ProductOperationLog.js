var ProductOperationLog = {};

ProductOperationLog = function () {
    var that = {};

    var business = 'Report.ProductOperationLog';

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
                $('#QryShipmentDate').FrameDatePickerRange({
                    value: model.QryShipmentDate
                });
                //产品型号
                $('#QryCFN').FrameTextBox({
                    value: model.QryCFN
                });
                $('#QryLotNumber').FrameTextBox({
                    value: model.QryLotNumber
                });
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnExportProductOperationLog').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportProductOperationLog();
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
                    field: "DealerCnName", title: "经销商名称", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DealerEngName", title: "经销商英文名称", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SapCode", title: "ERPCode", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "ERPCode" },
                    attributes: { "class": "table-td-cell" }
                },               
                {
                    field: "ONumber", title: "单据号", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "单据号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubmitDate", title: "单据提交日期", width: 140,
                    headerAttributes: { "class": "text-center text-bold", "title": "单据提交日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubmitUserName", title: "提交人", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "提交人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OType", title: "单据类型", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "单据类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OStatus", title: "单据状态", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "单据状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "FromWarehouse", title: "从仓库", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "从仓库" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ToWarehouse", title: "到仓库", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "到仓库" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                //{
                //    field: "CFN_Property1", title: "产品等级", width: 110,
                //    headerAttributes: { "class": "text-center text-bold", "title": "产品等级" },
                //    attributes: { "class": "table-td-cell" }
                //},
                {
                    field: "CfnNumber", title: "产品编号", width: 110,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CfnCnName", title: "产品中文名", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CfnEngName", title: "产品英文名", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LTM_LotNumber", title: "产品批号", width: 110,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QRCode", title: "二维码", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ExpiredDate", title: "产品有效期", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotQty", title: "产品数量", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品数量" },
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


    that.ExportProductOperationLog = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'ProductOperationLogExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'ExportType', 'ExportProductOperationLog');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryBrand', data.QryBrand.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryCFN', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryLotNumber', data.QryLotNumber);
        startDownload(urlExport, 'ProductOperationLogExportByDealer');
    }
    var setLayout = function () {
    }

    return that;
}();
