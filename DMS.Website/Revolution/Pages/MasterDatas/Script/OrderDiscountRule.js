var OrderDiscountRule = {};

OrderDiscountRule = function () {
    var that = {};

    var business = 'MasterDatas.OrderDiscountRule';
    var pickedList = [];
    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = FrameUtil.GetModel();
        createResultList();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryBu').FrameDropdownList({
                    dataSource: model.ListBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryBu
                });
                $('#QryUPN').FrameTextBox({
                    value: model.QryUPN
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
                $('#BtnImport').FrameButton({
                    text: '导入',
                    icon: 'upload',
                    onClick: function () {
                        that.openInfo();
                    }
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

    var fields = { BeginDate: { type: "date" }, EndDate: { type: "date" }, CreateDate: { type: "date" } };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    field: "SubCompanyName", title: "分子公司", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                },
                {
                    field: "BrandName", title: "品牌", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                },
                {
                    field: "ProductLineName", title: "产品线", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                },
                {
                    field: "SAPCode", title: "经销商编号", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商编号" }
                },
                {
                    field: "DealerName", title: "经销商名称", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "Upn", title: "产品编号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" }
                },
                {
                    field: "Lot", title: "批号", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" }
                },
                {
                    field: "LeftValue", title: "时间区间(>=天)", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "时间区间(>=天)" }
                },
                {
                    field: "RightValue", title: "时间区间(<天)", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "时间区间(<天)" }
                },
                {
                    field: "DiscountValue", title: "折扣率", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "折扣率" }
                },
                {
                    field: "BeginDate", title: "开始时间", width: '100px',format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "开始时间" }
                },
                {
                    field: "EndDate", title: "终止时间", width: '100px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "终止时间" }
                },
                {
                    field: "CreatUser", title: "提交人", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "提交人" }
                },
                {
                    field: "CreateDate", title: "提交时间", width: '100px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "提交时间" }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                
            },
            page: function (e) {
            }
        });
    }


    that.openInfo = function () {
        top.createTab({
            id: 'M_规则导入',
            title: '规则导入',
            url: 'Revolution/Pages/MasterDatas/OrderDiscountRuleImport.aspx'
        });
    }
    var setLayout = function () {
    }

    return that;
}();
