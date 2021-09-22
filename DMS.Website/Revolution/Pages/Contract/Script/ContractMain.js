var ContractMain = {};

ContractMain = function () {
    var that = {};

    var business = 'Contract.ContractMain';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstDealerTypeArr = "";

    that.Init = function () {
        var data = {};
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstDealerTypeArr = model.LstDealerType;
                //经销商名称
                $('#QryDealer').DmsDealerFilter({
                    dataSource: model.LstDealer,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealer
                });
                //经销商类型
                $('#QryDealerType').FrameDropdownList({
                    dataSource: model.LstDealerType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryDealerType
                });
                
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                if (model.DisableSelect)
                {
                    $('#QryDealer').DmsDealerFilter('disable');
                }

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
                    field: "Id", title: "经销商ID", width: 150, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商ID" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseShortName", title: "经销商中文名称", width: 230,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EnglishName", title: "经销商英文名称", width: 230, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DealerType", title: "经销商类型", width: 150, template: function (gridrow) {
                        var Name = "";
                        if (LstDealerTypeArr.length > 0) {
                            if (gridrow.DealerType != "") {
                                $.each(LstDealerTypeArr, function () {
                                    if (this.Key == gridrow.DealerType) {
                                        Name = this.Value;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Address", title: "地址", width: 300,
                    headerAttributes: { "class": "text-center text-bold", "title": "地址" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Province", title: "省份", width: 100, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "省份" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "City", title: "城市", width: 100, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "城市" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PostalCode", title: "邮编", width: 90, 
                    headerAttributes: { "class": "text-center text-bold", "title": "邮编" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Phone", title: "电话", width: 100, 
                    headerAttributes: { "class": "text-center text-bold", "title": "电话" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Fax", title: "传真", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "传真" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "披露", width: 50, hidden: true,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "披露", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='look'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
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

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    that.ShowDetails('edit', data.Id);
                });

                $("#RstResultList").find("i[name='look']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    that.ShowDetails('look', data.Id);
                });

            }
        });
    }

    that.ShowDetails = function (Type, Id) {
        if (Id) {
            top.createTab({
                id: 'M_' + Id,
                title: '第三方披露表',
                url: Type == 'look' ? 'Revolution/Pages/Contract/ContractThirdPartyV2.aspx?DealerId=' + Id : 'Revolution/Pages/Contract/ContractThirdParty.aspx?DealerId=' + Id
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();
