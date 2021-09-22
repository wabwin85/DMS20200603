var CfnnotorderInfo = {};

CfnnotorderInfo = function () {
    var that = {};

    var business = 'Order.CfnnotorderInfo';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstBuArr = "";
    var LstStatusArr = "";
    var LstTypeArr = "";
    var LstDealerArr = "";

    that.Init = function () {
        var data = {};
        $("#QryCFN").val(Common.GetUrlParam('Cfn'))
        data.QryCFN = Common.GetUrlParam('Cfn');
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                //经销商
                if (model.hidDealerId != "" || model.hidDealerId != null) {
                    $.each(model.LstDealer, function (index, val) {
                        if (model.hidDealerId === val.Id)
                            model.QryDealer = { Key: val.Id, Value: val.ChineseShortName };
                    })
                }
                $('#QryDealer').FrameDropdownList({
                    dataSource: model.LstDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'none',
                    readonly: model.cbDealerDisabled,
                    value: model.QryDealer
                });

                //产品型号
                $('#QryCFN').FrameTextBox({
                    value: model.QryCFN
                });

                //********************************************按钮控制
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                //*******************************************************************************
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
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var fields = {
        SubmitDate: { type: "string", format: "{0:yyyy-MM-dd}" },
    };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 15);

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "Title", title: "标题", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "标题" }
                },
                {
                    field: "Messing", title: "信息描述", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "信息描述" }
                },
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

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    openInfo(data.Id, data.Type, data.TransferNumber);
                });

                $("#RstResultList").find("i[name='print']").on('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    openPrintPage(data.Id);
                })
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();
