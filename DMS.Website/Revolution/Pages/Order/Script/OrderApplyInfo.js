var OrderApplyInfo = {};

OrderApplyInfo = function () {
    var that = {};

    var business = 'Order.OrderApplyInfo';
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
    var LstBuArr = "";
    var LstLstOrderTypeArr = "";
    var LstPointTypeArr = "";

    that.Init = function () {
        var data = {};
        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.IsNewApply = Common.GetUrlParam('IsNew');
        data.QryOrderType = { Key: "", Value: "" };
        $("#IsNewApply").val(Common.GetUrlParam('IsNew'));
        $("#InstanceId").val(Common.GetUrlParam('InstanceId'));

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                EditColumnArray = [];
                EntityModel = JSON.parse(model.EntityModel);
                LstWarehouseArr = model.LstWarehouse;
                LstBuArr = model.LstBu;
                LstLstOrderTypeArr = model.LstOrderType;
                LstPointTypeArr = model.LstPointType;

                $("#InstanceId").val(model.InstanceId);
                $("#hidOrderStatus").val(model.hidOrderStatus);
                $("#hidDealerId").val(model.hidDealerId);
                $("#hidPriceType").val(model.hidPriceType);
                $("#hidOrderType").val(model.hidOrderType);
                $("#hidPointType").val(model.hidPointType);
                $("#hidVenderId").val(model.hidVenderId);//父节点承运商
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
                if (EntityModel.OrderType == "CRPO") {
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
                }


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

                $("#QryProductLine").FrameDropdownList('disable');
                if (!model.cbProductLineWinDisabled)
                    $("#QryProductLine").FrameDropdownList('enable');

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
                $('#QryDealer').FrameDropdownList({
                    dataSource: model.LstDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseName',
                    selectType: 'none',
                    value: model.QryDealer,
                });
                $("#QryDealer").FrameDropdownList('disable');

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
                //付款方式
                var LstPayType = [{ Key: "经销商付款", Value: "经销商付款" }, { Key: "第三方付款", Value: "第三方付款" }];
                if (model.hidpayment == "经销商付款")
                    model.QryPaymentTpype = LstPayType[0];
                if (model.hidpayment == "第三方付款")
                    model.QryPaymentTpype = LstPayType[1];
                $('#QryPaymentTpype').FrameDropdownList({
                    dataSource: LstPayType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryPaymentTpype,
                });
                //Rsm
                $('#QrySales').FrameTextBox({
                    value: model.QrySales,
                    readonly: true
                });
                $('#QryCrossDock').FrameTextBox({
                    value: ''
                });

                //***********************************表单表头信息************
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
                $('#QryRemark').FrameTextArea({
                    value: model.QryRemark,

                });
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
                //拒绝理由
                //$('#QryRejectReason').FrameTextBox({
                //    value: model.QryRejectReason,
                //});
                //收货仓库

                if (model.IsNewApply) {//新增
                    if (model.LstWarehouse.length > 0) {
                        model.QryWarehouse = model.LstWarehouse[0];
                        $("#hidWarehouse").val(model.QryWarehouse.Key);
                    }
                    model.QryShipToAddress = model.QryWarehouse.Address;
                }
                else {
                    $("#hidWarehouse").val(model.hidWarehouse);
                    $.each(model.LstWarehouse, function (index, val) {
                        if (model.hidWarehouse === val.Id)
                            model.QryWarehouse = {
                                Key: model.hidWarehouse, Value: val.Name
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
                        that.WarehouseChange(this.value);
                    }
                });
                //收货地址
                $('#QryShipToAddress').FrameTextBox({
                    value: model.QryShipToAddress,
                    //readonly: true
                });
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
                createRstAttachmentDetail(model.LstAttachmentList);
                $('#RstOperationLog').DmsOperationLog({
                    dataSource: model.RstLogDetail
                });

                //*******************初始化******************
                //Init原始数据
                that.ProductDetailControl();
                SetWarehosueType($("#hidOrderType").val());
                that.IsShowpaymentType(model.IsExistsPaymentTypBYDma, $("#hidOrderType").val());

                $("#RstProductDetail").data("kendoGrid").columns[3].editable = false;//允许编辑
                $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;//不允许编辑，不可修改金额
                $("#RstProductDetail").data("kendoGrid").columns[6].editable = true;
                $("#RstProductDetail").data("kendoGrid").showColumn('Amount');
                $("#RstProductDetail").data("kendoGrid").hideColumn('LotNumber');

                if (model.IsDealer && model.DealerType == "T2" && model.hidOrderStatus == "Draft") {
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

                    if (EntityModel.OrderType == "CRPO") {
                        $('#btnUserPoint').FrameButton({
                            text: '使用积分',
                            icon: 'file-o',
                            onClick: function () {
                                that.UserPoint();
                            }
                        });
                        $("#RstProductDetail").data("kendoGrid").showColumn('PointAmount ');
                    }
                    EditColumnArray.push(3);
                    $("#RstProductDetail").data("kendoGrid").showColumn('Delete');//8
                    $("#RstAttachmentDetail").data("kendoGrid").showColumn('Delete');//7,附件
                    if (EntityModel.OrderType == "CRPO") {
                        $('#QryPointType').parent().parent().show();
                        $("#RstProductDetail").data("kendoGrid").showColumn('PointAmount ');
                    }
                }
                else {
                    EditColumnArrayIsExists(3);
                    $('#QryProductLine').FrameDropdownList('disable');
                    $('#QryOrderType').FrameDropdownList('disable');
                    $('#QryWarehouse').FrameDropdownList('disable');
                    $('#QryPaymentTpype').FrameDropdownList('disable');

                    $('#QryRemark').FrameTextArea('disable');
                    $('#QryContactPerson').FrameTextBox('disable');
                    $('#QryContact').FrameTextBox('disable');
                    $('#QryContactMobile').FrameTextBox('disable');
                    $('#QryConsignee').FrameTextBox('disable');
                    $('#QryConsigneePhone').FrameTextBox('disable');
                    $('#QryCarrier').FrameTextBox('disable');
                    if (EntityModel.OrderType == "CRPO")
                        $('#QryPointType').FrameDropdownList('disable');

                    $('#QryRDD').FrameDatePicker({
                        format: "yyyy-MM-dd",
                        value: (model.QryRDD == "" || model.QryRDD == null) ? ' ' : new Date(model.QryRDD)
                    });
                    $('#QryRDD').FrameDatePicker('disable');//禁用时间框需将最小时间限制去掉，否则无法绑定事件

                    //this.Toolbar1.Disabled = true;
                    $("#RstProductDetail").data("kendoGrid").columns[3].editable = true;//不允许编辑
                    $("#RstProductDetail").data("kendoGrid").hideColumn('Amount');
                    $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');//8
                    $("#RstProductDetail").data("kendoGrid").showColumn('LotNumber');//9
                    $("#RstAttachmentDetail").data("kendoGrid").hideColumn('Delete');//7,附件

                    $('#BtnSave').remove();
                    $('#BtnDelete').remove();
                    $('#BtnSubmit').remove();

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
                    if (EntityModel.OrderType == "CRPO") {
                        $('#QryPointType').parent().parent().show();
                        $("#RstProductDetail").data("kendoGrid").showColumn('PointAmount ');
                    }
                    //如果不是二级经销商，则隐藏复制按钮
                    if (!model.IsDealer || !(model.DealerType == "T2")) {
                        $('#BtnCopy').remove();
                        $('#BtnRevoke').remove();
                    }
                    else {
                        //如果是二级经销商，但单据的类型是“寄售销售订单”，则隐藏复制按钮 & 隐藏撤销按钮
                        //防止由于时间差导致订单尚未进入SAP OR ERP，寄售销售订单均不允许撤销
                        if (EntityModel.OrderType == "ConsignmentSales") {
                            $('#BtnCopy').remove();
                            $('#BtnRevoke').remove();
                        }

                        if (EntityModel.OrderType == "BOM") {
                            $('#BtnCopy').remove();
                        }

                        //单据状态不是“已提交”、“已同意”，则不能撤销
                        if (EntityModel.OrderStatus != "Submitted" && EntityModel.OrderStatus != "Approved") {
                            $('#BtnRevoke').remove();
                        }

                    }
                }

                //如果是促销订单，汇总价格为0lijie add 20161023
                if (EntityModel.OrderType == "PRO") {
                    $("#QryTotalAmount").FrameTextBox({
                        value: "0",
                    })
                }


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
                    $('#BtnAddAttachment').remove();
                }

                $('#WinFileUpload').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=OrderApply&InstanceId=" + $("#InstanceId").val(),
                        autoUpload: true
                    },
                    select: function (e) {

                    },
                    validation: {
                        //allowedExtensions: [".pdf"],
                    },
                    multiple: false,
                    success: function (e) {
                        //刷新附件列表
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

    //根据选择的订单类型，设定仓库类型、价格类型
    function SetWarehosueType(cbOrderType) {
        if ('Normal' == cbOrderType || 'Exchange' == cbOrderType) {
            $("#hidWareHouseType").val('Normal');
            $("#hidPriceType").val('Dealer');
        }
        else if ('Consignment' == cbOrderType || 'ConsignmentSales' == cbOrderType || 'SCPO' == cbOrderType) {
            $("#hidWareHouseType").val('Consignment');
            $("#hidPriceType").val('DealerConsignment');
        }
        else if ('PRO' == cbOrderType || 'CRPO' == cbOrderType) {
            $("#hidWareHouseType").val('Normal');
            $("#hidPriceType").val('Base');
        }
        else {
            $("#hidWareHouseType").val('Normal');
            $("#hidPriceType").val('Dealer');
        }
    }
    that.IsShowpaymentType = function (bl, cbOrderType) {
        if (bl && cbOrderType == "Normal") {
            //如果是普通订单，且经销商在表中有记录，要选择付款方式
            $("#IsShowpaymentType").show();
            $("#hidpaymentType").val("true");
        }
        else {
            $("#IsShowpaymentType").hide();
            $("#hidpaymentType").val("false");

            var LstPayType = [{ Key: "经销商付款", Value: "经销商付款" }, { Key: "第三方付款", Value: "第三方付款" }];
            var QryPaymentTpype = LstPayType[0];
            $('#QryPaymentTpype').FrameDropdownList({
                dataSource: LstPayType,
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'none',
                value: QryPaymentTpype,
                onChange: function (e) {
                    that.PaymentChanges(this.value);
                }
            });
        }
    }
    //订单明细按钮控制
    that.ProductDetailControl = function () {
        var data = FrameUtil.GetModel();
        if ("Draft" == data.hidOrderStatus) {
            //如果选择了成套设备类型的订单，则显示“添加成套设备”按钮
            if ("BOM" == data.QryOrderType.Key) {
                $('#btnAddCfnSet').FrameButton({
                    text: '添加成套产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddProductSet();
                    }
                });
                $('#btnAddCfn').empty();
                $('#btnAddCfn').removeClass();
                EditColumnArrayIsExists(3);
                $("#RstProductDetail").data("kendoGrid").columns[3].editable = true;
                $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');//8
            }
            else {
                if ("CRPO" == data.QryOrderType.Key) {
                    //this.btnUserPoint.Show();
                    $('#btnUserPoint').FrameButton({
                        text: '使用积分',
                        icon: 'file-o',
                        onClick: function () {
                            that.UserPoint();
                        }
                    });
                }
                else {
                    $('#btnUserPoint').empty();
                    $('#btnUserPoint').removeClass();
                }

                $('#btnAddCfn').FrameButton({
                    text: '添加产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddProduct();
                    }
                });
                $('#btnAddCfnSet').empty();
                $('#btnAddCfnSet').removeClass();

                EditColumnArray.push(3);
                $("#RstProductDetail").data("kendoGrid").columns[3].editable = false;//编辑
                $("#RstProductDetail").data("kendoGrid").showColumn('Delete');//8
            }
        }
    };
    //修改付款方式
    that.PaymentChanges = function (payType) {
        $("#hidpayment").val(payType);
    };
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
                that.WarehouseChange(this.value);
            }
        });
        //收货地址
        $('#QryShipToAddress').FrameTextBox({
            value: address,
        });
    };

    //使用积分函数
    that.UserPoint = function () {
        if ($("#hidInstanceId").val() == '' || $("#hidDealerId").val() == '' || $("#hidProductLine").val() == '' || $("#hidPriceType").val() == '' || $("#hidOrderType").val() == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请等待数据加载完毕!',
            });
        }
        else {
            var data = FrameUtil.GetModel();
            var InstanceId = data.InstanceId;
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
                            CfnPrice: { type: "number", validation: { required: false, format: "{0:n6}", min: 0 } }
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
                field: "CustomerFaceNbr", title: "产品型号", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "产品型号"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "CfnEnglishName", title: "产品英文名", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "产品英文名"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "CfnChineseName", title: "产品中文名", width: '120px', editable: true,
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
                field: "CfnPrice", title: "产品单价", width: '60px', editable: true,
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
                field: "ReceiptQty", title: "已发数量", width: '60px', editable: true, min: 1,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "已发数量"
                }, attributes: { "class": "table-td-cell" }
            },
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
                field: "LotNumber", title: "批号", width: '80px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "批号"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "CurRegNo", title: "注册证编号-1", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "注册证编号-1"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "CurManuName", title: "生产企业(注册证-1)", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "生产企业(注册证-1)"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "LastRegNo", title: "注册证编号-2", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "注册证编号-2"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "LastManuName", title: "生产企业(注册证-2)", width: '100px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "生产企业(注册证-2)"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "PointAmount", title: "使用积分", width: '100px', editable: true, hidden: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "使用积分"
                }, attributes: { "class": "table-td-cell" }
            },
            {
                field: "RedInvoicesAmount", title: "使用额度", width: '100px', editable: true, hidden: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "使用额度"
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
        var grid = $("#RstProductDetail").data("kendoGrid");
        grid.bind("save", grid_save);
        function grid_save(e) {
            that.UpdateItem(e);
        }
    }
    ///产品明细修改保存
    that.UpdateItem = function (e) {
        var data = {};
        var param = FrameUtil.GetModel();
        data.InstanceId = param.InstanceId;
        data.ItemId = e.model.Id;
        if (e.values.RequiredQty) {
            data.RequiredQty = e.values.RequiredQty;
        }
        else {
            data.RequiredQty = e.model.RequiredQty
        }
        var PackageFactor = 0;
        if (e.values.PackageFactor) {
            PackageFactor = e.values.PackageFactor;
        }
        else {
            PackageFactor = e.model.PackageFactor
        }
        if (data.RequiredQty % PackageFactor != 0) {
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
                that.RefershHeadData();
                FrameWindow.HideLoading();
            }
        });
    };

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

    function ChangeReasonEditor(container, options) {

        var PurchaseResult = [];
        var data = FrameUtil.GetModel();
        data.PmaId = options.model.PmaId;
        data.LotNumber = options.model.LotNumber;
        data.QRCode = options.model.QRCode;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'PurchaseOrderStore_RefershData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                PurchaseResult = model.LstPurchase;
                $('<input data-bind="value:' + options.field + '"/>')
    .appendTo(container)
    .kendoDropDownList({
        autoBind: true,
        dataTextField: "PurchaseOrderNbr",
        dataValueField: "Id",
        index: -1,
        dataSource: PurchaseResult,
        select: function (s) {
            that.SaveItem(s.dataItem, options.model);
        }
    })
                FrameWindow.HideLoading();
            }
        });


    };
    that.SaveItem = function (obj, model) {
        var data = that.GetModel();
        var EditRow = [];
        var r = {
            Id: model.Id,
            LotNumber: model.LotNumber,
            AdjustQty: model.AdjustQty,
            ExpiredDate: model.ExpiredDate,
            PurchaseOrderId: obj.Id,
            QRCode: model.QRCode,
            QRCodeEdit: model.QRCodeEdit,//二维码
            ToDealer: model.ChineseName,//转移经销商
            UPN: model.UPN,
        };
        EditRow.push(r);
        data.EditRows = JSON.stringify(EditRow);

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DropListSaveItem',
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
                    $("#RstProductDetail").data("kendoGrid").setOptions({
                        dataSource: $("#RstProductDetail").data("kendoGrid").dataSource
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    }

    //修改订单类型
    that.OrderTypeChange = function (orderTypeId) {

        FrameWindow.ShowConfirm({
            target: 'top',
            message: '改变订单类型将删除已添加的产品！',
            confirmCallback: function () {
                that.ProductDetailControl();//确定控制按钮权限
                $("#hidOrderType").val(orderTypeId);
                $("#hidWarehouse").val('');
                SetWarehosueType(orderTypeId);

                if (orderTypeId == 'CRPO') {
                    $("#RstProductDetail").data("kendoGrid").showColumn('PointAmount');//显示积分列
                    $('#QryPointType').parent().parent().show();
                    $('#QryPointType').FrameDropdownList({
                        dataSource: LstPointTypeArr,
                        dataKey: 'Key',
                        dataValue: 'Value',
                        selectType: 'none',
                        value: '',
                        onChange: function (s) {
                            that.PointTypeChange(this.value);
                        }
                    });
                } else {
                    $("#RstProductDetail").data("kendoGrid").hideColumn('PointAmount');
                    $('#QryPointType').parent().parent().hide();
                }

                var data = FrameUtil.GetModel();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'ChangeOrderType',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        $("#RstProductDetail").data("kendoGrid").setOptions({
                            dataSource: []
                        });
                        that.RefershHeadData();
                        LstWarehouseArr = model.LstWarehouse;
                        $('#QryWarehouse').FrameDropdownList({
                            dataSource: model.LstWarehouse,
                            dataKey: 'Id',
                            dataValue: 'Name',
                            selectType: 'none',
                            value: '',
                            onChange: function (s) {
                                that.WarehouseChange(this.value);
                            }
                        });
                        //收货地址
                        $('#QryShipToAddress').FrameTextBox({
                            value: model.QryShipToAddress,
                        });

                        that.IsShowpaymentType(model.IsExistsPaymentTypBYDma, data.QryOrderType.Key);

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
            message: '变更积分类型将删除原有产品！',
            confirmCallback: function () {
                //createRstDealerList([]);
                $("#hidPointType").val(PointTypeId);
                var data = FrameUtil.GetModel();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'ChangePointType',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        //$("#RstProductDetail").data("kendoGrid").setOptions({
                        //    dataSource: []
                        //});
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
                    $("#hidTerritoryCode").val('');
                    var data = FrameUtil.GetModel();
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'ChangeProductLine',
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
    //更新表头信息，修改dropdownlist、添加产品、删除行数据/修改行数量更新表头信息
    //目前行数量编辑没单行更新，故不需要更新
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
        var cbOrderType = data.QryOrderType.Key;
        debugger
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
                url = Common.AppVirtualPath + 'Revolution/Pages/Order/OrderCfnDialogT2PROPicker.aspx?hidInstanceId=' + hidInstanceId + '&&hidProductLine=' + hidProductLine + '&&hidDealerId=' + hidDealerId + '&&ptid=' + ptid;
            }
            else {//OrderCfnDialog hidInstanceId hidProductLine hidDealerId hidDealerId hidPriceType+'@'+cbOrderType
                url = Common.AppVirtualPath + 'Revolution/Pages/Order/OrderCfnDialogPicker.aspx?hidInstanceId=' + hidInstanceId + '&&hidProductLine=' + hidProductLine + '&&hidDealerId=' + hidDealerId + '&&ptid=' + ptid;
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
                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'DoAddProductItems',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                //var dataSource = $("#RstProductDetail").data("kendoGrid").dataSource.data();

                                //for (var i = 0; i < model.RstProductDetail.length; i++) {
                                //    var exists = false;
                                //    for (var j = 0; j < dataSource.length; j++) {
                                //        if (dataSource[j].Id == model.RstProductDetail[i].Id) {
                                //            exists = true;
                                //        }
                                //    }

                                //    if (!exists) {
                                //        $("#RstProductDetail").data("kendoGrid").dataSource.add(model.RstProductDetail[i]);
                                //    }
                                //}
                                //$("#RstDetailList").data("kendoGrid").dataSource.fetch();
                                $("#RstProductDetail").data("kendoGrid").setOptions({
                                    //dataSource: $("#RstProductDetail").data("kendoGrid").dataSource
                                    dataSource: model.RstProductDetail
                                });
                                that.RefershHeadData();//添加产品之后更新表头信息
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
            url = Common.AppVirtualPath + 'Revolution/Pages/Order/OrderT2CfnSetDialogPicker.aspx?InstanceId=' + hidInstanceId + '&&hidProductLine=' + hidProductLine + '&&hidDealerId=' + hidDealerId + '&&hidPriceType=' + hidPriceType + '&&hidOrderType=' + hidOrderType;

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
                        data.hidPriceTypeId = $("#hidPriceType").val();

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'DoAddProductSetItems',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                //var dataSource = $("#RstProductDetail").data("kendoGrid").dataSource.data();

                                //for (var i = 0; i < model.RstProductDetail.length; i++) {
                                //    var exists = false;
                                //    for (var j = 0; j < dataSource.length; j++) {
                                //        if (dataSource[j].Id == model.RstProductDetail[i].Id) {
                                //            exists = true;
                                //        }
                                //    }

                                //    if (!exists) {
                                //        $("#RstProductDetail").data("kendoGrid").dataSource.add(model.RstProductDetail[i]);
                                //    }
                                //}
                                ////$("#RstDetailList").data("kendoGrid").dataSource.fetch();
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
    //复制订单
    that.Copy = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确认要执行此操作？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
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
        var message = that.CheckForm(data);

        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            $("#hidPointCheckErr").val("0");
            if ($.trim(data.QryOrderType.Key) == 'CRPO') {
                FrameWindow.ShowLoading();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'CaculateFormValuePoint',
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
                                FrameWindow.HideLoading();
                                FrameWindow.ShowConfirm({
                                    target: 'top',
                                    message: '确定要执行此操作?',
                                    confirmCallback: function () {
                                        var data = that.GetModel();
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
                                                        FrameWindow.HideLoading();
                                                        FrameWindow.ShowConfirm({
                                                            target: 'top',
                                                            message: model.hidRtnMsg,
                                                            confirmCallback: function () {
                                                                that.submitOption(data);
                                                            }
                                                        });
                                                    }
                                                }
                                            }
                                        });
                                    }
                                });
                            }
                        }
                    }
                });
            }
            else {
                FrameWindow.ShowConfirm({
                    target: 'top',
                    message: '确定要执行此操作?',
                    confirmCallback: function () {
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
                                        FrameWindow.HideLoading();
                                        FrameWindow.ShowConfirm({
                                            target: 'top',
                                            message: model.hidRtnMsg,
                                            confirmCallback: function () {
                                                that.submitOption(data);
                                            }
                                        });
                                    }
                                }
                            }
                        });
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
        if ($.trim(data.QryDealer.Key) == '') {
            message.push('请选择经销商');
        }
        if ($.trim(data.QryOrderType.Key) != 'SCPO' && $.trim(data.QryWarehouse.Key) == '') {
            message.push('请选择收货仓库');
        }
        if ($.trim(data.QryShipToAddress) != 'SCPO' && $.trim(data.QryShipToAddress) == '') {
            message.push('请填写收货地址');
        }
        if ($.trim(data.QryRemark).length > 200) {
            message.push('备注信息字符数不能大于200');
        }
        if ($.trim(data.QryOrderType.Key) == 'CRPO' && $.trim(data.QryPointType.Key) == '') {
            message.push('请选择积分类型');
        }
        if ($.trim(data.hidpaymentType) == "true" && $.trim(data.hidpayment) == "") {
            message.push('请选择付款方式');
        }
        else if ($.trim(data.hidpaymentType) != "true" && $.trim(data.hidpayment) == "第三方付款") {
            message.push('没有融资准入资格的经销商不能选择第三方付款');
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

    return that;
}();


