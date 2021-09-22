var ConsignmentApplyHeaderList = {};

ConsignmentApplyHeaderList = function () {
    var that = {};

    var business = 'Consignment.ConsignmentApplyHeaderList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#DealerListType").val(model.DealerListType);
                //产品线
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                //经销商
                //$('#QryDealer').FrameDropdownList({
                //    dataSource: model.LstDealer,
                //    dataKey: 'Id',
                //    dataValue: 'Name',
                //    selectType: 'all',
                //    filter:'contains',
                //    readonly: model.IsDealer ? true : false,
                //    value: model.QryDealer
                //});

                if (model.DealerType != "" || model.DealerType != null) {
                    $.each(model.LstDealer, function (index, val) {
                        if (model.DealerType === val.Id)
                            model.QryDealer = { Key: val.Id, Value: val.ChineseShortName };
                    })
                }
                $('#QryDealer').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    parameters: { "IsAll": $("#DealerListType").val() },//查询类型
                    business: 'Util.DealerScreenFilter',
                    method: 'DealerFilter',
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'none',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealer,
                });
                if (model.DealerDisabled)
                    $("#QryDealer").DmsDealerFilter('disable');
                //申请单状态
                $('#QryStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryStatus
                });
                //提交开始日期
                var starDP = $("#QryBeginDate").kendoDatePicker({
                    value: model.QryBeginDate,
                    format: "yyyy-MM-dd",
                    depth: "month",
                    start: "month",
                }).data("kendoDatePicker");
                // starDP.element[0].disabled = true;
                //提交结束日期
                var endDP = $("#QryEndDate").kendoDatePicker({
                    value: model.QryEndDate,
                    dateInput: false,
                    format: "yyyy-MM-dd",
                    depth: "month",
                    start: "month",
                }).data("kendoDatePicker");
                // endDP.element[0].disabled = true;
                //申请单类型
                $('#QryType').FrameDropdownList({
                    dataSource: model.LstType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryType
                });
                //产品型号
                $('#QryProductType').FrameTextBox({
                    value: model.QryProductType
                });
                //申请单号
                $('#QryOrderNo').FrameTextBox({
                    value: model.QryOrderNo
                });
                //延期申请状态
                $('#QryDelayStatus').FrameDropdownList({
                    dataSource: model.LstDelayStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryDelayStatus
                });

                //按钮权限控制
                if (model.InsertVisible) {
                    $('#BtnNew').FrameButton({
                        text: '添加',
                        icon: 'plus',
                        onClick: function () {
                            that.openInfo();
                        }
                    });
                }
                else {
                    $('#BtnNew').remove();
                }

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });


                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
                createResultList();
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
    var params = function () {
        var parm = FrameUtil.GetModel();
        parm.QryBeginDate = $("#QryBeginDate").val();
        parm.QryEndDate = $("#QryEndDate").val();
        return parm;
    };
    var fields = { SubmitDate: { type: "date", format: "{0: yyyy-MM-dd}" } };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 15, params);

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "DealerName", title: "经销商", width: '160px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "BrandName", title: "品牌", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DmaSapCode", title: "ERP编号", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "ERP编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OrderNo", title: "申请单号", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalQty", title: "总数量", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "总数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubmitDate", type: "date", title: "提交日期", width: '100px', format: "{0: yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "提交日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShipToAddress", title: "收货地址", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "收货地址" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Remark", title: "备注", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "备注" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OrderTypeName", title: "申请单类型", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请单类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OrderStatusName", title: "申请单状态", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请单状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DelayOrderStatusName", title: "延期状态", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "延期状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DelayDelayTime", title: "可延期次数", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "可延期次数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "明细", width: "50px",
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
                refresh: true,
                pageSizes: false,
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

                    that.openInfo(data.Id, data.OrderStatus, data.OrderNo, data.DmaId);
                });
            }
        });
    }

    that.openInfo = function (InstanceId, Status, No, DmaId) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '经销商寄售 -' + ValidateDataType(No),
                url: 'Revolution/Pages/Consignment/ConsignmentApplyHeaderInfo.aspx?InstanceId=' + InstanceId + '&&Status=' + Status + '&&DealerId=' + DmaId,
                refresh: true
            });
        } else {
            top.createTab({
                id: 'M_CONSIGNMENT_CONSIGNMENTAPPLY_NEW',
                title: '经销商寄售 - 新增',
                url: 'Revolution/Pages/Consignment/ConsignmentApplyHeaderInfo.aspx?IsNew=true&&DealerId=' + DmaId,
                refresh: true
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();
