var TransferInfoReason = {};

TransferInfoReason = function () {
    var that = {};

    var business = 'Transfer.TransferInfoReason';

    that.Init = function () {
        var data = {};
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

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
        StartDate: { type: "StartDate", format: "{0:yyyy-MM-dd}" }, EndDate: { type: "EndDate", format: "{0:yyyy-MM-dd}" }
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
                    field: "ProductLineName", title: "产品线", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Reason", title: "原因", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "原因" },
                    attributes: { "class": "table-td-cell" }
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

        });
    }



    var setLayout = function () {
    }

    return that;
}();
