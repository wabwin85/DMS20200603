var InventoryShipQrCodeInfo = {};

InventoryShipQrCodeInfo = function () {
    var that = {};

    var business = 'Inventory.InventoryQROperation';
    var chooseProduct = [];
    var chooseQrCode = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstDealerArr = "";

    that.InitQrCodeConvertWin = function () {
        var data = {};
        $('#ChooseParam').val(Common.GetUrlParam('ChooseParam'));
        data.ChooseParam = $('#ChooseParam').val();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitQrCodeConvertWin',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstDealerArr = model.LstDealer;
                $('#HidDealerId').val(model.HidDealerId);
                $('#HidHeadId').val(model.HidHeadId);
                $('#HidPmaId').val(model.HidPmaId);
                $('#HidShipHeadId').val(model.HidShipHeadId);
                //经销商
                $('#WinQrCodeConvertDealerName').FrameTextBox({
                    value: model.WinQrCodeConvertDealerName
                });
                $('#WinQrCodeConvertDealerName').FrameTextBox('disable');
                //产品线
                $('#WinQrCodeConvertProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.WinQrCodeConvertProductLine
                });
                $('#WinQrCodeConvertProductLine').FrameDropdownList('disable');
                //产品型号
                $('#WinQrCodeConvertUpn').FrameTextBox({
                    value: model.WinQrCodeConvertUpn
                });
                $('#WinQrCodeConvertUpn').FrameTextBox('disable');
                //批次号
                $('#WinQrCodeConvertLotNumber').FrameTextBox({
                    value: model.WinQrCodeConvertLotNumber
                });
                $('#WinQrCodeConvertLotNumber').FrameTextBox('disable');
                //被替换的二维码
                $('#WinQrCodeConvertUsedQrCode').FrameTextBox({
                    value: model.WinQrCodeConvertUsedQrCode
                });
                $('#WinQrCodeConvertUsedQrCode').FrameTextBox('disable');
                //新二维码
                $('#WinQrCodeConvertNewQrCode').FrameTextBox({
                    value: model.WinQrCodeConvertNewQrCode
                });
                $('#WinQrCodeConvertNewQrCode').FrameTextBox('disable');
                //调整原因
                $('#WinQrCodeConvert').FrameDropdownList({
                    dataSource: [{ Key: '二维码替换', Value: '二维码替换' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: { Key: '二维码替换', Value: '二维码替换' }
                });

                //添加产品仓库
                $('#WinQrCodeWarehouse').FrameDropdownList({
                    dataSource: model.LstWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.WinQrCodeWarehouse
                });
                $('#WinQrCodeWarehouse').FrameDropdownList('setIndex', 1);
                //二维码
                $('#WinQrCode').FrameTextBox({
                    value: model.WinQrCode
                });
                
                createDetailList(model.RstWinQrCodeConvertList);
                createQrCfnList();

                //按钮控制*******************
                $('#BtnNewCfn').FrameButton({
                    onClick: function () {
                        that.ShowNewCfn();
                    }
                });
                $('#BtnNewCfn').html('<i class="fa fa-fw fa-plus"></i>');
                $('#BtnShipmentQRCodeSubmit').FrameButton({
                    text: '提交',
                    icon: 'send',
                    onClick: function () {
                        that.QrCodeConvertCheckedSumbit();
                    }
                });
                $('#BtnQrSearch').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        $('#InvType').val('Shipment');
                        that.QueryShipQrCode();
                    }
                });
                $('#BtnWinQrAdd').FrameButton({
                    text: '添加',
                    icon: 'plus',
                    onClick: function () {
                        that.AddQrItems();
                    }
                });
                $('#BtnWinQrClose').FrameButton({
                    text: '关闭',
                    icon: 'minus-circle',
                    onClick: function () {
                        $('#winQrCodeCfnLayout').data("kendoWindow").close();
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

    that.QrCodeConvertCheckedSumbit = function () {

        var param = '';
        for (var i = 0; i < chooseProduct.length; i++) {
            param += chooseProduct[i].Id + ',';
        }

        if (param != '') {

            var data = that.GetModel();
            data.ChangeParam = param;
            if (confirm('确定替换？')) {
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'QrCodeConvertChecked',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.ExecuteMessage == "Success") {
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: '二维码替换成功！',
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

        } else {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择需要替换的销售数据！'
            });
        }
    }

    that.AddQrItems = function () {
        if (chooseQrCode.length > 0)
        {
            $('#HidLotId').val(chooseQrCode[0].Id);
            $('#HidWhmId').val(chooseQrCode[0].WHMId);
            $('#WinQrCodeConvertNewQrCode').FrameTextBox('setValue', chooseQrCode[0].QrCode);
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '添加成功！',
                callback: function () {
                    $('#winQrCodeCfnLayout').data("kendoWindow").close();
                }
            });
        }
        else
        {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择要添加的产品！'
            });
        }
    }

    that.QueryShipProduct = function () {
        
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Bind_ShipmentQrCodeDetail',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                $('#RstWinQrCodeConvertList').data("kendoGrid").setOptions({
                    dataSource: model.RstWinQrCodeConvertList
                });
                $('#HidPmaId').val(model.HidPmaId);
                $('#HidShipHeadId').val(model.HidShipHeadId);
                
                FrameWindow.HideLoading();
            }
        });
    }

    var createDetailList = function (detailSource) {
        $("#RstWinQrCodeConvertList").kendoGrid({
            dataSource: detailSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 420,
            columns: [
                {
                    title: "选择", width: 50, encoded: false, 
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '#if(ShippedQty != "" && ShippedQty > 0 && ShippedQty != null){#<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>#}#',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "DealerId", title: "经销商", width: 220, template: function (gridrow) {
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
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "WarehouseName", title: "仓库", width: 150, 
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShipmentNbr", title: "销售单号", width: 100, 
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HospitalName", title: "销售医院", width: 130,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售医院" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubmitDate", title: "提交日期", width: 100, format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "提交日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CustomerFaceNbr", title: "产品型号", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Property1", title: "短编号", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "短编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "产品中文名称", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotNumber", title: "批次号", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "批次号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QRCode", title: "二维码", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ExpiredDate", title: "有效期", width: 100, format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Uom", title: "单位", width: 80, 
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShippedQty", title: "销售数量", width: 80, 
                    headerAttributes: { "class": "text-center text-bold", "title": "销售数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UnitPrice", title: "销售单价", width: 80, 
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单价" },
                    attributes: { "class": "table-td-cell" }
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

                $("#RstWinQrCodeConvertList").find(".Check-Item").unbind("click");
                $("#RstWinQrCodeConvertList").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstWinQrCodeConvertList").data("kendoGrid"),
                    dataItem = grid.dataItem(row);

                    if (checked) {
                        dataItem.IsChecked = true;
                        addItem('product', dataItem);
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeItem('product', dataItem);
                        row.removeClass("k-state-selected");
                    }
                });

                $('#CheckAll').unbind('change');
                $('#CheckAll').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstWinQrCodeConvertList").data("kendoGrid");
                        var data = grid.dataItem(row);

                        if (checked) {
                            addItem('product', data);
                            $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                            $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                        } else {
                            removeItem('product', data);
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
    }

    var clearChooseProduct = function () {
        $('#CheckAll').removeAttr("checked");
        chooseProduct.splice(0, chooseProduct.length);
    }

    var addItem = function (type, data) {
        if (type == 'product') {
            if (!isExists(data)) {
                chooseProduct.push(data);
            }
        }
        else {
            chooseQrCode.splice(0, chooseQrCode.length);
            chooseQrCode.push(data);
        }
    }

    var removeItem = function (type, data) {
        if (type == 'product') {
            for (var i = 0; i < chooseProduct.length; i++) {
                if ((chooseProduct[i].Id && data.Id && chooseProduct[i].Id == data.Id)) {
                    chooseProduct.splice(i, 1);
                    break;
                }
            }
        }
        else {
            chooseQrCode.splice(0, chooseQrCode.length);
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

    that.QueryShipQrCode = function () {
        var grid = $("#RstWinQrCodeCfnList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    var kendoQrSource = GetKendoDataSource(business, 'QueryShipQrCode', null, 10);
    var createQrCfnList = function () {
        $("#RstWinQrCodeCfnList").kendoGrid({
            dataSource: kendoQrSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 350,
            columns: [
                {
                    title: "选择", width: 50, encoded: false,
                    template: '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>',
                    attributes: { "class": "text-center" }
                },
                {
                    field: "CustomerFaceNbr", title: "产品型号",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "产品中文名",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotNumber", title: "批次号",
                    headerAttributes: { "class": "text-center text-bold", "title": "批次号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QrCode", title: "二维码",
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Qty", title: "库存",
                    headerAttributes: { "class": "text-center text-bold", "title": "库存" },
                    attributes: { "class": "table-td-cell" }
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

                $("#RstWinQrCodeCfnList").find(".Check-Item").unbind("click");
                $("#RstWinQrCodeCfnList").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstWinQrCodeCfnList").data("kendoGrid"),
                    dataItem = grid.dataItem(row);

                    if (checked) {
                        dataItem.IsChecked = true;
                        addItem('qrcode', dataItem);
                        $('.Check-Item').not(this).prop('checked', false);
                        $('.Check-Item').not(this).closest("tr").removeClass("k-state-selected");
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeItem('qrcode', dataItem);
                        $('.Check-Item').not(this).prop('checked', false);
                        row.removeClass("k-state-selected");
                    }
                });

            },
            page: function (e) {
            }
        });
    }

    that.ShowNewCfn = function () {
        $("#winQrCodeCfnLayout").kendoWindow({
            title: "Title",
            width: 800,
            height: 500,
            actions: [
                "Close"
            ],
            resizable: false
            //modal: true,
        }).data("kendoWindow").title("添加产品").center().open();
    }

    var setLayout = function () {
    }

    return that;
}();
