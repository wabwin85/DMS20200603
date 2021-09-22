var InventoryQROperation = {};

InventoryQROperation = function () {
    var that = {};

    var business = 'Inventory.InventoryQROperation';
    var chooseProduct = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstProductLineArr = "";

    that.Init = function () {
        var data = {};

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstProductLineArr = model.LstProductLine;
                //产品线
                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryProductLine
                });
                //经销商
                $('#QryDealer').DmsDealerFilter({
                    dataSource: model.LstDealerName,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealer,
                    onChange: that.DealerChange
                });
                //二维码
                $('#QryQrCode').FrameTextBox({
                    value: model.QryQrCode
                });
                //产品名称
                $('#QryCfnChineseName').FrameTextBox({
                    value: model.QryCfnChineseName
                });
                //仓库
                $('#QryWarehouse').FrameDropdownList({
                    dataSource: model.LstWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.QryWarehouse
                });
                //产品型号
                $('#QryCFN').FrameTextBox({
                    value: model.QryCFN
                });
                //有效期日期范围
                $('#QryExpiredDate').FrameDatePickerRange({
                    value: model.QryExpiredDate
                });
                //类型
                $('#QryScanType').FrameDropdownList({
                    dataSource: [{ Key: '上报销量', Value: '上报销量' }, { Key: '移库', Value: '移库' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryScanType
                });
                //批次号
                $('#QryLotNumber').FrameTextBox({
                    value: model.QryLotNumber
                });
                //数据日期范围
                $('#QryRemarkDate').FrameDatePickerRange({
                    value: model.QryRemarkDate
                });
                //备注
                $('#QryRemark').FrameTextBox({
                    value: model.QryRemark
                });
                //库存状态
                $('#QryQtyIsZero').FrameDropdownList({
                    dataSource: [{ Key: '1', Value: '库存不为零' }, { Key: '0', Value: '库存为零' }, { Key: '-1', Value: '库存不存在' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: { Key: '1', Value: '库存不为零' }
                });
                //扫描日期范围
                $('#QryCreateDate').FrameDatePickerRange({
                    value: model.QryCreateDate
                });
                //上报状态
                $('#QryShipmentState').FrameDropdownList({
                    dataSource: [{ Key: '1', Value: '已上报' }, { Key: '0', Value: '未上报' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: { Key: '0', Value: '未上报' }
                });

                createResultList();

                //按钮控制*******************
                $('#BtnSearch').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                        clearChooseProduct();
                    }
                });
                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportDetail();
                    }
                });
                $('#BtnDelete').FrameButton({
                    text: '删除',
                    icon: 'trash',
                    onClick: function () {
                        that.DelScanData();
                    }
                });
                $('#BtnCreateShipment').FrameButton({
                    text: '生成销售单',
                    icon: 'cart-plus',
                    onClick: function () {
                        that.AddShipmentCfn();
                    }
                });
                $('#BtnCreateTransfer').FrameButton({
                    text: '生成移库单',
                    icon: 'cart-plus',
                    onClick: function () {
                        that.AddTransferCfn();
                    }
                });
                $('#BtnCreateQrCodeConvent').FrameButton({
                    text: '替换二维码(销售)',
                    icon: 'retweet',
                    onClick: function () {
                        that.AddShipmentQRCode();
                    }
                });
                //$('#BtnCreateInventoryQrcodeConvent').FrameButton({
                //    text: '替换二维码(库存)',
                //    icon: 'retweet',
                //    onClick: function () {
                //        that.AddInventoryQRCode();
                //    }
                //});
                //**********************

                if (model.ShowRemark) {
                    $('#divRemark').show();
                }
                else {
                    $('#divRemark').hide();
                }

                if (model.IsDealer)
                {
                    $('#QryDealer').DmsDealerFilter('disable');
                }

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
        ExpiredDate: { type: "date", format: "{0:yyyy-MM-dd}" },
        RemarkDate: { type: "date", format: "{0:yyyy-MM-dd}" },
        CreateDate: { type: "date", format: "{0:yyyy-MM-dd}" },
        Qty: { type: "number" }
    };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 15);

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            height: 420,
            columns: [
                {
                    title: "选择", width: 50, encoded: false, editable: function () {
                        return false;
                    },
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "BarCode1", title: "上报类型", width: 100, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "上报类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DealerName", title: "经销商", width: 220, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "WarehouseName", title: "仓库", width: 150, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "WarehouseTypeName", title: "仓库类型", width: 100, hidden: true,
                    editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QrCode", title: "二维码", width: 130, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Remark", title: "备注", width: 100, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "备注" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductLineId", title: "产品线", width: 100, template: function (gridrow) {
                        var Name = "";
                        if (LstProductLineArr.length > 0) {
                            if (gridrow.ProductLineId != "") {
                                $.each(LstProductLineArr, function () {
                                    if (this.Key == gridrow.ProductLineId) {
                                        Name = this.Value;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        }
                    }, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: 80, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "BrandName", title: "品牌", width: 80, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell" }

                },
                {
                    field: "Upn", title: "产品型号", width: 100, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sku2", title: "短编号", width: 100, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "短编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CfnCnName", title: "产品中文名称", width: 100, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Lot", title: "批次号", width: 100, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "批次号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ExpiredDate", title: "有效期", width: 100, format: "{0:yyyy-MM-dd}",
                    editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RemarkDate", title: "数据日期", width: 100, format: "{0:yyyy-MM-dd}",
                    editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "数据日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CreateDate", title: "扫描日期", width: 100, format: "{0:yyyy-MM-dd}",
                    editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "扫描日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UOM", title: "单位", width: 80, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotQty", title: "库存数量", width: 80, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "库存数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Qty", title: "上报数量", width: 80, editable: function () {
                        return true;
                    }, //editor: ChangeLotQtyEditor,
                    headerAttributes: { "class": "text-center text-bold", "title": "上报数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CreateUserName", title: "上报人", width: 80, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "上报人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShipmentState", title: "上报状态", width: 80, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "上报状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "添加", width: 50, hidden: true,
                    editable: function () {
                        return false;
                    },
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "删除", width: 50,
                    editable: function () {
                        return false;
                    },
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='delete'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
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

                    that.AddItemSingle(data.Id, data.LotId, data.Qty);
                });

                $("#RstResultList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    that.DelItem(data.Id);
                });

                $("#RstResultList").find(".Check-Item").unbind("click");
                $("#RstResultList").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstResultList").data("kendoGrid"),
                    dataItem = grid.dataItem(row);

                    if (checked) {
                        dataItem.IsChecked = true;
                        addItem(dataItem);
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeItem(dataItem);
                        row.removeClass("k-state-selected");
                    }
                });

                $('#CheckAll').unbind('change');
                $('#CheckAll').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstResultList").data("kendoGrid");
                        var data = grid.dataItem(row);

                        if (checked) {
                            addItem(data);
                            $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                            $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                        } else {
                            removeItem(data);
                            $(this).prop("checked", false); //此处设置每行的checkbox不选中，必须用prop方法
                            $(this).closest("tr").removeClass("k-state-selected");  //设置grid 每一行不选中
                        }
                    });
                });
            },
            page: function (e) {
                clearChooseProduct();
            },
            edit: function (e) {
                CheckQty(e);
            }
        });
    }

    function ChangeLotQtyEditor(container, options) {
        $('<input data-bind="value:' + options.field + '"/>')
            .appendTo(container).kendoNumericTextBox()
    };

    //校验用户输入数量
    var CheckQty = function (e) {

        var grid = e.sender;
        var tr = $(e.container).closest("tr");
        var data = grid.dataItem(tr);
        var tfQty = e.container.find("input[name=Qty]");

        tfQty.blur(function (b) {
            if (accMin(data.LotQty, $(this).val()) < 0) {
                //数量错误时，编辑行置为空
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '上报数量不能大于库存数量！',
                });
                data.Qty = data.LotQty;
                $("#RstResultList").data("kendoGrid").dataSource.fetch();
                return false;
            }

            if (accMul($(this).val(), 1000000) % accDiv(1, data.ConvertFactor).mul(1000000) != 0) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '最小单位是：' + accDiv(1, data.ConvertFactor).toString(),
                });
                data.Qty = accDiv(1, data.ConvertFactor);
                $("#RstResultList").data("kendoGrid").dataSource.fetch();
                return false;
            }
        });

    }

    var clearChooseProduct = function () {
        $('#CheckAll').removeAttr("checked");
        $('.Check-Item').removeAttr("checked");
        $('.Check-Item').closest("tr").removeClass("k-state-selected");
        chooseProduct.splice(0, chooseProduct.length);
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            chooseProduct.push(data);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < chooseProduct.length; i++) {
            if ((chooseProduct[i].Id && data.Id && chooseProduct[i].Id == data.Id)) {
                chooseProduct.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < chooseProduct.length; i++) {
            if ((chooseProduct[i].Id && data.Id && chooseProduct[i].Id == data.Id)) {
                exists = true;
            }
        }
        return exists;
    }

    //历史移库单导出
    that.ExportDetail = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'InventoryQROperationExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'DmaId', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'WarehouseId', data.QryWarehouse.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Remark', data.QryRemark);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLineId', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Upn', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'Lot', data.QryLotNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'CfnChineseName', data.QryCfnChineseName);
        urlExport = Common.UpdateUrlParams(urlExport, 'ExpiredDateStart', data.QryExpiredDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'ExpiredDateEnd', data.QryExpiredDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QrCode', data.QryQrCode);
        urlExport = Common.UpdateUrlParams(urlExport, 'RemarkDateStart', data.QryRemarkDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'RemarkDateEnd', data.QryRemarkDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'CreateDateStart', data.QryCreateDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'CreateDateEnd', data.QryCreateDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'ScanType', data.QryScanType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QtyIsZero', data.QryQtyIsZero.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'ShipmentState', data.QryShipmentState.Key);
        startDownload(urlExport, 'InventoryQROperationExport');//下载名称
    }

    that.AddItemSingle = function (Id, LotId, Qty) {
        var data = {};
        data.ChooseParam = LotId + '@' + Id + '@' + Qty;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'AddItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.ExecuteMessage == "Success")
                {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '添加成功！',
                    });
                }
                
                FrameWindow.HideLoading();
            }
        });
    }

    that.DelItem = function (Id) {
        FrameWindow.ShowConfirm({
            target: 'center',
            message: '确定删除？',
            confirmCallback: function () {
                var data = {};
                data.DelItem = Id;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteItem',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {

                        that.Query();
                        
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }

    that.DelScanData = function () {

        if (chooseProduct.length > 0) {
            FrameWindow.ShowConfirm({
                target: 'center',
                message: '确定是否删除？',
                confirmCallback: function () {
                    var data = {};
                    var param = '';
                    for (var i = 0; i < chooseProduct.length; i++) {
                        param += chooseProduct[i].LotId + '@' + chooseProduct[i].Id + '@' + chooseProduct[i].Qty + ',';
                    }
                    data.ChooseParam = param.substr(0, param.length - 1);
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'DeleteItems',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            if (model.ExecuteMessage == "Success") {
                                that.Query();
                                clearChooseProduct();
                            } else {
                                FrameWindow.ShowAlert({
                                    target: 'center',
                                    alertType: 'info',
                                    message: model.ExecuteMessage,
                                });
                            }
                            FrameWindow.HideLoading();
                        }
                    });
                }
            });
        } else {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择需要删除的记录！',
            });
        }
    }

    //修改经销商
    that.DealerChange = function () {
        var data = {};
        data.QryDealer = $('#QryDealer').DmsDealerFilter('getValue');
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DealerChange',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                    
                $('#QryWarehouse').FrameDropdownList({
                    dataSource: model.LstWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.QryWarehouse
                });

                SetMod();
                FrameWindow.HideLoading();
            }
        });

    }

    //生成销售单
    that.AddShipmentCfn = function () {
        
        var param = '';
        var flag = 'true';
        for (var i = 0; i < chooseProduct.length; i++) {
            if (chooseProduct[i].Qty == '0' || chooseProduct[i].Qty < 0 || chooseProduct[i].Qty == null || chooseProduct[i].Qty == '') {
                flag = 'false';
            }
            param += chooseProduct[i].LotId + '@' + chooseProduct[i].Id + '@' + chooseProduct[i].Qty + ',';
        }

        if (flag == "false") {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '上报数量小于等于0的不允许添加！',
            });
            return false;
        }

        if (param.indexOf('null') >= 0) {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '无库存的二维码不允许添加！',
            });
            return false;
        }

        if (param.length > 0) {
            
            FrameWindow.ShowConfirm({
                target: 'center',
                message: '确定添加？',
                confirmCallback: function () {
                    var data = {};
                    data.InvType = 'Shipment';
                    data.ChooseParam = param.substr(0, param.length - 1);
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'AddItem',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            if (model.ExecuteMessage == "Success") {
                                clearChooseProduct();
                                that.OpenShipmentWin();
                                //Ext.getCmp('<%=this.ShipmentWindows.ClientID%>').show();
                                //RefreshShipmentDetailWindow();
                                //ShowShipmentWindow();
                                //Ext.getCmp('<%=this.gpAttachment.ClientID%>').store.reload();
                            } else {
                                FrameWindow.ShowAlert({
                                    target: 'center',
                                    alertType: 'info',
                                    message: model.ExecuteMessage,
                                });
                            }
                            FrameWindow.HideLoading();
                        }
                    });
                }
            });

        } else {
            that.OpenShipmentWin();
            //Ext.getCmp('<%=this.ShipmentWindows.ClientID%>').show();
            //RefreshShipmentDetailWindow();
            //ShowShipmentWindow();
        }
    }

    //生成移库单
    that.AddTransferCfn = function () {
        
        var param = '';
        var flag = 'true';
        for (var i = 0; i < chooseProduct.length; i++) {
            if (chooseProduct[i].Qty == '0' || chooseProduct[i].Qty < 0 || chooseProduct[i].Qty == null || chooseProduct[i].Qty == '') {
                flag = 'false';
            }
            param += chooseProduct[i].LotId + '@' + chooseProduct[i].Id + '@' + chooseProduct[i].Qty + ',';
        }

        if (flag == "false") {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '上报数量小于等于0的不允许添加！',
            });
            return false;
        }

        if (param.indexOf('null') >= 0) {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '无库存的二维码不允许添加！',
            });
            return false;
        }
        if (param.length > 0) {

            FrameWindow.ShowConfirm({
                target: 'center',
                message: '确定添加？',
                confirmCallback: function () {
                    var data = {};
                    data.InvType = 'Transfer';
                    data.ChooseParam = param.substr(0, param.length - 1);
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'AddItem',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            if (model.ExecuteMessage == "Success") {
                                clearChooseProduct();
                                that.OpenTransferWin();
                                //Ext.getCmp('<%=this.TransferWindows.ClientID%>').show();
                                //RefreshTransferDetailWindow();
                                //ShowTransferWindow();
                            } else {
                                FrameWindow.ShowAlert({
                                    target: 'center',
                                    alertType: 'info',
                                    message: model.ExecuteMessage,
                                });
                            }
                            FrameWindow.HideLoading();
                        }
                    });
                }
            });
        } else {
            that.OpenTransferWin();
            //Ext.getCmp('<%=this.TransferWindows.ClientID%>').show();
            //RefreshTransferDetailWindow();
            //ShowTransferWindow();
        }
    }

    //二维码替换
    that.AddShipmentQRCode = function () {

        var param = '';
        var count = 0;
        for (var i = 0; i < chooseProduct.length; i++) {
            param += chooseProduct[i].LotId + '@' + chooseProduct[i].Id;
            count = count + 1;
        }

        if (count != 1) {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '必须且只能选择一条进行替换！',
            });
            return false;
        }
        if (param.length > 0) {

            FrameWindow.ShowConfirm({
                target: 'center',
                message: '确定替换？',
                confirmCallback: function () {
                    clearChooseProduct();
                    that.OpenShipQrCodeWin(param);
                    //Ext.getCmp('<%=this.ShipmentQRCodeWindows.ClientID%>').show();
                    //RefreshShipmentQRCodeWindows();
                }
            });
        }
    }

    that.OpenShipmentWin = function () {
        top.createTab({
            id: 'M_INVENTORYSHIPMENTINFO',
            title: '销售单信息',
            url: 'Revolution/Pages/Inventory/InventoryShipmentInfo.aspx?InvType=Shipment'
        });
    }

    that.OpenTransferWin = function () {
        top.createTab({
            id: 'M_INVENTORYTRANSFERINFO',
            title: '移库信息',
            url: 'Revolution/Pages/Inventory/InventoryTransferInfo.aspx?InvType=Transfer'
        });
    };

    that.OpenShipQrCodeWin = function (param) {
        if (param) {
            top.createTab({
                id: 'M_INVENTORYSHIPQRCODEINFO',
                title: '二维码转换',
                url: 'Revolution/Pages/Inventory/InventoryShipQrCodeInfo.aspx?ChooseParam=' + param 
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();
