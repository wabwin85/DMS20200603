var InventoryShipmentInfo = {};

InventoryShipmentInfo = function () {
    var that = {};

    var business = 'Inventory.InventoryQROperation';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstProductLineArr = "";

    that.InitShipmentWin = function () {
        $("#DivBasicInfo").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });
        var data = {};
        $('#InvType').val(Common.GetUrlParam('InvType'));
        data.InvType = $('#InvType').val();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitShipmentWin',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstProductLineArr = model.LstProductLine;
                $('#HidDealerId').val(model.HidDealerId);
                //产品线
                $('#WinShipmentProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.WinShipmentProductLine,
                    onChange: that.WinShipmentProductLineChange
                });
                //经销商
                $('#WinShipmentDealerName').FrameTextBox({
                    value: model.WinShipmentDealerName
                });
                $('#WinShipmentDealerName').FrameTextBox('disable');
                //用量日期
                $('#WinShipmentDate').FrameDatePicker({
                    max: model.WinShipmentDate_Max,
                    min: model.WinShipmentDate_Min,
                    value: model.WinShipmentDate,
                    onChange: that.WinShipmentDateChange
                });
                //销售医院
                $('#WinShipmentHospital').FrameDropdownList({
                    dataSource: model.LstShipmentHospital,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.WinShipmentHospital
                });
                //发票号码
                $('#WinShipmentInvoiceNo').FrameTextBox({
                    value: model.WinShipmentInvoiceNo
                });
                //发票抬头
                $('#WinShipmentInvoiceTitle').FrameTextBox({
                    value: model.WinShipmentInvoiceTitle
                });
                //发票日期
                $('#WinShipmentInvoiceDate').FrameDatePicker({
                    value: model.WinShipmentInvoiceDate
                });
                //科室
                $('#WinShipmentDepartment').FrameTextBox({
                    value: model.WinShipmentDepartment
                });
                //备注
                $('#WinShipmentRemark').FrameTextArea({
                    value: model.WinShipmentRemark
                });
                
                createDetailList(model.RstWinShipmentList);
                createAttachList();

                if (model.ShipmentRecordSum) {
                    $("#spShipmentRecordSum").text(model.ShipmentRecordSum);
                }
                if (model.ShipmentQtySum) {
                    $("#spShipmentQtySum").text(model.ShipmentQtySum);
                }

                //按钮控制*******************
                $('#BtnWinPrice').FrameButton({
                    text: '更新价格',
                    onClick: function () {
                        that.GetCfnPrice();
                    }
                });
                $('#BtnWinAddAttach').FrameButton({
                    text: '添加附件',
                    icon: 'plus',
                    onClick: function () {
                        that.ShowAttachmentWin();
                    }
                });
                $('#BtnWinClearShipment').FrameButton({
                    text: '清空',
                    icon: 'times',
                    onClick: function () {
                        that.ShipmentClear();
                    }
                });
                $('#BtnWinAddShipment').FrameButton({
                    text: '提交',
                    icon: 'send',
                    onClick: function () {
                        that.ShipmentSubmit();
                    }
                });
                
                //**********************

                //上传文件
                $('#WinAttachUpload').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=ShipmentQr",
                        autoUpload: true
                    },
                    upload: function (e) {
                        e.data = { InstanceId: $('#HidDealerId').val() };
                    },
                    multiple: false,
                    success: function (e) {
                        //$("#BtnUploadProxy").FrameSortAble("FileaddNewData", e.response)
                        that.QueryAttachInfo();
                    }
                });

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    //改变产品线
    that.WinShipmentProductLineChange = function () {
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ShipmentProductLineChange',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //用量日期
                $('#WinShipmentDate').FrameDatePicker({
                    max: model.WinShipmentDate_Max,
                    min: model.WinShipmentDate_Min,
                    value: model.WinShipmentDate,
                    onChange: that.WinShipmentDateChange
                });
                //销售医院
                $('#WinShipmentHospital').FrameDropdownList({
                    dataSource: model.LstShipmentHospital,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.WinShipmentHospital
                });
                $('#RstWinShipmentList').data("kendoGrid").setOptions({
                    dataSource: []
                });
                $('#RstWinShipmentList').data("kendoGrid").setOptions({
                    dataSource: model.RstWinShipmentList
                });
                if (model.ShipmentRecordSum) {
                    $("#spShipmentRecordSum").text(model.ShipmentRecordSum);
                }
                if (model.ShipmentQtySum) {
                    $("#spShipmentQtySum").text(model.ShipmentQtySum);
                }
                FrameWindow.HideLoading();
            }
        });
    }

    //改变用量日期
    that.WinShipmentDateChange = function () {
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeShipmentDate',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //销售医院
                $('#WinShipmentHospital').FrameDropdownList({
                    dataSource: model.LstShipmentHospital,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.WinShipmentHospital
                });
                FrameWindow.HideLoading();
            }
        });
    }

    //更改价格
    that.GetCfnPrice = function () {
        var data = that.GetModel();
        if (data.WinShipmentHospital.Key == '') {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择医院！',
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'GetCfnPrice',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    
                    that.QueryShipment();

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    //清空销售单
    that.ShipmentClear = function () {

        var data = {};
        data.InvType = 'Shipment';
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
                    that.QueryShipment();

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    //提交销售单
    that.ShipmentSubmit = function () {

        var data = that.GetModel();
        var record;
        var inventory = $("#RstWinShipmentList").data("kendoGrid").dataSource.data();

        if (data.WinShipmentProductLine.Key == '' || data.WinShipmentHospital.Key == '' || data.WinShipmentDate == '') {

            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '销售单信息不完整！'
            });
            return false;
        }

        if (inventory.length == 0) {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '销售产品没有数据！'
            });
            return false;
        }

        var fristWarehouseType = "";
        for (var i = 0; i < inventory.length; i++) {
            record = inventory[i];
            if (record.Qty == 0) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '销售数量不能为0！'
                });
                return false;
            }
            if (record.Qty > record.LotQty) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '销售数量不能大于库存数量！'
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
            
            if (i == 0) { fristWarehouseType = record.WarehouseType; }
            if ((fristWarehouseType == "Consignment" || fristWarehouseType == "LP_Consignment" || fristWarehouseType == "Borrow") && i != 0) {
                if (record.WarehouseType != "Consignment" && record.WarehouseType != "LP_Consignment" && record.WarehouseType != "Borrow") {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '寄售库存不能和普通库存同时上报销量！'
                    });
                    return false;
                }
            }
            if ((fristWarehouseType != "Consignment" && fristWarehouseType != "LP_Consignment" && fristWarehouseType != "Borrow") && i != 0) {
                if (record.WarehouseType == "Consignment" || record.WarehouseType == "LP_Consignment" || record.WarehouseType == "Borrow") {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '寄售库存不能和普通库存同时上报销量！'
                    });
                    return false;
                }
            }

            if (new Date(record.ExpiredDate) < new Date(data.WinShipmentDate)) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '不能上报过期销量！'
                });
                return false;
            }
        }

        if (confirm('提交确认？')) {
            data.RstWinShipmentList = inventory;
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SubmitShipment',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.ExecuteMessage == "Success") {
                        FrameWindow.ShowAlert({
                            target: 'center',
                            alertType: 'info',
                            message: '已将数据生成为已完成状态的销售单！',
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

    that.QueryShipment = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Bind_DetailStore',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#RstWinShipmentList').data("kendoGrid").setOptions({
                    dataSource: []
                });
                $('#RstWinShipmentList').data("kendoGrid").setOptions({
                    dataSource: model.RstWinShipmentList
                });
                if (model.ShipmentRecordSum) {
                    $("#spShipmentRecordSum").text(model.ShipmentRecordSum);
                }
                if (model.ShipmentQtySum) {
                    $("#spShipmentQtySum").text(model.ShipmentQtySum);
                }
                FrameWindow.HideLoading();
            }
        });
    }

    var createDetailList = function (detailSource) {
        $("#RstWinShipmentList").kendoGrid({
            //dataSource: detailSource,
            dataSource: {
                data: detailSource,
                schema: {
                    model: {
                        fields: {
                            Qty: { type: "number" },
                            ShipmentPrice: { type: "number" }
                        }
                    },
                },
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            height: 350,
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
                    field: "Qty", title: "销售数量", width: 80, editable: function () {
                        return true;
                    }, //editor: ChangeQtyEditor,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShipmentPrice", title: "销售金额", width: 100, 
                    editable: function () {
                        return true;
                    }, //editor: ChangePriceEditor,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售金额" },
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

                $("#RstWinShipmentList").find("i[name='delete']").bind('click', function (e) {
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

    function ChangePriceEditor(container, options) {
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
                    message: '销售数量不能大于库存数量！',
                });
                //grid.cancelChanges();
                data.Qty = data.LotQty;
                $("#RstWinShipmentList").data("kendoGrid").dataSource.fetch();
                return false;
            }
            if ($(this).val() == 0) {
                //数量错误时，编辑行置为空
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '销售数量不能为0！',
                });
                //grid.cancelChanges();
                data.Qty = data.LotQty;
                $("#RstWinShipmentList").data("kendoGrid").dataSource.fetch();
                return false;
            }
            if (accMul($(this).val(), 1000000) % accDiv(1, data.ConvertFactor).mul(1000000) != 0) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '最小单位是：' + accDiv(1, data.ConvertFactor).toString(),
                });
                //grid.cancelChanges();
                data.Qty = accDiv(1, data.ConvertFactor);
                $("#RstWinShipmentList").data("kendoGrid").dataSource.fetch();
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

                that.QueryShipment();

                FrameWindow.HideLoading();
            }
        });
    }

    //附件
    that.QueryAttachInfo = function () {
        var grid = $("#RstWinAttachList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }
    var fieldsAtt = { UploadDate: { type: "date", format: "{0: yyyy-MM-dd}" } };
    var kendoAttach = GetKendoDataSource(business, 'QueryAttachInfo', fieldsAtt, 10);
    var createAttachList = function () {
        $("#RstWinAttachList").kendoGrid({
            dataSource: kendoAttach,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 345,
            columns: [
                {
                    field: "Name", title: "附件名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "附件名称" }
                },
                {
                    field: "Identity_Name", title: "上传人",
                    headerAttributes: { "class": "text-center text-bold", "title": "上传人" }
                },
                {
                    field: "UploadDate", title: "上传时间", format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "上传时间" }
                },
                {
                    field: "Id", title: "下载",
                    headerAttributes: { "class": "text-center text-bold", "title": "下载" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='downloadAttach'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "Id", title: "删除", 
                    headerAttributes: { "class": "text-center text-bold", "title": "删除" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='deleteAttach'></i>#}#",
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

                $("#RstWinAttachList").find("i[name='downloadAttach']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.DownloadAttach(data.Name, data.Url);

                });

                $("#RstWinAttachList").find("i[name='deleteAttach']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.DeleteAttach(data.Id, data.IsCurrent);
                });

            },
            page: function (e) {
            }
        });
    }

    that.DownloadAttach = function (Name, Url) {
        var url = '/Pages/Download.aspx?downloadname=' + escape(Name) + '&filename=' + escape(Url) + '&downtype=ShipmentToHospital';
        open(url, 'Download');
    }

    that.DeleteAttach = function (ID, IsCurrent) {
        var data = {};
        data.DelAttachId = ID;
        if (IsCurrent == '1') {
            if (confirm('是否要删除该附件？')) {
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteAttach',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.ExecuteMessage == 'Success') {
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: '删除成功！'
                            });
                        }
                        that.QueryAttachInfo();
                        FrameWindow.HideLoading();
                    }
                });
            }
        } else {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '非当天上传文件，不允许删除！'
            });
        }
        
    }

    that.ShowAttachmentWin = function () {
        $("#winAttachmentLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
            actions: [
                "Close"
            ],
            resizable: false,
            close: function () {
                that.QueryAttachInfo();
            }
            //modal: true,
        }).data("kendoWindow").title("上传附件").center().open();
    }

    var setLayout = function () {
    }

    return that;
}();
