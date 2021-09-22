/// <reference path="ConsignmentPicker.js" />
var TransferListInfo = {};

TransferListInfo = function () {
    var that = {};

    var business = 'Transfer.TransferListInfo';
    var CustomerFaceNbr = [];
    var g = 0;
    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.RstDetailList = $("#RstProductDetail").data("kendoGrid").dataSource.data();
        return model;
    }
    var EditColumnArray = [];//编辑列
    var EntityModel = {};
    var LstBuArr = "";
    var LstStatusArr = "";
    var LstLstDealerToListArr = "";

    that.Init = function () {
        var data = {};
        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.QryTransType = Common.GetUrlParam('Type');
        $("#QryTransferType").val("Rent");
        $('#IsNewApply').val(Common.GetUrlParam('IsNew'));

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                EntityModel = JSON.parse(model.EntityModel);

                LstBuArr = model.LstBu;
                LstStatusArr = model.LstStatus;
                LstLstDealerToListArr = model.LstDealerToList;
                $("#hidDealerId").val(model.DealerId);
                $("#hiddenDealerToDefaultWarehouseId").val(model.hiddenDealerToDefaultWarehouseId);

                $('#InstanceId').val(model.InstanceId);
                $("#QryDealerFromId").val(EntityModel.FromDealerDmaId);
                $("#QryDealerToId").val(EntityModel.ToDealerDmaId);

                $("#ProductLineId").val(EntityModel.ProductLineBumId == null ? model.LstBu[0].Key : EntityModel.ProductLineBumId);

                //经销商
                var DealerName = "";
                $.each(model.LstDealer, function (index, val) {
                    if (EntityModel.FromDealerDmaId === val.Id)
                        DealerName = val.ChineseShortName;
                })
                $('#QryDealerFromWin').FrameDropdownList({
                    dataSource: model.LstDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'select',
                    filter: 'contains',
                    value: { Key: EntityModel.FromDealerDmaId, Value: DealerName },
                });

                $('#QryNumber').FrameTextBox({
                    value: EntityModel.TransferNumber,
                });
                $('#QryNumber').FrameTextBox('disable');
                //出库时间
                $('#QryDate').FrameTextBox({
                    value: model.QryDate,
                });
                $('#QryDate').FrameTextBox('disable');

                var BuName = "";
                $.each(model.LstBu, function (index, val) {
                    if (dms.common.ToLowerCaseFn(EntityModel.ProductLineBumId) === dms.common.ToLowerCaseFn(val.Key))
                        BuName = val.Value;
                })

                $('#QryProductLineWin').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: EntityModel.ProductLineBumId == null ? model.LstBu[0] : { Key: EntityModel.ProductLineBumId, Value: BuName },
                    onChange: function (s) {
                        that.ProductLineChange(this.value);
                    }
                });
                //借入经销商
                var DealerToWinName = "";
                $.each(model.LstDealerToList, function (index, val) {
                    if (model.hiddenDealerToId === val.Id)
                        DealerToWinName = val.ChineseShortName;
                })
                $('#QryDealerToWin').FrameDropdownList({
                    dataSource: model.LstDealerToList,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'none',
                    filter: "contains",
                    value: { Key: model.hiddenDealerToId, Value: DealerToWinName },
                    onChange: function (s) {
                        that.DealerToChange(this.value);
                    }
                });

                //状态
                var StatusName = "";
                $.each(model.LstStatus, function (index, val) {
                    if (EntityModel.Status === val.Key)
                        StatusName = val.Value;
                })
                $('#QryStatus').FrameTextBox({
                    value: StatusName,
                });
                $('#QryStatus').FrameTextBox('disable');

                //绑定经销商。产品明细 。操作日志等
                createRstProductDetail(model.RstProductDetail);
                $('#RstOperationLog').DmsOperationLog({
                    dataSource: model.RstLogDetail
                });

                that.InitWindows(EntityModel, model.IsDealer);

                //列显示控制*******************
                that.EditColumn();
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();


                FrameWindow.HideLoading();
            }
        });
    }

    that.InitWindows = function (mainData, IsDealer) {
        //窗口状态控制
        $('#QryDealerFromWin').FrameDropdownList('disable');
        $('#QryProductLineWin').FrameDropdownList('disable');
        $('#QryDealerToWin').FrameDropdownList('disable');
        that.removeButton('BtnSave');
        that.removeButton('BtnDelete');
        that.removeButton('BtnSubmit');
        that.removeButton('BtnRevoke');
        that.removeButton('BtnAddProduct');
        $("#RstProductDetail").data("kendoGrid").hideColumn('TransferQty');//10
        //$("#RstProductDetail").data("kendoGrid").hideColumn('TransferQty');//11
        $("#RstProductDetail").data("kendoGrid").columns[10].editable = true;
        //$("#RstProductDetail").data("kendoGrid").columns[12].editable = true;
        $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');//13
        if (IsDealer) {
            if (mainData.Status == "Draft") {
                $('#QryProductLineWin').FrameDropdownList('enable');
                $('#QryDealerToWin').FrameDropdownList('enable');
                $('#BtnSave').FrameButton({
                    text: '保存草稿',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
                    }
                });
                $('#BtnDelete').FrameButton({
                    text: '删除草稿',
                    icon: 'save',
                    onClick: function () {
                        that.DeleteDraft();
                    }
                });
                $('#BtnSubmit').FrameButton({
                    text: '提交申请',
                    icon: 'send',
                    onClick: function () {
                        that.Submit();
                    }
                });
                if (mainData.FromDealerDmaId != null && mainData.ToDealerDmaId != null && mainData.ProductLineBumId != null && ($("#hiddenDealerToDefaultWarehouseId") != "" || $("#hiddenDealerToDefaultWarehouseId") != null)) {
                    $('#BtnAddProduct').FrameButton({
                        text: '添加产品',
                        icon: 'plus',
                        onClick: function () {
                            that.AddProduct();
                        }
                    });
                }
                $("#RstProductDetail").data("kendoGrid").showColumn('TransferQty');//10
                $("#RstProductDetail").data("kendoGrid").showColumn('Delete');//10
                $("#RstProductDetail").data("kendoGrid").columns[10].editable = false;
                EditColumnArray.push(10);
                //$("#RstProductDetail").data("kendoGrid").columns[12].editable = true;
            }
            else {
                $("#RstProductDetail").data("kendoGrid").columns[10].editable = true;
                $("#RstProductDetail").data("kendoGrid").showColumn('TransferQty');//11
                if (mainData.Status == "OntheWay") {
                    //撤销
                    $('#BtnRevoke').FrameButton({
                        text: '撤销',
                        icon: 'send',
                        onClick: function () {
                            that.DoRevoke();
                        }
                    });
                }
                EditColumnArrayIsExists(10);
            }
        }
        else {
            $("#RstProductDetail").data("kendoGrid").columns[10].editable = true;
            $("#RstProductDetail").data("kendoGrid").showColumn('TransferQty');//11
        }
    }

    var createRstProductDetail = function (dataSource) {
        $("#RstProductDetail").kendoGrid({
            dataSource: {
                data: dataSource,
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            //height: 300,
            columns: [
            {
                field: "WarehouseName", title: "仓库", width: 'auto', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "仓库" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CFNEnglishName", title: "产品英文名", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CFNChineseName", title: "产品中文名", width: '100px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CFN", title: "产品型号", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "UPN", title: "产品型号", width: '80px', editable: true, hidden: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "LotNumber", title: "序列号/批号", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "QRCode", title: "二维码", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "ExpiredDate", title: "有效期", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "有效期" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "UnitOfMeasure", title: "单位", width: '50px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "TotalQty", title: "库存量", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "库存量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "TransferQty", title: "借出数量", width: '80px', editable: false,
                headerAttributes: { "class": "text-center text-bold", "title": "借出数量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "TransferQty", title: "借出数量", width: '60px', editable: true, hidden: true,
                headerAttributes: { "class": "text-center text-bold", "title": "借出数量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "QRCodeEdit", title: "二维码", width: '80px', editable: true, hidden: true,
                headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                attributes: { "class": "table-td-cell" }
            },
             {
                 field: "Delete", title: "删除", width: '60px', editable: true,
                 headerAttributes: { "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;" },
                 template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                 attributes: { "class": "text-center text-bold" },
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
                that.CheckQty(e);
            },
            save: function (e) {
                that.UpdateItem(e);
            },
            dataBound: function (e) {
                var grid = e.sender;
                var rows = this.items();
                $(rows).each(function () {
                    var index = $(this).index() + 1;
                    var rowLabel = $(this).find(".Row-Number");
                    $(rowLabel).html(index);
                });

                $("#RstProductDetail").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $("#RstProductDetail").data("kendoGrid").dataSource.remove(data);
                    that.Delete(data.Id);
                });

                that.EditColumn();

            }
        });
    }
    //验证数量输入
    that.CheckQty = function (e) {
        var qty = /^[1-9]\d*$/;
        var grid = e.sender;
        var tr = $(e.container).closest("tr");
        var data = grid.dataItem(tr);
        var TransferQty = e.container.find("input[name=TransferQty]");

        TransferQty.change(function (b) {
            if (parseInt(data.TotalQty) < parseInt($(this).val())) {
                //数量错误时，编辑行置为空
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: "借出数量不能大于库存量！",
                });
                data.TransferQty = data.TransferQty;
                $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                return false;
            }
            if (data.QRCode != "" && data.QRCode != null) {
                if (data.QRCode.toLowerCase() != "noqr") {
                    if (parseInt($(this).val()) > 1) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: "带二维码的产品借出数量不得大于1",
                        });
                        data.TransferQty = data.TransferQty;
                        $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                        return false;
                    }
                }
            }
        });
    }

    //修改产品明细单元格由于提示较复杂，故采用单个单元格直接保存的方式
    that.UpdateItem = function (e) {
        var data = {};
        var param = FrameUtil.GetModel();
        data.InstanceId = param.InstanceId;
        data.LotId = e.model.Id;
        if (e.values.ToWarehouseName) {
            data.ToWarehouseId = e.values.ToWarehouseName;
        }
        else {
            data.ToWarehouseId = e.model.ToWarehouseId;
        }
        if (e.values.TransferQty) {
            data.TransferQty = e.values.TransferQty;
        }
        else {
            data.TransferQty = e.model.TransferQty;
        }

        if (e.values.QRCode) {
            data.QRCode = e.values.QRCode;
        }
        else {
            data.QRCode = e.model.QRCode
        }
        if (e.values.QRCodeEdit) {
            data.EditQrCode = e.values.QRCodeEdit;
        }
        else {
            data.EditQrCode = "";
        }
        if (e.values.LotNumber) {
            data.lotNumber = e.values.LotNumber;
        }
        else {
            data.lotNumber = e.model.LotNumber
        }

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    that.RefershHeadData();
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'Error',
                        message: model.ExecuteMessage,
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    };

    //刷新数据
    that.RefershHeadData = function () {
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'RefershHeadData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstProductDetail").data("kendoGrid").setOptions({
                    dataSource: model.RstProductDetail
                });
                FrameWindow.HideLoading();
            }
        });
    }

    //修改产品线
    that.ProductLineChange = function (Bu) {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '改变产品线将删除已添加的产品！',
            confirmCallback: function () {
                CheckAddItemsParam();
                $("#ProductLineId").val(Bu);
                that.RefershHeadData();

                var model = FrameUtil.GetModel();
                var data = {}; data.InstanceId = model.InstanceId;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteDetail',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        $("#RstProductDetail").data("kendoGrid").setOptions({
                            dataSource: []
                        });
                        FrameWindow.HideLoading();
                    }
                });
            },
            cancelCallback: function () {
                var originalBu = {
                    Key: '', Value: ''
                };
                $.each(LstBuArr, function (index, val) {
                    if (dms.common.ToLowerCaseFn($("#ProductLineId").val()) === dms.common.ToLowerCaseFn(val.Key))
                        originalBu = {
                            Key: $("#ProductLineId").val(), Value: val.Value
                        };
                })
                $('#QryProductLineWin').FrameDropdownList('setValue', originalBu);
            }
        });
    }
    //修改借入经销商
    that.DealerToChange = function (DealerId) {
        $("#hiddenDealerToDefaultWarehouseId").val("");//初始化
        CheckAddItemsParam();
        //查询仓库等信息是否存在
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'CheckDealer',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (!model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: model.ExecuteMessage,
                        callback: function () {

                        }
                    });
                }
                else {
                    $("#hiddenDealerToDefaultWarehouseId").val(model.hiddenDealerToDefaultWarehouseId);
                }
                FrameWindow.HideLoading();
            }
        });
    }
    //是否显示添加产品
    //此函数用来控制“添加产品”按钮的状态
    var CheckAddItemsParam = function () {
        var model = FrameUtil.GetModel();
        if (valiteIsNull(model.QryProductLineWin.Key) || valiteIsNull(model.QryProductLineWin.Key) || valiteIsNull(model.QryDealerToWin.Key)) {
            that.removeButton("BtnAddProduct");
        } else {
            //Ext.getCmp('AddItemsButton').enable();
            $('#BtnAddProduct').FrameButton({
                text: '添加产品',
                icon: 'plus',
                onClick: function () {
                    that.AddProduct();
                }
            });
        }
    }


    that.CheckForm = function (data) {
        var message = [];
        var reg = '^[0-9]*$';
        if ($.trim(data.QryDealerFromWin.Key) == "") {
            message.push('请选择经销商');
        }
        if ($.trim(data.QryProductLineWin.Key) == "") {
            message.push('请选择产品线');
        }
        if ($.trim(data.QryDealerToWin.Key) == "") {
            message.push('请选择借入经销商');
        }
        if (data.RstDetailList.length == 0) {
            message.push('请添加产品');
        }
        //表单数量验证
        var msg1 = ""; var msg2 = ""; var msg3 = ""; var msg4 = ""; var msg5 = "";
        for (var i = 0; i < data.RstDetailList.length; i++) {
            var record = data.RstDetailList[i];
            if (record.TransferQty <= 0) {
                msg1 = '借出数量不能为0！';
            }
            //二维码为空，数量不做限制，否则借货数量只能为1
            //if ((record.QRCodeEdit == "" || record.QRCodeEdit == null) && record.QRCode == "NoQR") {
            //    msg2 = '借货出库二维码为NoQR，请联系系统管理员补充二维码！';
            //}
            if (record.QRCode != null && record.QRCode != '' && record.TransferQty > 1) {
                if (record.QRCode.toLowerCase() != 'noqr') {
                    msg3 = '带二维码的产品数量不得大于一';
                }
            }
            //if (that.Calculations(data.RstDetailList, record.QRCodeEdit, "QRCodeEdit") > 1 && record.QRCode == "NoQR" && record.QRCodeEdit != '') {
            //    msg4 = '二维码' + record.QRCodeEdit + "出现多次";
            //}
            //if (that.Calculations(data.RstDetailList, record.QRCodeEdit, "QRCode") > 0 && record.QRCode == "NoQR" && record.QRCodeEdit != '') {
            //    msg5 = '二维码' + record.QRCode + "已使用"
            //}
        }
        if (msg1 != "")
            message.push(msg1);
        if (msg2 != "")
            message.push(msg2);
        if (msg3 != "")
            message.push(msg3);
        if (msg4 != "")
            message.push(msg4);
        if (msg5 != "")
            message.push(msg5);
        return message;
    }
    that.Calculations = function (data, obj, element) {
        var times = 0;
        for (var i = 0; i < data.length; i++) {
            if (data[i]['' + element + ''] == obj)
                times++;
        }
        return times;
    };

    //添加产品
    that.AddProduct = function () {
        var data = FrameUtil.GetModel();
        var TransferType = $("#QryTransferType").val()
        var InstanceId = data.InstanceId;//hiddenTransferId
        var DealerFromId = data.QryDealerFromWin.Key;
        var DealerToId = data.QryDealerToWin.Key;
        var ProductLineWin = data.QryProductLineWin.Key;
        var WarehouseWin = $("#hiddenDealerToDefaultWarehouseId").val();
        url = Common.AppVirtualPath + 'Revolution/Pages/Transfer/TransferEditorPicker.aspx?InstanceId=' + InstanceId + '&&TransferType=' + TransferType + '&&DealerFromId=' + DealerFromId + '&&DealerToId=' + DealerToId + '&&ProductLineWin=' + ProductLineWin + '&&WarehouseWin=' + WarehouseWin,

        FrameWindow.OpenWindow({
            target: 'top',
            title: '添加产品',
            url: url,
            width: $(window).width() * 0.7,
            height: $(window).height() * 0.9,
            actions: ["Close"],
            callback: function (list) {
                if (list) {
                    debugger
                    var pickearr = "";
                    var data = FrameUtil.GetModel();
                    data.InstanceId = $('#InstanceId').val();
                    data.QryBu = $('#ProductLineId').val();
                    for (var i = 0; i <= list.length - 1; i++) {
                        pickearr += list[i] + ","
                    }
                    data.DealerParams = pickearr;
                    //             result = business.AddItemsByType(model.QryTransferType,
                    //new Guid(model.InstanceId),
                    //new Guid(model.QryDealerFromId),
                    //new Guid(model.QryDealerToId),
                    //new Guid(model.QryProductLineWin.Key),
                    //param.Split(','),
                    //(new Guid(model.QryWarehouseWin.Key))

                    FrameWindow.ShowLoading();
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'DoAddProductItems',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            var dataSource = $("#RstProductDetail").data("kendoGrid").dataSource.data();

                            for (var i = 0; i < model.RstProductDetail.length; i++) {
                                var exists = false;
                                for (var j = 0; j < dataSource.length; j++) {
                                    if (dataSource[j].Id == model.RstProductDetail[i].Id) {
                                        exists = true;
                                    }
                                }

                                if (!exists) {
                                    $("#RstProductDetail").data("kendoGrid").dataSource.add(model.RstProductDetail[i]);
                                }
                            }
                            //$("#RstDetailList").data("kendoGrid").dataSource.fetch();
                            $("#RstProductDetail").data("kendoGrid").setOptions({
                                dataSource: $("#RstProductDetail").data("kendoGrid").dataSource
                            });
                            FrameWindow.HideLoading();
                        }
                    });
                }
            }
        });
    }

    //单行删除 操作
    that.Delete = function (LotId) {
        var data = {
        };
        data.LotId = LotId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'Delete',
                    message: '删除成功',
                });
                FrameWindow.HideLoading();
            }
        });
    }

    that.DeleteDraftOrder = function () {
        $("#hiddIsModifyStatus").val("false");
        if ("true" == $("#IsNewApply").val()) {
            var data = {};
            var param = FrameUtil.GetModel();
            data.InstanceId = param.InstanceId;
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
            target: 'top',
            message: '确认要执行删除操作？',
            confirmCallback: function () {
                var data = {
                };
                var param = FrameUtil.GetModel();
                data.InstanceId = param.InstanceId;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteDraft',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'Delete',
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

    };
    //撤销
    that.DoRevoke = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确认要执行撤销操作？',
            confirmCallback: function () {
                var data = {
                };
                var param = FrameUtil.GetModel();
                data.InstanceId = param.InstanceId;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DoRevoke',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (!model.IsSuccess) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'error',
                                message: model.ExecuteMessage,

                            });
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '撤销成功',
                                callback: function () {
                                    top.deleteTabsCurrent();
                                }
                            });

                        }
                        FrameWindow.HideLoading();
                    }
                });
            }
        });

    }
    //保存草稿
    that.Save = function () {
        var data = that.GetModel();
        //验证产品线，否则无法带出订单（分子公司和品牌）
        if ($.trim(data.QryProductLineWin.Key) == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线',
            });
        }
        else {
            var EditRow = [];
            var RstDetailList = data.RstDetailList;
            for (var i = 0; i < RstDetailList.length; i++) {
                var r = {
                    Id: RstDetailList[i].Id, ToWarehouseId: RstDetailList[i].ToWarehouseName.Id, TransferQty: RstDetailList[i].TransferQty, QRCode: RstDetailList[i].QRCode, EditQrCode: RstDetailList[i].QRCode, LotNumber: RstDetailList[i].LotNumber
                };
                EditRow.push(r);
            }
            data.EditRows = JSON.stringify(EditRow);
            //data.EntityModel.push(EntityModel);

            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SaveDraft',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (!model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'error',
                            message: model.ExecuteMessage,

                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '保存成功',
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

    //提交订单
    that.Submit = function () {
        var data = that.GetModel();
        var message = that.CheckForm(data);

        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            var EditRow = [];
            var RstDetailList = data.RstDetailList;
            for (var i = 0; i < RstDetailList.length; i++) {
                var r = {
                    Id: RstDetailList[i].Id, ToWarehouseId: RstDetailList[i].ToWarehouseName.Id, TransferQty: RstDetailList[i].TransferQty, QRCode: RstDetailList[i].QRCode, EditQrCode: RstDetailList[i].QRCode, LotNumber: RstDetailList[i].LotNumber
                };
                EditRow.push(r);
            }
            data.EditRows = JSON.stringify(EditRow);

            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Submit',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    if (!model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'error',
                            message: model.ExecuteMessage,

                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '提交成功',
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



    that.EditColumn = function () {
        var dataView = $("#RstProductDetail").data("kendoGrid").dataSource.view();
        for (var i = 0; i < dataView.length; i++) {
            var uid = dataView[i].uid;
            for (var j = 0; j < EditColumnArray.length; j++) {
                var editColumn = $($("#RstProductDetail tbody").find("tr[data-uid=" + uid + "] td")[EditColumnArray[j]]);
                $(editColumn).addClass("grid-cell-edit");
            }
        }
    };
    function EditColumnArrayIsExists(obj) {
        let x = EditColumnArray.indexOf(obj);
        while (x > -1) {
            EditColumnArray.splice(x, 1)
            x = EditColumnArray.indexOf(obj);
        }
    }

    function valiteIsNull(obj) {
        if (obj == "" || obj == null || obj == undefined) {
            return true;
        }
        else
            return false
    }

    that.removeButton = function (obj) {
        $('#' + obj + '').empty();
        $('#' + obj + '').removeClass();
        $('#' + obj + '').unbind();
    };
    var setLayout = function () {
    }

    return that;
}();


