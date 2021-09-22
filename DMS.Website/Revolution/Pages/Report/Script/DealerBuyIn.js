var DealerBuyIn = {};

DealerBuyIn = function () {
    var that = {};

    var business = 'Report.DealerBuyIn';

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
                $('#QryOrderNo').FrameTextBox({
                    value: model.QryOrderNo
                });
                $('#QryDeliveryNo').FrameTextBox({
                    value: model.QryDeliveryNo
                });
                //品牌
                $('#QryDealerType').FrameDropdownList({
                    dataSource: model.LstDealerType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryDealerType

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
                    value: model.QryDealer
                });
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnExportDealerBuyIn').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportDealerBuyIn();
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
                    field: "DMA_ChineseName", title: "经销商名称", width: 250,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DMA_EnglishName", title: "经销商英文名称", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DMA_SAP_Code", title: "ERPCode", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "ERPCode" },
                    attributes: { "class": "table-td-cell" }
                },               
                {
                    field: "PRH_PurchaseOrderNbr", title: "原始订单号", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "原始订单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OrderType", title: "订单类型", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "POH_SubmitDate", title: "订单提交日期", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单提交日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PRH_SAPShipmentID", title: "发货单号", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "发货单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PRH_TypeName", title: "收货类型", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "收货类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "IDENTITY_NAME", title: "操作人", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "操作人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PRH_PONumber", title: "收货单单号", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "收货单单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PRH_SAPShipmentDate", title: "发货日期", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "发货日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Year", title: "年度", width: 60,
                    headerAttributes: { "class": "text-center text-bold", "title": "年度" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Month", title: "月度", width: 60,
                    headerAttributes: { "class": "text-center text-bold", "title": "月度" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                //{
                //    field: "CFN_Property1", title: "产品等级", width: 110,
                //    headerAttributes: { "class": "text-center text-bold", "title": "产品等级" },
                //    attributes: { "class": "table-td-cell" }
                //},
                {
                    field: "CFN_CustomerFaceNbr", title: "产品编号", width: 110,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_ChineseName", title: "产品中文名", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_EnglishName", title: "产品英文名", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LTM_LotNumber", title: "产品批号", width: 110,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QRCode", title: "二维码", width: 140,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LTM_ExpiredDate", title: "产品有效期", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PRL_ReceiptQty", title: "发货数量", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "发货数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Price", title: "价格", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "价格" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount", title: "金额", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "InvoiceList", title: "系统发票号", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "系统发票号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "InvoiceAmount", title: "系统发票金额", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "系统发票金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PRH_StatusName", title: "是否接收", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "是否接收" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RFU_CurRegNo", title: "注册证编号-1", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-1" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RFU_CurManuName", title: "生产企业(注册证-1)", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业(注册证-1)" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RFU_LastRegNo", title: "注册证编号-2", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-2" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RFU_LastManuName", title: "生产企业(注册证-2)", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业(注册证-2)" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_Level1Code", title: "Level1 Code", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "Level1 Code" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_Level1Desc", title: "Level1 Desc", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "Level1 Desc" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_Level2Code", title: "Level2 Code", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "Level2 Code" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_Level2Desc", title: "Level2 Desc", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "Level2 Desc" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_Level3Code", title: "Level3 Code", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "Level3 Code" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_Level3Desc", title: "Level3 Desc", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "Level3 Desc" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_Level4Code", title: "Level4 Code", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "Level4 Code" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_Level4Desc", title: "Level4 Desc", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "Level4 Desc" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_Level5Code", title: "Level5 Code", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "Level5 Code" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN_Level5Desc", title: "Level5 Desc", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "Level5 Desc" },
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


    that.ExportDealerBuyIn = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerBuyInExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'ExportType', 'ExportDealerBuyIn');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryBrand', data.QryBrand.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryOrderDateStart', data.QryOrderDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryOrderDateEnd', data.QryOrderDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryShipmentDateStart', data.QryShipmentDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryShipmentDateEnd', data.QryShipmentDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryCFN', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryLotNumber', data.QryLotNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealer', data.QryDealer.Key); 
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerType', data.QryDealerType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDeliveryNo', data.QryDeliveryNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryOrderNo', data.QryOrderNo);
        startDownload(urlExport, 'DealerBuyInExportByDealer');
    }
    var setLayout = function () {
    }

    return that;
}();
