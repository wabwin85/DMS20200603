var OrderCfnSetDialogLPPicker = {};
//平台及一级经销商成套产品添加
OrderCfnSetDialogLPPicker = function () {
    var that = {};

    var business = 'Order.OrderCfnSetDialogLPPicker';
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {

        $('#QryProductLine').val(Common.GetUrlParam('hidProductLine'));
        $('#QryDealer').val(Common.GetUrlParam('hidDealerId'));
        $("#InstanceId").val(Common.GetUrlParam('InstanceId'));
        $("#hidPriceTypeId").val(Common.GetUrlParam('hidPriceType'));
        $("#hidOrderTypeId").val(Common.GetUrlParam('hidOrderType'));

        FrameWindow.ShowLoading();
        that.CreateResultList();
        that.CreateRstResultDetailList();


        $('#QryProtectName').FrameTextBox({
            value: ''
        });
        $('#QryUpn').FrameTextBox({
            value: ''
        });

        $('#BtnAdd').FrameButton({
            text: '添加',
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
                that.SerarchQuery();
            }
        });

        //FrameWindow.HideLoading();
    }

    //添加
    that.DoAddCfnSet = function () {
        var data = FrameUtil.GetModel();
        data.InstanceId = $("#HeaderId").val();
        data.QryDealer = $("#QryDealer").val();
        if (pickedList.length == 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择要添加的成套产品'
            });
        }
        else {
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

    //详情
    that.CreateRstResultDetailList = function (dataSource) {

        $("#RstResultDetailList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    field: "UPN", title: "产品型号", width: '180px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "产品中文名称", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EnglishName", title: "产品英文名称", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Price", title: "产品单价", width: '80px', template: function (gridrow) { if (gridrow.Price == null || "" == gridrow.Price || undefined == gridrow.Price) gridrow.Price = 0; return gridrow.Price },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品单价" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DiscountRate", title: "组套折扣", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "组套折扣" },
                    attributes: { "class": "table-td-cell", "style": "color:red" }, template: function (gridrow) { return (gridrow.DiscountRate) + "%" },
                },
                {
                    field: "DiscountPrice", title: "折后单价", width: '80px', template: function (gridrow) { if (gridrow.DiscountPrice == null || "" == gridrow.DiscountPrice || undefined == gridrow.DiscountPrice) gridrow.DiscountPrice = 0; return gridrow.DiscountPrice },
                    headerAttributes: { "class": "text-center text-bold", "title": "折后单价" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DefaultQuantity", title: "默认数量", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "默认数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PackagePrice", title: "组套后总价", width: '80px', template: function (gridrow) { if (gridrow.PackagePrice == null || "" == gridrow.PackagePrice || undefined == gridrow.PackagePrice) gridrow.PackagePrice = 0; return gridrow.PackagePrice },
                    headerAttributes: { "class": "text-center text-bold", "title": "组套后总价" },
                    attributes: { "class": "table-td-cell" }
                },
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
        });
    }


    that.SerarchQuery = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    };

    function GetFnParams() {
        var data = {};
        return data;
    };
    var fields = {
        RequiredQty: { type: "number", decimals: 0, validation: { required: false, min: 1, defaultvalue: 1, format: "{0:N0}" } }
    };
    var kendoDataSource = GetKendoDataSource(business, 'SerarchQuery', fields, 5);
    //UPN
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
                     template: '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "UPN", title: "UPN", width: '150px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "UPN" }
                },
                {
                    field: "ChineseName", title: "成套产品中文名称", width: '150px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "成套产品中文名称" }
                },
                {
                    field: "EnglishName", title: "成套产品英文名称", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "成套产品英文名称" }
                },
                {
                    field: "RequiredQty", title: "订购数量", width: '120px', editable: false, template: function (gridrow) { if (gridrow.RequiredQty == null || "" == gridrow.RequiredQty || undefined == gridrow.RequiredQty) gridrow.RequiredQty = 1; return gridrow.RequiredQty },
                    headerAttributes: { "class": "text-center text-bold", "title": "订购数量" }
                },
                {
                    field: "DiscountRate", title: "组套折扣", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "组套折扣" },
                    attributes: { "style": "color:red" }, template: function (gridrow) { return (gridrow.DiscountRate) + "%" },
                },
                {
                    title: "明细", width: "50px", editable: true,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if (1==1) {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

            ],
            editable: true,
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
                var Qty = e.container.find("input[name=RequiredQty]");

                Qty.change(function (b) {
                    for (var i = 0; i < pickedList.length; i++) {
                        if (pickedList[i].split('|')[0] == data.Id) {
                            pickedList[i] = data.Id + "|" + $(this).val();
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
                        if (dataItem.RequiredQty == "" || dataItem.RequiredQty == undefined) {
                            $(this).prop("checked", false);
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: '确认选中产品的订购数量大于0',
                            });
                        } else {
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
                //明细点击
                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.openSelectInfo(data.Id);
                });
                FrameWindow.HideLoading();
            },
            page: function (e) {
                $('#CheckAll').removeAttr("checked");
            }
        });
    }

    //明细查询
    that.openSelectInfo = function (CfnSetId) {
        var data = FrameUtil.GetModel();
        data.CfnSetId = CfnSetId;
        data.Page = 1;
        data.PageSize = 10;
        data.DataCount = 0;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Query',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstResultDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultDetailList
                });

                FrameWindow.HideLoading();
            }
        });
    };

    //组套


    var addItem = function (data) {
        if (!isExists(data)) {
            pickedList.push(data.Id + "|" + data.RequiredQty);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id + "|" + data.RequiredQty) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id + "|" + data.RequiredQty) {
                exists = true;
            }
        }

        return exists;
    }



    var setLayout = function () {
    }

    return that;
}();
