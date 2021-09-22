var InventoryReturnInfo = {};

InventoryReturnInfo = function () {
    var that = {};
    var business = 'Inventory.InventoryReturnInfo';
    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.RstDetailList = $("#RstProductDetail").data("kendoGrid").dataSource.data();
        return model;
    }
    var EditColumnArray = [];//编辑列
    var EntityModel = {};
    var LstAdjustTypeArr = [];
    var LstDealerArr = [];
    var LstBuArr = [];
    var LstStatusArr = "";
    var LstLstDealerToListArr = "";
    var RsmHidden = false;//Rsm
    var PageStatus = false;
    var PurchaseResult = [];//关联订单
    var PurchaseNbrId = "";
    var LstToDealer = [];//转移经销商
    var SelectTodealerId = "";

    that.Init = function () {
        var data = {};
        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.hiddenReturnType = Common.GetUrlParam('Type');
        data.QryAdjustType = Common.GetUrlParam('AdjustType');
        data.IsNewApply = Common.GetUrlParam('IsNew');
        $("#QryAdjustType").val(Common.GetUrlParam('AdjustType'));
        $("#hiddenReturnType").val(Common.GetUrlParam('Type'));
        $("#IsNewApply").val(Common.GetUrlParam('IsNew'));
        PageStatus = Common.GetUrlParam('IsNew') == 'true' ? true : false;

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                EntityModel = JSON.parse(model.EntityModel);
                //$("#IsNewApply").val(model.IsNewApply);
                $("#QryAdjustType").val(model.QryAdjustType);
                $("#hiddenDealerId").val(model.hiddenDealerId);
                $("#hiddenDealerType").val(model.hiddenDealerType);
                $("#hiddApplyType").val(model.hiddApplyType);
                $("#hiddenAdjustTypeId").val(model.hiddenAdjustTypeId);
                $("#hiddenProductLineId").val(model.hiddenProductLineId);
                $("#hidSalesAccount").val(model.hidSalesAccount);
                $("#hiddenReason").val(model.hiddenReason);
                $("#hiddenWhmType").val(model.hiddenWhmType);
                $("#InstanceId").val(model.InstanceId);
                $("#hiddenReturnType").val(model.hiddenReturnType);
                $("#hiddenIsRsm").val(model.hiddenIsRsm);
                RsmHidden = model.RsmHidden;
                LstBuArr = model.LstBu;
                //LstStatusArr = model.LstStatus;
                //LstLstDealerToListArr = model.LstDealerToList;
                LstAdjustTypeArr = model.LstAdjustType;
                LstDealerArr = model.LstDealer;

                //经销商
                var DealerName = "";
                $.each(model.LstDealer, function (index, val) {
                    if (model.hiddenDealerId === val.Id)
                        model.QryDealerWin = { Key: model.hiddenDealerId, Value: val.ChineseName };
                })

                //$('#QryDealerWin').DmsDealerFilter({
                //    dataSource: [{ DealerId: model.QryDealerWin.Key, DealerName: model.QryDealerWin.Value }],//model.LstDealer,
                //    delegateBusiness: business,
                //    dataKey: 'DealerId',
                //    dataValue: 'DealerName',
                //    selectType: 'none',
                //    filter: 'contains',
                //    serferFilter: true,
                //    value: model.QryDealerWin,
                //    onChange: function (s) {
                //        that.DealerWinChanange(this.value);
                //    }
                //});
                $('#QryDealerWin').FrameDropdownList({
                    dataSource: model.LstDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'none',
                    filter: 'contains',
                    value: model.QryDealerWin,
                    onChange: function (s) {
                        that.DealerWinChanange(this.value);
                    }
                });

                //退换货单号
                $('#QryAdjustNumberWin').FrameTextBox({
                    value: model.QryAdjustNumberWin,
                });
                $('#QryAdjustNumberWin').FrameTextBox('disable');
                //退换货日期
                $('#QryAdjustDateWin').FrameTextBox({
                    value: model.QryAdjustDateWin,
                });
                $('#QryAdjustDateWin').FrameTextBox('disable');

                //产品线 ,IsNewApply不能使用
                if (PageStatus) {
                    if (model.LstBu != null) {
                        if (model.LstBu.length > 0) {
                            model.QryProductLineWin = { Key: model.LstBu[0].Key, Value: model.LstBu[0].Value };
                            $("#hiddenProductLineId").val(model.LstBu[0].Key);
                        }
                    }
                }
                else {
                    $.each(model.LstBu, function (index, val) {
                        if (dms.common.ToLowerCaseFn(model.hiddenProductLineId) === dms.common.ToLowerCaseFn(val.Key))
                            model.QryProductLineWin = { Key: hiddenProductLineId, Value: val.Value };
                    })
                }

                $('#QryProductLineWin').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryProductLineWin,
                    onChange: function (s) {
                        that.ProductLineChange(this.value);
                    }
                });

                //状态
                $('#QrytAdjustStatusWin').FrameTextBox({
                    value: model.QrytAdjustStatusWin,
                });
                $('#QrytAdjustStatusWin').FrameTextBox('disable');

                //Rsm
                $.each(model.LstRsm, function (index, val) {
                    if (model.hidSalesAccount && model.hidSalesAccount != null && val.UserCode != null) {
                        if (model.hidSalesAccount.toLowerCase() === val.UserCode.toLowerCase())
                            model.QryRsm = { Key: hidSalesAccount, Value: val.Name };
                    }
                })
                $('#QryRsm').FrameDropdownList({
                    dataSource: model.LstRsm,
                    dataKey: 'UserCode',
                    dataValue: 'Name',
                    selectType: 'none',
                    value: model.QryRsm,
                    //readonly:true
                });
                $('#QryRsm').FrameDropdownList('disable');
                //销售人员信息，来源待定
                //$('#QrySales').FrameDropdownList({
                //    dataSource: model.LstSalesRepStor,
                //    dataKey: 'Id',
                //    dataValue: 'Name',
                //    selectType: 'none',
                //    value: ''
                //});
                //退货类型
                if (model.QryApplyType != null && model.QryApplyType != "") {
                    $.each(model.LstReturnType, function (index, val) {
                        if (model.hiddApplyType === val.Key)
                            model.QryApplyType = { Key: val.Key, Value: val.Value };
                    })
                }
                $('#QryApplyType').FrameDropdownList({
                    dataSource: model.LstReturnType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryApplyType,
                    onChange: function (s) {
                        that.ReturnTypeChange(this.value);
                    }
                });

                //请选择原因
                $.each(model.LstReturnReason, function (index, val) {
                    if (model.hiddenReason === val.Key)
                        model.QryReturnReason = { Key: val.Key, Value: val.Value };
                })
                $('#QryReturnReason').FrameDropdownList({
                    dataSource: model.LstReturnReason,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryReturnReason,
                    onChange: function (s) {
                        that.ReturnReasonChange(this.value);
                    }
                });

                //退换货要求
                if (model.QryReturnTypeWin != null && model.QryReturnTypeWin != "") {
                    $.each(model.LstAdjustType, function (index, val) {
                        if (model.QryReturnTypeWin.Key === val.Key)
                            model.QryReturnTypeWin = { Key: val.Key, Value: val.Value };
                    })
                }
                $('#QryReturnTypeWin').FrameDropdownList({
                    dataSource: model.LstAdjustType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryReturnTypeWin,
                    onChange: function (s) {
                        that.ReturnRequirementsChange(this.value);
                    }
                });

                //备注
                $('#QryAdjustReasonWin').FrameTextArea({
                    value: model.QryAdjustReasonWin
                });
                //审批意见，有权限限制
                $('#QryAduitNoteWin').FrameTextArea({
                    value: model.QryAduitNoteWin,
                });
                //统计说明、
                $("#ProductInstructions").FrameTextBox({
                    value: model.lblInvSum,
                    readonly: true
                });

                //绑定经销商。产品明细 。操作日志等
                createRstProductDetail(model.RstProductDetail);
                createRstAttachmentDetail(model.LstAttachmentList);
                $('#RstOperationLog').DmsOperationLog({
                    dataSource: model.RstLogDetail
                });
                //初始化
                that.InitControlStatus(model.IsDealer, model, EntityModel);
                if (model.RsmHidden) {
                    $('#QryRsm').parent().parent().hide();
                }
                else {
                    $('#QryRsm').parent().parent().show();
                }

                //列（显示）控制；编辑控制、按钮控制***********************************************************************************
                //上传附件按钮控制判断当前状态是不是为草稿状态，如果为草稿状态，则可以更新
                if (model.IsDealer) {
                    $('#BtnAddAttachment').FrameButton({
                        text: '添加附件',
                        icon: 'upload',
                        onClick: function () {
                            that.initUploadAttachDiv();
                        }
                    });
                }
                else if (EntityModel.Status == "Draft") {
                    $('#BtnAddAttachment').FrameButton({
                        text: '添加附件',
                        icon: 'upload',
                        onClick: function () {
                            that.initUploadAttachDiv();
                        }
                    });
                }
                else {
                    //that.remove("BtnAddAttachment");
                    $('#BtnAddAttachment').remove();
                }

                $('#WinFileUpload').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=InventoryRenturn&InstanceId=" + $("#InstanceId").val(),
                        autoUpload: true
                    },
                    select: function (e) {
                    },
                    validation: {
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

    //初始化页面控件状态
    that.InitControlStatus = function (IsDealer, model, mainData) {
        //Added By Song Yuqi On 20140320 Begin
        $('#QryRsm').parent().parent().hide();
        $("#QryDealerWin").FrameDropdownList('disable');

        $("#RstProductDetail").data("kendoGrid").showColumn('PurchaseOrderNbr');//12
        $("#RstProductDetail").data("kendoGrid").hideColumn('ChineseName');//13
        $("#RstProductDetail").data("kendoGrid").hideColumn('UnitPrice');//15
        $("#RstProductDetail").data("kendoGrid").columns[5].editable = true;//禁用
        $("#RstProductDetail").data("kendoGrid").columns[7].editable = true;
        $("#RstProductDetail").data("kendoGrid").columns[11].editable = true;
        $("#RstProductDetail").data("kendoGrid").columns[12].editable = true;
        $("#RstProductDetail").data("kendoGrid").columns[13].editable = true;
        //  $("#RstProductDetail").data("kendoGrid").columns[14].editable = true;
        $("#RstProductDetail").data("kendoGrid").hideColumn('QRCodeEdit');//14

        $("#QryProductLineWin").FrameDropdownList('disable');
        $('#QryAdjustReasonWin').FrameTextArea('disable');//备注
        $('#QryAduitNoteWin').FrameTextArea('disable');
        $('#QryAduitNoteWin').parent().parent().hide();

        that.removeButton("BtnSave");
        that.removeButton("BtnDelete");
        that.removeButton("BtnSubmit");
        that.removeButton("BtnRevoke");
        that.removeButton("BtnAddProduct");

        $('#QryReturnReason').FrameDropdownList('disable');//请选择原因
        $('#QryReturnTypeWin').FrameDropdownList('disable');//请选择退换货要求
        $('#QryApplyType').FrameDropdownList('disable');//选择退货类型
        $("#RstProductDetail").data("kendoGrid").showColumn('UnitPrice  ');//15
        $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');//16
        //RetrunReasonStore.RemoveAll();

        if (model.hiddenReturnType == "Normal")
            $("#RstProductDetail").data("kendoGrid").hideColumn('PurchaseOrderNbr');//12


        //若id为空，说明为新增，则生成新的id，并新增一条记录
        if (model.UserIdentityType == "User") {
            $("#QryDealerWin").FrameDropdownList('enable');
            //如果是用户类型为User lijie add 2016-07-19
            $("#QryProductLineWin").FrameDropdownList('enable');
        }
        //GridPanel3,隐藏,涉及的功能未开发
        //$("#RstConsignmentDetail").data("kendoGrid").hideColumn('ChineseName');//16
        //$("#RstConsignmentDetail").data("kendoGrid").hideColumn('Delete');//12
        //$("#RstConsignmentDetail").data("kendoGrid").columns[9].editable = true;
        //$("#RstConsignmentDetail").data("kendoGrid").columns[10].editable = true;
        //$("#RstConsignmentDetail").data("kendoGrid").columns[11].editable = true;

        //二级经销商寄售退货单
        if ($("#hiddenDealerType").val() == "T2" && mainData.WarehouseType == "Consignment" && ($("#hiddenAdjustTypeId").val() == "Return" || $("#hiddenAdjustTypeId").val() == "Exchange")) {
            //this.TabPanel1.ActiveTabIndex = 0;
            //this.TabConsignment.Disabled = true;
            //this.TabHeader.Disabled = false;
        }
        else if (($("#hiddenDealerType").val() == "T1" || $("#hiddenDealerType").val() == "LP" || $("#hiddenDealerType").val() == "LS") && mainData.WarehouseType == "Borrow") {
            //this.TabPanel1.ActiveTabIndex = 0;
            //this.TabConsignment.Disabled = true;
            //this.TabHeader.Disabled = false;
            $("#RstProductDetail").data("kendoGrid").showColumn('ChineseName');//13
            // $("#RstProductDetail").data("kendoGrid").hideColumn('QRCodeEdit');//14
            if (mainData.Status == "Draft") {
                EditColumnArray.push(13);
            }
        }
        if (mainData.WarehouseType == "Normal") {
            //如果LP或T1的普通退货申请单，隐藏关联订单，显示价格
            $("#RstProductDetail").data("kendoGrid").showColumn('UnitPrice');//15
        }
        else if (mainData.WarehouseType == "Borrow" || mainData.WarehouseType == "Consignment") {
            //如果LP或T1的寄售转移申请单，显示关联订单，隐藏价格
            $("#RstProductDetail").data("kendoGrid").hideColumn('UnitPrice');//15
        }
        //Added By Song Yuqi On 20140319 End
        $('#QryRsm').FrameDropdownList('disable');
        //退货要求与原因联动
        if (model.ReturnReasonHidden) {
            $('#QryReturnReason').parent().parent().hide();
        }
        else {
            $('#QryReturnReason').parent().parent().show();
        }
        if (model.DdsHidden) {
            $("#RstProductDetail").data("kendoGrid").hideColumn('UnitPrice');
        }

        if (IsDealer || model.UserIdentityType == "User") {
            if (mainData.Status == "Draft") {
                $("#QryProductLineWin").FrameDropdownList('enable');
                $('#QryAdjustReasonWin').FrameTextArea('enable');//备注

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
                $('#QryApplyType').FrameDropdownList('enable');//选择退货类型

                $("#RstProductDetail").data("kendoGrid").showColumn('Delete');//16
                $("#RstProductDetail").data("kendoGrid").columns[11].editable = false;
                $("#RstProductDetail").data("kendoGrid").columns[12].editable = false;
                $("#RstProductDetail").data("kendoGrid").columns[13].editable = false;
                //$("#RstProductDetail").data("kendoGrid").columns[14].editable = false;
                //$("#RstProductDetail").data("kendoGrid").columns[15].editable = false;

                $('#BtnAddProduct').FrameButton({
                    text: '添加产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddProduct();
                    }
                });
                EditColumnArray.push(11);
                EditColumnArray.push(14);
                //Added By Song Yuqi On 20140320 Begin
                EditColumnArray.push(12);//订单号

                //GridPanel3,隐藏
                //$("#RstConsignmentDetail").data("kendoGrid").hideColumn('ChineseName');//16
                //$("#RstConsignmentDetail").data("kendoGrid").showColumn('Delete');//12
                //$("#RstConsignmentDetail").data("kendoGrid").columns[9].editable = true;
                //$("#RstConsignmentDetail").data("kendoGrid").columns[10].editable = true;
                //$("#RstConsignmentDetail").data("kendoGrid").columns[11].editable = true;
                //$('#QryRsm').FrameDropdownList('enable');
                $('#QryReturnReason').FrameDropdownList('enable');//请选择原因
                if ($("#hiddenDealerType").val() == "T1" || $("#hiddenDealerType").val() == "LP" || $("#hiddenDealerType").val() == "LS") {
                    //GridPanel3,隐藏
                    //this.GridPanel3.ColumnModel.SetHidden(11, false);
                }
                //Added By Song Yuqi On 20140320 End
                $('#QryReturnTypeWin').FrameDropdownList('enable');//请选择退换货要求
            }
            else {
                //Added By Song Yuqi On 20140320 Begin
                EditColumnArrayIsExists(11);
                EditColumnArrayIsExists(12);        //订单号       
                $("#RstProductDetail").data("kendoGrid").showColumn('PurchaseOrderNbr');//12
                EditColumnArrayIsExists(13);    //订单号
                //GridPanel3,隐藏
                //this.GridPanel3.ColumnModel.SetRenderer(9, r);
                //this.GridPanel3.ColumnModel.SetRenderer(10, r);
                if (mainData.WarehouseType == "Normal") {
                    //如果LP或T1的普通退货申请单，隐藏关联订单，显示价格
                    $("#RstProductDetail").data("kendoGrid").hideColumn('PurchaseOrderNbr');//12
                }
                else if (mainData.WarehouseType == "Borrow" || mainData.WarehouseType == "Consignment") {
                    //如果LP或T1的寄售转移申请单，显示关联订单，隐藏价格
                }
                if (($("#hiddenDealerType").val() == "T1" || $("#hiddenDealerType").val() == "LP" || $("#hiddenDealerType").val() == "LS") && $("#hiddenReturnType").val() == "Borrow") {
                    $("#RstProductDetail").data("kendoGrid").showColumn('ChineseName');//13
                    $("#RstProductDetail").data("kendoGrid").columns[13].editable = true;
                    //this.GridPanel3.ColumnModel.SetRenderer(11, r);
                    //this.GridPanel3.ColumnModel.SetHidden(11, false);
                }
                //Added By Song Yuqi On 20140320 End
                var ReturnTyp = { Key: '', Value: '' };
                $.each(LstAdjustTypeArr, function (index, val) {
                    if (mainData.Reason === val.Key)
                        ReturnTyp = { Key: mainData.Reason, Value: val.Value };
                })
                $('#QryReturnTypeWin').FrameDropdownList('setValue', ReturnTyp);
            }
            if (mainData.Reason == "StockIn" || mainData.Reason == "StockOut") {
                if (mainData.Status == "Submit") {
                    $('#BtnRevoke').FrameButton({
                        text: '撤销',
                        icon: 'reply',
                        onClick: function () {
                            that.DoRevoke();
                        }
                    });
                }
            }
            else {
                //如果是退货，已提交时不能撤销，如果e-workflow已确认，则也不能修改
                if (mainData.Status == "Submitted" && model.LPGoodsReturnApprove) {
                    $('#BtnRevoke').FrameButton({
                        text: '撤销',
                        icon: 'reply',
                        onClick: function () {
                            that.DoRevoke();
                        }
                    });
                }

                //如果是二级经销商，且状态是已提交，则也不能修改
                if (model.UserIdentityType != "User") {
                    if (model.UserCorpType == "T2" && mainData.Status == "Submitted") {
                        that.removeButton("BtnRevoke");
                    }
                    //如果是平台，且单据经销商不是平台，则也不能修改
                    if ((model.UserCorpType == "LP" || model.UserCorpType == "LS") && mainData.Status == "Submitted" && !mainData.DmaId == model.CorpId) {
                        that.removeButton("BtnRevoke");
                    }
                }
                //如果是平台或者T1不可撤销 ljie add 2016-06-28
                if ($("#hiddenDealerType").val() == "T1" || $("#hiddenDealerType").val() == "LP" || $("#hiddenDealerType").val() == "LS") {
                    that.removeButton("BtnRevoke");
                }

                if (mainData.WarehouseType == "Normal" && mainData.ProductLineBumId == "8f15d92a-47e4-462f-a603-f61983d61b7b" && mainData.Reason == "Return" && mainData.Status != "Draft") {
                    //如果为普通退货单，产品线为Endo,经销商类型为T1或T2，为红海所属的不能修改
                    that.removeButton("BtnRevoke");
                }
            }
            if (model.IsShowPushERP) {
                $('#BtnPushERP').FrameButton({
                    text: '推送ERP',
                    icon: 'send',
                    onClick: function () {
                        that.PushToERP();
                    }
                });
            }
        }
        if (mainData.Status == "Reject" || mainData.Status == "Accept") {
            $('#QryAduitNoteWin').parent().parent().show();
        }
        //测试使用***++++
        //$("#RstProductDetail").data("kendoGrid").showColumn('ChineseName');//13
        //$("#RstProductDetail").data("kendoGrid").showColumn('PurchaseOrderNbr');//12
    };

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
                    field: "CFNChineseName", title: "产品中文名", width: '80px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN", title: "产品型号", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UPN", title: "UPN", width: '100px', editable: true, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "UPN" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotNumber", title: "序列号/批号", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QRCode", title: "二维码", width: '120px', editable: true,
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
                    field: "TotalQty", title: "库存量", width: '60px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "库存量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CreatedDate", title: "入库时间", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "入库时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AdjustQty", title: "数量", width: '60px', editable: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrderNbr", title: "关联订单", width: '120px', editable: false, editor: ChangePurchaseEditor,
                    template: function (gridRow) {
                        var OrderNbr = "";
                        if (PurchaseResult.length > 0) {
                            if (gridRow.PurchaseOrderNbr != null && gridRow.PurchaseOrderNbr != "") {
                                $.each(PurchaseResult, function () {
                                    if (this.PurchaseOrderNbr == gridRow.PurchaseOrderNbr) {
                                        OrderNbr = this.PurchaseOrderNbr;
                                        return false;
                                    }
                                })
                            }
                            else {
                                gridRow.PurchaseOrderNbr = "";
                            }
                        }
                        else {
                            if (gridRow.PurchaseOrderNbr != null && gridRow.PurchaseOrderNbr != "")
                                OrderNbr = gridRow.PurchaseOrderNbr;
                            else
                                OrderNbr = "";
                        }
                        return OrderNbr;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "关联订单" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "转移经销商", width: '100px', editable: false, editor: ChangeDealerEditor,
                    template: function (gridRow) {
                        var CName = "";
                        if (LstToDealer.length > 0) {
                            if (gridRow.ChineseName != null && gridRow.ChineseName != "") {
                                $.each(LstToDealer, function () {
                                    if (this.Id == gridRow.ChineseName) {
                                        CName = this.Name;
                                        return false;
                                    }
                                })
                            }
                            else {
                                gridRow.ChineseName = "";
                            }
                        }
                        else {
                            if (gridRow.ChineseName != null && gridRow.ChineseName != "")
                                CName = gridRow.ChineseName;
                            else
                                CName = "";
                        }
                        return CName;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "转移经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QRCodeEdit", title: "二维码", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UnitPrice", title: "退货价格信息", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "退货价格信息" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Delete", title: "删除", width: '50px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;" },
                    template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                    attributes: { "class": "text-center text-bold" },
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
        //var grid = $("#RstProductDetail").data("kendoGrid");
        //grid.bind("save", grid_save);
        //function grid_save(e) {
        //    if (!that.EditUpdate(e)) {
        //        //grid.refresh();
        //        //grid.dataSource.at(0).set("TransferQty", 2);
        //    }
        //    else {
        //        that.UpdateItem(e);
        //    }
        //}
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
                    headerAttributes: { "class": "text-center text-bold", "title": "附件名称" }
                },
                {
                    field: "Identity_Name", title: "上传人", width: '150px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "上传人" }
                },
                {
                    field: "UploadDate", title: "上传时间", width: '150px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "上传时间" }
                },
                {
                    field: "Url", title: "Url", width: '150px', editable: true, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "Url" }
                },
                {
                    title: "下载", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "下载", "style": "vertical-align: middle;" },
                    template: "<i class='fa fa-download' style='font-size: 14px; cursor: pointer;'></i>",
                    attributes: { "class": "text-center text-bold" },
                },
                {
                    field: "Delete", title: "删除", width: '100px', editable: true,
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
                    that.AttachmentDelete(data, data.Id, data.IsCurrent, data.Url);
                });
                $("#RstAttachmentDetail").find(".fa-download").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    var url = '../Download.aspx?downloadname=' + escape(data.Name) + '&filename=' + escape(data.Url) + '&downtype=AdjustAttachment';
                    downloadfile(url);
                    //$("#RstDetailList").data("kendoGrid").dataSource.remove(data);
                });

            }
        });
    }

    //关联订单单元格下拉**********begin************
    function ChangePurchaseEditor(container, options) {
        PurchaseNbrId = "";
        var data = FrameUtil.GetModel();
        data.PmaId = options.model.PmaId;
        data.LotNumber = options.model.LotNumber;
        data.QRCode = options.model.QRCode;
        FrameUtil.SubmitAjax({
            business: business,
            async: false,
            method: 'PurchaseOrderStore_RefershData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                PurchaseResult = model.LstPurchase;
                FrameWindow.HideLoading();
            }
        });
        $('<input data-bind="value:' + options.field + '"/>')
        .appendTo(container)
        .kendoDropDownList({
            autoBind: true,
            dataTextField: "PurchaseOrderNbr",
            dataValueField: "Id",
            index: 0,
            dataSource: PurchaseResult,
            select: function (s) {
                PurchaseNbrId = s.dataItem.Id;
            }
        })

    };

    //转移经销商下拉;新增寄售转移订单中，目前已隐藏该功能
    function ChangeDealerEditor(container, options) {
        SelectTodealerId = "";
        var data = FrameUtil.GetModel();
        data.PmaId = options.model.PmaId;
        data.LotNumber = options.model.LotNumber;
        data.QRCode = options.model.QRCode;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ToDealerStore_RefershData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstToDealer = model.LstToDealer;
                FrameWindow.HideLoading();
            }
        });

        $('<input data-bind="value:' + options.field + '"/>')
    .appendTo(container)
.kendoDropDownList({
    autoBind: true,
    dataTextField: "ChineseShortName",
    dataValueField: "Id",
    index: -1,
    dataSource: LstToDealer,
    select: function (s) {
        SelectTodealerId = s.dataItem.Id;
    }
})
    };
    //单元格下拉**********end************

    //校验用户输入数量 GridPanel3,隐藏，寄售
    that.EditUpdate13 = function (data) {
        var TotalQty = data.model.TotalQty;
        var ConvertFactor = data.model.ConvertFactor;
        if (data.values.AdjustQty) {
            if (accMin(TotalQty, data.values.AdjustQty) < 0) {
                //数量错误时，编辑行置为空
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: "调整数量不能大于库存量！",
                });
                return false;
            }
            if ($("#hiddenDealerType").val() == 'T2') {
                if (accMul(data.values.AdjustQty, 1000000) % accDiv(1, ConvertFactor).mul(1000000) != 0) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: "最小单位是：" + accDiv(1, ConvertFactor),
                    });
                    return false;
                }
            } else {
                //非T2的经销商申请的数量不能为小数,因此这里设置转换率均为1
                if (accMul(data.values.AdjustQty, 1000000) % accDiv(1, 1).mul(1000000) != 0) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: "最小单位是:1"
                    });
                    return false;
                }
            }
            return true;
        }
        else
            return true;

    };
    //校验用户输入数量
    that.EditUpdate = function (data) {
        var TotalQty = data.model.TotalQty;
        var ConvertFactor = data.model.ConvertFactor;
        if (data.values.AdjustQty) {
            if (accMin(TotalQty, data.values.AdjustQty) < 0) {
                //数量错误时，编辑行置为空
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: "调整数量不能大于库存量！",
                });
                data.values.AdjustQty = data.model.TotalQty;
                data.model.AdjustQty = data.model.TotalQty;
                $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                //  $("#RstProductDetail").data("kendoGrid").refresh();
                return false;
            }
            if (data.values.AdjustQty > 1) {
                //数量错误时，编辑行置为空
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: "退货数量不能大于1",
                });
                data.model.AdjustQty = 1;
                $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                $("#RstProductDetail").data("kendoGrid").refresh();
                return false;
            }
            if ($("#hiddenDealerType").val() == 'T2') {
                if (accMul(data.values.AdjustQty, 1000000) % accDiv(1, ConvertFactor).mul(1000000) != 0) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: "最小单位是：" + accDiv(1, ConvertFactor),
                    });
                    data.model.AdjustQty = 1;
                    $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                    return false;
                }
            } else {
                //非T2的经销商申请的数量不能为小数,因此这里设置转换率均为1
                if (accMul(data.values.AdjustQty, 1000000) % accDiv(1, 1).mul(1000000) != 0) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: "最小单位是:1"
                    });
                    //data.model.AdjustQty = data.model.TotalQty;
                    data.model.AdjustQty = 1;
                    $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                    return false;
                }
            }
            return true;
        }
        else
            return true;

    };
    that.CheckQty = function (e) {
        var qty = /^[1-9]\d*$/;
        var grid = e.sender;
        var tr = $(e.container).closest("tr");
        var data = grid.dataItem(tr);
        var AdjustQty = e.container.find("input[name=AdjustQty]");

        AdjustQty.change(function (b) {
            if (accMin(data.TotalQty, $(this).val()) < 0) {
                //数量错误时，编辑行置为空
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: "调整数量不能大于库存量！",
                });
                data.AdjustQty = data.TotalQty;
                $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                return false;
            }
            if (data.QRCode != "" && data.QRCode != null) {
                if (data.QRCode.toLowerCase() != "noqr") {
                    if ($(this).val() > 1) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: "退货数量不能大于1",
                        });
                        data.AdjustQty = data.TotalQty;
                        $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                        return false;
                    }
                }
                //noqr:为空时退货数量只需满足小于等于库存量即可
            }
            if ($("#hiddenDealerType").val() == 'T2') {
                if (accMul($(this).val(), 1000000) % accDiv(1, data.ConvertFactor).mul(1000000) != 0) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: "最小单位是：" + accDiv(1, data.ConvertFactor),
                    });
                    data.AdjustQty = data.TotalQty;
                    $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                    return false;
                }
            } else {
                //非T2的经销商申请的数量不能为小数,因此这里设置转换率均为1
                if (accMul($(this).val(), 1000000) % accDiv(1, 1).mul(1000000) != 0) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: "最小单位是:1"
                    });
                    data.AdjustQty = data.TotalQty;
                    $("#RstProductDetail").data("kendoGrid").dataSource.fetch();
                    return false;
                }
            }
        });

    }
    //修改产品明细单元格由于提示较复杂，故采用单个单元格直接保存的方式
    //编辑行数据实时保存
    that.UpdateItem = function (e) {
        //if (that.EditUpdate(e)) {
        var data = {};
        var param = FrameUtil.GetModel();
        data.hiddenReturnType = param.hiddenReturnType;
        data.InstanceId = param.InstanceId;
        data.LotId = e.model.Id;
        if (e.values.PurchaseOrderNbr) {
            //data.PurchaseOrderId = e.values.PurchaseOrderNbr.Id;
            data.PurchaseOrderId = PurchaseNbrId;
        }
        else {
            data.PurchaseOrderId = e.model.PurchaseOrderNbr;
        }
        if (e.values.LotNumber) {
            data.LotNumber = e.values.LotNumber;
        }
        else {
            data.LotNumber = e.model.LotNumber
        }
        if (e.values.ExpiredDate) {
            data.ExpiredDate = e.values.ExpiredDate;
        }
        else {
            data.ExpiredDate = e.model.ExpiredDate;
        }
        if (e.values.AdjustQty) {
            data.AdjustQty = e.values.AdjustQty;
        }
        else {
            data.AdjustQty = e.model.AdjustQty;
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
        if (e.values.ChineseName) {
            //data.ToDealer = e.values.ToDealer.Id;
            data.ToDealer = SelectTodealerId;
        }
        else {
            data.ToDealer = e.model.ChineseName;
        }
        if (e.values.UPN) {
            data.UPN = e.values.UPN;
        }
        else {
            data.UPN = e.model.UPN;
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
        //}
    };

    //刷新产品明细数据
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
                $("#ProductInstructions").FrameTextBox('setValue', model.lblInvSum);
                FrameWindow.HideLoading();
            }
        });
    }

    //刷新RSM数据
    that.RefreshRsm = function () {
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'RefreshRsm',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#hiddenIsRsm").val(data.hiddenIsRsm);
                $.each(model.LstRsm, function (index, val) {
                    if (model.hidSalesAccount === val.UserCode)
                        model.QryRsm = { Key: hidSalesAccount, Value: val.Name };
                })
                $('#QryRsm').FrameDropdownList({
                    dataSource: model.LstRsm,
                    dataKey: 'UserCode',
                    dataValue: 'Name',
                    selectType: 'none',
                    value: model.QryRsm,
                });
                if (model.RsmHidden) {
                    $('#QryRsm').parent().parent().hide();
                }
                else {
                    $('#QryRsm').parent().parent().show();
                }

                FrameWindow.HideLoading();
            }
        });
    }

    //修改经销商
    that.DealerWinChanange = function (DealerId) {
        var DealerType = "";
        $.each(LstDealerArr, function (index, val) {
            if (DealerId === val.Id)
                DealerType = val.DealerType;
        })
        if ($("#hiddenDealerId").val() != DealerId) {
            FrameWindow.ShowConfirm({
                target: 'top',
                message: '变更经销商会删除原有产品,确定变更？',
                confirmCallback: function () {
                    $("#hiddenDealerType").val(DealerType);
                    var data = FrameUtil.GetModel();
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'CbDealerWinChanaeg',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            //$("#RstProductDetail").data("kendoGrid").setOptions({
                            //    dataSource: []
                            //});
                            LstBuArr = model.LstBu;
                            that.RefershHeadData();
                            CheckAddItemsParam();
                            $("#hiddenDealerId").val(model.hiddenDealerId);
                            $("#hiddenProductLineId").val(model.hiddenProductLineId);
                            $("#hiddApplyType").val(model.hiddApplyType);
                            $("#hiddenWhmType").val(model.hiddenWhmType);

                            var Bu = { Key: '', Value: '' };
                            $.each(model.LstBu, function (index, val) {
                                if (model.hiddenProductLineId === val.Key)
                                    Bu = { Key: val.Key, Value: val.Value };
                            })
                            $('#QryProductLineWin').FrameDropdownList({
                                dataSource: model.LstBu,
                                dataKey: 'Key',
                                dataValue: 'Value',
                                selectType: 'none',
                                value: Bu,
                                onChange: function (s) {
                                    that.ProductLineChange(this.value);
                                }
                            });
                            //退回类型
                            if (model.QryApplyType != null && model.QryApplyType != "") {
                                $.each(model.LstReturnType, function (index, val) {
                                    if (model.QryApplyType.Key === val.Key)
                                        model.QryApplyType = {
                                            Key: val.Key, Value: val.Value
                                        };
                                })
                            }
                            $('#QryApplyType').FrameDropdownList({
                                dataSource: model.LstReturnType,
                                dataKey: 'Key',
                                dataValue: 'Value',
                                selectType: 'none',
                                value: model.QryApplyType,
                                onChange: function (s) {
                                    that.ReturnTypeChange(this.value);
                                }
                            });
                            //退换货要求
                            if (model.QryReturnTypeWin != null && model.QryReturnTypeWin != "") {
                                $.each(model.LstAdjustType, function (index, val) {
                                    if (model.QryReturnTypeWin.Key === val.Key)
                                        model.QryReturnTypeWin = {
                                            Key: val.Key, Value: val.Value
                                        };
                                })
                            }
                            $('#QryReturnTypeWin').FrameDropdownList({
                                dataSource: model.LstAdjustType,
                                dataKey: 'Key',
                                dataValue: 'Value',
                                selectType: 'none',
                                value: model.QryReturnTypeWin,
                                onChange: function (s) {
                                    that.ReturnRequirementsChange(this.value);
                                }
                            });
                            //请选择原因
                            $.each(model.LstReturnReason, function (index, val) {
                                if (model.hiddenReason === val.Key)
                                    model.QryReturnReason = {
                                        Key: val.Key, Value: val.Value
                                    };
                            })
                            $('#QryReturnReason').FrameDropdownList({
                                dataSource: model.LstReturnReason,
                                dataKey: 'Key',
                                dataValue: 'Value',
                                selectType: 'none',
                                value: model.QryReturnReason,
                                onChange: function (s) {
                                    that.ReturnReasonChange(this.value);
                                }
                            });
                            //选择原因
                            if (model.ReturnReasonHidden) {
                                $('#QryReturnReason').parent().parent().hide();
                            }
                            else {
                                $('#QryReturnReason').parent().parent().show();
                            }

                            FrameWindow.HideLoading();
                        }
                    });
                },
                cancelCallback: function () {
                    var originalDealer = { Key: '', Value: '' };
                    $.each(LstDealerArr, function (index, val) {
                        if ($("#hiddenDealerId").val() === val.Id)
                            originalDealer = {
                                Key: $("#hiddenDealerId").val(), Value: val.ChineseShortName
                            };
                    })
                    $('#QryDealerWin').FrameDropdownList('setValue', originalDealer);
                }
            });
        }
    }

    //修改产品线
    that.ProductLineChange = function (Bu) {

        if ($("#hiddenProductLineId").val() != Bu) {
            if ($("#hiddenProductLineId").val() == '') {
                $("#hiddenProductLineId").val(Bu);
                that.RefershHeadData();
                CheckAddItemsParam();
                that.RefreshRsm();
            }
            else {
                FrameWindow.ShowConfirm({
                    target: 'top',
                    message: '改变产品线将删除已添加的产品',
                    confirmCallback: function () {
                        var data = FrameUtil.GetModel();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'OnProductLineChange',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                $("#hiddenProductLineId").val(Bu);
                                that.RefershHeadData();
                                CheckAddItemsParam();
                                //that.RefreshRsm();
                                FrameWindow.HideLoading();
                            }
                        });
                    },
                    cancelCallback: function () {
                        var originalBu = { Key: '', Value: '' };
                        $.each(LstBuArr, function (index, val) {
                            if ($("#hiddenProductLineId").val() === val.Key)
                                originalBu = {
                                    Key: $("#hiddenProductLineId").val(), Value: val.Value
                                };
                        })
                        $('#QryProductLineWin').FrameDropdownList('setValue', originalBu);
                    }
                });
            }
        }
    }
    //修改退货类型
    that.ReturnTypeChange = function (ReturnType) {
        if ($("#hiddApplyType").val() != ReturnType) {
            $("#hiddApplyType").val(ReturnType);
            var data = FrameUtil.GetModel();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'OnCbApplyChange',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    CheckAddItemsParam();
                    if (model.hiddenDealerType == "T1" || model.hiddenDealerType == "LP" || model.hiddenDealerType == "LS") {
                        if (model.DdsHidden) {
                            $("#RstProductDetail").data("kendoGrid").hideColumn('UnitPrice');
                        }
                        else {
                            $("#RstProductDetail").data("kendoGrid").showColumn('UnitPrice');
                        }

                        $("#hiddenWhmType").val(model.hiddenWhmType);
                        $("#hiddenReason").val("");
                        $('#QryReturnReason').FrameDropdownList({
                            dataSource: model.LstReturnReason,
                            dataKey: 'Key',
                            dataValue: 'Value',
                            selectType: 'none',
                            onChange: function (s) {
                                that.ReturnReasonChange(this.value);
                            }
                        });
                        $('#QryReturnTypeWin').FrameDropdownList({
                            dataSource: model.LstAdjustType,
                            dataKey: 'Key',
                            dataValue: 'Value',
                            selectType: 'none',
                            value: model.QryReturnTypeWin,
                            onChange: function (s) {
                                that.ReturnRequirementsChange(this.value);
                            }
                        });
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }
    //修改选择原因
    that.ReturnReasonChange = function (ReturnReason) {
        if ($("#hiddenReason").val() != ReturnReason) {
            $("#hiddenReason").val(ReturnReason);
            var data = FrameUtil.GetModel();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'OnChangcbReturnReason',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if ((model.hiddenDealerType == "T1" || model.hiddenDealerType == "LP" || model.hiddenDealerType == "LS") && model.hiddenReturnType == "Normal") {
                        if (model.ReturnReasonHidden) {
                            $('#QryReturnReason').parent().parent().hide();
                        }
                        else {
                            $('#QryReturnReason').parent().parent().show();
                        }
                        if (model.DdsHidden) {
                            $("#RstProductDetail").data("kendoGrid").hideColumn('UnitPrice');
                        }
                        $('#QryReturnTypeWin').FrameDropdownList({
                            dataSource: model.LstAdjustType,
                            dataKey: 'Key',
                            dataValue: 'Value',
                            selectType: 'none',
                        });
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }
    //退换货要求判断
    that.ReturnRequirementsChange = function (RequirementsValue) {
        if (RequirementsValue == 'Exchange') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: "仅限换同UPN产品",
            });
            return;
        }
    };

    //是否显示添加产品
    //此函数用来控制“添加产品”按钮的状态
    var CheckAddItemsParam = function () {
        var model = FrameUtil.GetModel();
        if (valiteIsNull(model.QryProductLineWin.Key) || valiteIsNull(model.QryProductLineWin.Key)) {
            that.removeButton("BtnAddProduct");
        } else {
            $('#BtnAddProduct').FrameButton({
                text: '添加产品',
                icon: 'search',
                onClick: function () {
                    that.AddProduct();
                }
            });
        }
    }


    //添加产品
    that.AddProduct = function () {
        var data = FrameUtil.GetModel();
        var InstanceId = data.InstanceId;
        var hiddenDealerId = $("#hiddenDealerId").val();
        var hiddenProductLineId = $("#hiddenProductLineId").val();
        var ReturnTypeWin = data.QryReturnTypeWin.Key;
        var hiddenReturnType = $("#hiddenReturnType").val();
        var hiddApplyType = $("#hiddApplyType").val();
        if (data.QryProductLineWin.Key == "" || null == data.QryProductLineWin.Key) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: "请选择产品线后再添加产品！",
            });
        }
        else if (data.QryReturnTypeWin.Key == "" || null == data.QryReturnTypeWin.Key) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: "请选择退换货要求",
            });
        }
        else if (data.QryApplyType.Key == "" || null == data.QryApplyType.Key) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: "请选择退换货类型",
            });
        }
        else {
            url = Common.AppVirtualPath + 'Revolution/Pages/Inventory/InventoryReturnInfoPicker.aspx?InstanceId=' + InstanceId + '&&hiddenDealerId=' + hiddenDealerId + '&&hiddenProductLineId=' + hiddenProductLineId + '&&ReturnTypeWin=' + ReturnTypeWin + '&&hiddenReturnType=' + hiddenReturnType + '&&hiddApplyType=' + hiddApplyType,

            FrameWindow.OpenWindow({
                target: 'top',
                title: '添加产品',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (d) {
                    if (d) {
                        var pickearr = "";
                        var r = d[0];
                        var list = r.res;
                        var data = FrameUtil.GetModel();
                        data.InstanceId = $('#InstanceId').val();
                        data.QryBu = $('#ProductLineId').val();

                        data.hiddenDialogAdjustId = InstanceId;
                        data.hiddenDialogDealerId = hiddenDealerId;
                        data.hiddenDialogAdjustType = ReturnTypeWin;
                        data.hiddenWarehouseType = hiddenReturnType;
                        data.hiddenReturnApplyType = hiddApplyType;
                        data.cbWarehouse1 = r.Warehouse;
                        data.cbWarehouse2 = r.Warehouse2;

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
    }

    //产品明细单行删除 操作
    that.Delete = function (LotId) {
        var data = {};
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
                var data = {};
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
    //撤销订单
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
        else if ($.trim(data.QryReturnTypeWin.Key) == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择退换货类型/原因/要求',
            });
        }
        else if ($('#QryAdjustReasonWin').FrameTextArea('getValue').length > 2000) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '退换货原因的内容不能超过2000字!',
                callback: function () {
                }
            });
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
        data.hiddenAdjustType = data.hiddenAdjustTypeId;
        var message = that.CheckForm(data);

        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            var productCount = $("#RstProductDetail").data("kendoGrid")._data.length;
            if ($.trim(data.QryProductLineWin.Key) != '' && $.trim(data.QryAdjustReasonWin) != '' && $.trim(data.hiddApplyType) != '' && $.trim(data.QryReturnTypeWin.Key) != ''
         && (($.trim(data.hiddenDealerType) != 'T2' && productCount > 0)
         || ($.trim(data.hiddenDealerType) == 'T2' && ($.trim(data.hiddenAdjustType) != 'Return' || $.trim(data.hiddenAdjustType) != 'Exchange') && productCount > 0)
     || ($.trim(data.hiddenDealerType) == 'T2' && ($.trim(data.hiddenAdjustType) == 'Return' || $.trim(data.hiddenAdjustType) == 'Exchange') && $.trim(data.hiddenReturnType) == 'Consignment' && productCount > 0)
     || ($.trim(data.hiddenDealerType) == 'T2' && ($.trim(data.hiddenAdjustType) == 'Return' || $.trim(data.hiddenAdjustType) == 'Exchange') && $.trim(data.hiddenReturnType) != 'Consignment' && productCount > 0)
     || ($.trim(data.hiddenAdjustType) == 'Transfer' && ($.trim(data.hiddenDealerType) == 'T1' || $.trim(data.hiddenDealerType) == 'LP')))) {
                message = that.CheckLotQty(data);
                if (message.length == 0) {
                    if ((data.hiddenDealerType == 'T1' || data.hiddenDealerType == 'LP') && data.hiddenReturnType == 'Normal' && $.trim(data.QryReturnReason.Key) == '') {
                        message.push('请选择退货原因');
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: "请选择退货原因！",
                        });
                        return;
                    }
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
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: message,
                    });
                }
            }
            else {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: "请填写完整后再提交！",
                });
            }
        }
    }
    //推送ERP
    that.PushToERP = function () {
        var data = that.GetModel();
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
    that.CheckForm = function (data) {
        var message = [];
        var reg = '^[0-9]*$';
        if ($.trim(data.QryProductLineWin.Key) == "") {
            message.push('请选择产品线');
        }
        else if ($.trim(data.QryAdjustReasonWin) == "") {
            message.push('请填写备注');
        }
        if ($.trim(data.hiddenIsRsm) == "true" && $.trim(data.QryRsm.Key) == "") {
            message.push('请选择销售');
        }
        if ($.trim(data.QryReturnTypeWin.Key) == "") {
            message.push('请选择退换货类型/原因/要求');
        }
        if ($.trim(data.QryAdjustReasonWin).length > 2000) {
            message.push("退换货原因的内容不能超过2000字!");
        }
        return message;
    }
    that.CheckLotQty = function (data) {
        var message = [];
        data.hiddenAdjustType = data.hiddenAdjustTypeId;
        //表单数量验证
        var msg1 = ""; var msg2 = ""; var msg3 = ""; var msg4 = ""; var msg5 = ""; var msg6 = ""; var msg7 = "";
        for (var i = 0; i < data.RstDetailList.length; i++) {
            var record = data.RstDetailList[i];
            if (record.AdjustQty <= 0) {
                msg1 = '退换货数量不能为0！';
            }
            if (record.LotNumber == "" || record.LotNumber == null) {
                msg2 = '批号/序列号不能为空！';
            }
            if ($.trim(data.hiddenAdjustType) == 'Transfer' && (record.ChineseName == "" || record.ChineseName == null) && ($.trim(data.hiddenDealerType) == 'T1' || $.trim(data.hiddenDealerType) == 'LP')) {
                msg3 = '转移经销商不能为空！';
            }
            if ($.trim(data.hiddenAdjustType) == 'Transfer' && (record.PurchaseOrderNbr == "" || record.PurchaseOrderNbr == null) && ($.trim(data.hiddenDealerType) == 'T1' || $.trim(data.hiddenDealerType) == 'LP')) {
                msg4 = "关联订单号不能为空！";
            }
            //if ((record.QRCodeEdit == "" || record.QRCodeEdit == null) && record.QRCode == "NoQR" && ($.trim(data.hiddenAdjustType) == 'Return' || $.trim(data.hiddenAdjustType) == 'Exchange')) {
            //    msg5 = 'NoQR产品不能退货，请填写二维码';
            //}
            //if (that.Calculations(data.RstDetailList, record.QRCodeEdit, "QRCodeEdit") > 1 && record.QRCodeEdit != "" && $.trim(data.hiddenAdjustType) != 'Transfer') {
            //    msg6 = '二维码' + record.QRCodeEdit + "出现多次";
            //}
            //if (that.Calculations(data.RstDetailList, record.QRCodeEdit, "QRCode") > 0 && record.QRCode != "NoQR" && record.QRCodeEdit != "" && $.trim(data.hiddenAdjustType) != 'Transfer') {
            //    msg7 = '二维码' + record.data.QRCode + "已使用";
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
        if (msg7 != "")
            message.push(msg7);
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

    //****************附件**********
    that.initUploadAttachDiv = function (CName, EName, DealerType) {
        $("#winUploadAttachLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
            actions: ["Close"],
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
    that.AttachmentDelete = function (dataItem, Id, IsCurrent, AttachmentName) {
        if ("1" != IsCurrent) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '非当天上传文件，不允许删除',
            });
        }
        else {
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
        }
    };
    function downloadfile(url) {
        var iframe = document.createElement("iframe");
        iframe.src = url;
        iframe.style.display = "none";
        document.body.appendChild(iframe);
    }
    //****************附件**********

    function valiteIsNull(obj) {
        if (obj == "" || obj == null || obj == undefined) {
            return true;
        }
        else
            return false
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

    that.removeButton = function (obj) {
        $('#' + obj + '').empty();
        $('#' + obj + '').removeClass();
        $('#' + obj + '').unbind();
    };

    var setLayout = function () {
    }

    return that;
}();


