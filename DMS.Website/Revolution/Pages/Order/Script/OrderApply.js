var OrderApply = {};

OrderApply = function () {
    var that = {};

    var business = 'Order.OrderApply';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstBuArr = "";
    var LstStatusArr = "";
    var LstTypeArr = "";
    var LstDealerArr = "";

    that.Init = function () {
        var data = {};

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstBuArr = model.LstBu;
                LstStatusArr = model.LstStatus;
                LstTypeArr = model.LstType;
                LstDealerArr = model.LstDealer;
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
                if (model.hidInitDealerId != "" || model.hidInitDealerId != null) {
                    $.each(model.LstDealer, function (index, val) {
                        if (model.hidInitDealerId === val.Id)
                            model.QryDealer = { Key: val.Id, Value: val.ChineseShortName };
                    })
                }
                //$('#QryDealer').FrameDropdownList({
                //    dataSource: model.LstDealer,
                //    dataKey: 'Id',
                //    dataValue: 'ChineseShortName',
                //    selectType: 'none',
                //    readonly: model.cbDealerDisabled,
                //    value: model.QryDealer
                //});
                var DealerSource = [];
                if (model.QryDealer != null && model.QryDealer != "") {
                    DealerSource.push({ DealerId: model.QryDealer.Key, DealerName: model.QryDealer.Value });
                }

                //$('#QryDealer').DmsDealerFilter({
                //    dataSource: DealerSource,
                //    delegateBusiness: business,
                //    dataKey: 'DealerId',
                //    dataValue: 'DealerName',
                //    selectType: 'none',
                //    filter: 'contains',
                //    serferFilter: true,
                //    value: model.QryDealer,
                //});

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
                if (model.cbDealerDisabled)
                    $("#QryDealer").DmsDealerFilter('disable');


                $('#QryApplyDate').FrameDatePickerRange({
                    value: model.QryApplyDate
                });
                //状态
                $('#QryOrderStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryType
                });

                //产品型号
                $('#QryCFN').FrameTextBox({
                    value: model.QryCFN
                });
                //订单号
                $('#QryOrderNo').FrameTextBox({
                    value: model.QryLotNumber
                });

                //订单类型
                $('#QryOrderType').FrameDropdownList({
                    dataSource: model.LstType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryType
                });
                //备注
                $('#QryRemark').FrameTextBox({
                    value: model.QryRemark
                });

                //********************************************按钮控制
                //导出明细
                $('#BtnExpDetail').FrameButton({
                    text: '导出明细',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportDetail();
                    }
                });

                if (model.IsDealer) {
                    if (!model.InsertDisabled) {
                        $('#BtnNew').FrameButton({
                            text: '新增',
                            icon: 'plus',
                            onClick: function () {
                                openInfo();
                            }
                        });
                    }
                    else
                        $('#BtnNew').remove();
                    if (!model.btnImportDisabled) {
                        $('#BtnImport').FrameButton({
                            text: 'Excel导入',
                            icon: 'file',
                            onClick: function () {
                                that.Import();
                            }
                        });
                    }
                    else {
                        $('#BtnImport').remove();
                    }
                }
                else {
                    $('#BtnNew').remove();
                    $('#BtnImport').remove();
                }
                if (!model.btnStockpriceDisabled) {
                    $('#BtnStockprice').FrameButton({
                        text: '库存及价格查询',
                        icon: 'search',
                        onClick: function () {
                            that.StockpriceQuery();
                        }
                    });
                }
                else {
                    $('#BtnStockprice').remove();
                }
                if (model.SerchVisibile) {
                    $('#BtnQuery').FrameButton({
                        text: '查询',
                        icon: 'search',
                        onClick: function () {
                            that.Query();
                        }
                    });
                }
                else {
                    $('#BtnQuery').remove();
                }
                //*******************************************************************************
                //$("#RstResultList").data("kendoGrid").setOptions({
                //    dataSource: model.RstResultList
                //});
                createResultList();

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
        SubmitDate: { type: "date", format: "{0:yyyy-MM-dd}" },
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
                    field: "DmaId", title: "经销商", width: 'auto', template: function (gridrow) {
                        var Name = "";
                        if (LstDealerArr.length > 0) {
                            if (gridrow.DmaId != "") {
                                $.each(LstDealerArr, function () {
                                    if (this.Id == gridrow.DmaId) {
                                        Name = this.ChineseShortName;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        } else {
                            return Name;
                        }
                    },
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
                    field: "OrderNo", title: "订单号", width: '130px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalQty", title: "订单总数量", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单总数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalAmount", title: "订单总金额", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalReceiptQty", title: "已发总数量", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "已发总数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubmitDate", title: "提交日期", width: '100px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "提交日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OrderType", title: "订单类型", width: '80px', template: function (gridrow) {
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
                        } else {
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "订单类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OrderStatus", title: "订单状态", width: '80px', template: function (gridrow) {
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
                        } else {
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "订单状态" },
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
                    template: "#if (1==1) {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "打印", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if (1==1) {#<i class='fa fa-print' style='font-size: 14px; cursor: pointer;' name='print'></i>#}#",
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

                    openInfo(data.Id, data.OrderType, data.OrderNo);
                });

                $("#RstResultList").find("i[name='print']").on('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    openPrintPage(data.Id);
                })
            }
        });
    }
    //导出明细
    that.ExportDetail = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'OrderApplyExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLineBumId', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerId', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderStatus', data.QryOrderStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderType', data.QryOrderType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitDateStart', data.QryApplyDate.StartDate == null ? "" : data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitDateEnd', data.QryApplyDate.EndDate == null ? "" : data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderNo', data.QryOrderNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'Cfn', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'Remark', data.QryRemark);
        startDownload(urlExport, 'OrderApplyExport');//下载名称
    };

    var openPrintPage = function (id) {
        window.open("OrderPrint.aspx?OrderID=" + id, 'newwindow',
        'status=no,width=850px,height=550px,scrollbars=yes,resizable=yes,location=no,top=50,left=100');
    }
    //excel导入
    that.Import = function () {
        top.createTab({
            id: 'M2_OrderApplyForT2_OIT2PageImport',
            title: '二级经销商订单申请-Excel导入',
            url: 'Revolution/Pages/Order/OrderImport.aspx'
        });
    };
    //库存及价格查询
    that.StockpriceQuery = function () {
        top.createTab({
            id: 'M2_OrderApplyForT2_QIQueryPricePage',
            title: '库存及价格查询',
            url: 'Revolution/Pages/Inventory/QueryInventoryPrice.aspx'
        });
    };
    //新增
    var openInfo = function (InstanceId, Type, OrderNo) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '二级经销商订单申请 -' + ValidateDataType(OrderNo),
                url: 'Revolution/Pages/Order/OrderApplyInfo.aspx?InstanceId=' + InstanceId + '&&IsNew=false',
                refresh: true
            });
        } else {
            top.createTab({
                id: 'M_ORDER_ORDERAPPLY_NEW',
                title: '二级经销商订单申请 - 新增',
                url: 'Revolution/Pages/Order/OrderApplyInfo.aspx?IsNew=true',
                refresh: true
            });
        }
    }


    var setLayout = function () {
    }

    return that;
}();
