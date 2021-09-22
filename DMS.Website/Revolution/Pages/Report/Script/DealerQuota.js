var DealerQuota = {};

DealerQuota = function () {
    var that = {};

    var business = 'Report.DealerQuota';

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
                $('#QryContractNo').FrameTextBox({
                    value: model.QryContractNo
                });
                $('#QryDealerName').FrameTextBox({
                    value: model.QryDealerName
                });
                $('#QryYear').FrameTextBox({
                    value: model.QryYear
                });
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnExportDealerQuota').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportDealerQuota();
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
                    field: "ProductLineName", title: "产品线", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EName", title: "提交人", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "提交人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ContractNo", title: "合同编号", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "合同编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ContractStatusCN", title: "合同状态", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "合同状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DivisionName", title: "DivisionName", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "DivisionName" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubBUName", title: "SubBUName", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "SubBUName" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DealerName", title: "经销商名称", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SAPCode", title: "ERPCode", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "ERPCode" },
                    attributes: { "class": "table-td-cell" }
                },               
                {
                    field: "DealerType", title: "类型", width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ParentDealerName", title: "上级经销商名称", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "上级经销商名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ParentSAPCode", title: "上级经销商ERPCode", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "上级经销商ERPCode" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AgreementBegin", title: "合同开始日期", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "合同开始日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AgreementEnd", title: "合同结束日期", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "合同结束日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Year", title: "年份", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "年份" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount1", title: "1月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "1月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount2", title: "2月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "2月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount3", title: "3月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "3月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount4", title: "4月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "4月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount5", title: "5月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "5月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount6", title: "6月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "6月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount7", title: "7月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "7月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount8", title: "8月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "8月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount9", title: "9月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "9月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount10", title: "10月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "10月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount11", title: "11月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "11月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Amount12", title: "12月", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "12月" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AmountY", title: "全年", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "全年" },
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


    that.ExportDealerQuota = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerQuotaExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'ExportType', 'ExportDealerQuota');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryBrand', data.QryBrand.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryContractNo', data.QryContractNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerName', data.QryDealerName);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryYear', data.QryYear);
        startDownload(urlExport, 'DealerQuotaExportByDealer');
    }
    var setLayout = function () {
    }

    return that;
}();
