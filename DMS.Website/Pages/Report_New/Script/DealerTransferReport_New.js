var DealerTransferReport_New = {};

DealerTransferReport_New = function () {
    var that = {};

    var business = 'Report.DealerTransferReport_New';

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

    //经销商移库报表
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'StartDate', data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'EndDate', data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductModel', data.QryProductModel);
        urlExport = Common.UpdateUrlParams(urlExport, 'BatchNo', data.QryBatchNo);

        FrameUtil.StartDownload({
            url: urlExport,
            cookie: 'DealerTransferReport_NewExport',
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
                    field: "DMA_ChineseName", title: "经销商名称", width: '250px',
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
                    field: "TRN_TransferNumber", title: "移库单号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "移库单号" }
                },
                {
                    field: "IDENTITY_NAME", title: "操作人", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "操作人" }
                },
                {
                    field: "TRN_TransferDate", title: "移库日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "移库日期" }
                },
                {
                    field: "FromWHName", title: "移出仓库", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "移出仓库" }
                },
                {
                    field: "ToWHName", title: "移入仓库", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "移入仓库" }
                },
                {
                    field: "CFN_Property1", title: "产品级别", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品级别" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
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
                    field: "QRCode", title: "二维码", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "LTM_ExpiredDate", title: "产品有效期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" }
                },
                {
                    field: "TLT_TransferLotQty", title: "移动数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "移动数量" }
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
