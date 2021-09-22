var OrderApplyLPInfo = {};

OrderApplyLPInfo = function () {
    var that = {};

    var business = 'Order.OrderApplyLPInfo';
    var CustomerFaceNbr = [];
    var g = 0;
    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.RstDetailList = $("#RstProductDetail").data("kendoGrid").dataSource.data();
        return model;
    }
    var EditColumnArray = [];//编辑列
    var EntityModel = {};
    var LstWarehouseArr = "";
    var LstSpecialPriceArr = "";
    var LstBuArr = "";
    var LstLstOrderTypeArr = "";
    var LstPointTypeArr = "";

    that.Init = function () {
        var data = {};
        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.IsNewApply = Common.GetUrlParam('IsNew');
        data.QryOrderType = { Key: "", Value: "" };
        data.hidDealerId = Common.GetUrlParam('DmaId');
        $("#IsNewApply").val(Common.GetUrlParam('IsNew'));
        $("#InstanceId").val(Common.GetUrlParam('InstanceId'));
        $("#hidDealerId").val(Common.GetUrlParam('DmaId'));

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                EditColumnArray = [];
                EntityModel = JSON.parse(model.EntityModel);
                LstWarehouseArr = model.LstWarehouse;
                LstSpecialPriceArr = model.LstSpecialPrice;
                LstBuArr = model.LstBu;
                LstLstOrderTypeArr = model.LstOrderType;
                LstPointTypeArr = model.LstPointType;

                $("#InstanceId").val(model.InstanceId);
                $("#hidOrderStatus").val(model.hidOrderStatus);
                $("#hidDealerId").val(model.hidDealerId);
                $("#hidPriceType").val(model.hidPriceType);
                $("#hidOrderType").val(model.hidOrderType);
                $("#hidPointType").val(model.hidPointType);
                $("#hidCreateType").val(model.hidCreateType);
                $("#hidIsUsePro").val(model.hidIsUsePro);
                $("#hidVenderId").val(model.hidVenderId);
                $("#hidWarehouse").val(model.hidWarehouse);
                $("#hidPohId").val(model.hidPohId);
                $("#hidUpdateDate").val(model.hidUpdateDate);
                $("#hidSAPWarehouseAddress").val(model.hidSAPWarehouseAddress);
                $("#QryPickUp").val(model.QryPickUp);
                $("#QryDeliver").val(model.QryDeliver);
                //订单类型

                if (model.IsNewApply) {//新增
                    if (model.LstOrderType.length > 0) {
                        model.QryOrderType = model.LstOrderType[0];
                        $("#hidOrderType").val(model.QryOrderType.Key);
                    }
                    if (model.LstBu.length > 0) {
                        model.QryProductLine = model.LstBu[0];
                        $("#hidProductLine").val(model.QryProductLine.Key);
                    }
                }
                else {
                    $("#hidOrderType").val(model.hidOrderType);
                    $.each(model.LstOrderType, function (index, val) {
                        if (model.hidOrderType === val.Key)
                            model.QryOrderType = {
                                Key: model.hidOrderType, Value: val.Value
                            };
                    })
                    //bu 
                    $("#hidProductLine").val(model.hidProductLine);
                    $.each(model.LstBu, function (index, val) {
                        if (dms.common.ToLowerCaseFn(model.hidProductLine) === dms.common.ToLowerCaseFn(val.Key))
                            model.QryProductLine = {
                                Key: model.hidProductLine, Value: val.Value
                            };
                    })
                }
                $('#QryOrderType').FrameDropdownList({
                    dataSource: model.LstOrderType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryOrderType,
                    onChange: function (s) {
                        that.OrderTypeChange(this.value);
                    }
                });

                //订单号
                $('#QryOrderNO').FrameTextBox({
                    value: model.QryOrderNO,
                });
                $("#QryOrderNO").FrameTextBox('disable');

                $('#QryPointType').parent().parent().hide();
                $.each(model.LstPointType, function (index, val) {
                    if (EntityModel.PointType === val.Key)
                        model.QryPointType = {
                            Key: EntityModel.PointType, Value: val.Value
                        };
                })
                //积分类型
                $('#QryPointType').FrameDropdownList({
                    dataSource: model.LstPointType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryPointType,
                    onChange: function (s) {
                        that.PointTypeChange(this.value);
                    }
                });


                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryProductLine,
                    onChange: function (s) {
                        that.ProductLineChange(this.value);
                    }
                });

                //$("#QryProductLine").FrameDropdownList('disable');//Todo
                //if (!model.cbProductLineWinDisabled)
                //    $("#QryProductLine").FrameDropdownList('enable');
                if (model.hidOrderStatus != "Draft") {
                    $("#QryProductLine").FrameDropdownList('disable')
                }

                //状态
                $('#QryOrderStatus').FrameTextBox({
                    value: model.QryOrderStatus,
                });
                $("#QryOrderStatus").FrameTextBox('disable');

                //经销商
                var DealerName = "";
                $.each(model.LstDealer, function (index, val) {
                    if (model.hiddenDealerId === val.Id)
                        model.QryDealer = {
                            Key: model.hiddenDealerId, Value: val.ChineseName
                        };
                })
                //经销商
                //$('#QryDealer').FrameDropdownList({
                //    dataSource: model.LstDealer,
                //    dataKey: 'Id',
                //    dataValue: 'ChineseName',
                //    selectType: 'none',
                //    value: model.QryDealer,
                //});
                $('#QryDealer').FrameTextBox({
                    value: model.QryDealer.Value,
                });
                $("#QryDealer").FrameTextBox('disable');

                //订单对象
                $('#QryOrderTo').FrameTextBox({
                    value: model.QryOrderTo,
                });
                $("#QryOrderTo").FrameTextBox('disable');
                //提交日期
                $('#QrySubmitDate').FrameTextBox({
                    value: model.QrySubmitDate,
                });
                $("#QrySubmitDate").FrameTextBox('disable');

                //crossDock编号
                $('#QryCrossDock').FrameTextBox({
                    value: '',
                });

                //Rsm
                $('#QrySales').FrameTextBox({
                    value: model.QrySales,
                    readonly: true
                });

                //***********************************表单表头信息************
                $("#QryCurrency").FrameTextBox({
                    value: model.QryCurrency,
                    readonly: true
                })
                //金额汇总
                $("#QryTotalAmount").FrameTextBox({
                    value: model.QryTotalAmount,
                })
                $("#QryTotalAmount").FrameTextBox('disable');
                //数量汇总
                $("#QryTotalQty").FrameTextBox({
                    value: model.QryTotalQty,

                })
                $("#QryTotalQty").FrameTextBox('disable');

                $("#QryTotalReceiptQty").FrameTextBox({
                    value: model.QryTotalReceiptQty,
                })
                $("#QryTotalReceiptQty").FrameTextBox('disable');
                //配送中心
                $("#QryVirtualDC").FrameTextBox({
                    value: model.QryVirtualDC
                })
                //备注
                $('#QryRemark').FrameTextArea({
                    value: model.QryRemark,

                });
                //选择促销政策控件处理,特殊价格   
                that.InitpecialPrice(model);
                //订单联系人
                $('#QryContactPerson').FrameTextBox({
                    value: model.QryContactPerson,
                });
                //联系方式
                $('#QryContact').FrameTextBox({
                    value: model.QryContact,

                });
                //手机号码
                $('#QryContactMobile').FrameTextBox({
                    value: model.QryContactMobile,
                });
                //拒绝理由,无任何地方存在数据交互，可不要
                $('#QryRejectReason').FrameTextArea({
                    value: '',
                });

                var LstPickUpOrDeliver = []; var QryPickUpOrDeliver = "";
                LstPickUpOrDeliver.push({ Key: "0", Value: "自提" });
                LstPickUpOrDeliver.push({ Key: "1", Value: "送货/承运商承运" });
                if (model.QryPickUp) {
                    QryPickUpOrDeliver = { Key: "0", Value: "自提" };
                }
                if (model.QryDeliver) {
                    QryPickUpOrDeliver = { Key: "1", Value: "送货/承运商承运" };
                }
                $('#QryPickUpOrDeliver').FrameRadio({
                    dataSource: LstPickUpOrDeliver,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    value: QryPickUpOrDeliver,
                    onChange: that.ChangePickUpOrDeliver
                });

                ////收货仓库
                //if (model.IsNewApply) {//新增
                //    model.QryWarehouse = model.LstWarehouse[0];
                //    $("#hidWarehouse").val(model.QryWarehouse.Key);
                //    model.QryShipToAddress = model.QryWarehouse.Address;
                //}
                //else {
                //    $("#hidWarehouse").val(model.hidWarehouse);
                //    $.each(model.LstWarehouse, function (index, val) {
                //        if (model.hidWarehouse === val.Id)
                //            model.QryWarehouse = {
                //                Key: model.hidWarehouse, Value: val.Name
                //            };
                //    })
                //}
                //$('#QryWarehouse').FrameDropdownList({
                //    dataSource: model.LstWarehouse,
                //    dataKey: 'Id',
                //    dataValue: 'Name',
                //    selectType: 'none',
                //    value: model.QryWarehouse,
                //    onChange: function (s) {
                //        that.WarehouseChanage(this.value);
                //    }
                //});

                if (model.IsNewApply) {//新增
                    //收货地址
                    if (model.LstShipToAddress.length > 0) {
                        model.QryShipToAddress = { Key: model.LstShipToAddress[0].WhCode, Value: model.LstShipToAddress[0].WhAddress };
                        $("#hidSAPWarehouseAddress").val(model.QryShipToAddress.Key)
                    }
                }
                else {
                    //收货地址
                    if ($("#hidSAPWarehouseAddress").val() == "") {
                        if (model.LstShipToAddress.length > 0) {
                            model.QryShipToAddress = { Key: model.LstShipToAddress[0].WhCode, Value: model.LstShipToAddress[0].WhAddress };
                            $("#hidSAPWarehouseAddress").val(model.QryShipToAddress.Key);
                        }
                    }
                    else {
                        $("#hidSAPWarehouseAddress").val(model.hidSAPWarehouseAddress);
                    }
                    $.each(model.LstShipToAddress, function (index, val) {
                        if ($("#hidSAPWarehouseAddress").val() === val.WhCode)
                            model.QryShipToAddress = {
                                Key: val.WhCode, Value: val.WhAddress
                            };
                    })
                }
                //收货地址
                $('#QryShipToAddress').FrameDropdownList({
                    dataSource: model.LstShipToAddress,
                    dataKey: 'WhCode',
                    dataValue: 'WhAddress',
                    selectType: 'none',
                    value: model.QryShipToAddress,
                    onChange: function (s) {
                        that.SAPWarehouseAddressChanage(this.value);
                    }
                });
                //医院选择
                $('#QryTexthospitalname').FrameTextBox({
                    value: model.QryTexthospitalname,
                });
                $('#QryTexthospitalname').FrameTextBox('disable');
                $('#BtnChoiceHopital').FrameButton({
                    text: '选择',
                    icon: 'search',
                    onClick: function () {
                        that.ChoiceHospital();
                    }
                });
                //医院地址
                $("#QryHospitalAddress").FrameTextBox({
                    value: model.QryHospitalAddress,
                })
                $("#QryHospitalAddress").FrameTextBox('disable');
                //收货人
                $('#QryConsignee').FrameTextBox({
                    value: model.QryConsignee,
                });
                //收货人电话
                $('#QryConsigneePhone').FrameTextBox({
                    value: model.QryConsigneePhone,
                });
                //期望到货日期
                var curDate = new Date();
                var nextDate = new Date(curDate.getTime() + 24 * 60 * 60 * 1000); //后一天
                $('#QryRDD').FrameDatePicker({
                    min: nextDate,
                    format: "yyyy-MM-dd",
                    value: (model.QryRDD == "" || model.QryRDD == null) ? ' ' : new Date(model.QryRDD)
                });
                //var demoName = $("#QryRDD").kendoDatePicker({}).data("kendoDatePicker");
                //demoName.element[0].disabled = true;
                //$('#QryRDD').FrameDatePicker('disable');
                //承运商
                $('#QryCarrier').FrameTextBox({
                    value: model.QryCarrier,
                });

                //***********************************表单表头信息************
                //*************发货订单明细*****************
                createRstShipDetail(model.RstShipDetail);
                //*************发货订单明细*****************

                //绑定经销商。产品明细 。操作日志等
                createRstProductDetail(model.RstProductDetail);
                createRstInvoiceDetail(model.RstInvoiceDetail);
                createRstAttachmentDetail(model.LstAttachmentList);
                $('#RstOperationLog').DmsOperationLog({
                    dataSource: model.RstLogDetail
                });

                //*******************初始化******************
                //Init原始数据
                that.ProductLineInit();
                that.OrderTypeLoad($("#hidOrderType").val());//加载订单类型之后执行
                that.ClearDetailWindow();

                $('#BtnDiscardModify').FrameButton({
                    text: '放弃修改',
                    icon: 'reply',
                    onClick: function () {
                        that.Discard();
                    }
                });
                $('#BtnClose').FrameButton({
                    text: '申请关闭',
                    icon: 'recycle',
                    onClick: function () {
                        that.Close();
                    }
                });
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
                    text: '提交订单',
                    icon: 'send',
                    onClick: function () {
                        that.Submit();
                    }
                });
                $('#BtnUsePro').FrameButton({
                    text: '使用促销',
                    icon: 'file-o',
                    onClick: function () {
                        that.UserPo();
                    }
                });
                $('#btnUserPoint').FrameButton({
                    text: '使用积分',
                    icon: 'file-o',
                    onClick: function () {
                        that.UserPoint();
                    }
                });
                $('#BtnCopy').FrameButton({
                    text: '复制订单',
                    icon: 'copy',
                    onClick: function () {
                        that.Copy();
                    }
                });
                $('#BtnRevoke').FrameButton({
                    text: '撤销申请',
                    icon: 'reply',
                    onClick: function () {
                        that.DoRevoke();
                    }
                });
                that.removeButton('BtnRevoke');
                $('#btnAddCfnSet').FrameButton({
                    text: '添加成套产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddProductSet();
                    }
                });
                $('#btnUserPoint').FrameButton({
                    text: '使用积分',
                    icon: 'file-o',
                    onClick: function () {
                        that.UserPoint();
                    }
                });
                $('#btnAddCfn').FrameButton({
                    text: '添加产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddProduct();
                    }
                });
                $('#BtnPushToERP').FrameButton({
                    text: '推送ERP',
                    icon: 'send',
                    onClick: function () {
                        that.PushToERP();
                    }
                });
                if (EntityModel.OrderStatus != 'Submitted') {
                    that.removeButton('BtnPushToERP');
                }
                $("#hidDealerType").val(model.DealerType);
                if (EntityModel.OrderType == "CRPO") {
                    $("#RstProductDetail").data("kendoGrid").showColumn('PointAmount');
                    $('#QryPointType').parent().parent().show();
                }
                if (EntityModel.OrderType == "ClearBorrowManual") {
                    $("#RstProductDetail").data("kendoGrid").showColumn('DiscountRate');
                    $('#QryOrderType').FrameDropdownList('disable');
                }
                else {
                    $('#QryOrderType').FrameDropdownList('enable');
                }
                $('#QryCarrier').FrameTextBox('disable');
                if (model.hidOrderStatus == "Draft") {
                    $('#QryCarrier').FrameTextBox('enable');
                }
                if (model.IsDealer && (model.DealerType == "T1" || model.DealerType == "LP" || model.DealerType == "LS") && model.hidOrderStatus == "Draft") {

                    //隐藏复制、放弃修改按钮
                    $("#lbRejectReason").hide();
                    $('#QryRejectReason').hide();
                    that.removeButton('BtnCopy');
                    that.removeButton('BtnRevoke');
                    that.removeButton('BtnClose');
                    that.removeButton('BtnUsePro');
                    that.removeButton('BtnDiscardModify');
                    //产品数量、序列号可编辑
                    EditColumnArray.push(4);
                    EditColumnArray.push(11);
                    $("#RstProductDetail").data("kendoGrid").columns[4].editable = false;
                    $("#RstProductDetail").data("kendoGrid").columns[11].editable = false;
                    $("#RstAttachmentDetail").data("kendoGrid").showColumn('Delete');//7,附件

                    $('#BtnChoiceHopital').FrameButton('enable');
                    //启用Radio
                    $('#QryPickUpOrDeliver').FrameRadio('enable');

                    //Edit By Song Weiming on 2018-10-10 清指定批号订单不能修改价格
                    //如果是特殊价格订单或交接订单、特殊清指定批号订单，则可以修改价格
                    var SpecialPriceValue = $('#QrySpecialPrice').FrameDropdownList('getValue').Key;
                    if ((EntityModel.OrderType == "SpecialPrice" && (EntityModel.IsUsePro == "0" || (EntityModel.IsUsePro == "" || EntityModel.IsUsePro == null)) && (SpecialPriceValue == "满额送赠品" || SpecialPriceValue == "一次性特殊价格"))) {
                        $('#BtnUsePro').FrameButton({
                            text: '使用促销',
                            icon: 'file-o',
                            onClick: function () {
                                that.UserPo();
                            }
                        });

                        $('#btnAddCfn').FrameButton({
                            text: '添加产品',
                            icon: 'plus',
                            onClick: function () {
                                that.AddProduct();
                            }
                        });
                        EditColumnArray.push(5);
                        $("#RstProductDetail").data("kendoGrid").columns[5].editable = false;//允许编辑
                    }
                    if (EntityModel.OrderType == "Transfer") {
                        $('#BtnUsePro').FrameButton({
                            text: '使用促销',
                            icon: 'file-o',
                            onClick: function () {
                                that.UserPo();
                            }
                        });
                        EditColumnArray.push(5);
                        $("#RstProductDetail").data("kendoGrid").columns[5].editable = false;//允许编辑
                    }

                    //$('#QryCarrier').FrameTextBox('disable');
                    //如果订单时BOM订单，则不允许删除明细行
                    if (EntityModel.OrderType == "BOM") {
                        EditColumnArrayIsExists(4);
                        $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;
                        $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');
                    }

                    if (model.DealerType == 'LP' || model.DealerType == 'LS') {
                        $('#QryCrossDock').FrameTextBox('enable');
                        $('#QryCrossDock').parent().parent().show();

                    }
                    else {
                        $('#QryCrossDock').FrameTextBox('disable');
                        $('#QryCrossDock').parent().parent().hide();
                    }

                    //清指定订单查询操作
                    var param = {};
                    param.InstanceId = $("#InstanceId").val();
                    param.hidWarehouse = $("#hidWarehouse").val();
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'GetBorrowManual',
                        url: Common.AppHandler,
                        data: param,
                        async: false,
                        callback: function (d) {
                            //如果是清指定批号订单，且经销商为直销医院，仓库和收货地址不能更改。且收货地址要根据收货仓库获取
                            $("#hidDealerTaxpayer").val(d.hidDealerTaxpayer);
                            if (EntityModel.OrderType == 'ClearBorrowManual' && model.hidDealerTaxpayer == "直销医院") {
                                $('#QryWarehouse').FrameDropdownList('disable');
                                $('#QryShipToAddress').FrameDropdownList('disable');
                                if (d.hidSAPWarehouseAddress != "" && d.hidSAPWarehouseAddress != null)
                                    $("#hidSAPWarehouseAddress").val(d.hidSAPWarehouseAddress);
                            }
                        }
                    });

                    //Edit By Song Weiming on 2018-10-10 清指定批号订单不能删除明细行,且不可修改批号，不可修改任何内容
                    //备注：原coolite 订单列表与详情页采用相同Id订单类型同时绑定，导致后台获取条件一直为空，不满足清指定批号订单不能删除的要求，存在bug
                    if (EntityModel.OrderType == "ClearBorrowManual") {
                        EditColumnArrayIsExists(4); EditColumnArrayIsExists(5); EditColumnArrayIsExists(8); EditColumnArrayIsExists(11);
                        $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;//禁用编辑
                        $("#RstProductDetail").data("kendoGrid").columns[5].editable = true;
                        $("#RstProductDetail").data("kendoGrid").columns[8].editable = true;
                        $("#RstProductDetail").data("kendoGrid").columns[11].editable = true;
                        $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');
                        that.removeButton('BtnDelete');
                        that.removeButton('BtnSave');
                    }
                }
                    //如果是T1或LP或LS，且单据创建类型是临时
                else if (model.IsDealer && (model.DealerType == 'T1' || model.DealerType == 'LP' || model.DealerType == 'LS') && EntityModel.CreateType == "Temporary") {
                    //隐藏复制、保存草稿、删除草稿、申请关闭的按钮、显示提交、放弃修改按钮
                    $("#lbRejectReason").hide();
                    $('#QryRejectReason').hide();
                    that.removeButton('BtnCopy');
                    that.removeButton('BtnRevoke');
                    that.removeButton('BtnClose');
                    that.removeButton('BtnDelete');
                    that.removeButton('BtnSave');
                    //产品数量可编辑
                    EditColumnArray.push(4);
                    EditColumnArray.push(11);
                    $("#RstAttachmentDetail").data("kendoGrid").showColumn('Delete');//7,附件

                    $('#BtnChoiceHopital').FrameButton('enable');
                    $('#QryPickUpOrDeliver').FrameRadio('enable');  //Radio启用

                    //如果是特殊价格订单或交接订单、则可以修改价格
                    if (EntityModel.OrderType == 'SpecialPrice' || EntityModel.OrderType == 'Transfer') {
                        EditColumnArray.push(5);
                        $("#RstProductDetail").data("kendoGrid").columns[5].editable = false;//允许编辑
                    }
                    //已发货数量信息不显示
                    // $('#QryCarrier').FrameTextBox('disable');

                    if (EntityModel.OrderType == 'BOM') {
                        EditColumnArrayIsExists(4);
                        $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;
                        $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');

                    }

                    if (model.DealerType == 'LP' || model.DealerType == 'LS') {
                        $('#QryCrossDock').FrameTextBox('enable');
                        $('#QryCrossDock').parent().parent().show();
                    }
                    else {
                        $('#QryCrossDock').FrameTextBox('disable');
                        $('#QryCrossDock').parent().parent().hide();
                    }

                }
                else {
                    //产品数量不可编辑
                    EditColumnArrayIsExists(4);
                    EditColumnArrayIsExists(5);
                    EditColumnArrayIsExists(11);
                    $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;//禁用编辑
                    $("#RstProductDetail").data("kendoGrid").columns[5].editable = true;
                    $("#RstProductDetail").data("kendoGrid").columns[11].editable = true;

                    $("#RstProductDetail").data("kendoGrid").hideColumn('CanOrderNumber');
                    $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');
                    $("#RstAttachmentDetail").data("kendoGrid").hideColumn('Delete');//7,附件

                    //$('#QryProductLine').FrameDropdownList('disable');//Todo
                    $('#QryOrderType').FrameDropdownList('disable');
                    $('#QryWarehouse').FrameDropdownList('disable');
                    $('#QryShipToAddress').FrameDropdownList('disable');
                    if ($("#hidOrderType").val() == 'CRPO')
                        $('#QryPointType').FrameDropdownList('disable');

                    $('#QryRemark').FrameTextArea('disable');
                    $('#QrySpecialPrice').FrameDropdownList('disable');

                    $('#QryContactPerson').FrameTextBox('disable');
                    $('#QryContact').FrameTextBox('disable');
                    $('#QryContactMobile').FrameTextBox('disable');
                    $('#QryConsignee').FrameTextBox('disable');
                    $('#QryConsigneePhone').FrameTextBox('disable');

                    $('#QryRDD').FrameDatePicker({
                        format: "yyyy-MM-dd",
                        value: (model.QryRDD == "" || model.QryRDD == null) ? '' : new Date(model.QryRDD)
                    });
                    $('#QryRDD').FrameDatePicker('disable');//禁用时间框需将最小时间限制去掉，否则无法绑定事件
                    //$('#QryCarrier').FrameTextBox('disable');

                    //this.Toolbar1.Disabled = true;//Toolbar1下按钮块全禁用
                    that.removeButton('btnAddCfnSet');
                    that.removeButton('btnUserPoint');
                    that.removeButton('btnAddCfn');

                    that.removeButton('BtnSave');
                    that.removeButton('BtnDelete');
                    that.removeButton('BtnSubmit');
                    that.removeButton('BtnDiscardModify');
                    that.removeButton('BtnUsePro');

                    //如果不是物流平台和一级经销商
                    if (!model.IsDealer || (!model.DealerType == 'T1' && !model.DealerType == 'LP' && !model.DealerType == 'LS')) {
                        that.removeButton('BtnCopy');
                        that.removeButton('BtnRevoke');
                        that.removeButton('BtnClose');
                        $("#lbRejectReason").hide();
                        $('#QryRejectReason').hide();
                    }
                    else {
                        //如果单据类型不是交接订单、普通订单、特殊价格订单、近效期退换货订单、非近效期退换货订单、特殊清指定批号订单，则不能复制、不能撤销订单
                        if (EntityModel.OrderType == 'Normal' || EntityModel.OrderType == 'SpecialPrice' || EntityModel.OrderType == 'Transfer' || EntityModel.OrderType == 'PEGoodsReturn' || EntityModel.OrderType == 'EEGoodsReturn' || EntityModel.OrderType == 'BOM' || EntityModel.OrderType == 'PRO' || EntityModel.OrderType == 'CRPO') {

                            //单据状态不是“已提交”、“已同意”、“已进入SAP”，则不能撤销
                            if (EntityModel.OrderStatus != 'Submitted' && EntityModel.OrderStatus != 'Approved' && EntityModel.OrderStatus != 'Uploaded') {
                                that.removeButton('BtnRevoke');
                                $("#lbRejectReason").hide();
                                $('#QryRejectReason').hide();
                            }
                            if (EntityModel.OrderStatus != 'Delivering') {
                                that.removeButton('BtnClose');
                                $("#lbRejectReason").hide();
                                $('#QryRejectReason').hide();
                            }
                            if (EntityModel.OrderType == 'PRO' || EntityModel.OrderType == 'CRPO') {
                                that.removeButton('BtnClose');
                            }
                        }
                            //Edited By Song Yuqi On 2015-12-18 For 针对T1经销商短期寄售订单可以撤销和关闭 Begin
                        else if (EntityModel.OrderType == 'Consignment') {
                            //单据状态不是“已提交”、“已同意”、“已进入SAP”，则不能撤销
                            if (EntityModel.OrderStatus != 'Submitted' && EntityModel.OrderStatus != 'Approved' && EntityModel.OrderStatus != 'Uploaded') {
                                that.removeButton('BtnRevoke');
                                $("#lbRejectReason").hide();
                                $('#QryRejectReason').hide();
                            }
                            if (EntityModel.OrderStatus != 'Delivering') {
                                that.removeButton('BtnClose');
                                $("#lbRejectReason").hide();
                                $('#QryRejectReason').hide();
                            }
                        }
                        else if (EntityModel.OrderType == 'ClearBorrowManual') {
                            that.removeButton('BtnRevoke');
                        }
                            //Edited By Song Yuqi On 2015-12-18 For 针对T1经销商短期寄售订单可以撤销和关闭 End
                            //Edited By huyong 样品订单和短期寄售转移 可以撤销和修改，不能关闭↓
                        else if (EntityModel.OrderType == 'SampleApply' || EntityModel.OrderType == 'ZTKB') {
                            that.removeButton('BtnClose');
                        }
                        else {
                            that.removeButton('BtnCopy');
                            that.removeButton('BtnRevoke');
                            that.removeButton('BtnClose');
                            $("#lbRejectReason").hide();
                            $('#QryRejectReason').hide();
                        }
                        if (EntityModel.OrderType == 'PRO' || EntityModel.OrderType == 'CRPO' || EntityModel.OrderType == 'BOM') {
                            that.removeButton('BtnCopy');
                        }
                    }

                    $('#QryCrossDock').FrameTextBox('disable');
                    $('#QryCrossDock').parent().parent().hide();
                }

                that.InitBtnCfnAdd();
                if (model.QryPickUp)//自提清除医院信息，coolite存在bug
                    that.ChangePickUpOrDeliver();//初始化医院是否可用
                //列（显示）控制；编辑控制、按钮控制***********************************************************************************
                //上传附件按钮控制判断当前状态是不是为草稿状态，如果为草稿状态，则可以更新
                //判断当前状态是不是为草稿状态，如果为草稿状态，则可以更新
                if ("Draft" == EntityModel.OrderStatus) {
                    $('#BtnAddAttachment').FrameButton({
                        text: '添加附件',
                        icon: 'upload',
                        onClick: function () {
                            that.initUploadAttachDiv();
                        }
                    });
                }
                else {
                    that.removeButton('BtnAddAttachment');
                }

                $('#WinFileUpload').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=OrderApply&InstanceId=" + $("#InstanceId").val(),
                        autoUpload: true
                    },
                    select: function (e) {
                    },
                    validation: {
                    },
                    multiple: false,
                    success: function (e) {
                        that.refreshAttachment();
                    }
                });

                $('#BtnUploadAttach').FrameButton({
                    text: '上传附件',
                    onClick: function () {
                        that.UploadFile();
                    }
                });
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

    that.ChangePickUpOrDeliver = function () {
        var type = $('#QryPickUpOrDeliver').FrameRadio('getValue');
        $('.condition').hide();
        $('.condition-' + type.Key).css('display', '');
        if (type.Key == "0")//自提
        {
            $('#BtnChoiceHopital').FrameButton('disable');
            $("#QryHospitalAddress").FrameTextBox('disable');
            $('#QryTexthospitalname').FrameTextBox('setValue', '');
            $('#QryHospitalAddress').FrameTextBox('setValue', '');
            $("#QryPickUp").val('true');
            $("#QryDeliver").val('false');
        }
        else {
            $('#BtnChoiceHopital').FrameButton('enable');
            //$("#QryHospitalAddress").FrameTextBox('enable');
            $('#QryTexthospitalname').FrameTextBox('setValue', '');
            $('#QryHospitalAddress').FrameTextBox('setValue', '');
            $("#QryPickUp").val('false');
            $("#QryDeliver").val('true');
        }
    }

    that.InitpecialPrice = function (model) {
        var IsExistsSpecialPrice = model.LstSpecialPrice != null ? (model.LstSpecialPrice.length > 0 ? true : false) : false;
        //选择促销政策    
        $('#QrySpecialPrice').FrameDropdownList({
            dataSource: model.LstSpecialPrice,
            dataKey: 'PolicyId',
            dataValue: 'PolicyName',
            selectType: 'none',
            placeholder: "请选择促销政策",
            value: IsExistsSpecialPrice ? model.LstSpecialPrice[0] : '',
            onChange: function (s) {
                that.ChangeSpecialPrice(this.value);
            }
        });

        if (model.IsNewApply) {
            //$('#QrySpecialPrice').FrameDropdownList('setValue', model.LstSpecialPrice[0]);
            $("#hidSpecialPrice").val(IsExistsSpecialPrice ? model.LstSpecialPrice[0].PolicyId : '');
            //SpecialPriceInit();
        }
        else {
            if ($("#hidSpecialPrice").val() == '') {
                //  $('#QrySpecialPrice').FrameDropdownList('setValue', model.LstSpecialPrice[0]);
                $("#hidSpecialPrice").val(IsExistsSpecialPrice ? model.LstSpecialPrice[0].PolicyId : '');
                //SpecialPriceInit();
            }
            else {
                var cbSpecialPrice = "";
                $.each(LstSpecialPriceArr, function (index, val) {
                    if ($("#hidSpecialPrice").val() === val.PolicyId) {
                        cbSpecialPrice = { PolicyId: val.PolicyId, PolicyName: val.PolicyName };
                    }
                })
                //  $('#QrySpecialPrice').FrameDropdownList('setValue', cbSpecialPrice);
            }
        }

        //促销政策编号
        $('#QrySpecialPriceCode').FrameTextBox({
            value: '',
        });
        //促销政策内容
        $('#QryPolicyContent').FrameTextArea({
            value: '',
        });
        $('#QrySpecialPriceCode').FrameTextBox('disable');
        $('#QryPolicyContent').FrameTextArea('disable');
        //SpecialPriceInit初始化操作如下
        var PolicyNo = ""; var PolicyName = "";
        var index = $('#QrySpecialPrice').FrameDropdownList('getValue');
        if (index.Key >= 0) {
            $.each(LstSpecialPriceArr, function (index, val) {
                if (index == val.PolicyId) {
                    PolicyNo = val.PolicyNo;
                    PolicyName = val.PolicyName;
                }
            })
            $('#QrySpecialPriceCode').FrameTextBox('setValue', PolicyNo);
            $('#QryPolicyContent').FrameTextArea('setValue', PolicyName);
        }
    }
    //初始化控件状态
    that.ClearDetailWindow = function () {
        // Radio禁用
        $('#QryPickUpOrDeliver').FrameRadio('disable');
        $('#BtnChoiceHopital').FrameButton('disable');
        //$('#QryProductLine').FrameDropdownList('enable');//Todo
        $('#QryOrderType').FrameDropdownList('enable');
        $('#QryWarehouse').FrameDropdownList('enable');
        $('#QryShipToAddress').FrameDropdownList('enable');
        // $('#QryPointType').FrameDropdownList('enable');
        $('#QryPointType').parent().parent().hide();
        //that.removeButton("QryPointType");

        $('#QryTexthospitalname').FrameTextBox('disable');//禁用
        var HospitalAddress = $('#QryHospitalAddress').FrameTextBox('getValue');
        if (!HospitalAddress == "") {
            $("#QryHospitalAddress").FrameTextBox('enable');
        }
        else {
            $("#QryHospitalAddress").FrameTextBox('disable');
        }

        //表头
        $('#QryOrderNO').FrameTextBox('disable');
        $('#QrySubmitDate').FrameTextBox('disable');
        $('#QryOrderStatus').FrameTextBox('disable');
        $('#QryOrderTo').FrameTextBox('disable');
        $('#QryDealer').FrameTextBox('disable');

        //汇总信息
        $("#QryTotalAmount").FrameTextBox('disable');
        $("#QryTotalQty").FrameTextBox('disable');
        $("#QryTotalReceiptQty").FrameTextBox('disable');
        $('#QryRemark').FrameTextArea('enable');
        $("#QryVirtualDC").FrameTextBox('disable');
        //订单信息
        $("#lbRejectReason").show();
        $('#QryRejectReason').show();

        $('#QrySpecialPrice').FrameDropdownList('enable');
        $('#QrySpecialPriceCode').FrameTextBox('disable');
        $('#QryContactPerson').FrameTextBox('enable');
        $('#QryContact').FrameTextBox('enable');
        $('#QryContactMobile').FrameTextBox('enable');
        //收货信息
        $('#QryConsignee').FrameTextBox('enable');
        $('#QryConsigneePhone').FrameTextBox('enable');
        $('#QryRDD').FrameDatePicker('enable');
        //$('#QryCarrier').FrameTextBox('enable');

        $("#RstProductDetail").data("kendoGrid").columns[4].editable = false;//编辑
        $("#RstProductDetail").data("kendoGrid").columns[5].editable = true;
        $("#RstProductDetail").data("kendoGrid").columns[7].editable = true;
        $("#RstProductDetail").data("kendoGrid").showColumn('Amount');
        $("#RstProductDetail").data("kendoGrid").columns[11].editable = false;
        $("#RstProductDetail").data("kendoGrid").hideColumn('CanOrderNumber');
        $("#RstProductDetail").data("kendoGrid").showColumn('Delete');
        $("#RstProductDetail").data("kendoGrid").hideColumn('IsSpecial');
        $("#RstProductDetail").data("kendoGrid").hideColumn('PointAmount');//隐藏使用积分
        $("#RstProductDetail").data("kendoGrid").hideColumn('DiscountRate');//隐藏折扣率

        EditColumnArrayIsExists(5);
        $("#RstProductDetail").data("kendoGrid").columns[5].editable = true;
    }

    //产品明细点击执行：coolite按钮切换执行，kendo同一页直接执行
    that.InitBtnCfnAdd = function () {
        var data = FrameUtil.GetModel();
        //$('#btnAddCfnSet').empty();
        //$('#btnAddCfnSet').removeClass();
        if (data.hidOrderStatus == 'Draft') {
            //如果选择了成套设备类型的订单，则显示“添加成套设备”按钮
            if (data.QryOrderType.Key == 'BOM') {
                that.removeButton('btnAddCfn');
                $('#btnAddCfnSet').FrameButton({
                    text: '添加成套产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddProductSet();
                    }
                });

                EditColumnArrayIsExists(4);
                $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;//禁用编辑
                $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');
            }
            else {
                //Edit By Song Weiming on 2018-10-10 清指定批号订单不能删除明细行,且不可修改批号，不可修改任何内容
                if (data.QryOrderType.Key == 'ClearBorrowManual') {
                    EditColumnArrayIsExists(4); EditColumnArrayIsExists(5);
                    EditColumnArrayIsExists(8); EditColumnArrayIsExists(11);
                    $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;//禁用编辑
                    $("#RstProductDetail").data("kendoGrid").columns[5].editable = true;//禁用编辑
                    $("#RstProductDetail").data("kendoGrid").columns[8].editable = true;//禁用编辑
                    $("#RstProductDetail").data("kendoGrid").columns[11].editable = true;//禁用编辑
                    $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');

                }
                else {
                    EditColumnArray.push(4);
                    $("#RstProductDetail").data("kendoGrid").columns[4].editable = false;
                    $("#RstProductDetail").data("kendoGrid").showColumn('Delete');
                }

                //if (this.TabPanel1.ActiveTabIndex == 1)
                //{
                if (data.QryOrderType.Key == 'ClearBorrowManual') {
                    that.removeButton('btnAddCfn');
                    //$('#btnAddCfn').FrameButton('disable');
                    that.removeButton('btnAddCfnSet');
                }
                else {

                    $('#btnAddCfn').FrameButton({
                        text: '添加产品',
                        icon: 'plus',
                        onClick: function () {
                            that.AddProduct();
                        }
                    });
                    that.removeButton('btnAddCfnSet');
                }

                if (data.QryOrderType.Key == 'CRPO') {
                    $('#btnUserPoint').FrameButton({
                        text: '使用积分',
                        icon: 'file-o',
                        onClick: function () {
                            that.UserPoint();
                        }
                    });
                }
                else {
                    that.removeButton('btnUserPoint');
                }
                if (data.QryOrderType.Key == 'SpecialPrice') {
                    if (data.QrySpecialPrice.Key == "满额打折") {
                        //this.gpDetail.ColumnModel.SetEditable(4, false);
                        EditColumnArrayIsExists(5);
                        $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;//禁用编辑
                    }

                    if (data.hidIsUsePro == "0") {
                        $('#BtnUsePro').FrameButton({
                            text: '使用促销',
                            icon: 'file-o',
                            onClick: function () {
                                that.UserPo();
                            }
                        });

                        $('#btnAddCfn').FrameButton({
                            text: '添加产品',
                            icon: 'plus',
                            onClick: function () {
                                that.AddProduct();
                            }
                        });
                        if (data.QryOrderType.Key == 'BOM') {
                            $('#btnAddCfnSet').FrameButton({
                                text: '添加成套产品',
                                icon: 'plus',
                                onClick: function () {
                                    that.AddProductSet();
                                }
                            });
                        }
                    }
                    else {
                        EditColumnArrayIsExists(4);
                        $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;//禁用编辑
                        that.removeButton('BtnUsePro');
                        that.removeButton('btnAddCfn');
                        //$('#btnAddCfn').FrameButton('disable');
                    }
                }

                //}
                //else
                //{
                //    this.btnUsePro.Hide();
                //}
            }

        }
    }

    //根据选择的订单类型，设定仓库类型、价格类型
    function SetWarehosueType(cbOrderType) {
        //特殊价格订单(普通仓库、特殊价格)、寄售订单（寄售仓库、寄售价格）、普通订单（普通仓库、普通价格）、借货订单（借货仓库、寄售价格）、交接订单（普通仓库、普通价格）、特殊清指定批号订单（借货仓库、普通价格）
        if ('Normal' == cbOrderType || 'Transfer' == cbOrderType || 'PEGoodsReturn' == cbOrderType || 'EEGoodsReturn' == cbOrderType || 'BOM' == cbOrderType || 'Return' == cbOrderType) {
            $("#hidWareHouseType").val('Normal');
            $("#hidPriceType").val('Dealer');
        }
        else if ('ConsignmentSales' == cbOrderType) {
            $("#hidWareHouseType").val('Consignment');
            $("#hidPriceType").val('DealerConsignment');
        }
        else if ('Consignment' == cbOrderType) {
            $("#hidWareHouseType").val('Consignment,Borrow');
            $("#hidPriceType").val('DealerConsignment');
        }
        else if ('Consignment' == cbOrderType) {
            $("#hidWareHouseType").val('Consignment,Borrow');
            $("#hidPriceType").val('DealerConsignment');
        }
        else if ('Borrow' == cbOrderType || 'ClearBorrow' == cbOrderType || 'ClearBorrowManual' == cbOrderType || 'ZTKB' == cbOrderType || 'ZTKA' == cbOrderType) {
            $("#hidWareHouseType").val('Borrow');
            $("#hidPriceType").val('DealerConsignment');
        }
        else if ('SpecialPrice' == cbOrderType) {
            $("#hidWareHouseType").val('Normal');
            $("#hidPriceType").val('DealerSpecial');
        }
        else {
            $("#hidWareHouseType").val('Normal');
            $("#hidPriceType").val('Dealer');
        }

    }

    //根据产品线初始化特殊价格控件
    that.ProductLineInit = function () {
        var data = FrameUtil.GetModel();
        data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
        data.QryDealer = { Key: data.hidDealerId, Value: '' };
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ProductLineInit',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    //$('#QryProductLine').FrameDropdownList('disable');//Todo
                    //配送中心
                    $("#QryVirtualDC").FrameTextBox('setValue', model.QryVirtualDC);

                    //选择促销政策    
                    that.InitpecialPrice(model);
                    //coolite禁用的下拉获取不到值不执行权限控制；导致异常，选择不同订单与直接选择效果不一样
                    //if (!$('#QryProductLine').FrameDropdownList('getControl').element.context.disabled) {
                    if ($.trim(data.QryProductLine.Key) != "") {
                        if ("SpecialPrice" == $.trim(data.QryOrderType.Key)) {
                            $('#QrySpecialPrice').parent().parent().show();
                            $('#QrySpecialPriceCode').parent().parent().show();
                            $('#QryPolicyContent').parent().parent().show();

                            if (model.hidOrderStatus == "Draft") {
                                $('#BtnUsePro').FrameButton({
                                    text: '使用促销',
                                    icon: 'file-o',
                                    onClick: function () {
                                        that.UserPo();
                                    }
                                });
                            }
                            else {
                                that.removeButton('BtnUsePro');
                            }
                        }
                        else {
                            $('#QrySpecialPrice').parent().parent().hide();
                            $('#QrySpecialPriceCode').parent().parent().hide();
                            $('#QryPolicyContent').parent().parent().hide();

                            that.removeButton('BtnUsePro');
                        }
                    }
                    //}
                }
                FrameWindow.HideLoading();
            }
        });
    };


    //使用积分函数
    that.UserPoint = function () {
        if ($("#InstanceId").val() == '' || $("#hidDealerId").val() == '' || $("#hidProductLine").val() == '' || $("#hidPriceType").val() == '' || $("#hidOrderType").val() == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请等待数据加载完毕!',
            });
        }
        else {
            var data = FrameUtil.GetModel();
            var InstanceId = data.InstanceId;
            data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
            data.QryDealer = { Key: data.hidDealerId, Value: '' };
            if ($("#hidOrderType").val() == 'CRPO') {
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'CaculateFormValuePoint',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess) {
                            FrameWindow.ShowAlert({
                                alertType: 'info',
                                message: model.ExecuteMessage,
                            });
                        }
                        else {
                            FrameWindow.ShowAlert({
                                alertType: 'warning',
                                message: model.ExecuteMessage,
                            });
                        }
                        that.RefershHeadData();
                        FrameWindow.HideLoading();
                    }
                });

            } else {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'warning',
                    message: '非积分订单不能使用积分!',
                });
            }
        }
    }

    var createRstProductDetail = function (dataSource) {
        $("#RstProductDetail").kendoGrid({
            dataSource: {
                data: dataSource,
                schema: {
                    model: {
                        fields: {
                            RequiredQty: { type: "number", validation: { required: false, format: "{0:n0}", min: 1 } },
                            CfnPrice: { type: "number", validation: { required: false, format: "{0:n6}", min: 0 } },
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
                field: "Delete", title: "删除", width: '50px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;"
                },
                template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                attributes: {
                    "class": "text-center text-bold"
                },
            },
            {
                field: "CustomerFaceNbr", title: "产品型号", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "产品型号"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "CfnEnglishName", title: "产品英文名", width: 'auto', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "产品英文名"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "CfnChineseName", title: "产品中文名", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "产品中文名"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "RequiredQty", title: "订购数量", width: '60px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "订购数量"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "CfnPrice", title: "产品单价", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "产品单价"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "Uom", title: "单位", width: '40px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "单位"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "Amount", title: "金额小计", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "金额小计"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "CanOrderNumber", title: "可定数量", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "可定数量"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "ExpDate", title: "产品有效期", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "产品有效期"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "IsSpecial", title: "是否特殊价格", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "是否特殊价格"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "LotNumber", title: "批号", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "批号"
                }, attributes: { "class": "table-td-cell" }
            },

            {
                field: "ReceiptQty", title: "已发数量", width: '50px', editable: true, min: 1,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "已发数量"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "CurRegNo", title: "注册证编号-1", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "注册证编号-1"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "CurManuName", title: "生产企业(注册证-1)", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "生产企业(注册证-1)"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "LastRegNo", title: "注册证编号-2", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "注册证编号-2"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "LastManuName", title: "生产企业(注册证-2)", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "生产企业(注册证-2)"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "PointAmount", title: "使用积分", width: '80px', editable: true, hidden: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "使用积分"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "DiscountRate", title: "折扣率", width: '60px', editable: true, hidden: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "折扣率"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "PackageFactor", title: "发货规格", width: '60px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "发货规格"
                }, attributes: { "class": "table-td-cell" }
            }
            ],
            edit: function (e) {
                var numeric = e.container.find("input[name=RequiredQty]");
                numeric.keyup(function (k) {
                    //$(this).val($(this).val().replace(/^(0+)|[^\d]+/g, '').replace(/\D/g, '').replace(/^0*/g, '').replace(/[^1-9\.]/g, ''));
                    $(this).val($(this).val().replace(/\D/g, ''));
                    if ($(this).val() == "") $(this).val(1);
                });
                //numeric.blur(function (k) {
                //    if ($(this).val() == "") {
                //        e.sender.dataSource.cancelChanges();//撤销所有更改
                //        //$(this).val(1);//无效
                //    }
                //})
            },
            save: function (e) {
                var s = "";
            },
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
        //
        var grid = $("#RstProductDetail").data("kendoGrid");
        grid.bind("save", grid_save);
        function grid_save(e) {
            that.UpdateItem(e);
        }
    }

    var createRstInvoiceDetail = function (dataSource) {
        $("#RstInvoiceDetail").kendoGrid({
            dataSource: {
                data: dataSource,
                schema: {
                    model: {
                        fields: {
                            InvoiceDate: { type: "date", validation: { required: false, format: "{0:yyyy-MM-dd}" } }
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
                field: "InvoiceNo", title: "发票号码", width: '120px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "发票号码"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "InvoiceDate", title: "发票日期", width: '120px', editable: true, format: "{0:yyyy-MM-dd}",
                headerAttributes: {
                    "class": "text-center text-bold", "title": "发票日期"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "InvoiceAmount", title: "发票金额", width: '100px', editable: true,
                template: function (gridrow) { if (gridrow.InvoiceAmount == null || "" == gridrow.InvoiceAmount || undefined == gridrow.InvoiceAmount) gridrow.InvoiceAmount = 0; return gridrow.InvoiceAmount },
                headerAttributes: {
                    "class": "text-center text-bold", "title": "发票金额"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "InvoiceStatus", title: "发票状态", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "发票状态"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "ID733", title: "ERP系统发票号", width: '120px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "ERP系统发票号"
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
            dataBound: function (e) {
            }
        });
    }

    //发货明细
    var createRstShipDetail = function (dataSource) {
        $("#RstShipDetail").kendoGrid({
            dataSource: {
                data: dataSource,
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            columns: [
            {
                field: "SAPShipmentCode", title: "发货单号", width: '120px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "发货单号"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "SAPShipmentDate", title: "发货日期", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "发货日期"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "UPN", title: "发货产品型号", width: '150px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "发货产品型号"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "LotNumber", title: "发货产品批号", width: '150px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "发货产品批号"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "GenerateDate", title: "生产日期", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "生产日期"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "ExpiredDate", title: "有效期", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "有效期"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "ReceiptQty", title: "发货数量", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "发货数量"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "Carrier", title: "快递公司", width: 'auto', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "快递公司"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "TrackingNo", title: "快递单号", width: '120px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "快递单号"
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
            dataBound: function (e) {
            }
        });
    }
    //附件
    var createRstAttachmentDetail = function (dataSource) {
        $("#RstAttachmentDetail").kendoGrid({
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
                field: "Name", title: "附件名称", width: 'auto', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "附件名称"
                }
            },
            {
                field: "Identity_Name", title: "上传人", width: '150px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "上传人"
                }
            },
            {
                field: "UploadDate", title: "上传时间", width: '150px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "上传时间"
                }
            },
            {
                field: "Url", title: "Url", width: '150px', editable: true, hidden: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "Url"
                }
            },
            {
                title: "下载", width: '50px',
                headerAttributes: {
                    "class": "text-center text-bold", "title": "下载", "style": "vertical-align: middle;"
                },
                template: "<i class='fa fa-download' style='font-size: 14px; cursor: pointer;'></i>",
                attributes: {
                    "class": "text-center text-bold"
                },
            },
            {
                field: "Delete", title: "删除", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;"
                },
                template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                attributes: {
                    "class": "text-center text-bold"
                },
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
                var rows = this.items();
                $(rows).each(function () {
                    var index = $(this).index() + 1;
                    var rowLabel = $(this).find(".Row-Number");
                    $(rowLabel).html(index);
                });

                $("#RstAttachmentDetail").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.AttachmentDelete(data, data.Id, data.Url);
                });
                $("#RstAttachmentDetail").find(".fa-download").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    var url = '../Download.aspx?downloadname=' + escape(data.Name) + '&filename=' + escape(data.Url) + '&downtype=AdjustAttachment';
                    downloadfile(url);
                });

            }
        });
    }
    //初始化仓库（init中参数不全，无法一起查询）
    that.InitLstWarehouse = function () {
        var data = FrameUtil.GetModel();
        data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
        data.QryDealer = { Key: data.hidDealerId, Value: '' };
        FrameUtil.SubmitAjax({
            business: business,
            async: false,
            method: 'GetLstWarehouse',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //收货仓库
                if (model.IsNewApply) {//新增
                    if (model.LstWarehouse.length > 0) {
                        model.QryWarehouse = model.LstWarehouse[0];
                        $("#hidWarehouse").val(model.QryWarehouse.Key);
                    }
                }
                else {
                    if ($("#hidWarehouse").val() == "") {
                        if (model.LstWarehouse.length > 0) {
                            model.QryWarehouse = model.LstWarehouse[0];
                            $("#hidWarehouse").val(model.QryWarehouse.Key);
                        }
                    }
                    else {
                        $("#hidWarehouse").val(model.hidWarehouse);
                    }
                    $.each(model.LstWarehouse, function (index, val) {
                        if ($("#hidWarehouse").val() === val.Id)
                            model.QryWarehouse = {
                                Key: val.Id, Value: val.Name
                            };
                    })
                }
                $('#QryWarehouse').FrameDropdownList({
                    dataSource: model.LstWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    value: model.QryWarehouse,
                    onChange: function (s) {
                        that.WarehouseChanage(this.value);
                    }
                });
                FrameWindow.HideLoading();
            }
        });
    };
    //订单类型加载时刷新
    that.OrderTypeLoad = function (orderType) {
        SetWarehosueType(orderType);
        that.InitLstWarehouse();
        //cbWarehouse.store.reload();
        if (orderType == 'Transfer' || orderType == 'ConsignmentSales' || orderType == 'Consignment' || orderType == 'Return') {
            $("#RstProductDetail").data("kendoGrid").showColumn('LotNumber');
        } else {
            $("#RstProductDetail").data("kendoGrid").hideColumn('LotNumber');
        }
    }

    //修改仓库
    that.WarehouseChange = function (obj) {

        $("#hidWarehouse").val(obj);
        var Ware = {}; var address = "";
        $.each(LstWarehouseArr, function (index, val) {
            if (obj === val.Id) {
                Ware = { Key: obj, Value: val.Name };
                address = val.Address;
            }
        })
        $('#QryWarehouse').FrameDropdownList({
            dataSource: LstWarehouseArr,
            dataKey: 'Id',
            dataValue: 'Name',
            selectType: 'none',
            value: Ware,
            onChange: function (s) {
                that.WarehouseChanage(this.value);
            }
        });
        //收货地址
        $('#QryShipToAddress').FrameTextBox({
            value: address,
        });
    };

    //修改收货仓库
    that.WarehouseChanage = function () {
        var hidWarehouse = $("#hidWarehouse").val();
        var Warehouse = $('#QryWarehouse').FrameDropdownList('getValue').Key;
        var hidDealerTaxpayer = $("#hidDealerTaxpayer").val();
        var hidOrderType = $("#hidOrderType").val();
        //只有不是直销医院且或部位清指定订单变更仓库时才改变仓库（直销医院的清指定订单不可选择仓库）
        if ($("#hidDealerTaxpayer").val() != '直销医院' || hidOrderType != 'ClearBorrowManual') {
            if (Warehouse != hidWarehouse) {
                $("#hidWarehouse").val(Warehouse);
            }
        }
    }
    //修改收货仓库地址
    that.SAPWarehouseAddressChanage = function () {
        var hidSAPWarehouseAddress = $("#hidSAPWarehouseAddress").val();
        var SAPWarehouseAddress = $('#QryShipToAddress').FrameDropdownList('getValue').Key;
        if (SAPWarehouseAddress != hidSAPWarehouseAddress) {
            $("#hidSAPWarehouseAddress").val(SAPWarehouseAddress);
        }
    }

    //修改订单类型
    that.OrderTypeChange = function (orderTypeId) {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '改变订单类型将删除已添加的产品！',
            confirmCallback: function () {

                var data = FrameUtil.GetModel();
                data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
                data.QryDealer = { Key: data.hidDealerId, Value: '' };
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'ChangeOrderType',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        // that.ProductDetailControl();//确定控制按钮权限
                        that.InitBtnCfnAdd();
                        $("#hidOrderType").val(orderTypeId);
                        $("#hidWarehouse").val('');
                        $("#hidSpecialPrice").val('');
                        SetWarehosueType(orderTypeId);

                        if (orderTypeId == 'Transfer' || orderTypeId == 'ConsignmentSales' || orderTypeId == 'Consignment' || orderTypeId == 'Return') {
                            $("#RstProductDetail").data("kendoGrid").showColumn('LotNumber');
                        } else {
                            $("#RstProductDetail").data("kendoGrid").hideColumn('LotNumber');
                        }

                        if (orderTypeId == 'CRPO') {
                            $('#QryPointType').parent().parent().show();
                            $("#RstProductDetail").data("kendoGrid").showColumn('PointAmount');
                        } else {
                            $("#RstProductDetail").data("kendoGrid").hideColumn('PointAmount');
                            $('#QryPointType').parent().parent().hide();
                        }
                        if (orderTypeId == 'ClearBorrowManual') {
                            $("#RstProductDetail").data("kendoGrid").showColumn('DiscountRate');
                        } else {
                            $("#RstProductDetail").data("kendoGrid").hideColumn('DiscountRate');
                        }

                        //Coolite.AjaxMethods.OrderDetailWindowLP.SetSpecialPriceHidden();
                        //选择促销政策控件处理    
                        that.InitpecialPrice(model);
                        if ("SpecialPrice" == $.trim(data.QryOrderType.Key)) {
                            $('#QrySpecialPrice').parent().parent().show();
                            $('#QrySpecialPriceCode').parent().parent().show();
                            $('#QryPolicyContent').parent().parent().show();

                            if (model.hidOrderStatus == "Draft") {
                                $('#BtnUsePro').FrameButton({
                                    text: '使用促销',
                                    icon: 'file-o',
                                    onClick: function () {
                                        that.UserPo();
                                    }
                                });
                            }
                            else {
                                that.removeButton('BtnUsePro');
                            }
                        }
                        else {
                            $('#QrySpecialPrice').parent().parent().hide();
                            $('#QrySpecialPriceCode').parent().parent().hide();
                            $('#QryPolicyContent').parent().parent().hide();

                            that.removeButton('BtnUsePro');
                        }

                        //Coolite.AjaxMethods.OrderDetailWindowLP.SetSpecialPriceEdit();
                        //Edit By SongWeiming on 2018-10-10 清指定批号订单不可修改价格，不可删除明细记录 
                        //如果是特殊价格订单、交接订单、特殊清指定批号订单，则可以修改价格
                        //if (this.hidOrderType.Value.ToString() == PurchaseOrderType.SpecialPrice.ToString() || this.hidOrderType.Value.ToString() == PurchaseOrderType.Transfer.ToString() || this.hidOrderType.Value.ToString() == PurchaseOrderType.ClearBorrowManual.ToString())
                        if (orderTypeId == 'SpecialPrice' || orderTypeId == 'Transfer') {
                            EditColumnArray.push(5);
                            $("#RstProductDetail").data("kendoGrid").columns[5].editable = false;
                        }
                        else {
                            EditColumnArrayIsExists(5);
                            $("#RstProductDetail").data("kendoGrid").columns[5].editable = true;
                        }

                        that.RefershHeadData();
                        //$('#QryWarehouse').FrameDropdownList({
                        //    dataSource: model.LstWarehouse,
                        //    dataKey: 'Id',
                        //    dataValue: 'Name',
                        //    selectType: 'none',
                        //    value: model.QryWarehouse,
                        //    onChange: function (s) {
                        //        that.WarehouseChange(this.value);
                        //    }
                        //});
                        ////收货地址
                        //$('#QryShipToAddress').FrameTextBox({
                        //    value: model.QryShipToAddress,
                        //});


                        FrameWindow.HideLoading();
                    }
                });
            },
            cancelCallback: function () {
                var originalOrderType = '';
                $.each(LstLstOrderTypeArr, function (index, val) {
                    if ($("#hidOrderType").val() === val.Key)
                        originalOrderType = {
                            Key: $("#hidOrderType").val(), Value: val.Value
                        };
                })
                $('#QryOrderType').FrameDropdownList({
                    dataSource: LstLstOrderTypeArr,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: originalOrderType,
                    onChange: function (s) {
                        that.OrderTypeChange(this.value);
                    }
                });
            }
        });
    };
    //修改积分类型
    that.PointTypeChange = function (PointTypeId) {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确认修改吗！',
            confirmCallback: function () {
                //createRstDealerList([]);
                $("#hidPointType").val(PointTypeId);
                var data = FrameUtil.GetModel();
                data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
                data.QryDealer = { Key: data.hidDealerId, Value: '' };
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'ChangePointType',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        $("#RstProductDetail").data("kendoGrid").setOptions({
                            dataSource: []
                        });
                        that.RefershHeadData();
                        FrameWindow.HideLoading();
                    }
                });
            },
            cancelCallback: function () {
                var originalPointType = '';
                $.each(LstPointTypeArr, function (index, val) {
                    if ($("#hidPointType").val() === val.Key)
                        originalPointType = {
                            Key: $("#hidPointType").val(), Value: val.Value
                        };
                })
                $('#QryPointType').FrameDropdownList({
                    dataSource: LstPointTypeArr,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: originalPointType,
                    onChange: function (s) {
                        that.PointTypeChange(this.value);
                    }
                });
            }
        });
    };


    //修改产品线
    that.ProductLineChange = function (Bu) {
        //CheckAddItemsParam();
        if ($("#hiddenProductLineId").val() != Bu) {
            $("#hiddenProductLineId").val(Bu);
            FrameWindow.ShowConfirm({
                target: 'top',
                message: '改变产品线将删除已添加的产品',
                confirmCallback: function () {
                    $("#hidProductLine").val(Bu);
                    $("#hidOrderType").val($('#QryOrderType').FrameDropdownList('getValue').Key);
                    $("#hidTerritoryCode").val('');
                    var data = FrameUtil.GetModel();
                    data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
                    data.QryDealer = { Key: data.hidDealerId, Value: '' };
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'ChangeProductLine',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {

                            //Coolite.AjaxMethods.OrderDetailWindowLP.SetSpecialPriceHidden();
                            //选择促销政策控件处理    
                            that.InitpecialPrice(model);
                            if ("SpecialPrice" == $.trim(data.QryOrderType.Key)) {
                                debugger
                                $('#QrySpecialPrice').parent().parent().show();
                                $('#QrySpecialPriceCode').parent().parent().show();
                                $('#QryPolicyContent').parent().parent().show();

                                if (model.hidOrderStatus == "Draft") {
                                    $('#btnUserPoint').FrameButton({
                                        text: '使用积分',
                                        icon: 'file-o',
                                        onClick: function () {
                                            that.UserPoint();
                                        }
                                    });
                                }
                                else {
                                    that.removeButton('btnUserPoint');
                                }
                            }
                            else {
                                debugger
                                $('#QrySpecialPrice').parent().parent().hide();
                                $('#QrySpecialPriceCode').parent().parent().hide();
                                $('#QryPolicyContent').parent().parent().hide();

                                that.removeButton('btnUserPoint');
                            }

                            $("#RstProductDetail").data("kendoGrid").setOptions({
                                dataSource: []
                            });
                            that.RefershHeadData();
                            FrameWindow.HideLoading();
                        }
                    });
                },
                cancelCallback: function () {
                    var originalBu = '';
                    $.each(LstBuArr, function (index, val) {
                        if ($("#hidProductLine").val() === val.Key)
                            originalBu = {
                                Key: $("#hidProductLine").val(), Value: val.Value
                            };
                    })
                    $('#QryProductLine').FrameDropdownList({
                        dataSource: LstBuArr,
                        dataKey: 'Key',
                        dataValue: 'Value',
                        selectType: 'none',
                        value: originalBu,
                        onChange: function (s) {
                            that.ProductLineChange(this.value);
                        }
                    });
                }

            });
        }
    }

    //Edit by Songweiming on 2013-11-4 特殊价格选择暂时先不使用(ChangeSpecialPrice注释不使用)
    //设定特殊价格规则编号
    that.ChangeSpecialPrice = function (SpecialPrice) {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '改变特殊价格规则将删除已添加的产品！',
            confirmCallback: function () {
                $("#hidSpecialPrice").val(SpecialPrice);
                var data = FrameUtil.GetModel();
                data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
                data.QryDealer = { Key: data.hidDealerId, Value: '' };
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'ChangeSpecialPrice',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {

                        //若选择的政策是“满额送赠品”或"一次性特殊价格",可以修改价格，否则不能修改
                        if (SpecialPrice == "满额打折") {
                            $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;
                            $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;
                        }
                        else {
                            $("#RstProductDetail").data("kendoGrid").columns[4].editable = false;
                            $("#RstProductDetail").data("kendoGrid").columns[5].editable = false;
                        }

                        if (model.IsNewApply) {
                            //$('#QrySpecialPrice').FrameDropdownList('setValue', model.LstSpecialPrice[0]);
                            $("#hidSpecialPrice").val(model.LstSpecialPrice[0].PolicyId);
                            //SpecialPriceInit();
                        }
                        else {
                            if ($("#hidSpecialPrice").val() == '') {
                                //  $('#QrySpecialPrice').FrameDropdownList('setValue', model.LstSpecialPrice[0]);
                                $("#hidSpecialPrice").val(model.LstSpecialPrice[0].PolicyId);
                                //SpecialPriceInit();
                            }
                            else {
                                var cbSpecialPrice = "";
                                $.each(LstSpecialPriceArr, function (index, val) {
                                    if ($("#hidSpecialPrice").val() === val.PolicyId) {
                                        cbSpecialPrice = { PolicyId: val.PolicyId, PolicyName: val.PolicyName };
                                    }
                                })
                                //  $('#QrySpecialPrice').FrameDropdownList('setValue', cbSpecialPrice);
                            }
                        }
                        //SpecialPriceInit初始化操作如下
                        var PolicyNo = ""; var PolicyName = "";
                        var index = $('#QrySpecialPrice').FrameDropdownList('getValue');
                        if (index.Key >= 0) {
                            $.each(LstSpecialPriceArr, function (index, val) {
                                if (index == val.PolicyId) {
                                    PolicyNo = val.PolicyNo;
                                    PolicyName = val.PolicyName;
                                }
                            })
                            $('#QrySpecialPriceCode').FrameTextBox('setValue', PolicyNo);
                            $('#QryPolicyContent').FrameTextArea('setValue', PolicyName);
                        }

                        $("#RstProductDetail").data("kendoGrid").setOptions({
                            dataSource: []
                        });
                        that.RefershHeadData();
                        FrameWindow.HideLoading();
                    }
                });
            },
            cancelCallback: function () {
                var originalSpecialPrice = '';
                $.each(LstSpecialPriceArr, function (index, val) {
                    if ($("#hidSpecialPrice").val() === val.PolicyId)
                        originalSpecialPrice = {
                            Key: $("#hidSpecialPrice").val(), Value: val.PolicyName
                        };
                })
                $('#QrySpecialPrice').FrameDropdownList({
                    dataSource: LstSpecialPriceArr,
                    dataKey: 'PolicyId',
                    dataValue: 'PolicyName',
                    selectType: 'none',
                    placeholder: "请选择促销政策",
                    value: originalSpecialPrice,
                    onChange: function (s) {
                        that.ChangeSpecialPrice(this.value);
                    }
                });
            }

        });
    }
    //更新表头信息，修改dropdownlist、添加产品、删除行数据/修改行数量更新表头信息
    //目前行数量编辑没单行更新，故不需要更新
    that.RefershHeadData = function () {
        var data = FrameUtil.GetModel();
        data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
        data.QryDealer = { Key: data.hidDealerId, Value: '' };
        FrameUtil.SubmitAjax({
            business: business,
            method: 'RefershHeadData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstProductDetail").data("kendoGrid").setOptions({
                    dataSource: model.RstProductDetail
                });
                $("#QryTotalAmount").FrameTextBox('setValue', model.QryTotalAmount);
                $("#QryTotalQty").FrameTextBox('setValue', model.QryTotalQty);
                $("#QryTotalReceiptQty").FrameTextBox('setValue', model.QryTotalReceiptQty);
                FrameWindow.HideLoading();
            }
        });
    }

    //添加产品
    that.AddProduct = function () {
        var IscfnDialog = false;
        var data = FrameUtil.GetModel();
        var hidInstanceId = data.InstanceId;
        var hidProductLine = $("#hidProductLine").val();
        var hidDealerId = $("#hidDealerId").val();
        var hidPriceType = $("#hidPriceType").val();
        var hidOrderType = $("#hidOrderType").val();
        var hidSpecialPrice = $("#hidSpecialPrice").val();
        var cbOrderType = data.QryOrderType.Key;
        if (hidInstanceId == '' || hidDealerId == '' || hidProductLine == '' || hidPriceType == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: "存在产品线/经销商/付款类型为空！",
            });
        }
        else {
            var ptid = hidPriceType + '@' + cbOrderType;
            if (hidOrderType == 'PRO') //OrderCfnDialogT2PRO hidInstanceId hidProductLine hidDealerId hidPriceType+'@'+cbOrderType
            {
                IscfnDialog = true;
                //RefreshDetailCFNPROWindow    
                url = Common.AppVirtualPath + 'Revolution/Pages/Order/OrderCfnDialogLPPROPicker.aspx?hidInstanceId=' + hidInstanceId + '&&hidProductLine=' + hidProductLine + '&&hidDealerId=' + hidDealerId + '&&ptid=' + hidPriceType + '&&spid=' + hidSpecialPrice + '&&otype=' + hidOrderType
            }
            else {//OrderCfnDialog hidInstanceId hidProductLine hidDealerId hidDealerId hidPriceType+'@'+cbOrderType
                url = Common.AppVirtualPath + 'Revolution/Pages/Order/OrderCfnDialogLPPicker.aspx?hidInstanceId=' + hidInstanceId + '&&hidProductLine=' + hidProductLine + '&&hidDealerId=' + hidDealerId + '&&ptid=' + hidPriceType + '&&spid=' + hidSpecialPrice + '&&otype=' + hidOrderType
            }

            FrameWindow.OpenWindow({
                target: 'top',
                title: '添加产品',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (d) {
                    if (d) {
                        if (IscfnDialog) {
                            var pickearr = "";
                            var checkpickearr = "";
                            var pickedList = d[0];
                            var checkparamList = d[1];
                            var data = FrameUtil.GetModel();
                            data.InstanceId = $('#InstanceId').val();

                            for (var i = 0; i <= pickedList.length - 1; i++) {
                                pickearr += pickedList[i] + ","
                            }
                            for (var i = 0; i <= checkparamList.length - 1; i++) {
                                checkpickearr += checkparamList[i] + "|"
                            }
                            data.PickerParams = pickearr;
                            data.CheckpickearrParams = checkpickearr;
                            data.IscfnDialog = true;
                        }
                        else {
                            var pickearr = "";
                            var pickedList = d;
                            var data = FrameUtil.GetModel();
                            data.InstanceId = $('#InstanceId').val();
                            for (var i = 0; i <= pickedList.length - 1; i++) {
                                pickearr += pickedList[i] + ","
                            }
                            data.PickerParams = pickearr;
                            data.IscfnDialog = false;
                        }
                        data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
                        data.QryDealer = { Key: data.hidDealerId, Value: '' };
                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'DoAddProductItems',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                $("#RstProductDetail").data("kendoGrid").setOptions({
                                    dataSource: model.RstProductDetail
                                });
                                that.RefershHeadData();
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                }
            });
        }
    }
    //添加成套产品
    that.AddProductSet = function () {
        var data = FrameUtil.GetModel();
        var hidInstanceId = data.InstanceId;
        var hidProductLine = $("#hidProductLine").val();
        var hidDealerId = $("#hidDealerId").val();
        var hidPriceType = $("#hidPriceType").val();
        var hidOrderType = $("#hidOrderType").val();
        var cbOrderType = data.QryOrderType.Key;

        if (hidInstanceId == '' || hidDealerId == '' || hidProductLine == '' || hidPriceType == '' || hidOrderType == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: "存在订单类型/产品线/经销商/付款类型为空！",
            });
        }
        else {
            //OrderT2CfnSetDialog hidInstanceId hidProductLine hidDealerId hidPriceType hidOrderType
            url = Common.AppVirtualPath + 'Revolution/Pages/Order/OrderCfnSetDialogLPPicker.aspx?InstanceId=' + hidInstanceId + '&&hidProductLine=' + hidProductLine + '&&hidDealerId=' + hidDealerId + '&&hidPriceType=' + hidPriceType + '&&hidOrderType=' + hidOrderType;

            FrameWindow.OpenWindow({
                target: 'top',
                title: '添加成套产品',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (d) {
                    if (d) {
                        var pickearr = "";
                        var list = d;
                        var data = FrameUtil.GetModel();

                        for (var i = 0; i <= list.length - 1; i++) {
                            pickearr += list[i] + ","
                        }
                        data.PickerParams = pickearr;
                        data.hidDealerId = hidDealerId;
                        data.hidPriceType = $("#hidPriceType").val();
                        data.QryDealer = { Key: data.hidDealerId, Value: data.QryDealer };

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'DoAddProductSetItems',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                $("#RstProductDetail").data("kendoGrid").setOptions({
                                    dataSource: model.RstProductDetail
                                });
                                that.RefershHeadData();
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                }
            });
        }
    };
    //选择医院、
    that.ChoiceHospital = function () {
        var data = FrameUtil.GetModel();
        if (data.IptProductLine == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线'
            });
        }
        else {

            url = Common.AppVirtualPath + 'Revolution/Pages/Order/OrderHospitalPicker.aspx?' + 'ProductLine=' + data.QryProductLine.Key

            FrameWindow.OpenWindow({
                target: 'top',
                title: '医院选择',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    if (list) {
                        var hospitalname = list[0].HospitalName;
                        var HOS_Address = list[0].HospitalAddress;
                        $('#QryTexthospitalname').FrameTextBox('setValue', hospitalname);

                        $('#QryHospitalAddress').FrameTextBox({
                            value: HOS_Address,
                        });
                        $("#QryHospitalAddress").FrameTextBox('enable');

                    }
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
                if (model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '删除成功',
                    });
                    that.RefershHeadData();
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'Delete',
                        message: model.ExecuteMessage,
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    }

    ///产品明细修改保存
    that.UpdateItem = function (e) {
        var data = {};
        var param = FrameUtil.GetModel();
        data.InstanceId = param.InstanceId;
        data.QryOrderType = param.QryOrderType;
        data.EditItemId = e.model.Id;
        if (e.values.LotNumber) {
            data.EditLot = e.values.LotNumber;
        }
        else {
            data.EditLot = e.model.LotNumber
        }
        if (e.values.RequiredQty) {
            data.EditQty = e.values.RequiredQty;
        }
        else {
            data.EditQty = e.model.RequiredQty
        }
        if (e.values.CfnPrice) {
            data.EditCfnPrice = e.values.CfnPrice;
        }
        else {
            data.EditCfnPrice = e.model.CfnPrice
        }
        if (e.values.CustomerFaceNbr) {
            data.EditUpn = e.values.CustomerFaceNbr;
        }
        else {
            data.EditUpn = e.model.CustomerFaceNbr
        }
        var PackageFactor = 0;
        if (e.values.PackageFactor) {
            PackageFactor = e.values.PackageFactor;
        }
        else {
            PackageFactor = e.model.PackageFactor
        }
        if (data.EditQty % PackageFactor != 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'Info',
                message: '订购数量必须为发货规格的整数倍',
            });
            that.RefershHeadData();
            return;
        }
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'UpdateItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    var msg = "";
                    if (model.hidRtnVal == "LotTooLong") {
                        msg = "输入的产品编号过长，长度为30";
                    } else if (model.hidRtnVal == "LotNotExists") {
                        msg = "输入的产品编号不存在";
                    } else if (model.hidRtnVal == "LotExisted") {
                        msg = "输入的产品编号已存在";
                    }
                    else if (model.hidRtnVal == "LotPriceExisted") {
                        msg = "相同价格的产品已经存在";
                    }
                    if (msg != "") {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: msg,
                        });
                    }
                    that.RefershHeadData();
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'Delete',
                        message: model.ExecuteMessage,
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    };
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
                async: false,
                data: data,
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
    //复制订单
    that.Copy = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确认要执行此操作？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
                data.QryDealer = { Key: data.hidDealerId, Value: '' };
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DoCopy',
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
                                message: '复制成功！',
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
    };
    //撤销
    that.DoRevoke = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确认要执行此操作？',
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
    //使用促销
    //coolite使用促销之后后台Draft变成‘草稿’,bug?
    that.UserPo = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确认要执行此操作？',
            confirmCallback: function () {
                var data = {
                };
                var param = FrameUtil.GetModel();
                data.InstanceId = param.InstanceId;
                data.QrySpecialPrice = param.QrySpecialPrice;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'UsePro',
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
                                message: model.ExecuteMessage,
                            });
                            //促销
                            if (model.UseProStatus) {
                                //$('#QryProductLine').FrameDropdownList('disable');//Todo
                                $('#QryOrderType').FrameDropdownList('disable');
                                $('#QryWarehouse').FrameDropdownList('disable');
                                $('#QryShipToAddress').FrameDropdownList('disable');
                                //积分类型隐藏
                                $('#QryPointType').parent().parent().hide();

                                //表头
                                $('#QryOrderNO').FrameTextBox('disable');
                                $('#QrySubmitDate').FrameTextBox('disable');
                                $('#QryOrderStatus').FrameTextBox('disable');
                                $('#QryOrderTo').FrameTextBox('disable');
                                $('#QryDealer').FrameTextBox('disable');

                                //汇总信息
                                $("#QryTotalAmount").FrameTextBox('disable');
                                $("#QryTotalQty").FrameTextBox('disable');
                                $("#QryTotalReceiptQty").FrameTextBox('disable');
                                $('#QryRemark').FrameTextArea('disable');
                                $("#QryVirtualDC").FrameTextBox('disable');

                                //订单信息
                                $("#lbRejectReason").hide();
                                $('#QryRejectReason').hide();
                                $('#QrySpecialPrice').FrameDropdownList('disable');
                                $('#QrySpecialPriceCode').FrameTextBox('disable');
                                $('#QryContactPerson').FrameTextBox('disable');
                                $('#QryContact').FrameTextBox('disable');
                                $('#QryContactMobile').FrameTextBox('disable');

                                //收货信息
                                //this.txtShipToAddress.ReadOnly = false;
                                $('#QryConsignee').FrameTextBox('disable');
                                $('#QryConsigneePhone').FrameTextBox('disable');
                                $('#QryRDD').FrameDatePicker('disable');
                                // $('#QryCarrier').FrameTextBox('disable');
                                //所有按钮,除了提交都无效
                                $('#BtnDelete').FrameButton('enable');
                                $('#BtnDiscardModify').FrameButton('disable');
                                $('#BtnSubmit').FrameButton('enable');
                                $('#BtnCopy').FrameButton('disable');
                                $('#BtnRevoke').FrameButton('disable');
                                $('#BtnClose').FrameButton('disable');
                                $('#BtnSave').FrameButton('disable');
                                $('#BtnUsePro').FrameButton('disable');

                                $("#hidIsUsePro").val("1");

                                if ($('#QrySpecialPrice').FrameDropdownList('getValue').Key == "满额打折") {//禁用编辑
                                    EditColumnArrayIsExists(4); EditColumnArrayIsExists(5);
                                    $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;
                                    $("#RstProductDetail").data("kendoGrid").columns[5].editable = true;
                                }
                            }
                            that.RefershHeadData();
                        }
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    };
    //放弃修改
    that.Discard = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确认要执行此操作？',
            confirmCallback: function () {
                var data = {
                };
                var param = FrameUtil.GetModel();
                data.InstanceId = param.InstanceId;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DoDiscardModify',
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
                            top.deleteTabsCurrent();
                        }
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    };
    //申请关闭
    that.Close = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确认要执行此操作？',
            confirmCallback: function () {
                var data = {
                };
                var param = FrameUtil.GetModel();
                data.InstanceId = param.InstanceId;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DoClose',
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
                                message: '已申请关闭',
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
    };

    //保存草稿
    that.Save = function () {
        var data = that.GetModel();
        //验证产品线，否则无法带出订单（分子公司和品牌）
        if ($.trim(data.QryProductLine.Key) == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线',
            });
        }
        else {
            data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
            data.QryDealer = { Key: data.hidDealerId, Value: '' };
            //var EditRow = [];
            //var RstDetailList = data.RstDetailList;
            //for (var i = 0; i < RstDetailList.length; i++) {
            //    var r = {
            //        Id: RstDetailList[i].Id,
            //        RequiredQty: RstDetailList[i].RequiredQty,
            //        Amount: RstDetailList[i].Amount,
            //    };
            //    EditRow.push(r);
            //}
            //data.EditRowParams = JSON.stringify(EditRow);

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

    //****************提交操作***************
    that.Submit = function () {
        var data = that.GetModel();
        data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
        data.QryDealer = { Key: data.hidDealerId, Value: '' };

        var message = that.CheckForm(data);

        //校验组套产品订购数量
        if ($.trim(data.QryOrderType.Key) == 'BOM') {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'ValidateBOMQty',
                url: Common.AppHandler,
                data: data,
                async: false,
                callback: function (model) {
                    if (model.BOMQtyMsg == "0") {
                        message.push('组套产品订购数量超额，不能提交！');
                    }
                    FrameWindow.HideLoading();
                },
                failCallback: function (e) {
                    message.push('校验组套产品订购数量错误');
                    FrameWindow.HideLoading();
                }
            });
        }

        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            if ($.trim(data.QryOrderType.Key) == 'CRPO') {
                $("#hidPointCheckErr").val("0");
                FrameWindow.ShowLoading();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'CaculateFormValuePoint',
                    url: Common.AppHandler,
                    data: data,
                    async: false,
                    callback: function (model) {

                        if (!model.IsSuccess) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'error',
                                message: model.ExecuteMessage,
                            });
                            FrameWindow.HideLoading();
                        }
                        else {
                            $("#hidPointCheckErr").val(model.hidPointCheckErr);
                            if (model.hidPointCheckErr == "1") {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'warning',
                                    message: model.ExecuteMessage + "不能提交该订单",
                                });
                                FrameWindow.HideLoading();
                            }
                            else {
                                FrameWindow.ShowConfirm({
                                    target: 'top',
                                    message: model.ExecuteMessage + '确定要执行此操作?',
                                    confirmCallback: function () {
                                        var data = that.GetModel();
                                        data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
                                        data.QryDealer = { Key: data.hidDealerId, Value: '' };

                                        FrameUtil.SubmitAjax({
                                            business: business,
                                            method: 'CheckSubmit',
                                            url: Common.AppHandler,
                                            data: data,
                                            async: false,
                                            callback: function (model) {
                                                if (!model.IsSuccess) {
                                                    FrameWindow.ShowAlert({
                                                        target: 'top',
                                                        alertType: 'error',
                                                        message: model.ExecuteMessage,
                                                    });
                                                    FrameWindow.HideLoading();
                                                }
                                                else {
                                                    if (model.hidRtnVal == "Success") {
                                                        that.submitOption(data);
                                                    }
                                                    else if (model.hidRtnVal == "Error") {
                                                        FrameWindow.ShowAlert({
                                                            target: 'top',
                                                            alertType: 'error',
                                                            message: model.hidRtnMsg,
                                                        });
                                                        FrameWindow.HideLoading();
                                                    }
                                                    else if (model.hidRtnVal == "Warn") {
                                                        FrameWindow.ShowConfirm({
                                                            target: 'top',
                                                            message: model.hidRtnMsg,
                                                            confirmCallback: function () {
                                                                that.submitOption(data);
                                                            },
                                                            cancelCallback: function () {
                                                                FrameWindow.HideLoading();
                                                            }
                                                        });
                                                    }
                                                }
                                            }
                                        });
                                    },
                                    cancelCallback: function () {
                                        FrameWindow.HideLoading();
                                    }
                                });
                            }
                        }
                    }
                });
            }
            else if ($.trim(data.QryOrderType.Key) == 'CRPO') {
                FrameWindow.ShowLoading();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'ValidateBOMQty',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (!model.IsSuccess) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'error',
                                message: model.ExecuteMessage,
                            });
                            FrameWindow.HideLoading();
                        }
                        else {
                            if (model.BOMQtyMsg == "0") {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'warning',
                                    message: '组套产品订购数量超额，不能提交！',
                                });
                                FrameWindow.HideLoading();
                            }
                            else {
                                FrameWindow.HideLoading();
                                FrameWindow.ShowConfirm({
                                    target: 'top',
                                    message: '确定要执行此操作?',
                                    confirmCallback: function () {
                                        var data = that.GetModel();
                                        data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
                                        data.QryDealer = { Key: data.hidDealerId, Value: '' };

                                        FrameWindow.ShowLoading();
                                        FrameUtil.SubmitAjax({
                                            business: business,
                                            method: 'CheckSubmit',
                                            url: Common.AppHandler,
                                            data: data,
                                            callback: function (model) {
                                                if (!model.IsSuccess) {
                                                    FrameWindow.ShowAlert({
                                                        target: 'top',
                                                        alertType: 'error',
                                                        message: model.ExecuteMessage,
                                                    });
                                                    FrameWindow.HideLoading();
                                                }
                                                else {
                                                    if (model.hidRtnVal == "Success") {
                                                        that.submitOption(data);
                                                    }
                                                    else if (model.hidRtnVal == "Error") {
                                                        FrameWindow.ShowAlert({
                                                            target: 'top',
                                                            alertType: 'error',
                                                            message: model.hidRtnMsg,
                                                        });
                                                        FrameWindow.HideLoading();
                                                    }
                                                    else if (model.hidRtnVal == "Warn") {
                                                        FrameWindow.ShowConfirm({
                                                            target: 'top',
                                                            message: model.hidRtnMsg,
                                                            confirmCallback: function () {
                                                                that.submitOption(data);
                                                            },
                                                            cancelCallback: function () {
                                                                FrameWindow.HideLoading();
                                                            }
                                                        });
                                                        FrameWindow.HideLoading();
                                                    }
                                                }
                                            }
                                        });
                                    },
                                    cancelCallback: function () {
                                        FrameWindow.HideLoading();
                                    }
                                });
                            }
                        }
                    }
                });
            }
            else {
                FrameWindow.ShowLoading();
                FrameWindow.ShowConfirm({
                    target: 'top',
                    message: '确定要执行此操作?',
                    confirmCallback: function () {
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'CheckSubmit',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                if (!model.IsSuccess) {
                                    FrameWindow.ShowAlert({
                                        target: 'top',
                                        alertType: 'error',
                                        message: model.ExecuteMessage,
                                    });
                                    FrameWindow.HideLoading();
                                }
                                else {
                                    if (model.hidRtnVal == "Success") {
                                        that.submitOption(data);
                                    }
                                    else if (model.hidRtnVal == "Error") {
                                        FrameWindow.ShowAlert({
                                            target: 'top',
                                            alertType: 'error',
                                            message: model.hidRtnMsg,
                                        });
                                        FrameWindow.HideLoading();
                                    }
                                    else if (model.hidRtnVal == "Warn") {
                                        FrameWindow.ShowConfirm({
                                            target: 'top',
                                            message: model.hidRtnMsg,
                                            confirmCallback: function () {
                                                that.submitOption(data);
                                            },
                                            cancelCallback: function () {
                                                FrameWindow.HideLoading();
                                            }
                                        });
                                        FrameWindow.HideLoading();
                                    }
                                }
                            }
                        });
                    },
                    cancelCallback: function () {
                        FrameWindow.HideLoading();
                    }
                });
            }
        }
    }
    that.submitOption = function (data) {
        //var productCount = $("#RstProductDetail").data("kendoGrid")._data.length;
        //var EditRow = [];
        //var RstDetailList = data.RstDetailList;
        //for (var i = 0; i < RstDetailList.length; i++) {
        //    var r = {
        //        Id: RstDetailList[i].Id,
        //        RequiredQty: RstDetailList[i].RequiredQty,
        //        Amount: RstDetailList[i].Amount,
        //    };
        //    EditRow.push(r);
        //}
        //data.EditRowParams = JSON.stringify(EditRow);

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
    };
    //******************提交操作***************
    //推送ERP
    that.PushToERP = function () {
        var data = that.GetModel();
        data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
        data.QryDealer = { Key: data.hidDealerId, Value: '' };

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'PushToERP',
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
                        message: '推送成功',
                        callback: function () {
                            top.deleteTabsCurrent();
                        }
                    });

                }
                FrameWindow.HideLoading();
            }
        });
    }
    //****************附件**********
    that.initUploadAttachDiv = function (CName, EName, DealerType) {
        $("#winUploadAttachLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
            actions: [
        "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("上传附件").center().open();

    }

    //刷新文件
    that.refreshAttachment = function () {
        var data = FrameUtil.GetModel();
        data.QryPointType = data.QryPointType == null ? { Key: '', Value: '' } : data.QryPointType;
        data.QryDealer = { Key: data.hidDealerId, Value: '' };
        FrameUtil.SubmitAjax({
            business: business,
            method: 'AttachmentStore_Refresh',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                var dataSource = $("#RstAttachmentDetail").data("kendoGrid").dataSource.data();
                for (var i = 0; i < model.LstAttachmentList.length; i++) {
                    var exists = false;
                    for (var j = 0; j < dataSource.length; j++) {
                        if (dataSource[j].Id == model.LstAttachmentList[i].Id) {
                            exists = true;
                        }
                    }
                    if (!exists) {
                        $("#RstAttachmentDetail").data("kendoGrid").dataSource.add(model.LstAttachmentList[i]);
                    }
                }
                $("#RstAttachmentDetail").data("kendoGrid").setOptions({
                    dataSource: $("#RstAttachmentDetail").data("kendoGrid").dataSource
                });
                FrameWindow.HideLoading();
            }
        });
    }
    //删除附件
    that.AttachmentDelete = function (dataItem, Id, AttachmentName) {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '是否要删除该附件文件?',
            confirmCallback: function () {
                var data = {
                };
                data.AttachmentId = Id;
                data.AttachmentName = AttachmentName;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteAttachment',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'Delete',
                            message: '删除附件成功',
                        });
                        $("#RstAttachmentDetail").data("kendoGrid").dataSource.remove(dataItem);
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    };
    function downloadfile(url) {
        var iframe = document.createElement("iframe");
        iframe.src = url;
        iframe.style.display = "none";
        document.body.appendChild(iframe);
    }
    //****************附件**********


    that.CheckInt = function () {
        var r = /^[0-9]*$/;
        var IptConsignmentDay = $('#IptConsignmentDay').FrameTextBox('getValue')
        var IptDelayNumber = $('#IptDelayNumber').FrameTextBox('getValue')
        if (!r.test(IptConsignmentDay)) {
            $("#IptConsignmentDay_Control").val("");
        }
        if (!r.test(IptDelayNumber)) {
            $("#IptDelayNumber_Control").val("");
        }

    }

    that.CheckForm = function (data) {
        var message = [];
        var reg = '^[0-9]*$';
        //AllowBlank = "false"//必选项
        if ($.trim(data.QryOrderType.Key) == '') {
            message.push('请选择订单类型');
        }
        if ($.trim(data.QryProductLine.Key) == '') {
            message.push('请选择产品线');
        }
        if ($.trim(data.QryOrderType.Key) == 'CRPO') {
            if ($.trim(data.QryPointType.Key) == "") {
                message.push('请选择积分类型');
            }
        }
        if ($.trim(data.QryOrderType.Key) == 'SpecialPrice' && $.trim(data.QrySpecialPrice.Key) == '') {
            message.push('请选择特殊价格规则');
        }
        if ($.trim(data.QryContactPerson) == "" || $.trim(data.QryContact) == "" || $.trim(data.QryContactMobile) == "") {
            message.push('请填写完整的联系人信息');
        }
        if ($.trim(data.QryContactMobile) != "" && (isNaN(data.QryContactMobile) || $.trim(data.QryContactMobile).length != 11)) {
            message.push('请填写正确的手机号码');
        }
        //if ($.trim(data.QryWarehouse.Key) == '') {
        //    message.push('请选择收货仓库');
        //}
        //if ($.trim(data.QryShipToAddress.Key) == '') {
        //    message.push('请选择收货地址');
        //}
        if ($.trim(data.QryConsignee) == "" || $.trim(data.QryConsigneePhone) == "") {
            message.push('请填写完整的收货人信息');
        }
        if ($.trim(data.QryContact) == '') {
            message.push('请填写邮箱地址');
        }
        else {
            reg = /^[a-z0-9]+([._\\-]*[a-z0-9])*@(([a-zA-Z0-9_-])+\.)+([a-zA-Z0-9_-]{2,5})$/;
            if (!reg.test(data.QryContact)) {
                message.push('请输入正确的邮箱地址');
            }
        }

        return message;
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

    var setLayout = function () {
    }
    that.removeButton = function (obj) {
        $('#' + obj + '').empty();
        $('#' + obj + '').removeClass();
        $('#' + obj + '').unbind();
    };

    return that;
}();


