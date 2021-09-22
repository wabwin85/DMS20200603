var ConsignTransferList = {};

ConsignTransferList = function () {
    var that = {};

    var business = 'Consign.ConsignTransferList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        data.QryQueryType = {};
        data.QryQueryType.Key = 'In';

        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryQueryType').FrameRadio({
                    dataSource: model.LstQueryType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    value: model.QryQueryType,
                    onChange: that.ChangeQueryType
                });
                that.ChangeQueryType();
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                $('#QryContractNo').FrameTextBox({
                    value: model.QryContractNo
                });
                $('#QryStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryStatus
                });
                $('#QryDealer').FrameTextBox({
                    value: model.QryDealer
                });
                $('#QryUpn').FrameTextBox({
                    value: model.QryUpn
                });

                if (model.IsCanApply) {
                    $('#BtnNew').FrameButton({
                        text: '新增',
                        icon: 'plus',
                        onClick: function () {
                            openInfo();
                        }
                    });
                    $('#BtnImport').FrameButton({
                        text: '导入',
                        icon: 'server',
                        onClick: function () {
                            Import();
                        }
                    });

                } else {
                    $('#BtnNew').remove();
                }
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

    that.ChangeQueryType = function () {
        var type = $('#QryQueryType').FrameRadio('getValue');
        $('.condition').hide();
        $('.condition-' + type.Key).css('display', '');
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
                    locked: true, title: "查看", width: "40px",
                    headerAttributes: { "class": "text-center text-bold" },
                    template: "<i class='fa fa-fw fa-list view' style='font-size: 14px; cursor: pointer;'></i>",
                    attributes: { "class": "text-center" }
                },
                {
                    field: "TransferNo", title: "合同编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同编号" }
                },
                {
                    field: "TransferType", title: "类型", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "类型" }
                },
                {
                    field: "ProductLine", title: "BU", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Bu" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" }
                },
                {
                    field: "BrandName", title: "品牌", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" }

                },
                {
                    field: "DealerOutName", title: "移出经销商", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "移出经销商" }
                },
                {
                    field: "DealerInName", title: "移入经销商", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "移入经销商" }
                },
                {
                    field: "TransferStatus", title: "状态", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "状态" }
                },
                {
                    field: "ApplyUser", title: "申请人", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请人" }
                },
                {
                    field: "ApplyDate", title: "申请日期", width: '140px',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请日期" }
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

                    openInfo(data.TransferId, data.TransferNo, data.TransferType);
                });
            }
        });
    }

    var Import = function () {
        top.createTab({
            id: 'M_IN_IMPORTCONSIGN',
            title: '寄售转移 - 批量导入',
            url: 'Revolution/Pages/Consign/ConsignmentTransferInit.aspx'
        });
    }

    var openInfo = function (TransferId, TransferNo, TransferType) {
        if (TransferId) {
            if (TransferType == '移入') {
                top.createTab({
                    id: 'M_IN_' + TransferId,
                    title: '寄售转移 - ' + TransferNo,
                    url: 'Revolution/Pages/Consign/ConsignTransferInfo.aspx?InstanceId=' + TransferId,
                    refresh: true
                });
            } else {
                top.createTab({
                    id: 'M_OUT_' + TransferId,
                    title: '寄售转移 - ' + TransferNo,
                    url: 'Revolution/Pages/Consign/ConsignTransferConfirm.aspx?InstanceId=' + TransferId,
                    refresh: true
                });
            }
        } else {
            top.createTab({
                id: 'M_CONSIGN_TRANSFER_NEW',
                title: '寄售转移 - 新增',
                url: 'Revolution/Pages/Consign/ConsignTransferInfo.aspx',
                refresh: true
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();
