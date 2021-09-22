var TransferEditorInfo = {};

TransferEditorInfo = function () {
    var that = {};

    var business = 'Transfer.TransferEditorInfo';
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
    var LstWarehouseArr = "";

    that.Init = function () {
        var data = {};
        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.QryTransType = Common.GetUrlParam('Type');
        $("#QryTransferType").val(data.QryTransType);
        $("#IsNewApply").val(Common.GetUrlParam('IsNewApply'));

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                EntityModel = JSON.parse(model.EntityModel);

                LstBuArr = model.LstBu;
                LstStatusArr = model.LstStatus;
                LstWarehouseArr = model.LstWarehouse;
                $("#hidDealerId").val(model.DealerId);
                $("#DealerListType").val(model.DealerListType);
                $('#InstanceId').val(model.InstanceId);
                $("#ProductSumText").append(model.ProductSumText);
                $("#QryDealerFromId").val(EntityModel.FromDealerDmaId);
                $("#QryDealerToId").val(EntityModel.ToDealerDmaId);

                $("#ProductLineId").val(EntityModel.ProductLineBumId == null ? "" : EntityModel.ProductLineBumId);

                //经销商
                var DealerName = "";
                $.each(model.LstDealer, function (index, val) {
                    if (EntityModel.FromDealerDmaId === val.Id)
                        DealerName = val.ChineseShortName;
                })
                //$('#QryDealerFromWin').FrameDropdownList({
                //    dataSource: model.LstDealer,
                //    dataKey: 'Id',
                //    dataValue: 'ChineseShortName',
                //    selectType: 'select',
                //    value: { Key: EntityModel.FromDealerDmaId, Value: DealerName },
                //});
                $('#QryDealerFromWin').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    parameters: { "IsAll": $("#DealerListType").val() },//查询类型
                    business: 'Util.DealerScreenFilter',
                    method: 'DealerFilter',
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'none',
                    filter: 'contains',
                    serferFilter: true,
                    value: { Key: EntityModel.FromDealerDmaId, Value: DealerName },
                });

                $('#QryOrderNO').FrameTextBox({
                    value: EntityModel.TransferNumber,
                });
                $('#QryOrderNO').FrameTextBox('disable');

                var StatusName = "";
                $.each(model.LstStatus, function (index, val) {
                    if (EntityModel.Status === val.Key)
                        StatusName = val.Value;
                })
                $('#QryStatus').FrameTextBox({
                    value: StatusName,
                });
                $('#QryStatus').FrameTextBox('disable');

                //产品线
                var Bu = "";
                $.each(model.LstBu, function (index, val) {
                    if (dms.common.ToLowerCaseFn(EntityModel.ProductLineBumId) === dms.common.ToLowerCaseFn(val.Key))
                        Bu = { Key: val.Key, Value: val.Value };
                })
                $('#QryProductLineWin').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: Bu,
                    onChange: function () {
                        that.ProductLineChange(this.value);
                    }
                });
                //日期
                $('#QryDate').FrameTextBox({
                    value: EntityModel.TransferDate,
                });
                $('#QryDate').FrameTextBox('disable');

                //默认移入仓库
                var WarehouseName = "";
                if (model.LstWarehouse != null && model.LstWarehouse != "") {
                    if (model.LstWarehouse.length > 0)
                        WarehouseName = { Key: model.LstWarehouse[0].Id, Value: model.LstWarehouse[0].Name }
                }
                //$.each(model.LstWarehouse, function (index, val) {
                //    if (EntityModel.ToDealerDmaId === val.Key)
                //        WarehouseName = val.Value;
                //})
                $('#QryWarehouseWin').FrameDropdownList({
                    dataSource: model.LstWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: WarehouseName
                    //onChange: that.ProductLineChange

                });

                //绑定经销商。产品明细 。操作日志等
                createRstProductDetail(model.RstProductDetail);
                $('#RstOperationLog').DmsOperationLog({
                    dataSource: model.RstLogDetail
                });

                that.InitWindows(EntityModel, model.IsDealer, model.BtnReasonVisibile);

                if ($("#IsNewApply").val() == 'true') {
                    CheckAddItemsParam();
                }
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
    //初始化按钮字段
    that.InitWindows = function (mainData, IsDealer, ReasonVisibile) {
        //窗口状态控制
        $('#QryDealerFromWin').parent().parent().show();
        $('#QryDealerFromWin').FrameDropdownList('disable');
        $('#QryProductLineWin').FrameDropdownList('disable');
        $('#QryWarehouseWin').FrameDropdownList('disable');
        that.removeButton("BtnReason");
        that.removeButton("BtnSave");
        that.removeButton("BtnSubmit");
        that.removeButton("BtnDelete");
        that.removeButton("BtnAddProduct");
        $("#RstProductDetail").data("kendoGrid").hideColumn('TransferQty');//10
        $("#RstProductDetail").data("kendoGrid").hideColumn('ToWarehouseName');//11
        $("#RstProductDetail").data("kendoGrid").hideColumn('TransferQtyEdit');//12
        $("#RstProductDetail").data("kendoGrid").hideColumn('ToWarehouseIdEdit');//13
        $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');//15
        //二维码禁用编辑
        //所有出库操作我二维码禁用编辑，入库能够进行编辑二维码功能
        //$("#RstProductDetail").data("kendoGrid").columns[14].editable = false;//允许编辑,

        if (IsDealer) {
            if (mainData.Status == "Draft") {
                $('#QryProductLineWin').FrameDropdownList('enable');
                $('#QryWarehouseWin').FrameDropdownList('enable');

                $('#BtnSave').FrameButton({
                    text: '保存草稿',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
                    }
                });
                $('#BtnDelete').FrameButton({
                    text: '删除草稿',
                    icon: 'remove',
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
                if (mainData.FromDealerDmaId != null && mainData.ToDealerDmaId != null && mainData.ProductLineBumId != null) {
                    $('#BtnAddProduct').FrameButton({
                        text: '添加产品',
                        icon: 'plus',
                        onClick: function () {
                            that.AddProduct();
                        }
                    });
                }
                $("#RstProductDetail").data("kendoGrid").showColumn('TransferQtyEdit');//12
                $("#RstProductDetail").data("kendoGrid").showColumn('ToWarehouseIdEdit');//13
                $("#RstProductDetail").data("kendoGrid").showColumn('Delete');//15
                //$("#RstProductDetail").data("kendoGrid").showColumn('QRCodeEdit');//14
                EditColumnArray.push(12);

                if (!ReasonVisibile) {
                    $('#BtnReason').FrameButton({
                        text: '授权产品线无法选择的原因',
                        icon: '',
                        onClick: function () {
                            that.ShowReason();
                        }
                    });
                }
            }
            else {
                //$("#RstProductDetail").data("kendoGrid").hideColumn('QRCodeEdit');//14
                //$("#RstProductDetail").data("kendoGrid").showColumn('TransferQty');//10
                //$("#RstProductDetail").data("kendoGrid").showColumn('ToWarehouseName');//11
                $("#RstProductDetail").data("kendoGrid").showColumn('TransferQtyEdit');//12
                $("#RstProductDetail").data("kendoGrid").showColumn('ToWarehouseIdEdit');//13
                $("#RstProductDetail").data("kendoGrid").columns[12].editable = true;
                $("#RstProductDetail").data("kendoGrid").columns[13].editable = true;
                //$("#RstProductDetail").data("kendoGrid").columns[14].editable = true;
                //EditColumnArrayIsExists(10);
            }
        }
        else {
            //$("#RstProductDetail").data("kendoGrid").showColumn('TransferQty');//10
            //$("#RstProductDetail").data("kendoGrid").showColumn('ToWarehouseName');//11
            $("#RstProductDetail").data("kendoGrid").showColumn('TransferQtyEdit');//12
            $("#RstProductDetail").data("kendoGrid").showColumn('ToWarehouseIdEdit');//13
            $("#RstProductDetail").data("kendoGrid").columns[12].editable = true;
            $("#RstProductDetail").data("kendoGrid").columns[13].editable = true;
            //$("#RstProductDetail").data("kendoGrid").columns[14].editable = true;//禁用
        }
    }

    var createRstProductDetail = function (dataSource) {
        $("#RstProductDetail").kendoGrid({
            dataSource: {
                data: dataSource,
                schema: {
                    model: {
                        fields: {
                            TransferQty: { type: "number", validation: { required: true, min: 0 } }
                        }
                    },
                },
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            //height: 300,
            columns: [
            {
                field: "WarehouseName", title: "移出仓库", width: 'auto', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "移出仓库" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CFNEnglishName", title: "产品英文名", width: '100px', editable: true,
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
                field: "ExpiredDate", title: "有效期", width: '60px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "有效期" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "UnitOfMeasure", title: "单位", width: '60px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "TotalQty", title: "库存量", width: '60px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "库存量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "TransferQty", title: "数量", width: '60px', editable: true, hidden: true,//10
                headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "ToWarehouseName", title: "移入仓库", width: '150px', editable: true, hidden: true,//11
                headerAttributes: { "class": "text-center text-bold", "title": "移入仓库" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "TransferQty", title: "数量", width: '60px', editable: false,//12
                headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "ToWarehouseId", title: "移入仓库", width: '120px', editable: false, editor: ChangeReasonEditor,//13
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
                headerAttributes: { "class": "text-center text-bold", "title": "移入仓库" },
                attributes: { "class": "table-td-cell" }
            },
            //{
            //    field: "QRCodeEdit", title: "二维码", width: '100px', editable: false,//14
            //    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
            //    attributes: { "class": "table-td-cell" }
            //},
             {
                 field: "Delete", title: "删除", width: '50px', editable: true,
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

                $("a[id=lnksaveStandardPrice]").bind("click", function (e) {
                    var row = $(this).closest("tr");
                    var grid = $("#grid-serch-benchmark-price").data("kendoGrid");
                    var dataItem = grid.dataItem(row);
                    if (dataItem.ChangeReason == "" || dataItem.ChangeReason == null) {
                        alert("请选择修改原因");
                        return false;
                    }
                });

                that.EditColumn();
            }
        });

    }


    function ChangeReasonEditor(container, options) {
        //$('<input required name="' + options.field + '"/>')
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

    //验证数量输入
    that.CheckQty = function (e) {
        var qty = /^[1-9]\d*$/;
        var grid = e.sender;
        var tr = $(e.container).closest("tr");
        var data = grid.dataItem(tr);
        var TransferQty = e.container.find("input[name=TransferQty]");

        TransferQty.change(function (b) {
            if (accMin(data.TotalQty, $(this).val()) < 0) {
                //数量错误时，编辑行置为空
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: "移库数量不能大于库存量！",
                });
                data.TransferQty = data.TransferQty;
                $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                return false;
            }
            //二维码存在情况下，订购数量不能大于一
            if (data.QRCode != null && data.QRCode != '' && $(this).val() > 1) {
                if (data.QRCode.toLowerCase() != 'noqr') {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: "带二维码的产品数量不得大于一！",
                    });
                    data.TransferQty = data.TransferQty;
                    $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                    return false;
                }
            }
            //最小单位限制
            //if (accMul($(this).val(), 1000000) % accDiv(1, data.ConvertFactor).mul(1000000) != 0) {
            //    FrameWindow.ShowAlert({
            //        target: 'top',
            //        alertType: 'warning',
            //        message: "最小单位是:" + accDiv(1, data.ConvertFactor)
            //    });
            //    data.TransferQty = data.TotalQty;
            //    $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
            //    return false;
            //}
        });
        //if (data.values.ToWarehouseId == '') {
        //    return false;
        //}

        //遍历二维码，如果存在禁用编辑，否则允许编辑
        //var QRCodeEdit = e.container.find("input[name=QRCodeEdit]");
        //if (data.QRCode != 'NoQR')
        //    QRCodeEdit[0].setAttribute("disabled", true);
        //else
        //    QRCodeEdit[0].removeAttribute("disabled");
    }

    //修改产品明细单元格由于提示较复杂，故采用单个单元格直接保存的方式
    //编辑行数据实时保存
    that.UpdateItem = function (e) {
        var data = {
        };
        var param = FrameUtil.GetModel();
        data.InstanceId = param.InstanceId;
        data.LotId = e.model.Id;
        if (e.values.ToWarehouseId) {
            data.ToWarehouseId = e.values.ToWarehouseId;
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
            method: 'SaveTransferItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    that.RefershHeadData();
                    if (model.hiddenMsg == "warning") {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: model.ExecuteMessage,
                        });
                    }
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

    that.CheckForm = function (data) {
        var message = [];
        var reg = '^[0-9]*$';
        if ($.trim(data.QryDealerFromWin.Key) == "") {
            message.push('请选择经销商');
        }
        if ($.trim(data.QryProductLineWin.Key) == "") {
            message.push('请选择产品线');
        }
        if (data.RstDetailList.length == 0) {
            message.push('请添加产品');
        }
        //表单数量验证
        var msg1 = ""; var msg2 = ""; var msg3 = ""; var msg4 = ""; var msg5 = ""; var msg6 = "";
        for (var i = 0; i < data.RstDetailList.length; i++) {
            var record = data.RstDetailList[i];
            if (record.TransferQty <= 0) {
                msg1 = '数量不能为0！';
            }
            if (record.ToWarehouseId == null) {
                msg2 = '移入仓库不能为空！';
            }
            if (record.QRCode != null && record.QRCode != '' && record.TransferQty > 1) {
                if (record.QRCode.toLowerCase() != 'noqr') {
                    msg4 = '带二维码的产品数量不得大于一';
                }
            }
            //if ((record.QRCodeEdit == "" || record.QRCodeEdit == null) && record.QRCode == "NoQR") {
            //    msg3 = '移库必须填写二维码';
            //}
            //if (record.QRCodeEdit != null && record.QRCodeEdit != '' && record.TransferQty > 1) {
            //    msg4 = '带二维码的产品数量不得大于一';
            //}
            //if (that.Calculations(data.RstDetailList, record.QRCodeEdit, "QRCodeEdit") > 1 && record.QRCodeEdit != '') {
            //    msg5 = '二维码' + record.QRCodeEdit + "出现多次";
            //}
            //if (record.QRCodeEdit != null && record.QRCodeEdit != '' && that.Calculations(data.RstDetailList, record.QRCodeEdit, "QRCode") > 0
            // && record.QRCode == "NoQR" && record.QRCodeEdit != '') {
            //    msg6 = '二维码' + record.QRCodeEdit + "已使用";
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
        if (msg6 != "")
            message.push(msg6);

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

    //授权产品线无法选择的原因
    that.ShowReason = function () {
        FrameWindow.OpenWindow({
            target: 'top',
            title: '移库单明细',
            url: Common.AppVirtualPath + 'Revolution/Pages/Transfer/TransferInfoReason.aspx?',
            width: $(window).width() * 0.7,
            height: $(window).height() * 0.9,
            actions: ["Close"],
            callback: function () {
            }
        });
    };

    //添加产品
    that.AddProduct = function () {
        var data = FrameUtil.GetModel();
        var IptProductLine = $('#ProductLineId').val();
        var FormId = $('#InstanceId').val();
        var TransferType = "";
        if ($("#QryTransferType").val() == "Transfer")
            TransferType = "Transfer";
        else
            TransferType = "TransferConsignment";
        var InstanceId = data.InstanceId;
        var DealerFromId = data.QryDealerFromId;
        var DealerToId = data.QryDealerToId;
        var ProductLineWin = data.QryProductLineWin.Key;
        var WarehouseWin = data.QryWarehouseWin.Key;
        url = Common.AppVirtualPath + 'Revolution/Pages/Transfer/TransferEditorPicker.aspx?InstanceId=' + InstanceId + '&&TransferType=' + TransferType + '&&DealerFromId=' + DealerFromId + '&&DealerToId=' + DealerToId + '&&ProductLineWin=' + ProductLineWin + '&&WarehouseWin=' + WarehouseWin,

        FrameWindow.OpenWindow({
            target: 'top',
            title: '物料选择',
            url: url,
            width: $(window).width() * 0.7,
            height: $(window).height() * 0.9,
            actions: ["Close"],
            callback: function (list) {
                if (list) {
                    var pickearr = "";
                    var data = FrameUtil.GetModel();
                    data.InstanceId = $('#InstanceId').val();
                    data.QryBu = $('#ProductLineId').val();
                    for (var i = 0; i <= list.length - 1; i++) {
                        pickearr += list[i] + ","
                    }
                    data.DealerParams = pickearr;

                    FrameWindow.ShowLoading();
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'DoAddProductItems',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            that.RefershHeadData();
                            FrameWindow.HideLoading();
                        }
                    });
                }
            }
        });
    }

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

    var CheckAddItemsParam = function () {
        var productLine = $('#QryProductLineWin').FrameDropdownList('getValue').Key;
        if (productLine == '' || productLine == null) {
            that.removeButton("BtnAddProduct");
        } else {
            $('#BtnAddProduct').FrameButton({
                text: '添加产品',
                icon: 'plus',
                onClick: function () {
                    that.AddProduct();
                }
            });
        }
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

    //保存草稿
    that.Save = function () {
        var data = that.GetModel();
        //验证产品线，否则无法带出分子公司和品牌
        if ($.trim(data.QryProductLineWin.Key) == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请选择产品线',
            });
            return;
        }
        else {
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
                        if (model.hiddrtn == "WarehouseEqual") {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: '移出仓库与移入仓库必须不同！',
                            });
                        }
                        else if (model.hiddrtn == "WarehouseNotEqual") {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '提交成功',
                                callback: function () {
                                    top.deleteTabsCurrent();
                                }
                            });
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: model.ExecuteMessage,
                            });
                        }
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    //修改产品线
    that.ProductLineChange = function (Bu) {
        var productLine = $('#QryProductLineWin').FrameDropdownList('getValue').Key;
        if ($("#ProductLineId").val() != Bu) {
            if ($("#ProductLineId").val() == '') {
                $("#ProductLineId").val(Bu);
                that.RefershHeadData();
                CheckAddItemsParam();
            }
            else {
                FrameWindow.ShowConfirm({
                    target: 'top',
                    message: '改变产品线将删除已添加的产品！',
                    confirmCallback: function () {
                        CheckAddItemsParam();
                        $("#ProductLineId").val(Bu);
                        that.RefershHeadData();

                        var model = FrameUtil.GetModel();
                        var data = {
                        }; data.InstanceId = model.InstanceId;
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
