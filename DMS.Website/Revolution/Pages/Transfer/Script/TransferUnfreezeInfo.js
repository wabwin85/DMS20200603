var TransferUnfreezeInfo = {};

TransferUnfreezeInfo = function () {
    var that = {};

    var business = 'Transfer.TransferUnfreeze';
    var chooseProduct = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstStatusArr = "";
    var LstWarehouseArr = "";

    that.Init = function () {
        $("#DivBasicInfo").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });
        var data = {};
        data.WinTransferId = Common.GetUrlParam('InstanceId');
        data.WinTransferType = Common.GetUrlParam('Type');
        $("#IsNewApply").val(Common.GetUrlParam('IsNew'));

        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitInfoWin',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#WinTransferId').val(model.WinTransferId);
                $('#WinTransferType').val(model.WinTransferType);
                //详情页面部分
                $('#WinDealer').DmsDealerFilter({
                    dataSource: model.LstDealerName,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.WinDealer,
                    onChange: that.DealerChange
                });
                $('#WinTransferNumber').FrameTextBox({
                    value: model.WinTransferNumber,
                    readonly: true
                });
                $('#WinTransferStatus').FrameTextBox({
                    value: model.WinTransferStatus,
                    readonly: true
                });
                $('#WinProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.WinProductLine,
                    onChange: that.ProductLineChange
                });
                $('#WinDate').FrameTextBox({
                    value: model.WinDate,
                    readonly: true
                });
                $('#WinWarehouse').FrameDropdownList({
                    dataSource: model.LstWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.WinWarehouse
                });
                if (model.LstWarehouse && model.LstWarehouse.length > 0) {
                    $('#WinWarehouse').FrameDropdownList('setIndex', 1);
                    LstWarehouseArr = model.LstWarehouse;
                }
                if (model.ShowSearch) {
                    $('#BtnReason').FrameButton({
                        text: '授权产品线无法选择的原因',
                        icon: 'info-circle',
                        onClick: function () {
                            that.ShowReason();
                        }
                    });
                }
                $('#BtnWinSave').FrameButton({
                    text: '保存草稿',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
                    }
                });
                $('#BtnWinDelete').FrameButton({
                    text: '删除草稿',
                    icon: 'save',
                    onClick: function () {
                        that.DeleteDraft();
                    }
                });
                $('#BtnWinSubmit').FrameButton({
                    text: '提交',
                    icon: 'send',
                    onClick: function () {
                        that.Submit();
                    }
                });
                $('#BtnAddProduct').FrameButton({
                    text: '添加产品',
                    icon: 'search',
                    onClick: function () {
                        that.ShowDialog();
                    }
                });
                //绑定经销商。产品明细 。操作日志等
                createRstProductDetail();
                $("#RstWinProductList").data("kendoGrid").setOptions({
                    dataSource: {
                        data: model.RstWinProductList,
                        schema: {
                            model: {
                                fields: {
                                    TransferQty: { type: "string" },
                                    QRCodeEdit: { type: "string" }
                                }
                            }
                        }
                    }
                });
                $("#RstWinProductList").data("kendoGrid").dataSource.page(1);
                if (model.WinProductSum) {
                    $("#spProductSum").text(model.WinProductSum);
                }
                $('#RstWinOPLog').DmsOperationLog({
                    dataSource: model.RstWinOPLog
                });

                //选择产品页面按钮
                $('#BtnImportQrCode').FrameButton({
                    text: '导入二维码',
                    icon: 'plus',
                    onClick: function () {
                        that.ShowImportQrCodeWin();
                    }
                });
                $('#BtnSearch').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        clearChooseProduct();
                        that.QueryProductItem();
                    }
                });
                $('#BtnWinAdd').FrameButton({
                    text: '添加',
                    icon: 'plus',
                    onClick: function () {
                        that.AddItemsToDetail();
                    }
                });
                $('#BtnWinClose').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $('#winChooseItemLayout').data("kendoWindow").close();
                    }
                });
                //二维码导入
                $('#WinQrCodeImport').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadFile.ashx?Type=ShipmentQrCode&SheetName=Sheet1",
                        autoUpload: true
                    },
                    localization: {
                        headerStatusUploading: "上传处理中,请稍等..."
                    },
                    multiple: false,
                    error: function onError(e) {
                        if (e.XMLHttpRequest.responseText != "") {
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: e.XMLHttpRequest.responseText,
                                callback: function () {
                                }
                            });
                        }
                        FrameWindow.HideLoading();
                        var upload = $("#WinQrCodeImport").data("kendoUpload");
                        upload.enable();
                    },
                    success: function onSuccess(e) {
                        if (e.XMLHttpRequest.responseText != "") {
                            var obj = $.parseJSON(e.XMLHttpRequest.responseText);
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: obj.msg,
                                callback: function () {
                                }
                            });
                            if (obj.result == "Success") {
                                that.QueryProductItem(obj.qrCode);
                                $("#winQRCodeImportLayout").data("kendoWindow").close();
                            }
                        }
                        FrameWindow.HideLoading();
                        var upload = $("#WinQrCodeImport").data("kendoUpload");
                        upload.enable();
                    },
                    upload: function onUpload(e) {
                        var files = e.files;
                        // Check the extension of the file and abort the upload if it is not .xls or .xlsx
                        $.each(files, function () {
                            if (this.extension.toLowerCase() != ".xls" && this.extension.toLowerCase() != ".xlsx") {
                                FrameWindow.ShowAlert({
                                    target: 'center',
                                    alertType: 'info',
                                    message: '只能导入Excel文件！',
                                    callback: function () {
                                        e.preventDefault();
                                        var dataSource = $("#RstProductItem").data("kendoGrid").dataSource;
                                        dataSource.data([]);
                                        FrameWindow.HideLoading();
                                    }
                                });
                            }
                            else {
                                FrameWindow.ShowLoading();
                                var upload = $("#WinQrCodeImport").data("kendoUpload");
                                upload.disable();
                            }
                        });
                    }
                });
                $("#BtnQrCodeTemplate").FrameButton({
                    text: '下载模板',
                    onClick: function () {
                        window.open('/Upload/ShipmentQrCode/Template_QrCode.xls');
                    }
                });

                //控件控制
                $('#WinDealer').DmsDealerFilter('disable');
                $('#WinWarehouse').FrameDropdownList('disable');
                $('#WinProductLine').FrameDropdownList('disable');
                if (model.HideUOM) {
                    $("#RstWinProductList").data("kendoGrid").hideColumn(8);
                }
                if (model.HideUPN) {
                    $("#RstWinProductList").data("kendoGrid").hideColumn(4);
                }

                $('#BtnWinSave').FrameButton('disable');
                $('#BtnWinDelete').FrameButton('disable');
                $('#BtnWinSubmit').FrameButton('disable');
                $('#BtnAddProduct').FrameButton('disable');
                $("#RstWinProductList").data("kendoGrid").hideColumn(10);//数量
                $("#RstWinProductList").data("kendoGrid").hideColumn(11);//移入仓库
                $("#RstWinProductList").data("kendoGrid").hideColumn(12);//数量可编辑
                $("#RstWinProductList").data("kendoGrid").hideColumn(13);//移入仓库可编辑
                $("#RstWinProductList").data("kendoGrid").hideColumn(15);//删除
                $("#RstWinProductList").data("kendoGrid").columns[14].editable = function () { return true };//二维码
                //列显示控制*******************

                if (model.WinTransferStatus == "草稿") {
                    $('#WinDealer').DmsDealerFilter('enable');
                    $('#WinProductLine').FrameDropdownList('enable');
                    $('#WinWarehouse').FrameDropdownList('enable');
                    $('#BtnWinSave').FrameButton('enable');
                    $('#BtnWinDelete').FrameButton('enable');
                    $('#BtnWinSubmit').FrameButton('enable');
                    if (model.ShowAdd) {
                        $('#BtnAddProduct').FrameButton('enable');
                    }
                    $("#RstWinProductList").data("kendoGrid").showColumn(12);
                    $("#RstWinProductList").data("kendoGrid").showColumn(13);
                    $("#RstWinProductList").data("kendoGrid").showColumn(15);

                }
                else {
                    $("#RstWinProductList").data("kendoGrid").hideColumn(14);
                    $("#RstWinProductList").data("kendoGrid").showColumn(10);
                    $("#RstWinProductList").data("kendoGrid").showColumn(11);
                    $("#RstWinProductList").data("kendoGrid").columns[14].editable = function () { return false };
                }

                //列显示控制*******************

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();


                FrameWindow.HideLoading();
            }
        });
    }

    var createRstProductDetail = function () {
        $("#RstWinProductList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            height: 420,
            columns: [
            {
                field: "WarehouseName", title: "移出仓库", width: 170, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "移出仓库" }
            },
            {
                field: "CFNEnglishName", title: "产品英文名", width: 150, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" }
            },
            {
                field: "CFNChineseName", title: "产品中文名", width: 120, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" }
            },
            {
                field: "CFN", title: "产品型号", width: 100, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
            },
            {
                field: "UPN", title: "条形码", width: 100, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "条形码" }
            },
            {
                field: "LotNumber", title: "序列号/批号", width: 100, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" }
            },
            {
                field: "QRCode", title: "二维码", width: 120, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
            },
            {
                field: "ExpiredDate", title: "有效期", width: 100, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
            },
            {
                field: "UnitOfMeasure", title: "单位", width: 50, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "单位" }
            },
            {
                field: "TotalQty", title: "库存量", width: 50, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "库存量" }
            },
            {
                field: "TransferQty", title: "数量", width: 50, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "数量" }
            },
            {
                field: "ToWarehouseName", title: "移入仓库", width: 100, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "移入仓库" }
            },
			{
			    field: "TransferQty", title: "数量", width: 50, editable: function () {
			        return true;
			    },
			    headerAttributes: { "class": "text-center text-bold", "title": "数量" }
			},
            {
                field: "ToWarehouseId", title: "移入仓库", width: 170, editable: function () {
                    return true;
                },
                editor: ChangeWarehouseEditor,
                template: function (gridRow) {
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
                headerAttributes: { "class": "text-center text-bold", "title": "移入仓库" }
            },
            {
                field: "QRCodeEdit", title: "二维码", width: 150, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
            },
            {
                field: "Delete", title: "删除", width: 50, editable: function () {
                    return false;
                },
                headerAttributes: { "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;" },
                template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                attributes: { "class": "text-center text-bold" },
            }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 10,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstWinProductList").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    //$("#RstWinProductList").data("kendoGrid").dataSource.remove(data);
                    that.Delete(data.Id);
                });

            },
            edit: function (e) {
                CheckQty(e);
            }
        });
    }

    function ChangeWarehouseEditor(container, options) {
        $('<input data-bind="value:' + options.field + '"/>')
            .appendTo(container)
            .kendoDropDownList({
                autoBind: true,
                dataTextField: "Name",
                dataValueField: "Id",
                index: 0,
                dataSource: LstWarehouseArr
            })
    };

    //添加产品
    that.ShowDialog = function () {
        $("#RstProductItem").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 300,
            columns: [
                {
                    title: "选择", width: 50, encoded: false,
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=LotId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=LotId#"></label>',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "WarehouseName", title: "分仓库",
                    width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "分仓库" }
                },
                {
                    field: "EnglishName", title: "英文名称",
                    width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "英文名称" }
                },
                {
                    field: "ChineseName", title: "中文名称",
                    width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "中文名称" }
                },
                {
                    field: "CFN", title: "产品型号",
                    width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "UPN", title: "条形码",
                    width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "条形码" }
                },
                {
                    field: "LotNumber", title: "序列号/批号",
                    width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" }
                },
                {
                    field: "QRCode", title: "二维码",
                    width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "LotExpiredDate", title: "有效期",
                    width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
                },
                {
                    field: "UnitOfMeasure", title: "单位",
                    width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "LotInvQty", title: "库存数量",
                    width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "库存数量" }
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

                $("#RstProductItem").find(".Check-Item").unbind("click");
                $("#RstProductItem").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstProductItem").data("kendoGrid"),
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
                        var grid = $("#RstProductItem").data("kendoGrid");
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
            }
        });
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitProductChoose',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.HideUOM) {
                    $("#RstProductItem").data("kendoGrid").hideColumn(9);
                }
                if (model.HideUPN) {
                    $("#RstProductItem").data("kendoGrid").hideColumn(5);
                }
                $('#WinFreezeWarehouse').FrameDropdownList({
                    dataSource: model.LstFreezeWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.WinFreezeWarehouse
                });
                $('#WinLotNumber').FrameTextBox({
                    value: model.WinLotNumber
                });
                $('#WinCFN').FrameTextBox({
                    value: model.WinCFN
                });
                $('#WinQrCode').FrameTextBox({
                    value: model.WinQrCode
                });

                FrameWindow.HideLoading();
            }
        });
        $("#winChooseItemLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: '80%',
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("物料选择").center().open();
    }

    //单行删除 操作
    that.Delete = function (LotId) {
        var data = {};
        data.DeleteItemId = LotId;
        data.WinTransferId = $('#WinTransferId').val();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'Delete',
                    message: model.ExecuteMessage,
                });
                if (model.RstWinProductList) {
                    $("#RstWinProductList").data("kendoGrid").setOptions({
                        dataSource: {
                            data: model.RstWinProductList,
                            schema: {
                                model: {
                                    fields: {
                                        TransferQty: { type: "string" },
                                        QRCodeEdit: { type: "string" }
                                    }
                                }
                            }
                        }
                    });
                }
                if (model.WinProductSum) {
                    $("#spProductSum").text(model.WinProductSum);
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.DeleteDraftOrder = function () {
        $("#hiddIsModifyStatus").val("false");
        if ("true" == $("#IsNewApply").val()) {
            var data = {};
            data.WinTransferId = $('#WinTransferId').val();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteDraft',
                url: Common.AppHandler,
                data: data,
                async: false,
                callback: function (model) {
                    if (!model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: model.ExecuteMessage,
                        });
                    }
                    FrameWindow.HideLoading();
                    $("#hiddIsModifyStatus").val("true");
                }
            });
        }
    };
    //删除草稿
    that.DeleteDraft = function () {
        FrameWindow.ShowConfirm({
            target: 'center',
            message: '确认要执行删除操作？',
            confirmCallback: function () {
                var data = {};
                data.WinTransferId = $('#WinTransferId').val();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteDraft',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'center',
                            alertType: 'Delete',
                            message: model.ExecuteMessage,
                            callback: function () {
                                top.deleteTabsCurrent();
                            }
                        });
                        FrameWindow.HideLoading();
                    }
                });
            }
        });

    };

    //保存草稿
    that.Save = function () {
        var data = that.GetModel();
        var gridProduct = $("#RstWinProductList").data("kendoGrid").dataSource.data();
        data.RstWinProductList = gridProduct;

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveDraft',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.ExecuteMessage != '') {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'error',
                        message: model.ExecuteMessage,

                    });
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '保存成功！',
                        callback: function () {
                            top.deleteTabsCurrent();
                        }
                    });

                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.CheckForm = function (data) {
        var message = [];
        var rowCount = $('#RstWinProductList').data("kendoGrid").items().length;
        var reg = '^[0-9]*$';
        if ($.trim(data.WinDealer.Key) == "" || $.trim(data.WinProductLine.Key) == "" || rowCount <= 0) {
            message.push('请填写完整后再提交！');
            return message;
        }
        var store = $("#RstWinProductList").data("kendoGrid").dataSource.data();
        for (var i = 0; i < store.length ; i++) {
            var record = store[i];
            if (record.TransferQty <= 0) {
                message.push('数量不能为0！');
                return message;
            }
            if (record.TransferQty > record.TotalQty) {
                message.push('移库数量不能大于库存数量！');
                return message;
            }
            if (record.ToWarehouseId == null) {
                message.push('移入仓库不能为空！');
                return message;
            }
        }
        return message;
    }

    that.Submit = function () {
        var data = that.GetModel();
        var message = that.CheckForm(data);

        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            var gridProduct = $("#RstWinProductList").data("kendoGrid").dataSource.data();
            data.RstWinProductList = gridProduct;

            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Submit',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    if (model.ExecuteMessage != 'WarehouseNotEqual') {
                        if (model.ExecuteMessage == 'WarehouseEqual') {
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'error',
                                message: '移出仓库与移入仓库必须不同！',

                            });
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'error',
                                message: model.ExecuteMessage,

                            });
                        }
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'center',
                            alertType: 'info',
                            message: '提交成功！',
                            callback: function () {
                                top.deleteTabsCurrent();
                            }
                        });

                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    //修改经销商
    that.DealerChange = function () {
        if ($('#HidDealerFrom').val() != $('#WinDealer').DmsDealerFilter('getValue').Key) {
            var data = {};
            data.WinTransferId = $('#WinTransferId').val();
            data.WinDealer = $('#WinDealer').DmsDealerFilter('getValue');
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteDetail',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#HidDealerFrom').val($('#WinDealer').DmsDealerFilter('getValue').Key);
                    if (model.ExecuteMessage == '') {
                        $("#RstWinProductList").data("kendoGrid").setOptions({
                            dataSource: []
                        });
                        $("#spProductSum").text('');
                        $('#WinWarehouse').FrameDropdownList({
                            dataSource: model.LstWarehouse,
                            dataKey: 'Id',
                            dataValue: 'Name',
                            selectType: 'select',
                            value: model.WinWarehouse
                        });
                        LstWarehouseArr = model.LstWarehouse;
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'center',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                    SetMod();
                    FrameWindow.HideLoading();
                }
            });

        }
    }

    //修改产品线
    that.ProductLineChange = function () {
        var HiddenProductLineId = $('#HidProductLine').val();
        var WinProductLine = $('#WinProductLine').FrameDropdownList('getValue').Key;

        if (HiddenProductLineId != WinProductLine) {
            if (HiddenProductLineId == '') {
                $('#HidProductLine').val(WinProductLine);
                SetMod();
            } else {
                if (confirm('改变产品线将删除已添加的产品！')) {
                    var data = {};
                    data.WinTransferId = $('#WinTransferId').val();
                    data.WinDealer = $('#WinDealer').DmsDealerFilter('getValue');
                    FrameWindow.ShowLoading();
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'DeleteDetail',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            $('#HidProductLine').val(WinProductLine);
                            if (model.ExecuteMessage == '') {
                                $("#RstWinProductList").data("kendoGrid").setOptions({
                                    dataSource: []
                                });
                                $("#spProductSum").text('');
                            }
                            else {
                                FrameWindow.ShowAlert({
                                    target: 'center',
                                    alertType: 'info',
                                    message: model.ExecuteMessage,
                                    callback: function () {
                                    }
                                });
                            }
                            SetMod();
                            FrameWindow.HideLoading();
                        }
                    });

                } else {
                    $('#WinProductLine_Control').data("kendoDropDownList").value($('#HidProductLine').val());
                }
            }
        }
    }

    var SetMod = function () {
        var data = that.GetModel();
        if (data.WinProductLine.Key == "") {
            $("#BtnAddProduct").FrameButton('disable');
        }
        else {
            $("#BtnAddProduct").FrameButton('enable');
        }
    }

    //校验用户输入数量
    var CheckQty = function (e) {

        var grid = e.sender;
        var tr = $(e.container).closest("tr");
        var data = grid.dataItem(tr);
        var tfQty = e.container.find("input[name=TransferQty]");

        tfQty.blur(function (b) {
            if (accMin(data.TotalQty, $(this).val()) < 0) {
                //数量错误时，编辑行置为空
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '移库数量不能大于库存量！',
                });
            }

            if (accMul($(this).val(), 1000000) % accDiv(1, data.ConvertFactor).mul(1000000) != 0) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '最小单位是：' + accDiv(1, data.ConvertFactor).toString(),
                });
            }
        });

    }

    that.ShowImportQrCodeWin = function () {
        $("#winQRCodeImportLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("经销商二维码导入").center().open();
    }

    var clearChooseProduct = function () {
        $('#CheckAll').removeAttr("checked");
        chooseProduct.splice(0, chooseProduct.length);
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            chooseProduct.push(data);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < chooseProduct.length; i++) {
            if ((chooseProduct[i].LotId && data.LotId && chooseProduct[i].LotId == data.LotId)) {
                chooseProduct.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < chooseProduct.length; i++) {
            if ((chooseProduct[i].LotId && data.LotId && chooseProduct[i].LotId == data.LotId)) {
                exists = true;
            }
        }
        return exists;
    }

    that.QueryProductItem = function (qrCode) {
        var data = that.GetModel();
        if (qrCode && qrCode != '')
            data.WinSCQrCode = qrCode;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryProductItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#RstProductItem').data("kendoGrid").setOptions({
                        dataSource: model.RstProductItem
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.AddItemsToDetail = function () {
        var data = that.GetModel();
        if (chooseProduct.length > 0) {
            var param = '';
            for (var i = 0; i < chooseProduct.length; i++) {
                param += chooseProduct[i].LotId + ',';
            }
            data.ParaChooseItem = param.substr(0, param.length - 1);
            FrameUtil.SubmitAjax({
                business: business,
                method: 'AddItemsToDetail',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    if (model.RstWinProductList) {
                        $("#RstWinProductList").data("kendoGrid").setOptions({
                            dataSource: {
                                data: model.RstWinProductList,
                                schema: {
                                    model: {
                                        fields: {
                                            TransferQty: { type: "string" },
                                            QRCodeEdit: { type: "string" }
                                        }
                                    }
                                }
                            }
                        });
                    }
                    if (model.WinProductSum) {
                        $("#spProductSum").text(model.WinProductSum);
                    }
                    $("#winChooseItemLayout").data("kendoWindow").close();

                    FrameWindow.HideLoading();
                }
            });
        }
        else {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择要添加的数据！',
                callback: function () {
                }
            });
        }
    }

    that.ShowReason = function () {
        $("#RstWinReason").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 230,
            columns: [
                {
                    field: "ProductLineName", title: "产品线",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "Reason", title: "原因",
                    headerAttributes: { "class": "text-center text-bold", "title": "原因" }
                }

            ]
        });
        var data = {};
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ShowReason',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#RstWinReason').data("kendoGrid").setOptions({
                        dataSource: model.RstWinReason
                    });
                }
                FrameWindow.HideLoading();
            }
        });

        $("#winReasonLayout").kendoWindow({
            title: "Title",
            width: 500,
            height: 300,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("移库单明细").center().open();
    }

    var setLayout = function () {
    }

    return that;
}();
