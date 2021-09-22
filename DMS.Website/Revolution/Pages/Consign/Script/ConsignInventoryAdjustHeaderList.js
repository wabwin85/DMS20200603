var ConsignInventoryAdjustHeaderList = {};

ConsignInventoryAdjustHeaderList = function () {
    var that = {};

    var business = 'Consign.ConsignInventoryAdjustHeaderList';

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


                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'ProductLineID',
                    dataValue: 'ProductLineName',
                    selectType: 'all',
                    value: model.QryProductLine
                });

                $('#QryDealer').FrameTextBox({
                    value: model.QryDealer
                });
                $('#QryType').FrameDropdownList({
                    dataSource: model.LstType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryType
                });

                $('#QryApplyDate').FrameDatePickerRange({
                    value: model.QryApplyDate
                });

                $('#QryApplyNo').FrameTextBox({
                    value: model.QryApplyNo
                });
                $('#QryST').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryST
                });


                $('#QryProductModel').FrameTextBox({
                    value: model.QryProductModel
                });

                $('#QryProductBatchNo').FrameTextBox({
                    value: model.QryProductBatchNo
                });
                $('#QryTwoCode').FrameTextBox({
                    value: model.QryTwoCode
                });

                $('#QryBillNo').FrameTextBox({
                    value: model.QryBillNo
                });
                //$('#QryRemark').FrameTextBox({
                //    value: model.QryRemark
                //});

                if (model.IsDealer == true) {
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
                    field: "DMA_ChineseName", title: "经销商", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "AdjustNumber", title: "申请单号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请单号" }
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
                    field: "Type", title: "类型", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同名称" }
                },
                {
                    field: "TotalQyt", title: "总数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "总数量" }
                },
                //{
                //    field: "TotalQyt", title: "总金额", width: '100px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "总金额" }
                //},
                {
                    field: "ApprovalDate", title: "申请日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请日期" }
                },

                {
                    field: "CreateUserName", title: "提交人", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "提交人" }
                },
                {
                    field: "Status", title: "状态", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "状态" }
                },
                //{
                //    field: "Status", title: "关联单据", width: '100px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "关联单据" }
                //},
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

                    openInfo(data.Id, data.Status, data.AdjustNumber);
                });
            }
        });
    }

    var openInfo = function (InstanceId, Status, AdjustNumber) {
        if (InstanceId) {
            top.createTab({
                id: 'M',
                title: '寄售买断 - ' + AdjustNumber,
                url: 'Revolution/Pages/Consign/ConsignInventoryAdjustHeaderInfo.aspx?InstanceId=' + InstanceId + '&&Status=' + Status,
                refresh: true
            });
        } else {
            top.createTab({
                id: 'M_CONSIGN_CONTRACT_NEW',
                title: '寄售买断 - 新增',
                url: 'Revolution/Pages/Consign/ConsignInventoryAdjustHeaderInfo.aspx',
                refresh: true
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();
