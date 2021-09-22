
var OrderCfnDialogPicker = {};

OrderCfnDialogPicker = function () {
    var that = {};

    var business = 'Order.OrderCfnDialogPicker';
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    $('#QryProductLine').val(Common.GetUrlParam('hidProductLine'));
    $('#QryDealer').val(Common.GetUrlParam('hidDealerId'));
    $("#InstanceId").val(Common.GetUrlParam('hidInstanceId'));
    var ptid = Common.GetUrlParam('ptid');
    var str = ptid.split("@");
    $("#hidPriceTypeId").val(str[0]);
    if (str.length > 1) {
        $("#hidOrderType").val(str[1]);
    }

    that.Init = function () {
        FrameWindow.ShowLoading();

        $('#QryCFN').FrameTextBox({
            placeholder: '逗点分隔，可多个模糊查询',
            value: ''
        });
        $('#QryCFNName').FrameTextBox({
            placeholder: '逗点分隔，可多个模糊查询',
            value: ''
        });

        $('#DisplayCanOrder').FrameSwitch({
            onLabel: "是",
            offLabel: "否",
            value: "是",
        });

        that.CreateResultList();

        $('#BtnOk').FrameButton({
            text: '确定',
            icon: 'file',
            onClick: function () {
                if (pickedList.length == 0) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: '确认要添加选中的产品',


                    });
                } else {
                    FrameWindow.ShowConfirm({
                        target: 'top',
                        message: '确认要添加选中的产品吗？',
                        confirmCallback: function () {
                            FrameWindow.SetWindowReturnValue({
                                target: 'top',
                                value: pickedList
                            });

                            FrameWindow.CloseWindow({
                                target: 'top'
                            });
                        }
                    });

                }
            }
        });
        $('#BtnClose').FrameButton({
            text: '关闭',
            icon: 'remove',
            onClick: function () {
                FrameWindow.CloseWindow({
                    target: 'top'
                });
            }
        });
        $('#BtnQuery').FrameButton({
            text: '查询',
            icon: 'search',
            onClick: function () {
                that.Query();
            }
        });
        $('#BtnCfnInfo').FrameButton({
            text: '查询产品是否可订购',
            icon: 'search',
            onClick: function () {
                that.BtnCfnInfo();
            }
        });

        $(window).resize(function () {
            setLayout();
        })
        setLayout();

        //FrameWindow.HideLoading();

    }


    //查询
    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    function GetFnParams() {
        var data = FrameUtil.GetModel();
        return data;
    };
    var fields = {
        ShipmentQtyDialog: { type: "number", validation: { required: true, decimals: 0, min: 1 } }
    };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 8, GetFnParams);
    //经销商
    that.CreateResultList = function () {

        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            columns: [
                 {
                     title: "全选", width: '50px', encoded: false, editable: true,
                     headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                     template: "#if(data.IsCanOrder=='是'){#" +
                         '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>' +
                         '#}#',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "CustomerFaceNbr", title: "产品型号", width: '150px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EnglishName", title: "产品英文名称", width: '150px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "产品中文名称", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Price", title: "产品单价", width: '120px', editable: true, template: function (gridrow) { if (gridrow.Price == null || "" == gridrow.Price || undefined == gridrow.Price) gridrow.Price = 0; return gridrow.Price },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品单价" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UOM", title: "包装", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "包装" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ConvertFactor", title: "单位数量", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "单位数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "是否可下订单", width: "50px", editable: true,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if (IsCanOrder=='是'){#" +
                                   '是' +
                                "#}else{#" +
                                    '否' +
                                "#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "CurGMKind", title: "产品类别", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品类别" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CurGMCatalog", title: "产品分类代码", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类代码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CurRegNo", title: "注册证编号-1", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-1" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CurManuName", title: "生产企业(注册证-1)", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业(注册证-1)" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LastRegNo", title: "注册证编号-2", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-2" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LastManuName", title: "生产企业(注册证-2)", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业(注册证-2)" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShipmentQtyDialog", title: "销售数量(个)", width: '120px', editable: false, format: "{0:N0}", template: function (gridrow) { if (gridrow.ShipmentQtyDialog == null || "" == gridrow.ShipmentQtyDialog || undefined == gridrow.ShipmentQtyDialog) gridrow.ShipmentQtyDialog = gridrow.PackageFactor; return gridrow.ShipmentQtyDialog },
                    headerAttributes: { "class": "text-center text-bold", "title": "销售数量(个)" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PackageFactor", title: "发货规格", width: '60px', editable: true,
                    headerAttributes: {
                        "class": "text-center text-bold", "title": "发货规格"
                    }, attributes: { "class": "table-td-cell" }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            edit: function (e) {
                var grid = e.sender;
                var tr = $(e.container).closest("tr");
                var data = grid.dataItem(tr);
                var Qty = e.container.find("input[name=ShipmentQtyDialog]");

                Qty.change(function (b) {
                    for (var i = 0; i < pickedList.length; i++) {
                        if (pickedList[i].split('@')[0] == data.Id) {
                            if ($(this).val() % data.PackageFactor != 0) {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'Info',
                                    message: '订购数量必须为发货规格的整数倍',
                                });
                                $(this).val(data.PackageFactor);
                            }
                            else {
                                pickedList[i] = data.Id + "@" + $(this).val();
                            }
                            break;
                        }
                    }
                });
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstResultList").find(".Check-Item").unbind("click");
                $("#RstResultList").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstResultList").data("kendoGrid"),
                    dataItem = grid.dataItem(row);

                    if (checked) {
                        if (dataItem.ShipmentQtyDialog % dataItem.PackageFactor != 0) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'Info',
                                message: '订购数量必须为发货规格的整数倍',
                            });
                            $(row).find(".Check-Item").prop("checked", false);
                            return
                        }
                        else {
                            dataItem.IsChecked = true;
                            addItem(dataItem);
                            row.addClass("k-state-selected");
                        }
                    } else {
                        dataItem.IsChecked = false;
                        removeItem(dataItem);
                        row.removeClass("k-state-selected");
                    }
                });

                $('#CheckAll').unbind('change');
                $('#CheckAll').on('change', function (ev) {
                    var checked = ev.target.checked;
                    var blNum = false;
                    $('.Check-Item').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstResultList").data("kendoGrid");
                        var data = grid.dataItem(row);

                        if (checked) {
                            if (data.ShipmentQtyDialog % data.PackageFactor != 0) {
                                blNum = true;
                                $(row).find(".Check-Item").prop("checked", false);
                                return
                            }
                            else {
                                addItem(data);
                                $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                                $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                            }
                        } else {
                            removeItem(data);
                            $(this).prop("checked", false); //此处设置每行的checkbox不选中，必须用prop方法
                            $(this).closest("tr").removeClass("k-state-selected");  //设置grid 每一行不选中
                        }
                    });
                    if (blNum) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'Info',
                            message: '存在订购数量不符合发货规格条目，并已排除！',
                        });
                    }
                });
                FrameWindow.HideLoading();
            },
            page: function (e) {
                $('#CheckAll').removeAttr("checked");
            }
        });
    }


    var addItem = function (data) {
        if (data.ShipmentQtyDialog == "" || data.ShipmentQtyDialog == undefined) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '确认选中产品的销售个数大于0',
            });
            return;
        }
        if (!isExists(data)) {
            pickedList.push(data.Id + '@' + data.ShipmentQtyDialog);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id + '@' + data.ShipmentQtyDialog) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id + '@' + data.ShipmentQtyDialog) {
                exists = true;
            }
        }
        return exists;
    }


    that.BtnCfnInfo = function () {
        var model = FrameUtil.GetModel();
        top.createTab({
            id: 'M2_OrderApplyForT2_OACfnNotOrder',
            title: '产品不可订购信息查询',
            url: 'Revolution/Pages/Order/CfnnotorderInfo.aspx?Cfn=' + model.QryCFN
        });
        FrameWindow.CloseWindow({
            target: 'top'
        });
    };

    var setLayout = function () {
    }

    return that;
}();

