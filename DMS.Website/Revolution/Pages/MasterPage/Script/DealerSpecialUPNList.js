var DealerSpecialUPNList = {};

DealerSpecialUPNList = function () {
    var that = {};

    var business = 'MasterPage.DealerSpecialUPNList';

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

                $('#IptDealer').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.IptDealer
                   
                });

                $('#QryDealerType').DmsDealerFilter({
                    dataSource: model.LstDealerType,
                    dataKey: 'DICT_KEY',
                    dataValue: 'DICT_KEY',
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

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "ChineseShortName", title: "经销商中文名称", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商中文名称" }
                },
                {
                    field: "DealerType", title: "经销商类型", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商类型" }
                },
                {
                    field: "Address", title: "地址", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "地址" }
                },
                {
                    field: "PostalCode", title: "邮编", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "邮编" }
                },
                {
                    field: "Phone", title: "电话", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "电弧" }
                },
                {
                    field: "Fax", title: "传真", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "传真" }
                },
                {
                    title: "维护", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
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

                    openInfo(data.Id);
                });
            }
        });
    }

    var openInfo = function (InstanceId) {
        
        top.createTab({
            id: 'M_' + InstanceId,
            title: '组套UPN',
            url: 'Revolution/Pages/MasterPage/DealerSpecialUPNInfo.aspx?InstanceId=' + InstanceId
        });
    }

    var setLayout = function () {
    }

    return that;
}();
