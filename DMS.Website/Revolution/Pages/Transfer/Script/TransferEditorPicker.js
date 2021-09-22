var TransferEditorPicker = {};

TransferEditorPicker = function () {
    var that = {};

    var business = 'Transfer.TransferEditorPicker';
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }
    $('#QryTransferType').val(Common.GetUrlParam('TransferType'));
    $('#QryInstanceId').val(Common.GetUrlParam('InstanceId'));
    $('#QryDealerFromId').val(Common.GetUrlParam('DealerFromId'));
    $('#QryDealerToId').val(Common.GetUrlParam('DealerToId'));
    $('#QryProductLineWin').val(Common.GetUrlParam('ProductLineWin'));
    $('#QryWarehouseWin').val(Common.GetUrlParam('WarehouseWin'));

    that.Init = function () {
        var data = {};
        data.QryTransferType = $('#QryTransferType').val();
        data.QryInstanceId = $('#QryInstanceId').val();
        data.QryDealerFromId = $('#QryDealerFromId').val();
        data.QryDealerToId = $('#QryDealerToId').val();
        data.QryProductLineWin = $('#QryProductLineWin').val();
        data.QryWarehouseWin = $('#QryWarehouseWin').val();

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
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
                
                if (model.RstTransferWarehouseList != null) {
                    if (model.RstTransferWarehouseList.length > 0) {
                        model.QryDealer = { Key: model.RstTransferWarehouseList[0].Id, Value: model.RstTransferWarehouseList[0].Name };
                    }
                }
                $('#QryWorehourse').FrameDropdownList({
                    dataSource: model.RstTransferWarehouseList,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    readonly: model.IsDealer ? true : false,
                    value: model.QryDealer
                });
                //$('#DisplayCanOrder').FrameSwitch({
                //    onLabel: "是",
                //    offLabel: "否",
                //    value: "是",
                //});

                that.CreateResultList([]);

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

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });

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
                    field: "LotInvQty", title: "库存数量", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "库存数量" },
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
        if (!isExists(data)) {
            pickedList.push(data.LotId);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.LotId) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.LotId) {
                exists = true;
            }
        }
        return exists;
    }



    var setLayout = function () {
    }

    return that;
}();

