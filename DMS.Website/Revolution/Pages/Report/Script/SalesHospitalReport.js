var SalesHospitalReport = {};

SalesHospitalReport = function () {
    var that = {};

    var business = 'Report.SalesHospitalReport';

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
                    onChange: that.ChangeBrand

                });
                $('#QryProductLine').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: ''
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnExportsalesHosRpt').FrameButton({
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
                    field: "IDENTITY_NAME", title: "销售人员", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售人员" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "attribute_name", title: "产品线", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Region", title: "销售人员所属销售区域", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售人员所属销售区域" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_HospitalName", title: "负责医院名称", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "负责医院名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_Province", title: "医院省份", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院省份" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_City", title: "医院地区", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院地区" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_District", title: "医院县市（区）", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院县市（区）" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_PostalCode", title: "医院邮编", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院邮编" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_Address", title: "医院地址", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院地址" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_Phone", title: "医院电话", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院电话" },
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
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'salesHospitalByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'ExportType', 'salesHospital');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryBrand', data.QryBrand.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        startDownload(urlExport, 'salesHospitalByDealer'); 
    }
    var setLayout = function () {
    }

    return that;
}();
