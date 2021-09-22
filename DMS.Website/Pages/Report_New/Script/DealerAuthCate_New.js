var DealerAuthCate_New = {};

DealerAuthCate_New = function () {
    var that = {};

    var business = 'Report.DealerAuthCate_New';

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

    //经销商授权报表
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);

        FrameUtil.StartDownload({
            url: urlExport,
            cookie: 'DealerAuthCate_NewExport',
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
                    field: "dma_chinesename", title: "经销商名称", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "ProductLine", title: "产品线", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "Auth_Cate", title: "授权分类/产品线", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "授权分类/产品线" }
                },
                {
                    field: "HOS_HospitalName", title: "授权医院", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "授权医院" }
                },
                {
                    field: "HOS_Key_Account", title: "授权医院编号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "授权医院编号" }
                },
                {
                    field: "HOS_Province", title: "省份", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "省份" }
                },
                {
                    field: "HOS_City", title: "地区", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "地区" }
                },
                {
                    field: "HOS_District", title: "县市（区）", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "县市（区）" }
                },
                {
                    field: "HOS_PublicEmail", title: "邮编", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "邮编" }
                },
                {
                    field: "HOS_Address", title: "医院地址", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院地址" }
                },
                {
                    field: "HOS_Phone", title: "医院电话", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院电话" }
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
