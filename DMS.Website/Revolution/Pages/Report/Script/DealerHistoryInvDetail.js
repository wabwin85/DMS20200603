var DealerHistoryInvDetail = {};

DealerHistoryInvDetail = function () {
    var that = {};

    var business = 'Report.DealerHistoryInvDetail';

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
                $("#DealerListType").val(model.DealerListType);
                //品牌
                $('#QryBrand').FrameDropdownList({
                    dataSource: model.LstBrand,
                    dataKey: 'Id',
                    dataValue: 'ATTRIBUTE_NAME',
                    selectType: 'select',
                    value: model.QryBrand,
                    onChange: that.ChangeBrand

                });
                $('#QryProductLine').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: ''
                });
                //$('#QryInvDate').FrameDatePickerRange({
                //    value: model.QryInvDate
                //});
                $('#QryInventDate').FrameDatePickerRange({
                    value: model.QryInventDate
                });
                $('#QryDealer').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    parameters: { "IsAll": $("#DealerListType").val() },//查询类型
                    business: 'Util.DealerScreenFilter',
                    method: 'DealerFilter',
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'none',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealer,
                });
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
                $('#BtnExportInvDetailRpt').FrameButton({
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
                    field: "DealerName", title: "经销商名称", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DealerType", title: "经销商类型", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ParentDealer", title: "上级经销商", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "上级经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "WarehouseName", title: "仓库", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "WhmType", title: "仓库类型", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CustomerFaceNbr", title: "产品型号", width: 110,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
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
                    field: "LotNumber", title: "序列号", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QRCode", title: "二维码", width: 140,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ExpiredDateString", title: "有效期", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UnitOfMeasure", title: "单位", width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OnHandQty", title: "库存数量", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "库存数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "INV_BAK_DATE", title: "库存日期", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "库存日期" },
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
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerHistoryInvDetailExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'ExportType', 'DealerHistoryInvDetail');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryBrand', data.QryBrand.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        //urlExport = Common.UpdateUrlParams(urlExport, 'InventDate', time);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryInventDateStart', data.QryInventDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryInventDateEnd', data.QryInventDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryCFN', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryLotNumber', data.QryLotNumber);
        startDownload(urlExport, 'DealerHistoryInvDetailExportByDealer');
    }
    var setLayout = function () {
    }

    return that;
}();
