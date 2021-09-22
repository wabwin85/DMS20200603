<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrderDetailWindow.ascx.cs"
    Inherits="DMS.Website.Controls.OrderDetailWindow" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
<style type="text/css">
    .x-form-empty-field {
        color: #bbbbbb;
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }

    .x-small-editor .x-form-field {
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }

    .x-small-editor .x-form-text {
        height: 20px;
        line-height: 16px;
        vertical-align: middle;
    }

    .editable-column {
        background: #FFFF99;
    }

    .nonEditable-column {
        background: #FFFFFF;
    }

    .yellow-row {
        background: #FFD700;
    }

    .lablered {
        color: red;
    }

    .lableblack {
        color: black;
    }
</style>

<script type="text/javascript" language="javascript">
    var odwMsgList = {
        msg1: "<%=GetLocalResourceObject("ValidateForm.confirm.Body").ToString()%>",
        msg2: "<%=GetLocalResourceObject("btnCopy.OrderDetailWindow.Copy.Message").ToString()%>",
        msg3: "<%=GetLocalResourceObject("Revoke.Alert.Title").ToString()%>"
    }
    //初次载入详细信息窗口时读取数据
    function RefreshDetailWindow() {
        //Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
        Ext.getCmp('<%=this.PagingToolBar2.ClientID%>').changePage(1);
        Ext.getCmp('<%=this.gpLog.ClientID%>').reload();
        Ext.getCmp('<%=this.gpAttachment.ClientID%>').store.reload();

        Ext.getCmp('<%=this.cbOrderType.ClientID%>').store.reload();
        Ext.getCmp('<%=this.cbDealer.ClientID%>').store.reload();
        Ext.getCmp('<%=this.cbProductLine.ClientID%>').store.reload();
        Ext.getCmp('<%=this.cbPointType.ClientID%>').store.reload();
    }
    //重新读取明细行
    function ReloadDetail() {
        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
    }

    //表单验证
    function ValidateForm() {
        var errMsg = "";
        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
        var rtnRegMsg = Ext.getCmp('<%=this.hidRtnRegMsg.ClientID%>');

        var isForm1Valid = Ext.getCmp('<%=this.FormPanel1.ClientID%>').getForm().isValid();
        var isForm2Valid = Ext.getCmp('<%=this.FormPanel2.ClientID%>').getForm().isValid();

        var tabPanel = Ext.getCmp('<%=this.TabPanel1.ClientID%>')
        var txtRemark = Ext.getCmp('<%=this.txtRemark.ClientID%>');
        var dtRDD = Ext.getCmp('<%=this.dtRDD.ClientID%>');

        var cbWarehouse = Ext.getCmp('<%=this.cbWarehouse.ClientID%>');
        var cbOrderType = Ext.getCmp('<%=this.cbOrderType.ClientID%>');
        var hidpaymentType = Ext.getCmp('<%=this.hidpaymentType.ClientID%>');
        var hidpayment = Ext.getCmp('<%=this.hidpayment.ClientID%>');
        var hidPointCheckErr = Ext.getCmp('<%=this.hidPointCheckErr.ClientID%>');

        if (cbOrderType.getValue() != 'SCPO' && cbWarehouse.getValue() == '') {
            errMsg += '请选择收货仓库！';
        }
        debugger
        if (!isForm1Valid || !isForm2Valid) {
            errMsg = "<%=GetLocalResourceObject("ValidateForm.errMsgForm").ToString()%>";
        }
        if (txtRemark.getValue().length > 200) {
            errMsg += '<%=GetLocalResourceObject("ValidateForm.errMsgConst").ToString()%>';
        }
        var hidProductLine = Ext.getCmp('<%=this.hidProductLine.ClientID%>');

        var hidVenderId = Ext.getCmp('<%=this.hidVenderId.ClientID%>');

        //Edit By SongWeiming on 2017-04-18 去除RSM的选择
<%--        var cbSales =  Ext.getCmp('<%=this.cbSales.ClientID%>');
        if (hidProductLine.getValue() == '8f15d92a-47e4-462f-a603-f61983d61b7b' && cbSales.getValue() == '' && (hidVenderId.getValue() == "a00fcd75-951d-4d91-8f24-a29900da5e85" || hidVenderId.getValue() == "84c83f71-93b4-4efd-ab51-12354afabac3")) {
            errMsg += '请选择RSM！';
        }--%>

        var cbpaymentTpype = Ext.getCmp('<%=this.cbpaymentTpype.ClientID%>');
        if (hidpaymentType.getValue() == "true" && hidpayment.getValue() == "") {
            errMsg += '请选择付款方式';
        }
        else if (hidpaymentType.getValue() != "true" && hidpayment.getValue() == "第三方付款") {
            errMsg += '没有融资准入资格的经销商不能选择第三方付款';
        }

        //alert(typeof(dtRDD.getValue().length) == "undefined");
        //当选择了日期，判断选择的日期不能大于当前提交日期18天
        //if (typeof(dtRDD.getValue().length) == "undefined"){
        //    var d = new Date();//当前时间
        //    var t = new Date(d.getFullYear(),d.getMonth(),d.getDate()).getTime() + 18*24*60*60*1000;//加上18天时间戳
        //    d.setTime(t);
        //    if (dtRDD.getValue() > d){
        //        errMsg += '<%=GetLocalResourceObject("ValidateForm.errMsgConst1").ToString()%>';
        //    }
        //}

        if (errMsg != "") {
            tabPanel.setActiveTab(0);
            Ext.Msg.alert('Message', errMsg);
        } else {
            hidPointCheckErr.setValue("0");
            if (cbOrderType.getValue() == '<%=PurchaseOrderType.CRPO.ToString() %>') {
                Coolite.AjaxMethods.OrderDetailWindow.CaculateFormValuePoint({
                    success: function (result) {
                        if (hidPointCheckErr.getValue() == "1") {
                            Ext.Msg.alert('errMsg', result + "不能提交该订单。");
                            return false;
                        } else {
                             Ext.Msg.confirm('Message', odwMsgList.msg1,
                                    function (e) {
                                        if (e == 'yes') {
                                            Coolite.AjaxMethods.OrderDetailWindow.CheckSubmit(
                                                        {
                                                            success: function () {
                                                                if (rtnVal.getValue() == "Success") {
                                                                    Coolite.AjaxMethods.OrderDetailWindow.Submit(
                                                                    {
                                                                        success: function () {
                                                                            Ext.Msg.alert('Message', '<%=GetLocalResourceObject("ValidateForm.Submit.alert.Body").ToString()%>');
                                                                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                                            RefreshMainPage();
                                                                        },
                                                                        failure: function (err) {
                                                                            Ext.Msg.alert('Error', err);
                                                                        }
                                                                    }
                                                                );
                                                                } else if (rtnVal.getValue() == "Error") {
                                                                    tabPanel.setActiveTab(1);
                                                                    Ext.Msg.alert('Error', rtnMsg.getValue());
                                                                } else if (rtnVal.getValue() == "Warn") {
                                                                    tabPanel.setActiveTab(1);
                                                                    Ext.Msg.confirm('Warning', rtnMsg.getValue(),
                                                                        function (e) {
                                                                            if (e == 'yes') {
                                                                                Coolite.AjaxMethods.OrderDetailWindow.Submit(
                                                                                {
                                                                                    success: function () {
                                                                                        Ext.Msg.alert('Message', '<%=GetLocalResourceObject("ValidateForm.Submit.alert.Body").ToString()%>');
                                                                                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                                                            RefreshMainPage();
                                                                                        },
                                                                                        failure: function (err) {
                                                                                            Ext.Msg.alert('Error', err);
                                                                                        }
                                                                                    }
                                                                            );
                                                                                }
                                                                            }
                                                                );
                                                                        }
                                                            },
                                                            failure: function (err) {
                                                                Ext.Msg.alert('Error', err);
                                                            }
                                                        }
                                                );
                                                    }
                                    });
                        }
                    }
                })
            }
            else{
            Ext.Msg.confirm('Message', odwMsgList.msg1,
                                    function (e) {
                                        if (e == 'yes') {
                                            Coolite.AjaxMethods.OrderDetailWindow.CheckSubmit(
                                                        {
                                                            success: function () {
                                                                if (rtnVal.getValue() == "Success") {
                                                                    Coolite.AjaxMethods.OrderDetailWindow.Submit(
                                                                    {
                                                                        success: function () {
                                                                            Ext.Msg.alert('Message', '<%=GetLocalResourceObject("ValidateForm.Submit.alert.Body").ToString()%>');
                                                                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                                            RefreshMainPage();
                                                                        },
                                                                        failure: function (err) {
                                                                            Ext.Msg.alert('Error', err);
                                                                        }
                                                                    }
                                                                );
                                                                } else if (rtnVal.getValue() == "Error") {
                                                                    tabPanel.setActiveTab(1);
                                                                    Ext.Msg.alert('Error', rtnMsg.getValue());
                                                                } else if (rtnVal.getValue() == "Warn") {
                                                                    tabPanel.setActiveTab(1);
                                                                    Ext.Msg.confirm('Warning', rtnMsg.getValue(),
                                                                        function (e) {
                                                                            if (e == 'yes') {
                                                                                Coolite.AjaxMethods.OrderDetailWindow.Submit(
                                                                                {
                                                                                    success: function () {
                                                                                        Ext.Msg.alert('Message', '<%=GetLocalResourceObject("ValidateForm.Submit.alert.Body").ToString()%>');
                                                                                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                                                            RefreshMainPage();
                                                                                        },
                                                                                        failure: function (err) {
                                                                                            Ext.Msg.alert('Error', err);
                                                                                        }
                                                                                    }
                                                                            );
                                                                                }
                                                                            }
                                                                );
                                                                        }
                                                            },
                                                            failure: function (err) {
                                                                Ext.Msg.alert('Error', err);
                                                            }
                                                        }
                                                );
                                                    }
                                    });
            }

                                            }
                                        }

                                        //window hide前提示是否需要保存数据
                                        var NeedSave = function () {
                                            var isModified = Ext.getCmp('<%=this.hidIsModified.ClientID%>').getValue() == "True" ? true : false;
                    var isPageNew = Ext.getCmp('<%=this.hidIsPageNew.ClientID%>').getValue() == "True" ? true : false;
                    var isSaved = Ext.getCmp('<%=this.hidIsSaved.ClientID%>').getValue() == "True" ? true : false;
                    //alert("isModified=" + isModified + " isPageNew=" + isPageNew + " isSaved=" + isSaved);
                    if (!isSaved) {
                        if (isModified) {
                            Ext.Msg.confirm('Warning', '<%=GetLocalResourceObject("NeedSave.confirm.Body").ToString()%>',
                    function (e) {
                        if (e == 'yes') {
                            Coolite.AjaxMethods.OrderDetailWindow.SaveDraft(
                            {
                                success: function () {
                                    Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                    RefreshMainPage();
                },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                    }
                }
                );
        } else {
            if (isPageNew) {
                Coolite.AjaxMethods.OrderDetailWindow.DeleteDraft(
                {
                    success: function () {
                        Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                    RefreshMainPage();
                },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                    }
                }
                );
        } else {
            Ext.getCmp('<%=this.hidIsSaved.ClientID%>').setValue("True");
                    Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                }
            }
                });
        return false;
    } else if (isPageNew) {
        Coolite.AjaxMethods.OrderDetailWindow.DeleteDraft(
        {
            success: function () {
                Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                    RefreshMainPage();
                },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                    }
                }
                );
            return false;
        }
}
                }

//设置是否需要保存
var SetModified = function (isModified) {
    Ext.getCmp('<%=this.hidIsModified.ClientID%>').setValue(isModified ? "True" : "False");
}

//变更产品线
var ChangeProductLine = function () {
    var cbProductLine = Ext.getCmp('<%=this.cbProductLine.ClientID%>');
    var hidProductLine = Ext.getCmp('<%=this.hidProductLine.ClientID%>');
    var hidTerritoryCode = Ext.getCmp('<%=this.hidTerritoryCode.ClientID%>');

    //alert("ChangeProductLine");
    if (hidProductLine.getValue() != cbProductLine.getValue()) {
        Ext.Msg.confirm('Warning', '<%=GetLocalResourceObject("ChangeProductLine.confirm.Body").ToString()%>',
                        function (e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.OrderDetailWindow.ChangeProductLine(
                                {
                                    success: function () {
                                        hidProductLine.setValue(cbProductLine.getValue());
                                        hidTerritoryCode.setValue('');
                                        SetModified(true);
                                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').enable();

                                        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();

                                        //Edit By SongWeiming on 2017-04-18 去除RSM的选择
<%--                                        SetSalesAccount();
                                        Ext.getCmp('<%=this.cbSales.ClientID%>').store.reload();--%>

                                        clearItems();
                                    },
                                    failure: function (err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                                );
                            }
                            else {
                                cbProductLine.setValue(hidProductLine.getValue());
                                Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

                            }
                        }
                    );
                    } else {
                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

    }
}
var ChangePointType = function () {

    var cbPointType = Ext.getCmp('<%=this.cbPointType.ClientID%>');
    var hidPointType = Ext.getCmp('<%=this.hidPointType.ClientID%>');

    if (hidPointType.getValue() != cbPointType.getValue()) {
        Ext.Msg.confirm('Warning', '变更积分类型将删除原有产品',
                    function (e) {
                        if (e == 'yes') {
                            Coolite.AjaxMethods.OrderDetailWindow.ChangePointType(
                            {
                                success: function () {

                                    hidPointType.setValue(cbPointType.getValue());

                                    SetModified(true);
                                    Ext.getCmp('<%=this.Toolbar1.ClientID%>').enable();
                                        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
                                        clearItems();
                                    },
                                    failure: function (err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                                );
                            }
                            else {
                                cbPointType.setValue(hidPointType.getValue());
                                Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);
                            }
                        }
                    );
                    } else {
                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);
        }
}

    //变更订单类型
    var ChangeOrderType = function () {
        var cbOrderType = Ext.getCmp('<%=this.cbOrderType.ClientID%>');
        var hidOrderType = Ext.getCmp('<%=this.hidOrderType.ClientID%>');
        var hidWarehouse = Ext.getCmp('<%=this.hidWarehouse.ClientID%>');
        var hidWareHouseType = Ext.getCmp('<%=this.hidWareHouseType.ClientID%>');
        var hidPointType = Ext.getCmp('<%=this.hidPointType.ClientID%>')
        var cbPointType = Ext.getCmp('<%=this.cbPointType.ClientID%>');
        var gpDetail = Ext.getCmp('<%=this.gpDetail.ClientID%>');
        //alert("ChangeOrderType");
        if (hidOrderType.getValue() != cbOrderType.getValue()) {
            Ext.Msg.confirm('Warning', '<%=GetLocalResourceObject("ChangeOrderType.confirm.Body").ToString()%>',
                        function (e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.OrderDetailWindow.ChangeOrderType(
                                {
                                    success: function () {
                                        hidOrderType.setValue(cbOrderType.getValue());
                                        hidWarehouse.setValue('');
                                        SetWarehosueType();
                                        SetModified(true);
                                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').enable();
                                        if (cbOrderType.getValue() == 'CRPO') {
                                            gpDetail.getColumnModel().setHidden(14, false);
                                            //gpDetail.getColumnModel().setHidden(15, false);
                                            cbPointType.show();
                                        } else {
                                            gpDetail.getColumnModel().setHidden(14, true);
                                            //gpDetail.getColumnModel().setHidden(15, false);
                                            cbPointType.hide();
                                        }
                                        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
                                        Ext.getCmp('<%=this.cbWarehouse.ClientID%>').store.reload();
                                        clearItems();
                                    },
                                    failure: function (err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                                );
                            }
                            else {
                                cbOrderType.setValue(hidOrderType.getValue());
                                Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

                            }
                        }
                    );
                    } else {
                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

        }
    }

    //屏蔽刷新Store时的提示
    var StoreCommitAll = function (store) {
        for (var i = 0; i < store.getCount() ; i++) {
            var record = store.getAt(i);
            if (record.dirty) {
                record.commit();
            }
        }
    }

    var ShowEditingMask = function () {
        var win = Ext.getCmp('<%=this.DetailWindow.ClientID%>');
     win.body.mask('<%=GetLocalResourceObject("ShowEditingMask.mask").ToString()%>', 'x-mask-loading');
     SetWinBtnDisabled(win, true);
 }

 var SetWinBtnDisabled = function (win, disabled) {
     for (var i = 0; i < win.buttons.length; i++) {
         win.buttons[i].setDisabled(disabled);
     }
 }

 //订单类型加载时刷新
 function OrderTypeStoreLoad() {
     var hidIsPageNew = Ext.getCmp('<%=this.hidIsPageNew.ClientID%>');
        var cbOrderType = Ext.getCmp('<%=this.cbOrderType.ClientID%>');
        var hidOrderType = Ext.getCmp('<%=this.hidOrderType.ClientID%>');
        var cbWarehouse = Ext.getCmp('<%=this.cbWarehouse.ClientID%>');
        var hidWareHouseType = Ext.getCmp('<%=this.hidWareHouseType.ClientID%>');

        if (hidIsPageNew.getValue() == 'True') {
            cbOrderType.setValue(cbOrderType.store.getTotalCount() > 0 ? cbOrderType.store.getAt(0).get('Key') : '');
            hidOrderType.setValue(cbOrderType.getValue());
        } else {
            cbOrderType.setValue(hidOrderType.getValue());
        }

        SetWarehosueType();
        cbWarehouse.store.reload();
        IsShowpayment();
    }

    //根据选择的订单类型，设定仓库类型、价格类型
    function SetWarehosueType() {
        var cbOrderType = Ext.getCmp('<%=this.cbOrderType.ClientID%>');
        var hidWareHouseType = Ext.getCmp('<%=this.hidWareHouseType.ClientID%>');
        var hidPriceType = Ext.getCmp('<%=this.hidPriceType.ClientID%>');


        if (cbOrderType.getValue() == '<%=PurchaseOrderType.Normal.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.Exchange.ToString() %>') {
            hidWareHouseType.setValue('Normal');
            hidPriceType.setValue('Dealer');
        }
        else if (cbOrderType.getValue() == '<%=PurchaseOrderType.Consignment.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.ConsignmentSales.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.SCPO.ToString() %>') {
            hidWareHouseType.setValue('Consignment');
            hidPriceType.setValue('DealerConsignment');
        }
        else if (cbOrderType.getValue() == '<%=PurchaseOrderType.PRO.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.CRPO.ToString() %>') {
            hidWareHouseType.setValue('Normal');
            hidPriceType.setValue('Base');
        }
        else {
            hidWareHouseType.setValue('Normal');
            hidPriceType.setValue('Dealer');
        }
}

var SetCellCssEditable = function (v, m) {
    m.css = "editable-column";
    return v;
}

var SetCellCssNonEditable = function (v, m) {
    m.css = "";
    return v;
}

function getCurrentInvRowClass(record, index) {
    var orderStatus = Ext.getCmp('<%=this.hidOrderStatus.ClientID%>');
    if (orderStatus.getValue() == '<%=PurchaseOrderStatus.Delivering.ToString() %>' || orderStatus.getValue() == '<%=PurchaseOrderStatus.Completed.ToString() %>' || orderStatus.getValue() == '<%=PurchaseOrderStatus.ApplyComplete.ToString() %>') {

        if (record.data.ReceiptQty < record.data.RequiredQty) {
            return 'yellow-row';
        }
    }
}

var CheckQty = function () {
    var hidEditItemId = Ext.getCmp('<%=this.hidEditItemId.ClientID%>');
    var txtRequiredQty = Ext.getCmp('<%=this.txtRequiredQty.ClientID%>');
    var grid = Ext.getCmp('<%=this.gpDetail.ClientID%>');
    var record = grid.store.getById(hidEditItemId.getValue());

    //根据转换率判断是否有小数位
    if (accMul(txtRequiredQty.getValue(), 1000000) % accDiv(1, record.data.ConvertFactor).mul(1000000) != 0) {
        hidEditItemId.setValue('');
        Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body").ToString()%>' + accDiv(1, record.data.ConvertFactor).toString());
        return false;
    }
    return true;
}
//订单加载后判断是否显示付款方式
function IsShowpayment() {
    var hidpaymentType = Ext.getCmp('<%=this.hidpaymentType.ClientID%>');
     var cbpaymentTpype = Ext.getCmp('<%=this.cbpaymentTpype.ClientID%>');
     Coolite.AjaxMethods.OrderDetailWindow.IsShowpaymentType(
    {

        success: function () {

        },
        failure: function (err) {
            Ext.Msg.alert('Error', err);
        }
    }
     )
 }
 function cbpaymentChanges() {
     var cbpaymentTpype = Ext.getCmp('<%=this.cbpaymentTpype.ClientID%>');
        var hidpayment = Ext.getCmp('<%=this.hidpayment.ClientID%>');
        hidpayment.setValue(cbpaymentTpype.getValue());
    }
    function cbpayment1Changes() {
        var cbpaymentTpype1 = Ext.getCmp('<%=this.cbpaymentTpype1.ClientID%>');
        var hidpayment = Ext.getCmp('<%=this.hidpayment.ClientID%>');
        hidpayment.setValue(cbpaymentTpype1.getValue());

    }

    function downloadfile(url) {
        var iframe = document.createElement("iframe");
        iframe.src = url;
        iframe.style.display = "none";
        document.body.appendChild(iframe);
    }
    <%-- var SetSalesAccount = function(){
         var hidProductLine = Ext.getCmp('<%=this.hidProductLine.ClientID%>');
         var hidVenderId = Ext.getCmp('<%=this.hidVenderId.ClientID%>');
         if(hidProductLine.getValue() == '8f15d92a-47e4-462f-a603-f61983d61b7b' && (hidVenderId.getValue() == "a00fcd75-951d-4d91-8f24-a29900da5e85" || hidVenderId.getValue() =="84c83f71-93b4-4efd-ab51-12354afabac3")){Ext.getCmp('<%=this.cbSales.ClientID%>').show();
         }
        else{Ext.getCmp('<%=this.cbSales.ClientID%>').hide();
        }
    }--%>
</script>

<ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="PohId" />
                <ext:RecordField Name="CfnId" />
                <ext:RecordField Name="CustomerFaceNbr" />
                <ext:RecordField Name="CfnChineseName" />
                <ext:RecordField Name="CfnEnglishName" />
                <ext:RecordField Name="CfnPrice" />
                <ext:RecordField Name="Uom" />
                <ext:RecordField Name="RequiredQty" />
                <ext:RecordField Name="Amount" />
                <ext:RecordField Name="ReceiptQty" />
                <ext:RecordField Name="LotNumber" />
                <ext:RecordField Name="ConvertFactor" />
                <ext:RecordField Name="CurRegNo" />
                <ext:RecordField Name="CurValidDateFrom" />
                <ext:RecordField Name="CurValidDataTo" />
                <ext:RecordField Name="CurManuName" />
                <ext:RecordField Name="LastRegNo" />
                <ext:RecordField Name="LastValidDateFrom" />
                <ext:RecordField Name="LastValidDataTo" />
                <ext:RecordField Name="LastManuName" />
                <ext:RecordField Name="CurGMKind" />
                <ext:RecordField Name="CurGMCatalog" />
                <ext:RecordField Name="PointAmount" />
                <ext:RecordField Name="RedInvoicesAmount" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
        <Load Handler="#{DetailWindow}.body.unmask();" />
        <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
    </Listeners>
</ext:Store>
<ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData"
    AutoLoad="false">
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
<ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine"
    AutoLoad="false">
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
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbProductLine}.setValue(#{cbProductLine}.store.getTotalCount()>0?#{cbProductLine}.store.getAt(0).get('Id'):'');#{hidProductLine}.setValue(#{cbProductLine}.getValue());}else{#{cbProductLine}.setValue(#{hidProductLine}.getValue());}" />

    </Listeners>
    <SortInfo Field="Id" Direction="ASC" />
</ext:Store>
<ext:Store ID="OrderTypeStore" runat="server" UseIdConfirmation="true" OnRefreshData="OrderTypeStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Key">
            <Fields>
                <ext:RecordField Name="Key" />
                <ext:RecordField Name="Value" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <BaseParams>
    </BaseParams>
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){OrderTypeStoreLoad();}else{OrderTypeStoreLoad();}" />
    </Listeners>
</ext:Store>
<ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_DealerList"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="ChineseName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbDealer}.setValue(#{hidDealerId}.getValue());" />
    </Listeners>
    <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
</ext:Store>
<ext:Store ID="WarehouseStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_WarehouseByDealer"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Address" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <BaseParams>
        <ext:Parameter Name="DealerId" Value="#{hidDealerId}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{hidDealerId}.getValue()"
            Mode="Raw" />
        <ext:Parameter Name="DealerWarehouseType" Value="#{hidWareHouseType}.getValue()"
            Mode="Raw" />
    </BaseParams>
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWarehouse}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Id'):'');#{txtShipToAddress}.setValue(#{cbWarehouse}.store.getAt(0).get('Address'));}else{#{cbWarehouse}.setValue(#{hidWarehouse}.getValue());}" />
        <LoadException Handler="Ext.Msg.alert('Warehouse - Load failed', e.message || response.statusText);" />
    </Listeners>
</ext:Store>
<%--<ext:Store ID="SalesStore" runat="server" UseIdConfirmation="true" OnRefreshData="SalesStore_RefershData" AutoLoad="false">
    <Reader>
        <ext:JsonReader ReaderID="UserAccount">
            <Fields>
                <ext:RecordField Name="UserAccount" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbSales}.setValue(#{hidSalesAccount}.getValue());" />
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbSales}.setValue(#{cbSales}.store.getTotalCount()>0?#{cbSales}.store.getAt(0).get('UserAccount'):'');}else{#{cbSales}.setValue(#{hidSalesAccount}.getValue());" />
        <LoadException Handler="Ext.Msg.alert('RSM - Load failed', e.message || response.statusText);" />
    </Listeners>
</ext:Store>--%>
<ext:Store ID="PointTypeStore" runat="server" UseIdConfirmation="true" OnRefreshData="PointTypeStore_RefershData"
    AutoLoad="false">
    <Reader>
        <ext:JsonReader ReaderID="Key">
            <Fields>
                <ext:RecordField Name="Key" />
                <ext:RecordField Name="Value" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbPointType}.setValue(#{cbPointType}.store.getTotalCount()>0?#{cbPointType}.store.getAt(0).get('Key'):'');#{hidPointType}.setValue(#{cbPointType}.getValue());}else{#{cbPointType}.setValue(#{hidPointType}.getValue());}" />
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
<%--<ext:Store ID="TerritoryStore" runat="server" UseIdConfirmation="true" OnRefreshData="TerritoryStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Code">
            <Fields>
                <ext:RecordField Name="Code" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True' || #{hidTerritoryCode}.getValue()==''){#{cbTerritory}.setValue(#{cbTerritory}.store.getTotalCount()>0?#{cbTerritory}.store.getAt(0).get('Code'):'');#{hidTerritoryCode}.setValue(#{cbTerritory}.getValue());}else{#{cbTerritory}.setValue(#{hidTerritoryCode}.getValue());}" />
    </Listeners>
    <SortInfo Field="Name" Direction="ASC" />
</ext:Store>--%>
<ext:Hidden ID="hidIsPageNew" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsModified" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsSaved" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidInstanceId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidDealerId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidProductLine" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidOrderStatus" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidEditItemId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidTerritoryCode" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnVal" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnMsg" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnRegMsg" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidLatestAuditDate" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidOrderType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWareHouseType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWarehouse" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPriceType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidVenderId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidpaymentType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPointType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidpayment" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPointCheckErr" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenFileName" runat="server">
</ext:Hidden>
<%--<ext:Hidden ID="hidSalesAccount" runat="server">
</ext:Hidden>--%>
<ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
    Width="980" Height="490" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:FormPanel ID="FormPanel1" runat="server" Header="false" Frame="true" AutoHeight="false"
                    Height="90">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".24">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                    <Body>
                                        <%--表头信息 --%>
                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <%--订单类型、订单编号、提交日期 --%>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbOrderType" runat="server" EmptyText="<%$ Resources: cbOrderType.EmptyText %>"
                                                    Width="120" Editable="false" TypeAhead="true" StoreID="OrderTypeStore" ValueField="Key"
                                                    AllowBlank="false" Mode="Local" DisplayField="Value" FieldLabel="<%$ Resources: txtOrderType.FieldLabel %>">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>"
                                                            HideTrigger="true" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                        <%--<Select Handler="#{hidOrderType}.setValue(#{cbOrderType}.getValue());" />--%>
                                                        <%--<Select Handler="#{btnAddCfn}.setDisabled(true);#{btnAddCfnSet}.setDisabled(true);ChangeOrderType();" />--%>
                                                        <Select Handler="#{Toolbar1}.setDisabled(true);ChangeOrderType();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderNo" runat="server" FieldLabel="<%$ Resources: txtOrderNo.FieldLabel %>"
                                                    Width="120" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbPointType" runat="server" EmptyText="请选择" Width="120" Editable="false" Hidden="true"
                                                    TypeAhead="true" StoreID="PointTypeStore" ValueField="Key" ListWidth="200" Mode="Local"
                                                    DisplayField="Value" FieldLabel="积分类型">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                        <Select Handler="#{Toolbar1}.setDisabled(true);ChangePointType();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".24">
                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <%--产品线、订单状态、财务信息 --%>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbProductLine" runat="server" Width="120" Editable="false" TypeAhead="true"
                                                    Disabled="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName"
                                                    FieldLabel="<%$ Resources: cbProductLine.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: cbProductLine.BlankText %>"
                                                    EmptyText="<%$ Resources: cbProductLine.EmptyText %>" ListWidth="200" Resizable="true">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>"
                                                            HideTrigger="true" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                        <%--<Select Handler="#{btnAddCfn}.setDisabled(true);#{btnAddCfnSet}.setDisabled(true);ChangeProductLine();" />--%>
                                                        <Select Handler="#{Toolbar1}.setDisabled(true);ChangeProductLine();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderStatus" runat="server" FieldLabel="<%$ Resources: txtOrderStatus.FieldLabel %>"
                                                    Width="120" />
                                            </ext:Anchor>
                                            <%-- <ext:Anchor>
                                                <ext:ComboBox ID="cbTerritory" runat="server" Width="120" Editable="false" TypeAhead="true"
                                                    Disabled="false" StoreID="TerritoryStore" ValueField="Code" DisplayField="Name"
                                                    FieldLabel="<%$ Resources: cbTerritory.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: cbTerritory.BlankText %>"
                                                    EmptyText="<%$ Resources: cbTerritory.EmptyText %>">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>"
                                                            HideTrigger="true" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                        <Select Handler="#{hidTerritoryCode}.setValue(#{cbTerritory}.getValue());" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>--%>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".3">
                                <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <%--经销商、订单对象、财务信息 --%>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbDealer" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                    StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName" FieldLabel="<%$ Resources: cbDealer.FieldLabel %>"
                                                    Mode="Local" AllowBlank="false" BlankText="<%$ Resources: cbDealer.BlankText %>"
                                                    EmptyText="<%$ Resources: cbDealer.EmptyText %>" ListWidth="300" Resizable="true">
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderTo" runat="server" FieldLabel="<%$ Resources: txtOrderTo.FieldLabel %>"
                                                    Width="200" />
                                            </ext:Anchor>
                                            <%--<ext:Anchor>
                                                <ext:Button ID="btnFinance" runat="server" Text="<%$ Resources: txtFinance.FieldLabel %>"
                                                    Flat="true" Icon="Information">
                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.OrderCfnSetDialog.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue(),#{hidDealerId}.getValue());" />
                                                    </Listeners>
                                                </ext:Button>
                                            </ext:Anchor>--%>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".22">
                                <ext:Panel ID="Panel17" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout23" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtSubmitDate" runat="server" FieldLabel="<%$ Resources: txtSubmitDate.FieldLabel %>"
                                                    Width="130" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbpaymentTpype" LabelStyle="color:red;font-weight:bold" runat="server" Width="130" TypeAhead="true" FieldLabel="付款方式"
                                                    BlankText="请选择" EmptyText="请选择付款方式" ListWidth="130" Resizable="true">
                                                    <Items>
                                                        <ext:ListItem Text="经销商付款" Value="经销商付款" />
                                                        <ext:ListItem Text="第三方付款" Value="第三方付款" />
                                                    </Items>
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();#{hidpayment}.setValue('');" />
                                                        <Select Handler="cbpaymentChanges();" />
                                                    </Listeners>
                                                </ext:ComboBox>

                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbpaymentTpype1" runat="server" Width="130" TypeAhead="true" FieldLabel="付款方式"
                                                    BlankText="请选择" EmptyText="请选择付款方式" ListWidth="130" Resizable="true">
                                                    <SelectedItem Text="经销商付款" Value="经销商付款" />
                                                    <Items>
                                                        <ext:ListItem Text="经销商付款" Value="经销商付款" />
                                                        <ext:ListItem Text="第三方付款" Value="第三方付款" />
                                                    </Items>
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();#{hidpayment}.setValue('');" />
                                                        <Select Handler="cbpayment1Changes();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbSales" runat="server" LabelStyle="color:red;font-weight:bold" Width="130" TypeAhead="true" ValueField="UserAccount" DisplayField="Name" FieldLabel="RSM"
                                                    BlankText="请选择" EmptyText="请选择RSM" ListWidth="200" Resizable="true" Visible="false">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>" />
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
                </ext:FormPanel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                    <Tabs>
                        <ext:Tab ID="TabHeader" runat="server" Title="<%$ Resources: TabHeader.Title %>"
                            BodyStyle="padding: 6px;" AutoScroll="true">
                            <%--表头信息 --%>
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout3" runat="server" Split="false">
                                                <ext:LayoutColumn ColumnWidth="0.3">
                                                    <ext:Panel ID="Panel4" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel4.Title %>">
                                                        <%--汇总信息 --%>
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left">
                                                                <ext:Anchor>
                                                                    <ext:NumberField ID="txtTotalAmount" runat="server" FieldLabel="<%$ Resources: txtTotalAmount.FieldLabel %>">
                                                                    </ext:NumberField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:NumberField ID="txtTotalQty" runat="server" FieldLabel="<%$ Resources: txtTotalQty.FieldLabel %>">
                                                                    </ext:NumberField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Label ID="lbRemark" runat="server" FieldLabel="<%$ Resources: lbRemark.FieldLabel %>">
                                                                    </ext:Label>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextArea ID="txtRemark" runat="server" Width="250" Height="120" HideLabel="true" />
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth="0.3">
                                                    <ext:Panel ID="Panel5" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel5.Title %>">
                                                        <%--订单信息 --%>
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left">
                                                                <%--订单联系人、联系方式、手机号码 --%>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtContactPerson" runat="server" Width="120" FieldLabel="<%$ Resources: txtContactPerson.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtContactPerson.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="100" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtContact" runat="server" Width="120" FieldLabel="<%$ Resources: txtContact.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtContact.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="100" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtContactMobile" runat="server" Width="120" FieldLabel="<%$ Resources: txtContactMobile.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtContactMobile.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="100" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Label ID="lbRejectReason" runat="server" FieldLabel="<%$ Resources: lbRejectReason.FieldLabel %>"
                                                                        HideLabel="true">
                                                                    </ext:Label>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextArea ID="txtRejectReason" runat="server" Width="250" Height="100" HideLabel="true" />
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth="0.4">
                                                    <ext:Panel ID="Panel10" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel10.Title %>">
                                                        <%-- 收货信息 --%>
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left">
                                                                <%--收货仓库选择、收货地址、收货人、收货人电话、期望到货时间、承运商 --%>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="cbWarehouse" runat="server" EmptyText="<%$ Resources: cbOrderType.EmptyText %>"
                                                                        Width="250" Editable="false" Disabled="false" TypeAhead="true" StoreID="WarehouseStore"
                                                                        ListWidth="300" ValueField="Id" AllowBlank="true" Mode="Local" DisplayField="Name"
                                                                        FieldLabel="<%$ Resources: cbWarehouse.FieldLabel %>">
                                                                        <Triggers>
                                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>"
                                                                                HideTrigger="true" />
                                                                        </Triggers>
                                                                        <Listeners>
                                                                            <TriggerClick Handler="this.clearValue();" />
                                                                            <Select Handler="#{hidWarehouse}.setValue(#{cbWarehouse}.getValue());#{txtShipToAddress}.setValue(#{cbWarehouse}.store.getById(#{cbWarehouse}.getValue()).get('Address'));" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtShipToAddress" runat="server" Width="250" FieldLabel="<%$ Resources: txtShipToAddress.FieldLabel %>"
                                                                        AllowBlank="false" BlankText="<%$ Resources: txtShipToAddress.BlankText %>" MsgTarget="Side">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtConsignee" runat="server" Width="150" FieldLabel="<%$ Resources: txtConsignee.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtConsignee.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="200" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtConsigneePhone" runat="server" Width="150" FieldLabel="<%$ Resources: txtConsigneePhone.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtConsigneePhone.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="200" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:DateField ID="dtRDD" runat="server" Width="150" FieldLabel="<%$ Resources: dtRDD.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: dtRDD.BlankText %>" MsgTarget="Side" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtCarrier" runat="server" Width="150" FieldLabel="<%$ Resources: txtCarrier.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtCarrier.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="200">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:FormPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TabDetail" runat="server" Title="<%$ Resources: TabDetail.Title %>"
                            AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FT1" runat="server">
                                    <ext:GridPanel ID="gpDetail" runat="server" Title="<%$ Resources: gpDetail.Title %>"
                                        StoreID="DetailStore" StripeRows="true" Border="false" Icon="Lorry" ClicksToEdit="1"
                                        EnableHdMenu="false" Header="false" AutoExpandColumn="CfnChineseName">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                    <%--<ext:Button ID="btnAvaiableProduct" runat="server" Text="<%$ Resources: btnAvaiableProduct.Text %>"
                                                    Icon="Information">
                                                    <Listeners>
                                                        <Click Handler="" />
                                                    </Listeners>
                                                </ext:Button>--%>
                                                    <%--<ext:Button ID="btnAddCfnSet" runat="server" Text="<%$ Resources: btnAddCfnSet.Text %>"
                                                    Icon="Add">
                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.OrderCfnSetDialog.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue(),#{hidDealerId}.getValue(),#{hidPriceType}.getValue(),#{hidOrderType}.getValue());" />
                                                    </Listeners>
                                                </ext:Button>--%>
                                                    <ext:Button ID="btnUserPoint" runat="server" Text="使用积分" Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{hidDealerId}.getValue() == '' || #{hidProductLine}.getValue() == ''|| #{hidPriceType}.getValue()=='' || #{hidOrderType}.getValue() =='') {alert('请等待数据加载完毕！');} else {if (#{hidOrderType}.getValue() =='CRPO') {Coolite.AjaxMethods.OrderDetailWindow.CaculateFormValuePoint({success:function(result){Ext.Msg.alert('信息',result); ReloadDetail();}, failure: function(err) {Ext.Msg.alert('Error', err);}})} else {alert('非积分订单不能使用积分！');}}" />
                                                        </Listeners>
                                                    </ext:Button>
                                                    <ext:Button ID="btnAddCfnSet" runat="server" Text="<%$ Resources: btnAddCfnSet.Text %>"
                                                        Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{hidDealerId}.getValue() == '' || #{hidProductLine}.getValue() == ''|| #{hidPriceType}.getValue()=='' || #{hidOrderType}.getValue() =='') {alert('请等待数据加载完毕！');} else {Coolite.AjaxMethods.OrderT2CfnSetDialog.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue(),#{hidDealerId}.getValue(),#{hidPriceType}.getValue(),#{hidOrderType}.getValue());}" />
                                                        </Listeners>
                                                    </ext:Button>
                                                    <ext:Button ID="btnAddCfn" runat="server" Text="<%$ Resources: btnAddCfn.Text %>"
                                                        Icon="Add">
                                                        <Listeners>
                                                            <%--<Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{hidDealerId}.getValue() == '' || #{hidProductLine}.getValue() == ''|| #{hidPriceType}.getValue()=='') {alert('请等待数据加载完毕！');} else {Coolite.AjaxMethods.OrderCfnDialog.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue(),#{hidDealerId}.getValue(),#{hidPriceType}.getValue()+'@'+#{cbOrderType}.getValue());}" />--%>
                                                            <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{hidDealerId}.getValue() == '' || #{hidProductLine}.getValue() == ''|| #{hidPriceType}.getValue()=='') {alert('请等待数据加载完毕！');} else {if (#{hidOrderType}.getValue() =='PRO') {Coolite.AjaxMethods.OrderCfnDialogT2PRO.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue(),#{hidDealerId}.getValue(),#{hidPriceType}.getValue()+'@'+#{cbOrderType}.getValue(),{success:function(){RefreshDetailCFNPROWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});} else{ Coolite.AjaxMethods.OrderCfnDialog.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue(),#{hidDealerId}.getValue(),#{hidPriceType}.getValue()+'@'+#{cbOrderType}.getValue()) ;}}" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CustomerFaceNbr" Width="120" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnEnglishName" Width="200" DataIndex="CfnEnglishName" Header="<%$ Resources: gpDetail.CfnEnglishName %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnChineseName" DataIndex="CfnChineseName" Header="<%$ Resources: gpDetail.CfnChineseName %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="RequiredQty" DataIndex="RequiredQty" Width="100" Header="<%$ Resources: gpDetail.RequiredQty %>">
                                                    <Editor>
                                                        <ext:NumberField ID="txtRequiredQty" runat="server" AllowBlank="false" AllowDecimals="true"
                                                            DataIndex="RequiredQty" SelectOnFocus="true" AllowNegative="false">
                                                        </ext:NumberField>
                                                    </Editor>
                                                    <%--<Renderer Fn="SetCellCss" />--%>
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnPrice" DataIndex="CfnPrice" Width="70" Header="<%$ Resources: gpDetail.CfnPrice %>">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Uom" DataIndex="Uom" Width="50" Header="<%$ Resources: gpDetail.Uom %>"
                                                    Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount" DataIndex="Amount" Width="100" Header="<%$ Resources: gpDetail.Amount %>">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                    <Editor>
                                                        <ext:NumberField ID="txtAmount" runat="server" AllowBlank="false" DataIndex="Amount"
                                                            SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                        </ext:NumberField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="ReceiptQty" DataIndex="ReceiptQty" Width="70" Header="<%$ Resources: gpDetail.ReceiptQty %>">
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="<%$ Resources: gpDetail.CommandColumn.Header %>"
                                                    Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources: gpDetail.CommandColumn.Header %>" />
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: gpDetail.LotNumber %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="CurRegNo" DataIndex="CurRegNo" Header="注册证编号-1" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="CurManuName" DataIndex="CurManuName" Header="生产企业(注册证-1)" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="LastRegNo" DataIndex="LastRegNo" Header="注册证编号-2" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="LastManuName" DataIndex="LastManuName" Header="生产企业(注册证-2)"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="PointAmount" DataIndex="PointAmount" Header="使用积分" Width="100"
                                                    Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="RedInvoicesAmount" DataIndex="RedInvoicesAmount" Header="使用额度"
                                                    Width="100" Hidden="true">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <View>
                                            <ext:GridView ID="GridView1" runat="server">
                                                <GetRowClass Fn="getCurrentInvRowClass" />
                                            </ext:GridView>
                                        </View>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <ValidateEdit Fn="CheckQty" />
                                            <Command Handler="ShowEditingMask();Coolite.AjaxMethods.OrderDetailWindow.DeleteItem(record.data.Id,{success:function(){ReloadDetail();SetWinBtnDisabled(#{DetailWindow},false);},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                            <BeforeEdit Handler="#{hidEditItemId}.setValue(this.getSelectionModel().getSelected().id);#{txtRequiredQty}.setValue(this.getSelectionModel().getSelected().data.RequiredQty);#{txtAmount}.setValue(this.getSelectionModel().getSelected().data.Amount);" />
                                            <AfterEdit Handler="ShowEditingMask();StoreCommitAll(this.store);Coolite.AjaxMethods.OrderDetailWindow.UpdateItem(#{txtRequiredQty}.getValue(),#{txtAmount}.getValue(),{success:function(){#{hidEditItemId}.setValue('');ReloadDetail();SetWinBtnDisabled(#{DetailWindow},false);},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="50" StoreID="DetailStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="false" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                            <Listeners>
                                <Activate Handler="Coolite.AjaxMethods.OrderDetailWindow.InitBtnCfnAdd();" />
                            </Listeners>
                        </ext:Tab>
                        <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources: TabLog.Title %>" AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FT2" runat="server">
                                    <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore"
                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                        Icon="Lorry" AutoExpandColumn="OperNote">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="<%$ Resources: gpLog.OperUserId %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources: gpLog.OperUserName %>"
                                                    Width="200">
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
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="50" StoreID="OrderLogStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TabAttachment" runat="server" Title="附件" Icon="BrickLink" AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FTAttachement" runat="server">
                                    <ext:GridPanel ID="gpAttachment" runat="server" Title="附件列表" StoreID="AttachmentStore" AutoWidth="true" StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" Header="false" AutoExpandColumn="Name">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar3" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill3" runat="server" />
                                                    <ext:Button ID="btnAddAttach" runat="server" Text="添加附件" Icon="Add" StyleSpec="margin-right:15px">
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
                                            <ext:PagingToolbar ID="PagingToolBarAttachement" runat="server" PageSize="50" StoreID="AttachmentStore" DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中……" />
                                        <Listeners>
                                            <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该附件文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.OrderDetailWindow.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            Ext.Msg.alert('Message', '删除附件成功！');
                                                                                            #{gpAttachment}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });                                                                                   
                                                                           
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
                                <Activate Handler="Coolite.AjaxMethods.OrderDetailWindow.InitBtnAddAttach();" />
                            </Listeners>
                        </ext:Tab>
                    </Tabs>
                </ext:TabPanel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Buttons>
        <ext:Button ID="btnSaveDraft" runat="server" Text="<%$ Resources: btnSaveDraft.Text %>"
            Icon="Add">
            <Listeners>
                <Click Handler="Coolite.AjaxMethods.OrderDetailWindow.SaveDraft({success:function(){#{DetailWindow}.hide();RefreshMainPage();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnDeleteDraft" runat="server" Text="<%$ Resources: btnDeleteDraft.Text %>"
            Icon="Delete">
            <Listeners>
                <Click Handler="
                    Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.OrderDetailWindow.DeleteDraft({success:function(){#{DetailWindow}.hide();RefreshMainPage();},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnSubmit" runat="server" Text="<%$ Resources: btnSubmit.Text %>"
            Icon="LorryAdd">
            <Listeners>
                <Click Handler="ValidateForm();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnCopy" runat="server" Text="<%$ Resources: btnCopy.Text %>" Icon="PageCopy">
            <Listeners>
                <Click Handler="Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.OrderDetailWindow.Copy({success:function(){#{DetailWindow}.hide();RefreshMainPage();Ext.Msg.alert('Message',odwMsgList.msg2);},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnRevoke" runat="server" Text="<%$ Resources: btnRevoke.Text %>"
            Icon="Decline">
            <Listeners>
                <Click Handler="Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.OrderDetailWindow.Revoke({success:function(){#{DetailWindow}.hide();RefreshMainPage();Ext.Msg.alert('Message',odwMsgList.msg3);},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Listeners>
        <BeforeHide Handler="return NeedSave();" />
    </Listeners>
</ext:Window>
<ext:Window ID="AttachmentWindow" runat="server" Icon="Group" Title="上传附件" Resizable="false" Header="false" Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Header="false" AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
            <Defaults>
                <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
            </Defaults>
            <Body>
                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="50">
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