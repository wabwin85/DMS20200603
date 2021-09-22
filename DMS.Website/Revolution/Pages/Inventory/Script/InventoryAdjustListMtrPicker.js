var InventoryAdjustListMtrPicker = {};

InventoryAdjustListMtrPicker = function () {
    var that = {};

    var business = 'Inventory.InventoryAdjustListMtrPicker';
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }
    var RstWarehouseListArr = [];
    var StatusPicker = false;
    FrameWindow.ShowLoading();
    that.Init = function () {
        var data = {};
        var MethodName = "Init";
        var Type = Common.GetUrlParam('ChoiceType');
        $('#QryInstanceId').val(Common.GetUrlParam('InstanceId'));
        $('#QryDealerId').val(Common.GetUrlParam('hiddenDealerId'));
        $('#QryProductLineWin').val(Common.GetUrlParam('hiddenProductLineId'));
        if ("1" == Type) {
            //寄售仓库
            MethodName = "ConsignmentInit";
            $('#QryAdjustType').val(Common.GetUrlParam('hiddenAdjustType'));
            $('#QryWarehouseType').val(Common.GetUrlParam('hiddenReturnType'));
        }
        else {
            //普通仓库
            MethodName = "Init";
            $('#QryAdjustType').val(Common.GetUrlParam('hiddenAdjustType'));
            $('#QryWarehouseType').val(Common.GetUrlParam('hiddenReturnType'));
            $('#QryReturnApplyType').val(Common.GetUrlParam('hiddApplyType'));
        }
        data.QryInstanceId = $('#QryInstanceId').val();
        data.QryDealerId = $('#QryDealerId').val();
        data.QryProductLineWin = $('#QryProductLineWin').val();
        data.QryAdjustType = $('#QryAdjustType').val();
        data.QryWarehouseType = $('#QryWarehouseType').val();
        data.QryReturnApplyType = $('#QryReturnApplyType').val();
        FrameUtil.SubmitAjax({
            business: business,
            method: MethodName,
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                RstWarehouseListArr = model.RstWarehouseList;
                $("#IsCFN").val(model.IsCFN);
                StatusPicker = model.IsCFN;
                if (model.IsCFN) {//CFN状态
                    $("#DialogWindow").hide();
                    $("#DialogWindow_CFN").show();

                    $('#QryCFN_CFN').FrameTextBox({
                        value: '',
                        placeholder: '逗点分隔，可多个模糊查询'
                    });
                    $('#QryIsShareCFN').FrameSwitch({
                        onLabel: "是",
                        offLabel: "否",
                        value: "否",
                    });
                    $('#QryUPN_CFN').FrameTextBox({
                        value: '',
                        placeholder: '逗点分隔，可多个模糊查询'
                    });
                    //仓库
                    var wareValue = "";
                    if (model.RstWarehouseList != null) {
                        if (model.RstWarehouseList.length > 0)
                            wareValue = { Key: model.RstWarehouseList[0].Id, Value: model.RstWarehouseList[0].Name }
                    }
                    $('#QryWarehouse2').FrameDropdownList({
                        dataSource: model.RstWarehouseList,
                        dataKey: 'Id',
                        dataValue: 'Name',
                        selectType: 'none',
                        value: wareValue
                    });

                    that.CreateResultList_CFN();
                }
                else {
                    $("#DialogWindow").show();
                    $("#DialogWindow_CFN").hide();

                    $('#QryCFN').FrameTextBox({
                        value: '',
                        placeholder: '逗点分隔，可多个模糊查询'
                    });
                    $('#QryLotNumber').FrameTextBox({
                        value: '',
                        placeholder: '逗点分隔，可多个模糊查询'
                    });
                    $('#QryQrCode').FrameTextBox({
                        value: '',
                        placeholder: '逗点分隔，可多个模糊查询'
                    });
                    //仓库
                    //#{cbWarehouse}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Id'):'');
                    //#{hiddenReve3}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Type'):''); 
                    var wareValue = "";
                    if (model.RstWarehouseList != null) {
                        if (model.RstWarehouseList.length > 0)
                            wareValue = { Key: model.RstWarehouseList[0].Id, Value: model.RstWarehouseList[0].Name }
                    }
                    $('#QryWorehourse').FrameDropdownList({
                        dataSource: model.RstWarehouseList,
                        dataKey: 'Id',
                        dataValue: 'Name',
                        selectType: 'none',
                        value: wareValue
                    });

                    FrameWindow.ShowLoading();
                    that.CreateResultList();
                    that.SetGriHIde();
                }

                $('#BtnOk').FrameButton({
                    text: '确定',
                    icon: 'file',
                    onClick: function () {
                        if (StatusPicker) {//寄售仓库调用
                            if ($('#QryWarehouse2').FrameDropdownList('getValue').Key == "") {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'warning',
                                    message: '请选择移入仓库',
                                });
                                return;
                            }
                        }
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
                                    var QryWarehouse = ""; var QryWarehouse2 = "";
                                    var model = FrameUtil.GetModel();
                                    if (StatusPicker)
                                        QryWarehouse2 = $('#QryWarehouse2').FrameDropdownList('getValue').Key;
                                    else
                                        QryWarehouse = $('#QryWorehourse').FrameDropdownList('getValue').Key;

                                    FrameWindow.SetWindowReturnValue({
                                        target: 'top',
                                        value: [{ Warehouse: QryWarehouse, Warehouse2: QryWarehouse2, res: pickedList }]
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
                $('#BtnQuery_CFN').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
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
    that.SetGriHIde = function () {
        var ReturnType = $("#hiddenReturnType").val();
        if (ReturnType != "Return" && ReturnType != "Exchange") {
            $("#RstResultList").data("kendoGrid").hideColumn('Price');
        }
        else {
            $("#RstResultList").data("kendoGrid").showColumn('Price');
        }
    }
    //变更仓库时获取类型,如果类型时Consignment，LP_Consignment，Borrow，隐藏价格列
    that.ChangeWoreHourse = function (type) {
        var ReturnType = $("#hiddenReturnType").val();
        if (ReturnType == "Return" || ReturnType == "Exchange") {
            if (type == 'Consignment' || type == 'LP_Consignment' || type == 'Borrow') {
                $("#RstResultList").data("kendoGrid").hideColumn('Price');
            }
            else if (type == "DefaultWH" || type == "Normal") {
                $("#RstResultList").data("kendoGrid").showColumn('Price');
            }
        }
        else {
            $("#RstResultList").data("kendoGrid").hideColumn('Price');
        }
    };

    //查询
    that.Query = function () {
        if (!StatusPicker) {
            if ($.trim($('#QryWorehourse').FrameDropdownList('getValue').Key) == "") {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: '请选择仓库',
                });
                return;
            }
        }
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    function GetFnParams() {
        var data = FrameUtil.GetModel();
        //data.QryProductLineWin = data.QryWorehourse.Key;
        return data;
    };
    var fields = {};
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 10, GetFnParams());
    //经销商
    that.CreateResultList = function () {

        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                 {
                     title: "全选", width: '50px', encoded: false,
                     headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                     template: '<input type="checkbox" id="Check_#=LotId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=LotId#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "WarehouseName", title: "分仓库", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "分仓库" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EnglishName", title: "英文名称", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "中文名称", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN", title: "产品型号", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UPN", title: "条形码", width: '120px', hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "条形码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotNumber", title: "序列号/批号", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QRCode", title: "二维码", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotExpiredDate", title: "有效期", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UnitOfMeasure", title: "单位", width: '120px', hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotInvQty", title: "库存数量", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "库存数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Price", title: "产品价格", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品价格" },
                    attributes: { "class": "table-td-cell" }
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
            dataBound: function (e) {
                var grid = e.sender;

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
                $('#CheckAll').removeAttr("checked");
            }
        });
    }

    that.CreateResultList_CFN = function () {

        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                 {
                     title: "全选", width: '50px', encoded: false,
                     headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                     template: '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "CFN", title: "产品型号", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UPN", title: "条形码", width: '120px', hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "条形码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EngName", title: "英文说明", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "英文说明" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChnName", title: "中文说明", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "中文说明" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UnitOfMeasure", title: "单位", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                    attributes: { "class": "table-td-cell" }
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
            dataBound: function (e) {
                var grid = e.sender;

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
                $('#CheckAll').removeAttr("checked");
            }
        });
    }

    var addItem = function (data) {
        debugger
        if (!isExists(data)) {
            pickedList.push((StatusPicker ? data.Id : data.LotId));
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == (StatusPicker ? data.Id : data.LotId)) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == (StatusPicker ? data.Id : data.LotId)) {
                exists = true;
            }
        }
        return exists;
    }



    var setLayout = function () {
    }

    return that;
}();


