<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InventoryReturn.aspx.cs"
    Inherits="DMS.Website.Pages.Inventory.InventoryReturn" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/InventoryAdjustDialog.ascx" TagName="InventoryAdjustDialog"
    TagPrefix="uc2" %>
<%@ Register Src="../../Controls/InventoryAdjustEditor.ascx" TagName="InventoryAdjustEditor"
    TagPrefix="uc1" %>
<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Had1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"></script>

    <style type="text/css">
        .editable-column {
            background: #FFFF99;
        }

        .nonEditable-column {
            background: #FFFFFF;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />

        <script language="javascript" type="text/javascript">
            function downloadfile(url) {
                var iframe = document.createElement("iframe");
                iframe.src = url;
                iframe.style.display = "none";
                document.body.appendChild(iframe);
            }

            var MsgList = {
                btnInsert: {
                    FailureTitle: "<%=GetLocalResourceObject("Panel1.btnInsert.Alert.Title").ToString()%>",
                    FailureMsg: "<%=GetLocalResourceObject("Panel1.btnInsert.Alert.Body").ToString()%>"
                },
                ShowDetails: {
                    FailureTitle: "<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Alert.Title").ToString()%>",
                    FailureMsg: "<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Alert.Body").ToString()%>"
                },
                AddItemsButton: {
                    FailureTitle: "<%=GetLocalResourceObject("GridPanel2.AddItemsButton.AjaxEvents.Alert.Title").ToString()%>",
                    FailureMsg: "<%=GetLocalResourceObject("GridPanel2.AddItemsButton.AjaxEvents.Alert.Body").ToString()%>"
                },
                Error: "<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>"
            }

            var OrderApplyMsgList = {
                msg1: "<%=GetLocalResourceObject("loadExample.subMenu300").ToString()%>",
                msg2: "<%=GetLocalResourceObject("loadExample.subMenu301").ToString()%>"
            }


            var ReloadGridByType = function () {
                var detailGrid = Ext.getCmp('GridPanel2');
                var consignmentGrid = Ext.getCmp('GridPanel3');
                var hiddenDealerType = Ext.getCmp('hiddenDealerType');
                var hiddenAdjustType = Ext.getCmp('hiddenAdjustTypeId');
                var hiddenReturnType = Ext.getCmp('hiddenReturnType');
                if ((hiddenAdjustType.getValue() == 'Return' || hiddenAdjustType.getValue() == 'Exchange') && hiddenDealerType.getValue() == 'T2' && hiddenReturnType.getValue() == 'Consignment') {
                    //consignmentGrid.store.reload();
                }
                else if (hiddenAdjustType.getValue() == 'Transfer' && hiddenReturnType.getValue() == 'Consignment' && (hiddenDealerType.getValue() == 'T1' || hiddenDealerType.getValue() == 'LP')) {
                    //consignmentGrid.store.reload();
                }
                else {
                    detailGrid.store.reload();
                }
            }

            var CheckAddItemsParam = function () {
                //此函数用来控制“添加产品”按钮的状态

                if (Ext.getCmp('cbProductLineWin').getValue() == '') {
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
                if (currenStatus == 'new') {
                    Coolite.AjaxMethods.DeleteDraft(
                    {
                        success: function () {
                            Ext.getCmp('hiddenIsModified').setValue('');
                            Ext.getCmp('GridPanel1').store.reload();
                            Ext.getCmp('DetailWindow').hide();
                        },
                        failure: function (err) {
                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', err);
                    }
                }
                );
                    return false;
                }
            if (currenStatus == 'newchanged') {
                //第一次新增的窗口
                Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title1").ToString()%>',
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
                                Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', err);
                            }
                        }
                        );
                        }
                });
                    return false;
                }
            if (currenStatus == 'oldchanged') {
                //修改窗口
                Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.oldchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.oldchanged.Confirm.Title2").ToString()%>',
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

            if (hiddenProductLineId.getValue() != cbProductLineWin.getValue()) {
                if (hiddenProductLineId.getValue() == '') {
                    hiddenProductLineId.setValue(cbProductLineWin.getValue());
                    //grid.store.reload();
                    ReloadGridByType();
                    CheckAddItemsParam();
                    ClearItems();
                    SetMod(true);
                    Ext.getCmp('cbRsm').store.reload();
                } else {
                    Ext.Msg.confirm('<%=GetLocalResourceObject("ChangeProductLine.confirm.Title").ToString()%>', '<%=GetLocalResourceObject("ChangeProductLine.confirm.Body").ToString()%>',
                            function (e) {
                                if (e == 'yes') {
                                    Coolite.AjaxMethods.OnProductLineChange(
                                        {
                                            success: function () {
                                                hiddenProductLineId.setValue(cbProductLineWin.getValue());
                                                //grid.store.reload();
                                                ReloadGridByType();
                                                CheckAddItemsParam();
                                                ClearItems();
                                                SetMod(true);
                                                Ext.getCmp('cbRsm').store.reload();
                                            },
                                            failure: function (err) {
                                                Ext.Msg.alert('<%=GetLocalResourceObject("ChangeProductLine.Alert.Title").ToString()%>', err);
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
                        var ChangeApplyType = function () {
                            var hiddApplyType = Ext.getCmp('hiddApplyType');
                            var cbApplyType = Ext.getCmp('cbApplyType');
                            var grid = Ext.getCmp('GridPanel2');
                            var cbReturnReason = Ext.getCmp('cbReturnReason');
                            var hiddenReason = Ext.getCmp('hiddenReason');
                            var hiddenIsModified = Ext.getCmp('hiddenIsModified');

                            if (hiddApplyType.getValue() != cbApplyType.getValue()) {

                                Coolite.AjaxMethods.OnCbApplyChange(
                                    {
                                        success: function () {

                                            //grid.store.reload();
                                            //ReloadGridByType();
                                            CheckAddItemsParam();
                                            ClearItems();
                                            SetMod(true);
                                            hiddenReason.setValue('');
                                            cbReturnReason.store.reload();
                                        },
                                        failure: function (err) {
                                            Ext.Msg.alert('<%=GetLocalResourceObject("ChangeProductLine.Alert.Title").ToString()%>', err);
                                        }
                                    }
                                );

                                    }
                        }

                                var ChangcbReturnReason = function () {
                                    var cbReturnReason = Ext.getCmp('cbReturnReason');
                                    var hiddenReason = Ext.getCmp('hiddenReason');
                                    if (cbReturnReason.getValue() != hiddenReason.getValue()) {
                                        Coolite.AjaxMethods.OnChangcbReturnReason(cbReturnReason.getValue(),
                                                            {
                                                                success: function () {

                                                                    //grid.store.reload();
                                                                    //ReloadGridByType();

                                                                },
                                                                failure: function (err) {
                                                                    Ext.Msg.alert('<%=GetLocalResourceObject("ChangeProductLine.Alert.Title").ToString()%>', err);
                                                            }
                                                        }
                                );
                                                        }
                            }
                                                    var CheckDraft = function () {
                                                        if (Ext.getCmp('hiddenIsEditting').getValue() != '') {
                                                            //Ext.Msg.alert('Error','请稍后');
                                                        } else {
                                                            if (Ext.getCmp('txtAdjustReasonWin').getValue().length > 2000) {
                                                                Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckAdjustReason").ToString()%>');
                                                                }
                                                                else {
                                                                    Coolite.AjaxMethods.SaveDraft({
                                                                        success: function () {
                                                                            Ext.getCmp('hiddenIsModified').setValue('');
                                                                            Ext.getCmp('GridPanel1').store.reload();
                                                                            Ext.getCmp('DetailWindow').hide();
                                                                        },
                                                                        failure: function (err) {
                                                                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', err);
                                                }
                                            });
                                            }
                                        }

                                                        }

                                    var CheckSubmit = function () {

                                        var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');

                                        if (hiddenIsEditting.getValue() != '') {
                                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckSubmit.alert.Body").ToString()%>');
                            return;
                        }
                        if (Ext.getCmp('txtAdjustReasonWin').getValue().length > 2000) {
                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckAdjustReason").ToString()%>');
                            return;
                        }

                        //var cbDealerWin = Ext.getCmp('cbDealerWin');
                        var cbProductLineWin = Ext.getCmp('cbProductLineWin');
                        var txtAdjustReasonWin = Ext.getCmp('txtAdjustReasonWin');
                        var grid = Ext.getCmp('GridPanel2');
                        var consignmentGrid = Ext.getCmp('GridPanel3');
                        var hiddenDealerType = Ext.getCmp('hiddenDealerType');
                        var hiddenAdjustType = Ext.getCmp('hiddenAdjustTypeId');
                        var hiddenReturnType = Ext.getCmp('hiddenReturnType');
                        var hiddenResult = Ext.getCmp('hiddenresult');
                        var hiddApplyType = Ext.getCmp('hiddApplyType');
                        var cbReturnTypeWin = Ext.getCmp('cbReturnTypeWin');
                        var cbRsm = Ext.getCmp('cbRsm');
                        var cbReturnReason = Ext.getCmp('cbReturnReason');

                        if (hiddenIsRsm.getValue() == 'true' && cbRsm.getValue() == '') {
                            Ext.Msg.alert('Messing', '请选择销售！');
                            return;
                        }

                        if (cbProductLineWin.getValue() != '' && txtAdjustReasonWin.getValue() != '' && hiddApplyType.getValue() != '' && cbReturnTypeWin.getValue() != ''
                        && ((hiddenDealerType.getValue() != 'T2' && grid.store.getCount() > 0)
                        || (hiddenDealerType.getValue() == 'T2' && (hiddenAdjustType.getValue() != 'Return' || hiddenAdjustType.getValue() != 'Exchange') && grid.store.getCount() > 0)
                        || (hiddenDealerType.getValue() == 'T2' && (hiddenAdjustType.getValue() == 'Return' || hiddenAdjustType.getValue() == 'Exchange') && hiddenReturnType.getValue() == 'Consignment' && consignmentGrid.store.getCount() > 0)
                        || (hiddenDealerType.getValue() == 'T2' && (hiddenAdjustType.getValue() == 'Return' || hiddenAdjustType.getValue() == 'Exchange') && hiddenReturnType.getValue() != 'Consignment' && grid.store.getCount() > 0)
                        || (hiddenAdjustType.getValue() == 'Transfer' && (hiddenDealerType.getValue() == 'T1' || hiddenDealerType.getValue() == 'LP')))) {
                            if (CheckLotQty()) {

                                if ((hiddenDealerType.getValue() == 'T1' || hiddenDealerType.getValue() == 'LP') && hiddenReturnType.getValue() == 'Normal' && cbReturnReason.getValue() == '') {
                                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.failure.Alert.Title").ToString()%>', '请选择退货原因');
                                    return false;
                                }
                                Ext.getCmp("DetailWindow").body.mask('Loading...', 'x-mask-loading');
                                Coolite.AjaxMethods.DoSubmit({

                                    success: function () {
                                        if (hiddenResult.getValue() == 'true') {
                                            Ext.getCmp("DetailWindow").body.unmask();
                                            Ext.getCmp('hiddenIsModified').setValue('');
                                            Ext.getCmp('GridPanel1').store.reload();
                                            Ext.getCmp('DetailWindow').hide();
                                        }
                                    },
                                    failure: function (err) {
                                        Ext.getCmp("DetailWindow").body.unmask();
                                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.failure.Alert.Title").ToString()%>', err.indexOf("$$$") > 0 ? err.split("$$$")[1] : err);
                            Ext.getCmp('GridPanel2').store.reload();
                        },
                        timeout: 1800000
                    });
                }
            } else {
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.Alert.Title1").ToString()%>', ' <%=GetLocalResourceObject("CheckSubmit.Alert.Body1").ToString()%>');
                            Ext.getCmp("DetailWindow").body.unmask();
                        }
                    }


                    var CheckLotQty = function () {
                        var store;

                        var hiddenDealerType = Ext.getCmp('hiddenDealerType');
                        var hiddenAdjustType = Ext.getCmp('hiddenAdjustTypeId');
                        var hiddenReturnType = Ext.getCmp('hiddenReturnType');
                        var hiddenWhmType = Ext.getCmp('hiddenWhmType');
                        if (hiddenDealerType.getValue() == 'T2' && (hiddenAdjustType.getValue() == 'Return' || hiddenAdjustType.getValue() == 'Exchange') && hiddenReturnType.getValue() == 'Consignment') {
                            store = Ext.getCmp('GridPanel2').store;
                        }
                        else if (hiddenAdjustType.getValue() == 'Transfer' && (hiddenDealerType.getValue() == 'T1' || hiddenDealerType.getValue() == 'LP')) {
                            store = Ext.getCmp('GridPanel2').store;
                        }
                        else {
                            store = Ext.getCmp('GridPanel2').store;
                        }
                        for (var i = 0; i < store.getCount() ; i++) {
                            var record = store.getAt(i);
                            if (record.data.AdjustQty <= 0) {
                                Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body").ToString()%>');
                    return false;
                }
              <%--  if (hiddenDealerType.getValue() == 'T2' && (hiddenAdjustType.getValue() == 'Return'|| hiddenAdjustType.getValue()=='Exchange') && (record.data.PurchaseOrderNbr == "" || record.data.PurchaseOrderNbr == null)) {

                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body2").ToString()%>');
                    return false;
                }--%>

                if (record.data.LotNumber == "" || record.data.LotNumber == null) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title1").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body1").ToString()%>');
                    return false;
                }
                if (hiddenAdjustType.getValue() == 'Transfer' && (record.data.ChineseName == "" || record.data.ChineseName == null) && (hiddenDealerType.getValue() == 'T1' || hiddenDealerType.getValue() == 'LP')) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title").ToString()%>', '转移经销商不能为空！');
                    return false;
                }
                if (hiddenAdjustType.getValue() == 'Transfer' && (record.data.PurchaseOrderNbr == "" || record.data.PurchaseOrderNbr == null) && (hiddenDealerType.getValue() == 'T1' || hiddenDealerType.getValue() == 'LP')) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body2").ToString()%>');
                    return false;
                }

                if ((record.data.QRCodeEdit == "" || record.data.QRCodeEdit == null) && record.data.QRCode == "NoQR" && (hiddenAdjustType.getValue() == 'Return' || hiddenAdjustType.getValue() == 'Exchange')) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title").ToString()%>', 'NoQR产品不能退货，请填写二维码');
                    return false;
                }
                if (store.query("QRCodeEdit", record.data.QRCodeEdit).length > 1 && record.data.QRCodeEdit != "" && hiddenAdjustType.getValue() != 'Transfer') {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '二维码' + record.data.QRCodeEdit + "出现多次");
                    return false;
                }
                if (store.query("QRCode", record.data.QRCodeEdit).length > 0 && record.data.QRCode != "NoQR" && record.data.QRCodeEdit != "" && hiddenAdjustType.getValue() != 'Transfer') {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '二维码' + record.data.QRCode + "已使用");
                    return false;
                }
              <%--  if(hiddenAdjustType.getValue() == 'Return' && record.data.WarehouseType == 'Borrow' && (record.data.PurchaseOrderNbr == "" || record.data.PurchaseOrderNbr == null) && (hiddenDealerType.getValue() == 'T1' || hiddenDealerType.getValue() == 'LP'))
                {
                  
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title").ToString()%>', '借货库的物料关联订单号不能为空');
                    return false;
                }--%>

            }

            return true;
        }

        //校验用户输入数量
        var CheckQty = function () {
            var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
            var txtAdjustQty = Ext.getCmp('txtAdjustQty');
            var grid = Ext.getCmp('GridPanel2');
            var hiddenCurrentEdit = Ext.getCmp('hiddenCurrentEdit');
            var hiddenDealerType = Ext.getCmp('hiddenDealerType');

            var record = grid.store.getById(hiddenCurrentEdit.getValue());
            //记录当前编辑的行ID
            hiddenIsEditting.setValue(hiddenCurrentEdit.getValue());

            if (accMin(record.data.TotalQty, txtAdjustQty.getValue()) < 0) {
                //数量错误时，编辑行置为空
                hiddenIsEditting.setValue('');
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body").ToString()%>');
                return false;
            }

            if (txtAdjustQty.getValue() > 1) {
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '退货数量不能大于1');
                return false;
            }

            if (hiddenDealerType.getValue() == 'T2') {
                if (accMul(txtAdjustQty.getValue(), 1000000) % accDiv(1, record.data.ConvertFactor).mul(1000000) != 0) {
                    hiddenIsEditting.setValue('');
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body1").ToString()%>' + accDiv(1, record.data.ConvertFactor).toString());
                    return false;
                }
            } else {
                //非T2的经销商申请的数量不能为小数,因此这里设置转换率均为1
                if (accMul(txtAdjustQty.getValue(), 1000000) % accDiv(1, 1).mul(1000000) != 0) {
                    hiddenIsEditting.setValue('');
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body1").ToString()%>' + 1);
                    return false;
                }
            }

            return true;
        }

        //校验用户输入数量
        var CheckConsignmentQty = function () {

            var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
            var txtAdjustQty = Ext.getCmp('nfAdjustQty');
            var grid = Ext.getCmp('GridPanel3');
            var hiddenCurrentEdit = Ext.getCmp('hiddenCurrentEdit');
            var record = grid.store.getById(hiddenCurrentEdit.getValue());
            var hiddenDealerType = Ext.getCmp('hiddenDealerType');

            //记录当前编辑的行ID
            hiddenIsEditting.setValue(hiddenCurrentEdit.getValue());

            if (accMin(record.data.TotalQty, txtAdjustQty.getValue()) < 0) {
                //数量错误时，编辑行置为空
                hiddenIsEditting.setValue('');
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body").ToString()%>');
                return false;
            }

            if (hiddenDealerType.getValue() == 'T2') {
                if (accMul(txtAdjustQty.getValue(), 1000000) % accDiv(1, record.data.ConvertFactor).mul(1000000) != 0) {
                    hiddenIsEditting.setValue('');
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body1").ToString()%>' + accDiv(1, record.data.ConvertFactor).toString());
                    return false;
                }
            } else {
                //非T2的经销商申请的数量不能为小数,因此这里设置转换率均为1
                if (accMul(txtAdjustQty.getValue(), 1000000) % accDiv(1, 1).mul(1000000) != 0) {
                    hiddenIsEditting.setValue('');
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body1").ToString()%>' + 1);
                    return false;
                }
            }

            return true;
        }

        var SetCellCssEditable = function (v, m) {
            m.css = "editable-column";
            return v;
        }

        var SetCellCssNonEditable = function (v, m) {
            m.css = "nonEditable-column";
            return v;
        }

        var ReturnPrint = function () {
            return '<img class="imgPrint" style="cursor:pointer;" src="../../resources/images/icons/printer.png" />';
        }

        var cellClick = function (grid, rowIndex, columnIndex, e) {

            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
            var id = record.data['Id'];
            if (t.className == 'imgPrint' && columnId == 'Id') {
                //showModalDialog("InventoryReturnPrint.aspx?id=" + id, window, "status:false;dialogWidth:800px;dialogHeight:500px");
                window.open("InventoryReturnPrint.aspx?id=" + id, 'newwindow',
              'status=no,width=850px,height=550px,scrollbars=yes,resizable=yes,location=no,top=50,left=100');
            }
        }

        function SelectValue(e) {
            var filterField = 'ChineseShortName';  //需进行模糊查询的字段
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var value = e.query;
                if (value != null && value != '') {
                    combo.store.filterBy(function (record, id) {
                        var text = record.get(filterField);
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

        function CbDealerWinChanaeg() {

            var hiddenDealer = Ext.getCmp('<%=this.hiddenDealerId.ClientID%>');
            var cbDealer = Ext.getCmp('<%=this.cbDealerWin.ClientID%>');
            var hiddenDealerType = Ext.getCmp('<%=hiddenDealerType.ClientID%>');
            var store = Ext.getCmp('<%=cbDealerWin.ClientID%>').store;
            var DealerType = store.getById(cbDealer.getValue()).get('DealerType');
            if (hiddenDealer.getValue() != cbDealer.getValue()) {
                Ext.Msg.confirm('Messing', '变更经销商会删除原有产品,确定变更？', function (e) {
                    if (e == 'yes') {
                        hiddenDealerType.setValue(DealerType);
                        Coolite.AjaxMethods.CbDealerWinChanaeg({

                            success: function () {

                                //grid.store.reload();
                                ReloadGridByType();
                                CheckAddItemsParam();
                                ClearItems();
                                SetMod(true);

                            },
                            failure: function (err) {
                                Ext.Msg.alert('<%=GetLocalResourceObject("ChangeProductLine.Alert.Title").ToString()%>', err);
                            }
                        })
                        }
                        else {
                            cbDealer.setValue(hiddenDealer.getValue());
                        }
                })

                }
            }
            var change = function () {
                var id = Ext.getCmp('cbReturnTypeWin').getValue();
                if (id == 'Exchange') {
                    Ext.MessageBox.alert('提示', '仅限换同UPN产品');
                    return;
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
            <Listeners>
                <Load Handler="#{RsmStore}.reload();" />
            </Listeners>
            <SortInfo Field="Id" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="ProductLineStoreWin" runat="server" UseIdConfirmation="true">
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
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseShortName" />
                        <ext:RecordField Name="DealerType" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="AdjustStatusStore" runat="server" UseIdConfirmation="true">
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
        <ext:Store ID="AdjustTypeForMainStore" runat="server" UseIdConfirmation="true">
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
        <ext:Store ID="AdjustTypeStore" runat="server" UseIdConfirmation="true">
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
        <ext:Store ID="AdjustReturnTypeStore" runat="server" UseIdConfirmation="true" AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{cbApplyType}.setValue(#{hiddApplyType}.getValue()); #{cbReturnReason}.store.reload();" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="AdjustNumber" />
                        <ext:RecordField Name="Type" />
                        <ext:RecordField Name="CreateDate" />
                        <ext:RecordField Name="CreateUserId" />
                        <ext:RecordField Name="CreateUserName" />
                        <ext:RecordField Name="Status" />
                        <ext:RecordField Name="ApprovalDate" />
                        <ext:RecordField Name="ApprovalUserId" />
                        <ext:RecordField Name="ProductLine" />
                        <ext:RecordField Name="TotalQyt" />
                        <ext:RecordField Name="IsConsignment" />
                        <ext:RecordField Name="ProductLineName" />
                        <ext:RecordField Name="Remark" />
                        <ext:RecordField Name="IAH_WarehouseType" />

                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--        <SortInfo Field="AdjustNumber" Direction="ASC" />--%>
        </ext:Store>
        <ext:Hidden ID="hiddenresult" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenUpn" runat="server">
        </ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true"
                            BodyStyle="padding: 5px;" Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout1.cbProductLine.EmptyText %>"
                                                            Width="150" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                            DisplayField="AttributeName" FieldLabel="<%$ Resources: Panel1.FormLayout1.cbProductLine.FieldLabel %>"
                                                            ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout1.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="txtStartDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout1.txtStartDate.FieldLabel %>" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtAdjustNumber" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout1.txtAdjustNumber.FieldLabel %>" />
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
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout2.cbDealer.EmptyText %>"
                                                            Width="220" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                                            DisplayField="ChineseShortName" Mode="Local" FieldLabel="<%$ Resources: Panel1.FormLayout2.cbDealer.FieldLabel %>"
                                                            ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout2.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();this.store.clearFilter();" />
                                                                <BeforeQuery Fn="ComboxSelValue" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="txtEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtEndDate.FieldLabel %>" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtCFN" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtUPN" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtUPN.FieldLabel %>"
                                                            Hidden="<%$ AppSettings: HiddenUPN  %>" />
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
                                                        <ext:ComboBox ID="cbReturnType" runat="server" Width="150px" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbReturnType.FieldLabel %>"
                                                            AllowBlank="true" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbReturnType.BlankText %>"
                                                            StoreID="AdjustTypeForMainStore" ValueField="Key" DisplayField="Value" EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbReturnType.EmptyText %>">
                                                            <%-- <Items>
                                                            <ext:ListItem Text="退货" Value="Return" />
                                                            <ext:ListItem Text="换货" Value="Exchange" />
                                                        </Items>--%>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout4.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbAdjustStatus" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout3.cbAdjustStatus.EmptyText %>"
                                                            Width="150" Editable="false" TypeAhead="true" StoreID="AdjustStatusStore" ValueField="Key"
                                                            DisplayField="Value" FieldLabel="<%$ Resources: Panel1.FormLayout3.cbAdjustStatus.FieldLabel %>">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout4.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtLotNumber2" runat="server" Width="150" FieldLabel="批号/二维码" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="<%$ Resources: Panel1.btnSearch.Text %>" runat="server"
                                    Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: Panel1.btnInsert.Text %>"
                                    Icon="Add" IDMode="Legacy">
                                    <AjaxEvents>
                                        <Click Before="#{GridPanel1}.getSelectionModel().clearSelections();#{hiddenReturnType}.setValue('Normal');"
                                            OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                            Success="#{cbDealerWin}.clearValue();#{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.setValue(#{cbProductLineWin}.store.getTotalCount()>0?#{cbProductLineWin}.store.getAt(0).get('Id'):'');#{hiddenProductLineId}.setValue(#{cbProductLineWin}.getValue()); ClearItems();#{GridPanel2}.clear();#{GridPanel3}.clear();#{hiddenIsModified}.setValue('new');#{gpLog}.store.reload();#{cbRsm}.store.reload();#{gpAttachment}.clear();">

                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}"
                                                Msg="<%$ Resources: GridPanel1.AjaxEvents.EventMask.Msg %>" />
                                            <ExtraParams>
                                                <ext:Parameter Name="AdjustId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                                </ext:Parameter>
                                                <ext:Parameter Name="AdjustType" Value="Return" Mode="Value">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnInsertConsignment" runat="server" Text="<%$ Resources: Panel1.btnConsignmentInsert.Text %>"
                                    Icon="Add" IDMode="Legacy">
                                    <AjaxEvents>
                                        <Click Before="#{GridPanel1}.getSelectionModel().clearSelections();#{hiddenReturnType}.setValue('Consignment');"
                                            OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                            Success="#{cbDealerWin}.clearValue();#{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.setValue(#{cbProductLineWin}.store.getTotalCount()>0?#{cbProductLineWin}.store.getAt(0).get('Id'):'');#{hiddenProductLineId}.setValue(#{cbProductLineWin}.getValue());ClearItems();#{GridPanel2}.clear();#{GridPanel3}.clear();#{hiddenIsModified}.setValue('new');#{gpLog}.store.reload();#{gpAttachment}.clear();">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}"
                                                Msg="<%$ Resources: GridPanel1.AjaxEvents.EventMask.Msg %>" />
                                            <ExtraParams>
                                                <ext:Parameter Name="AdjustId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                                </ext:Parameter>
                                                <ext:Parameter Name="AdjustType" Value="Return" Mode="Value">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnInsertBorrow" runat="server" Text="<%$ Resources: Panel1.btnInsertBorrow.Text %>"
                                    Disabled="false" Icon="Add" IDMode="Legacy" Hidden="true">
                                    <AjaxEvents>
                                        <Click Before="#{GridPanel1}.getSelectionModel().clearSelections();#{hiddenReturnType}.setValue('Borrow');"
                                            OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                            Success="#{cbDealerWin}.clearValue();#{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.setValue(#{cbProductLineWin}.store.getTotalCount()>0?#{cbProductLineWin}.store.getAt(0).get('Id'):'');#{hiddenProductLineId}.setValue(#{cbProductLineWin}.getValue());ClearItems();#{GridPanel2}.clear();#{GridPanel3}.clear();#{hiddenIsModified}.setValue('new');#{gpLog}.store.reload();#{gpAttachment}.clear();">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}"
                                                Msg="<%$ Resources: GridPanel1.AjaxEvents.EventMask.Msg %>" />
                                            <ExtraParams>
                                                <ext:Parameter Name="AdjustId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                                </ext:Parameter>
                                                <ext:Parameter Name="AdjustType" Value="Transfer" Mode="Value">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnImport" runat="server" Text="<%$ Resources: btnImport.Text %>"
                                    Icon="Disk" IDMode="Legacy">
                                    <Listeners>
                                        <%-- <Click Handler="window.parent.loadExample('/Pages/Inventory/InventoryReturnImport.aspx','subMenu300',OrderApplyMsgList.msg1);" />--%>

                                        <Click Handler="top.createTab({id: 'subMenu300',title: '退换货申请 - 批量导入',url: 'Pages/Inventory/InventoryReturnImport.aspx'});" />

                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnImportConsignment" runat="server" Text="<%$ Resources: btnImportConsignment.Text %>"
                                    Icon="Disk" IDMode="Legacy" Hidden="true">
                                    <Listeners>
                                        <%--<Click Handler="window.parent.loadExample('/Pages/Inventory/InventoryReturnImportConsignment.aspx','subMenu301',OrderApplyMsgList.msg2);" />--%>
                                        <Click Handler="top.createTab({id: 'subMenu301',title: '退换货申请 - 寄售导入',url: 'Pages/Inventory/InventoryReturnImportConsignment.aspx'});" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnExport" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="true" OnClick="ExportExcel">
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                        StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true"
                                        AutoExpandColumn="Remark">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerId" DataIndex="DealerId" Header="<%$ Resources: GridPanel1.ColumnModel1.DealerId.Header %>"
                                                    Width="160">
                                                    <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseShortName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="AdjustNumber" DataIndex="AdjustNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.AdjustNumber.Header %>"
                                                    Width="160">
                                                </ext:Column>
                                                <ext:Column ColumnID="Type" DataIndex="Type" Width="100" Align="Center" Header="<%$ Resources: GridPanel1.ColumnModel1.Type.Header %>">
                                                    <Renderer Handler="return getNameFromStoreById(AdjustTypeForMainStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="TotalQyt" DataIndex="TotalQyt" Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.TotalQyt.Header %>"
                                                    Align="Right">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Width="100" Header="<%$ Resources: GridPanel1.ColumnModel1.CreateDate.Header %>"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateUserName" DataIndex="CreateUserName" Width="100" Header="<%$ Resources: GridPanel1.ColumnModel1.CreateUserName.Header %>"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="Status" DataIndex="Status" Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.Status.Header %>"
                                                    Align="Center">
                                                    <Renderer Handler="return getNameFromStoreById(AdjustStatusStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="IsConsignment" DataIndex="IsConsignment" Width="100" Header="<%$ Resources: GridPanel1.ColumnModel1.IsConsignment.Header %>"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Width="120" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductLineName.Header %>"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="Remark" DataIndex="Remark" Header="<%$ Resources: GridPanel1.ColumnModel1.Remark.Header %>"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>"
                                                    Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.ToolTip.Text %>" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:Column ColumnID="Id" DataIndex="Id" Header="<%$ Resources:GridPanel1.ColumnModel1.Id.Header %>"
                                                    Align="Center">
                                                    <Renderer Fn="ReturnPrint" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <AjaxEvents>
                                            <Command Before="#{hiddenReturnType}.setValue(#{GridPanel1}.getSelectionModel().getSelected().data.IAH_WarehouseType)" OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.ShowDetails.FailureTitle, MsgList.ShowDetails.FailureMsg);"
                                                Success="#{cbDealerWin}.clearValue(); #{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.clearValue(); if(#{hiddenProductLineId}.getValue()!=''){#{cbProductLineWin}.setValue(#{hiddenProductLineId}.getValue())}else{#{cbProductLineWin}.setValue(#{cbProductLineWin}.store.getTotalCount()>0?#{cbProductLineWin}.store.getAt(0).get('Id'):'');}ClearItems();#{GridPanel2}.reload();#{PagingToolBar3}.changePage(1);#{hiddenIsModified}.setValue('old');#{gpLog}.store.reload();#{cbRsm}.store.reload();#{PagingToolBarAttachement}.changePage(1);">

                                                <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}"
                                                    Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                                <ExtraParams>
                                                    <ext:Parameter Name="AdjustId" Value="#{GridPanel1}.getSelectionModel().getSelected().id"
                                                        Mode="Raw">
                                                    </ext:Parameter>
                                                    <ext:Parameter Name="AdjustType" Value="#{GridPanel1}.getSelectionModel().getSelected().data.Type"
                                                        Mode="Raw">
                                                    </ext:Parameter>
                                                </ExtraParams>
                                            </Command>
                                        </AjaxEvents>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="false" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel2.AddItemsButton.AjaxEvents.EventMask.Msg %>" />
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
        <ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="CFN" />
                        <ext:RecordField Name="UPN" />
                        <ext:RecordField Name="PmaId" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="UnitOfMeasure" />
                        <ext:RecordField Name="AdjustQty" />
                        <ext:RecordField Name="TotalQty" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="WarehouseId" />
                        <ext:RecordField Name="WarehouseType" />
                        <ext:RecordField Name="CreatedDate" DateFormat="Ymd" Type="Date" />
                        <ext:RecordField Name="PurchaseOrderNbr" />
                        <ext:RecordField Name="CFNEnglishName" />
                        <ext:RecordField Name="CFNChineseName" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="QRCode" />
                        <ext:RecordField Name="QRCodeEdit" />
                        <ext:RecordField Name="UnitPrice" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
            </Listeners>
            <%--        <SortInfo Field="CFN" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="ConsignmentDetailStore" runat="server" OnRefreshData="ConsignmentDetailStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="CFN" />
                        <ext:RecordField Name="UPN" />
                        <ext:RecordField Name="PmaId" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="UnitOfMeasure" />
                        <ext:RecordField Name="AdjustQty" />
                        <ext:RecordField Name="TotalQty" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="WarehouseId" />
                        <ext:RecordField Name="CreatedDate" DateFormat="Ymd" Type="Date" />
                        <ext:RecordField Name="PurchaseOrderNbr" />
                        <ext:RecordField Name="CFNEnglishName" />
                        <ext:RecordField Name="CFNChineseName" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="ChineseName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData"
            AutoLoad="false">
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
        <ext:Store ID="PurchaseOrderStore" runat="server" OnRefreshData="PurchaseOrderStore_RefershData"
            AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="PurchaseOrderNbr" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="ToDealerStore" runat="server" OnRefreshData="ToDealerStore_RefershData"
            AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="ChineseShortName" />

                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="RsmStore" runat="server" UseIdConfirmation="true" OnRefreshData="RsmStore_RefershData"
            AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="UserAccount">
                    <Fields>
                        <ext:RecordField Name="UserAccount" />
                        <ext:RecordField Name="UserCode" />
                        <ext:RecordField Name="Name" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{cbRsm}.setValue(#{hidSalesAccount}.getValue());" />
                <LoadException Handler="Ext.Msg.alert('RSM - Load failed', e.message || response.statusText);" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="RetrunReasonStore" runat="server" UseIdConfirmation="true" OnRefreshData="RetrunReasonStore_RefershData"
            AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="UserAccount">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler=" #{cbReturnReason}.setValue(#{hiddenReason}.getValue());" />
                <LoadException Handler="Ext.Msg.alert('RSM - Load failed', e.message || response.statusText);" />
            </Listeners>
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
        <ext:Hidden ID="hidSalesAccount" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenIsRsm" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsPageNew" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenAdjustId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenDealerId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenProductLineId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenAdjustTypeId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenIsModified" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenCurrentEdit" runat="server" />
        <ext:Hidden ID="hiddenIsEditting" runat="server" />
        <ext:Hidden ID="hiddenReturnType" runat="server" />
        <ext:Hidden ID="hiddenDealerType" runat="server" />
        <ext:Hidden ID="hiddenPmaId" runat="server" />
        <ext:Hidden ID="hiddenLotNumber" runat="server" />
        <ext:Hidden ID="hiddenQRCode" runat="server" />
        <ext:Hidden ID="hiddApplyType" runat="server" />
        <ext:Hidden ID="hiddenWhmType" runat="server" />
        <ext:Hidden ID="hiddenReason" runat="server" />
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
            Width="980" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:Panel ID="Panel11" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".3">
                                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbDealerWin" runat="server" Width="180" Editable="true" TypeAhead="true"
                                                                    Mode="Local" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                                    FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.FieldLabel %>"
                                                                    AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.BlankText %>"
                                                                    EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.EmptyText %>"
                                                                    ListWidth="300" Resizable="true">
                                                                    <Listeners>
                                                                        <Select Handler="CbDealerWinChanaeg();" />
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbProductLineWin" runat="server" Width="180" Editable="false" TypeAhead="true"
                                                                    StoreID="ProductLineStoreWin" ValueField="Id" DisplayField="AttributeName" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.FieldLabel %>"
                                                                    AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.BlankText %>"
                                                                    EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.EmptyText %>"
                                                                    ListWidth="300" Resizable="true">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout5.FieldTrigger.Qtip %>"
                                                                            HideTrigger="true" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <Select Handler="ChangeProductLine();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextArea ID="txtAdjustReasonWin" runat="server" FieldLabel="备注" LabelStyle="color:red;font-weight:bold"
                                                                    Width="180" SelectOnFocus="true" Height="50" AllowBlank="false" />
                                                            </ext:Anchor>

                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".25">
                                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtAdjustNumberWin" runat="server" Width="150" FieldLabel="退换货单号"
                                                                    ReadOnly="true" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtAdjustStatusWin" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtAdjustStatusWin.FieldLabel %>"
                                                                    ReadOnly="true" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextArea ID="txtAduitNoteWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout9.txtAduitNoteWin.FieldLabel %>"
                                                                    Width="150" SelectOnFocus="true" Height="50" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".2">
                                                <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="70">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtAdjustDateWin" Width="100" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtAdjustDateWin.FieldLabel %>"
                                                                    ReadOnly="true" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbRsm" runat="server" Width="100" FieldLabel="RSM"
                                                                    AllowBlank="false" BlankText="销售" ListWidth="250"
                                                                    EmptyText="请选择销售"
                                                                    StoreID="RsmStore" ValueField="UserCode" DisplayField="Name">
                                                                    <Listeners>
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".25">
                                                <ext:Panel ID="Panel10" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="80">

                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbApplyType" runat="server" Width="150" Editable="false" TypeAhead="true"
                                                                    StoreID="AdjustReturnTypeStore" ValueField="Key" DisplayField="Value" FieldLabel="退货类型"
                                                                    AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.BlankText %>"
                                                                    EmptyText="选择退货类型" ListWidth="300" Resizable="true">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout5.FieldTrigger.Qtip %>"
                                                                            HideTrigger="true" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <Select Handler="ChangeApplyType();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbReturnReason" runat="server" Width="150" StoreID="RetrunReasonStore"
                                                                    ValueField="Key" DisplayField="Value" FieldLabel="请选择原因" BlankText="请选择"
                                                                    EmptyText="请选择原因" ListWidth="300" Resizable="true">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <Select Handler="ChangcbReturnReason()" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbReturnTypeWin" runat="server" Width="150" FieldLabel="退/换货要求"
                                                                    AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbReturnType.BlankText %>"
                                                                    EmptyText="请选择退换货要求"
                                                                    StoreID="AdjustTypeStore" ListWidth="300" ValueField="Key" DisplayField="Value">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout4.FieldTrigger.Qtip %>" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <Select Handler="change();" />
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
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                            <Tabs>
                                <ext:Tab ID="TabHeader" runat="server" Title="<%$ Resources: TabDetail.Title %>"
                                    BodyStyle="padding: 0px;" AutoScroll="false">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout2" runat="server">
                                            <ext:GridPanel ID="GridPanel2" runat="server" Title="<%$ Resources: GridPanel2.Title %>"
                                                StoreID="DetailStore" StripeRows="true" Border="false" Icon="Lorry" ClicksToEdit="1"
                                                EnableHdMenu="false" Header="false">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar1" runat="server">
                                                        <Items>
                                                            <ext:Label ID="lblResult" runat="server" Text="" Icon="Lorry" />
                                                            <ext:Label ID="lblInvSum" runat="server" Text="" Icon="Sum" X="500" />
                                                        </Items>
                                                        <Items>
                                                            <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                            <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources: GridPanel2.AddItemsButton.Text %>"
                                                                Icon="Add">
                                                                <AjaxEvents>
                                                                    <Click OnEvent="ShowDialog" Failure="Ext.MessageBox.alert(MsgList.AddItemsButton.FailureTitle, MsgList.AddItemsButton.FailureMsg);">
                                                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{DetailWindow}.body}"
                                                                            Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                                                                        <ExtraParams>
                                                                            <ext:Parameter Name="AdjustId" Value="#{hiddenAdjustId}.getValue()" Mode="Raw">
                                                                            </ext:Parameter>
                                                                        </ExtraParams>
                                                                    </Click>
                                                                </AjaxEvents>
                                                            </ext:Button>
                                                        </Items>
                                                    </ext:Toolbar>
                                                </TopBar>
                                                <ColumnModel ID="ColumnModel2" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="<%$ Resources: GridPanel2.ColumnModel2.WarehouseName.Header %>"
                                                            Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CFNEnglishName" DataIndex="CFNEnglishName" Header="<%$ Resources: CFNEnglishName %>"
                                                            Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CFNChineseName" DataIndex="CFNChineseName" Header="<%$ Resources:CFNChineseName %>"
                                                            Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CFN" DataIndex="CFN" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                            Width="120">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UPN" DataIndex="UPN" Header="<%$ Resources: GridPanel2.ColumnModel2.UPN.Header %>"
                                                            Width="120" Hidden="<%$ AppSettings: HiddenUPN  %>">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel2.ColumnModel2.LotNumber.Header %>"
                                                            Width="90">
                                                            <Editor>
                                                                <ext:TextField ID="txtLotNumber" runat="server" AllowBlank="false" SelectOnFocus="true">
                                                                </ext:TextField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Width="80">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources: GridPanel2.ColumnModel2.ExpiredDate.Header %>"
                                                            Width="90">
                                                            <Editor>
                                                                <ext:DateField ID="dtExpiredDate" runat="server" AllowBlank="true" AltFormats="true"
                                                                    DataIndex="ExpiredDate">
                                                                </ext:DateField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources: GridPanel2.ColumnModel2.UnitOfMeasure.Header %>"
                                                            Width="50" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="<%$ Resources: GridPanel2.ColumnModel2.TotalQty.Header %>"
                                                            Width="70" Align="Right">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CreatedDate" DataIndex="CreatedDate" Header="<%$ Resources: GridPanel2.ColumnModel2.CreatedDate.Header %>"
                                                            Width="80">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Ymd')" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="AdjustQty" DataIndex="AdjustQty" Header="<%$ Resources: GridPanel2.ColumnModel2.AdjustQty.Header %>"
                                                            Width="50" Align="Right">
                                                            <Editor>
                                                                <ext:NumberField ID="txtAdjustQty" runat="server" AllowBlank="false" AllowDecimals="true"
                                                                    DataIndex="AdjustQty" SelectOnFocus="true" AllowNegative="false">
                                                                </ext:NumberField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="PurchaseOrderNbr" DataIndex="PurchaseOrderNbr" Header="<%$ Resources: GridPanel2.ColumnModel2.PurchaseOrderNbr.Header %>"
                                                            Align="Center" Width="200">
                                                            <Editor>
                                                                <ext:ComboBox ID="cbPurchaseOrderNbrNormal" runat="server" Width="200" Editable="true"
                                                                    TypeAhead="true" Mode="Local" StoreID="PurchaseOrderStore" ValueField="Id" DisplayField="PurchaseOrderNbr"
                                                                    AllowBlank="true" ListWidth="300" Resizable="true">
                                                                </ext:ComboBox>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="转移经销商" Align="Center"
                                                            Width="150">
                                                            <Editor>
                                                                <ext:ComboBox ID="cbToDealer" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                                    Mode="Local" StoreID="ToDealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                                    AllowBlank="false" ListWidth="200" Resizable="true">
                                                                </ext:ComboBox>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="QRCodeEdit" DataIndex="QRCodeEdit" Header="二维码" Align="Center"
                                                            Width="150">
                                                            <Editor>
                                                                <ext:TextField ID="txtQRCode" runat="server" AllowBlank="false" SelectOnFocus="true">
                                                                </ext:TextField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UnitPrice" DataIndex="UnitPrice" Header="退货价格信息" Align="Center"
                                                            Width="150">
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="50" Header="<%$ Resources: GridPanel2.ColumnModel2.CommandColumn.Header %>"
                                                            Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources: GridPanel2.ColumnModel2.CommandColumn.GridCommand.ToolTip-Text %>" />
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                                        MoveEditorOnEnter="true">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="DetailStore"
                                                        DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                                </BottomBar>
                                                <SaveMask ShowMask="true" />
                                                <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                                                <Listeners>
                                                    <Command Handler="if (command == 'Delete'){
                                                Coolite.AjaxMethods.DeleteItem(this.getSelectionModel().getSelected().id,{failure: function(err) {Ext.Msg.alert(MsgList.Error, err);}});
                                            }else{
                                                Coolite.AjaxMethods.EditItem(this.getSelectionModel().getSelected().id,#{hiddenAdjustTypeId}.getValue());
                                            }" />
                                                    <ValidateEdit Fn="CheckQty" />
                                                    <BeforeEdit Handler="#{hiddenCurrentEdit}.setValue(this.getSelectionModel().getSelected().id);
                                                            #{txtAdjustQty}.setValue(this.getSelectionModel().getSelected().data.AdjustQty);
                                                            #{txtLotNumber}.setValue(this.getSelectionModel().getSelected().data.LotNumber);
                                                            #{dtExpiredDate}.setValue(this.getSelectionModel().getSelected().data.ExpiredDate);
                                                            #{hiddenPmaId}.setValue(this.getSelectionModel().getSelected().data.PmaId);
                                                            #{hiddenLotNumber}.setValue(this.getSelectionModel().getSelected().data.LotNumber);
                                                            #{hiddenQRCode}.setValue(this.getSelectionModel().getSelected().data.QRCode);
                                                            #{txtQRCode}.setValue(this.getSelectionModel().getSelected().data.QRCodeEdit);
                                                            #{hiddenUpn}.setValue(this.getSelectionModel().getSelected().data.UPN);
                                                            #{PurchaseOrderStore}.reload();
                                                            #{cbPurchaseOrderNbrNormal}.setValue(this.getSelectionModel().getSelected().data.PurchaseOrderNbr);
                                                            #{ToDealerStore}.reload();
                                                            #{cbToDealer}.setValue(this.getSelectionModel().getSelected().data.ChineseName);
                                                            
                                                " />
                                                    <AfterEdit Handler="Coolite.AjaxMethods.SaveItem(#{txtLotNumber}.getValue(),#{dtExpiredDate}.getValue(),#{txtAdjustQty}.getValue(),#{cbPurchaseOrderNbrNormal}.getValue(),#{hiddenQRCode}.getValue(),#{txtQRCode}.getValue(),#{cbToDealer}.getValue(),#{hiddenUpn}.getValue(),{success:function(){ #{hiddenIsEditting}.setValue(''); },failure: function(err) {Ext.Msg.alert(MsgList.Error, err);}});" />
                                                </Listeners>
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                                <ext:Tab ID="TabConsignment" runat="server" Title="<%$ Resources: TabDetail.Title %>"
                                    BodyStyle="padding: 0px;" AutoScroll="false">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout4" runat="server">
                                            <ext:GridPanel ID="GridPanel3" runat="server" Title="<%$ Resources: GridPanel2.Title %>"
                                                StoreID="ConsignmentDetailStore" StripeRows="true" Border="false" Icon="Lorry"
                                                ClicksToEdit="1" EnableHdMenu="false" Header="false">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar2" runat="server">
                                                        <Items>
                                                            <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                            <ext:Button ID="Button1" runat="server" Text="<%$ Resources: GridPanel2.AddItemsButton.Text %>"
                                                                Icon="Add">
                                                                <AjaxEvents>
                                                                    <Click OnEvent="ShowDialog" Failure="Ext.MessageBox.alert(MsgList.AddItemsButton.FailureTitle, MsgList.AddItemsButton.FailureMsg);">
                                                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{DetailWindow}.body}"
                                                                            Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                                                                        <ExtraParams>
                                                                            <ext:Parameter Name="AdjustId" Value="#{hiddenAdjustId}.getValue()" Mode="Raw">
                                                                            </ext:Parameter>
                                                                        </ExtraParams>
                                                                    </Click>
                                                                </AjaxEvents>
                                                            </ext:Button>
                                                        </Items>
                                                    </ext:Toolbar>
                                                </TopBar>
                                                <ColumnModel ID="ColumnModel4" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="CFNEnglishName" DataIndex="CFNEnglishName" Header="<%$ Resources: CFNEnglishName %>"
                                                            Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CFNChineseName" DataIndex="CFNChineseName" Header="<%$ Resources:CFNChineseName %>"
                                                            Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CFN" DataIndex="CFN" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                            Width="90">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UPN" DataIndex="UPN" Header="<%$ Resources: GridPanel2.ColumnModel2.UPN.Header %>"
                                                            Width="90" Hidden="<%$ AppSettings: HiddenUPN  %>">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel2.ColumnModel2.LotNumber.Header %>"
                                                            Width="80">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources: GridPanel2.ColumnModel2.ExpiredDate.Header %>"
                                                            Width="50">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources: GridPanel2.ColumnModel2.UnitOfMeasure.Header %>"
                                                            Width="40" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="<%$ Resources: GridPanel2.ColumnModel2.TotalQty.Header %>"
                                                            Width="60" Align="Right">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CreatedDate" DataIndex="CreatedDate" Header="<%$ Resources: GridPanel2.ColumnModel2.CreatedDate.Header %>"
                                                            Width="80">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Ymd')" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="AdjustQty" DataIndex="AdjustQty" Header="<%$ Resources: GridPanel2.ColumnModel2.AdjustQty.Header %>"
                                                            Width="50" Align="Right">
                                                            <Editor>
                                                                <ext:NumberField ID="nfAdjustQty" runat="server" AllowBlank="false" AllowDecimals="true"
                                                                    DataIndex="AdjustQty" SelectOnFocus="true" AllowNegative="false">
                                                                </ext:NumberField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="PurchaseOrderNbr" DataIndex="PurchaseOrderNbr" Header="<%$ Resources: GridPanel2.ColumnModel2.PurchaseOrderNbr.Header %>"
                                                            Align="Center" Width="150">
                                                            <Editor>
                                                                <ext:ComboBox ID="cbPurchaseOrderNbrConsignment" runat="server" Width="200" Editable="true"
                                                                    TypeAhead="true" Mode="Local" StoreID="PurchaseOrderStore" ValueField="Id" DisplayField="PurchaseOrderNbr"
                                                                    AllowBlank="true" ListWidth="300" Resizable="true">
                                                                </ext:ComboBox>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="转移经销商" Align="Center"
                                                            Width="150">
                                                            <Editor>
                                                                <%--<ext:ComboBox ID="cbToDealer" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                                Mode="Local" StoreID="ToDealerStore" ValueField="Id" DisplayField="ChineseName"
                                                                AllowBlank="false" ListWidth="200" Resizable="true">
                                                            </ext:ComboBox>--%>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="50" Header="<%$ Resources: GridPanel2.ColumnModel2.CommandColumn.Header %>"
                                                            Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources: GridPanel2.ColumnModel2.CommandColumn.GridCommand.ToolTip-Text %>" />
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server"
                                                        MoveEditorOnEnter="true">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBarConsignment" runat="server" PageSize="15" StoreID="ConsignmentDetailStore"
                                                        DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                                </BottomBar>
                                                <SaveMask ShowMask="true" />
                                                <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                                                <Listeners>
                                                    <Command Handler="if (command == 'Delete'){
                                                        Coolite.AjaxMethods.DeleteConsignmentItem(this.getSelectionModel().getSelected().id,{failure: function(err) {Ext.Msg.alert(MsgList.Error, err);}});
                                                    }" />
                                                    <ValidateEdit Fn="CheckConsignmentQty" />
                                                    <BeforeEdit Handler="#{hiddenCurrentEdit}.setValue(this.getSelectionModel().getSelected().id);
                                                            #{nfAdjustQty}.setValue(this.getSelectionModel().getSelected().data.AdjustQty);
                                                            #{hiddenPmaId}.setValue(this.getSelectionModel().getSelected().data.PmaId);
                                                            #{hiddenLotNumber}.setValue(this.getSelectionModel().getSelected().data.LotNumber);
                                                            #{PurchaseOrderStore}.reload();
                                                           
                                                            #{cbPurchaseOrderNbrConsignment}.setValue(this.getSelectionModel().getSelected().data.PurchaseOrderNbr);                                                            
                                                            #{ToDealerStore}.reload();
                                                            #{cbToDealer}.setValue(this.getSelectionModel().getSelected().data.ChineseName);
                                                " />
                                                    <AfterEdit Handler="Coolite.AjaxMethods.SaveConsignmentItem(#{nfAdjustQty}.getValue(),#{cbPurchaseOrderNbrConsignment}.getValue(),#{cbToDealer}.getValue(),{success:function(){#{hiddenIsEditting}.setValue('');},failure: function(err) {Ext.Msg.alert(MsgList.Error, err);}});" />
                                                </Listeners>
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
                                                                                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=AdjustAttachment';
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
                                <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources: TabLog.Title %>" AutoScroll="false">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout3" runat="server">
                                            <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore"
                                                StripeRows="true" Border="false" Icon="Lorry" ClicksToEdit="1" EnableHdMenu="false"
                                                Header="false" AutoExpandColumn="OperNote">
                                                <ColumnModel ID="ColumnModel3" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="<%$ Resources: gpLog.OperUserId %>"
                                                            Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources: gpLog.OperUserName %>"
                                                            Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="<%$ Resources: gpLog.OperTypeName %>"
                                                            Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="<%$ Resources: gpLog.OperDate %>"
                                                            Width="150">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources: gpLog.OperNote %>">
                                                        </ext:Column>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                        MoveEditorOnEnter="true">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="15" StoreID="OrderLogStore"
                                                        DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                                </BottomBar>
                                                <SaveMask ShowMask="false" />
                                                <LoadMask ShowMask="true" />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                            </Tabs>
                        </ext:TabPanel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="DraftButton" runat="server" Text="<%$ Resources: DetailWindow.DraftButton.Text %>"
                    Icon="Add">
                    <Listeners>
                        <Click Handler="CheckDraft();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="DeleteButton" runat="server" Text="<%$ Resources: DetailWindow.DeleteButton.Text %>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.DeleteDraft({
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                            },
                            failure: function(err) {
                                Ext.Msg.alert(MsgList.Error, err);
                            }
                        });" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="SubmitButton" runat="server" Text="<%$ Resources: DetailWindow.SubmitButton.Text %>"
                    Icon="LorryAdd">
                    <Listeners>
                        <Click Handler="CheckSubmit();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="RevokeButton" runat="server" Text="<%$ Resources: DetailWindow.RevokeButton.Text %>"
                    Icon="Cancel">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.DoRevoke({
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                            },
                            failure: function(err) {
                                Ext.Msg.alert(MsgList.Error, err);
                            }
                        });" />
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
                        <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="50">
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

        <uc2:InventoryAdjustDialog ID="InventoryAdjustDialog1" runat="server" />
        <%--    <uc1:InventoryAdjustEditor ID="InventoryAdjustEditor1" runat="server" />--%>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
