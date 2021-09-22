var ConsignTransferConfirm = {};

ConsignTransferConfirm = function () {
    var that = {};

    var business = 'Consign.ConsignTransferConfirm';
    var confirmList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.RstConfirmList = confirmList;

        return model;
    }

    that.Init = function () {
        var data = {};
        data.InstanceId = Common.GetUrlParam('InstanceId');

        createDetailList();
        createInventoryList();
        createConfirmList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                var readonly = !(model.ViewMode == "Edit");

                $('#InstanceId').val(model.InstanceId);
                $('#IptApplyBasic').DmsApplyBasic({
                    value: model.IptApplyBasic
                });
                $('#IptBu').FrameLabel({
                    value: model.IptBu
                });
                $('#IptDealerOut').FrameLabel({
                    value: model.IptDealerOut
                });
                $('#IptDealerIn').FrameLabel({
                    value: model.IptDealerIn
                });
                $('#IptHospital').FrameLabel({
                    value: model.IptHospital
                });
                $('#IptSales').FrameLabel({
                    value: model.IptSales
                });
                $('#IptRemark').FrameLabel({
                    value: model.IptRemark
                });

                $("#RstDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstDetailList
                });

                confirmList = model.RstConfirmList;

                if (!readonly) {
                    $('#BtnConfirm').FrameButton({
                        text: '确认提交',
                        icon: 'send',
                        onClick: that.Confirm
                    });
                } else {
                    $("#RstConfirmList").data("kendoGrid").hideColumn('Delete');

                    $('.panel-confirming').remove();
                    $('.panel-confirmed').css('width', '').removeClass('col-xs-5').addClass('col-xs-12');
                    $('.panel-confirmed-row').css('border-left', '');
                    $('#BtnConfirm').remove();
                }

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.ChangeUpn = function (upnId, detailId) {
        if ($("#RstInventoryList").length > 0) {
            var data = {};
            data.InstanceId = $('#InstanceId').val();
            data.IptUpnId = upnId;
            data.IptDetailId = detailId;

            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'ChangeUpn',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    var itemList = getConfirmItem(model.IptUpnId);
                    var inventoryList = model.RstInventoryList;

                    for (var i = inventoryList.length - 1; i >= 0; i--) {
                        for (var j = 0; j < itemList.length; j++) {
                            if (inventoryList[i].LotMasterId == itemList[j].LotMasterId) {
                                inventoryList.splice(i, 1);
                                break;
                            }
                        }
                    }

                    $("#RstInventoryList").data("kendoGrid").setOptions({
                        dataSource: inventoryList
                    });
                    $("#RstConfirmList").data("kendoGrid").setOptions({
                        dataSource: itemList
                    });

                    FrameWindow.HideLoading();
                }
            });
        } else {
            var itemList = getConfirmItem(upnId);

            $("#RstConfirmList").data("kendoGrid").setOptions({
                dataSource: itemList
            });
        }
    }

    that.Confirm = function () {
        var data = that.GetModel();
        console.log(data);

        var message = checkForm(data);
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {

            var dataSource = $("#RstDetailList").data("kendoGrid").dataSource.data();
            var count = 0;
            for (var i = 0; i < dataSource.length; i++) {
                if ($('#Confirm_' + dataSource[i].UpnId).html() == 0) {
                    count++;
                }
            }
            if (count == dataSource.length) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: '请确认转移产品后提交',
                });
                FrameWindow.HideLoading();
            }
            else {
                FrameWindow.ShowConfirm({
                    target: 'top',
                    message: '确认转移申请吗？',
                    confirmCallback: function () {
                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'Confirm',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'info',
                                    message: '操作成功',
                                    callback: function () {
                                        var url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignTransferConfirm.aspx';
                                        url += '?InstanceId=' + model.InstanceId;
                                        window.location = url;
                                    }
                                });
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                });
            }

        }
    }

    var checkForm = function (data) {
        var message = [];

        return message;
    }

    var createDetailList = function () {
        $("#RstDetailList").kendoGrid({
            dataSource: [],
            scrollable: true,
            selectable: true,
            columns: [
                {
                    title: "序号", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "序号" },
                    template: "<span class='row-number'></span>",
                    attributes: { "class": "text-right" }
                },
                {
                    title: "选择", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "选择", "style": "vertical-align: middle;" },
                    template: "<i class='fa fa-list item-select' style='font-size: 14px; cursor: pointer;'></i>",
                    attributes: { "class": "text-center text-bold" }
                },
                {
                    field: "UpnNo", title: "产品UPN", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品UPN" },
                },
                {
                    field: "UpnShortNo", title: "产品短编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品短编号" }
                },
                {
                    field: "UpnName", title: "产品中文名/英文名", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名/英文名" },
                    template: "#=UpnName# / #=UpnEngName#"
                },
                {
                    field: "Unit", title: "单位", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "Quantity", title: "申请数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                    attributes: { "class": "text-right" },
                    template: "<span id='Apply_#=UpnId#'>#=kendo.toString(Quantity, 'N0')#</span>"
                },
                {
                    field: "ConfirmQuantity", title: "确认数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "确认数量" },
                    attributes: { "class": "text-right" },
                    template: "<span id='Confirm_#=UpnId#'>#=kendo.toString(ConfirmQuantity, 'N0')#</span>"
                },
                {
                    field: "Difference", title: "差异", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "差异" },
                    attributes: { "class": "text-right" },
                    template: "<span id='Difference_#=UpnId#'>#=kendo.toString(Difference, 'N0')#</span>"
                }
            ],
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            change: function (e) {
                var selected = this.select();
                var item = this.dataItem(selected);
                that.ChangeUpn(item.UpnId, item.DetailId);
            },
            dataBound: function (e) {
                var grid = e.sender;
                var rows = this.items();

                $(rows).each(function () {
                    var index = $(this).index() + 1;
                    var rowLabel = $(this).find(".row-number");
                    $(rowLabel).html(index);
                });

                var total = 0;
                for (var i = $("#RstDetailList").data("kendoGrid").dataSource.data().length - 1; i >= 0; i--) {
                    var item = $("#RstDetailList").data("kendoGrid").dataSource.data().at(i);
                    total += item.Total;
                }
                $('#IptTotal').html(kendo.toString(total, "N2"));
            }
        });
    }

    var createInventoryList = function () {
        $("#RstInventoryList").kendoGrid({
            dataSource: [],
            height: 400,
            columns: [
                {
                    title: "序号", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "序号" },
                    template: "<span class='row-number'></span>",
                    attributes: { "class": "text-right" }
                },
                {
                    title: "选择", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "选择", "style": "vertical-align: middle;" },
                    template: "<i class='fa fa-check item-select' style='font-size: 14px; cursor: pointer;'></i>",
                    attributes: { "class": "text-center text-bold" }
                },
                {
                    field: "WarehouseName", title: "仓库", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" },
                },
                {
                    field: "Lot", title: "批号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" }
                },
                {
                    field: "QrCode", title: "二维码", width: '130px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                }
            ],
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;
                var rows = this.items();

                $(rows).each(function () {
                    var index = $(this).index() + 1;
                    var rowLabel = $(this).find(".row-number");
                    $(rowLabel).html(index);
                });

                $("#RstInventoryList").find(".item-select").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    var confirm = $('#Confirm_' + data.UpnId);
                    var difference = $('#Difference_' + data.UpnId);

                    if (parseInt(difference.html()) >= 0) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: '确认数量不能超过申请数量',
                        });
                    } else {
                        kendo.fx(tr).transfer($("#RstConfirmList"))
                                    .duration(500)
                                    .play()
                                    .then(function () {
                                        $(this).remove();
                                    });

                        var itemList = getConfirmItem(data.UpnId);

                        itemList.push(data);
                        setConfirmItem(data.UpnId, itemList);

                        $("#RstConfirmList").data("kendoGrid").setOptions({
                            dataSource: itemList
                        });
                        $("#RstInventoryList").data("kendoGrid").dataSource.remove(data);

                        confirm.html(kendo.toString(parseInt(confirm.html()) + 1, "N0"));
                        difference.html(kendo.toString(parseInt(difference.html()) + 1, "N0"));
                    }
                });
            }
        });
    }

    var createConfirmList = function () {
        $("#RstConfirmList").kendoGrid({
            dataSource: [],
            height: 400,
            columns: [
                {
                    title: "序号", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "序号" },
                    template: "<span class='row-number'></span>",
                    attributes: { "class": "text-right" }
                },
                {
                    field: "Delete", title: "移除", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "移除", "style": "vertical-align: middle;" },
                    template: "<i class='fa fa-close item-remove' style='font-size: 14px; cursor: pointer;'></i>",
                    attributes: { "class": "text-center text-bold" }
                },
                {
                    field: "WarehouseName", title: "仓库", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" },
                },
                {
                    field: "Lot", title: "批号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" }
                },
                {
                    field: "QrCode", title: "二维码", width: '130px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                }
            ],
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;
                var rows = this.items();

                $(rows).each(function () {
                    var index = $(this).index() + 1;
                    var rowLabel = $(this).find(".row-number");
                    $(rowLabel).html(index);
                });

                $("#RstConfirmList").find(".item-remove").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    var confirm = $('#Confirm_' + data.UpnId);
                    var difference = $('#Difference_' + data.UpnId);

                    kendo.fx(tr).transfer($("#RstInventoryList"))
                                .duration(500)
                                .play()
                                .then(function () {
                                    $(this).remove();
                                });

                    var itemList = getConfirmItem(data.UpnId);
                    for (var i = 0; i < itemList.length; i++) {
                        if (itemList[i].QrCode == data.QrCode) {
                            itemList.splice(i, 1);
                            break;
                        }
                    }
                    setConfirmItem(data.UpnId, itemList);

                    $("#RstInventoryList").data("kendoGrid").dataSource.add(data);
                    $("#RstConfirmList").data("kendoGrid").dataSource.remove(data);

                    confirm.html(kendo.toString(parseInt(confirm.html()) - 1, "N0"));
                    difference.html(kendo.toString(parseInt(difference.html()) - 1, "N0"));
                });
            }
        });
    }

    var getConfirmItem = function (upnId) {
        var item;
        for (var i = 0; i < confirmList.length; i++) {
            if (confirmList[i].UpnId == upnId) {
                item = confirmList[i].ItemList;
            }
        }
        if (!item) {
            item = [];
            confirmList.push({ UpnId: upnId, ItemList: [] });
        }
        return item;
    }

    var setConfirmItem = function (upnId, itemList) {
        for (var i = 0; i < confirmList.length; i++) {
            if (confirmList[i].UpnId == upnId) {
                confirmList[i].ItemList = itemList;
            }
        }
    }

    var setLayout = function () {
    }

    return that;
}();
