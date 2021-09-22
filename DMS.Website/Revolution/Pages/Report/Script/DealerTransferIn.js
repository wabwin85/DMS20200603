var DealerTransferIn = {};

DealerTransferIn = function () {
    var that = {};

    var business = 'Report.DealerTransferIn';

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
                $('#QryTransferDate').FrameDatePickerRange({
                    value: model.QryTransferDate
                });

                
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnExportTransferIn').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportTransferIn();
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
                    field: "ToDMA_ChineseName", title: "经销商名称", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ToDMA_EnglishName", title: "经销商英文名称", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ToDMA_SAP_Code", title: "ERPCode", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "ERPCode" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PRH_PONumber", title: "借货入库单号", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "借货入库单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PRH_SAPShipmentID", title: "对应的借货出库单号", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "对应的借货出库单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PRH_ReceiptDate", title: "接收日期", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "接收日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "FromDMA_ChineseName", title: "借出经销商名称", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "借出经销商名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "FromDMA_EnglishName", title: "借出经销商英文名称", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "借出经销商英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "FromDMA_SAP_Code", title: "借出经销商ERPCode", width: 140,
                    headerAttributes: { "class": "text-center text-bold", "title": "借出经销商ERPCode" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "WHM_Name", title: "接收库", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "接收库" },
                    attributes: { "class": "table-td-cell" }
                },
                //{
                //    field: "CFN_Property1", title: "产品级别", width: 110,
                //    headerAttributes: { "class": "text-center text-bold", "title": "产品级别" },
                //    attributes: { "class": "table-td-cell" }
                //},
                {
                    field: "CFN_CustomerFaceNbr", title: "产品编号", width: 110,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_ChineseName", title: "产品中文名称", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_EnglishName", title: "产品英文名称", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LTM_LotNumber", title: "批号", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QRCode", title: "二维码", width: 140,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LTM_ExpiredDate", title: "产品有效期", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PRL_ReceiptQty", title: "借入数量", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "借入数量" },
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


    that.ExportTransferIn = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'TransferInExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'ExportType', 'ExportTransferIn');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryBrand', data.QryBrand.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryTransferDateStart', data.QryTransferDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryTransferDateEnd', data.QryTransferDate.EndDate);
        startDownload(urlExport, 'TransferInExportByDealer');
    }
    var setLayout = function () {
    }

    return that;
}();
