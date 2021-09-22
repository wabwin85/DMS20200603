var ConsignTransferInfo = {};

ConsignTransferInfo = function () {
    var that = {};

    var business = 'Consign.ConsignTransferInfo';
    var confirmList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.RstDetailList = $("#RstDetailList").data("kendoGrid").dataSource.data();

        return model;
    }

    that.Init = function () {
        var data = {};
        data.InstanceId = Common.GetUrlParam('InstanceId');

        createDetailList();
        createConfirmList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                var readonly = !(model.ViewMode == "Edit");

                $('#InstanceId').val(model.InstanceId);
                $('#IsNewApply').val(model.IsNewApply);
                $('#IptApplyBasic').DmsApplyBasic({
                    value: model.IptApplyBasic
                });
                $('#IptBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.IptBu,
                    onChange: that.ChangeBu,
                    readonly: !model.IsNewApply
                });
                $('#IptDealerOut').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    parameters: { ProductLine: model.IptBu ? model.IptBu.Key : '' },
                    checkRequire: function (parameters) {
                        var message = [];

                        if (!parameters.ProductLine || parameters.ProductLine == '') {
                            message.push('请选择产品线');
                        }

                        return message;
                    },
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.IptDealerOut,
                    readonly: readonly
                });
                $('#IptDealerIn').FrameDropdownList({
                    value: model.IptDealerIn,
                    readonly: true
                });
                $('#IptHospital').DmsHospitalFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    parameters: { ProductLine: model.IptBu ? model.IptBu.Key : '', DealerId: model.IptDealerIn.Key },
                    checkRequire: function (parameters) {
                        var message = [];

                        if (!parameters.ProductLine || parameters.ProductLine == '') {
                            message.push('请选择产品线');
                        }

                        return message;
                    },
                    dataKey: 'HospitalId',
                    dataValue: 'HospitalName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.IptHospital,
                    readonly: readonly
                });
                $('#IptSales').DmsEmployeeFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    parameters: { ProductLine: model.IptBu ? model.IptBu.Key : '', HospitalID: model.IptHospital ? model.IptHospital.Key : '' },
                    checkRequire: function (parameters) {
                        var message = [];

                        if (!parameters.ProductLine || parameters.ProductLine == '') {
                            message.push('请选择产品线');
                        }
                        //if (!parameters.HospitalID || parameters.HospitalID == '') {
                        //    message.push('请选择医院');
                        //}
                        return message;
                    },
                    dataKey: 'UserAccount',
                    dataValue: 'UserName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.IptSales,
                    readonly: readonly
                });
                $('#IptConsignContract').DmsConsignContract({
                    dataSource: model.LstConsignContract,
                    dataKey: 'ContractId',
                    dataValue: 'ContractName',
                    selectType: 'select',
                    value: model.IptConsignContract,
                    readonly: readonly,
                    onChange: function () {
                        $("#RstDetailList").data("kendoGrid").setOptions({
                            dataSource: []
                        });
                    }
                });
                $('#IptRemark').FrameTextArea({
                    value: model.IptRemark,
                    readonly: readonly
                });

                if (readonly) {
                    $("#RstDetailList").data("kendoGrid").hideColumn('Delete');
                    $("#RstDetailList").data("kendoGrid").hideColumn('QuantityModify');
                } else {
                    $("#RstDetailList").data("kendoGrid").setOptions({
                        selectable: false
                    });
                    $("#RstDetailList").data("kendoGrid").hideColumn('Select');
                    $("#RstDetailList").data("kendoGrid").hideColumn('Quantity');
                    $("#RstDetailList").data("kendoGrid").hideColumn('ConfirmQuantity');

                    $('.panel-confirm-grid').hide();
                }
                $("#RstDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstDetailList
                });

                if (!model.IsNewApply) {
                    $('#RstOperationLog').DmsOperationLog({
                        dataSource: model.RstOperationLog
                    });
                }

                confirmList = model.RstConfirmList;

                if (!readonly) {
                    $('#BtnAddDetail').FrameButton({
                        text: '添加',
                        icon: 'plus',
                        onClick: that.AddDetail
                    });
                    if (!model.IsNewApply) {
                        $('#BtnDelete').FrameButton({
                            text: '删除',
                            icon: 'trash',
                            className: 'btn-danger',
                            onClick: that.Delete
                        });
                    } else {
                        $('#BtnDelete').remove();
                    }
                    $('#BtnSave').FrameButton({
                        text: '保存',
                        icon: 'save',
                        onClick: that.Save
                    });
                    $('#BtnSubmit').FrameButton({
                        text: '提交',
                        icon: 'send',
                        onClick: that.Submit
                    });
                } else {
                    $('#PnlAddDetailButton').remove();
                    $('#BtnAddDetail').remove();
                    $('#BtnSave').remove();
                    $('#BtnSubmit').remove();
                }

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.ChangeBu = function () {
        var data = {};
        data.IptBu = $('#IptBu').FrameDropdownList('getValue');

        $('#IptDealerOut').DmsDealerFilter('setParameter', 'ProductLine', data.IptBu.Key);
        $('#IptDealerOut').DmsDealerFilter('setDataSource', []);
        $('#IptSales').DmsEmployeeFilter('setParameter', 'ProductLine', data.IptBu.Key);
        $('#IptSales').DmsEmployeeFilter('setDataSource', []);
        $('#IptHospital').DmsHospitalFilter('setParameter', 'ProductLine', data.IptBu.Key);
        $('#IptHospital').DmsHospitalFilter('setDataSource', []);
        $("#RstDetailList").data("kendoGrid").setOptions({
            dataSource: []
        });

        if (data.IptBu.Key != '') {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'ChangeBu',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#IptConsignContract').DmsConsignContract('setDataSource', model.LstConsignContract);

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.AddDetail = function () {
        if ($('#IptConsignContract').DmsConsignContract('getValue').ContractId == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择寄售合同'
            });
        }
        else {
            var url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ContractUpnPicker.aspx';
            url = Common.UpdateUrlParams(url, 'ContractId', $('#IptConsignContract').DmsConsignContract('getValue').ContractId);

            FrameWindow.OpenWindow({
                target: 'top',
                title: '产品UPN',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    if (list) {
                        var data = {};
                        data.IptBu = $('#IptBu').FrameDropdownList('getValue');
                        data.LstUpn = list;

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'AddDetail',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                var dataSource = $("#RstDetailList").data("kendoGrid").dataSource.data();

                                for (var i = 0; i < model.LstDetailList.length; i++) {
                                    var exists = false;
                                    for (var j = 0; j < dataSource.length; j++) {
                                        if (dataSource[j].UpnId == model.LstDetailList[i].UpnId) {
                                            exists = true;
                                        }
                                    }

                                    if (!exists) {
                                        $("#RstDetailList").data("kendoGrid").dataSource.add(model.LstDetailList[i]);
                                    }
                                }
                                $("#RstDetailList").data("kendoGrid").dataSource.fetch();

                                FrameWindow.HideLoading();
                            }
                        });
                    }
                }
            });
        }
    }

    that.ChangeUpn = function (upnId, detailId) {
        var itemList = getConfirmItem(upnId);

        $("#RstConfirmList").data("kendoGrid").setOptions({
            dataSource: itemList
        });
    }

    that.Delete = function () {
        var data = {};
        data.InstanceId = $('#InstanceId').val();

        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定删除吗？',
            confirmCallback: function () {
                FrameWindow.ShowLoading();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'Delete',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '删除成功',
                            callback: function () {
                                top.deleteTabsCurrent();
                            }
                        });

                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }

    that.Save = function () {
        var data = that.GetModel();

        console.log(data);
        var message = checkForm(data, 'Save');
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Save',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '保存成功',
                        callback: function () {
                            if (model.IsNewApply) {
                                changeTabsName(model.InstanceId, '寄售转移 - ' + model.IptApplyNo);
                            }

                            var url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignTransferInfo.aspx';
                            url += '?InstanceId=' + model.InstanceId;

                            window.location = url;
                        }
                    });

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.Submit = function () {
        var data = that.GetModel();

        var message = checkForm(data, 'Submit');
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {

            var dataSource = $("#RstDetailList").data("kendoGrid").dataSource.data();
            var UPN = '';
            for (var i = 0; i < dataSource.length; i++) {
                if (dataSource[i].Quantity == 0) {
                    UPN = UPN + dataSource[i].UpnNo + '<br/>'
                }
            }
            if (UPN != '') {


                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: '以下UPN申请数量必须大于0:<br/>' + UPN + '',
                });
                FrameWindow.HideLoading();
            }
            else {
                FrameWindow.ShowConfirm({
                    target: 'top',
                    message: '确定提交吗？',
                    confirmCallback: function () {
                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'Submit',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'info',
                                    message: '提交成功',
                                    callback: function () {
                                        if (model.IsNewApply) {
                                            changeTabsName(model.InstanceId, '寄售转移 - ' + model.IptApplyNo);
                                        }

                                        var url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignTransferInfo.aspx';
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

    var checkForm = function (data, status) {
        var message = [];

        if (data.IptBu.Key == '') {
            message.push('请选择产品线');
        }

        if (status == 'Submit') {
            if (data.IptDealerOut.Key == '') {
                message.push('请选择移出经销商');
            }
            //if (data.IptHospital.Key == '') {
            //    message.push('请选择医院');
            //}
            if (data.IptRemark == '') {
                message.push('请填写转移原因');
            }
            if (data.IptConsignContract.ContractId == '') {
                message.push('请选择寄售合同');
            }
            if (data.RstDetailList.length == 0) {
                message.push('请添加需要转移的产品');
            }
            if (data.IptSales.Key == '') {
                message.push('请选择销售');
            }
            //if (data.IptConsignContract.ConsignDay<=15) {
            //    message.push('请选择医院');
            //}

        }

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
                    attributes: { "class": "text-right" },
                    footerTemplate: "合计",
                    footerAttributes: { "class": "text-center" }
                },
                {
                    field: "Select", title: "选择", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "选择", "style": "vertical-align: middle;" },
                    template: "<i class='fa fa-list item-select' style='font-size: 14px; cursor: pointer;'></i>",
                    attributes: { "class": "text-center text-bold" }
                },
                {
                    field: "Delete", title: "删除", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;" },
                    template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
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
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" },

                },
                {
                    field: "QuantityModify", title: "数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                    template: "<input class='k-textbox item-quantity' style='width:100%;' data-value='#=Quantity#' value='#=kendo.toString(Quantity, \"N0\")#' />",
                    footerTemplate: "<span id='Iptsum' />",
                    footerAttributes: { "class": "text-right" }
                },
                {
                    field: "Quantity", title: "数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                    attributes: { "class": "text-right" },
                    format: "{0:N0}",
                    footerTemplate: "<span id='Iptsum1' />",
                    footerAttributes: { "class": "text-right" }
                },
                {
                    field: "Price", title: "单价", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单价" },
                    attributes: { "class": "text-right" },
                    format: "{0:N2}"
                },
                {
                    field: "Total", title: "小计", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "小计" },
                    attributes: { "class": "text-right" },
                    format: "{0:N2}",
                    footerTemplate: "<span id='IptTotal' />",
                    footerAttributes: { "class": "text-right" }
                },
                {
                    field: "ConfirmQuantity", title: "确认数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "确认数量" },
                    attributes: { "class": "text-right" },
                    format: "{0:N0}"
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

                $("#RstDetailList").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $("#RstDetailList").data("kendoGrid").dataSource.remove(data);

                    calcTotal();
                });

                $("#RstDetailList").find(".item-quantity").on('focus', function () {
                    $(this).attr('type', 'number')
                    $(this).val($(this).data('value'));
                });
                $("#RstDetailList").find(".item-quantity").on('blur', function () {
                    $(this).attr('type', 'text')
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    data.Quantity = $(this).val() ? parseInt($(this).val()) : 0;
                    data.Total = data.Quantity * data.Price;

                    $("#RstDetailList").data("kendoGrid").dataSource.fetch();

                    calcTotal();
                });

                calcTotal();
            }
        });
    }

    var calcTotal = function () {
        var total = 0;
        var sum = 0;
        for (var i = $("#RstDetailList").data("kendoGrid").dataSource.data().length - 1; i >= 0; i--) {
            var item = $("#RstDetailList").data("kendoGrid").dataSource.data().at(i);
            total += item.Total;
            sum += item.Quantity;
        }
        $('#IptTotal').html(kendo.toString(total, "N2"));
        $('#Iptsum').html(kendo.toString(sum, "N0"));
        $('#Iptsum1').html(kendo.toString(sum, "N0"));
    }

    var createConfirmList = function () {
        $("#RstConfirmList").kendoGrid({
            dataSource: [],
            columns: [
                {
                    title: "序号", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "序号" },
                    template: "<span class='row-number'></span>",
                    attributes: { "class": "text-right" }
                },
                {
                    field: "WarehouseName", title: "仓库", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" },
                },
                {
                    field: "Lot", title: "批号", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" }
                },
                {
                    field: "QrCode", title: "二维码", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                }
            ],
            dataBound: function (e) {
                var grid = e.sender;
                var rows = this.items();

                $(rows).each(function () {
                    var index = $(this).index() + 1;
                    var rowLabel = $(this).find(".row-number");
                    $(rowLabel).html(index);
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

    var setLayout = function () {
    }

    return that;
}();
