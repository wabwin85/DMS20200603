var InventoryImport = {};

InventoryImport = function () {
    var that = {};

    var business = 'Inventory.InventoryImport';

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
                $('#QryDealer').DmsDealerFilter({
                    dataSource: model.LstDealerName,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealer
                });
                $('#QryImportDate').FrameTextBox({
                    value: model.QryImportDate
                });

                if (model.IsDealer == true) {

                    if (model.DealerType == "T1" || model.DealerType =="T2") {
                        $('#QryDealer').DmsDealerFilter('disable');
                    }

                    $('#BtnImport').FrameButton({
                        text: 'Excel导入',
                        icon: 'file-excel-o',
                        onClick: function () {
                            top.createTab({
                                id: 'M_InventoryInit_New',
                                title: '导入',
                                url: 'Revolution/Pages/Inventory/InventoryInit.aspx',
                                refresh: true
                            });
                        }
                    });
                }
                $('#BtnQuery').FrameButton({
                    text: '查找',
                    icon: 'search',
                    onClick: function () {
                        that.GetTotalCount();
                        that.Query();
                    }
                });

                if (model.QryInvCount) {
                    $("#spTotalCount").text(model.QryInvCount);
                }
                if (model.QryInvQty) {
                    $("#spTotalQty").text(model.QryInvQty);
                }

                //$("#RstResultList").data("kendoGrid").setOptions({
                //    dataSource: model.RstResultList
                //});

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
            grid.dataSource.page(0);
            return;
        }
    }

    that.GetTotalCount = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'GetTotalCount',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.QryInvCount) {
                    $("#spTotalCount").text(model.QryInvCount);
                }
                if (model.QryInvQty) {
                    $("#spTotalQty").text(model.QryInvQty);
                }

                FrameWindow.HideLoading();
            }
        });
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 20);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 415,
            columns: [
                {
                    field: "DealerSapCode", title: "经销商编号", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DealerName", title: "经销商", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Warehouse", title: "仓库名称", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "WarehouseType", title: "仓库类型", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ArticleNumber", title: "产品型号(UPN)", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号(UPN)" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotNumber", title: "产品批号", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ExpiredDate", title: "产品有效期", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Qty", title: "数量", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UploadDate", title: "导入时间", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "导入时间" },
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
                var grid = e.sender;

            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();