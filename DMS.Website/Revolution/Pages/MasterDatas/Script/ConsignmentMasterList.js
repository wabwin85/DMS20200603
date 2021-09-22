var ConsignmentMasterList = {};

ConsignmentMasterList = function () {
    var that = {};

    var business = 'MasterDatas.ConsignmentMasterList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstBuArr = "";
    var LstStatusArr = "";
    var LstTypeArr = "";

    that.Init = function () {
        var data = {};
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstBuArr = model.LstBu;
                LstStatusArr = model.LstStatus;
                LstTypeArr = model.LstType;
                //产品线
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                //经销商
                $('#QryDealer').FrameDropdownList({
                    dataSource: model.LstDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseName',
                    selectType: 'all',
                    filter:'contains',
                    //readonly: model.IsDealer ? true : false,
                    value: model.QryDealer
                });
                //申请单状态
                $('#QryStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryStatus
                });
                $('#QryApplyDate').FrameDatePickerRange({
                    value: model.QryContractDate
                });
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

                $('#QryConsignmentName').FrameTextBox({
                    value: model.QryConsignmentName
                });
                //按钮权限
                if (model.InsertEnable) {
                    $('#BtnNew').FrameButton({
                        text: '新增短期寄售规则',
                        icon: 'plus',
                        onClick: function () {
                            openInfo();
                        }
                    });
                } else {
                    $('#BtnNew').remove();
                }
                if (model.SearchEnabled) {
                    $('#BtnQuery').FrameButton({
                        text: '查询',
                        icon: 'search',
                        onClick: function () {
                            that.Query();
                        }
                    });
                } else {
                    $('#BtnQuery').remove();
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
                    field: "OrderNo", title: "规则单据号", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "规则单据号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductLineId", title: "产品线", width: '80px', template: function (gridrow) {
                        var Name = "";
                        if (LstBuArr.length > 0) {
                            if (gridrow.ProductLineId != "") {
                                $.each(LstBuArr, function () {
                                    if (this.ProductLineID == gridrow.Key) {
                                        Name = this.Value;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OrderType", title: "近效期规则", width: '100px', template: function (gridrow) {
                        var Name = "";
                        if (LstTypeArr.length > 0) {
                            if (gridrow.OrderType != "") {
                                $.each(LstTypeArr, function () {
                                    if (this.Key == gridrow.OrderType) {
                                        Name = this.Value;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "近效期规则" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "BrandName", title: "品牌", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "ConsignmentName", title: "寄售规则名称", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "寄售规则名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ConsignmentDay", title: "寄售天数", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "寄售天数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DelayTime", title: "可延期次数", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "可延期次数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "StartDate", title: "开始时间", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "开始时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EndDate", title: "结束时间", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "结束时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OrderStatus", title: "单据状态", width: '80px', template: function (gridrow) {
                        var Name = "";
                        if (LstStatusArr.length > 0) {
                            if (gridrow.OrderStatus != "") {
                                $.each(LstStatusArr, function () {
                                    if (this.Key == gridrow.OrderStatus) {
                                        Name = this.Value;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "单据状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Remark", title: "备注", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "备注" },
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

                    openInfo(data.Id, data.OrderStatus, data.OrderNo);
                });
            }
        });
    }

    var openInfo = function (InstanceId, Status, OrderNo) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '短期寄售规则维护 -' + ValidateDataType(OrderNo),
                url: 'Revolution/Pages/MasterDatas/ConsignmentMasterListInfo.aspx?InstanceId=' + InstanceId + '&&Status=' + Status
            });
        } else {
            top.createTab({
                id: 'M_MASTERDATAS_CONSIGNMENTMASTERLIST_NEW',
                title: '短期寄售规则维护 - 新增',
                url: 'Revolution/Pages/MasterDatas/ConsignmentMasterListInfo.aspx'
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();
