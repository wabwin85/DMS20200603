<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShipmentAudit.aspx.cs"
    Inherits="DMS.Website.Pages.Shipment.ShipmentAudit" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/ShipmentDialog.ascx" TagName="ShipmentDialog" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .list-item
        {
            font: normal 9px tahoma, arial, helvetica, sans-serif;
            padding: 1px 1px 1px 1px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #bbbbbb;
        }
        .list-item h3
        {
            display: block;
            font: inherit;
            font-weight: normal;
            font-size: 12px;
            color: #222;
        }
    </style>

    <script language="javascript" type="text/javascript">
        var MsgList = {
			btnInsert:{
				FailureTitle:"<%=GetLocalResourceObject("Panel1.btnInsert.MessageBox.alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("Panel1.btnInsert.MessageBox.alert").ToString()%>"
			},
			ShowDetails:{
				FailureTitle:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.MessageBox.alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.MessageBox.alert.Body").ToString()%>"
			},
			DetailStore:{
				LoadExceptionTitle:"<%=GetLocalResourceObject("DetailStore.Alert.Title").ToString()%>"
			},
			ShowDialog:{
				FailureTitle:"<%=GetLocalResourceObject("GridPanel2.AddItemsButton.MessageBox.alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("GridPanel2.AddItemsButton.MessageBox.alert.Body").ToString()%>"
			},
			DeleteItem:{
				ConfirmTitle:"<%=GetLocalResourceObject("GridPanel2.Listeners.Confirm.Title").ToString()%>",
				ConfirmMsg:"<%=GetLocalResourceObject("GridPanel2.Listeners.Confirm.Body").ToString()%>",
				FailureTitle:"<%=GetLocalResourceObject("GridPanel2.Listeners.Alert.Title").ToString()%>"
			},
			AfterEdit:{
				FailureTitle:"<%=GetLocalResourceObject("GridPanel2.Listeners.AfterEdit.Alert.Title").ToString()%>"			
			},
			DeleteButton:{
				FailureTitle:"<%=GetLocalResourceObject("DetailWindow.DeleteButton.Listeners.Alert").ToString()%>"			
			},
			RevokeButton:{
				FailureTitle:"<%=GetLocalResourceObject("DetailWindow.RevokeButton.Listeners.Alert").ToString()%>"			
			},
			CaseInformation:"<%=GetLocalResourceObject("MsgList.CaseInformation").ToString()%>"
        }

        var DIBProductLineID;
        DIBProductLineID = '5cff995d-8ffc-44f6-a0aa-ff750cc36312';
        var CheckAddItemsParam = function() {
            //此函数用来控制“添加产品”按钮的状态
            if (Ext.getCmp('cbProductLineWin').getValue() == '' || Ext.getCmp('cbHospitalWin').getValue() == '') {
                Ext.getCmp('AddItemsButton').disable();
            } else {
                Ext.getCmp('AddItemsButton').enable();
            }
        }

        var SetMod = function(changed) {
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
        var CheckMod = function() {
            var currenStatus = Ext.getCmp('hiddenIsModified').getValue();
            Ext.getCmp('orderTypeWin').hide();
            if (currenStatus == 'new') {
                Coolite.AjaxMethods.DeleteDraft(
                {
                    success: function() {
                        Ext.getCmp('hiddenIsModified').setValue('');
                        Ext.getCmp('GridPanel1').store.reload();
                        Ext.getCmp('DetailWindow').hide();
                    },
                    failure: function(err) {
                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.failure.Alert").ToString()%>', err);
                    }
                }
                );
                return false;
            }
            if (currenStatus == 'newchanged') {
                //第一次新增的窗口
                Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Body").ToString()%>',
                function(e) {
                    if (e == 'yes') {
                        //alert("用户需保存草稿或提交数据");
                    } else {
                        //alert("执行删除草稿的操作");
                        Coolite.AjaxMethods.DeleteDraft(
                        {
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                            },
                            failure: function(err) {
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
                function(e) {
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

        var ChangeProductLine = function() {
            var hiddenProductLineId = Ext.getCmp('hiddenProductLineId');
            var cbProductLineWin = Ext.getCmp('cbProductLineWin');
            var grid = Ext.getCmp('GridPanel2');
            var hiddenIsModified = Ext.getCmp('hiddenIsModified');
            var cbHospitalWin = Ext.getCmp('cbHospitalWin');
            var hiddenHospitalId = Ext.getCmp('hiddenHospitalId');

            if (cbProductLineWin.getValue() == DIBProductLineID) {
                Ext.getCmp('orderTypeWin').show();
            } else {
                Ext.getCmp('orderTypeWin').hide();
            }
            if (hiddenProductLineId.getValue() != cbProductLineWin.getValue()) {
                if (hiddenProductLineId.getValue() == '') {
                    //如果值为空，则说明是第一次选择，不需要删除操作
                    hiddenProductLineId.setValue(cbProductLineWin.getValue());
                    grid.store.reload();
                    cbHospitalWin.clearValue();
                    hiddenHospitalId.setValue('');
                    cbHospitalWin.store.reload();
                    CheckAddItemsParam();
                    ClearItems();
                    SetMod(true);
                } else {
                    Ext.Msg.confirm('<%=GetLocalResourceObject("ChangeProductLine.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("ChangeProductLine.Confirm.Body").ToString()%>',
                        function(e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.OnProductLineChange(
                                    {
                                        success: function() {
                                            hiddenProductLineId.setValue(cbProductLineWin.getValue());
                                            grid.store.reload();
                                            cbHospitalWin.clearValue();
                                            hiddenHospitalId.setValue('');
                                            cbHospitalWin.store.reload();
                                            CheckAddItemsParam();
                                            ClearItems();
                                            SetMod(true);
                                        },
                                        failure: function(err) {
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

        var ChangeHospital = function() {
            var hiddenHospitalId = Ext.getCmp('hiddenHospitalId');
            var cbHospitalWin = Ext.getCmp('cbHospitalWin');
            var grid = Ext.getCmp('GridPanel2');
            var hiddenIsModified = Ext.getCmp('hiddenIsModified');

            if (hiddenHospitalId.getValue() != cbHospitalWin.getValue()) {
                if (hiddenHospitalId.getValue() == '') {
                    hiddenHospitalId.setValue(cbHospitalWin.getValue());
                    grid.store.reload();
                    CheckAddItemsParam();
                    ClearItems();
                    SetMod(true);
                } else {
                    Ext.Msg.confirm('<%=GetLocalResourceObject("ChangeHospital.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("ChangeHospital.Confirm.Body").ToString()%>',
                        function(e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.OnHospitalChange(
                                    {
                                        success: function() {
                                            hiddenHospitalId.setValue(cbHospitalWin.getValue());
                                            grid.store.reload();
                                            CheckAddItemsParam();
                                            ClearItems();
                                            SetMod(true);
                                        },
                                        failure: function(err) {
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
        
    
        
        
        var CheckDraft = function() {
            if(Ext.getCmp('hiddenIsEditting').getValue()!=''){
                            //Ext.Msg.alert('Error','请稍后');
            }
            else
            {
                if(Ext.getCmp('txtMemoWin').getValue().length > 2000)
                {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.DoSubmit.failure.Alert").ToString()%>','<%=GetLocalResourceObject("CheckDraft.Alert.Title").ToString()%>');
                }
                else
                {
                    Coolite.AjaxMethods.SaveDraft({
                        success: function() {
                            Ext.getCmp('hiddenIsModified').setValue('');
                            Ext.getCmp('GridPanel1').store.reload();
                            Ext.getCmp('DetailWindow').hide();
                            Ext.getCmp('orderTypeWin').hide();
                        },
                        failure: function(err) {
                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckDraft.Alert.SaveDraft.Title").ToString()%>', err);
                        }
                    });
                }
           }
        }
        var CheckSubmit = function() {
            if (Ext.getCmp('txtOrderStatusWin').getValue() == '完成') {
                Coolite.AjaxMethods.DoSubmit({
                    success: function(rtn) {
                        if (rtn == 'Done') {
                            Ext.getCmp('hiddenIsModified').setValue('');
                            Ext.getCmp('GridPanel1').store.reload();
                            Ext.getCmp('DetailWindow').hide();
                            Ext.getCmp('orderTypeWin').hide();
                        }
                    },
                    failure: function(err) {
                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.txtOrderStatusWin.failure.Alert").ToString()%>', err);
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
                var txtShipmentDateWin = Ext.getCmp('txtShipmentDateWin');
                if (txtShipmentDateWin.getValue() != '') {
                    if (cbProductLineWin.getValue() != '' && cbHospitalWin.getValue() != '' && grid.store.getCount() > 0) {
                        if (CheckLotQty()) {
                            if (CheckHasConsumableItems()) {
                                Ext.Msg.confirm('<%=GetLocalResourceObject("CheckSubmit.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("CheckSubmit.Confirm.Body").ToString()%>',
                            function(button) {
                                if (button == 'yes') {
                                    Coolite.AjaxMethods.DoSubmit({
                                        success: function(rtn) {
                                            if (rtn == 'Done') {
                                                Ext.getCmp('hiddenIsModified').setValue('');
                                                Ext.getCmp('GridPanel1').store.reload();
                                                Ext.getCmp('DetailWindow').hide();
                                                Ext.getCmp('orderTypeWin').hide();
                                            }
                                        },
                                        failure: function(err) {
                                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.alert").ToString()%>', err);
                                        }
                                    });
                                } else {
                                    return;
                                }
                            }
                        );
                            }
                            else {
                                Coolite.AjaxMethods.DoSubmit({
                                    success: function(rtn) {
                                        if (rtn == 'Done') {
                                            Ext.getCmp('hiddenIsModified').setValue('');
                                            Ext.getCmp('GridPanel1').store.reload();
                                            Ext.getCmp('DetailWindow').hide();
                                            Ext.getCmp('orderTypeWin').hide();




                                        }
                                    },
                                    failure: function(err) {
                                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.alert1").ToString()%>', err);
                                    }
                                });
                            }


                        }
                    } else {
                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.Alert.Title").ToString()%>', ' <%=GetLocalResourceObject("CheckSubmit.Alert.Body").ToString()%>');
                    }
                } else {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.Alert.Title1").ToString()%>', ' <%=GetLocalResourceObject("CheckSubmit.Alert.Body1").ToString()%>');
                }
            }

        }

        var CheckLotQty = function() {
            var store = Ext.getCmp('GridPanel2').store;
            for (var i = 0; i < store.getCount(); i++) {
                var record = store.getAt(i);
                if (record.data.ShipmentQty <= 0) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body").ToString()%>');
                    return false;
                }
                if (record.data.ShipmentQty > record.data.TotalQty) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title1").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body1").ToString()%>');
                    return false;
                }
            }
            return true;
        }

        var CheckQty = function() {
            var txtShipmentQty = Ext.getCmp('txtShipmentQty');
            var grid = Ext.getCmp('GridPanel2');
            var hiddenCurrentEditShipmentId = Ext.getCmp('hiddenCurrentEditShipmentId');
            var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
            var record = grid.store.getById(hiddenCurrentEditShipmentId.getValue());
            //记录当前编辑的行ID
            hiddenIsEditting.setValue(hiddenCurrentEditShipmentId.getValue());
            if (parseInt(txtShipmentQty.getValue()) > parseInt(record.data.TotalQty)) {
                //数量错误时，编辑行置为空
                hiddenIsEditting.setValue('');
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body").ToString()%>');
                return false;
            }
            return true;
        }

        var CheckHasConsumableItems = function() {
            var store = Ext.getCmp('GridPanel2').store;
            for (var i = 0; i < store.getCount(); i++) {
                var record = store.getAt(i);
                if (record.data.IsConsumableItem == '1') {
                    return true;
                }
            }
            return false;
        }

        var prepare = function(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            firstButton.setDisabled(!record.data.Implant);
        }

        var ShowImplantInfoWindow = function(LotId) {
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

        var ShowShipmentOperationPage = function() {
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
                success: function(rtn) {
                    //window.parent.loadExample('/Pages/Shipment/ShipmentOperation.aspx?SPHID=' + SPHID + "&OrderNumber=" + OrderNumber + "&ShipmentDate=" + ShipmentDate + "&Invoice=" + Invoice + "&DateCheck=" + rtn + "&DealerName=" + DealerName + "&HospitalName=" + HospitalName, 'subMenu' + SPHID, MsgList.CaseInformation);
                    top.createTab({ id: 'subMenu' + SPHID, title: MsgList.CaseInformation, url: 'Pages/Shipment/ShipmentOperation.aspx?SPHID=' + SPHID + "&OrderNumber=" + OrderNumber + "&ShipmentDate=" + ShipmentDate + "&Invoice=" + Invoice + "&DateCheck=" + rtn + "&DealerName=" + DealerName + "&HospitalName=" + HospitalName });
                },
                failure: function(err) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("ShowShipmentOperationPage.Alert").ToString()%>', err);
                }
            });


        }
        var resetForm = function() {
            Ext.getCmp('orderTypeWin').hide();
        }

        var shipmentPrint = function() {
            return '<img class="imgPrint" ext:qtip="<%=GetLocalResourceObject("shipmentPrint.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/printer.png" />';
        }

        var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
            var id = record.data['Id'];
            if (t.className == 'imgPrint' && columnId == 'Id') {
               showModalDialog("ShipmentPrint.aspx?id=" + id, window, "status:false;dialogWidth:800px;dialogHeight:500px");
            }
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
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
    <ext:Store ID="ProductLineWinStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLineWin"
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
        <BaseParams>
            <ext:Parameter Name="DealerId" Value="#{hiddenDealerId}.getValue()" Mode="Raw" />
        </BaseParams>
        <Listeners>
            <Load Handler="if (#{hiddenProductLineId}.getValue()==''){#{hiddenProductLineId}.setValue(#{cbProductLineWin}.store.getTotalCount()>0?#{cbProductLineWin}.store.getAt(0).get('Id'):'');}#{cbProductLineWin}.setValue(#{hiddenProductLineId}.getValue());" />
        </Listeners>
        <SortInfo Field="Id" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="HospitalWinStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshHospitalWin"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Address" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <BaseParams>
            <ext:Parameter Name="DealerId" Value="#{hiddenDealerId}.getValue()" Mode="Raw" />
            <ext:Parameter Name="ProductLineId" Value="#{hiddenProductLineId}.getValue()" Mode="Raw" />
        </BaseParams>
        <Listeners>
            <Load Handler="#{cbHospitalWin}.setValue(#{hiddenHospitalId}.getValue());" />
        </Listeners>
        <%--        <SortInfo Field="Name" Direction="ASC" /> Store的排序不对，用SQL的排序--%>
    </ext:Store>
    <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ChineseName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="ShipmentOrderTypeStore" runat="server" UseIdConfirmation="true">
        <BaseParams>
            <ext:Parameter Name="Type" Value="Consts_ShipmentOrder_Type" Mode="Value">
            </ext:Parameter>
        </BaseParams>
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
                    <ext:RecordField Name="OrderNumber" />
                    <ext:RecordField Name="HospitalId" />
                    <ext:RecordField Name="HospitalName" />
                    <ext:RecordField Name="ShipmentDate"/>
                    <ext:RecordField Name="ShipmentName" />
                    <ext:RecordField Name="Status" />
                    <ext:RecordField Name="ReverseId" />
                    <ext:RecordField Name="ProductLine" />
                    <ext:RecordField Name="TotalQyt" />
                    <ext:RecordField Name="TotalAmount" />
                    <ext:RecordField Name="Type" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="ShipmentDate" Direction="DESC" />
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources:Panel1.Title %>" AutoHeight="true"
                        BodyStyle="padding: 5px;" Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources:Panel1.FormLayout1.cbProductLine.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                        ListWidth="300" Resizable="true" DisplayField="AttributeName" FieldLabel="<%$ Resources:Panel1.FormLayout1.cbProductLine.FieldLabel %>">
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
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources:Panel1.FormLayout2.cbDealer.EmptyText %>"
                                                        Width="220" Editable="true" TypeAhead="true" StoreID="DealerStore" ValueField="Id"
                                                        DisplayField="ChineseName" Mode="Local" ListWidth="300" Resizable="true" FieldLabel="<%$ Resources:Panel1.FormLayout2.cbDealer.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:Panel1.FormLayout2.cbDealer.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
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
                                                    <ext:TextField ID="txtUPN" runat="server" Width="150" FieldLabel="<%$ Resources:Panel1.FormLayout2.txtUPN.FieldLabel %>"
                                                        Hidden="<%$ AppSettings: HiddenUPN  %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtSubmitDateEnd" runat="server" Width="150" FieldLabel="<%$ Resources:Panel1.FormLayout1.txtSubmitDateEnd.FieldLabel%>" />
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
                                                    <ext:ComboBox ID="cbOrderStatus" runat="server" EmptyText="<%$ Resources:Panel1.FormLayout3.cbOrderStatus.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="OrderStatusStore" ValueField="Key"
                                                        DisplayField="Value" FieldLabel="<%$ Resources:Panel1.FormLayout3.cbOrderStatus.FieldLabel %>">
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
                                                    <ext:ComboBox ID="cbShipmentOrderTypeWin" runat="server" EmptyText=" " Width="150"
                                                        Editable="false" TypeAhead="true" StoreID="ShipmentOrderTypeStore" ValueField="Key"
                                                        DisplayField="Value" FieldLabel="<%$ Resources:Panel1.FormLayout3.ShipmentOrderType.FieldLabel %>"
                                                        Mode="Local">
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
                            <ext:Button ID="btnSearch" Text="<%$ Resources:Panel1.btnSearch.Text %>" runat="server"
                                Icon="ArrowRefresh" IDMode="Legacy" StyleSpec="margin-right:100px">
                                <Listeners>
                                    <Click Handler="#{GridPanel1}.reload();" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources:GridPanel1.Title %>"
                                    StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="DealerId" DataIndex="DealerId" Header="<%$ Resources:GridPanel1.ColumnModel1.DealerId.Header %>"
                                                Width="180">
                                                <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="OrderNumber" DataIndex="OrderNumber" Header="<%$ Resources:GridPanel1.ColumnModel1.OrderNumber.Header %>"
                                                Width="195">
                                            </ext:Column>
                                            <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="<%$ Resources:GridPanel1.ColumnModel1.HospitalName.Header %>"
                                                Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="TotalQyt" DataIndex="TotalQyt" Header="<%$ Resources:GridPanel1.ColumnModel1.TotalQyt.Header %>"
                                                Width="60" Align="Right">
                                            </ext:Column>
                                            <ext:Column ColumnID="TotalAmount" DataIndex="TotalAmount" Header="<%$ Resources:GridPanel1.ColumnModel1.TotalAmount.Header %>"
                                                Width="80" Align="Right">
                                            </ext:Column>
                                            <ext:Column ColumnID="ShipmentDate" DataIndex="ShipmentDate" Header="<%$ Resources:GridPanel1.ColumnModel1.ShipmentDate.Header %>"
                                                Width="80">                                               
                                            </ext:Column>
                                            <ext:Column ColumnID="ShipmentName" DataIndex="ShipmentName" Header="<%$ Resources:GridPanel1.ColumnModel1.ShipmentName.Header %>"
                                                Width="80">
                                                
                                            </ext:Column>
                                            <ext:Column ColumnID="Status" DataIndex="Status" Header="<%$ Resources:GridPanel1.ColumnModel1.Status.Header %>"
                                                Align="Center">
                                                <Renderer Handler="return getNameFromStoreById(OrderStatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="Type" DataIndex="Type" Header="<%$ Resources:Panel1.FormLayout3.ShipmentOrderType.FieldLabel %>"
                                                Align="Center">
                                                <Renderer Handler="return getNameFromStoreById(ShipmentOrderTypeStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:CommandColumn Width="60" Header="<%$ Resources:GridPanel1.ColumnModel1.CommandColumn.Header %>"
                                                Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="<%$ Resources:GridPanel1.ColumnModel1.CommandColumn.ToolTip.Text %>" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                            <ext:Column ColumnID="Id" DataIndex="Id" Header="<%$ Resources:GridPanel1.ColumnModel1.Id.Header %>"
                                                Align="Center">
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
                                            Success="#{cbDealerWin}.clearValue(); #{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.clearValue(); #{ProductLineWinStore}.reload();#{cbHospitalWin}.clearValue();#{HospitalWinStore}.reload();ClearItems();#{GridPanel2}.reload();#{hiddenIsModified}.setValue('old');#{gpLog}.store.reload();">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                            <ExtraParams>
                                                <ext:Parameter Name="OrderId" Value="#{GridPanel1}.getSelectionModel().getSelected().id"
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
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.DetailStore.LoadExceptionTitle, e.message || response.statusText);" />
        </Listeners>
        <%--        <SortInfo Field="CFN" Direction="ASC" /> 要按CFN,UPN,LotNumber排序 --%>
    </ext:Store>
    <ext:Hidden ID="hiddenOrderId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenDealerId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenProductLineId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenHospitalId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenIsModified" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenCurrentEditShipmentId" runat="server" />
    <ext:Hidden ID="hiddenIsEditting" runat="server" />
    <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
        Width="900" Height="494" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false">
        <Body>
            <ext:BorderLayout ID="BorderLayout2" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:Panel ID="Panel11" runat="server">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".38">
                                            <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="60">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDealerWin" runat="server" Width="250" Editable="true" TypeAhead="true"
                                                                Mode="Local" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName"
                                                                FieldLabel="<%$ Resources: Panel7.FormLayout4.cbDealerWin.FieldLabel %>" ListWidth="300"
                                                                Resizable="true" AllowBlank="false" BlankText="<%$ Resources: Panel7.FormLayout4.cbDealerWin.BlankText %>"
                                                                EmptyText="<%$ Resources: Panel7.FormLayout4.cbDealerWin.EmptyText %>">
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                             <ext:Anchor>
                                                            <ext:Checkbox ID="cbIsAuthWin" FieldLabel="非授权医院" runat="server" Hidden="true">
                                                                <%--<Listeners>
                                                                    <Check Handler=" Coolite.AjaxMethods.ReLoadHositalStore()" />
                                                                </Listeners>--%>
                                                            </ext:Checkbox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbProductLineWin" runat="server" Width="200" Editable="false" TypeAhead="true"
                                                                StoreID="ProductLineWinStore" ValueField="Id" DisplayField="AttributeName" FieldLabel="<%$ Resources: Panel7.FormLayout4.cbProductLineWin.FieldLabel %>"
                                                                ListWidth="300" Resizable="true" AllowBlank="false" BlankText="<%$ Resources: Panel7.FormLayout4.cbProductLineWin.BlankText %>"
                                                                EmptyText="<%$ Resources: Panel7.FormLayout4.cbProductLineWin.EmptyText %>">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel7.FormLayout4.cbProductLineWin.FieldTrigger.Qtip %>"
                                                                        HideTrigger="true" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                    <Select Handler="ChangeProductLine();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".38">
                                            <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="60">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtOrderNumberWin" runat="server" FieldLabel="<%$ Resources: Panel8.FormLayout5.txtOrderNumberWin.FieldLabel %>"
                                                                ReadOnly="true" Width="200" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbHospitalWin" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                                StoreID="HospitalWinStore" ValueField="Id" DisplayField="Name" FieldLabel="<%$ Resources: Panel8.FormLayout5.cbHospitalWin.FieldLabel %>"
                                                                AllowBlank="false" BlankText="<%$ Resources:Panel8.FormLayout5.cbHospitalWin.BlankText %>"
                                                                EmptyText="<%$ Resources:Panel8.FormLayout5.cbHospitalWin.EmptyText %>" Mode="Local"
                                                                Resizable="true" ListWidth="300" ItemSelector="div.list-item">
                                                                <Template ID="Template1" runat="server">
                                                                    <tpl for=".">
                                                                        <div class="list-item">
                                                                             <h3>{Name}</h3>
                                                                             <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{Address}</p>   
                                                                        </div>
                                                                    </tpl>
                                                                </Template>
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:Panel8.FormLayout5.cbHospitalWin.FieldTrigger.Qtip %>"
                                                                        HideTrigger="true" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                    <Select Handler="ChangeHospital();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".24">
                                            <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="70">
                                                        <ext:Anchor>
                                                            <ext:DateField ID="txtShipmentDateWin" runat="server" Width="100" FieldLabel="<%$ Resources:Panel9.FormLayout6.txtShipmentDateWin.FieldLabel %>" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtOrderStatusWin" runat="server" FieldLabel="<%$ Resources:Panel9.FormLayout6.txtOrderStatusWin.FieldLabel %>"
                                                                ReadOnly="true" Width="80" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                            </ext:Panel>
                            <ext:Panel ID="Panel13" runat="server">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                        <ext:LayoutColumn ColumnWidth="0.38">
                                            <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="60">
                                                        <ext:Anchor>
                                                            <ext:TextArea ID="txtMemoWin" runat="server" FieldLabel="<%$ Resources:Panel14.FormLayout8.txtMemoWin.FieldLabel %>"
                                                                Width="250" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth="0.38 ">
                                            <ext:Panel ID="PanelOrderType" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="formLayoutOrderType" runat="server" LabelAlign="Left" LabelWidth="60">
                                                        <%--   <ext:Anchor>
                                                            <ext:TextField ID="txtTotalAmount" runat="server" FieldLabel="<%$ Resources:PanelOrderType.txtTotalAmount.FieldLabel %>"
                                                                ReadOnly="true" Width="80" Hidden="true" />
                                                        </ext:Anchor>--%>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtOfficeWin" runat="server" FieldLabel="<%$ Resources:Panel12.FormLayout6.txtOffice.FieldLabel%>"
                                                                Width="200" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtInvoice" runat="server" FieldLabel="<%$ Resources:Panel12.FormLayout6.txtInvoiceNumber.FieldLabel%>"
                                                                Width="200" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtInvoiceTitleWin" runat="server" FieldLabel="<%$ Resources:Panel12.FormLayout6.txtInvoiceTitle.FieldLabel%>"
                                                                Width="200" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:DateField ID="txtInvoiceDateWin" runat="server" FieldLabel="<%$ Resources:txtInvoiceDate.FieldLabel%>"
                                                                Width="200" />
                                                        </ext:Anchor>
                                                        <ext:Anchor Horizontal="50%">
                                                            <ext:RadioGroup ID="orderTypeWin" runat="server" FieldLabel="<%$ Resources:PanelOrderType.orderTypeWin.FieldLabel %>"
                                                                ColumnsNumber="2" Width="100" Hidden="true">
                                                                <Items>
                                                                    <ext:Radio ID="rbPersonalWin" runat="server" BoxLabel="<%$ Resources:PanelOrderType.orderTypeWin.rbPersonalWin.BoxLabel %>"
                                                                        Checked="false" />
                                                                    <ext:Radio ID="rbHospitalWin" runat="server" BoxLabel="<%$ Resources:PanelOrderType.orderTypeWin.rbHospitalWin.BoxLabel %>"
                                                                        Checked="true" />
                                                                </Items>
                                                            </ext:RadioGroup>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".24">
                                            <ext:Panel ID="Panel15" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="formLayout9" runat="server" LabelAlign="Left" LabelWidth="70">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtTotalQty" runat="server" FieldLabel="<%$ Resources:PanelOrderType.txtTotalQty.FieldLabel %>"
                                                                ReadOnly="true" Width="80" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtTotalAmount" runat="server" FieldLabel="<%$ Resources:PanelOrderType.txtTotalAmount.FieldLabel %>"
                                                                ReadOnly="true" Width="80" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtShipmentOrderTypeWin" runat="server" FieldLabel="<%$ Resources:Panel1.FormLayout3.ShipmentOrderType.FieldLabel %>"
                                                                ReadOnly="true" Width="90" />
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
                <Center MarginsSummary="0 5 0 5">
                    <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                        <Tabs>
                            <ext:Tab ID="TabSearch" runat="server" Title="<%$ Resources:TabPanel1.TabSearch.Text%>"
                                AutoScroll="true">
                                <Body>
                                    <ext:Panel ID="Panel10" runat="server" Height="245" Header="false">
                                        <Body>
                                            <ext:FitLayout ID="FitLayout2" runat="server">
                                                <ext:GridPanel ID="GridPanel2" runat="server" Title="<%$ Resources:GridPanel2.TabSearchResult.Text%>"
                                                    StoreID="DetailStore" Border="false" Icon="Lorry" AutoWidth="true" ClicksToEdit="1"
                                                    EnableHdMenu="false" StripeRows="true">
                                                    <TopBar>
                                                        <ext:Toolbar ID="Toolbar1" runat="server">
                                                            <Items>
                                                                <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                                <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources:GridPanel2.AddItemsButton.Text %>"
                                                                    Icon="Add">
                                                                    <AjaxEvents>
                                                                        <Click OnEvent="ShowDialog" Failure="Ext.MessageBox.alert(MsgList.ShowDialog.FailureTitle, MsgList.ShowDialog.FailureMsg);">
                                                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{DetailWindow}.body}" />
                                                                            <ExtraParams>
                                                                                <ext:Parameter Name="OrderId" Value="#{hiddenOrderId}.getValue()" Mode="Raw">
                                                                                </ext:Parameter>
                                                                                <ext:Parameter Name="DealerWarehouseType" Value="#{txtShipmentOrderTypeWin}.getValue()"
                                                                                    Mode="Raw">
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
                                                            <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="<%$ Resources:GridPanel2.ColumnModel2.WarehouseName.Header %>"
                                                                Width="190">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="CFN" DataIndex="CFN" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                                Width="100">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="UPN" DataIndex="UPN" Header="<%$ Resources:GridPanel2.ColumnModel2.UPN.Header %>"
                                                                Width="100" Hidden="<%$ AppSettings: HiddenUPN  %>">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources:GridPanel2.ColumnModel2.LotNumber.Header %>"
                                                                Width="100">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources:GridPanel2.ColumnModel2.ExpiredDate.Header %>"
                                                                Width="80">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources:GridPanel2.ColumnModel2.UnitOfMeasure.Header %>"
                                                                Width="50" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="<%$ Resources:GridPanel2.ColumnModel2.TotalQty.Header %>"
                                                                Width="70" Align="Right">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="UnitPrice" DataIndex="UnitPrice" Header="<%$ Resources:GridPanel2.ColumnModel2.UnitPrice.Header %>"
                                                                Width="60" Align="Right">
                                                                <Editor>
                                                                    <ext:NumberField ID="txtUnitPrice" runat="server" AllowBlank="false" DecimalPrecision="2"
                                                                        AllowDecimals="true" SelectOnFocus="true" AllowNegative="false">
                                                                    </ext:NumberField>
                                                                </Editor>
                                                            </ext:Column>
                                                            <ext:Column ColumnID="ShipmentQty" DataIndex="ShipmentQty" Header="<%$ Resources:GridPanel2.ColumnModel2.ShipmentQty.Header %>"
                                                                Width="80" Align="Right">
                                                                <Editor>
                                                                    <ext:NumberField ID="txtShipmentQty" runat="server" AllowBlank="false" AllowDecimals="true"
                                                                        SelectOnFocus="true" AllowNegative="false">
                                                                    </ext:NumberField>
                                                                </Editor>
                                                            </ext:Column>
                                                            <ext:CommandColumn Width="50" Header="<%$ Resources:GridPanel2.ColumnModel2.CommandColumn.Header %>"
                                                                Align="Center">
                                                                <Commands>
                                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources:GridPanel2.ColumnModel2.GridCommand.ToolTip-Text %>" />
                                                                    <%--                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit" ToolTip-Text="Edit" />--%>
                                                                </Commands>
                                                            </ext:CommandColumn>
                                                            <ext:CommandColumn Width="60" Header="<%$ Resources:GridPanel2.ColumnModel2.CommandColumn.Header1 %>"
                                                                Align="Center" Hidden="true">
                                                                <Commands>
                                                                    <ext:GridCommand Icon="VcardEdit" CommandName="Implant" />
                                                                </Commands>
                                                                <PrepareToolbar Fn="prepare" />
                                                            </ext:CommandColumn>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="DetailStore"
                                                            DisplayInfo="false" />
                                                    </BottomBar>
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
                                                        <AfterEdit Handler="
                                            Coolite.AjaxMethods.SaveItem(#{txtShipmentQty}.getValue(),#{txtUnitPrice}.getValue(),{success:function(){#{hiddenIsEditting}.setValue('');},failure: function(err) {Ext.Msg.alert(MsgList.AfterEdit.FailureTitle, err);}});" />
                                                        <%--将当前编辑行Id保存下来 --%>
                                                        <BeforeEdit Handler="#{hiddenCurrentEditShipmentId}.setValue(this.getSelectionModel().getSelected().id);
                                                            #{txtShipmentQty}.setValue(this.getSelectionModel().getSelected().data.ShipmentQty);
                                                            #{txtUnitPrice}.setValue(this.getSelectionModel().getSelected().data.UnitPrice);" />
                                                    </Listeners>
                                                </ext:GridPanel>
                                            </ext:FitLayout>
                                        </Body>
                                    </ext:Panel>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources:TabLog.Text%>" AutoScroll="true">
                                <Body>
                                    <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources:TabLog.gpLog.Text%>"
                                        StoreID="OrderLogStore" AutoWidth="true" StripeRows="true" Collapsible="false"
                                        Border="false" Icon="Lorry" Height="245" Width="874">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="<%$ Resources:TabLog.OperUserId.Text%>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources:TabLog.OperUserName.Text%>"
                                                    Width="170">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="<%$ Resources:TabLog.OperTypeName.Text%>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="<%$ Resources:TabLog.OperDate.Text%>"
                                                    Width="150">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources:TabLog.OperNote.Text%>"
                                                    Width="200">
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
                                                DisplayInfo="false" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </Body>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </Center>
            </ext:BorderLayout>
        </Body>
        <Buttons>
            <ext:Button ID="BaoTaiButton" runat="server" Text="<%$ Resources:DetailWindow.BaoTaiButton.Text %>"
                Icon="NoteEdit">
                <Listeners>
                    <Click Handler="ShowShipmentOperationPage();" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="SubmitButton" runat="server" Text="<%$ Resources:DetailWindow.SubmitButton.Text %>"
                Icon="LorryAdd">
                <Listeners>
                    <Click Handler="CheckSubmit();" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="RevokeButton" runat="server" Text="<%$ Resources:DetailWindow.RevokeButton.Text %>"
                Icon="Cancel">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.DoRevoke({
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                                Ext.getCmp('orderTypeWin').hide();
                            },
                            failure: function(err) {
                                Ext.Msg.alert(MsgList.RevokeButton.FailureTitle, err);
                            }
                        });" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="ApproveButton" runat="server" Text="<%$ Resources:DetailWindow.ApproveButton.Text %>"
                Icon="Accept">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.DoRevoke({
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                                Ext.getCmp('orderTypeWin').hide();
                            },
                            failure: function(err) {
                                Ext.Msg.alert(MsgList.RevokeButton.FailureTitle, err);
                            }
                        });" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="RejectButton" runat="server" Text="<%$ Resources:DetailWindow.RejectButton.Text %>"
                Icon="Cancel">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.DoReject({
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                                Ext.getCmp('orderTypeWin').hide();
                            },
                            failure: function(err) {
                                Ext.Msg.alert(MsgList.RevokeButton.FailureTitle, err);
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
    <uc1:ShipmentDialog ID="ShipmentDialog1" runat="server" />
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
