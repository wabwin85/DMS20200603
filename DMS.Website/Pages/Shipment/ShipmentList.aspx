<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShipmentList.aspx.cs" Inherits="DMS.Website.Pages.Shipment.ShipmentList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/ShipmentDialog.ascx" TagName="ShipmentDialog" TagPrefix="uc1" %>
<%@ Register Src="../../Controls/ShipmentCfnDialog.ascx" TagName="ShipmentCfnDialog" TagPrefix="uc1" %>
<%@ Register Src="../../Controls/AuthorizationDialog.ascx" TagName="AuthorizationDialog" TagPrefix="uc1" %>
<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="HeadShipmentList" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"></script>

    <link href="../../resources/swfupload/css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../resources/swfupload/swfupload.js"></script>
    <script type="text/javascript" src="../../resources/swfupload/swfupload.queue.js"></script>
    <script type="text/javascript" src="../../resources/swfupload/fileprogress.js"></script>
    <script type="text/javascript" src="../../resources/swfupload/filegroupprogress.js"></script>
    <script type="text/javascript" src="../../resources/swfupload/handlers.js"></script>

    <style type="text/css">
        .list-item {
            font: normal 9px tahoma, arial, helvetica, sans-serif;
            padding: 1px 1px 1px 1px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #bbbbbb;
        }

            .list-item h3 {
                display: block;
                font: inherit;
                font-weight: normal;
                font-size: 12px;
                color: #222;
            }

            .list-item h2 {
                display: block;
                font: inherit;
                font-weight: normal;
                font-size: 12px;
                color: #bbbbbb;
            }

        .red-row {
            background: #FF0000 !important;
        }

        .orange-row {
            background: #FF8D09 !important;
        }

        .yellow-row {
            background: #FFD700 !important;
        }

        .green-row {
            background: #32CD32 !important;
        }

        .editable-column {
            background: #FFFF99;
        }

        .nonEditable-column {
            background: #FFFFFF;
        }

        .txtRed {
            color: Red;
            font-size: 13px !important;
        }

        .textFieldReadonly {
            background-color: #DFE9F6;
            border-color: #DFE9F6;
            background-image: none;
        }

        .x-form-text {
            color: black;
        }





        .txtGree {
            color: green;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />

        <script language="javascript" type="text/javascript">
            var MsgList = {
                btnInsert: {
                    FailureTitle: "<%=GetLocalResourceObject("Panel1.btnInsert.MessageBox.alert.Title").ToString()%>",
                    FailureMsg: "<%=GetLocalResourceObject("Panel1.btnInsert.MessageBox.alert").ToString()%>"
                },
                ShowDetails: {
                    FailureTitle: "<%=GetLocalResourceObject("GridPanel1.AjaxEvents.MessageBox.alert.Title").ToString()%>",
                    FailureMsg: "<%=GetLocalResourceObject("GridPanel1.AjaxEvents.MessageBox.alert.Body").ToString()%>"
                },
                DetailStore: {
                    LoadExceptionTitle: "<%=GetLocalResourceObject("DetailStore.Alert.Title").ToString()%>"
                },
                ShowDialog: {
                    FailureTitle: "<%=GetLocalResourceObject("GridPanel2.AddItemsButton.MessageBox.alert.Title").ToString()%>",
                    FailureMsg: "<%=GetLocalResourceObject("GridPanel2.AddItemsButton.MessageBox.alert.Body").ToString()%>"
                },
                DeleteItem: {
                    ConfirmTitle: "<%=GetLocalResourceObject("GridPanel2.Listeners.Confirm.Title").ToString()%>",
                    ConfirmMsg: "<%=GetLocalResourceObject("GridPanel2.Listeners.Confirm.Body").ToString()%>",
                    FailureTitle: "<%=GetLocalResourceObject("GridPanel2.Listeners.Alert.Title").ToString()%>"
                },
                AfterEdit: {
                    FailureTitle: "<%=GetLocalResourceObject("GridPanel2.Listeners.AfterEdit.Alert.Title").ToString()%>"
                },
                DeleteButton: {
                    FailureTitle: "<%=GetLocalResourceObject("DetailWindow.DeleteButton.Listeners.Alert").ToString()%>"
                },
                RevokeButton: {
                    FailureTitle: "<%=GetLocalResourceObject("DetailWindow.RevokeButton.Listeners.Alert").ToString()%>"
                },
                CaseInformation: "<%=GetLocalResourceObject("MsgList.CaseInformation").ToString()%>"
            }

            var ReloadGridByType = function () {
                var detailGrid = Ext.getCmp('GridPanel2');
                //var consignmentGrid = Ext.getCmp('GridPanel3');
                var hiddenDealerType = Ext.getCmp('hiddenDealerType');
                var hiddenShipmentType = Ext.getCmp('hiddenShipmentType');
                //if (hiddenDealerType.getValue() == 'T2' && hiddenShipmentType.getValue() == 'Consignment') {
                //    consignmentGrid.store.reload();
                //} else {
                detailGrid.store.reload();
                //}


            }


            var CheckAddItemsParam = function () {
                var hiddenDealerType = Ext.getCmp('hiddenDealerType');
                var hiddenShipmentType = Ext.getCmp('hiddenShipmentType');
                //此函数用来控制“添加产品”按钮的状态
                //由于Tab异步加载会造成JS错误，应此控件的状态需要根据类型来判断
                //alert(Ext.getCmp('txtShipmentDateWin').getValue());
                if (Ext.getCmp('cbProductLineWin').getValue() == '' || Ext.getCmp('cbHospitalWin').getValue() == '') {


                    Ext.getCmp('AddItemsButton').disable();


                } else {


                    Ext.getCmp('AddItemsButton').enable();
                }
            }

            var SetMod = function (changed) {
                var hiddenIsModified = Ext.getCmp('hiddenIsModified');
                if (changed) {
                    if (hiddenIsModified.getValue() == 'new') {
                        hiddenIsModified.setValue('newchanged');
                    } else if (hiddenIsModified.getValue() == 'old') {
                        hiddenIsModified.setValue('oldchanged');
                    }
                }
            }

            //当关闭明细窗口时，判断是否需要保存数据
            var CheckMod = function () {
                var currenStatus = Ext.getCmp('hiddenIsModified').getValue();
                //Ext.getCmp('orderTypeWin').hide();
                if (currenStatus == 'new') {
                    Coolite.AjaxMethods.DeleteDraft(
                    {
                        success: function () {
                            Ext.getCmp('hiddenIsModified').setValue('');
                            Ext.getCmp('GridPanel1').store.reload();
                            Ext.getCmp('DetailWindow').hide();
                        },
                        failure: function (err) {
                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.failure.Alert").ToString()%>', err);
                        }
                    }
                );
                        return false;
                    }
                if (currenStatus == 'newchanged') {
                    //第一次新增的窗口
                    Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Body").ToString()%>',
                function (e) {
                    if (e == 'yes') {
                        //alert("用户需保存草稿或提交数据");
                    } else {
                        //alert("执行删除草稿的操作");
                        Coolite.AjaxMethods.DeleteDraft(
                        {
                            success: function () {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                            },
                            failure: function (err) {
                                Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.newchanged.Alert").ToString()%>', err);
                            }
                        }
                        );
                        }
                });
                    return false;
                }
                if (currenStatus == 'oldchanged') {
                    //修改窗口
                    Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.oldchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.oldchanged.Confirm.Body").ToString()%>',
                function (e) {
                    if (e == 'yes') {
                        //alert("用户需保存草稿或提交数据");
                    } else {
                        Ext.getCmp('hiddenIsModified').setValue('');
                        Ext.getCmp('DetailWindow').hide();
                    }
                });
                    return false;
                }
            }

            var ChangeProductLine = function () {
                var hiddenProductLineId = Ext.getCmp('hiddenProductLineId');
                var cbProductLineWin = Ext.getCmp('cbProductLineWin');
                var grid = Ext.getCmp('GridPanel2');
                var hiddenIsModified = Ext.getCmp('hiddenIsModified');
                var cbHospitalWin = Ext.getCmp('cbHospitalWin');
                var hiddenHospitalId = Ext.getCmp('hiddenHospitalId');
                var txtShipmentDateWin = Ext.getCmp('txtShipmentDateWin');


                //Ext.getCmp('orderTypeWin').hide();

                if (hiddenProductLineId.getValue() != cbProductLineWin.getValue()) {
                    if (hiddenProductLineId.getValue() == '') {
                        //如果值为空，则说明是第一次选择，不需要删除操作
                        hiddenProductLineId.setValue(cbProductLineWin.getValue());
                        ReloadGridByType();
                        cbHospitalWin.clearValue();
                        hiddenHospitalId.setValue('');
                        cbHospitalWin.store.reload();
                        CheckAddItemsParam();
                        ClearItems();
                        SetMod(true);
                    } else {
                        Ext.Msg.confirm('<%=GetLocalResourceObject("ChangeProductLine.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("ChangeProductLine.Confirm.Body").ToString()%>',
                        function (e) {
                            if (e == 'yes') {
                                hiddenProductLineId.setValue(cbProductLineWin.getValue());
                                Coolite.AjaxMethods.OnProductLineChange(
                                    {
                                        success: function () {

                                            //grid.store.reload();
                                            ReloadGridByType();
                                            txtShipmentDateWin.setValue('');
                                            cbHospitalWin.clearValue();
                                            hiddenHospitalId.setValue('');
                                            CheckAddItemsParam();
                                            ClearItems();
                                            SetMod(true);
                                        },
                                        failure: function (err) {
                                            Ext.Msg.alert('<%=GetLocalResourceObject("ChangeProductLine.Alert").ToString()%>', err);
                                        }
                                    }
                                );
                                    }
                                    else {
                                        cbProductLineWin.setValue(hiddenProductLineId.getValue());
                                    }
                        }
                    );
                            }
                        }

            }

                    var ChangeDealer = function () {
                        cbProductLineWin.clearValue();
                        hiddenProductLineId.setValue('');
                        cbProductLineWin.store.reload();

                        cbHospitalWin.clearValue();
                        hiddenHospitalId.setValue('');
                        cbHospitalWin.store.reload();


                        var hiddenDealerId = Ext.getCmp('hiddenDealerId');
                        var cbDealerWin = Ext.getCmp('cbDealerWin');
                        hiddenDealerId.setValue(cbDealerWin.getValue());
                    }

                    var ChangeIsAuth = function () {
                        Coolite.AjaxMethods.OnHospitalChange(
                                                {
                                                    success: function () {
                                                        //hiddenHospitalId.setValue(cbHospitalWin.getValue());
                                                        ReloadGridByType();
                                                        CheckAddItemsParam();
                                                        ClearItems();
                                                        SetMod(true);
                                                    },
                                                    failure: function (err) {
                                                        Ext.Msg.alert('<%=GetLocalResourceObject("ChangeHospital.Alert").ToString()%>', err);
                                                    }
                                                }
                                );


                    }

                                                var ChangeHospital = function () {
                                                    var hiddenHospitalId = Ext.getCmp('hiddenHospitalId');
                                                    var cbHospitalWin = Ext.getCmp('cbHospitalWin');

                                                    if (hiddenHospitalId.getValue() != cbHospitalWin.getValue()) {
                                                        //如果值为空，则说明是第一次选择，不需要删除操作
                                                        if (hiddenHospitalId.getValue() == '' && hiddenIsFirstShipmentDate.getValue() == 'First') {
                                                            hiddenHospitalId.setValue(cbHospitalWin.getValue());
                                                            ReloadGridByType();
                                                            CheckAddItemsParam();
                                                            ClearItems();
                                                            SetMod(true);
                                                        } else {
                                                            Ext.Msg.confirm('<%=GetLocalResourceObject("ChangeHospital.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("ChangeHospital2.Confirm.Body").ToString()%>',
                                    function (e) {
                                        if (e == 'yes') {
                                            Coolite.AjaxMethods.OnHospitalChangeAuth(
                                                {
                                                    success: function () {
                                                        hiddenHospitalId.setValue(cbHospitalWin.getValue());
                                                        ReloadGridByType();
                                                        CheckAddItemsParam();
                                                        ClearItems();
                                                        SetMod(true);
                                                    },
                                                    failure: function (err) {
                                                        Ext.Msg.alert('<%=GetLocalResourceObject("ChangeHospital.Alert").ToString()%>', err);
                                                    }
                                                }
                                            );
                                                }
                                                else {
                                                    cbHospitalWin.setValue(hiddenHospitalId.getValue());
                                                }
                                    }
                                );
                                        }
                                    }

                                                }

                                //选择用量日期的时候，需要重置销售医院
                                var ChangeShipmentDate = function () {

                                    var hiddenShipmentDate = Ext.getCmp('hiddenShipmentDate');
                                    var hiddenHospitalId = Ext.getCmp('hiddenHospitalId');
                                    var txtShipmentDateWin = Ext.getCmp('txtShipmentDateWin');
                                    var cbHospitalWin = Ext.getCmp('cbHospitalWin');
                                    var cbProductLineWin = Ext.getCmp('cbProductLineWin');

                                    if (cbProductLineWin.getValue() == '') {
                                        Ext.Msg.alert('错误', '请先选择产品线！');
                                        return;
                                    }



                                    if (hiddenShipmentDate.getValue() != txtShipmentDateWin.getValue()) {

                                        //如果值为空，则说明是第一次选择，不需要删除操作
                                        if (hiddenShipmentDate.getValue() == '') {
                                            hiddenIsFirstShipmentDate.setValue('First');
                                        } else {
                                            hiddenIsFirstShipmentDate.setValue('Changed');
                                        }


                                        cbHospitalWin.clearValue();
                                        hiddenHospitalId.setValue('');

                                        Coolite.AjaxMethods.ChangeShipmentDate({
                                            success: function () {
                                                //hiddenShipmentDate.setValue(txtShipmentDateWin.getValue());                         
                                                //cbHospitalWin.clearValue();    
                                            },
                                            failure: function (err) {
                                                Ext.Msg.alert('错误', err);
                                            }
                                        });
                                    }
                                }

                                var CheckDraft = function (grid) {

                                    //保存草稿
                                    //var store = grid.getStore();
                                    //var count = store.getCount();                       
                                    //for (var i = 0; i < count; i++) {

                                    //    var record = store.getAt(i);
                                    //    var unitPrice = record.data.UnitPrice;
                                    //    var shipNum = record.data.ShipmentQty;
                                    //    alert('Row:' + i + '，unitPrice：' + unitPrice + ',shipQty:' + shipNum);
                                    //}

                                    var recordData = [];
                                    Ext.each(grid.getStore().getRange(), function (record) {
                                        recordData.push(record.data);
                                    });
                                    var jsonData = Ext.encode(recordData);

                                    //Ext.getCmp('txtMemoWin').setValue(jsonData);


                                    if (Ext.getCmp('txtMemoWin').getValue().length > 2000) {
                                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.DoSubmit.failure.Alert").ToString()%>', '<%=GetLocalResourceObject("CheckDraft.Alert.Title").ToString()%>');
                                    }
                                    else {

                                        Coolite.AjaxMethods.SaveDraft(jsonData, {
                                            success: function () {
                                                Ext.getCmp('hiddenIsModified').setValue('');
                                                Ext.getCmp('GridPanel1').store.reload();
                                                Ext.getCmp('DetailWindow').hide();
                                                //Ext.getCmp('orderTypeWin').hide();
                                            },
                                            failure: function (err) {
                                                Ext.Msg.alert('<%=GetLocalResourceObject("CheckDraft.Alert.SaveDraft.Title").ToString()%>', err);
                                            }
                                        });
                                        }

                                }


                                    var SubmitCheckCorrectRecord = function () {
                                        Ext.getCmp('BtnSubmitShipment').disable();

                                        Coolite.AjaxMethods.DoSubmit({
                                            success: function (rtn) {
                                                if (rtn == 'Done') {
                                                    Ext.getCmp('hiddenIsModified').setValue('');
                                                    Ext.getCmp('GridPanel1').store.reload();
                                                    Ext.getCmp('CheckSubmitResultWindows').hide();
                                                    Ext.getCmp('DetailWindow').hide();
                                                    Ext.getCmp('BtnSubmitShipment').enable();
                                                }
                                            },
                                            failure: function (err) {
                                                Ext.Msg.alert('提交出错,请联系管理员！', err);
                                                Ext.getCmp('BtnSubmitShipment').enable();
                                            }
                                        });

                                    }


                                    var CheckSubmit = function () {
                                        Ext.getCmp('SubmitButton').disable();

                                        if (Ext.getCmp('txtOrderStatusWin').getValue() == '已完成') {
                                            Coolite.AjaxMethods.DoSubmit({
                                                success: function (rtn) {
                                                    if (rtn == 'Done') {
                                                        Ext.getCmp('hiddenIsModified').setValue('');
                                                        Ext.getCmp('GridPanel1').store.reload();
                                                        Ext.getCmp('DetailWindow').hide();
                                                        //Ext.getCmp('orderTypeWin').hide();
                                                    }
                                                },
                                                failure: function (err) {
                                                    Ext.Msg.alert('错误！', err);
                                                }
                                            });
                                        } else {
                                            var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
                                            if (hiddenIsEditting.getValue() != '') {
                                                Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.DoSubmit.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckSubmit.DoSubmit.Alert.Body").ToString()%>');
                                                return;
                                            }
                                            if (Ext.getCmp('txtMemoWin').getValue().length > 2000) {
                                                Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.txtMemoWin.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckSubmit.txtMemoWin.Alert.Title.Body").ToString()%>');
                                                return;
                                            }

                                            //var cbDealerWin = Ext.getCmp('cbDealerWin');
                                            var cbProductLineWin = Ext.getCmp('cbProductLineWin');
                                            var cbHospitalWin = Ext.getCmp('cbHospitalWin');
                                            var grid = Ext.getCmp('GridPanel2');
                                            //var consignmentGrid = Ext.getCmp('GridPanel3');
                                            var hiddenDealerType = Ext.getCmp('hiddenDealerType');
                                            var hiddenShipmentType = Ext.getCmp('hiddenShipmentType');
                                            var txtShipmentDateWin = Ext.getCmp('txtShipmentDateWin');
                                            var txtOrderStatusWin = Ext.getCmp('txtOrderStatusWin');
                                            var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
                                            var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');

                                            var isAdmin = Ext.getCmp('<%=this.hiddenIsAdmin.ClientID%>').getValue();

                                            if (txtShipmentDateWin.getValue() != '') {
                                                if (cbProductLineWin.getValue() != '' && cbHospitalWin.getValue() != '' &&
                                                     ((hiddenDealerType.getValue() != 'T2' && grid.store.getCount() > 0)
                                                       || (hiddenDealerType.getValue() == 'T2' && hiddenShipmentType.getValue() == 'Consignment')
                                                       || (hiddenDealerType.getValue() == 'T2' && hiddenShipmentType.getValue() != 'Consignment')
                                                      )
                                                    ) {
                                                    //数据核查
                                                    var store;
                                                    var hiddenDealerType = Ext.getCmp('hiddenDealerType');
                                                    var hiddenShipmentType = Ext.getCmp('hiddenShipmentType');
                                                    var strBasicChkRtn = '';
                                                    var qtyCheck = 0;

                                                    //如果是二级寄售，则使用GridPanel3
                                                    store = Ext.getCmp('GridPanel2').store;

                                                    //逐行遍历校验数据（基础校验）
                                                    for (var i = 0; i < store.getCount() ; i++) {
                                                        var record = store.getAt(i);

                                                        //仅草稿状态的单据，在提价时才会进行逐行明细数据的校验
                                                        if (Ext.getCmp('txtOrderStatusWin').getValue() == '草稿' || Ext.getCmp('txtOrderStatusWin').getValue() == '') {

                                                            var re = /^[1-9]\d*$/;
                                                            if (!re.test(record.data.ShipmentQty * record.data.ConvertFactor) && record.data.ShipmentQty > 0 && record.data.ConvertFactor != "3") {
                                                                strBasicChkRtn += '批号：' + record.data.LotNumber + ' 填写的销售数量有误！<br>'
                                                            }

                                                            if (record.data.ShipmentQty == 0) {
                                                                strBasicChkRtn += '批号：' + record.data.LotNumber + ' 销售数量不能为0！<br>'
                                                            }

                                                            if (record.data.UnitPrice == null || record.data.UnitPrice == NaN) {
                                                                strBasicChkRtn += '批号：' + record.data.LotNumber + ' 请填写产品单价！<br>'
                                                            }

                                                            //寄售销售单的采购单价是必填的
                                                            if (isAdmin == 1 && Ext.getCmp("txtShipmentOrderTypeWin").getValue() == "寄售产品销售单" && (record.data.AdjAction == null || record.data.AdjAction == '' || record.data.AdjAction == NaN)) {
                                                                strBasicChkRtn += '批号：' + record.data.LotNumber + ' 请填写产品采购单价！<br>'
                                                            }

                                                            //alert(isAdmin);
                                                            if (isAdmin == 0 && record.data.WhType != "Normal" && record.data.WhType != "Frozen" && record.data.QRCode == "NoQR" && (record.data.QRCodeEdit == '' || record.data.QRCodeEdit == null) && record.data.WhCode.toLocaleUpperCase().indexOf('NOQR') < 0) {
                                                                strBasicChkRtn += '批号：' + record.data.LotNumber + ' 必须填写二维码！<br>';
                                                            }

                                                            if (record.data.QRCodeEdit != null && record.data.QRCodeEdit != '' && record.data.ShipmentQty > 1) {
                                                                strBasicChkRtn += '带二维码的产品数量不得大于一<br>';
                                                            }

                                                            if (store.query("QRCodeEdit", record.data.QRCodeEdit).length > 1 && record.data.QRCodeEdit != '') {
                                                                strBasicChkRtn += '二维码' + record.data.QRCodeEdit + '出现多次';
                                                            }

                                                            if (store.query("QRCode", record.data.QRCodeEdit).length > 0 && record.data.QRCode == "NoQR" && record.data.QRCodeEdit != '') {
                                                                strBasicChkRtn += '二维码' + record.data.QRCode + '已使用';
                                                            }
                                                            //if (Ext.getCmp("hiddenIsShipmentUpdate").getValue() == "UpdateShipment" && record.data.ShipmentDate == null)
                                                            //{
                                                            //    strBasicChkRtn += '批号：' + record.data.LotNumber + ' 请填写实际用量日期！<br>'
                                                            //}

                                                            qtyCheck += record.data.ShipmentQty;
                                                        }
                                                    }
                                                    if (isAdmin == 0 && Ext.getCmp("hiddenIsShipmentUpdate").getValue() == "UpdateShipment" && qtyCheck != 0) {
                                                        strBasicChkRtn += '调整数量设置不准确';
                                                    }

                                                    //如果基础校验全部通过，则调用Ajax方法进行库存、用量日期等的校验
                                                    if (strBasicChkRtn == '') {

                                                        var recordData = [];
                                                        Ext.each(store.getRange(), function (record) {
                                                            recordData.push(record.data);
                                                        });
                                                        var jsonData = Ext.encode(recordData);

                                                        //Begin Ajax：CheckSubmit
                                                        Coolite.AjaxMethods.CheckSubmit(jsonData, {
                                                            success: function () {
                                                                //如果校验没有问题，则继续执行后续的方法
                                                                if (rtnVal.getValue() == "Success") {

                                                                    //Start CheckHasConsumableItems
                                                                    //if (CheckHasConsumableItems()) {
                                                                    //    Ext.Msg.confirm('提示！', '产品中包含耗材，请确认是否在备注中填写了泵号！', function (button) {
                                                                    //        if (button == 'yes') {
                                                                    //            Coolite.AjaxMethods.DoSubmit({
                                                                    //                success: function (rtn) {
                                                                    //                    if (rtn == 'Done') {
                                                                    //                        Ext.getCmp('hiddenIsModified').setValue('');
                                                                    //                        Ext.getCmp('GridPanel1').store.reload();
                                                                    //                        Ext.getCmp('DetailWindow').hide();
                                                                    //                        //Ext.getCmp('orderTypeWin').hide();
                                                                    //                    }
                                                                    //                },
                                                                    //                failure: function (err) {
                                                                    //                    Ext.Msg.alert('提交出错！', err);
                                                                    //                }
                                                                    //            });
                                                                    //        } else {
                                                                    //            return;
                                                                    //        }
                                                                    //    });
                                                                    //} else {

                                                                    //显示错误信息等内容，确认后再进行提交
                                                                    Ext.getCmp('gpCheckSubmitResult').store.reload();

                                                                    //Ext.getCmp('CheckSubmitResultWindows').Show();

                                                                    //Coolite.AjaxMethods.DoSubmit({
                                                                    //    success: function (rtn) {
                                                                    //        if (rtn == 'Done') {
                                                                    //            Ext.getCmp('hiddenIsModified').setValue('');
                                                                    //            Ext.getCmp('GridPanel1').store.reload();
                                                                    //            Ext.getCmp('DetailWindow').hide();
                                                                    //            //Ext.getCmp('orderTypeWin').hide();
                                                                    //        }
                                                                    //    },
                                                                    //    failure: function (err) {
                                                                    //        Ext.Msg.alert('提交出错！', err);
                                                                    //    }
                                                                    //});


                                                                    //}
                                                                    //End CheckHasConsumableItems


                                                                }
                                                                    //如果校验发现问题，则提示错误信息
                                                                else if (rtnVal.getValue() == "Error") {
                                                                    Ext.MessageBox.maxWidth = 700;
                                                                    var reg = new RegExp('brbr', 'g');
                                                                    Ext.Msg.alert('警告！', rtnMsg.getValue().replace(reg, '<br/>'));
                                                                    Ext.getCmp('SubmitButton').enable();

                                                                }
                                                            },
                                                            failure: function (err) {
                                                                //Ajax方法CheckSubmit调用过程中发生的错误
                                                                Ext.Msg.alert('Error！', err);
                                                                Ext.getCmp('SubmitButton').enable();
                                                            }
                                                        }
                                                        ); //End Ajax：CheckSubmit

                                                    } else {
                                                        //提示错误信息
                                                        Ext.MessageBox.maxWidth = 700;
                                                        Ext.Msg.alert('警告！', strBasicChkRtn);
                                                        Ext.getCmp('SubmitButton').enable();
                                                    }


                                                } else {
                                                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.Alert.Title").ToString()%>', ' <%=GetLocalResourceObject("CheckSubmit.Alert.Body").ToString()%>');
                                                    Ext.getCmp('SubmitButton').enable();
                                                }

                                            } else {
                                                Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.Alert.Title1").ToString()%>', ' <%=GetLocalResourceObject("CheckSubmit.Alert.Body1").ToString()%>');
                                                Ext.getCmp('SubmitButton').enable();
                                            }
                                        }
                                        //Ext.getCmp('SubmitButton').enable();
                                    }

                                    var CheckLotQty = function () {
                                        var store;
                                        var hiddenDealerType = Ext.getCmp('hiddenDealerType');
                                        var hiddenShipmentType = Ext.getCmp('hiddenShipmentType');
                                        //if (hiddenDealerType.getValue() == 'T2' && hiddenShipmentType.getValue() == 'Consignment') {
                                        //    store = Ext.getCmp('GridPanel3').store;
                                        //} else {
                                        store = Ext.getCmp('GridPanel2').store;
                                        //}

                                        for (var i = 0; i < store.getCount() ; i++) {

                                            var record = store.getAt(i);
                                            //                if (record.data.ShipmentQty = 0) {
                                            //                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body").ToString()%>');
                                            //                    return false;
                                            //                }
                                            if (Ext.getCmp('txtOrderStatusWin').getValue() == '草稿') {

                                                if (record.data.ShipmentQty > record.data.TotalQty) {
                                                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title1").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body1").ToString()%>');
                                                    return false;
                                                }
                                                var re = /^[1-9]\d*$/;
                                                if (!re.test(record.data.ShipmentQty * record.data.ConvertFactor) && record.data.ShipmentQty > 0) {
                                                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title1").ToString()%>', '销售数量有误');
                                                    return false;
                                                }

                                                if (record.data.ShipmentQty == 0) {
                                                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body").ToString()%>');
                                                    return false;
                                                }

                                                if (record.data.UnitPrice == null || record.data.UnitPrice == NaN) {
                                                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.txtMemoWin.Alert.Title").ToString()%>', '请填写产品价格');
                                                    return false;
                                                }



                                                if (record.data.IsCanOrder == '否' && (record.data.ShipmentDate == null || record.data.ShipmentDate == ''
                                                || record.data.Remark == null || record.data.Remark == '')) {
                                                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.txtMemoWin.Alert.Title").ToString()%>', '请填写实际用量日期和备注');
                                                    return false;
                                                }
                                                if (record.data.WhType != "HospieWh") {

                                                }

                                                if (record.data.IsCanOrder == '否') {
                                                    if ((record.data.CFN_Property6 == 0 && record.data.ShipmentDate.substr(0, 6) > record.data.ExpiredDate) ||
                                                   (record.data.CFN_Property6 == 1 && record.data.ShipmentDate > record.data.ExpiredDate)) {

                                                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.txtMemoWin.Alert.Title").ToString()%>', '实际用量不能大于有效期');
                                                        return false;
                                                    }
                                                }

                                            }
                                        }
                                        return true;
                                    }

                                    var CheckQty = function () {

                                        var qty = /^[1-9]\d*$/;
                                        var txtShipmentQty = Ext.getCmp('txtShipmentQty');
                                        var grid = Ext.getCmp('GridPanel2');
                                        var hiddenCurrentEditShipmentId = Ext.getCmp('hiddenCurrentEditShipmentId');
                                        var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
                                        var record = grid.store.getById(hiddenCurrentEditShipmentId.getValue());
                                        //记录当前编辑的行ID
                                        hiddenIsEditting.setValue(hiddenCurrentEditShipmentId.getValue());

                                        if (accMin(record.data.TotalQty, txtShipmentQty.getValue()) < 0) {
                                            //数量错误时，编辑行置为空
                                            hiddenIsEditting.setValue('');
                                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body").ToString()%>');
                                            return false;
                                        }
                                        if (txtShipmentQty.getValue() == 0) {
                                            //数量错误时，编辑行置为空
                                            hiddenIsEditting.setValue('');
                                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '销售数量不能为0');
                                            return false;
                                        }

                                        if (!qty.test(txtShipmentQty.getValue()) && Ext.getCmp("txtShipmentOrderTypeWin").getValue() == "借货产品销售单") {
                                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("ConsignmentQtyControl").ToString()%>');
                                            return false;
                                        }

                                        //寄售判断小数位(如果转换率为3，且填写的数量不是0.3，或0.4，0.6,或者不是整数，则报错)                           
                                        if ((Ext.getCmp("txtShipmentOrderTypeWin").getValue() == "销售出库单" || Ext.getCmp("txtShipmentOrderTypeWin").getValue() == "寄售产品销售单") && record.data.ConvertFactor == "3" && txtShipmentQty.getValue() != "0.4" && txtShipmentQty.getValue() != "0.3" && txtShipmentQty.getValue() != "0.6" && txtShipmentQty.getValue() != "1") {
                                            Ext.Msg.alert('警告', '此产品包装单位为3<br>请填写0.3、0.4、0.6或整数');
                                            return false;
                                        }

                                        if ((accMul(txtShipmentQty.getValue(), 1000000) % accDiv(1, record.data.ConvertFactor).mul(1000000) != 0) && record.data.ConvertFactor != "3" && (Ext.getCmp("txtShipmentOrderTypeWin").getValue() == "销售出库单" || Ext.getCmp("txtShipmentOrderTypeWin").getValue() == "寄售产品销售单")) {
                                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("ConsignmentQtyControl1").ToString()%>' + accDiv(1, record.data.ConvertFactor).toString());
                                            return false;
                                        }

                                        return true;
                                    }

<%--   var CheckConsignmentQty = function () {

       var qty = /^[1-9]\d*$/;
       var txtShipmentQty = Ext.getCmp('nfConsignmentQty');
       var grid = Ext.getCmp('GridPanel3');
       var hiddenCurrentEditShipmentId = Ext.getCmp('hiddenCurrentEditShipmentId');
       var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
       var record = grid.store.getById(hiddenCurrentEditShipmentId.getValue());
       //记录当前编辑的行ID
       hiddenIsEditting.setValue(hiddenCurrentEditShipmentId.getValue());

       if (accMin(record.data.TotalQty, txtShipmentQty.getValue()) < 0) {
           //数量错误时，编辑行置为空
           hiddenIsEditting.setValue('');
           Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body").ToString()%>');
            return false;
        }

        if (!qty.test(txtShipmentQty.getValue()) && Ext.getCmp("txtShipmentOrderTypeWin").getValue() == "借货产品销售单") {
            Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("ConsignmentQtyControl").ToString()%>');
            return false;
        }

        //寄售判断小数位
        if ((accMul(txtShipmentQty.getValue(), 1000000) % accDiv(1, record.data.ConvertFactor).mul(1000000) != 0)
        && Ext.getCmp("txtShipmentOrderTypeWin").getValue() == "寄售产品销售单") {
            Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("ConsignmentQtyControl1").ToString()%>' + accDiv(1, record.data.ConvertFactor).toString());
            return false;
        }

        return true;
    }--%>

            //var CheckHasConsumableItems = function () {
            //    var store = Ext.getCmp('GridPanel2').store;
            //    for (var i = 0; i < store.getCount() ; i++) {
            //        var record = store.getAt(i);
            //        if (record.data.IsConsumableItem == '1') {
            //            return true;
            //        }
            //    }
            //    return false;
            //}

            var prepare = function (grid, toolbar, rowIndex, record) {
                var firstButton = toolbar.items.get(0);
                firstButton.setDisabled(!record.data.Implant);
            }

            var ShowImplantInfoWindow = function (LotId) {
                var DealerId = Ext.getCmp('cbDealerWin').getValue();
                var ProductLine = Ext.getCmp('cbProductLineWin').getText();
                var HospitalId = Ext.getCmp('cbHospitalWin').getValue();

                if (ProductLine.indexOf("DIB") >= 0) {
                    //window.parent.loadExample('/Pages/Shipment/InsulinPumpWarrantEditor.aspx?lotid=' + LotId + "&dealerid=" + DealerId + "&hospitalid=" + HospitalId, 'subMenu' + LotId, 'DIB植入信息');
                    top.createTab({ id: 'subMenu' + LotId, title: 'DIB植入信息', url: 'Pages/Shipment/InsulinPumpWarrantEditor.aspx?lotid=' + LotId + "&dealerid=" + DealerId + "&hospitalid=" + HospitalId });
                } else if (ProductLine.indexOf("VAS") >= 0) {
                    //window.parent.loadExample('/Pages/Shipment/VasWarrantEditor.aspx?lotid=' + LotId + "&dealerid=" + DealerId + "&hospitalid=" + HospitalId, 'subMenu' + LotId, 'VAS植入信息');
                    top.createTab({ id: 'subMenu' + LotId, title: 'VAS植入信息', url: 'Pages/Shipment/VasWarrantEditor.aspx?lotid=' + LotId + "&dealerid=" + DealerId + "&hospitalid=" + HospitalId });
                }
            }

            var ShowShipmentOperationPage = function () {
                var SPHID = Ext.getCmp('hiddenOrderId').getValue();
                var DealerName = '';
                if (Ext.getCmp('cbDealerWin').getValue() != '') {
                    DealerName = Ext.getCmp('cbDealerWin').getRawValue();
                }
                var HospitalName = '';
                if (Ext.getCmp('cbHospitalWin').getValue() != '') {
                    HospitalName = Ext.getCmp('cbHospitalWin').getRawValue();
                }
                var OrderNumber = Ext.getCmp('txtOrderNumberWin').getValue();
                var ShipmentDate = Ext.util.Format.date(Ext.getCmp('txtShipmentDateWin').getValue(), 'Y-m-d');
                var Invoice = Ext.getCmp('txtInvoice').getValue();
                Coolite.AjaxMethods.OperationDateCheck({
                    success: function (rtn) {
                        //window.parent.loadExample('/Pages/Shipment/ShipmentOperation.aspx?SPHID=' + SPHID + "&OrderNumber=" + OrderNumber + "&ShipmentDate=" + ShipmentDate + "&Invoice=" + Invoice + "&DateCheck=" + rtn + "&DealerName=" + DealerName + "&HospitalName=" + HospitalName, 'subMenu' + SPHID, MsgList.CaseInformation);
                        top.createTab({ id: 'subMenu' + SPHID, title: MsgList.CaseInformation, url: '/Pages/Shipment/ShipmentOperation.aspx?SPHID=' + SPHID + "&OrderNumber=" + OrderNumber + "&ShipmentDate=" + ShipmentDate + "&Invoice=" + Invoice + "&DateCheck=" + rtn + "&DealerName=" + DealerName + "&HospitalName=" + HospitalName });
                    },
                    failure: function (err) {
                        Ext.Msg.alert('<%=GetLocalResourceObject("ShowShipmentOperationPage.Alert").ToString()%>', err);
                    }
                });


            }
                var resetForm = function () {
                    //Ext.getCmp('orderTypeWin').hide();
                }

                var shipmentPrint = function () {
                    return '<img class="imgPrint" ext:qtip="<%=GetLocalResourceObject("shipmentPrint.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/printer.png" />';
                }

                var cellClick = function (grid, rowIndex, columnIndex, e) {
                    var t = e.getTarget();
                    var record = grid.getStore().getAt(rowIndex);  // Get the Record
                    var test = "1";


                    var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
                    var id = record.data['Id'];

                    if (t.className == 'imgPrint' && columnId == 'Id') {

                        //               showModalDialog("ShipmentPrint.aspx?id=" + id, window, "status:false;dialogWidth:850px;dialogHeight:550px");
                        //window.open("ShipmentPrint.aspx?id=" + id, window, "status:false;dialogWidth:850px;dialogHeight:550px");
                        window.open("ShipmentPrint.aspx?id=" + id, 'newwindow',
                        'status=no,width=850px,height=550px,scrollbars=yes,resizable=yes,location=no,top=50,left=100');
                    }
                }

                var SetCellCssEditable = function (v, m) {
                    m.css = "editable-column";
                    return v;
                }

                var SetCellCssNonEditable = function (v, m) {
                    m.css = "nonEditable-column";
                    return v;
                }

                var DoConfirm = function () {
                    Ext.Msg.confirm('<%=GetLocalResourceObject("IsConfirm").ToString()%>', '<%=GetLocalResourceObject("AddNoSalesRecord").ToString()%>',
          function (e) {
              if (e == 'yes') {

                  Coolite.AjaxMethods.DoConfirm(
                  {
                      success: function () {

                          Ext.Msg.alert('<%=GetLocalResourceObject("DoConfirm.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("AddSuccess").ToString()%>');
                      }
                                    ,
                      failure: function () {
                          Ext.Msg.alert('<%=GetLocalResourceObject("DoConfirm.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("AddFailer").ToString()%>');
                      }


                  });
              }
              else {

              }
          });
                }




      function SelectValue(e) {
          var filterField = 'Name';  //需进行模糊查询的字段
          var combo = e.combo;
          combo.collapse();
          if (!e.forceAll) {
              var value = e.query;
              if (value != null && value != '') {
                  combo.store.filterBy(function (record, id) {
                      var text = record.get(filterField);
                      value = value.replace(/\s/g, '');
                      if (text != null && text != "") {
                          // 用自己的过滤规则,如写正则式
                          return (text.indexOf(value) != -1);
                      }
                      else {
                          return false;
                      }
                  });
              } else {
                  combo.store.clearFilter();
              }
              combo.onLoad(); //不加第一次会显示不出来  
              combo.expand();
              return false;
          }
      }

      function SelectDealerValue(e) {
          var filterField = 'ChineseName';  //需进行模糊查询的字段
          var combo = e.combo;
          combo.collapse();
          if (!e.forceAll) {
              var value = e.query;
              if (value != null && value != '') {
                  combo.store.filterBy(function (record, id) {
                      var text = record.get(filterField);
                      value = value.replace(/\s/g, '');
                      if (text != null && text != "") {
                          // 用自己的过滤规则,如写正则式
                          return (text.indexOf(value) != -1);
                      }
                      else {
                          return false;
                      }
                  });
              } else {
                  combo.store.clearFilter();
              }
              combo.onLoad(); //不加第一次会显示不出来  
              combo.expand();
              return false;
          }
      }


      //触发函数
      function downloadfile(url) {
          var iframe = document.createElement("iframe");
          iframe.src = url;
          iframe.style.display = "none";
          document.body.appendChild(iframe);
      }

      //将时间转化为 2011-08-20 00:00:00 格式 
      //解决Ext4的formPanel通过grid的store查询问题 2012.2.22 jzr 
      function dateFormat(value) {
          if (null != value) {
              return Ext.Date.format(new Date(value), 'Y-m-d H:i:s');
          } else {
              return null;
          }
      }

      var ReloadAdjustWindow = function () {
          var gpHistoryShipment = Ext.getCmp('gpHistoryShipment');
          var gpInventory = Ext.getCmp('gpInventory');

          gpHistoryShipment.reload();
          gpInventory.reload();
      }

      var CheckAdjustQtyForInv = function () {

          var qty = /^[1-9]\d*$/;
          var txtShipmentQty = Ext.getCmp('nfShipmentQtyForInv');
          var grid = Ext.getCmp('gpInventory');
          var id = Ext.getCmp('hiddenCurrentEditShipmentId');
          var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
          var record = grid.store.getById(id.getValue());
          //记录当前编辑的行ID
          hiddenIsEditting.setValue(id.getValue());

          if (accMin(record.data.TotalQty, txtShipmentQty.getValue()) < 0) {
              //数量错误时，编辑行置为空
              hiddenIsEditting.setValue('');
              Ext.Msg.alert('Wraning', '销售数量大于库存数量！');
              return false;
          }
          if (txtShipmentQty.getValue() == 0) {
              //数量错误时，编辑行置为空
              hiddenIsEditting.setValue('');
              Ext.Msg.alert('Wraning', '销售数量不能为0');
              return false;
          }
          //寄售判断小数位
          if ((accMul(txtShipmentQty.getValue(), 1000000) % accDiv(1, record.data.ConvertFactor).mul(1000000) != 0)
          && (Ext.getCmp("txtShipmentOrderTypeWin").getValue() == "销售出库单" || Ext.getCmp("txtShipmentOrderTypeWin").getValue() == "寄售产品销售单")) {
              Ext.Msg.alert('Wraning', '最小单位是：' + accDiv(1, record.data.ConvertFactor).toString());
              return false;
          }

          return true;
      }

      var CheckAdjustQtyForShipment = function () {


          return true;
      }

      var CheckAddForAdmin = function () {
          var inventoryStore = Ext.getCmp('gpInventory').store;
          var shipmentStore = Ext.getCmp('gpHistoryShipment').store;
          var shipmentType = Ext.getCmp("txtShipmentOrderTypeWin").getValue();
          var record;
          if (shipmentType == '寄售产品销售单') {
              for (var i = 0; i < inventoryStore.getCount() ; i++) {
                  record = inventoryStore.getAt(i);

                  if (record.data.ShipmentPrice == '' || record.data.ShipmentPrice == null) {
                      Ext.Msg.alert('Wraning', '请填写销售单价');
                      return false;
                  }
              }

              for (var i = 0; i < shipmentStore.getCount() ; i++) {
                  record = shipmentStore.getAt(i);

                  if (record.data.ShipmentPrice == '' || record.data.ShipmentPrice == null) {
                      Ext.Msg.alert('Wraning', '请填写销售单价');
                      return false;
                  }
                  if (record.data.ShipmentQty == '' || record.data.ShipmentQty == null || record.data.ShipmentQty == 0) {
                      Ext.Msg.alert('Wraning', '请填写销售数量');
                      return false;
                  }
              }
          }

          Coolite.AjaxMethods.AddShipmentAdjustToShipmentLot();
      }

      function ComboxSelValue(e) {
          var combo = e.combo;
          combo.collapse();
          if (!e.forceAll) {
              var input = e.query;
              if (input != null && input != '') {
                  // 检索的正则
                  var regExp = new RegExp(".*" + input + ".*");
                  // 执行检索
                  combo.store.filterBy(function (record, id) {
                      // 得到每个record的项目名称值
                      var text = record.get(combo.displayField);
                      return regExp.test(text);
                  });
              } else {
                  combo.store.clearFilter();
              }
              combo.expand();
              return false;
          }
      }

      function SetShipmentData() {
          var txtShipmentDateWin = Ext.getCmp('txtShipmentDateWin')
          Coolite.AjaxMethods.SetShipmentData({
              success: function () {


              },
              failure: function (err) {

              }
          });
      }

      function getIsErrorInvoiceInitClass(record, index) {
          if (record.data.IsError == '1' || record.data.IsError == true) {
              return 'yellow-row';
          }
      }
        </script>

        <script type="text/javascript">
            var swfu;
            var uploadTotalDesc;
            var uploadSuccessDesc;
            var uploadFailureDesc;
            var divUploadErrorlist;

            var successCount;
            var failureCount;

            window.onload = function () {
                swfu = swfu_upload_init("spanButtonPlaceHolder", "divprogresscontainer", "divprogressGroup", "ShipmentInvoice", uploadSuccess_forShipment);

                uploadTotalDesc = document.getElementById("spanUploadTotalDesc");
                uploadSuccessDesc = document.getElementById("spanUploadSuccessDesc");
                uploadFailureDesc = document.getElementById("spanUploadFailureDesc");
                divUploadErrorlist = document.getElementById("divUploadErrorlist");
            }

            function shipmentInvoideUploadHelp() {
                Ext.getCmp('<%=this.InvoiceHelpWindows.ClientID%>').show();
            }

            function shipmentInvoideUploadReset() {
                swfu_upload_reset("divprogresscontainer", resetUploadFileMessage);
            }

            function shipmentInvoiceStartUpload() {
                swfu.startUpload();
                var totalCount = parseInt(uploadTotalDesc.innerHTML) == NaN ? 0 : parseInt(uploadTotalDesc.innerHTML);
                uploadTotalDesc.innerHTML = totalCount + swfu.getStats().files_queued;
            }

            function resetUploadFileMessage() {
                uploadTotalDesc.innerHTML = 0;
                uploadSuccessDesc.innerHTML = 0;
                uploadFailureDesc.innerHTML = 0;
                divUploadErrorlist.innerHTML = "";
            }

            function uploadSuccess_forShipment(file, serverData) {
                try {

                    var progress = new FileProgress(file, swfu.settings.custom_settings.progressTarget);
                    progress.setComplete(this.settings);
                    fg_uploads += file.size;

                    Coolite.AjaxMethods.UploadShipmentAttachment(file.index, file.name, serverData,
                            {
                                success: function (rtnVal) {
                                    var idx = rtnVal.split(",")[0];
                                    var cn = rtnVal.split(",")[1];

                                    if (parseInt(cn) == 0) {
                                        //Ext.Msg.alert("Error", "文件名" + file.name + ";在系统中没有此发票号的信息");

                                        //var divProgress = document.getElementById("divprogresscontainer");

                                        //var chile = document.getElementById("divprogresscontainer").childNodes[idx];

                                        failureCount = parseInt(uploadFailureDesc.innerHTML) == NaN ? 0 : parseInt(uploadFailureDesc.innerHTML);

                                        uploadFailureDesc.innerHTML = failureCount + 1;

                                        if (divUploadErrorlist.innerHTML == "") {
                                            divUploadErrorlist.innerHTML = file.name;
                                        } else {
                                            divUploadErrorlist.innerHTML = divUploadErrorlist.innerHTML + '<br /><br />' + file.name;
                                        }

                                        progress.setMessage("<font style='color:red;'>在系统中没有此发票号的信息</red>");
                                    }
                                    else {
                                        successCount = parseInt(uploadSuccessDesc.innerHTML) == NaN ? 0 : parseInt(uploadSuccessDesc.innerHTML);

                                        uploadSuccessDesc.innerHTML = successCount + 1;
                                        progress.setMessage("<font style='color:red;'>上传成功！</red>");
                                    }
                                },
                                failure: function (err) { Ext.Msg.alert("Error", err); }
                            }
                        );

                } catch (ex) {
                    this.debug(ex);
                }
            }

            var Img = '<img src="{0}"></img>';
            var change = function (value) {
                if (value == '1') {
                    return String.format(Img, '/resources/images/icons/cross.png');
                }
                else if (value == '0') {
                    return String.format(Img, '/resources/images/icons/tick.png');
                }
                else {
                    //return "";
                    return String.format(Img, '/resources/images/icons/bullet_go.png');
                }
            }

            var qrcheckChange = function (value) {
                if (value == '1') {
                    return String.format(Img, '/resources/images/icons/exclamation.png');
                }
                else if (value == '0') {
                    return String.format(Img, '/resources/images/icons/tick.png');
                }
                else {
                    //return "";
                    return String.format(Img, '/resources/images/icons/bullet_go.png');
                }
            }

            var alertInfo = function (value) {
                if (null != value)
                    return "<p style='color:red'>" + value + "</p>";
                else return value;
            }

            var alertInfoQty = function (value) {
                if (null != value && value == '0.01')
                    return "<p style='color:red'>" + value + "</p>";
                else return value;
            }

            var renderDataErrorType = function (value) {
                if (value == '授权') {
                    return '<a class="ErrorTypeQuery" ext:qtip="点击查看授权" style="cursor:pointer;">' + value + '</a>';
                } else {
                    return ""
                }
            }

            var cellClickErrorResult = function (grid, rowIndex, columnIndex, e) {

                var t = e.getTarget();
                var record = grid.getStore().getAt(rowIndex);  // Get the Record   
                var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
                if (t.className == 'ErrorTypeQuery' && columnId == 'ErrorType') {
                    Coolite.AjaxMethods.AuthorizationDialog.AuthorizationShow(record.data.CustomerFaceNbr, record.data.Dealerid, { success: function () { }, failure: function (err) { Ext.Msg.alert('Error', err); } });
                }
            }

            function getErrorRowClass(record, index) {
                if (record.data.IsError == '1') {
                    return 'yellow-row';

                }
            }
        </script>

        <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="AttributeName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Id" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="PohId" />
                        <ext:RecordField Name="OperUser" />
                        <ext:RecordField Name="OperUserId" />
                        <ext:RecordField Name="OperUserName" />
                        <ext:RecordField Name="OperType" />
                        <ext:RecordField Name="OperTypeName" />
                        <ext:RecordField Name="OperDate" Type="Date" />
                        <ext:RecordField Name="OperNote" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="false" OnRefreshData="AttachmentStore_Refresh">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Attachment" />
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="Url" />
                        <ext:RecordField Name="Type" />
                        <ext:RecordField Name="UploadUser" />
                        <ext:RecordField Name="Identity_Name" />
                        <ext:RecordField Name="UploadDate" />
                        <ext:RecordField Name="IsCurrent" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="ProductLineWinStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLineWin" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="AttributeName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <BaseParams>
                <ext:Parameter Name="DealerId" Value="#{hiddenDealerId}.getValue()" Mode="Raw" />
            </BaseParams>
            <Listeners>
                <Load Handler="if (#{hiddenProductLineId}.getValue()==''){ #{hiddenProductLineId}.setValue(#{cbProductLineWin}.store.getTotalCount()>0?#{cbProductLineWin}.store.getAt(0).get('Id'):'');}#{cbProductLineWin}.setValue(#{hiddenProductLineId}.getValue());SetShipmentData();" />
            </Listeners>
            <SortInfo Field="Id" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="HospitalWinStore" runat="server" UseIdConfirmation="true" AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="ShortName" />
                        <ext:RecordField Name="Address" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{cbHospitalWin}.setValue(#{hiddenHospitalId}.getValue());" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseShortName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{cbDealerWin}.setValue(#{hiddenInitDealerId}.getValue());" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="OrderStatusStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Key" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="ShipmentOrderTypeStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Key" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="OrderNumber" />
                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="ShipmentDate" />
                        <ext:RecordField Name="ShipmentName" />
                        <ext:RecordField Name="Status" />
                        <ext:RecordField Name="ReverseId" />
                        <ext:RecordField Name="ProductLine" />
                        <ext:RecordField Name="TotalQyt" />
                        <ext:RecordField Name="TotalAmount" />
                        <ext:RecordField Name="Type" />
                        <ext:RecordField Name="SubmitDate" />
                        <ext:RecordField Name="InvoiceStatus" />
                        <ext:RecordField Name="SubmitDays" />
                        <ext:RecordField Name="InvoiceTitle" />
                        <ext:RecordField Name="InvoiceNo" />
                        <ext:RecordField Name="InvoiceDate" />
                        <ext:RecordField Name="Annexsource" />
                        <ext:RecordField Name="AdjType" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--<SortInfo Field="OrderNumber" Direction="ASC" />--%>
        </ext:Store>
        <ext:Hidden ID="hiddenInitDealerId" runat="server">
        </ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources:Panel1.Title %>" AutoHeight="true" BodyStyle="padding: 5px;" Frame="true" Icon="Find">
                            <Body>
                                <ext:Panel runat="server" ID="er">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".3">
                                                <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources:Panel1.FormLayout1.cbProductLine.EmptyText %>" Width="150" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" ListWidth="300" Resizable="true" DisplayField="AttributeName"
                                                                    FieldLabel="<%$ Resources:Panel1.FormLayout1.cbProductLine.FieldLabel %>">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:Panel1.FormLayout1.cbProductLine.FieldTrigger.Qtip %>" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtStartDate" runat="server" Width="150" FieldLabel="<%$ Resources:Panel1.FormLayout1.txtStartDate.FieldLabel %>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtOrderNumber" runat="server" Width="150" FieldLabel="<%$ Resources:Panel1.FormLayout1.txtOrderNumber.FieldLabel %>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtSubmitDateStart" runat="server" Width="150" FieldLabel="<%$ Resources:Panel1.FormLayout1.txtSubmitDate.FieldLabel%>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbInvoiceStatus" runat="server" EmptyText="" Editable="true" TypeAhead="true" Mode="Local" Width="150" Resizable="true" FieldLabel="<%$ Resources:GridPanel1.ColumnModel1.InvoiceStatus.Header %>">
                                                                    <Items>
                                                                        <ext:ListItem Text="未填写" Value="未填写" />
                                                                        <ext:ListItem Text="不完整" Value="不完整" />
                                                                        <ext:ListItem Text="已填写" Value="已填写" />
                                                                    </Items>
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtInvoiceDateStart" runat="server" Width="150" FieldLabel="发票开始日期" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources:Panel1.FormLayout2.cbDealer.EmptyText %>" Width="220" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName" Mode="Local" ListWidth="300" Resizable="true"
                                                                    FieldLabel="<%$ Resources:Panel1.FormLayout2.cbDealer.FieldLabel %>">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:Panel1.FormLayout2.cbDealer.FieldTrigger.Qtip %>" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                        <TriggerClick Handler="this.clearValue();this.store.clearFilter();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtEndDate" runat="server" Width="150" FieldLabel="<%$ Resources:Panel1.FormLayout2.txtEndDate.FieldLabel %>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtCFN" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtUPN" runat="server" Width="150" FieldLabel="<%$ Resources:Panel1.FormLayout2.txtUPN.FieldLabel %>" Hidden="<%$ AppSettings: HiddenUPN  %>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtSubmitDateEnd" runat="server" Width="150" FieldLabel="<%$ Resources:Panel1.FormLayout1.txtSubmitDateEnd.FieldLabel%>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtInvoiceNo" runat="server" Width="150" FieldLabel="<%$ Resources:GridPanel1.ColumnModel1.InvoiceNo.Header %>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtInvoiceDateend" runat="server" Width="150" FieldLabel="发票结束日期" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbOrderStatus" runat="server" EmptyText="<%$ Resources:Panel1.FormLayout3.cbOrderStatus.EmptyText %>" Width="150" Editable="false" TypeAhead="true" StoreID="OrderStatusStore" ValueField="Key" DisplayField="Value" FieldLabel="<%$ Resources:Panel1.FormLayout3.cbOrderStatus.FieldLabel %>">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:Panel1.FormLayout3.cbOrderStatus.FieldTrigger.Qtip %>" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtHospital" runat="server" Width="150" FieldLabel="<%$ Resources:Panel1.FormLayout3.txtHospital.FieldLabel %>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtLotNumber" runat="server" Width="150" FieldLabel="<%$ Resources:Panel1.FormLayout3.txtLotNumber.FieldLabel %>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbShipmentOrderTypeWin" runat="server" EmptyText=" " Width="150" Editable="false" TypeAhead="true" StoreID="ShipmentOrderTypeStore" ValueField="Key" DisplayField="Value" FieldLabel="<%$ Resources:Panel1.FormLayout3.ShipmentOrderType.FieldLabel %>"
                                                                    Mode="Local">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbInvoiceState" runat="server" EmptyText="上报状态" Width="150" Editable="false"
                                                                    TypeAhead="true" FieldLabel="发票上报状态" ListWidth="150" Resizable="true">
                                                                    <Items>
                                                                        <ext:ListItem Text="已上传" Value="已上传" />
                                                                        <ext:ListItem Text="未上传" Value="未上传" />
                                                                    </Items>
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:Panel ID="Panel32" runat="server">
                                    <Body>
                                        <ext:Label ID="Remark" runat="server" LabelSeparator="" Width="200"
                                            EmptyText="您有超期未上传发票的销量单据" CtCls="txtRed" />
                                    </Body>
                                </ext:Panel>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnUploadFile" runat="server" Text="批量上传发票附件" Icon="Add">
                                    <Listeners>
                                        <Click Handler="#{ShipmentInvoiceUploadWindows}.show();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnUploadInvoice" runat="server" Text="批量导入发票号" Icon="Add">
                                    <Listeners>
                                        <Click Handler="#{InvoiceUploadWindows}.show();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnConfirm" Text="<%$ Resources:NoSalesConfrimation %>" runat="server">
                                    <Listeners>
                                        <Click Handler="DoConfirm()" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnSearch" Text="<%$ Resources:Panel1.btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources:Panel1.btnInsert.Text %>" Icon="Add" IDMode="Legacy">
                                    <AjaxEvents>
                                        <Click Before=" #{hiddenIsShipmentUpdate}.setValue(''); #{hiddenShipmentType}.setValue('Hospital');#{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);" Success="#{cbDealerWin}.clearValue();#{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.clearValue();#{cbHospitalWin}.clearValue();#{ProductLineWinStore}.reload();ClearItems();#{GridPanel2}.clear();#{gpLog}.clear();#{gpAttachment}.clear();#{hiddenIsModified}.setValue('new');">
                                            <ExtraParams>
                                                <ext:Parameter Name="OrderId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                                </ext:Parameter>
                                                <ext:Parameter Name="Type" Value="Hospital" Mode="Value">
                                                </ext:Parameter>
                                            </ExtraParams>
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnInsertJS" runat="server" Text="<%$ Resources:Panel1.btnInsertJS.Text%>" Icon="Add" IDMode="Legacy">
                                    <AjaxEvents>
                                        <Click Before="#{hiddenIsShipmentUpdate}.setValue(''); #{hiddenShipmentType}.setValue('Consignment');#{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);" Success="#{cbDealerWin}.clearValue();#{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.clearValue();#{cbHospitalWin}.clearValue();#{ProductLineWinStore}.reload();ClearItems();#{GridPanel2}.clear();#{gpLog}.clear();#{gpAttachment}.clear();#{hiddenIsModified}.setValue('new');">
                                            <ExtraParams>
                                                <ext:Parameter Name="OrderId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                                </ext:Parameter>
                                                <ext:Parameter Name="Type" Value="Consignment" Mode="Value">
                                                </ext:Parameter>
                                            </ExtraParams>
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnInsertBorrow" runat="server" Text="<%$ Resources:Panel1.btnInsertJH.Text%>" Icon="Add" IDMode="Legacy">
                                    <AjaxEvents>
                                        <Click Before="#{hiddenIsShipmentUpdate}.setValue(''); #{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                            Success="#{cbDealerWin}.clearValue();#{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.clearValue();#{cbHospitalWin}.clearValue();#{ProductLineWinStore}.reload();ClearItems();#{GridPanel2}.clear();#{gpLog}.clear();#{gpAttachment}.clear();#{hiddenIsModified}.setValue('new');">
                                            <ExtraParams>
                                                <ext:Parameter Name="OrderId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                                </ext:Parameter>
                                                <ext:Parameter Name="Type" Value="Borrow" Mode="Value">
                                                </ext:Parameter>
                                            </ExtraParams>
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnUpdate" runat="server" Text="销量单二维码替换" Icon="Add" IDMode="Legacy">
                                    <AjaxEvents>
                                        <Click Before=" #{hiddenIsShipmentUpdate}.setValue('UpdateShipment'); 
                                                        #{hiddenShipmentType}.setValue('Hospital');
                                                        #{GridPanel1}.getSelectionModel().clearSelections();"
                                            OnEvent="ShowDetailsUpdate"
                                            Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                            Success="#{cbDealerWin}.clearValue();
                                                        if (#{hiddenDealerId}.getValue()!='' && #{hiddenDealerId}.getValue().toUpperCase() !='FB62D945-C9D7-4B0F-8D26-4672D2C728B7')
                                                           {#{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());}
                                                           #{cbProductLineWin}.clearValue();#{cbHospitalWin}.clearValue();#{ProductLineWinStore}.reload();ClearItems();#{GridPanel2}.clear();#{gpLog}.clear();#{gpAttachment}.clear();#{hiddenIsModified}.setValue('new');">
                                            <ExtraParams>
                                                <ext:Parameter Name="OrderId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                                </ext:Parameter>
                                                <ext:Parameter Name="Type" Value="Hospital" Mode="Value">
                                                </ext:Parameter>
                                            </ExtraParams>
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnUpdateConsignment" runat="server" Text="补寄售销售单" Icon="Add" IDMode="Legacy">
                                    <AjaxEvents>
                                        <Click Before="#{hiddenIsShipmentUpdate}.setValue('UpdateShipment');#{hiddenIsShipmentUpdate}.setValue('UpdateShipment');#{hiddenShipmentType}.setValue('Hospital');#{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowDetailsUpdate" Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                            Success="#{cbDealerWin}.clearValue();
                                            if (#{hiddenDealerId}.getValue()!='' && #{hiddenDealerId}.getValue().toUpperCase() !='FB62D945-C9D7-4B0F-8D26-4672D2C728B7'){#{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());}
                                            #{cbProductLineWin}.clearValue();#{cbHospitalWin}.clearValue();#{ProductLineWinStore}.reload();ClearItems();#{GridPanel2}.clear();#{gpLog}.clear();#{gpAttachment}.clear();#{hiddenIsModified}.setValue('new');">
                                            <ExtraParams>
                                                <ext:Parameter Name="OrderId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                                </ext:Parameter>
                                                <ext:Parameter Name="Type" Value="Consignment" Mode="Value">
                                                </ext:Parameter>
                                            </ExtraParams>
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnExport" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="true" OnClick="ExportDetail">
                                </ext:Button>
                                <ext:Button ID="btnExportshipment" Text="导出销售单发票" runat="server" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="true" OnClick="ExportShipment">
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources:GridPanel1.Title %>" StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerId" DataIndex="DealerId" Header="<%$ Resources:GridPanel1.ColumnModel1.DealerId.Header %>" Width="180">
                                                    <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseShortName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="OrderNumber" DataIndex="OrderNumber" Header="<%$ Resources:GridPanel1.ColumnModel1.OrderNumber.Header %>" Width="195">
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="<%$ Resources:GridPanel1.ColumnModel1.HospitalName.Header %>" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="TotalQyt" DataIndex="TotalQyt" Header="<%$ Resources:GridPanel1.ColumnModel1.TotalQyt.Header %>" Width="60" Align="Right">
                                                </ext:Column>
                                                <ext:Column ColumnID="TotalAmount" DataIndex="TotalAmount" Header="<%$ Resources:GridPanel1.ColumnModel1.TotalAmount.Header %>" Width="80" Align="Right">
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipmentDate" DataIndex="ShipmentDate" Header="<%$ Resources:GridPanel1.ColumnModel1.ShipmentDate.Header %>" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipmentName" DataIndex="ShipmentName" Header="<%$ Resources:GridPanel1.ColumnModel1.ShipmentName.Header %>" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="Status" DataIndex="Status" Header="<%$ Resources:GridPanel1.ColumnModel1.Status.Header %>" Align="Center">
                                                    <Renderer Handler="return getNameFromStoreById(OrderStatusStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Type" DataIndex="Type" Header="<%$ Resources:Panel1.FormLayout3.ShipmentOrderType.FieldLabel %>" Align="Center">
                                                    <Renderer Handler="return getNameFromStoreById(ShipmentOrderTypeStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column Width="60" ColumnID="InvoiceStatus" DataIndex="InvoiceStatus" Header="<%$ Resources:GridPanel1.ColumnModel1.InvoiceStatus.Header %>" Align="Center">
                                                </ext:Column>
                                                <ext:Column Width="60" ColumnID="InvoiceTitle" DataIndex="InvoiceTitle" Hidden="true" Header="<%$ Resources:GridPanel1.ColumnModel1.InvoiceTitle.Header %>" Align="Center">
                                                </ext:Column>
                                                <ext:Column Width="60" ColumnID="InvoiceNo" DataIndex="InvoiceNo" Hidden="true" Header="<%$ Resources:GridPanel1.ColumnModel1.InvoiceNo.Header %>" Align="Center">
                                                </ext:Column>
                                                <ext:Column Width="60" ColumnID="InvoiceDate" DataIndex="InvoiceDate" Hidden="true" Header="<%$ Resources:GridPanel1.ColumnModel1.InvoicDate.Header %>" Align="Center">
                                                </ext:Column>
                                                <ext:Column Width="60" ColumnID="SubmitDays" DataIndex="SubmitDays" Header="已上报天数" Align="Center">
                                                </ext:Column>
                                                <ext:Column Width="70" ColumnID="Annexsource" DataIndex="Annexsource" Header="附件来源" Align="Center"></ext:Column>
                                                <ext:CommandColumn Width="60" Header="<%$ Resources:GridPanel1.ColumnModel1.CommandColumn.Header %>" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="<%$ Resources:GridPanel1.ColumnModel1.CommandColumn.ToolTip.Text %>" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:Column ColumnID="Id" DataIndex="Id" Header="<%$ Resources:GridPanel1.ColumnModel1.Id.Header %>" Align="Center">
                                                    <Renderer Fn="shipmentPrint" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <AjaxEvents>
                                            <Command OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.ShowDetails.FailureTitle, MsgList.ShowDetails.FailureMsg);"
                                                Before="#{GridPanel2}.clear();
                                                       #{hiddenIsShipmentUpdate}.setValue(#{GridPanel1}.getSelectionModel().getSelected().data.AdjType);"
                                                Success="#{GridPanel2}.reload();#{cbDealerWin}.clearValue();#{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.clearValue(); #{ProductLineWinStore}.reload();ClearItems();#{gpLog}.reload();#{gpAttachment}.reload();#{hiddenIsModified}.setValue('old');#{gpLog}.store.reload();#{gpAttachment}.store.reload();">
                                                <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                                <ExtraParams>
                                                    <ext:Parameter Name="OrderId" Value="#{GridPanel1}.getSelectionModel().getSelected().id" Mode="Raw">
                                                    </ext:Parameter>
                                                </ExtraParams>
                                            </Command>
                                        </AjaxEvents>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore" DisplayInfo="false" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel1.LoadMask.Msg %>" />
                                        <Listeners>
                                            <CellClick Fn="cellClick" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>

        <ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="CFN" />
                        <ext:RecordField Name="UPN" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="UnitOfMeasure" />
                        <ext:RecordField Name="UnitPrice" />
                        <ext:RecordField Name="ShipmentQty" />
                        <ext:RecordField Name="TotalQty" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="WarehouseId" />
                        <ext:RecordField Name="Implant" />
                        <ext:RecordField Name="IsConsumableItem" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="CFNEnName" />
                        <ext:RecordField Name="CFNChName" />
                        <ext:RecordField Name="ShipmentDate" />
                        <ext:RecordField Name="Remark" />
                        <ext:RecordField Name="IsCanOrder" />
                        <ext:RecordField Name="CFN_Property6" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="PurchaseOrderNbr" />
                        <ext:RecordField Name="QRCode" />
                        <ext:RecordField Name="QRCodeEdit" />
                        <ext:RecordField Name="WhType" />
                        <ext:RecordField Name="WhCode" />
                        <ext:RecordField Name="AdjAction" />
                        <ext:RecordField Name="QRCheck" />
                        <ext:RecordField Name="IsError" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert(MsgList.DetailStore.LoadExceptionTitle, e.message || response.statusText);" />
            </Listeners>
            <%--        <SortInfo Field="CFN" Direction="ASC" /> 要按CFN,UPN,LotNumber排序 --%>
        </ext:Store>
        <%--<ext:Store ID="ConsignmentDetailStore" runat="server" OnRefreshData="ConsignmentDetailStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="CFN" />
                        <ext:RecordField Name="UPN" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="UnitOfMeasure" />
                        <ext:RecordField Name="UnitPrice" />
                        <ext:RecordField Name="ShipmentQty" />
                        <ext:RecordField Name="TotalQty" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="WarehouseId" />
                        <ext:RecordField Name="Implant" />
                        <ext:RecordField Name="IsConsumableItem" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="CFNEnName" />
                        <ext:RecordField Name="CFNChName" />
                        <ext:RecordField Name="ShipmentDate" />
                        <ext:RecordField Name="Remark" />
                        <ext:RecordField Name="IsCanOrder" />
                        <ext:RecordField Name="CFN_Property6" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="PurchaseOrderNbr" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert(MsgList.DetailStore.LoadExceptionTitle, e.message || response.statusText);" />
            </Listeners>
        </ext:Store>--%>
        <ext:Store ID="CongisnmentOrderStore" runat="server" OnRefreshData="CongisnmentOrderStore_RefershData" AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="PurchaseOrderNbr" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="hiddenIsAdmin" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenOrderId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenDealerId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenDealerType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenProductLineId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenHospitalId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenCFN" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenLotNumber" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenIsModified" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidRtnVal" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidRtnMsg" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenCurrentEditShipmentId" runat="server" />
        <ext:Hidden ID="hiddenIsEditting" runat="server" />
        <ext:Hidden ID="hiddenShipmentType" runat="server" />
        <ext:Hidden ID="hiddenShipmentDate" runat="server" />
        <ext:Hidden ID="hiddenIsFirstShipmentDate" runat="server" />
        <ext:Hidden ID="hiddenQrCode" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenShipmentStatus" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenLotNumberCode" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenIsShipmentUpdate" runat="server">
        </ext:Hidden>
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>" Width="980" Height="520" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Resizable="false" Header="false" CenterOnLoad="true"
            Y="10" Maximizable="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:Panel ID="Panel20" runat="server" Height="40">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".66">
                                                <ext:Panel ID="Panel21" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout15" runat="server" LabelAlign="Left" LabelWidth="60">
                                                            <%-- 经销商 --%>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbDealerWin" runat="server" Width="510" Editable="true" TypeAhead="false" Mode="Local" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName" FieldLabel="<%$ Resources: Panel7.FormLayout4.cbDealerWin.FieldLabel %>" ListWidth="500"
                                                                    Resizable="true" AllowBlank="false" BlankText="<%$ Resources: Panel7.FormLayout4.cbDealerWin.BlankText %>" EmptyText="<%$ Resources: Panel7.FormLayout4.cbDealerWin.EmptyText %>">
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                        <Select Handler="ChangeDealer();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".34">
                                                <ext:Panel ID="Panel22" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout16" runat="server" LabelAlign="Left" LabelWidth="60">
                                                            <%-- 销售单类型选择 ，已不使用，注释掉 by swm on 2018-06-19--%>
                                                            <%-- 
                                                            <ext:Anchor Horizontal="34%">
                                                                <ext:RadioGroup ID="orderTypeWin" runat="server" FieldLabel="<%$ Resources:PanelOrderType.orderTypeWin.FieldLabel %>" ColumnsNumber="2" Width="100" Hidden="true">
                                                                    <Items>
                                                                        <ext:Radio ID="rbPersonalWin" runat="server" BoxLabel="<%$ Resources:PanelOrderType.orderTypeWin.rbPersonalWin.BoxLabel %>" Checked="false" />
                                                                        <ext:Radio ID="rbHospitalWin" runat="server" BoxLabel="<%$ Resources:PanelOrderType.orderTypeWin.rbHospitalWin.BoxLabel %>" Checked="true" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </ext:Anchor>
                                                            --%>
                                                            <%-- 销售单类型显示 --%>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtShipmentOrderTypeWin" runat="server" FieldLabel="单据类型" ReadOnly="true" Width="90" FieldClass="textFieldReadonly" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>

                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:Panel ID="Panel11" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="60">

                                                            <%--产品线--%>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbProductLineWin" runat="server" Width="200" Editable="false" TypeAhead="true" StoreID="ProductLineWinStore" ValueField="Id" DisplayField="AttributeName"
                                                                    FieldLabel="<font color='red'><b>产品线</b></font>" ListWidth="300" Resizable="true" AllowBlank="false"
                                                                    BlankText="<%$ Resources: Panel7.FormLayout4.cbProductLineWin.BlankText %>" EmptyText="<%$ Resources: Panel7.FormLayout4.cbProductLineWin.EmptyText %>">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel7.FormLayout4.cbProductLineWin.FieldTrigger.Qtip %>" HideTrigger="true" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <Select Handler="ChangeProductLine();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>

                                                            <ext:Anchor>
                                                                <ext:Checkbox ID="cbIsAuthWin" FieldLabel="所有医院" runat="server" Hidden="true">
                                                                    <Listeners>
                                                                        <Check Handler="#{GridPanel2}.clear();Coolite.AjaxMethods.ReLoadHositalStore()" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </ext:Anchor>
                                                            <%-- 用量日期 --%>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtShipmentDateWin" runat="server" ReadOnly="true" Width="200" FieldLabel="<font color='red'><b>用量日期</b></font>">
                                                                    <Listeners>
                                                                        <Select Handler="ChangeShipmentDate();" />
                                                                    </Listeners>
                                                                </ext:DateField>
                                                            </ext:Anchor>
                                                            <%--销售医院--%>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbHospitalWin" runat="server" Width="200" Editable="true" TypeAhead="true" ForceSelection="true" TriggerAction="All" StoreID="HospitalWinStore" ValueField="Id" DisplayField="Name"
                                                                    FieldLabel="<font color='red'><b>销售医院</b></font>"
                                                                    AllowBlank="false" BlankText="<%$ Resources:Panel8.FormLayout5.cbHospitalWin.BlankText %>" EmptyText="<%$ Resources:Panel8.FormLayout5.cbHospitalWin.EmptyText %>" Resizable="true" ListWidth="300" Mode="Local" SelectOnFocus="true" ItemSelector="div.list-item">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:Panel8.FormLayout5.cbHospitalWin.FieldTrigger.Qtip %>" HideTrigger="true" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <Select Handler="ChangeHospital();" />
                                                                    </Listeners>
                                                                    <Template ID="Template1" runat="server">
                                                                    <tpl for=".">
                                                                        <div class="list-item">
                                                                             <h3>{Name}</h3>
                                                                             <h2>　{ShortName}</h2>
                                                                        </div>
                                                                    </tpl>
                                                                    </Template>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Button ID="BtnReason" runat="server" Text="授权产品线无法选择的原因" IDMode="Legacy" Hidden="true" Icon="Information" Width="200">
                                                                    <AjaxEvents>
                                                                        <Click OnEvent="ShowReason">
                                                                        </Click>
                                                                    </AjaxEvents>
                                                                </ext:Button>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="60">
                                                            <%-- 发票号码 --%>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtInvoice" runat="server" FieldLabel="<%$ Resources:Panel12.FormLayout6.txtInvoiceNumber.FieldLabel%>" Width="200" />
                                                            </ext:Anchor>

                                                            <%-- 发票日期 --%>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtInvoiceDateWin" runat="server" FieldLabel="<%$ Resources:txtInvoiceDate.FieldLabel%>" Width="200" />
                                                            </ext:Anchor>

                                                            <%-- 发票Title --%>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtInvoiceTitleWin" runat="server" FieldLabel="<%$ Resources:Panel12.FormLayout6.txtInvoiceTitle.FieldLabel%>" Width="200" />
                                                            </ext:Anchor>

                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".34">
                                                <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="60">


                                                            <%-- 销售单号 --%>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtOrderNumberWin" runat="server" FieldLabel="销售单号" Width="200" FieldClass="textFieldReadonly" />
                                                            </ext:Anchor>

                                                            <%-- 订单状态 --%>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtOrderStatusWin" runat="server" FieldLabel="单据状态" Width="200" FieldClass="textFieldReadonly" />
                                                            </ext:Anchor>

                                                            <%-- 科室 --%>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtOfficeWin" runat="server" FieldLabel="<%$ Resources:Panel12.FormLayout6.txtOffice.FieldLabel%>" Width="200" Hidden="true" />
                                                            </ext:Anchor>
                                                            <%-- 备注 --%>
                                                            <ext:Anchor>
                                                                <ext:TextArea ID="txtMemoWin" runat="server" FieldLabel="单据备注" Width="200" Height="40" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                                <%-- 
                                <ext:Panel ID="Panel13" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                            <ext:LayoutColumn ColumnWidth="0.39">
                                                <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                                    <Body>

                                                        <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="70">
                                                            
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth="0.37 ">
                                                <ext:Panel ID="PanelOrderType" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="formLayoutOrderType" runat="server" LabelAlign="Left" LabelWidth="60">
                                                            

                                                            
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".24">
                                                <ext:Panel ID="Panel15" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="formLayout9" runat="server" LabelAlign="Left" LabelWidth="70">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtTotalQty" runat="server" FieldLabel="<%$ Resources:PanelOrderType.txtTotalQty.FieldLabel %>" ReadOnly="true" Width="80" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtTotalAmount" runat="server" FieldLabel="<%$ Resources:PanelOrderType.txtTotalAmount.FieldLabel %>" ReadOnly="true" Width="80" />
                                                            </ext:Anchor>
                                                            
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                                --%>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                            <Tabs>
                                <ext:Tab ID="TabSearch" runat="server" Title="<%$ Resources:TabPanel1.TabSearch.Text%>" ActiveIndex="1" AutoShow="true">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout2" runat="server">
                                            <ext:GridPanel ID="GridPanel2" runat="server" Title="<%$ Resources:GridPanel2.TabSearchResult.Text%>" StoreID="DetailStore" Border="false" Icon="Lorry" AutoWidth="true" ClicksToEdit="1" EnableHdMenu="false" StripeRows="true" Header="false" AutoExpandColumn="WarehouseName">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar1" runat="server">
                                                        <Items>
                                                            <ext:Label ID="lbGP2SumQty" runat="server" Text="" Icon="Sum" />
                                                            <ext:Label ID="Label3" runat="server" Text="" />
                                                            <ext:Label ID="lbGP2SumPrice" runat="server" Text="" Icon="Sum" />
                                                        </Items>
                                                        <Items>
                                                            <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                            <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources:GridPanel2.AddItemsButton.Text %>" Icon="Add" StyleSpec="margin-right:15px">
                                                                <AjaxEvents>
                                                                    <Click OnEvent="ShowDialog" Failure="Ext.MessageBox.alert(MsgList.ShowDialog.FailureTitle, MsgList.ShowDialog.FailureMsg);">
                                                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{DetailWindow}.body}" />
                                                                        <ExtraParams>
                                                                            <ext:Parameter Name="OrderId" Value="#{hiddenOrderId}.getValue()" Mode="Raw">
                                                                            </ext:Parameter>
                                                                            <ext:Parameter Name="DealerWarehouseType" Value="#{txtShipmentOrderTypeWin}.getValue()" Mode="Raw">
                                                                            </ext:Parameter>
                                                                            <ext:Parameter Name="ShipmentDate" Value="#{txtShipmentDateWin}.getValue()" Mode="Raw">
                                                                            </ext:Parameter>
                                                                        </ExtraParams>
                                                                    </Click>
                                                                </AjaxEvents>
                                                            </ext:Button>
                                                            <ext:Button ID="btnShowAdminShipment" runat="server" Text="<%$ Resources:GridPanel2.AddItemsButton.Text %>" Icon="Add" StyleSpec="margin-right:15px" Hidden="true">
                                                                <AjaxEvents>
                                                                    <Click OnEvent="ShowAdminShipmentDialog"
                                                                        Failure="Ext.MessageBox.alert(MsgList.ShowDialog.FailureTitle, MsgList.ShowDialog.FailureMsg);"
                                                                        Success="#{ShipmentAdjustWindow}.show();#{gpHistoryShipment}.reload();#{gpInventory}.reload();">
                                                                        <ExtraParams>
                                                                            <ext:Parameter Name="OrderId" Value="#{hiddenOrderId}.getValue()" Mode="Raw">
                                                                            </ext:Parameter>
                                                                            <ext:Parameter Name="DealerWarehouseType" Value="#{txtShipmentOrderTypeWin}.getValue()" Mode="Raw">
                                                                            </ext:Parameter>
                                                                            <ext:Parameter Name="ShipmentDate" Value="#{txtShipmentDateWin}.getValue()" Mode="Raw">
                                                                            </ext:Parameter>
                                                                        </ExtraParams>
                                                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{DetailWindow}.body}" />
                                                                    </Click>
                                                                </AjaxEvents>
                                                            </ext:Button>
                                                        </Items>
                                                    </ext:Toolbar>
                                                </TopBar>
                                                <ColumnModel ID="ColumnModel2" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="分仓库" Width="180">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CFN" DataIndex="CFN" Header="产品型号" Width="90">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CFNEnName" DataIndex="CFNEnName" Header="产品英文名" Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UPN" DataIndex="UPN" Header="产品UPN">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="序号/批号" Width="80">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Width="80">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="产品有效期" Width="80">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="单位" Width="40">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ConvertFactor" DataIndex="ConvertFactor" Header="系数" Width="40">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="库存量" Width="70" Align="Right">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UnitPrice" DataIndex="UnitPrice" Header="单价" Width="60" Align="Right">
                                                            <Editor>
                                                                <ext:NumberField ID="txtUnitPrice" runat="server" AllowBlank="false" DecimalPrecision="2" AllowDecimals="true" SelectOnFocus="true" AllowNegative="false">
                                                                </ext:NumberField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="AdjAction" DataIndex="AdjAction" Header="采购价" Width="60" Align="Right">
                                                            <Editor>
                                                                <ext:NumberField ID="txtAdjAction" runat="server" AllowBlank="false" DecimalPrecision="2" AllowDecimals="true" SelectOnFocus="true" AllowNegative="false">
                                                                </ext:NumberField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ShipmentQty" DataIndex="ShipmentQty" Header="销售量" Width="70" Align="Right">
                                                            <Editor>
                                                                <ext:NumberField ID="txtShipmentQty" runat="server" AllowBlank="false" AllowDecimals="true" SelectOnFocus="true" AllowNegative="true">
                                                                </ext:NumberField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ShipmentDate" DataIndex="ShipmentDate" Header="实际用量日期" Width="120" Align="Right">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y/m/d')" />
                                                            <Editor>
                                                                <ext:DateField ID="dtShipmentDate" runat="server" AllowBlank="false" SelectOnFocus="true" Format="Y-m-d">
                                                                </ext:DateField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="QRCodeEdit" DataIndex="QRCodeEdit" Header="二维码" Align="Center" Width="150">
                                                            <Editor>
                                                                <ext:TextField ID="txtQrCode" runat="server" AllowBlank="false" SelectOnFocus="true">
                                                                </ext:TextField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Remark" DataIndex="Remark" Header="备注" Width="100" Align="Right">
                                                            <Editor>
                                                                <ext:TextField ID="txtRemark" runat="server" AllowBlank="false" SelectOnFocus="true" MaxLength="100">
                                                                </ext:TextField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="IsCanOrder" DataIndex="IsCanOrder" Header="是否有效" Hidden="true">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CFN_Property6" DataIndex="CFN_Property6" Header="CFN_Property6" Hidden="true">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="PurchaseOrderNbr" DataIndex="PurchaseOrderNbr" Header="寄售申请单号"
                                                            Align="Center" Width="150">
                                                            <Editor>
                                                                <ext:ComboBox ID="cbCongisnmentOrderNbr" runat="server" Width="150" Editable="true" TypeAhead="true"
                                                                    Mode="Local" StoreID="CongisnmentOrderStore" ValueField="Id" DisplayField="PurchaseOrderNbr"
                                                                    AllowBlank="false" ListWidth="300" Resizable="true">
                                                                </ext:ComboBox>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="40" Header="<%$ Resources:GridPanel2.ColumnModel2.CommandColumn.Header %>" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources:GridPanel2.ColumnModel2.GridCommand.ToolTip-Text %>" />
                                                                <%--                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit" ToolTip-Text="Edit" />--%>
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                        <ext:CommandColumn Width="50" Header="<%$ Resources:GridPanel2.ColumnModel2.CommandColumn.Header1 %>" Align="Center" Hidden="true">
                                                            <Commands>
                                                                <ext:GridCommand Icon="VcardEdit" CommandName="Implant" />
                                                            </Commands>
                                                            <PrepareToolbar Fn="prepare" />
                                                        </ext:CommandColumn>
                                                        <ext:Column ColumnID="QRCheck" DataIndex="QRCheck" Header="二维码发票认证" Align="Center" Width="120">
                                                            <Renderer Fn="qrcheckChange" />
                                                        </ext:Column>
                                                    </Columns>
                                                </ColumnModel>
                                                <View>
                                                    <ext:GridView ID="GridView3" runat="server">
                                                        <GetRowClass Fn="getErrorRowClass" />
                                                    </ext:GridView>
                                                </View>

                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <%--<BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="DetailStore" DisplayInfo="false" />
                                                </BottomBar>--%>
                                                <SaveMask ShowMask="true" Msg="<%$ Resources:GridPanel2.SaveMask.Msg %>" />
                                                <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel2.LoadMask.Msg %>" />
                                                <Listeners>
                                                    <ValidateEdit Fn="CheckQty" />
                                                    <Command Handler="
                                            if (command == 'Delete'){
                                                Ext.Msg.confirm(MsgList.DeleteItem.ConfirmTitle, MsgList.DeleteItem.ConfirmMsg,
                                                    function(e) {
                                                        if (e == 'yes') {
                                                            Coolite.AjaxMethods.DeleteItem({failure: function(err) {Ext.Msg.alert(MsgList.DeleteItem.FailureTitle, err);}});
                                                        }
                                                    });
                                            }else if(command == 'Edit'){
                                                Coolite.AjaxMethods.EditItem(this.getSelectionModel().getSelected().id);
                                            }else if(command == 'Implant'){
                                                ShowImplantInfoWindow(this.getSelectionModel().getSelected().id);
                                            }" />

                                                    <%--将当前编辑行Id保存下来 --%>
                                                    <BeforeEdit Handler="#{hiddenCurrentEditShipmentId}.setValue(this.getSelectionModel().getSelected().id);
                                                            #{txtShipmentQty}.setValue(this.getSelectionModel().getSelected().data.ShipmentQty);
                                                            #{txtUnitPrice}.setValue(this.getSelectionModel().getSelected().data.UnitPrice);
                                                            #{txtAdjAction}.setValue(this.getSelectionModel().getSelected().data.AdjAction);
                                                            #{dtShipmentDate}.setValue(this.getSelectionModel().getSelected().data.ShipmentDate);
                                                            #{txtRemark}.setValue(this.getSelectionModel().getSelected().data.Remark);
                                                            #{hiddenCFN}.setValue(this.getSelectionModel().getSelected().data.CFN);
                                                            #{hiddenLotNumber}.setValue(this.getSelectionModel().getSelected().data.LotNumber);
                                                            #{hiddenQrCode}.setValue(this.getSelectionModel().getSelected().data.QRCode);
                                                            #{txtQrCode}.setValue(this.getSelectionModel().getSelected().data.QRCodeEdit);
                                                            #{hiddenLotNumberCode}.setValue(this.getSelectionModel().getSelected().data.LotNumber);
                                                           
                                                            if(this.getSelectionModel().getSelected().data.QRCode!='NoQR')
                                                            {
                                                             #{txtQrCode}.setDisabled(true);
                                                            }
                                                            else{
                                                            #{txtQrCode}.setDisabled(false);
                                                            }
                                                            #{CongisnmentOrderStore}.reload();
                                                            #{cbCongisnmentOrderNbr}.setValue(this.getSelectionModel().getSelected().data.PurchaseOrderNbr);
                                                           " />
                                                    <AfterEdit Handler="#{hiddenIsEditting}.setValue('');" />
                                                    <%-- <AfterEdit Handler="
                                            Coolite.AjaxMethods.SaveItem(#{txtShipmentQty}.getValue(),#{txtUnitPrice}.getValue(),#{dtShipmentDate}.getValue(),#{txtRemark}.getValue(),#{cbCongisnmentOrderNbr}.getValue(),#{hiddenQrCode}.getValue(),#{txtQrCode}.getValue(), #{hiddenLotNumberCode}.getValue(),#{txtAdjAction}.getValue(),{success:function(){#{hiddenIsEditting}.setValue('');},failure: function(err) {Ext.Msg.alert(MsgList.AfterEdit.FailureTitle, err);}});" 
                                                        />--%>
                                                </Listeners>
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>


                                <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources:TabLog.Text%>" AutoScroll="true">
                                    <Body>
                                        <ext:FitLayout ID="FT2" runat="server">
                                            <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources:TabLog.gpLog.Text%>" StoreID="OrderLogStore" AutoWidth="true" StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" Header="false" AutoExpandColumn="OperUserId">
                                                <ColumnModel ID="ColumnModel3" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="<%$ Resources:TabLog.OperUserId.Text%>" Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources:TabLog.OperUserName.Text%>" Width="170">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="<%$ Resources:TabLog.OperTypeName.Text%>" Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="<%$ Resources:TabLog.OperDate.Text%>" Width="150">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources:TabLog.OperNote.Text%>" Width="200">
                                                        </ext:Column>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server" MoveEditorOnEnter="true">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBarLog" runat="server" PageSize="10" StoreID="OrderLogStore" DisplayInfo="false" />
                                                </BottomBar>
                                                <SaveMask ShowMask="false" />
                                                <LoadMask ShowMask="true" />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                                <ext:Tab ID="TabAttachment" runat="server" Title="附件" Icon="BrickLink" AutoScroll="true">
                                    <Body>
                                        <ext:FitLayout ID="FTAttachement" runat="server">
                                            <ext:GridPanel ID="gpAttachment" runat="server" Title="附件列表" StoreID="AttachmentStore" AutoWidth="true" StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" Header="false" AutoExpandColumn="Name">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar3" runat="server">
                                                        <Items>
                                                            <ext:ToolbarFill ID="ToolbarFill3" runat="server" />
                                                            <ext:Button ID="btnAddAttach" runat="server" Text="添加附件" Icon="Add" StyleSpec="margin-right:15px">
                                                                <%--<Listeners>
                                                                <Click Handler="AttachmentWindow.show();" />
                                                            </Listeners>--%>
                                                                <AjaxEvents>
                                                                    <Click OnEvent="ShowAttachmentWindow">
                                                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{DetailWindow}.body}" />
                                                                    </Click>
                                                                </AjaxEvents>
                                                            </ext:Button>
                                                        </Items>
                                                    </ext:Toolbar>
                                                </TopBar>
                                                <ColumnModel ID="ColumnModel5" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="MainId" DataIndex="MainId" Hidden="true">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Name" DataIndex="Name" Header="附件名称">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Url" DataIndex="Url" Header="路径" Hidden="true" Width="200">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="上传人" Width="200">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="上传时间" Width="100">
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad" ToolTip-Text="下载" />
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                        <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel5" SingleSelect="true" runat="server">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBarAttachement" runat="server" PageSize="100" StoreID="AttachmentStore" DisplayInfo="false" />
                                                </BottomBar>
                                                <SaveMask ShowMask="true" />
                                                <LoadMask ShowMask="true" Msg="处理中……" />
                                                <Listeners>
                                                    <Command Handler="if (command == 'Delete'){
                                                                            if( record.data.IsCurrent == '1'){
                                                                                Ext.Msg.confirm('警告', '是否要删除该附件文件?',
                                                                                    function(e) {
                                                                                        if (e == 'yes') {
                                                                                            Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                                success: function() {
                                                                                                    Ext.Msg.alert('Message', '删除附件成功！');
                                                                                                    #{gpAttachment}.reload();
                                                                                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                        }
                                                                                    });
                                                                                    
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        Ext.Msg.alert('警告', '非当天上传文件，不允许删除');
                                                                                    }
                                                                            }
                                                                            else if (command == 'DownLoad')
                                                                            {
                                                                                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=ShipmentToHospital';
                                                                                downloadfile(url);                                                                                
                                                                            }
                                                                            
                                                                            " />
                                                </Listeners>
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                    <Listeners>
                                        <Activate Handler="Coolite.AjaxMethods.InitBtnAddAttach();" />
                                    </Listeners>
                                </ext:Tab>
                            </Tabs>
                        </ext:TabPanel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <%--<ext:Button ID="BaoTaiButton" runat="server" Text="<%$ Resources:DetailWindow.BaoTaiButton.Text %>" Icon="NoteEdit">
                    <Listeners>
                        <Click Handler="ShowShipmentOperationPage();" />
                    </Listeners>
                </ext:Button>--%>
                <ext:Button ID="DraftButton" runat="server" Text="<%$ Resources:DetailWindow.DraftButton.Text %>" Icon="Add">
                    <Listeners>
                        <Click Handler="CheckDraft(#{GridPanel2});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="DeleteButton" runat="server" Text="<%$ Resources:DetailWindow.DeleteButton.Text %>" Icon="Delete">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.DeleteDraft({
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                                
                            },
                            failure: function(err) {
                                Ext.Msg.alert(MsgList.DeleteButton.FailureTitle, err);
                            }
                        });" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="SubmitButton" runat="server" Text="下一步" Icon="LorryAdd">
                    <Listeners>
                        <Click Handler="CheckSubmit();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="RevokeButton" runat="server" Text="<%$ Resources:DetailWindow.RevokeButton.Text %>" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{RevokeButton}.setDisabled(true);Coolite.AjaxMethods.DoRevoke({
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                                
                            },
                            failure: function(err) {
                                Ext.Msg.alert(MsgList.RevokeButton.FailureTitle, err);
                            }
                        });" />
                    </Listeners>
                </ext:Button>

                <ext:Button ID="PriceButton" runat="server" Text="修改价格" Icon="PageEdit">
                    <Listeners>
                        <Click Handler="#{OrderPriceGridPanel}.store.reload(); #{UpdateOrderPriceWindow}.show(); " />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Fn="CheckMod" />
                <Hide Handler="#{GridPanel2}.clear();" />
            </Listeners>
        </ext:Window>
        <ext:Hidden ID="hiddenFileName" runat="server">
        </ext:Hidden>
        <ext:Window ID="AttachmentWindow" runat="server" Icon="Group" Title="上传附件" Resizable="false" Header="false" Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Header="false" AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="50">
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择上传附件" FieldLabel="文件" ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="SaveButton" runat="server" Text="上传附件">
                            <AjaxEvents>
                                <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');"
                                    Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });"
                                    Success="#{gpAttachment}.reload();#{FileUploadField1}.setValue('')">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="ResetButton" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </Body>
            <Listeners>
                <Hide Handler="#{gpAttachment}.reload();" />
                <BeforeShow Handler="#{FileUploadField1}.setValue('');" />
            </Listeners>
        </ext:Window>

        <ext:Store ID="ShipmentAdjustLotForShipmentStore" runat="server" OnRefreshData="ShipmentAdjustLotForShipmentStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="DealerCode" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="WarehouseCode" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="ShipmentQty" />
                        <ext:RecordField Name="ShipmentNbr" />
                        <ext:RecordField Name="SubmitDate" />
                        <ext:RecordField Name="ShipmentDate" />
                        <ext:RecordField Name="UPN" />
                        <ext:RecordField Name="UPN2" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="QRCode" />
                        <ext:RecordField Name="UOM" />
                        <ext:RecordField Name="ShipmentQty" />
                        <ext:RecordField Name="ShipmentPrice" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="ProductCnName" />
                        <ext:RecordField Name="ProductEnName" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="ActualShipmentDate" />
                        <ext:RecordField Name="NewSltId" />
                        <ext:RecordField Name="ConfirmPrice" />
                        <ext:RecordField Name="LotId" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert(MsgList.DetailStore.LoadExceptionTitle, e.message || response.statusText);" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="ShipmentAdjustLotForInventoryStore" runat="server" OnRefreshData="ShipmentAdjustLotForInventoryStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="DealerCode" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="WarehouseCode" />
                        <ext:RecordField Name="UPN" />
                        <ext:RecordField Name="UPN2" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="QRCode" />
                        <ext:RecordField Name="UOM" />
                        <ext:RecordField Name="TotalQty" />
                        <ext:RecordField Name="ShipmentQty" />
                        <ext:RecordField Name="ShipmentPrice" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="ProductCnName" />
                        <ext:RecordField Name="ProductEnName" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="ActualShipmentDate" />
                        <ext:RecordField Name="NewSltId" />
                        <ext:RecordField Name="ConfirmPrice" />
                        <ext:RecordField Name="LotId" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert(MsgList.DetailStore.LoadExceptionTitle, e.message || response.statusText);" />
            </Listeners>
        </ext:Store>
        <ext:Window ID="ShipmentAdjustWindow" runat="server" Icon="Group" Title="销售调整"
            Width="980" Height="460" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Y="10" Maximizable="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout3" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel10" runat="server" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Information">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".36">
                                        <ext:Panel ID="Panel12" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="70">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfDealerForAdmin" runat="server" FieldLabel="经销商" Width="150" ReadOnly="true"></ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfHospitalForAdmin" runat="server" FieldLabel="销售医院" Width="150" ReadOnly="true"></ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".32">
                                        <ext:Panel ID="Panel16" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout11" runat="server" LabelAlign="Left" LabelWidth="70">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfProductLineForAdmin" runat="server" FieldLabel="产品线" Width="100" ReadOnly="true"></ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbReasonForAdmin" runat="server" EmptyText="请选择..." Width="100" TypeAhead="true" ListWidth="300" Resizable="true" FieldLabel="调整原因">
                                                            <Items>
                                                                <ext:ListItem Text="经销商调整数据" Value="经销商调整数据" />
                                                                <ext:ListItem Text="医院调整数据" Value="医院调整数据" />
                                                                <ext:ListItem Text="审计调整（仅管理员操作）" Value="审计调整" />
                                                                <ext:ListItem Text="系统调整（仅管理员操作）" Value="系统调整" />
                                                                <ext:ListItem Text="其他调整（仅管理员操作）" Value="其他调整" />
                                                            </Items>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".32">
                                        <ext:Panel ID="Panel17" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout12" runat="server" LabelAlign="Left" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfShipmentDateForAdmin" runat="server" FieldLabel="用量日期" Width="100" ReadOnly="true"></ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Checkbox ID="cbUpnFlag" runat="server" FieldLabel="Upn是否相同" Hidden="true"></ext:Checkbox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="dtShipmentDateForAdjust" runat="server" FieldLabel="实际用量日期" Width="100"></ext:DateField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel18" runat="server" Header="false" Height="820" AutoScroll="true">
                            <Body>
                                <ext:FormLayout ID="FormLayout13" runat="server" LabelAlign="Left">
                                    <ext:Anchor>
                                        <ext:GridPanel ID="gpHistoryShipment" runat="server" Title="历史销售明细数据" StoreID="ShipmentAdjustLotForShipmentStore" Border="true"
                                            Icon="Lorry" AutoWidth="true" AutoExpandColumn="WarehouseName" Height="250" ClicksToEdit="1" EnableHdMenu="false" StripeRows="true" Header="false">
                                            <TopBar>
                                                <ext:Toolbar ID="Toolbar4" runat="server">
                                                    <Items>
                                                        <ext:ToolbarFill ID="ToolbarFill4" runat="server" />
                                                        <ext:Button ID="btnAddHistoryShipment" runat="server" Text="添加历史销售数据" Icon="Add" StyleSpec="margin-right:15px">
                                                            <AjaxEvents>
                                                                <Click OnEvent="ShowShipmentAdjustDialog" Failure="Ext.MessageBox.alert(MsgList.ShowDialog.FailureTitle, MsgList.ShowDialog.FailureMsg);">
                                                                    <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{ShipmentAdjustWindow}.body}" />
                                                                    <ExtraParams>
                                                                        <ext:Parameter Name="OrderId" Value="#{hiddenOrderId}.getValue()" Mode="Raw">
                                                                        </ext:Parameter>
                                                                        <ext:Parameter Name="DealerWarehouseType" Value="#{txtShipmentOrderTypeWin}.getValue()" Mode="Raw">
                                                                        </ext:Parameter>
                                                                        <ext:Parameter Name="ShipmentDate" Value="#{txtShipmentDateWin}.getValue()" Mode="Raw">
                                                                        </ext:Parameter>
                                                                        <ext:Parameter Name="DialogType" Value="Shipment" Mode="Value">
                                                                        </ext:Parameter>
                                                                    </ExtraParams>
                                                                </Click>
                                                            </AjaxEvents>
                                                        </ext:Button>
                                                    </Items>
                                                </ext:Toolbar>
                                            </TopBar>
                                            <ColumnModel ID="ColumnModel6" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="120">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="仓库">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ShipmentNbr" DataIndex="ShipmentNbr" Header="销售单号" Width="120">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="销售医院" Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="SubmitDate" DataIndex="SubmitDate" Header="提交日期" Width="90" Hidden="true">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ShipmentDate" DataIndex="ShipmentDate" Header="用量日期" Width="90">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UPN" DataIndex="UPN" Header="产品型号" Width="90">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UPN2" DataIndex="UPN2" Header="短编号" Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ProductCnName" DataIndex="ProductCnName" Header="产品中文名" Width="90">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="序列号\批号" Width="90">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Width="90">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="有效期" Width="90">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ShipmentQty" DataIndex="ShipmentQty" Header="销售数量" Width="90">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ShipmentPrice" DataIndex="ShipmentPrice" Header="销售单价" Width="90">
                                                        <Editor>
                                                            <ext:NumberField ID="nfShipmentPriceForShipment" runat="server" AllowBlank="false" DecimalPrecision="2" AllowDecimals="true" SelectOnFocus="true" AllowNegative="false">
                                                            </ext:NumberField>
                                                        </Editor>
                                                        <Renderer Fn="SetCellCssEditable" />
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="40" Header="删除" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel6" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <Listeners>
                                                <ValidateEdit Fn="CheckAdjustQtyForShipment" />
                                                <Command Handler="Coolite.AjaxMethods.DeleteAdjustItem(record.data.Id,record.data.LotId,{success:function(){#{gpHistoryShipment}.reload();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                <BeforeEdit
                                                    Handler="#{hiddenCurrentEditShipmentId}.setValue(this.getSelectionModel().getSelected().id);
                                                            #{nfShipmentPriceForShipment}.setValue(this.getSelectionModel().getSelected().data.ShipmentPrice);" />
                                                <AfterEdit Handler="Coolite.AjaxMethods.SaveAdjustItemForShipment(#{nfShipmentPriceForShipment}.getValue(),{success:function(){#{hiddenCurrentEditShipmentId}.setValue('');#{hiddenIsEditting}.setValue('');},failure: function(err) {Ext.Msg.alert(MsgList.AfterEdit.FailureTitle, err);}});" />
                                            </Listeners>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" />
                                        </ext:GridPanel>
                                    </ext:Anchor>
                                    <ext:Anchor>
                                        <ext:GridPanel ID="gpInventory" runat="server" Title="库存数据" StoreID="ShipmentAdjustLotForInventoryStore" Border="true"
                                            Icon="Lorry" AutoWidth="true" Height="250" AutoExpandColumn="WarehouseName" ClicksToEdit="1" EnableHdMenu="false" StripeRows="true" Header="false">
                                            <TopBar>
                                                <ext:Toolbar ID="Toolbar5" runat="server">
                                                    <Items>
                                                        <ext:ToolbarFill ID="ToolbarFill5" runat="server" />
                                                        <ext:Button ID="btnAddInventory" runat="server" Text="添加库存" Icon="Add" StyleSpec="margin-right:15px">
                                                            <AjaxEvents>
                                                                <Click OnEvent="ShowShipmentAdjustDialog" Failure="Ext.MessageBox.alert(MsgList.ShowDialog.FailureTitle, MsgList.ShowDialog.FailureMsg);">
                                                                    <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{ShipmentAdjustWindow}.body}" />
                                                                    <ExtraParams>
                                                                        <ext:Parameter Name="OrderId" Value="#{hiddenOrderId}.getValue()" Mode="Raw">
                                                                        </ext:Parameter>
                                                                        <ext:Parameter Name="DealerWarehouseType" Value="#{txtShipmentOrderTypeWin}.getValue()" Mode="Raw">
                                                                        </ext:Parameter>
                                                                        <ext:Parameter Name="ShipmentDate" Value="#{txtShipmentDateWin}.getValue()" Mode="Raw">
                                                                        </ext:Parameter>
                                                                        <ext:Parameter Name="DialogType" Value="Inventory" Mode="Value">
                                                                        </ext:Parameter>
                                                                    </ExtraParams>
                                                                </Click>
                                                            </AjaxEvents>
                                                        </ext:Button>
                                                    </Items>
                                                </ext:Toolbar>
                                            </TopBar>
                                            <ColumnModel ID="ColumnModel7" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="仓库">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UPN" DataIndex="UPN" Header="产品型号" Width="90">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UPN2" DataIndex="UPN2" Header="短编号" Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ProductCnName" DataIndex="ProductCnName" Header="产品中文名" Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="序列号\批号" Width="90">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Width="90">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="有效期" Width="90">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="库存数量" Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ShipmentQty" DataIndex="ShipmentQty" Header="销售数量" Width="70" Align="Right">
                                                        <Editor>
                                                            <ext:NumberField ID="nfShipmentQtyForInv" runat="server" AllowBlank="false" DecimalPrecision="2" AllowDecimals="true" SelectOnFocus="true" AllowNegative="false">
                                                            </ext:NumberField>
                                                        </Editor>
                                                        <Renderer Fn="SetCellCssEditable" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ShipmentPrice" DataIndex="ShipmentPrice" Header="销售单价" Width="75" Align="Right">
                                                        <Editor>
                                                            <ext:NumberField ID="nfShipmentPriceForInv" runat="server" AllowBlank="false" DecimalPrecision="2" AllowDecimals="true" SelectOnFocus="true" AllowNegative="false">
                                                            </ext:NumberField>
                                                        </Editor>
                                                        <Renderer Fn="SetCellCssEditable" />
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="40" Header="删除" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel7" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="Coolite.AjaxMethods.DeleteAdjustItem(record.data.Id,record.data.LotId,{success:function(){#{gpInventory}.reload();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                <ValidateEdit Fn="CheckAdjustQtyForInv" />
                                                <BeforeEdit
                                                    Handler="#{hiddenCurrentEditShipmentId}.setValue(this.getSelectionModel().getSelected().id);
                                                            #{nfShipmentQtyForInv}.setValue(this.getSelectionModel().getSelected().data.ShipmentQty);
                                                            #{nfShipmentPriceForInv}.setValue(this.getSelectionModel().getSelected().data.ShipmentPrice);" />
                                                <AfterEdit Handler="Coolite.AjaxMethods.SaveAdjustItemForInv(#{nfShipmentQtyForInv}.getValue(),#{nfShipmentPriceForInv}.getValue(),{success:function(){#{hiddenCurrentEditShipmentId}.setValue('');#{hiddenIsEditting}.setValue('');},failure: function(err) {Ext.Msg.alert(MsgList.AfterEdit.FailureTitle, err);}});" />
                                            </Listeners>
                                            <SaveMask ShowMask="true" Msg="保存中..." />
                                            <LoadMask ShowMask="true" Msg="加载中..." />
                                        </ext:GridPanel>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="btnAddForAdmin" Text="添加" runat="server" Icon="Add" IDMode="Legacy">
                    <Listeners>
                        <Click Handler="CheckAddForAdmin();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnReturnForAdmin" Text="返回" runat="server" Icon="Cancel" IDMode="Legacy">
                    <Listeners>
                        <Click Handler="#{ShipmentAdjustWindow}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <%--<Hide Handler="#{PagingToolBar2}.changePage(1);" />--%>
            </Listeners>
        </ext:Window>

        <ext:Store ID="ReasonStore" runat="server" UseIdConfirmation="false" OnRefreshData="ReasonStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="OrderNumber" />
                        <ext:RecordField Name="ProductLineName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Window ID="ReasonWindow" runat="server" Icon="Group" Title="产品线无法选择原因"
            Width="500" Height="300" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout4" runat="server">

                    <Center MarginsSummary="0 5 5 5">
                        <ext:TabPanel ID="TabPanel2" runat="server" ActiveTabIndex="0" Plain="true">
                            <Tabs>
                                <ext:Tab ID="TabReason" runat="server" Title="未上传附件单据"
                                    BodyStyle="padding: 0px;" AutoScroll="false">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout4" runat="server">
                                            <ext:GridPanel ID="GridPanel4" runat="server" Title="<%$ Resources:GridPanel2.Title %>"
                                                StoreID="ReasonStore" StripeRows="true" Border="false" Icon="Lorry"
                                                EnableHdMenu="false" Header="false" AutoExpandColumn="OrderNumber">
                                                <ColumnModel ID="ColumnModel8" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="<%$ Resources: Panel7.FormLayout4.cbProductLineWin.FieldLabel  %>"
                                                            Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OrderNumber" DataIndex="OrderNumber" Header="<%$ Resources:Panel1.FormLayout1.txtOrderNumber.FieldLabel %>"
                                                            Width="100">
                                                        </ext:Column>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel8" SingleSelect="true" runat="server">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="15" StoreID="ReasonStore"
                                                        DisplayInfo="true" />
                                                </BottomBar>
                                                <SaveMask ShowMask="true" Msg="<%$ Resources:GridPanel2.SaveMask.Msg %>" />
                                                <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel2.LoadMask.Msg %>" />
                                                <View>
                                                    <ext:GridView ID="GridView2" runat="server">
                                                        <GetRowClass Handler="" />
                                                    </ext:GridView>
                                                </View>
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                            </Tabs>
                        </ext:TabPanel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:Window>
        <ext:Window ID="ShipmentInvoiceUploadWindows" runat="server" Icon="Group" Title="发票批量上传"
            Width="890" Height="390" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
            <Body>
                <ext:FitLayout ID="flShipmentInvoiceUpload" runat="server">
                    <ext:Panel ID="plShipmentInvoiceUpload" runat="server" AutoScroll="true" BodyStyle="padding:10px;">
                        <Body>
                            <table cellpadding="5">
                                <tr>
                                    <td style="padding: 5px;"><span id="spanButtonPlaceHolder"></span></td>
                                    <td style="padding: 5px;"><span class="btn_upload" onclick='shipmentInvoiceStartUpload();'>
                                        <img src="/resources/swfupload/images/swfBnt_upload.png" /></span></td>
                                    <td style="padding: 5px;"><span class="btn_upload" onclick='shipmentInvoideUploadReset();'>
                                        <img src="/resources/swfupload/images/swfBnt_reset.png" /></span>
                                    </td>
                                    <td style="padding: 5px;"><span class="btn_upload" onclick='shipmentInvoideUploadHelp();'>
                                        <img src="/resources/swfupload/images/swfBnt_help.png" /></span>
                                    </td>
                                  <td style="padding: 5px;">
                                        <div id="nameTip" class="onShow">最多上传<font color="red"> 50</font> 个附件,单文件最大 <font color="red">20MB （同时请确保附件文件名与发票号一致！）
                                            请确保按照发票上传要求拍摄发票照片</font></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5" style="padding: 5px;">支持 *.*格式。&nbsp;&nbsp;&nbsp;<span id="spanUploadListDesc">共计 <span id="spanUploadTotalDesc" style="color: red">0</span> 个，成功上传 <span id="spanUploadSuccessDesc" style="color: red">0</span> 个，未上传 <span id="spanUploadFailureDesc" style="color: red">0</span> 个。</span></td>
                                </tr>
                            </table>
                            <div class="uploadbox" style="float: left;">
                                <span class="uploadbox_t">上传列表</span>
                                <div id="divprogresscontainer"></div>
                                <div id="divprogressGroup"></div>
                                <div id="piclist">
                                    <ul>
                                    </ul>
                                </div>
                            </div>
                            <div class="uploaderrorbox" style="float: left; margin-left: 10px;">
                                <span class="uploadbox_t">未成功上传列表</span>
                                <div id="divUploadErrorlist"></div>
                            </div>
                        </Body>
                    </ext:Panel>
                </ext:FitLayout>
            </Body>
        </ext:Window>
        <ext:Window ID="InvoiceHelpWindows" runat="server" Icon="Help" Title="发票上传帮助"
            Width="650" Height="580" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
            <Body>
                <ext:FitLayout ID="FitLayout7" runat="server">
                    <ext:Panel ID="Panel15" runat="server" AutoScroll="true" BodyStyle="padding:10px;">
                        <Body>
                            <div style="padding: 5px; font-size: 14px; font-family: 微软雅黑; color: #0D0D0D; line-height: 22px;">
                                <p>
                                    <span style="">对于请求识别的增值税发票图片，推荐尺寸为<b>最短边高于1200像素</b>，保证图像质量，可以有效提高识别率。</span>
                                </p>
                                <p>
                                    <br />
                                </p>
                                <p>
                                    <span>增值税发票识别拍摄技巧，说明如下：</span>
                                </p>
                                <p>
                                    <span>1.请保证光线充足，增值税发票上不要有阴影和反光；</span>
                                </p>
                                <p>
                                    <span>2.请让增值税发票图片区域尽量充满整个拍摄预览区域，最好不低于80%的面积；</span>
                                </p>
                                <p>
                                    <span>3.请对焦清晰后再进行拍摄；</span>
                                </p>
                                <p>
                                    <span>4.请横屏拍摄；</span>
                                </p>
                                <p>
                                    <br />
                                </p>
                                <p>
                                    <span>拍摄示例如下：</span>
                                </p>
                            </div>
                            <div>
                                <p>
                                    <span style="font-family: 微软雅黑; color: #0D0D0D">
                                        <img width="434" height="247" src="../../resources/images/InvoiceHelp.png" alt="InvoiceHelp" /></span>
                                </p>
                            </div>
                        </Body>
                    </ext:Panel>
                </ext:FitLayout>
            </Body>
        </ext:Window>

        <ext:Store ID="InvoiceUploadStore" runat="server" OnRefreshData="InvoiceUploadStore_RefershData"
            AutoLoad="false" WarningOnDirty="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="ShipmentNbr" />
                        <ext:RecordField Name="InvoiceNo" />
                        <ext:RecordField Name="IsError" />
                        <ext:RecordField Name="ErrorMsg" />
                        <ext:RecordField Name="LineNbr" />
                        <ext:RecordField Name="ImportUser" />
                        <ext:RecordField Name="ImportDate" />
                        <ext:RecordField Name="SphId" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Window ID="InvoiceUploadWindows" runat="server" Icon="Group" Title="发票号批量上传" AutoScroll="true"
            Width="660" Height="390" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout5" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="InvoiceForm" runat="server" Width="500" Frame="true" Header="false" AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                            <Defaults>
                                <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                            </Defaults>
                            <Body>
                                <ext:FormLayout ID="FormLayout14" runat="server" LabelWidth="50">
                                    <ext:Anchor>
                                        <ext:FileUploadField ID="fufShipmentInvoice" runat="server" EmptyText="选择导入文件(Excel格式)" FieldLabel="文件" ButtonText="" Icon="ImageAdd">
                                        </ext:FileUploadField>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                            <Listeners>
                                <ClientValidation Handler="#{btnInvoiceSave}.setDisabled(!valid);" />
                            </Listeners>
                            <Buttons>
                                <ext:Button ID="btnInvoiceSave" runat="server" Text="上传附件">
                                    <AjaxEvents>
                                        <Click OnEvent="UploadInvoiceClick" Before="if(!#{InvoiceForm}.getForm().isValid()) { return false; } 
                                                Ext.Msg.wait('正在上传附件...', '附件上传');"
                                            Failure="Ext.Msg.show({ 
                                                title   : '错误', 
                                                msg     : '上传中发生错误', 
                                                minWidth: 200, 
                                                modal   : true, 
                                                icon    : Ext.Msg.ERROR, 
                                                buttons : Ext.Msg.OK 
                                            });#{btnInvoiceImport}.setDisabled(true);"
                                            Success="#{PagingToolBar5}.changePage(1);">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnInvoiceReset" runat="server" Text="清除">
                                    <Listeners>
                                        <Click Handler="#{InvoiceForm}.getForm().reset();#{btnInvoiceSave}.setDisabled(true);#{btnInvoiceImport}.setDisabled(true);#{GridPanel5}.clear();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInvoiceImport" runat="server" Text="导入数据库" Disabled="true">
                                    <AjaxEvents>
                                        <Click OnEvent="UploadInvoiceConfirm" Success="#{InvoiceForm}.getForm().reset();#{btnInvoiceSave}.setDisabled(true);#{btnInvoiceImport}.setDisabled(true);#{GridPanel5}.clear();">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnInvoiceDownload" runat="server" Text="下载模板">
                                    <Listeners>
                                        <Click Handler="window.open('../../Upload/ExcelTemplate/Template_ShipmentInvoiceImport.xls')" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel19" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout5" runat="server">
                                    <ext:GridPanel ID="GridPanel5" runat="server" Title="销售单发票号导入"
                                        StoreID="InvoiceUploadStore" Border="false" Icon="Error" AutoWidth="true" StripeRows="true"
                                        EnableHdMenu="false">
                                        <ColumnModel ID="ColumnModel9" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="LineNbr" DataIndex="LineNbr" Header="行号" Sortable="false" Width="50">
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipmentNbr" DataIndex="ShipmentNbr" Header="销售单号" Sortable="false" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="InvoiceNo" DataIndex="InvoiceNo" Header="发票号" Sortable="false" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ErrorMsg" DataIndex="ErrorMsg" Header="错误信息" Sortable="false" Width="230">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <View>
                                            <ext:GridView ID="GridView1" runat="server">
                                                <GetRowClass Fn="getIsErrorInvoiceInitClass" />
                                            </ext:GridView>
                                        </View>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel9" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="false">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar5" runat="server" PageSize="100" StoreID="InvoiceUploadStore" DisplayInfo="false">
                                            </ext:PagingToolbar>
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="Loading..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Listeners>
                <BeforeShow Handler="#{InvoiceForm}.getForm().reset();#{btnInvoiceSave}.setDisabled(true);#{btnInvoiceImport}.setDisabled(true);#{GridPanel5}.clear();" />
            </Listeners>
        </ext:Window>

        <ext:Store ID="CheckSubmitResultStore" runat="server" OnRefreshData="CheckSubmitResultStore_RefershData" AutoLoad="false" WarningOnDirty="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="IdentityType" />
                        <ext:RecordField Name="IdentityCode" />
                        <ext:RecordField Name="SphId" />
                        <ext:RecordField Name="SphType" />
                        <ext:RecordField Name="ShipmentPmaId" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="ShipmentQty" />
                        <ext:RecordField Name="TotalQty" />
                        <ext:RecordField Name="Iscrm" />

                        <ext:RecordField Name="CustomerFaceNbr" />
                        <ext:RecordField Name="CfnId" />
                        <ext:RecordField Name="CurDate" />
                        <ext:RecordField Name="ShipmentDate" />
                        <ext:RecordField Name="HasAttachment" />
                        <ext:RecordField Name="ActualShipDate" />
                        <ext:RecordField Name="ConvertExpDate" />
                        <ext:RecordField Name="Dealerid" />
                        <ext:RecordField Name="EditQrCode" />
                        <ext:RecordField Name="QrCode" />
                        <ext:RecordField Name="IsShipDateCrossQuarter" />
                        <ext:RecordField Name="IsActualShipDateCrossQuarter" />
                        <ext:RecordField Name="ErrorDesc" />

                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="BumId" />
                        <ext:RecordField Name="IsError" />
                        <ext:RecordField Name="ErrorType" />
                        <ext:RecordField Name="ErrorFixSuggestion" />
                        <ext:RecordField Name="WhmId" />
                        <ext:RecordField Name="WhmName" />
                        <ext:RecordField Name="CfnChineseName" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="AvailableQty" />
                        <ext:RecordField Name="SalesUnitPrice" />
                        <ext:RecordField Name="CreateUser" />
                        <ext:RecordField Name="CreateDate" />

                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Window ID="CheckSubmitResultWindows" runat="server" Icon="Group" Title="销售单数据提交核查结果" AutoScroll="true"
            Width="1100" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Y="15" Maximizable="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout6" runat="server">
                    <Center MarginsSummary="0 0 0 0">
                        <ext:Panel ID="Panel13" runat="server" Header="false" Border="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="gpCheckSubmitResult" runat="server" Title=""
                                        StoreID="CheckSubmitResultStore" Border="false" Icon="Error" AutoWidth="true" StripeRows="true"
                                        EnableHdMenu="false">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar2" runat="server" Height="25">
                                                <Items>
                                                    <ext:Label ID="lblWrongCnt" runat="server" Text="" Icon="Cross" CtCls="txtRed" />
                                                    <ext:Label ID="LabelBlank1" runat="server" Text="" />
                                                    <ext:Label ID="lblCorrectCnt" runat="server" Text="" Icon="Tick" CtCls="txtGree" />
                                                    <ext:Label ID="LabelBlank2" runat="server" Text="" />
                                                </Items>

                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                    <ext:Label ID="lblSumQty" runat="server" Text="" Icon="Sum" />
                                                    <ext:Label ID="LabelBlank4" runat="server" Text="" />
                                                    <ext:Label ID="lblSumPrice" runat="server" Text="" Icon="Sum" />
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel4" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="IsError" DataIndex="IsError" Header="结果" Sortable="false" Width="40">
                                                    <Renderer Fn="change" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipmentDate" DataIndex="ShipmentDate" Header="用量日期" Sortable="true" Width="80">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="WhmName" DataIndex="WhmName" Header="仓库" Sortable="true" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="产品型号" Sortable="true" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnChineseName" DataIndex="CfnChineseName" Header="产品名称" Sortable="false" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ConvertFactor" DataIndex="ConvertFactor" Header="包装数" Sortable="false" Width="50">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="批号" Sortable="true" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="QrCode" DataIndex="QrCode" Header="二维码" Sortable="true" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="产品有效期" Sortable="true" Width="80">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="可用库存数" Sortable="false" Width="70">
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipmentQty" DataIndex="ShipmentQty" Header="销售数量" Sortable="false" Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="AvailableQty" DataIndex="AvailableQty" Header="剩余库存" Sortable="false" Width="60">
                                                    <Renderer Fn="alertInfoQty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesUnitPrice" DataIndex="SalesUnitPrice" Header="销售单价" Sortable="false" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="ErrorType" DataIndex="ErrorType" Header="错误类别" Sortable="false" Width="100" Align="Center">
                                                    <Renderer Fn="renderDataErrorType" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ErrorDesc" DataIndex="ErrorDesc" Header="错误描述" Sortable="false" Width="200">
                                                    <Renderer Fn="alertInfo" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ErrorFixSuggestion" DataIndex="ErrorFixSuggestion" Header="建议修改" Sortable="false" Width="200">
                                                    <Renderer Fn="alertInfo" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Dealerid" DataIndex="Dealerid" Header="Dealerid" Hidden="true">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="false">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <CellClick Fn="cellClickErrorResult" />
                                        </Listeners>
                                        <LoadMask ShowMask="true" Msg="Loading..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnSubmitShipment" runat="server" Text="提交(仅正确记录)" Icon="Accept">
                    <Listeners>
                        <Click Handler="SubmitCheckCorrectRecord();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnExpAllResult" runat="server" Text="导出(所有记录)" Icon="PageExcel" IDMode="Legacy" AutoPostBack="true" OnClick="ExportSubmitDetail">
                </ext:Button>
                <ext:Button ID="btnReturn" runat="server" Text="返回上一步" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{CheckSubmitResultWindows}.hide();#{SubmitButton}.enable(); #{GridPanel2}.store.reload()" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="#{SubmitButton}.enable(); #{GridPanel2}.store.reload();" />
            </Listeners>
        </ext:Window>

        <ext:Hidden ID="hidPriceDetailId" runat="server">
        </ext:Hidden>
        <ext:Store ID="UpdateOrderPriceStore" runat="server" OnRefreshData="UpdateOrderPriceStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="CFN" />
                        <ext:RecordField Name="UPN" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="UnitOfMeasure" />
                        <ext:RecordField Name="UnitPrice" />
                        <ext:RecordField Name="ShipmentQty" />
                        <ext:RecordField Name="TotalQty" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="WarehouseId" />
                        <ext:RecordField Name="Implant" />
                        <ext:RecordField Name="IsConsumableItem" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="CFNEnName" />
                        <ext:RecordField Name="CFNChName" />
                        <ext:RecordField Name="ShipmentDate" />
                        <ext:RecordField Name="Remark" />
                        <ext:RecordField Name="IsCanOrder" />
                        <ext:RecordField Name="CFN_Property6" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="PurchaseOrderNbr" />
                        <ext:RecordField Name="QRCode" />
                        <ext:RecordField Name="QRCodeEdit" />
                        <ext:RecordField Name="WhType" />
                        <ext:RecordField Name="WhCode" />
                        <ext:RecordField Name="AdjAction" />
                        <ext:RecordField Name="QRCheck" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert(MsgList.DetailStore.LoadExceptionTitle, e.message || response.statusText);" />
            </Listeners>
        </ext:Store>

        <ext:Window ID="UpdateOrderPriceWindow" runat="server" Icon="Group" Title="销售单数据提交核查结果" AutoScroll="true"
            Width="980" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Y="15" Maximizable="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout7" runat="server">
                    <Center MarginsSummary="0 0 0 0">
                        <ext:Panel ID="Panel14" runat="server" Header="false" Border="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout6" runat="server">
                                    <ext:GridPanel ID="OrderPriceGridPanel" runat="server" Title="产品明细" StoreID="UpdateOrderPriceStore" Border="false" Icon="Lorry" AutoWidth="true" ClicksToEdit="1" EnableHdMenu="false" StripeRows="true" Header="false" AutoExpandColumn="WarehouseName">
                                        <ColumnModel ID="ColumnModel10" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="分仓库" Width="180">
                                                </ext:Column>
                                                <ext:Column ColumnID="CFN" DataIndex="CFN" Header="产品型号" Width="90">
                                                </ext:Column>
                                                <ext:Column ColumnID="CFNEnName" DataIndex="CFNEnName" Header="产品英文名" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="UPN" DataIndex="UPN" Header="产品UPN">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="序号/批号" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="产品有效期" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="单位" Width="40">
                                                </ext:Column>
                                                <ext:Column ColumnID="ConvertFactor" DataIndex="ConvertFactor" Header="系数" Width="40">
                                                </ext:Column>
                                                <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="库存量" Width="70" Align="Right">
                                                </ext:Column>
                                                <ext:Column ColumnID="UnitPrice" DataIndex="UnitPrice" Header="单价" Width="60" Align="Right">
                                                    <Editor>
                                                        <ext:NumberField ID="txtUnitPriceWind" runat="server" AllowBlank="false" DecimalPrecision="2" AllowDecimals="true" SelectOnFocus="true" AllowNegative="false">
                                                        </ext:NumberField>
                                                    </Editor>
                                                    <Renderer Fn="SetCellCssEditable" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipmentQty" DataIndex="ShipmentQty" Header="销售量" Width="70" Align="Right">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel10" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <SaveMask ShowMask="true" Msg="<%$ Resources:GridPanel2.SaveMask.Msg %>" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel2.LoadMask.Msg %>" />
                                        <Listeners>
                                            <%--将当前编辑行Id保存下来 --%>
                                            <BeforeEdit Handler="#{hidPriceDetailId}.setValue(this.getSelectionModel().getSelected().id);
                                                    #{txtUnitPriceWind}.setValue(this.getSelectionModel().getSelected().data.UnitPrice);
                                                    " />
                                            <AfterEdit Handler="
                                                    Coolite.AjaxMethods.SaveItemPrice(#{txtUnitPriceWind}.getValue(),{success:function(){#{hidPriceDetailId}.setValue('');},failure: function(err) {Ext.Msg.alert(MsgList.AfterEdit.FailureTitle, err);}});" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Listeners>
                <Hide Handler="#{GridPanel2}.store.reload();" />
            </Listeners>
        </ext:Window>

        <uc1:ShipmentDialog ID="ShipmentDialog1" runat="server" />
        <uc1:ShipmentCfnDialog ID="ShipmentCfnDialog1" runat="server" />
        <uc1:AuthorizationDialog ID="AuthorizationDialog1" runat="server"></uc1:AuthorizationDialog>
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
