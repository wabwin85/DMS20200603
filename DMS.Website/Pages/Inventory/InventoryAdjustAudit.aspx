<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InventoryAdjustAudit.aspx.cs"
    Inherits="DMS.Website.Pages.Inventory.InventoryAdjustAudit" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/InventoryAdjustDialog.ascx" TagName="InventoryAdjustDialog"
    TagPrefix="uc2" %>
<%@ Register Src="../../Controls/InventoryAdjustEditor.ascx" TagName="InventoryAdjustEditor"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script language="javascript">       
        var MsgList = {
			Error:"<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>"
        }

        var CheckAddItemsParam = function() {
            //此函数用来控制“添加产品”按钮的状态

            if (Ext.getCmp('cbProductLineWin').getValue() == '' || Ext.getCmp('cbAdjustTypeWin').getValue() == '') {
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
            if (currenStatus == 'new') {
                Coolite.AjaxMethods.DeleteDraft(
                {
                    success: function() {
                        Ext.getCmp('hiddenIsModified').setValue('');
                        Ext.getCmp('GridPanel1').store.reload();
                        Ext.getCmp('DetailWindow').hide();
                    },
                    failure: function(err) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', err);
                    }
                }
                );
                return false;
            }
            if (currenStatus == 'newchanged') {
                //第一次新增的窗口
                Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title1").ToString()%>',
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
                Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.oldchanged.Confirm.Title1").ToString()%>',
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

            if (hiddenProductLineId.getValue() != cbProductLineWin.getValue()) {
                if (hiddenProductLineId.getValue() == '') {
                    hiddenProductLineId.setValue(cbProductLineWin.getValue());
                    grid.store.reload();
                    CheckAddItemsParam();
                    ClearItems();
                    SetMod(true);
                } else {
                Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("ChangeProductLine.confirm.Body").ToString()%>',
                        function(e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.OnProductLineChange(
                                    {
                                        success: function() {
                                            hiddenProductLineId.setValue(cbProductLineWin.getValue());
                                            grid.store.reload();
                                            CheckAddItemsParam();
                                            ClearItems();
                                            SetMod(true);
                                        },
                                        failure: function(err) {
                                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', err);
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


//        var ChangeAdjustType = function() {
//            var hiddenAdjustTypeId = Ext.getCmp('hiddenAdjustTypeId');
//            var cbAdjustTypeWin = Ext.getCmp('cbAdjustTypeWin');
//            var grid = Ext.getCmp('GridPanel2');
//            var hiddenIsModified = Ext.getCmp('hiddenIsModified');

//            if (hiddenAdjustTypeId.getValue() != cbAdjustTypeWin.getValue()) {
//                if (hiddenAdjustTypeId.getValue() == '') {
//                    hiddenAdjustTypeId.setValue(cbAdjustTypeWin.getValue());
//                    grid.store.reload();
//                    CheckAddItemsParam();
//                    ClearItems();
//                    SetMod(true);
//                } else {
//                Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("ChangeAdjustType.confirm.Body").ToString()%>',
//                        function(e) {
//                            if (e == 'yes') {
//                                Coolite.AjaxMethods.OnAdjustTypeChange(
//                                    {
//                                        success: function() {
//                                            hiddenAdjustTypeId.setValue(cbAdjustTypeWin.getValue());
//                                            grid.store.reload();
//                                            CheckAddItemsParam();
//                                            ClearItems();
//                                            SetMod(true);
//                                        },
//                                        failure: function(err) {
//                                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', err);
//                                        }
//                                    }
//                                );
//                            }
//                            else {
//                                cbAdjustTypeWin.setValue(hiddenAdjustTypeId.getValue());
//                            }
//                        }
//                    );
//                }
//            }

//        }

        var CheckSubmit = function() {
            //var cbDealerWin = Ext.getCmp('cbDealerWin');
            var cbProductLineWin = Ext.getCmp('cbProductLineWin');
            var txtAdjustReasonWin = Ext.getCmp('txtAdjustReasonWin');
            var grid = Ext.getCmp('GridPanel2');
            if (cbProductLineWin.getValue() != '' && txtAdjustReasonWin.getValue() != '' && grid.store.getCount() > 0) {
                Coolite.AjaxMethods.DoSubmit({
                    success: function() {
                        Ext.getCmp('hiddenIsModified').setValue('');
                        Ext.getCmp('GridPanel1').store.reload();
                        Ext.getCmp('DetailWindow').hide();
                    },
                    failure: function(err) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', err);
                    }
                });
            } else {
            Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckSubmit.alert.Title.Body").ToString()%>');
            }
        }

        var CheckReject = function() {

            if (Ext.getCmp('txtAduitNoteWin').getValue().length > 2000) {
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.new.Alert.Body").ToString()%>');
            }
            else {
                Coolite.AjaxMethods.DoReject({
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

        var CheckApproval = function() {

            if (Ext.getCmp('txtAduitNoteWin').getValue().length > 2000) {
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.new.Alert.Body").ToString()%>');
            }
            else {
                Coolite.AjaxMethods.DoApprove({
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
    <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
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
                </Fields>
            </ext:JsonReader>
        </Reader>
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
                                                    <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources: Panel1.Panel3.cbProductLine.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                        DisplayField="AttributeName" FieldLabel="<%$ Resources: Panel1.Panel3.cbProductLine.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.Panel3.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtStartDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.Panel3.txtStartDate.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtAdjustNumber" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.Panel3.txtAdjustNumber.FieldLabel %>" />
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
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: Panel1.Panel4.cbDealer.EmptyText %>"
                                                        Width="220" Editable="true" TypeAhead="false" Mode="Local" StoreID="DealerStore"
                                                        ValueField="Id" DisplayField="ChineseShortName" FieldLabel="<%$ Resources: Panel1.Panel4.cbDealer.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.Panel4.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                            <BeforeQuery Fn="SelectValue" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.Panel4.txtStartDate.FieldLabel %>" />
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
                                                        StoreID="AdjustTypeStore" ValueField="Key" DisplayField="Value" EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbReturnType.EmptyText %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout4.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbAdjustStatus" runat="server" EmptyText="<%$ Resources: Panel1.Panel5.cbAdjustStatus.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="AdjustStatusStore" ValueField="Key"
                                                        DisplayField="Value" FieldLabel="<%$ Resources: Panel1.Panel5.cbAdjustStatus.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.Panel5.FieldTrigger.Qtip %>" />
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
                         <ext:Button ID="btnImport" Text="审批结果导入" runat="server"
                                Icon="PageExcel" IDMode="Legacy">
                                <Listeners>
                                    <%--<Click Handler="window.parent.loadExample('/Pages/Inventory/InventoryAdjustAuditImport.aspx','subMenu301','审批结果批量上传');" />--%>
                                    <Click Handler="top.createTab({id: 'subMenu301',title: '审批结果批量上传',url: 'Pages/Inventory/InventoryAdjustAuditImport.aspx'});" />
                                </Listeners>
                            </ext:Button>
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
                                    <Click Before="#{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowDetails"
                                        Failure="Ext.MessageBox.alert('Load failed', 'Error during ajax event!');" Success="#{cbDealerWin}.clearValue();#{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.clearValue();ClearItems();#{GridPanel2}.clear();#{hiddenIsModified}.setValue('new');">
                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                        <ExtraParams>
                                            <ext:Parameter Name="AdjustId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                            </ext:Parameter>
                                        </ExtraParams>
                                    </Click>
                                </AjaxEvents>
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
                                    StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" AutoExpandColumn="Remark">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="DealerId" DataIndex="DealerId" Header="<%$ Resources: GridPanel1.ColumnModel1.DealerId.Header %>"
                                                Width="180">
                                                <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseShortName'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="AdjustNumber" DataIndex="AdjustNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.AdjustNumber.Header %>"
                                                Width="160">
                                            </ext:Column>
                                            <ext:Column ColumnID="Type" DataIndex="Type" Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.Type.Header %>">
                                                <Renderer Handler="return getNameFromStoreById(AdjustTypeStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="TotalQyt" Width="60" Align="Right"  DataIndex="TotalQyt" Header="<%$ Resources: GridPanel1.ColumnModel1.TotalQyt.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="<%$ Resources: GridPanel1.ColumnModel1.CreateDate.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="CreateUserName" DataIndex="CreateUserName" Header="<%$ Resources: GridPanel1.ColumnModel1.CreateUserName.Header %>"
                                                Align="Right">
                                            </ext:Column>
                                            <ext:Column ColumnID="Status" DataIndex="Status"  Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.Status.Header %>">
                                                <Renderer Handler="return getNameFromStoreById(AdjustStatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="IsConsignment" DataIndex="IsConsignment" Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.IsConsignment.Header %>"
                                                Align="Center">
                                            </ext:Column>
                                            <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Width="150" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductLineName.Header %>"
                                                Align="Center">
                                            </ext:Column>
                                            <ext:Column ColumnID="Remark" DataIndex="Remark" Header="<%$ Resources: GridPanel1.ColumnModel1.Remark.Header %>"
                                                Align="Center">
                                            </ext:Column>
                                            <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>">
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
                                        <Command OnEvent="ShowDetails" Failure="Ext.MessageBox.alert('Load failed', 'Error during ajax event!');"
                                            Success="#{cbDealerWin}.clearValue(); #{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.clearValue(); #{cbProductLineWin}.setValue(#{hiddenProductLineId}.getValue());ClearItems();#{GridPanel2}.reload();#{hiddenIsModified}.setValue('old');#{gpLog}.store.reload();">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
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
                                    <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
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
                    <ext:RecordField Name="CreatedDate" />
                    <ext:RecordField Name="PurchaseOrderNbr" />
                    <ext:RecordField Name="QRCode" />
                    <ext:RecordField Name="QRCodeEdit" />
                    
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
        </Listeners>
        <SortInfo Field="CFN" Direction="ASC" />
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
    <ext:Hidden ID="hiddenReturnType" runat="server" />
    <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
        Width="900" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false">
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
                                                                StoreID="DealerStore" ValueField="Id" Mode="Local" DisplayField="ChineseShortName"
                                                                FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.FieldLabel %>"
                                                                AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.BlankText %>"
                                                                EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.EmptyText %>"
                                                                ListWidth="300" Resizable="true">
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbProductLineWin" runat="server" Width="150" Editable="false" TypeAhead="true"
                                                                StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.FieldLabel %>"
                                                                AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.BlankText %>"
                                                                EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.EmptyText %>"
                                                                ListWidth="300" Resizable="true">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout4.FieldTrigger.Qtip %>"
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
                                                            <ext:TextField ID="txtAdjustNumberWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout5.txtAdjustNumberWin.FieldLabel %>"
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
                                                            <ext:ComboBox ID="cbReturnTypeWin" runat="server" Width="125px" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbReturnType.FieldLabel %>"
                                                                AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbReturnType.BlankText %>"
                                                                EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbReturnType.EmptyText %>">
                                                                <Items>
                                                                    <ext:ListItem Text="退货" Value="Return" />
                                                                    <ext:ListItem Text="换货" Value="Exchange" />
                                                                </Items>
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout4.FieldTrigger.Qtip %>" />
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
                            <ext:Panel ID="Panel13" runat="server">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".5">
                                            <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextArea ID="txtAdjustReasonWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout8.txtAdjustReasonWin.FieldLabel %>"
                                                                Width="300" Height="30" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".5">
                                            <ext:Panel ID="Panel15" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextArea ID="txtAduitNoteWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout9.txtAduitNoteWin.FieldLabel %>"
                                                                Width="300" Height="30" />
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
                                            StoreID="DetailStore" Border="false" Icon="Lorry" AutoWidth="true" ClicksToEdit="1"
                                            Header="false" StripeRows="true">
                                            <TopBar>
                                                <ext:Toolbar ID="Toolbar1" runat="server" Visible="false">
                                                    <Items>
                                                        <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                        <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources: GridPanel2.AddItemsButton.Text %>"
                                                            Icon="Add">
                                                            <AjaxEvents>
                                                                <Click OnEvent="ShowDialog" Failure="Ext.MessageBox.alert('Load failed', 'Error during ajax event!');">
                                                                    <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{DetailWindow}.body}" />
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
                                                    <ext:Column ColumnID="CFN" DataIndex="CFN" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UPN" DataIndex="UPN" Header="<%$ Resources: GridPanel2.ColumnModel2.UPN.Header %>"
                                                        Width="100" Hidden="<%$ AppSettings: HiddenUPN  %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel2.ColumnModel2.LotNumber.Header %>"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources: GridPanel2.ColumnModel2.ExpiredDate.Header %>"
                                                        Width="80">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources: GridPanel2.ColumnModel2.UnitOfMeasure.Header %>"
                                                        Width="50" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="<%$ Resources: GridPanel2.ColumnModel2.TotalQty.Header %>"
                                                        Width="50">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CreatedDate" DataIndex="CreatedDate" Header="<%$ Resources: GridPanel2.ColumnModel2.CreatedDate.Header %>"
                                                        Width="80">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="AdjustQty" DataIndex="AdjustQty" Header="<%$ Resources: GridPanel2.ColumnModel2.AdjustQty.Header %>"
                                                        Width="80">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="QRCodeEdit" DataIndex="QRCodeEdit" Header="二维码"
                                                        Width="80">
                                                    </ext:Column>
                                                    
                                                    <ext:Column ColumnID="PurchaseOrderNbr" DataIndex="PurchaseOrderNbr" Header="<%$ Resources: GridPanel2.ColumnModel2.PurchaseOrderNbr.Header %>"
                                                        Width="100" Align="Right" Hidden="true">
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="50">
                                                        <Commands>
                                                            <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources: GridPanel2.ColumnModel2.CommandColumn.ToolTip-Text %>" />
                                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit" ToolTip-Text="<%$ Resources: GridPanel2.ColumnModel2.CommandColumn.ToolTip-Text1 %>" />
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="DetailStore"
                                                    DisplayInfo="false" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                                            <Listeners>
                                                <Command Handler="if (command == 'Delete'){Coolite.AjaxMethods.DeleteItem(this.getSelectionModel().getSelected().id,{failure: function(err) {Ext.Msg.alert(MsgList.Error, err);}});}else{Coolite.AjaxMethods.EditItem(this.getSelectionModel().getSelected().id,#{hiddenAdjustTypeId}.getValue());}" />
                                            </Listeners>
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources: TabLog.Title %>" AutoScroll="false">
                                <Body>
                                    <ext:FitLayout ID="FitLayout3" runat="server">
                                        <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore"
                                            StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" Header="false">
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
                                                    <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources: gpLog.OperNote %>"
                                                        Width="250">
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                    MoveEditorOnEnter="true">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="10" StoreID="OrderLogStore"
                                                    DisplayInfo="false" />
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
            <ext:Button ID="RejectButton" runat="server" Text="<%$ Resources: DetailWindow.RejectButton.Text %>">
                <Listeners>
                    <Click Handler="CheckReject();" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="ApprovalButton" runat="server" Text="<%$ Resources: DetailWindow.ApprovalButton.Text %>">
                <Listeners>
                    <Click Handler="CheckApproval();" />
                </Listeners>
            </ext:Button>
        </Buttons>
        <Listeners>
            <BeforeHide Fn="CheckMod" />
        </Listeners>
    </ext:Window>
    <uc2:InventoryAdjustDialog ID="InventoryAdjustDialog1" runat="server" />
    <%--    <uc1:InventoryAdjustEditor ID="InventoryAdjustEditor1" runat="server" />--%>
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
