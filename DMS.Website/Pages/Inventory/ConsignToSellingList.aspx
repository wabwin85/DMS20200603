<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConsignToSellingList.aspx.cs"
    Inherits="DMS.Website.Pages.Inventory.ConsignToSellingList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/InventoryAdjustDialog.ascx" TagName="InventoryAdjustDialog"
    TagPrefix="uc2" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
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

    <script language="javascript">
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

        var CheckAddItemsParam = function () {
            //此函数用来控制“添加产品”按钮的状态
            if (Ext.getCmp('cbProductLineWin').getValue() == '' || Ext.getCmp('cbAdjustTypeWin').getValue() == '') {
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
                    grid.store.reload();
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
                                                grid.store.reload();
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

                        var ChangeAdjustType = function () {
                            var hiddenAdjustTypeId = Ext.getCmp('hiddenAdjustTypeId');
                            var cbAdjustTypeWin = Ext.getCmp('cbAdjustTypeWin');
                            var grid = Ext.getCmp('GridPanel2');
                            var hiddenIsModified = Ext.getCmp('hiddenIsModified');
                            grid.getColumnModel().setEditable(10, true);

                            if (hiddenAdjustTypeId.getValue() != cbAdjustTypeWin.getValue()) {
                                if (hiddenAdjustTypeId.getValue() == '') {
                                    hiddenAdjustTypeId.setValue(cbAdjustTypeWin.getValue());
                                    grid.store.reload();
                                    CheckAddItemsParam();
                                    ClearItems();
                                    SetMod(true);
                                } else {
                                    Ext.Msg.confirm('<%=GetLocalResourceObject("ChangeAdjustType.confirm.Title").ToString()%>', '<%=GetLocalResourceObject("ChangeAdjustType.confirm.Body").ToString()%>',
                            function (e) {
                                if (e == 'yes') {
                                    Coolite.AjaxMethods.OnAdjustTypeChange(
                                        {
                                            success: function () {
                                                hiddenAdjustTypeId.setValue(cbAdjustTypeWin.getValue());
                                                grid.store.reload();
                                                CheckAddItemsParam();
                                                ClearItems();
                                                SetMod(true);
                                            },
                                            failure: function (err) {
                                                Ext.Msg.alert('<%=GetLocalResourceObject("ChangeAdjustType.Alert.Title").ToString()%>', err);
                                            }
                                        }
                                );
                                        }
                                        else {
                                            cbAdjustTypeWin.setValue(hiddenAdjustTypeId.getValue());
                                        }
                            }
                    );
                                }
                            }

                    }

        var CheckDraft = function() {
            if(Ext.getCmp('hiddenIsEditting').getValue()!=''){
                        //Ext.Msg.alert('Error','请稍后');
                    }else
                    {
                        if(Ext.getCmp('txtAdjustReasonWin').getValue().length > 2000)
                        {
                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckAdjustReason").ToString()%>');
                        }
                        else
                        {
                            Coolite.AjaxMethods.SaveDraft({
                                success: function() {
                                    Ext.getCmp('hiddenIsModified').setValue('');
                                    Ext.getCmp('GridPanel1').store.reload();
                                    Ext.getCmp('DetailWindow').hide();
                                },
                                failure: function(err) {
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
            var cbAdjustTypeWin = Ext.getCmp('cbAdjustTypeWin');
            var txtAdjustReasonWin = Ext.getCmp('txtAdjustReasonWin');
            var hiddenIsRsm=Ext.getCmp('hiddenIsRsm');
            var cbRsm=Ext.getCmp('cbRsm');
            var grid = Ext.getCmp('GridPanel2');
            if (cbProductLineWin.getValue() != '' && cbAdjustTypeWin.getValue() != '' && txtAdjustReasonWin.getValue() != '' && grid.store.getCount() > 0) {

            if(hiddenIsRsm.getValue()=='true' && cbRsm.getValue()=='')
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.Alert.Title1").ToString()%>', ' <%=GetLocalResourceObject("CheckSubmit.Alert.Body1").ToString()%>');
                return ;
            }
                if (CheckLotQty()) {
                    Coolite.AjaxMethods.DoSubmit({
                        success: function() {
                            Ext.getCmp('hiddenIsModified').setValue('');
                            Ext.getCmp('GridPanel1').store.reload();
                            Ext.getCmp('DetailWindow').hide();
                        },
                        failure: function(err) {
                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.failure.Alert.Title").ToString()%>', err);
                        }
                    });
                    }
                } else {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.Alert.Title1").ToString()%>', ' <%=GetLocalResourceObject("CheckSubmit.Alert.Body1").ToString()%>');
            }
                    }


        var CheckLotQty = function () {
            var store = Ext.getCmp('GridPanel2').store;
            for (var i = 0; i < store.getCount() ; i++) {
                var record = store.getAt(i);
                if (record.data.AdjustQty <= 0) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body").ToString()%>');
                    return false;
                }
                if (record.data.LotNumber == "" || record.data.LotNumber == null) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title1").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body1").ToString()%>');
                    return false;
                }
                if (accMin(record.data.TotalQty, record.data.AdjustQty) < 0) {
                    //数量错误时，编辑行置为空
                    hiddenIsEditting.setValue('');
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body").ToString()%>');
                    return false;
                }
                if (record.data.QRCode == 'NoQR' && record.data.QRCodeEdit == '') {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '二维码为NoQR的产品必须填写二维码');
                    return false;
                }
                if (record.data.QRCodeEdit != null && record.data.QRCodeEdit != '' && record.data.AdjustQty > 1) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '带二维码的产品数量不得大于一');
                    return false;
                }
                if (store.query("QRCodeEdit", record.data.QRCodeEdit).length > 1 && record.data.QRCodeEdit != '') {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '二维码' + record.data.QRCodeEdit + "出现多次");
                    return false;
                }
                if (store.query("QRCode", record.data.QRCodeEdit).length > 0 && record.data.QRCode != "NoQR" && record.data.QRCodeEdit != '') {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '二维码' + record.data.QRCode + "已使用");
                       return false;
                   }
               }
            return true;
        }

           //校验用户输入数量
           var CheckQty = function () {
               var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
               var txtAdjustQty = Ext.getCmp('txtAdjustQty');
               var grid = Ext.getCmp('GridPanel2');
               var hiddenCurrentEdit = Ext.getCmp('hiddenCurrentEdit');
               var record = grid.store.getById(hiddenCurrentEdit.getValue());
               //记录当前编辑的行ID
               hiddenIsEditting.setValue(hiddenCurrentEdit.getValue());

               if (accMin(record.data.TotalQty, txtAdjustQty.getValue()) < 0) {
                   //数量错误时，编辑行置为空
                   hiddenIsEditting.setValue('');
                   Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body").ToString()%>');
                   return false;
               }
               //alert(accMul(txtAdjustQty.getValue(),1000000));
               //alert(accDiv(1,record.data.ConvertFactor).mul(1000000));
               if (accMul(txtAdjustQty.getValue(), 1000000) % accDiv(1, record.data.ConvertFactor).mul(1000000) != 0) {
                   hiddenIsEditting.setValue('');
                   Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body1").ToString()%>' + accDiv(1, record.data.ConvertFactor).toString());
                return false;
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
        function IsHiddenRsm(){
         var cbHospit = Ext.getCmp('<%=this.cbRsm.ClientID%>');
         cbHospit.store.removeAll();
        cbHospit.setValue('');
         Coolite.AjaxMethods.IsHiddenRsm({
           success: function() {
                     
                            Ext.getCmp('<%=this.cbRsm.ClientID%>').reload();
                        },
                        failure: function(err) {
                       
                        }
         })
        
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
            <Listeners>
                <Load Handler="#{RsmStore}.reload();" />
            </Listeners>
            <SortInfo Field="Id" Direction="ASC" />
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
        <ext:Store ID="AdjustTypeWinStore" runat="server" UseIdConfirmation="true">
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
                        <ext:RecordField Name="AdjustReason" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--        <SortInfo Field="AdjustNumber" Direction="ASC" />--%>
        </ext:Store>
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
                                                            Width="220" Editable="true" TypeAhead="true" StoreID="DealerStore" ValueField="Id"
                                                            DisplayField="ChineseShortName" Mode="Local" FieldLabel="<%$ Resources: Panel1.FormLayout2.cbDealer.FieldLabel %>"
                                                            ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout2.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
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
                                                        <ext:ComboBox ID="cbAdjustType" runat="server" EmptyText="选择类型..." Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="AdjustTypeStore" ValueField="Key" DisplayField="Value"
                                                            FieldLabel="<%$ Resources: GridPanel1.ColumnModel1.Type.Header %>">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout3.FieldTrigger.Qtip %>" />
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
                                                        <ext:TextField ID="txtLotNumber2" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout3.txtLotNumber2.FieldLabel %>" />
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
                                        <%-- <Click Handler="#{GridPanel1}.reload();" />--%>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: Panel1.btnInsert.Text %>"
                                    Icon="Add" IDMode="Legacy">
                                    <AjaxEvents>
                                        <Click Before="#{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowDetails"
                                            Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                            Success="#{cbDealerWin}.clearValue();#{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.setValue(#{cbProductLineWin}.store.getTotalCount()>0?#{cbProductLineWin}.store.getAt(0).get('Id'):'');#{hiddenProductLineId}.setValue(#{cbProductLineWin}.getValue());#{cbAdjustTypeWin}.clearValue();ClearItems();#{GridPanel2}.clear();#{hiddenIsModified}.setValue('new');#{cbRsm}.store.reload();">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}"
                                                Msg="<%$ Resources: GridPanel1.AjaxEvents.EventMask.Msg %>" />
                                            <ExtraParams>
                                                <ext:Parameter Name="AdjustId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                        StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerId" DataIndex="DealerId" Header="<%$ Resources: GridPanel1.ColumnModel1.DealerId.Header %>"
                                                    Width="180">
                                                    <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="AdjustNumber" DataIndex="AdjustNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.AdjustNumber.Header %>"
                                                    Width="180">
                                                </ext:Column>
                                                <ext:Column ColumnID="Type" DataIndex="Type" Header="<%$ Resources: GridPanel1.ColumnModel1.Type.Header %>">
                                                    <Renderer Handler="return getNameFromStoreById(AdjustTypeStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="TotalQyt" DataIndex="TotalQyt" Header="<%$ Resources: GridPanel1.ColumnModel1.TotalQyt.Header %>"
                                                    Align="Right">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="<%$ Resources: GridPanel1.ColumnModel1.CreateDate.Header %>"
                                                    Align="Right">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateUserName" DataIndex="CreateUserName" Header="<%$ Resources: GridPanel1.ColumnModel1.CreateUserName.Header %>"
                                                    Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="AdjustReason" DataIndex="AdjustReason" Header="<%$ Resources: GridPanel1.ColumnModel1.AdjustReason.Header %>"
                                                    Width="230">
                                                </ext:Column>
                                                <ext:Column ColumnID="Status" DataIndex="Status" Header="<%$ Resources: GridPanel1.ColumnModel1.Status.Header %>"
                                                    Align="Center">
                                                    <Renderer Handler="return getNameFromStoreById(AdjustStatusStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>"
                                                    Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.ToolTip.Text %>" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <AjaxEvents>
                                            <Command OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.ShowDetails.FailureTitle, MsgList.ShowDetails.FailureMsg);"
                                                Success="#{cbDealerWin}.clearValue(); #{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.clearValue(); #{cbProductLineWin}.setValue(#{hiddenProductLineId}.getValue());#{cbAdjustTypeWin}.setValue(#{hiddenAdjustTypeId}.getValue());ClearItems();#{GridPanel2}.reload();#{hiddenIsModified}.setValue('old');#{gpLog}.store.reload();#{cbRsm}.store.reload();">
                                                <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}"
                                                    Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                                <ExtraParams>
                                                    <ext:Parameter Name="AdjustId" Value="#{GridPanel1}.getSelectionModel().getSelected().id"
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
                        <ext:RecordField Name="AdjustQty" />
                        <ext:RecordField Name="TotalQty" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="WarehouseId" />
                        <ext:RecordField Name="CreatedDate" DateFormat="Ymd" Type="Date" />
                        <ext:RecordField Name="PurchaseOrderNbr" />
                        <ext:RecordField Name="CFNEnglishName" />
                        <ext:RecordField Name="CFNChineseName" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="QRCode" />
                        <ext:RecordField Name="QRCodeEdit" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
            </Listeners>
            <%--        <SortInfo Field="CFN" Direction="ASC" />--%>
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
        <ext:Store ID="RsmStore" runat="server" UseIdConfirmation="true" OnRefreshData="RsmStore_RefershData"
            AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="UserAccount">
                    <Fields>
                        <ext:RecordField Name="UserAccount" />
                        <ext:RecordField Name="Name" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{cbRsm}.setValue(#{hidSalesAccount}.getValue());" />
                <LoadException Handler="Ext.Msg.alert('RSM - Load failed', e.message || response.statusText);" />
            </Listeners>
        </ext:Store>
        <ext:Hidden ID="hidIsPageNew" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidSalesAccount" runat="server">
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
        <ext:Hidden ID="hiddenIsRsm" runat="server"> 
        </ext:Hidden>
        <ext:Hidden ID="hiddenCurrentEdit" runat="server" />
        <ext:Hidden ID="hiddenIsEditting" runat="server" />
        <ext:Hidden ID="hiddenDealerType" runat="server" />
        <ext:Hidden ID="hiddenLotNumber" runat="server" />
        <ext:Hidden ID="hiddenQrCode" runat="server" />
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="寄售转销售调整" Width="950"
            Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:Panel ID="Panel11" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".4">
                                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbDealerWin" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                                    Mode="Local" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName"
                                                                    FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.FieldLabel %>"
                                                                    AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.BlankText %>"
                                                                    EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.EmptyText %>"
                                                                    ListWidth="300" Resizable="true">
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbProductLineWin" runat="server" Width="200" Editable="false" TypeAhead="true"
                                                                    StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.FieldLabel %>"
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
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".3">
                                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtAdjustNumberWin" Width="150" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout5.txtAdjustNumberWin.FieldLabel %>"
                                                                    ReadOnly="true" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtAdjustStatusWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtAdjustStatusWin.FieldLabel %>"
                                                                    ReadOnly="true" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".3">
                                                <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtAdjustDateWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtAdjustDateWin.FieldLabel %>"
                                                                    ReadOnly="true" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbAdjustTypeWin" runat="server" Width="150" Editable="false" TypeAhead="true"
                                                                    StoreID="AdjustTypeWinStore" ValueField="Key" DisplayField="Value" FieldLabel="<%$ Resources: DetailWindow.FormLayout5.cbAdjustTypeWin.FieldLabel %>"
                                                                    AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout5.cbAdjustTypeWin.BlankText %>"
                                                                    EmptyText="<%$ Resources: DetailWindow.FormLayout5.cbAdjustTypeWin.EmptyText %>">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout5.FieldTrigger.Qtip %>"
                                                                            HideTrigger="true" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <Select Handler="ChangeAdjustType();" />
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
                                <ext:Panel ID="Panel13" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".4">
                                                <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:TextArea ID="txtAdjustReasonWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout8.txtAdjustReasonWin.FieldLabel %>"
                                                                    Width="200" SelectOnFocus="true" Height="50" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".3">
                                                <ext:Panel ID="Panel15" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:TextArea ID="txtAduitNoteWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout9.txtAduitNoteWin.FieldLabel %>"
                                                                    Width="150" SelectOnFocus="true" Height="50" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".3">
                                                <ext:Panel ID="Panel10" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbRsm" runat="server" Width="150" TypeAhead="true" StoreID="RsmStore"
                                                                    ValueField="UserAccount" DisplayField="Name" FieldLabel="RSM" BlankText="请选择"
                                                                    EmptyText="请选择RSM" ListWidth="150" Resizable="true">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="" />
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
                                                StoreID="DetailStore" StripeRows="true" Collapsible="false" Border="false" Icon="Lorry"
                                                ClicksToEdit="1" AutoExpandColumn="CFNChineseName" Header="false">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar1" runat="server">
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
                                                            Width="150">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CFNEnglishName" DataIndex="CFNEnglishName" Header="<%$ Resources: CFNEnglishName %>"
                                                            Width="200">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CFNChineseName" DataIndex="CFNChineseName" Header="<%$ Resources:CFNChineseName %>">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CFN" DataIndex="CFN" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                            Width="120">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UPN" DataIndex="UPN" Header="<%$ Resources: GridPanel2.ColumnModel2.UPN.Header %>"
                                                            Width="120" Hidden="<%$ AppSettings: HiddenUPN  %>">
                                                            <Editor>
                                                                <ext:TextField ID="txtCFNEdit" runat="server" AllowBlank="false" SelectOnFocus="true"
                                                                    DataIndex="CFN">
                                                                </ext:TextField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel2.ColumnModel2.LotNumber.Header %>"
                                                            Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Width="100">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources: GridPanel2.ColumnModel2.ExpiredDate.Header %>"
                                                            Width="70">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources: GridPanel2.ColumnModel2.UnitOfMeasure.Header %>"
                                                            Width="50" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="<%$ Resources: GridPanel2.ColumnModel2.TotalQty.Header %>"
                                                            Width="50" Align="Right">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CreatedDate" DataIndex="CreatedDate" Header="<%$ Resources: GridPanel2.ColumnModel2.CreatedDate.Header %>"
                                                            Width="80">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Ymd')" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="AdjustQty" DataIndex="AdjustQty" Header="<%$ Resources: GridPanel2.ColumnModel2.AdjustQty.Header %>"
                                                            Width="50" Align="Right">
                                                            <Editor>
                                                                <ext:NumberField ID="txtAdjustQty" runat="server" AllowBlank="false" AllowDecimals="true"
                                                                    DecimalPrecision="4" DataIndex="AdjustQty" SelectOnFocus="true" AllowNegative="false">
                                                                </ext:NumberField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="QRCodeEdit" DataIndex="QRCodeEdit" Header="二维码" Width="50"
                                                            Align="Right">
                                                            <Editor>
                                                                <ext:TextField ID="txtQrCode" runat="server" AllowBlank="false"
                                                                    DataIndex="QRCodeEdit" SelectOnFocus="true">
                                                                </ext:TextField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="50" Header="<%$ Resources: GridPanel2.ColumnModel2.CommandColumn.Header %>"
                                                            Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources: GridPanel2.ColumnModel2.CommandColumn.GridCommand.ToolTip-Text %>" />
                                                                <%--  <ext:GridCommand Icon="NoteEdit" CommandName="Edit" ToolTip-Text="Edit" />--%>
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
                                                        DisplayInfo="true" />
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
                                                            #{txtCFNEdit}.setValue(this.getSelectionModel().getSelected().data.CFN);
                                                            #{txtQrCode}.setValue(this.getSelectionModel().getSelected().data.QRCodeEdit);
                                                            #{hiddenLotNumber}.setValue(this.getSelectionModel().getSelected().data.LotNumber);
                                                            #{hiddenQrCode}.setValue(this.getSelectionModel().getSelected().data.QRCode);
                                                          
                                                             
                                        " />
                                                    <AfterEdit Handler="Coolite.AjaxMethods.SaveItem(#{txtAdjustQty}.getValue(),#{hiddenQrCode}.getValue(),#{txtQrCode}.getValue(),#{hiddenLotNumber}.getValue(),{success:function(){#{hiddenIsEditting}.setValue('');},failure: function(err) {Ext.Msg.alert(MsgList.Error, err);}});" />
                                                </Listeners>
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                                <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources: TabLog.Title %>" AutoScroll="true">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout3" runat="server">
                                            <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore"
                                                StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" AutoExpandColumn="OperNote"
                                                Header="false">
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
                                                        DisplayInfo="true" />
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
                    Icon="Cancel" Visible="false">
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
        <uc2:InventoryAdjustDialog ID="InventoryAdjustDialog1" runat="server" />
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
