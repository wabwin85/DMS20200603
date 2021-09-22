<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConsignmentApplyHeaderList.aspx.cs"
    Inherits="DMS.Website.Pages.Consignment.ConsignmentApplyHeaderList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="~/Controls/ConsignmenCfn.ascx" TagName="ConsignmenCfn" TagPrefix="uc" %>
<%@ Register Src="~/Controls/ConsignmenCfnSet.ascx" TagName="ConsignmenCfnSet" TagPrefix="uc" %>
<%@ Register Src="~/Controls/ConsignmenReturnsCfn.ascx" TagName="ConsignmenReturnsCfn" TagPrefix="uc" %>
<%@ Register Src="~/Controls/ConsignmentHospital.ascx" TagPrefix="uc" TagName="ConsignmentHospital" %>


<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .yellow-row {
            background: #FFFF99;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />

        <script type="text/javascript" language="javascript">
            Ext.apply(Ext.util.Format, { number: function (v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function (format) { return function (v) { return Ext.util.Format.number(v, format); }; } });

            function RefreshDetailWindow() {
                Ext.getCmp('<%=this.PagingToolBar3.ClientID%>').changePage(1);
                Ext.getCmp('<%=this.gpTrack.ClientID%>').reload();
                Ext.getCmp('<%=this.gpLog.ClientID%>').reload();
            }
            //选择弹窗
            var showHospitalSelectorDlg = function () {
                var product = <%= cbproline.ClientID %>.getValue();

                if (product == null || product == "") {
                    Ext.Msg.alert('提醒', '请选择产品线!');
                }
                else
                    openHospitalSearchDlg2(product);
            }



            var RenderCheckBoxSet = function (value) {
                return "<input type='checkbox' name='chkItemSet' value='" + value + "'>";
            }
            var RenderRetrunCheckBoxSet = function (value) {
                return "<input type='checkbox' name='chkRetrunItemSet' value='" + value + "'>";
            }

            var RenderTextBoxSet = function (value) {
                return "<input type='text' name='txtItemSet' value='" + value + "' style='width:50px'>";
            }

            function CheckAllSet() {
                var chklist = document.getElementsByName("chkItemSet");
                var isChecked = document.getElementById("chkAllItemSet").checked;
                //alert(chklist.length);
                for (var i = 0; i < chklist.length; i++) {
                    chklist[i].checked = isChecked;
                    //alert(chklist[i].value);
                }
            }

            var template = '<span style="color:{0};">{1}</span>';

            var pctChange = function (value) {
                return String.format(template, (value < 1) ? 'green' : 'red', value + '%');
            }

           <%-- function ChangeHospit() {
                var cbHospit = Ext.getCmp('cbHospital');
                var cbProductLine = Ext.getCmp('<%=this.cbproline.ClientID%>');

                if (cbProductLine.getValue() == '') {
                    cbHospit.clearValue();
                    cbHospit.store.removeAll();

                }
            }--%>
            function HospitBind() {
                var HospId = Ext.getCmp('<%=this.HospId.ClientID%>');
                var cbHospit = Ext.getCmp('<%=this.cbHospital.ClientID%>');
                Coolite.AjaxMethods.HospitChange({
                    success: function () {
                        ChaneSale();
                        HospId.setValue(cbHospit.getValue());

                    },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                    }
                });
            }
            function ChangeHospit() {

                var HospId = Ext.getCmp('<%=this.HospId.ClientID%>');
                var cbHospit = Ext.getCmp('<%=this.cbHospital.ClientID%>');
                if (HospId.getValue() != cbHospit.getValue()) {

                    HospitBind();
                }
            }
            function RefreshLogInfo() {
                Ext.getCmp('<%=this.PagingToolBar2.ClientID%>').changePage(1);
            }

            var ChanConsignmentFrom = function ChanConsignmentFrom() {
                var cbProductsource = Ext.getCmp('<%=this.cbProductsource.ClientID%>');
                var hidChanConsignment = Ext.getCmp('<%=this.hidChanConsignment.ClientID%>');

                if (cbProductsource.getValue() != hidChanConsignment.getValue()) {
                    Ext.Msg.confirm('Messgin', '产品来源发送改变，是否删除原有申请单?', function (e) {
                        if (e == 'yes') {
                            Coolite.AjaxMethods.ChanConsignmentFrom(cbProductsource.getValue(), {
                                success: function () {

                                    hidChanConsignment.setValue(cbProductsource.getValue());
                                    SetModified(true);
                                    Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
                                },
                                failure: function (err) {
                                    Ext.Msg.alert('Error', err);
                                }
                            })
                        }
                        else {

                            cbProductsource.setValue(hidChanConsignment.getValue());
                            Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

                        }
                    });
                }
                else {
                    Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

                }

            }

            function SelectListDealer(e) {
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

            function SelectValueDealer(e) {
                var filterField = 'Id';  //需进行模糊查询的字段
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
            ///模糊查询
            function SelectValue(e) {
                var filterField = 'Name';  //需进行模糊查询的字段
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
            //设置是否需要保存
            var SetModified = function (isModified) {
                Ext.getCmp('<%=this.hidIsModified.ClientID%>').setValue(isModified ? "True" : "False");
            }
            function ValidateForm() {
                var errMsg = "";
                var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
                var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
                var isForm1Valid = Ext.getCmp('<%=this.FormPanel2.ClientID%>').getForm().isValid();
                var isFrom2Valid = Ext.getCmp('<%=this.FormPanel1.ClientID%>').getForm().isValid();
                var IsSaved = Ext.getCmp('<%=this.hidIsSaved.ClientID%>');
                var txtNumberDays = Ext.getCmp('<%=this.txtNumberDays.ClientID%>');
                var txtConsignment = Ext.getCmp('<%=this.txtConsignment.ClientID%>');
                var Consignment = Ext.getCmp('<%=this.hidConsignment.ClientID%>');
                var cbHospital = Ext.getCmp('<%=this.cbHospital.ClientID%>');
                //医院地址
                var Texthospitalname = Ext.getCmp('<%=this.Texthospitalname.ClientID%>');
                //医院名称
                var HospitalAddress = Ext.getCmp('<%=this.HospitalAddress.ClientID%>');



                if (!isForm1Valid) {
                    Ext.Msg.alert('Message', '请填写信息');
                    return false;
                }
                if (!isFrom2Valid) {
                    Ext.Msg.alert('Message', '请选择产品线和寄售规则');
                    return false;
                }

                if (parseInt(txtNumberDays.getValue()) <= 15 && txtConsignment.getValue() == '') {
                    Ext.Msg.alert('Message', '小于等于15天的寄售必须填写原因寄售原因中填写手术相关信息。');
                    return false;
                }
                var cbHospital = Ext.getCmp('<%=this.cbHospital.ClientID%>');
                if (parseInt(txtNumberDays.getValue()) <= 15 && cbHospital.getValue() == '') {
                    Ext.Msg.alert('Message', '小于等于15天的寄售必须选择医院。');
                    return false;
                }
                Ext.Msg.confirm('Message', '确定提交?', function (e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.CheckSubmit({
                            success: function () {
                                if (rtnVal.getValue() == "Success") {
                                    Coolite.AjaxMethods.Submit({

                                        success: function () {

                                            Ext.Msg.alert('Message', '提交成功!');
                                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                            RefreshMainPage();
                                        },
                                        failure: function (err) {
                                            Ext.Msg.alert('Error', err);
                                        }

                                    });
                                }
                                else if (rtnVal.getValue() == "Error") {

                                    Ext.Msg.alert('Error', rtnMsg.getValue());
                                }
                                else if (rtnVal.getValue() == "Warn") {
                                    Ext.Msg.confirm('Warning', '验证通过，是否提交?', function (e) {
                                        if (e == 'yes') {

                                            Coolite.AjaxMethods.Submit({
                                                success: function (msg) {
                                                    if (msg != '') {
                                                        Ext.Msg.alert('Error', msg);
                                                    } else {

                                                        if (IsSaved.getValue() == 'True') {
                                                            Ext.Msg.alert('Message', '提交成功!');
                                                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                            RefreshMainPage();
                                                        }
                                                        else {
                                                            Ext.Msg.alert('Message', '申请单信息发生改变，请重新操作')
                                                        }
                                                    }
                                                },
                                                failure: function (err) {
                                                    Ext.Msg.alert('Error', err);
                                                }
                                            });
                                        }
                                    })
                                }
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }

                        });
                    }
                });
            }
            //变更短期寄售规则（现调整为寄售合同）
            var SetConsignment = function () {
                var Consignment = Ext.getCmp('<%=this.hidConsignment.ClientID%>');
                if (Consignment.getValue() != txtRule.getValue()) {
                    Coolite.AjaxMethods.SetConsignment(
                        {
                            success: function () {
                 //            Ext.getCmp('<%=this.Toolbar1.ClientID%>').enable();
                                Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
                                Consignment.setValue(txtRule.getValue());
                                SetModified(true);
                                clearItems();
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    )
                };
            }
            //选择来源经销商
            var ChaneSourceDealer = function () {
                var SourceDealer = Ext.getCmp('<%=this.HiSourceDealer.ClientID%>');
                var cbSuorcePro = Ext.getCmp('<%=this.cbSuorcePro.ClientID%>');

                if (SourceDealer.getValue() != cbSuorcePro.getValue()) {

                    Coolite.AjaxMethods.ChangSuoresDelaer({

                        success: function () {
                            SourceDealer.setValue(cbSuorcePro.getValue());
                        },
                        failure: function (err) {

                            Ext.Msg.alert('Error', err);
                        }
                    })


                }

            }
            //变更销售
            ChaneSale = function () {
                var Sale = Ext.getCmp('<%=this.cbSale.ClientID%>');
                var txtSalesName = Ext.getCmp('<%=this.txtSalesName.ClientID%>');
                var txtSalesEmail = Ext.getCmp('<%=this.txtSalesEmail.ClientID%>');
                var txtSalesPhone = Ext.getCmp('<%=this.txtSalesPhone.ClientID%>');
                var txtConsignee = Ext.getCmp('<%=this.txtConsignee.ClientID%>');
                var txtConsigneeAddress = Ext.getCmp('<%=this.cbSAPWarehouseAddress.ClientID%>');
                var txtConsigneePhone = Ext.getCmp('<%=this.txtConsigneePhone.ClientID%>');
                var hidSaleId = Ext.getCmp('<%=this.hidSaleId.ClientID%>');

               

                if (hidSaleId.getValue() != Sale.getValue()) {
                    txtSalesName.setValue('');
                    txtSalesEmail.setValue('');
                    txtSalesPhone.setValue('');

                    
                    var Mobile = getNameFromStoreById(SalesRepStor, { Key: 'Id', Value: 'Mobile' }, Sale.getValue());
                    var Salename = getNameFromStoreById(SalesRepStor, { Key: 'Id', Value: 'Name' }, Sale.getValue());
                    var Email = getNameFromStoreById(SalesRepStor, { Key: 'Id', Value: 'Email' }, Sale.getValue());
                    txtSalesName.setValue(Salename);
                    txtSalesEmail.setValue(Email);
                    txtSalesPhone.setValue(Mobile);
                    hidSaleId.setValue(Sale.getValue());
                }


            }
            //变更产品线
            var ChangeProductLine = function () {
                var cbOrderType = Ext.getCmp('<%=this.cbOrderType.ClientID%>');
                var cbProductLine = Ext.getCmp('<%=this.cbproline.ClientID%>');
                var hidOrderType = Ext.getCmp('<%=this.hidOrderType.ClientID%>');
                var cbHospit = Ext.getCmp('<%=this.cbHospital.ClientID%>');

                if (hidProductLine.getValue() != cbproline.getValue()) {
                    Ext.Msg.confirm('Warning', '产品线发生改变，是否删除原有申请单?',
                        function (e) {
                            if (e == 'yes') {
                                cbHospit.store.removeAll();
                                cbHospit.setValue('');
                                Coolite.AjaxMethods.ChangeProductLine(
                                    {
                                        success: function () {
                                            hidProductLine.setValue(cbProductLine.getValue());
                                            hidOrderType.setValue(cbOrderType.getValue());


                                            if (cbHospit.getValue() != '') {

                                                HospitBind();
                                            }
                                            SetModified(true);
                                            Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
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
            //window hide前提示是否需要保存数据
            var NeedSave = function () {

                var isModified = Ext.getCmp('<%=this.hidIsModified.ClientID%>').getValue() == "True" ? true : false;
                var isSaved = Ext.getCmp('<%=this.hidIsSaved.ClientID%>').getValue() == "True" ? true : false;
                if (!isSaved) {
                    if (isModified) {
                        Ext.Msg.confirm('Warning', '数据发生改变，是否保存草稿?', function (e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.SaveDraft({
                                    success: function () {
                                        if (Ext.getCmp('<%=this.hidIsSaved.ClientID%>').getValue() == 'True') {
                                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                            RefreshMainPage();
                                        }
                                        else {
                                            Ext.Msg.alert('Messg', '申请单信息发生改变，请重新操作');
                                        }

                                    },
                                    failure: function (err) {

                                        Ext.Msg.alert('Error', err);
                                    }
                                });

                            }
                            else {
                                Ext.getCmp('<%=this.hidIsModified.ClientID%>').setValue('False');
                                Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                            }

                        });
                        return false;
                    }

                }

            }


            var UpdateItem = function (upn) {
                var txtRequiredQty = Ext.getCmp('<%=this.txtRequiredQty.ClientID%>');
                var txtCfnPrice = Ext.getCmp('<%=this.txtCfnPrice.ClientID%>');
                var hidCustomerFaceNbr = Ext.getCmp('<%=this.hidCustomerFaceNbr.ClientID%>');
                var hidEditItemId = Ext.getCmp('<%=this.hidEditItemId.ClientID%>');
                var DetailWindow = Ext.getCmp('<%=this.DetailWindow.ClientID%>');
                var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
                Coolite.AjaxMethods.UpdateItem(txtRequiredQty.getValue(), txtCfnPrice.getValue(), hidCustomerFaceNbr.getValue(),
                    {
                        success: function () {
                            if (rtnVal.getValue() == "LotTooLong") {
                                Ext.Msg.alert('Error', '输入的产品编号过长，长度为30');
                            } else if (rtnVal.getValue() == "LotNotExists") {
                                Ext.Msg.alert('Error', '输入的产品编号不存在');
                            } else if (rtnVal.getValue() == "LotExisted") {
                                Ext.Msg.alert('Error', '输入的产品编号已存在');
                            }
                            else if (rtnVal.getValue() == "LotPriceExisted") {
                                Ext.Msg.alert('Error', '相同价格的产品已经存在!');
                            }
                            hidEditItemId.setValue('');
                            DetailStoreLoad();

                            SetWinBtnDisabled(DetailWindow, false);
                        },
                        failure: function (err) {
                            Ext.Msg.alert('Error', err);
                        }
                    }
                );
            }
            var ShowEditingMask = function () {
                var win = Ext.getCmp('<%=this.DetailWindow.ClientID%>');
                win.body.mask('正在变更申请单信息,请稍后', 'x-mask-loading');
                SetWinBtnDisabled(win, true);
            };
            var SetWinBtnDisabled = function (win, disabled) {
                for (var i = 0; i < win.buttons.length; i++) {
                    win.buttons[i].setDisabled(disabled);
                }
            };
            //屏蔽刷新Store时的提示
            var StoreCommitAll = function (store) {
                for (var i = 0; i < store.getCount(); i++) {
                    var record = store.getAt(i);
                    if (record.dirty) {
                        record.commit();
                    }
                }
            };
            function windowsshow(id) {
                Coolite.AjaxMethods.Show(id,
                    {
                        success: function () {

                        },
                        failure: function (err) {
                            Ext.Msg.alert('Error', err);
                        }
                    }
                );
            };
            function DetailStoreLoad() {
                Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();

            };
            function RefreshMainPage() {

                Ext.getCmp('<%=this.GHeaderlist.ClientID%>').reload();
            };


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
            <Listeners>
                <%--<Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbProductLine}.setValue(#{cbProductLine}.store.getTotalCount()>0?#{cbProductLine}.store.getAt(0).get('Id'):'');#{hidProductLine}.setValue(#{cbProductLine}.getValue());Coolite.AjaxMethods.OrderDetailWindowLP.ProductLineInit();}else{#{cbProductLine}.setValue(#{hidProductLine}.getValue());Coolite.AjaxMethods.OrderDetailWindowLP.ProductLineInit();}" />--%>
            </Listeners>
        </ext:Store>
        <ext:Store ID="ProductsourceStor" runat="server" UseIdConfirmation="true">
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
        <ext:Store ID="HostitStore" runat="server" UseIdConfirmation="true">
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
            <SortInfo Field="Id" Direction="ASC" />
            <Listeners>
               <%-- <Load Handler="#{cbProductLine}.setValue(#{cbProductLine}.store.getTotalCount()>0?#{cbProductLine}.store.getAt(0).get('Id'):'');" />--%>
            </Listeners>
        </ext:Store>

        <ext:Store ID="ProductLineDmaStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Name" />

                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Id" Direction="ASC" />

        </ext:Store>
        <ext:Store ID="OrderLogStore" runat="server" AutoLoad="false" OnRefreshData="OrderLogStore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
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
            <Listeners>
                <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
                <Load Handler="#{DetailWindow}.body.unmask();" />
                <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="CAH_Id" />
                        <ext:RecordField Name="CFN_Id" />
                        <ext:RecordField Name="UOM" />
                        <ext:RecordField Name="Qty" />
                        <ext:RecordField Name="Price" />
                        <ext:RecordField Name="Actual_Price" />
                        <ext:RecordField Name="Amount" />
                        <ext:RecordField Name="Remark" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="BarCode" />
                        <ext:RecordField Name="BarCode_Id" />
                        <ext:RecordField Name="CustomerFaceNbr" />
                        <ext:RecordField Name="CfnChineseName" />
                        <ext:RecordField Name="CfnEnglishName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
                <Load Handler="#{DetailWindow}.body.unmask();" />
                <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
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
        <ext:Store ID="OrderTypeStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <%--  <Load Handler="OrderTypeStoreLoad()" />--%>
            </Listeners>
        </ext:Store>
        <ext:Store ID="DealerConsignmentStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Name" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="SalesRepStor" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="Email" />
                        <ext:RecordField Name="Mobile" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>

        <ext:Store ID="OrderTrackStore" runat="server" AutoLoad="false" OnRefreshData="OrderTrackStore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="CahId" />
                        <ext:RecordField Name="CahOrderNo" />
                        <ext:RecordField Name="CahSubmitDate" Type="Date" />
                        <ext:RecordField Name="CfnId" />
                        <ext:RecordField Name="PmaId" />
                        <ext:RecordField Name="CfnChineseName" />
                        <ext:RecordField Name="CfnEnglishName" />
                        <ext:RecordField Name="CfnCode" />
                        <ext:RecordField Name="CfnCode2" />
                        <ext:RecordField Name="CfnUom" />
                        <ext:RecordField Name="LotId" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="TotalQty" />
                        <ext:RecordField Name="PurchaseId" />
                        <ext:RecordField Name="PurchaseNo" />
                        <ext:RecordField Name="PurchaseDate" Type="Date" />
                        <ext:RecordField Name="PurchaseQty" />
                        <ext:RecordField Name="POReceiptId" />
                        <ext:RecordField Name="POReceiptNo" />
                        <ext:RecordField Name="POReceiptSapNo" />
                        <ext:RecordField Name="POReceiptDeliveryDate" />
                        <ext:RecordField Name="POReceiptDate" />
                        <ext:RecordField Name="POReceiptQty" />
                        <ext:RecordField Name="ExpirationDate" Type="Date" />
                        <ext:RecordField Name="ConsignmentDay" />
                        <ext:RecordField Name="DelayNumber" />
                        <ext:RecordField Name="ShipmentLotId" />
                        <ext:RecordField Name="ShipmentNos" />
                        <ext:RecordField Name="ShipmentDates" />
                        <ext:RecordField Name="ShipmentSubmitDates" />
                        <ext:RecordField Name="ShipmentQty" />
                        <ext:RecordField Name="ReturnLotId" />
                        <ext:RecordField Name="ReturnNos" />
                        <ext:RecordField Name="ReturnDates" />
                        <ext:RecordField Name="ReturnApprovelDates" />
                        <ext:RecordField Name="ReturnQty" />
                        <ext:RecordField Name="ComplainNo" />
                        <ext:RecordField Name="ComplainBscNo" />
                        <ext:RecordField Name="ComplainDate" Type="Date" />
                        <ext:RecordField Name="ComplainStatus" />
                        <ext:RecordField Name="ComplainQty" />
                        <ext:RecordField Name="ClearBorrowNos" />
                        <ext:RecordField Name="ClearBorrowDate" />
                        <ext:RecordField Name="ClearBorrowQty" />
                        <ext:RecordField Name="PORLotNumber" />
                        <ext:RecordField Name="PORQrCode" />
                        <ext:RecordField Name="Qty" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
                <Load Handler="#{DetailWindow}.body.unmask();" />
                <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="DelayStatusStore" runat="server" UseIdConfirmation="true">
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

        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <%-- 明细 --%>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DmaSapCode" />
                        <ext:RecordField Name="OrderNo" />
                        <ext:RecordField Name="ProductLineBumId" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="OrderStatus" />
                        <ext:RecordField Name="OrderType" />
                        <ext:RecordField Name="SubmitUser" />
                        <ext:RecordField Name="SubmitDate" Type="Date" />
                        <ext:RecordField Name="TotalQty" />
                        <ext:RecordField Name="Amount" />
                        <ext:RecordField Name="ShipToAddress" />
                        <ext:RecordField Name="DelayOrderStatus" />
                        <ext:RecordField Name="DelayDelayTime" />
                        <ext:RecordField Name="Remark" />
                        <ext:RecordField Name="Texthospitalname" />
                        <ext:RecordField Name="HospitalAddress" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="SAPWarehouseAddressStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="WhAddress" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="hidIsModified" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsSaved" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidOrderStatus" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidSaleId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidLatestAuditDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidRtnVal" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidChanConsignment" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidRtnMsg" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HiConsignment" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HiCfntype" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidCorpType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidInstanceId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDealerId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidProductLine" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPriceType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidorderState" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidOrderType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidEditItemId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidSpecialPrice" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidCustomerFaceNbr" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidCreateType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidUpdateDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidConsignment" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HiSourceDealer" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HiDmaId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HospId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDivisionCode" runat="server">
        </ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="查询条件" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="请选择" Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" Mode="Local" DisplayField="AttributeName"
                                                            FieldLabel="产品线" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="txtSubmitDateStart" runat="server" Width="150" FieldLabel="提交日期" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtCfn" runat="server" Width="150" FieldLabel="产品型号" />
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
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择..." Width="220" Editable="true"
                                                            TypeAhead="false" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                            Mode="Local" FieldLabel="经销商" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();this.store.clearFilter();" />
                                                                <BeforeQuery Fn="SelectListDealer" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="txtSubmitDateEnd" runat="server" Width="150" FieldLabel="至" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtOrderNo" runat="server" Width="150" FieldLabel="申请单号" />
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
                                                        <ext:ComboBox ID="cbOrderStatus" runat="server" EmptyText="请选择...." Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="OrderStatusStore" ValueField="Key" Mode="Local" DisplayField="Value"
                                                            FieldLabel="申请单状态">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbOrderType" runat="server" EmptyText="请选择..." Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="OrderTypeStore" ValueField="Key" Mode="Local" DisplayField="Value"
                                                            FieldLabel="申请单类型">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDelayStatus" runat="server" EmptyText="请选择..." Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="DelayStatusStore" ValueField="Key" Mode="Local" DisplayField="Value"
                                                            FieldLabel="延期申请状态">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
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
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="添加" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="windowsshow('00000000-0000-0000-0000-000000000000')" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GHeaderlist" runat="server" Title="申请单列表" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" AutoExpandColumn="Remark">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DmaId" DataIndex="DmaId" Header="经销商" Width="200">
                                                    <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DmaSapCode" DataIndex="DmaSapCode" Header="ERP编号" Width="70">
                                                </ext:Column>
                                                <ext:Column ColumnID="OrderNo" DataIndex="OrderNo" Header="申请单号" Width="160">
                                                </ext:Column>
                                                <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Width="70" Align="Right" Header="总数量">
                                                </ext:Column>
                                                <ext:Column ColumnID="TotalAmount" Hidden="true" DataIndex="TotalAmount" Width="80"
                                                    Align="Right" Header="总金额">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="SubmitDate" DataIndex="SubmitDate" Align="Center" Header="提交日期">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipToAddress" DataIndex="ShipToAddress" Width="150" Header="收货地址">
                                                </ext:Column>
                                                <ext:Column ColumnID="Remark" DataIndex="Remark" Header="备注">
                                                </ext:Column>
                                                <ext:Column ColumnID="OrderType" DataIndex="OrderType" Align="Center" Width="100"
                                                    Header="申请类型">
                                                    <Renderer Handler="return getNameFromStoreById(OrderTypeStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="OrderStatus" DataIndex="OrderStatus" Align="Center" Width="80"
                                                    Header="申请单状态">
                                                    <Renderer Handler="return getNameFromStoreById(OrderStatusStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DelayOrderStatus" DataIndex="DelayOrderStatus" Align="Center" Width="80"
                                                    Header="延期状态">
                                                    <Renderer Handler="return getNameFromStoreById(DelayStatusStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DelayDelayTime" DataIndex="DelayDelayTime" Align="Center" Width="80"
                                                    Header="可延期次数">
                                                </ext:Column>
                                                <ext:CommandColumn ColumnID="Id" Align="Center" Width="50" Header="明细">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="查看明细" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <%-- <ext:Column ColumnID="Id" DataIndex="OrderStatus" Align="Center" Width="50" Header="<%$ Resources:GridPanel1.ColumnModel1.Modify.Header %>">
                                                <Renderer Fn="orderModify" />
                                            </ext:Column>--%>
                                                <ext:Column ColumnID="Print" DataIndex="DmaId" Hidden="true" Align="Center" Width="50"
                                                    Header="打印">
                                                    <%--<Renderer Fn="PrintRender" />--%>
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <%-- <View>
                                        <ext:GridView ID="GridView1" runat="server">
                                            <GetRowClass />
                                        </ext:GridView>
                                    </View>--%>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="Coolite.AjaxMethods.Show(record.data.Id,{success:function(){RefreshDetailWindow();RefreshLogInfo();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                            <CellClick />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="ResultStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="申请单详情" Width="1024" Height="490"
            AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Resizable="false" Header="false" CenterOnLoad="true"
            Y="5" Maximizable="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="FormPanel1" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".24">
                                        <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                            <Body>
                                                <%--表头信息 --%>
                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="70">
                                                    <%--订单类型、订单编号、提交日期 --%>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtApplyType" runat="server" ReadOnly="true" FieldLabel="申请单类型"
                                                            Width="120" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbproline" runat="server" LabelStyle="color:red;" Width="120" Editable="false"
                                                            TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName"
                                                            FieldLabel="产品线" AllowBlank="false" BlankText="产品线" EmptyText="请选择.." ListWidth="200"
                                                            Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <Select Handler="#{Toolbar1}.setDisabled(true);ChangeProductLine();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="txtRule" runat="server" LabelStyle="color:red;" Width="120" Editable="false"
                                                            TypeAhead="true" StoreID="DealerConsignmentStore" ValueField="Id" DisplayField="Name"
                                                            FieldLabel="寄售合同" AllowBlank="false" BlankText="寄售合同" EmptyText="请选择寄售合同" ListWidth="200"
                                                            Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <Select Handler="#{Toolbar1}.setDisabled(true);SetConsignment();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtConsignmentRule" runat="server" Width="120" ReadOnly="true" FieldLabel="寄售规则" LabelStyle="color:red;">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".24">
                                        <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="70">
                                                    <%--产品线、订单状态、财务信息 --%>

                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtDealerName" ReadOnly="true" runat="server" FieldLabel="经销商名称"
                                                            Width="150" />
                                                        <%-- <ext:TextField ID="cbDealer" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                    StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName" FieldLabel="<%$ Resources: cbDealer.FieldLabel %>"
                                                    Mode="Local" AllowBlank="false" BlankText="<%$ Resources: cbDealer.BlankText %>"
                                                    EmptyText="<%$ Resources: cbDealer.EmptyText %>" ListWidth="300" Resizable="true">
                                                </ext:ComboBox>--%>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProductsource" runat="server" LabelStyle="color:red;" Width="150"
                                                            Editable="false" TypeAhead="true" Disabled="false" StoreID="ProductsourceStor"
                                                            ValueField="Key" DisplayField="Value" FieldLabel="产品来源" AllowBlank="true" BlankText="产品来源"
                                                            EmptyText="请选择" ListWidth="200" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <Select Handler="#{Toolbar1}.setDisabled(true);ChanConsignmentFrom();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbHospital" runat="server" Width="150" Editable="true" TypeAhead="true"
                                                            StoreID="HostitStore" ValueField="Id" DisplayField="Name" LabelStyle="color:red;"
                                                            FieldLabel="医院" AllowBlank="true" BlankText="医院" EmptyText="医院" ListWidth="200"
                                                            Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <BeforeQuery Fn="SelectValue" />
                                                                <Select Handler="#{Toolbar1}.setDisabled(true); ChangeHospit();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="TextHospit" Hidden="true" ReadOnly="true" runat="server" FieldLabel="医院" LabelStyle="color:red;" Width="150" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="70">
                                                    <%--经销商、订单对象 --%>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtSubmitDate" ReadOnly="true" runat="server" FieldLabel="提交日期"
                                                            Width="130" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbSuorcePro" runat="server" LabelStyle="color:red;" Width="130"
                                                            Editable="true" TypeAhead="true" Disabled="false" StoreID="ProductLineDmaStore" ValueField="Id" DisplayField="Name"
                                                            FieldLabel="来源经销商" AllowBlank="true" BlankText="来源经销商" EmptyText="请选择" ListWidth="200"
                                                            Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <Select Handler="#{Toolbar1}.setDisabled(true);ChaneSourceDealer();" />
                                                                <BeforeQuery Fn="SelectValue" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel14" runat="server" Border="false">
                                                            <Body>
                                                                <div style="color: Red;">
                                                                    注:小于等于15天的寄售必须选择医院。
                                                                </div>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".22">
                                        <ext:Panel ID="Panel17" runat="server" Border="false" Header="false">
                                            <Body>
                                                <%--表头信息 --%>
                                                <ext:FormLayout ID="forminfo1" runat="server" LabelAlign="Left" LabelWidth="75">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtApplyNo" ReadOnly="true" runat="server" FieldLabel="申请单号" Width="130" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtOrderState" ReadOnly="true" runat="server" FieldLabel="申请单状态"
                                                            Width="130" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtDelayState" ReadOnly="true" runat="server" FieldLabel="延期申请状态"
                                                            Width="130" />
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
                                <ext:Tab ID="TabHeader" runat="server" Title="申请单主信息" BodyStyle="padding: 6px;" AutoScroll="true">
                                    <%--表头信息 --%>
                                    <Body>
                                        <ext:FitLayout ID="FTHeader" runat="server">
                                            <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                                                <Body>
                                                    <ext:ColumnLayout ID="ColumnLayout3" runat="server" Split="false">
                                                        <ext:LayoutColumn ColumnWidth="0.35">
                                                            <ext:Panel ID="Panel6" runat="server" Border="true" FormGroup="true" Title="汇总信息">
                                                                <%--汇总信息 --%>
                                                                <Body>
                                                                    <ext:FormLayout ID="forminfo2" runat="server" LabelAlign="Left">
                                                                        <%--金额汇总、数量汇总、VirtualDC、备注 --%>
                                                                        <ext:Anchor>
                                                                            <ext:NumberField ID="txtnumber" ReadOnly="true" runat="server" FieldLabel="申请数量汇总">
                                                                            </ext:NumberField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:NumberField ID="txtTaoteprice" ReadOnly="true" runat="server" FieldLabel="申请总价格">
                                                                            </ext:NumberField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:Label ID="lbConsignment" runat="server" FieldLabel="寄售原因">
                                                                            </ext:Label>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:Panel ID="divPanel" runat="server" Border="false">
                                                                                <Body>
                                                                                    <div style="color: Red; line-height: 10px; padding-bottom: 5px;">
                                                                                        注:小于等于15天的寄售必须填写原因<br></br>
                                                                                        寄售原因中填写手术相关信息。
                                                                                    </div>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:TextArea ID="txtConsignment" runat="server" Width="240" Height="50" HideLabel="true" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:Label ID="lbRemark" runat="server" FieldLabel="备注说明">
                                                                            </ext:Label>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:TextArea ID="txtRemark" runat="server" Width="240" Height="50" HideLabel="true" />
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth="0.35">
                                                            <ext:Panel ID="boke" runat="server" Border="true" FormGroup="true" Title="销售信息">
                                                                <%--订单信息 --%>
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                        <%--特殊价格规则名称、特殊价格规则编号、订单联系人、联系方式、手机号码 --%>
                                                                        <ext:Anchor>
                                                                            <ext:ComboBox ID="cbSale" runat="server" LabelStyle="color:red;" Width="205" Editable="true"
                                                                                TypeAhead="true" Disabled="false" StoreID="SalesRepStor" ValueField="Id" DisplayField="Name"
                                                                                FieldLabel="销售" AllowBlank="true" BlankText="销售" EmptyText="请选择" ListWidth="200"
                                                                                Resizable="true">
                                                                                <Triggers>
                                                                                    <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                                                </Triggers>
                                                                                <Listeners>
                                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                                    <Select Handler="#{Toolbar1}.setDisabled(true);ChaneSale();" />
                                                                                    <BeforeQuery Fn="SelectValueDealer" />
                                                                                </Listeners>
                                                                            </ext:ComboBox>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtSalesName" ReadOnly="true" LabelStyle="color:red;" runat="server" Width="205"
                                                                                FieldLabel="销售姓名" AllowBlank="false" BlankText="销售姓名" MsgTarget="Side" MaxLength="100" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtSalesEmail" ReadOnly="true" LabelStyle="color:red;" runat="server" Width="205"
                                                                                FieldLabel="销售邮箱" AllowBlank="false" BlankText="销售邮箱" MsgTarget="Side" MaxLength="100" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtSalesPhone" ReadOnly="true" LabelStyle="color:red;" runat="server" Width="205"
                                                                                FieldLabel="销售电话" AllowBlank="false" BlankText="销售电话" MsgTarget="Side" MaxLength="100" />
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth="0.35">
                                                            <ext:Panel ID="Panel10" runat="server" Border="true" FormGroup="true" Title="收货人信息">
                                                                <%-- 收货信息 --%>
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left">
                                                                        <%--收货仓库选择、收货地址、收货人、收货人电话、期望到货时间、承运商、医院地址、医院名称--%>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtConsignee" LabelStyle="color:red;" runat="server" Width="150"
                                                                                FieldLabel="收货人" AllowBlank="false" BlankText="请填写收货人..." MsgTarget="Side" MaxLength="250" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <%--    <ext:TextField ID="txtConsigneeAddress" LabelStyle="color:red;" runat="server" Width="150"
                                                                                FieldLabel="收货地址" AllowBlank="false" BlankText="收货地址" MsgTarget="Side" MaxLength="200" />--%>
                                                                            <ext:ComboBox ID="cbSAPWarehouseAddress" runat="server" Width="150" Editable="false"
                                                                                Disabled="false" TypeAhead="true" StoreID="SAPWarehouseAddressStore" ListWidth="300"
                                                                                ValueField="WhAddress" AllowBlank="false" DisplayField="WhAddress" LabelStyle="color:red;" MsgTarget="Side"
                                                                                FieldLabel="收货地址">
                                                                            </ext:ComboBox>
                                                                        </ext:Anchor>

                                                                        <ext:Anchor>
                                                                            <ext:Panel ID="pan" runat="server" Border="false" Width="385">
                                                                                <Body>
                                                                                    <ext:ColumnLayout ID="ColumnLayout5" runat="server" Split="false">
                                                                                        <ext:LayoutColumn ColumnWidth="0.62">
                                                                                            <ext:Panel ID="Panel15" runat="server" Border="true" FormGroup="true">
                                                                                                <Body>
                                                                                                    <ext:FormLayout ID="FormLayout12" runat="server" LabelAlign="Left">
                                                                                                        <ext:Anchor>
                                                                                                            <ext:TextField ID="Texthospitalname" runat="server" FieldLabel="医院名称"
                                                                                                                AllowBlank="true" />
                                                                                                        </ext:Anchor>
                                                                                                    </ext:FormLayout>
                                                                                                </Body>
                                                                                            </ext:Panel>
                                                                                        </ext:LayoutColumn>
                                                                                        <ext:LayoutColumn ColumnWidth="0.13">
                                                                                            <ext:Panel ID="Panel16" runat="server" Border="true" FormGroup="true">
                                                                                                <Body>
                                                                                                    <ext:FormLayout ID="FormLayout13" runat="server" LabelAlign="Left">
                                                                                                        <ext:Anchor>
                                                                                                            <ext:Button ID="btnhospital" runat="server" Text="选择" Icon="Zoom">
                                                                                                                <Listeners>
                                                                                                                    <Click Fn="showHospitalSelectorDlg" />
                                                                                                                </Listeners>
                                                                                                            </ext:Button>
                                                                                                        </ext:Anchor>
                                                                                                    </ext:FormLayout>
                                                                                                </Body>
                                                                                            </ext:Panel>
                                                                                        </ext:LayoutColumn>
                                                                                    </ext:ColumnLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="HospitalAddress" runat="server" Width="150" FieldLabel="医院地址" MaxLength="500" />
                                                                        </ext:Anchor>


                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtConsigneePhone" LabelStyle="color:red;" runat="server" Width="150"
                                                                                FieldLabel="收货人电话" AllowBlank="false" BlankText="收货人电话" MsgTarget="Side" MaxLength="200">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:DateField ID="dfRDD" runat="server" Width="150" LabelStyle="color:red;" AllowBlank="false" BlankText="期望到货日期" MsgTarget="Side" FieldLabel="期望到货日期" />
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
                                <ext:Tab ID="TabDetail" runat="server" Title="寄售规则明细" BodyStyle="padding: 6px;" AutoScroll="false">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout3" runat="server">
                                            <ext:FormPanel ID="FormPanel3" runat="server" Header="false" Border="false">
                                                <Body>
                                                    <ext:ColumnLayout ID="ColumnLayout4" runat="server" Split="false">
                                                        <ext:LayoutColumn ColumnWidth="0.3">
                                                            <ext:Panel ID="Panel11" runat="server" Border="true" FormGroup="true" Title="寄售规则明细">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left">
                                                                        <%--寄售天数... --%>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtNumberDays" ReadOnly="true" runat="server" Width="150" FieldLabel="寄售天数"
                                                                                AllowBlank="true" BlankText="寄售天数" MsgTarget="Side" MaxLength="100" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <%--  <ext:TextField ID="txtNearlyvalidType" ReadOnly="true" runat="server" Width="150"
                                                                                FieldLabel="近效期类型" AllowBlank="true" BlankText="近效期类型" MsgTarget="Side" MaxLength="100" />--%>
                                                                            <ext:TextField ID="txtIsControlAmount" ReadOnly="true" runat="server" Width="150"
                                                                                FieldLabel="是否控制总金额" AllowBlank="true" BlankText="是否控制总金额" MsgTarget="Side" MaxLength="100" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <%--    <ext:TextField ID="txtLateMoney" ReadOnly="true" LabelStyle="color:#4e79b2;" runat="server"
                                                                                Width="150" FieldLabel="滞纳金 每日金额" AllowBlank="true" BlankText="滞纳金 每日金额" MsgTarget="Side"
                                                                                MaxLength="100" />--%>
                                                                            <ext:TextField ID="txtIsDiscount" ReadOnly="true" LabelStyle="color:#4e79b2;" runat="server"
                                                                                Width="150" FieldLabel="适用近效期规则" AllowBlank="true" BlankText="是否适用近效期折扣规则" MsgTarget="Side"
                                                                                MaxLength="100" />
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth="0.3">
                                                            <ext:Panel ID="Panel12" runat="server" Border="true" FormGroup="true" Title="寄售规则明细">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left">
                                                                        <%--寄售天数... --%>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtDelaytimes" ReadOnly="true" runat="server" Width="150" FieldLabel="可延期次数"
                                                                                AllowBlank="true" BlankText="可延期次数" MsgTarget="Side" MaxLength="100" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <%--<ext:TextField ID="txtReturnperiod" ReadOnly="true" runat="server" Width="150" FieldLabel="退货期限"
                                                                                AllowBlank="true" BlankText="退货期限" MsgTarget="Side" MaxLength="100" />--%>
                                                                            <ext:TextField ID="txtIsControlNumber" ReadOnly="true" runat="server" Width="150"
                                                                                FieldLabel="控制总数量" AllowBlank="true" BlankText="是否控制总数量" MsgTarget="Side" MaxLength="100" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <%--  <ext:TextField ID="txtMainMoney" ReadOnly="true" LabelStyle="color:#4e79b2;" runat="server"
                                                                                Width="150" FieldLabel="最低保证金金额" AllowBlank="true" BlankText="最低保证金金额" MsgTarget="Side"
                                                                                MaxLength="100" />--%>
                                                                            <ext:TextField ID="txtIsKB" ReadOnly="true" LabelStyle="color:#4e79b2;" runat="server"
                                                                                Width="150" FieldLabel="自动补货" AllowBlank="true" BlankText="是否自动补货" MsgTarget="Side"
                                                                                MaxLength="100" />
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth="0.3">
                                                            <ext:Panel ID="Panel13" runat="server" Border="true" FormGroup="true" Title="寄售规则明细">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout11" runat="server" LabelAlign="Left">
                                                                        <%--寄售天数... --%>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtBeginData" ReadOnly="true" runat="server" Width="150" FieldLabel="时间期限-起始"
                                                                                AllowBlank="true" BlankText="时间期限-起始" MsgTarget="Side" MaxLength="100" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtEndData" ReadOnly="true" runat="server" Width="150" FieldLabel="时间期限-截止"
                                                                                AllowBlank="true" BlankText="时间期限-截止" MsgTarget="Side" MaxLength="100" />
                                                                        </ext:Anchor>
                                                                        <%--    <ext:Anchor>
                                                                              <ext:TextField ID="txtTotalMoney" ReadOnly="true" LabelStyle="color:#4e79b2;" runat="server"
                                                                                Width="150" FieldLabel="总量控制金额" AllowBlank="true" BlankText="总量控制金额" MsgTarget="Side"
                                                                                MaxLength="100" />
                                                                        </ext:Anchor>
                                                                        --%>
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
                                <ext:Tab ID="TabInvoice" runat="server" Title="申请产品明细" AutoScroll="false">
                                    <Body>
                                        <ext:FitLayout ID="FT1" runat="server">
                                            <ext:GridPanel ID="gpDetail" runat="server" Title="申请产品明细" StoreID="DetailStore"
                                                StripeRows="true" Border="false" Icon="Lorry" ClicksToEdit="1" EnableHdMenu="false"
                                                Header="false">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar1" runat="server">
                                                        <Items>
                                                            <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                            <ext:Button ID="btnAddOtherdealersCfn" runat="server" Text="添加退货单产品" Icon="Add">
                                                                <Listeners>
                                                                    <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{cbDealer}.getValue() == '' || #{cbproline}.getValue() == ''|| #{cbSuorcePro}.getValue() ==''||#{txtRule}.getValue()=='') {alert('请选择必要的信息！');return false;} 
                                                            {Coolite.AjaxMethods.ConsignmenReturnsCfn.Show(#{hidInstanceId}.getValue(),#{cbproline}.getValue(),#{cbDealer}.getValue(),#{cbSuorcePro}.getValue(),#{txtRule}.getValue(),{success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                                                                </Listeners>

                                                            </ext:Button>
                                                            <ext:Button ID="btnAddCfn" runat="server" Text="添加产品" Icon="Add">
                                                                <Listeners>
                                                                    <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{cbDealer}.getValue() == '' || #{cbproline}.getValue() == ''|| #{hidOrderType}.getValue() =='') {alert('请选择必要的信息！');return false;} 
                                                            {Coolite.AjaxMethods.ConsignmenCfn.Show(#{hidInstanceId}.getValue(),#{cbproline}.getValue(),#{cbDealer}.getValue(),#{hidPriceType}.getValue(),#{hidSpecialPrice}.getValue(),#{hidOrderType}.getValue(),{success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="btnAddCfnSet" runat="server" Text="添加组产品" Icon="Add">
                                                                <Listeners>
                                                                    <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{cbDealer}.getValue() == '' || #{cbproline}.getValue() == ''|| #{hidOrderType}.getValue() =='') {alert('请选择必要的信息！'); return false;} 
                                                            {Coolite.AjaxMethods.ConsignmenCfnSet.Show(#{hidInstanceId}.getValue(),#{cbproline}.getValue(),#{cbDealer}.getValue(),#{hidPriceType}.getValue(),#{hidSpecialPrice}.getValue(),#{hidOrderType}.getValue(),{success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                                                                </Listeners>
                                                            </ext:Button>
                                                        </Items>
                                                    </ext:Toolbar>
                                                </TopBar>
                                                <ColumnModel ID="ColumnModel3" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Width="200" Header="产品型号">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CfnChineseName" DataIndex="CfnChineseName" Header="产品中文名">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CfnEnglishName" DataIndex="CfnEnglishName" Header="产品英文名" Width="70"
                                                            Align="Center">
                                                            <%--<Renderer Fn="SetCellCss" />--%>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UOM" DataIndex="UOM" Header="单位" Width="70"
                                                            Align="Center">
                                                            <%--<Renderer Fn="SetCellCss" />--%>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Qty" DataIndex="Qty" Header="申请数量" Width="70" Align="Right">
                                                            <Editor>
                                                                <ext:NumberField ID="txtRequiredQty" runat="server" AllowBlank="false" AllowDecimals="false"
                                                                    DataIndex="Qty" SelectOnFocus="false" AllowNegative="false">
                                                                </ext:NumberField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Price" Hidden="true" DataIndex="Price" Header="产品单价" Width="70" Align="Right">
                                                            <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                            <Editor>
                                                                <ext:NumberField ID="txtCfnPrice" runat="server" AllowBlank="false" AllowDecimals="true"
                                                                    DataIndex="CfnPrice" SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                                </ext:NumberField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Amount" Hidden="true" DataIndex="Amount" Header="金额小计" Width="80" Align="Right">
                                                            <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                            <Editor>
                                                                <ext:NumberField ID="txtAmount" runat="server" AllowBlank="false" DataIndex="Amount"
                                                                    SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                                </ext:NumberField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="批号" Width="70"
                                                            Align="Center">
                                                            <%--<Renderer Fn="SetCellCss" />--%>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Price" DataIndex="Price" Header="产品单价" Width="70" Align="Right">
                                                            <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <%--<View>
                                            <ext:GridView ID="GridView2" runat="server">
                                                <GetRowClass Fn="getCurrentInvRowClass" />
                                            </ext:GridView>
                                        </View>--%>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="ProductDetaile" SingleSelect="true" runat="server" MoveEditorOnEnter="true">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <Listeners>
                                                    <Command Handler="ShowEditingMask();Coolite.AjaxMethods.DeleteItem(record.data.Id,{success:function(){ DetailStoreLoad();SetWinBtnDisabled(#{DetailWindow},false);},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                    <BeforeEdit Handler="#{hidEditItemId}.setValue(this.getSelectionModel().getSelected().id);#{hidCustomerFaceNbr}.setValue(this.getSelectionModel().getSelected().data.CustomerFaceNbr);#{txtRequiredQty}.setValue(this.getSelectionModel().getSelected().data.RequiredQty);#{txtCfnPrice}.setValue(this.getSelectionModel().getSelected().data.Price);#{txtAmount}.setValue(this.getSelectionModel().getSelected().data.Amount);" />
                                                    <AfterEdit Handler="ShowEditingMask();StoreCommitAll(this.store);UpdateItem();" />
                                                </Listeners>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="50" StoreID="DetailStore"
                                                        DisplayInfo="true" />
                                                </BottomBar>
                                                <SaveMask ShowMask="false" />
                                                <LoadMask ShowMask="false" />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                    <Listeners>
                                        <Activate Handler="Coolite.AjaxMethods.InitBtnCfnAdd();" />
                                    </Listeners>
                                </ext:Tab>
                                <ext:Tab ID="TabTrack" runat="server" Title="产品追踪明细" AutoScroll="false" Hidden="true">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout2" runat="server">
                                            <ext:GridPanel ID="gpTrack" runat="server" Title="产品追踪明细" StoreID="OrderTrackStore" AutoScroll="true"
                                                StripeRows="true" Collapsible="false" Border="false" Header="false" Icon="Lorry">
                                                <ColumnModel ID="ColumnModel2" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="CfnCode" DataIndex="CfnCode" Header="产品型号" Width="90">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CfnCode2" DataIndex="CfnCode2" Header="短编号" Width="60">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="PORLotNumber" DataIndex="PORLotNumber" Header="批次号" Width="70">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="PORQrCode" DataIndex="PORQrCode" Header="二维码" Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="PurchaseNo" DataIndex="PurchaseNo" Header="申请单号" Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="PurchaseDate" DataIndex="PurchaseDate" Header="申请日期" Width="90">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="PurchaseQty" DataIndex="PurchaseQty" Header="申请数量" Width="70">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="POReceiptNo" DataIndex="POReceiptNo" Header="发货单号" Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="POReceiptDeliveryDate" DataIndex="POReceiptDeliveryDate" Header="发货日期" Width="90">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="POReceiptQty" DataIndex="POReceiptQty" Header="发货数量" Width="70">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ReturnNos" DataIndex="ReturnNos" Header="退货单号" Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ReturnDates" DataIndex="ReturnDates" Header="退货日期" Width="90">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ReturnQty" DataIndex="ReturnQty" Header="退货数量" Width="70">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ShipmentNos" DataIndex="ShipmentNos" Header="销售单号" Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ShipmentDates" DataIndex="ShipmentDates" Header="销售日期" Width="90">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ShipmentQty" DataIndex="ShipmentQty" Header="销售数量" Width="70">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ClearBorrowNos" DataIndex="ClearBorrowNos" Header="清指定批号订单号" Width="120">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ClearBorrowDate" DataIndex="ClearBorrowDate" Header="清指定批号完成日期" Width="120">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ClearBorrowQty" DataIndex="ClearBorrowQty" Header="清指定批号数量" Width="120">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ComplainNo" DataIndex="ComplainNo" Header="投诉单号" Width="90">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ComplainBscNo" DataIndex="ComplainBscNo" Header="波科全球投诉号" Width="120">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ComplainDate" DataIndex="ComplainDate" Header="投诉日期" Width="90">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ComplainQty" DataIndex="ComplainQty" Header="投诉数量" Width="70">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Qty" DataIndex="Qty" Header="当前库存数" Width="70">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="当前库存数" Width="70" Hidden="true">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ExpirationDate" DataIndex="ExpirationDate" Header="到期日期" Width="90">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="DelayNumber" DataIndex="DelayNumber" Header="延期次数" Width="70">
                                                        </ext:Column>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                                        MoveEditorOnEnter="true">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="50" StoreID="OrderTrackStore"
                                                        DisplayInfo="true" />
                                                </BottomBar>
                                                <SaveMask ShowMask="false" />
                                                <LoadMask ShowMask="false" />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                                <ext:Tab ID="TabLog" runat="server" Title="操作记录" AutoScroll="true">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout4" runat="server">
                                            <ext:GridPanel ID="gpLog" runat="server" Title="操作记录" StoreID="OrderLogStore"
                                                AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                                Icon="Lorry" AutoExpandColumn="OperNote">
                                                <ColumnModel ID="ColumnModel4" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="操作人账号" Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="操作人姓名" Width="150">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="操作内容" Width="150">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="操作时间" Width="150">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="备注信息">
                                                        </ext:Column>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                        MoveEditorOnEnter="true">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="50" StoreID="OrderLogStore"
                                                        DisplayInfo="true" />
                                                </BottomBar>
                                                <SaveMask ShowMask="false" />
                                                <LoadMask ShowMask="false" />
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
                <ext:Button ID="BtnDelay" runat="server" Text="申请延期" Icon="Add">
                    <Listeners>
                        <Click Handler="   Ext.Msg.confirm('Messgin', '确定申请?', function(e) {

                if (e == 'yes') {  Coolite.AjaxMethods.btnDelayClick(
                    {success:function(){
                    if(#{hidIsSaved}.getValue()=='True')
                    {
                    #{DetailWindow}.hide(); RefreshMainPage();
                    }
                    else if(#{hidRtnVal}.getValue()=='Error'){
                    Ext.Msg.alert('Messg',#{hidRtnMsg}.getValue());
                    }
                    
                    },failure:function(err){Ext.Msg.alert('Error', err);}});
                      }

            })" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnSave" runat="server" Text="保存草稿" Icon="Add">
                    <Listeners>
                        <Click Handler=" Coolite.AjaxMethods.SaveDraft(
                    {success:function(){
                    if(#{hidIsSaved}.getValue()=='True')
                    {
                    #{DetailWindow}.hide(); RefreshMainPage();
                    }
                    else{
                    Ext.Msg.alert('Messg', '申请单信息发生改变，请重新操作');
                    }
                    },failure:function(err){Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnDalt" runat="server" Text="删除草稿" Icon="Delete">
                    <Listeners>
                        <Click Handler="
                    Ext.Msg.confirm('Message', '确定删除？',
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.DeleteDraft({success:function(){
                                       if(#{hidIsSaved}.getValue()=='True')
                    {
                    #{DetailWindow}.hide(); RefreshMainPage();
                    }
                    else{
                    Ext.Msg.alert('Messg', '申请单信息发生改变，请重新操作');
                    }}
                                        
                                        ,failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnSubmit" runat="server" Text="提交申请" Icon="LorryAdd">
                    <Listeners>
                        <Click Handler="ValidateForm();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="return NeedSave();" />
            </Listeners>
        </ext:Window>
        <uc:ConsignmenCfn ID="ConsignmenCfn" runat="server" />
        <uc:ConsignmenCfnSet ID="ConsignmenCfnSet" runat="server" />
        <uc:ConsignmenReturnsCfn ID="ConsignmenReturnsCfn" runat="server" />
        <uc:ConsignmentHospital runat="server" ID="ConsignmentHospital" />
        <ext:Hidden ID="OrderState" runat="server">
        </ext:Hidden>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
