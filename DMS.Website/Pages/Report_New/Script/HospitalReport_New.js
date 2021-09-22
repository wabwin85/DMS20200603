var HospitalReport_New = {};

HospitalReport_New = function () {
    var that = {};

    var business = 'Report.HospitalReport_New';

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

    //医院库数据报表
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;

        FrameUtil.StartDownload({
            url: urlExport,
            cookie: 'HospitalReport_NewExport',
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
                    field: "HOS_HospitalName", title: "医院中文名称", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院中文名称" }
                },
                {
                    field: "HOS_HospitalShortName", title: "医院别名", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院别名" }
                },
                {
                    field: "HOS_Key_Account", title: "医院编号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院编号" }
                },
                {
                    field: "HOS_Grade", title: "医院等级", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院等级" }
                },
                {
                    field: "HOS_Province", title: "省份", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "省份" }
                },
                {
                    field: "HOS_City", title: "地区", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "地区" }
                },
                {
                    field: "HOS_District", title: "县市（区）", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "县市（区）" }
                },
                {
                    field: "HOS_PublicEmail", title: "邮编", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "邮编" }
                },
                {
                    field: "HOS_Address", title: "地址", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "地址" }
                },
                {
                    field: "HOS_Phone", title: "医院电话", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院电话" }
                },
                {
                    field: "HOS_Director", title: "院长姓名", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "院长姓名" }
                },
                {
                    field: "HOS_DirectorContact", title: "院长联系方式", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "院长联系方式" }
                },
                {
                    field: "HOS_ChiefEquipment", title: "设备科长姓名", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "设备科长姓名" }
                },
                {
                    field: "HOS_ChiefEquipmentContact", title: "设备科长联系方式", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "设备科长联系方式" }
                },
                {
                    field: "HOS_Website", title: "医院网址", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院网址" }
                },
                {
                    field: "IDENTITY_NAME", title: "修改人", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "修改人" }
                },
                {
                    field: "HOS_LastModifiedDate", title: "修改时间", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "修改时间" }
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
