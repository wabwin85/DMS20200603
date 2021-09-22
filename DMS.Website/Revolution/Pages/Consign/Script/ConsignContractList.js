var ConsignContractList = {};

ConsignContractList = function () {
    var that = {};

    var business = 'Consign.ConsignContractList';

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
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'ProductLineID',
                    dataValue: 'ProductLineName',
                    selectType: 'all',
                    value: model.QryBu
                });
                $('#QryDealer').FrameTextBox({

                    value: model.QryDealer
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
                $('#QryIsAuto').FrameDropdownList({
                    dataSource: [{ Key: '1', Value: '是' }, { Key: '0', Value: '否' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryIsAuto
                });
                $('#QryDiscountRule').FrameDropdownList({
                    dataSource: [{ Key: '1', Value: '是' }, { Key: '0', Value: '否' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryDiscountRule
                });
                $('#QryHasUpn').FrameTextBox({

                    value: model.QryHasUpn
                });
                $('#QryContractDate').FrameDatePickerRange({
                    value: model.QryContractDate
                });

                if (model.IsDealer == false) {
                    $('#BtnNew').FrameButton({
                        text: '新增',
                        icon: 'plus',
                        onClick: function () {
                            openInfo();
                        }
                    });
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
        //console.log(data);

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

    //大区维护
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Area', data.QryArea);
        urlExport = Common.UpdateUrlParams(urlExport, 'IsActive', data.QryIsActive);

        startDownload({
            url: urlExport,
            cookie: 'AreaListExport',
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
                    field: "BU", title: "BU", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "BU" }
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
                    field: "DMA_ChineseName", title: "经销商", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "No", title: "寄售合同编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "寄售合同编号" }
                },
                {
                    field: "Status", title: "状态", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "状态" }
                },
                {
                    field: "IsKB", title: "是否自动补货", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "是否自动补货" }
                },
                {
                    field: "IsUseDiscount", title: "是否使用有效折扣", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "是否使用有效折扣" }
                },
                {
                    field: "BeginDate", title: "合同起始日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同起始日期" }
                },
                {
                    field: "EndDate", title: "合同结束日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同结束日期" }
                },
                {
                    title: "编辑", width: "50px",
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

                    openInfo(data.CCH_ID, data.Status, data.No);
                });
            }
        });
    }

    var openInfo = function (InstanceId, Status, No) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '寄售合同 -' + No,
                url: 'Revolution/Pages/Consign/ConsignContractInfo.aspx?InstanceId=' + InstanceId + '&&Status=' + Status,
                refresh: true
            });
        } else {
            top.createTab({
                id: 'M_CONSIGN_CONTRACT_NEW',
                title: '寄售合同 - 新增',
                url: 'Revolution/Pages/Consign/ConsignContractInfo.aspx',
                refresh: true
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();
