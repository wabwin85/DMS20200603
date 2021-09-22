var InventoryTransferInfo = {};

InventoryTransferInfo = function () {
    var that = {};

    var business = 'Inventory.InventoryQROperation';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstProductLineArr = "";
    var LstWarehouseArr = "";

    that.InitTransferWin = function () {

        var data = {};
        $('#InvType').val(Common.GetUrlParam('InvType'));
        data.InvType = $('#InvType').val();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitTransferWin',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstProductLineArr = model.LstProductLine;
                LstWarehouseArr = model.LstTransferWarehouse;
                //产品线
                $('#WinTransferProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.WinTransferProductLine,
                    onChange: that.WinTransferProductLineChange
                });
                //经销商
                $('#WinTransferDealerName').FrameTextBox({
                    value: model.WinTransferDealerName
                });
                $('#WinTransferDealerName').FrameTextBox('disable');
                //移库类型
                $('#WinTransferType').FrameDropdownList({
                    dataSource: model.LstTransferType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.WinTransferType,
                    onChange: that.WinTransferTypeChange
                });
                $('#WinTransferType').FrameDropdownList('setIndex', 1);
                //默认移入仓库
                $('#WinTransferWarehouse').FrameDropdownList({
                    dataSource: model.LstTransferWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.WinTransferWarehouse,
                    onChange: that.WinTransferWarehouseChange
                });

                createDetailList(model.RstWinTransferList);
                if (model.TransferRecordSum) {
                    $("#spTransferRecordSum").text(model.TransferRecordSum);
                }
                if (model.TransferQtySum) {
                    $("#spTransferQtySum").text(model.TransferQtySum);
                }

                //按钮控制*******************
                $('#BtnTransferClear').FrameButton({
                    text: '清空',
                    icon: 'times',
                    onClick: function () {
                        that.TransferClear();
                    }
                });
                $('#BtnTransferSubmit').FrameButton({
                    text: '提交',
                    icon: 'send',
                    onClick: function () {
                        that.TransferSubmit();
                    }
                });

                //**********************

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    //改变产品线
    that.WinTransferProductLineChange = function () {
        that.QueryTransfer();
    }

    //改变移库类型
    that.WinTransferTypeChange = function () {
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'GetTransferWarehouseByType',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                LstWarehouseArr = model.LstTransferWarehouse;
                $('#WinTransferWarehouse').FrameDropdownList({
                    dataSource: model.LstTransferWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.WinTransferWarehouse,
                    onChange: that.WinTransferWarehouseChange
                });
                that.QueryTransfer();

                FrameWindow.HideLoading();
            }
        });
    }

    //改变仓库
    that.WinTransferWarehouseChange = function () {
        var data = that.GetModel();
        var inventory = $("#RstWinTransferList").data("kendoGrid").dataSource.data();

        if (data.WinTransferWarehouse.Key == null || data.WinTransferWarehouse.Key == '') {
            return;
        }
        if (inventory.length > 0) {
            
            if (confirm('确定更新默认仓库？')) {
                FrameWindow.ShowLoading();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'UpdateToWarehouse',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.ExecuteMessage == "Success")
                        {
                            that.QueryTransfer();
                        }
                        else
                        {
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: model.ExecuteMessage
                            });
                        }

                        FrameWindow.HideLoading();
                    }
                });
            }
        } 
    }

    //清除移库
    that.TransferClear = function () {
        var data = {};
        data.InvType = 'Transfer';
        if (confirm('清空确认？')) {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteOperationByType',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '清空成功！'
                    });
                    that.QueryTransfer();

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    //提交移库
    that.TransferSubmit = function () {
        var data = that.GetModel();
        var record;
        var inventory = $("#RstWinTransferList").data("kendoGrid").dataSource.data();

        if (data.WinTransferProductLine.Key == '' || data.WinTransferType.Key == '') {

            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '移库单信息不完整！'
            });
            return false;
        }

        if (inventory.length == 0) {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '移库产品没有数据！'
            });
            return false;
        }

        for (var i = 0; i < inventory.length; i++) {
            record = inventory[i];
            if (record.Qty == 0) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '移库数量不能为0！'
                });
                return false;
            }
            if (record.Qty > record.LotQty) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '移库数量不能大于库存数量！'
                });
                return false;
            }
            if (accMul(record.Qty, 1000000) % accDiv(1, record.ConvertFactor).mul(1000000) != 0) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '最小单位是' + accDiv(1, record.ConvertFactor).toString()
                });
                return false;
            }
            if (record.ToWarehouseId == '' || record.ToWarehouseId == null) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '必须选择移入仓库！'
                });
                return false;
            }
            if (record.WarehouseId.toUpperCase() == record.ToWarehouseId.toUpperCase()) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '移出仓库与移入仓库必须不同！'
                });
                return false;
            }
            if (record.WarehouseType == 'Borrow' || record.WarehouseType == 'Consignment' || record.WarehouseType == 'LP_Consignment'
                || record.ToWarehouseType == 'Borrow' || record.ToWarehouseType == 'Consignment' || record.ToWarehouseType == 'LP_Consignment'
                ) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '寄售/借货仓位不能做移库操作！'
                });
                return false;
            }
        }

        if (confirm('提交确认？')) {
            data.RstWinTransferList = inventory;
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SubmitTransfer',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.ExecuteMessage == "Success") {
                        FrameWindow.ShowAlert({
                            target: 'center',
                            alertType: 'info',
                            message: '已将数据生成为完成状态的移库单！',
                            callback: function () {
                                top.deleteTabsCurrent();
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'center',
                            alertType: 'info',
                            message: model.ExecuteMessage
                        });
                    }

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.QueryTransfer = function () {
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Bind_DetailStore',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#RstWinTransferList').data("kendoGrid").setOptions({
                    dataSource: []
                });
                $('#RstWinTransferList').data("kendoGrid").setOptions({
                    dataSource: model.RstWinTransferList
                });
                if (model.TransferRecordSum) {
                    $("#spTransferRecordSum").text(model.TransferRecordSum);
                }
                if (model.TransferQtySum) {
                    $("#spTransferQtySum").text(model.TransferQtySum);
                }
                FrameWindow.HideLoading();
            }
        });
    }

    var createDetailList = function (detailSource) {
        $("#RstWinTransferList").kendoGrid({
            //dataSource: detailSource,
            dataSource: {
                data: detailSource,
                schema: {
                    model: {
                        fields: {
                            Qty: { type: "number" }
                        }
                    },
                },
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            height: 420,
            columns: [
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
                    field: "BarCode", title: "二维码", width: 130, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QrcRemark", title: "备注", width: 100, editable: function () {
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
                    field: "CustomerFaceNbr", title: "产品型号", width: 100, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SKU2", title: "短编号", width: 100, editable: function () {
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
                    field: "LotNumber", title: "批次号", width: 100, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "批次号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ExpiredDate", title: "有效期", width: 100, format: "{0:yyyy-MM-dd}",
                    template: "#= kendo.toString(kendo.parseDate(ExpiredDate, 'yyyy-MM-dd'), 'yyyy-MM-dd') #",
                    editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" },
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
                    field: "Qty", title: "移库数量", width: 80, editable: function () {
                        return true;
                    }, //editor: ChangeQtyEditor,
                    headerAttributes: { "class": "text-center text-bold", "title": "移库数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ToWarehouseId", title: "移入仓库", width: 100,
                    editable: function () {
                        return true;
                    }, editor: ChangeWarehouseEditor, template: function (gridRow) {
                        var warehouseName = "";
                        if (LstWarehouseArr.length > 0) {
                            if (gridRow.ToWarehouseId != null && gridRow.ToWarehouseId != "") {
                                $.each(LstWarehouseArr, function () {
                                    if (this.Id == gridRow.ToWarehouseId) {
                                        warehouseName = this.Name;
                                        return false;
                                    }
                                })
                            }
                            else {
                                gridRow.ToWarehouseId = "";
                            }
                        }
                        return warehouseName;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "移入仓库" },
                    attributes: { "class": "table-td-cell" }
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

                $("#RstWinTransferList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    that.DeleteOperationItem(data.Id);
                });

            },
            page: function (e) {
            },
            edit: function (e) {
                CheckQty(e);
            }
        });
    }

    function ChangeQtyEditor(container, options) {
        $('<input data-bind="value:' + options.field + '"/>')
            .appendTo(container).kendoNumericTextBox()
    };

    function ChangeWarehouseEditor(container, options) {
        $('<input data-bind="value:' + options.field + '"/>')
            .appendTo(container).kendoDropDownList({
                autoBind: true,
                dataTextField: "Name",
                dataValueField: "Id",
                index: 0,
                dataSource: LstWarehouseArr
            })

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
                    message: '移库数量不能大于库存数量！',
                });
                data.Qty = data.LotQty;
                $("#RstWinTransferList").data("kendoGrid").dataSource.fetch();
                return false;
            }
            if ($(this).val() == 0) {
                //数量错误时，编辑行置为空
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '移库数量不能为0！',
                });
                data.Qty = data.LotQty;
                $("#RstWinTransferList").data("kendoGrid").dataSource.fetch();
                return false;
            }
            if (accMul($(this).val(), 1000000) % accDiv(1, data.ConvertFactor).mul(1000000) != 0) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '最小单位是：' + accDiv(1, data.ConvertFactor).toString(),
                });
                data.Qty = accDiv(1, data.ConvertFactor);
                $("#RstWinTransferList").data("kendoGrid").dataSource.fetch();
                return false;
            }
        });

    }

    //删除产品
    that.DeleteOperationItem = function (Id) {
        var data = {};
        data.DelProductId = Id;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteOperationItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                that.QueryTransfer();

                FrameWindow.HideLoading();
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();
