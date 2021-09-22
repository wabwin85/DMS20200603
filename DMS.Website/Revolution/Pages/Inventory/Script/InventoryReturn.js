var InventoryReturn = {};

InventoryReturn = function () {
    var that = {};

    var business = 'Inventory.InventoryReturn';

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
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //public bool DealerDisabled;//经销商是都禁用
                LstBuArr = model.LstBu;
                LstStatusArr = model.LstAdjustStatus;
                LstTypeArr = model.LstReturnType;
                LstDealerArr = model.LstDealer;
                //产品线
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });

                //经销商
                $.each(model.LstDealer, function (index, val) {
                    if (model.DealerId === val.Id)
                        model.QryDealer = { Key: model.DealerId, Value: val.ChineseShortName };
                })
                $('#QryDealer').FrameDropdownList({
                    dataSource: model.LstDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'all',
                    filter: 'contains',
                    readonly: model.DealerDisabled,
                    value: model.QryDealer
                });
                $('#QryDealerType').FrameDropdownList({
                    dataSource: model.LstDealerType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryDealerType
                });
                //退货单类型
                $('#QryReturnType').FrameDropdownList({
                    dataSource: model.LstReturnType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryReturnType
                });

                //移库单号
                $('#QryTransferNumber').FrameTextBox({
                    value: model.QryTransferNumber
                });

                $('#QryApplyDate').FrameDatePickerRange({
                    value: model.QryApplyDate
                });
                //状态
                $('#QryAdjustStatus').FrameDropdownList({
                    dataSource: model.LstAdjustStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryAdjustStatus
                });

                //退货单号
                $('#QryAdjustNumber').FrameTextBox({
                    value: model.QryAdjustNumber
                });
                //产品型号
                $('#QryCFN').FrameTextBox({
                    value: model.QryCFN
                });
                //批号/二维码
                $('#QryLotNumber').FrameTextBox({
                    value: model.QryLotNumber
                });


                //按钮控制******************************
                if (model.SearchVisible) {
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

                if (model.InsertVisible) {
                    $('#BtnNew').FrameButton({
                        text: '新增普通退换货申请单',
                        icon: 'plus',
                        onClick: function () {
                            that.addOrdinaryApply();
                        }
                    })
                }
                else {
                    $('#BtnNew').remove();
                }
                //if (model.InsertBorrow) { //隐藏，Ext直接隐藏
                if (false) {
                    $('#BtnInsertBorrow').FrameButton({
                        text: '新增寄售转移申请单',
                        icon: 'Example ofplus-square',
                        onClick: function () {
                            that.addConsignmentTransferApply();
                        }
                    });
                }
                else {
                    $('#BtnInsertBorrow').remove();
                }
                if (model.InsertConsignment) {
                    $('#BtnInsertConsignment').FrameButton({
                        text: '新增寄售退换货申请单',
                        icon: 'file-code-o',
                        onClick: function () {
                            that.ddConsignmentApply();
                        }
                    });
                }
                else {
                    $('#BtnInsertConsignment').remove();
                }

                if (false) {////隐藏，Ext直接隐藏
                    $('#btnImportConsignment').FrameButton({
                        text: 'Excel寄售导入',
                        icon: 'file-code-o',
                        onClick: function () {
                            that.Import(true);
                        }
                    });
                }
                $('#BtnImport').FrameButton({
                    text: 'Excel导入',
                    icon: 'file-code-o',
                    onClick: function () {
                        that.Import(false);
                    }
                });
                if (model.BtnResultShow) {
                    $('#BtnResultImport').remove();
                }
                else {
                    $('#BtnResultImport').FrameButton({
                        text: '退换货结果导入',
                        icon: 'file-excel-o',
                        onClick: function () {
                            that.ImportResult();
                        }
                    });
                }
                if (model.ExportVisible) {
                    $('#BtnExport').FrameButton({
                        text: '导出',
                        icon: 'file-excel-o',
                        onClick: function () {
                            that.Export();
                        }
                    });
                }
                else {
                    $('#BtnExport').remove();
                }

                //按钮控制**********************

                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });


                FrameWindow.HideLoading();
            }
        });
    }
    that.ImportResult = function () {
        top.createTab({
            id: 'M2_InventoryAdjustAudit_IMPORT',
            title: '退换货结果导入',
            url: 'Revolution/Pages/Inventory/ReturnResultImport.aspx'
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
                    field: "DealerId", title: "经销商", width: 'auto', template: function (gridrow) {
                        var Name = "";
                        if (LstDealerArr.length > 0) {
                            if (gridrow.DealerId != "") {
                                $.each(LstDealerArr, function () {
                                    if (this.Id == gridrow.DealerId) {
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
                    field: "AdjustNumber", title: "退换货单号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "退换货单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Type", title: "类型", width: '100px', template: function (gridrow) {
                        var Name = "";
                        if (LstTypeArr.length > 0) {
                            if (gridrow.Type != "") {
                                $.each(LstTypeArr, function () {
                                    if (this.Key == gridrow.Type) {
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
                    headerAttributes: { "class": "text-center text-bold", "title": "类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalQyt", title: "总数量", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "总数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CreateDate", title: "退换货日期", width: '90px',
                    headerAttributes: { "class": "text-center text-bold", "title": "退换货日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CreateUserName", title: "退换货人", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "退换货人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Status", title: "状态", width: '50px', template: function (gridrow) {
                        var Name = "";
                        if (LstStatusArr.length > 0) {
                            if (gridrow.Status != "") {
                                $.each(LstStatusArr, function () {
                                    if (this.Key == gridrow.Status) {
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
                    headerAttributes: { "class": "text-center text-bold", "title": "状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "IsConsignment", title: "物权类型", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "物权类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
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
                },
                {
                    title: "打印", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-print' style='font-size: 14px; cursor: pointer;' name='print'></i>#}#",
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

                    openInfo(data.Id, data.IAH_WarehouseType, data.Type, data.AdjustNumber);
                });

                $("#RstResultList").find("i[name='print']").on('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    openPrintPage(data.Id);
                })
            }
        });
    }

    var openInfo = function (InstanceId, Type, AdjustType, OrderNo) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '退换货申请-' + ValidateDataType(OrderNo),
                url: 'Revolution/Pages/Inventory/InventoryReturnInfo.aspx?InstanceId=' + InstanceId + '&&Type=' + Type + '&&AdjustType=' + AdjustType + '&&IsNew=false',
                refresh:true
            });
        } else {
        }
    }

    var openPrintPage = function (id) {
        window.open("InventoryReturnPrint.aspx?id=" + id, 'newwindow',
        'status=no,width=850px,height=550px,scrollbars=yes,resizable=yes,location=no,top=50,left=100');
    }

    //新增寄售转移申请单
    that.addConsignmentTransferApply = function () {
        top.createTab({
            id: 'M_INVENTORY_TRANSFER_NEW',
            title: '退换货申请-新增寄售转移申请单',
            url: 'Revolution/Pages/Inventory/InventoryReturnInfo.aspx?Type=Borrow&&AdjustType=Transfer&&IsNew=true',
            refresh: true
        });
    };
    //新增普通退换货申请
    that.addOrdinaryApply = function () {
        top.createTab({
            id: 'M_INVENTORY_RETURN_NEW',
            title: '退换货申请-新增普通退换货申请单',
            url: 'Revolution/Pages/Inventory/InventoryReturnInfo.aspx?Type=Normal&&AdjustType=Return&&IsNew=true',
            refresh:true
        });
    };
    //新增寄售退换货申请单
    that.ddConsignmentApply = function () {
        top.createTab({
            id: 'M_INVENTORY_CONSIGNMENT_NEW',
            title: '退换货申请-新增寄售退换货申请单',
            url: 'Revolution/Pages/Inventory/InventoryReturnInfo.aspx?Type=Consignment&&AdjustType=Return&&IsNew=true',
            refresh:true
        });
    };


    //导入
    that.Import = function (status) {
        if (status)//Excel寄售导入
        {
            top.createTab({
                id: 'M_INVENTORY_CONSIGNMENT_IMPORT',
                title: '退换货申请-Excel寄售导入',
                url: 'Revolution/Pages/Inventory/InventoryReturnConsignmentImport.aspx'
            });
        }
            //Excel导入
        else {
            top.createTab({
                id: 'M_INVENTORY_EXCEL_IMPORT',
                title: '退换货申请-Excel导入',
                url: 'Revolution/Pages/Inventory/InventoryReturnImport.aspx'
            });
        }
    }

    //导出
    that.Export = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        debugger
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'InventoryReturn');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerId', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Type', data.QryReturnType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'CreateDateStart', data.QryApplyDate.StartDate == null ? "" : data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'CreateDateEnd', data.QryApplyDate.EndDate == null ? "" : data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'AdjustNumber', data.QryAdjustNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'Status', data.QryAdjustStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Cfn', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'LotNumber', data.QryLotNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerType', data.QryDealerType.Key);
        startDownload(urlExport, 'InventoryReturn');//下载名称
    };

    return that;
}();

