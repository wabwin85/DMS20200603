var OrderApplyLP = {};

OrderApplyLP = function () {
    var that = {};

    var business = 'Order.OrderApplyLP';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstBuArr = "";
    var LstStatusArr = "";
    var LstTypeArr = "";
    var LstDealerArr = "";
    var LstShipToAddressArr = "";

    that.Init = function () {
        var data = {};

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#DealerListType").val(model.DealerListType);
                $("#hidCorpType").val(model.hidCorpType);
                $("#IsDealer").val(model.IsDealer);
                LstBuArr = model.LstBu;
                LstStatusArr = model.LstStatus;
                LstTypeArr = model.LstType;
                LstDealerArr = model.LstDealer;
                LstShipToAddressArr = model.LstShipToAddress;
                //产品线
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                //经销商
                //dataKey存在差异，故采用两种方式
                if (model.cbDealerDisabled) {
                    if (model.hidInitDealerId != "" || model.hidInitDealerId != null) {
                        $.each(model.LstDealer, function (index, val) {
                            if (model.hidInitDealerId === val.Id)
                                model.QryDealer = { Key: val.Id, Value: val.ChineseShortName };
                        })
                    }
                    $('#QryDealer').FrameDropdownList({
                        dataSource: model.LstDealer,
                        dataKey: 'Id',
                        dataValue: 'ChineseShortName',
                        selectType: 'none',
                        //readonly: model.cbDealerDisabled,
                        value: model.QryDealer
                    });
                    $("#QryDealer").FrameDropdownList('disable');
                }
                else {
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
                }

                //状态
                $('#QryOrderStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryType
                });
                $('#QryApplyDate').FrameDatePickerRange({
                    value: model.QryApplyDate
                });
                //订单类型
                $('#QryOrderType').FrameDropdownList({
                    dataSource: model.LstType,
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

                //备注
                $('#QryRemark').FrameTextBox({
                    value: model.QryRemark
                });

                //按钮权限控制
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
                    else {
                        $("#BtnNew").remove();
                    }
                    if (!model.btnImportDisabled) {
                        $('#BtnImport').FrameButton({
                            text: 'Excel导入',
                            icon: 'file-code-o',
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

                $('#BtnEptLog').FrameButton({
                    text: '导出操作日志',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportLog();
                    }
                });
                $('#BtnExpInvoice').FrameButton({
                    text: '导出发票',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportInvoice();
                    }
                });
                $('#BtnExpDetail').FrameButton({
                    text: '导出明细',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportDetail();
                    }
                });
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
        SubmitDate: { type: "date", format: "{0:yyyy-MM-dd}" }
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
                    field: "DmaId", title: "经销商", width: '80px', template: function (gridrow) {
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
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "DmaSapCode", title: "ERP编号", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "ERP编号" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "BrandName", title: "品牌", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "OrderNo", title: "订单号", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单号" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "TotalQty", title: "订单总数量", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单总数量" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "TotalAmount", title: "订单总金额", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "订单总金额" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "TotalReceiptQty", title: "已发总数量", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "已发总数量" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "SubmitDate", title: "提交日期", width: '90px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "提交日期" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "ShipToAddress", title: "收货地址", width: '80px', template: function (gridrow) {
                        var Name = "";
                        if (LstShipToAddressArr.length > 0) {
                            if (gridrow.ShipToAddress != "") {
                                $.each(LstShipToAddressArr, function () {
                                    if (this.WhCode == gridrow.ShipToAddress) {
                                        Name = this.WhAddress;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        } else {
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "收货地址" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    field: "Remark", title: "备注", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "备注" },
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
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
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
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
                    attributes: { "class": "table-td-cell #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #" }
                },
                {
                    title: "明细", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-file-text-o' style='font-size: 14px; cursor: pointer;' name='file-text-o'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #"
                    }
                },
                {
                    title: "修改", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if(($('\\#hidCorpType').val()== 'HQ' ? false : true) && $('\\#IsDealer').val()){#" +
                               "#if (($('\\#hidCorpType').val() == 'T1')||$('\\#hidCorpType').val() == 'LP'||$('\\#hidCorpType').val() == 'LS') {#" +
                                   "#if('Submitted'==data.OrderStatus){#" +
                                       "#if('Normal'==data.OrderType||'SpecialPrice'==data.OrderType||'Transfer'==data.OrderType||'ClearBorrowManual'==data.OrderType||'PEGoodsReturn'==data.OrderType||'EEGoodsReturn'==data.OrderType||'BOM'==data.OrderType){#" +
                                         "<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>" +
                                        "#}#" +
                                    "#}#" +
                               "#}#" +
                            "#}#",
                    attributes: {
                        "class": "text-center text-bold #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #"
                    }
                },
                {
                    title: "打印", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-print' style='font-size: 14px; cursor: pointer;' name='print'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold #if(data.IsAutoGenClearBorrow >0 &&data.OrderStatus=='Draft'){#list_back#} #"
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
                $("#RstResultList").find("i[name='file-text-o']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    openInfo(data.Id, data.OrderType, data.OrderNo, data.DmaId);
                });

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    openModifyInfo(data.Id, data.OrderType, data.OrderNo, data.DmaId);
                });

                $("#RstResultList").find("i[name='print']").on('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    openPrintPage(data.Id);
                })
            },
            complete: function (e) {
                debugger
                if (record.data.IsAutoGenClearBorrow > 0 && record.data.OrderStatus == '<%=PurchaseOrderStatus.Draft.ToString() %>') {
                    return 'yellow-row';

                }
            },
            edit: function (e) {
                debugger
                if (record.data.IsAutoGenClearBorrow > 0 && record.data.OrderStatus == '<%=PurchaseOrderStatus.Draft.ToString() %>') {
                    return 'yellow-row';

                }
            }

        });

    }

    var openPrintPage = function (id) {
        window.open("OrderPrint.aspx?OrderID=" + id, 'newwindow',
        'status=no,width=850px,height=550px,scrollbars=yes,resizable=yes,location=no,top=50,left=100');
    }

    var openInfo = function (InstanceId, Type, OrderNo, DmaId) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '平台及一级经销商订单申请-' + ValidateDataType(OrderNo),
                url: 'Revolution/Pages/Order/OrderApplyLPInfo.aspx?InstanceId=' + InstanceId + '&&DmaId=' + DmaId + '&&IsNew=false',
                refresh: true
            });
        } else {
            top.createTab({
                id: 'M_ORDER_ORDERAPPLYLP_NEW',
                title: '平台及一级经销商订单申请-新增',
                url: 'Revolution/Pages/Order/OrderApplyLPInfo.aspx?IsNew=true&&DmaId=' + $('#QryDealer').FrameDropdownList('getValue').Key,
                refresh: true
            });
        }
    }

    //修改逻辑处理
    var openModifyInfo = function (InstanceId, ordertype, OrderNo, DmaId) {
        var data = {};
        if (ordertype == 'ClearBorrowManual') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '清指定批号订单已提交，如要修改，请撤销订单后重新申请！',
            });
        }
        else {
            //存放headerId
            $("#hidHeaderId").val(InstanceId);
            data.TemporaryId = InstanceId;
            FrameUtil.SubmitAjax({
                business: business,
                method: 'CopyForTemporary',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess) {
                        $("#hidNewOrderInstanceId").val(model.hidNewOrderInstanceId);
                        if (model.hidRtnVal == 'statusChange') {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: '订单状态已改变，不能进行修改',
                            });
                        }
                        else if (model.hidRtnVal == 'Success') {
                            top.createTab({
                                id: 'M_' + InstanceId,
                                title: '平台及一级经销商订单申请-' + ValidateDataType(OrderNo),
                                url: 'Revolution/Pages/Order/OrderApplyLPInfo.aspx?InstanceId=' + model.hidNewOrderInstanceId + '&&DmaId=' + InstanceId + '&&IsNew=false',
                                refresh: true
                            });
                        }
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }


    //Excel导入
    that.Import = function () {
        top.createTab({
            id: 'M2_OrderApply_ImportOALP',
            title: '平台及一级经销商订单申请-Excel导入',
            url: 'Revolution/Pages/Order/OrderApplyLPImport.aspx'
        });
    };
    //导出操作日志 
    that.ExportLog = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'OperationLogExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLineBumId', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'DmaId', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderType', data.QryOrderType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderStatus', data.QryOrderStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitDateStart', data.QryApplyDate.StartDate == null ? "" : data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitDateEnd', data.QryApplyDate.EndDate == null ? "" : data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderNo', data.QryOrderNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'Cfn', data.QryCFN);
        startDownload(urlExport, 'OperationLogExport');
    };
    //导出发票
    that.ExportInvoice = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'InvoiceInfoExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLineBumId', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'DmaId', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderType', data.QryOrderType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderStatus', data.QryOrderStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitDateStart', data.QryApplyDate.StartDate == null ? "" : data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitDateEnd', data.QryApplyDate.EndDate == null ? "" : data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderNo', data.QryOrderNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'Cfn', data.QryCFN);
        startDownload(urlExport, 'InvoiceInfoExport');
    };
    //导出明细
    that.ExportDetail = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'OrderDetailExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLineBumId', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'DmaId', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderType', data.QryOrderType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderStatus', data.QryOrderStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitDateStart', data.QryApplyDate.StartDate == null ? "" : data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitDateEnd', data.QryApplyDate.EndDate == null ? "" : data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderNo', data.QryOrderNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'Cfn', data.QryCFN);
        startDownload(urlExport, 'OrderDetailExport');
    };
    //库存及价格查询
    that.StockpriceQuery = function () {
        top.createTab({
            id: 'M2_OrderApply_OAQueryPrice',
            title: '库存及价格查询',
            url: 'Revolution/Pages/Inventory/QueryInventoryPrice.aspx'
        });
    };

    var setLayout = function () {
    }

    return that;
}();
