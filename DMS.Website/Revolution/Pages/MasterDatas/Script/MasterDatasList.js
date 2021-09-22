var MasterDatasList = {};
MasterDatasList = function () {
    var that = {};

    var business = 'MasterDatas.MasterDatasList'

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
                //年月
                $('#QryApplyDate').FrameDatePicker({
                    value: model.QryApplyDate
                });
                $('#BtnNew').FrameButton({
                    text: '新增',
                    icon: 'file',
                    onClick: function () {
                        openInfo();
                    }
                });
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
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
    var createResultList = function () { }
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 800,
            columns: [

                {
                    field: "Year", title: "年月", width: '130px',
                    headerAttributes: { "class": "text-center text-bold", "title": "年月" }
                },
                {
                    field: "Day", title: "上月用量截至日期", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "上月用量截至日期" }
                },
                {
                    field: "Date10", title: "是否上报当月用量", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "上月用量截至日期" }
                },
                {
                    field: "CreateDate", title: "维护时间", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "维护时间" }
                },
                {
                    field: "CreateUser", title: "维护人", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "维护人" }
                },
                {
                    locked: true, title: "维护", width: "60px",
                    headerAttributes: { "class": "text-center text-bold" },
                    template: "<i class='fa fa-fw fa-list view' style='font-size: 14px; cursor: pointer;'></i>",
                    attributes: { "class": "text-center" }
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
                var grid = e.sender;

                $("#RstResultList").find(".view").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    openInfo(data.Year);
                });
            }
        });
    }
    var openInfo = function (Year) {
        url = Common.AppVirtualPath + 'Revolution/Pages/MasterDatas/MasterDataInfo.aspx?Year=' + Year;
        FrameWindow.OpenWindow({
            target: 'top',
            title: '销售单用量日期维护',
            url: url,
            width: $(window).width() * 0.4,
            height: $(window).height() * 0.6,
            actions: ["Close"],
            callback: function (flowList) {
                var data = FrameUtil.GetModel();
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
        });
    }
    var setLayout = function () {
    }

    return that;
}();