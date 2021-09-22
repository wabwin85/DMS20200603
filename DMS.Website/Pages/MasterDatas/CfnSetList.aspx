<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CfnSetList.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.CfnSetList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/CFNSearchDialog.ascx" TagName="CFNSearchDialog"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/T.R/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CfnSetList</title>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>

        <script language="javascript">
        var CheckAddItemsParam = function() {
            //此函数用来控制“添加产品”按钮的状态
            if (Ext.getCmp('cbProductLineWin').getValue() == '' ) {
                Ext.getCmp('AddItemsButton').disable();
            } else {
                Ext.getCmp('AddItemsButton').enable();
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
                } else {
                    Ext.Msg.confirm('<%=GetLocalResourceObject("ChangeProductLine.confirm.title").ToString()%>', '<%=GetLocalResourceObject("ChangeProductLine.confirm.body").ToString()%>',
                        function(e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.OnProductLineChange(
                                    {
                                        success: function() {
                                            hiddenProductLineId.setValue(cbProductLineWin.getValue());
                                            grid.store.reload();
                                            CheckAddItemsParam();                                            
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
        
        
        var showCfnSearchDlg = function() {
            if (Ext.getCmp('cbProductLineWin').getValue() == null) {
                Ext.Msg.alert('<%=GetLocalResourceObject("showCfnSearchDlg.alert.Title").ToString()%>', '<%=GetLocalResourceObject("showCfnSearchDlg.alert.Body").ToString()%>');
                return;
            }
            openCfnSearchDlg(<%=cbProductLineWin.ClientID %>.getValue(),null);           

        }
        
        var SaveGridPanel2Data=function() {
            if (Ext.getCmp('cbProductLineWin').getValue() == null) {                
                Ext.Msg.alert('<%=GetLocalResourceObject("SaveGridPanel2Data.Msg.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("SaveGridPanel2Data.Msg.Alert.Body").ToString()%>');
                return;
            } else {
                if (Ext.getCmp('txtChineseNameWin').getValue() == '' || Ext.getCmp('txtEnglishNameWin').getValue() == '') {                    
                    Ext.Msg.alert('<%=GetLocalResourceObject("SaveGridPanel2Data.Msg.Alert.Title1").ToString()%>', '<%=GetLocalResourceObject("SaveGridPanel2Data.Msg.Alert.Body1").ToString()%>');
                    return;
                } else {                    
                    if (IsStoreDirty(GridPanel2.store)||Ext.getCmp('hiddenIsStoreRemove').Text=='true'){
                        Ext.getCmp('hiddenIsStoreRemove').Text='false'                                  
                        GridPanel2.save();    
                    }else{                        
                        Coolite.AjaxMethods.SaveMainData();
                    }            
                }
            }          
            
       }
       
       var CFNSetListMsg = {
            LoadException:"<%=GetLocalResourceObject("CFNSetStore.LoadException.Msg.Alert").ToString()%>",
            CommitFailed:"<%=GetLocalResourceObject("CFNSetStore.CommitFailed.Msg.Alert").ToString()%>",
            CommitFailedReason:"<%=GetLocalResourceObject("CFNSetStore.CommitFailedReason.Msg.Alert").ToString()%>",
            SaveException:"<%=GetLocalResourceObject("CFNSetStore.CommitFailed.Msg.Alert").ToString()%>",
            CommitDone:"<%=GetLocalResourceObject("CFNSetStore.CommitDone.Msg.Alert").ToString()%>",
            CommitDoneMsg:"<%=GetLocalResourceObject("CFNSetStore.CommitDone.Msg.Alert1").ToString()%>",
            InsertFailureTitle:"<%=GetLocalResourceObject("plSearch.btnInsert.Alert.Title").ToString()%>",
            InsertFailureMsg:"<%=GetLocalResourceObject("plSearch.btnInsert.Alert.Body").ToString()%>",
            DeleteConfirm:"<%=GetLocalResourceObject("plSearch.btnDelete.Listeners.confirm").ToString()%>",
            ShowDetailsTitle:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.alert.Title").ToString()%>",
            ShowDetailsMsg:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.alert.Body").ToString()%>",
            DetailWindowDeleteTitle:"<%=GetLocalResourceObject("DetailWindow.GridPanel2.Listeners.Alert").ToString()%>",
            DetailWindowRevokeTitle:"<%=GetLocalResourceObject("DetailWindow.RevokeButton.Alert").ToString()%>"
       }
        </script>

        <ext:Store ID="CFNSetStore" runat="server" OnRefreshData="CFNSet_RefershData" OnBeforeStoreChanged="CFNSet_BeforeStoreChanged"
            AutoLoad="false">
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={15}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="EnglishName" />
                        <ext:RecordField Name="ProductLineBumId" />
                        <ext:RecordField Name="CreateUser" />
                        <ext:RecordField Name="CreateDate" />
                        <ext:RecordField Name="UpdateUser" />
                        <ext:RecordField Name="UpdateDate" />
                        <ext:RecordField Name="DeleteFlag" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert(CFNSetListMsg.LoadException, e.message || e )" />
                <CommitFailed Handler="Ext.Msg.alert(CFNSetListMsg.CommitFailed, CFNSetListMsg.CommitFailedReason + msg)" />
                <SaveException Handler="Ext.Msg.alert(CFNSetListMsg.SaveException, e.message || e)" />
                <CommitDone Handler="Ext.Msg.alert(CFNSetListMsg.CommitDone, CFNSetListMsg.CommitDoneMsg);" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine">
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
            <SortInfo Field="Id" Direction="ASC" />
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources: plSearch.FormLayout1.cbProductLine.EmptyText%>" Width="150"
                                                            Editable="true" AllowBlank="false" TypeAhead="true" StoreID="ProductLineStore"
                                                            ValueField="Id" DisplayField="AttributeName" ListWidth="300" Resizable="true"
                                                            FieldLabel="<%$ Resources: plSearch.FormLayout1.cbProductLine.FieldLabel %>">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.FormLayout1.cbProductLine.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtCFNSCName" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout1.txtCFNSCName.FieldLabel %>" Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtCustomerFaceNbr" runat="server" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="<%$ Resources: plSearch.btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.SearchData();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: plSearch.btnInsert.Text %>" Icon="Add" IDMode="Legacy">
                                    <AjaxEvents>
                                        <Click Before="#{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowDetails"
                                            Failure="Ext.MessageBox.alert(CFNSetListMsg.InsertFailureTitle, CFNSetListMsg.InsertFailureMsg);" Success="">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}"
                                                Msg="<%$ Resources:plSearch.btnInsert.EventMask.Msg %>" />
                                            <ExtraParams>
                                                <ext:Parameter Name="CFNSID" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources:plSearch.btnDelete.Text %>" Icon="Delete" CommandArgument=""
                                    CommandName="" IDMode="Legacy" OnClientClick="">
                                    <Listeners>
                                        <Click Handler="var result = confirm(CFNSetListMsg.DeleteConfirm); if ( (result) && #{GridPanel1}.hasSelection()) {#{GridPanel1}.deleteSelected();#{GridPanel1}.save();}" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources:GridPanel1.title %>" StoreID="CFNSetStore"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources:GridPanel1.ColumnModel1.ChineseName.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtChineseName" runat="server" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="<%$ Resources:GridPanel1.ColumnModel1.EnglishName.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtEnglishName" runat="server" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="<%$ Resources:GridPanel1.ColumnModel1.CommandColumn.Header %>" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="<%$ Resources:GridPanel1.ColumnModel1.ToolTip.Text %>" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <AjaxEvents>
                                            <Command OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(CFNSetListMsg.ShowDetailsTitle, CFNSetListMsg.ShowDetailsMsg);"
                                                Success="">
                                                <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}"
                                                    Msg="<%$ Resources:GridPanel1.AjaxEvents.EventMask.Msg %>" />
                                                <ExtraParams>
                                                    <ext:Parameter Name="CFNSID" Value="#{GridPanel1}.getSelectionModel().getSelected().id"
                                                        Mode="Raw">
                                                    </ext:Parameter>
                                                </ExtraParams>
                                            </Command>
                                        </AjaxEvents>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="CFNSetStore"
                                                DisplayInfo="true" EmptyMsg="No data to display" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel1.LoadMask.Msg %>" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
            OnBeforeStoreChanged="DetailStore_BeforeStoreChanged" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="CFNSID" />
                        <ext:RecordField Name="DefaultQuantity" />
                        <ext:RecordField Name="CFNID" />
                        <ext:RecordField Name="EnglishName" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="CustomerFaceNbr" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
                <Remove Handler="Ext.getCmp('hiddenIsStoreRemove').Text = 'true';" />
            </Listeners>
            <SortInfo Field="CustomerFaceNbr" Direction="ASC" />
        </ext:Store>
        <ext:Hidden ID="hiddenCFNSID" runat="server" />
        <ext:Hidden ID="hiddenCurrentEdit" runat="server" />
        <ext:Hidden ID="hiddenProductLineId" runat="server" />
        <ext:Hidden ID="hiddenIsModified" runat="server" />
        <ext:Hidden ID="hiddenIsStoreRemove" runat="server" Text="false"/>
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources:DetailWindow.Title %>" Width="900"
            Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
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
                                                                <ext:ComboBox ID="cbProductLineWin" runat="server" Width="150" Editable="false" TypeAhead="true"
                                                                    StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName" FieldLabel="<%$ Resources:DetailWindow.FormLayout4.cbProductLineWin.FieldLabel %>"
                                                                    AllowBlank="false" BlankText="<%$ Resources:DetailWindow.FormLayout4.cbProductLineWin.BlankText %>" EmptyText="<%$ Resources:DetailWindow.FormLayout4.cbProductLineWin.EmptyText%>" ListWidth="300" Resizable="true">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:DetailWindow.FormLayout4.cbProductLineWin.FieldTrigger.Qtip %>" HideTrigger="true" />
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
                                            <ext:LayoutColumn ColumnWidth=".6">
                                                <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="120">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtChineseNameWin" runat="server" FieldLabel="<%$ Resources:DetailWindow.FormLayout6.txtChineseNameWin.FieldLabel %>" ReadOnly="false" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtEnglishNameWin" runat="server" FieldLabel="<%$ Resources:DetailWindow.FormLayout6.txtEnglishNameWin.FieldLabel %>" ReadOnly="false" />
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
                        <ext:Panel ID="Panel10" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout2" runat="server">
                                    <ext:GridPanel ID="GridPanel2" runat="server" Title="<%$ Resources:DetailWindow.GridPanel2.Title %>" StoreID="DetailStore"
                                        StripeRows="true" Collapsible="true" Border="false" Icon="Lorry" AutoWidth="true"
                                        ClicksToEdit="1">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                    <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources:DetailWindow.GridPanel2.AddItemsButton.Text%>" Icon="Add">
                                                        <Listeners>
                                                            <Click Fn="showCfnSearchDlg" />
                                                        </Listeners>
                                                        <%-- <AjaxEvents>
                                                            <Click OnEvent="ShowDialog" Failure="Ext.MessageBox.alert('数据处理过程', 'ajax事件过程有问题!');">
                                                                <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{DetailWindow}.body}"
                                                                    Msg="处理中..." />
                                                                <ExtraParams>
                                                                    <ext:Parameter Name="CFNSID" Value="#{hiddenCFNSID}.getValue()" Mode="Raw">
                                                                    </ext:Parameter>
                                                                </ExtraParams>
                                                            </Click>
                                                        </AjaxEvents>--%>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources:DetailWindow.GridPanel2.ColumnModel2.ChineseName.Header %>" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="<%$ Resources:DetailWindow.GridPanel2.ColumnModel2.EnglishName.Header %>" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="DefaultQuantity" DataIndex="DefaultQuantity" Header="<%$ Resources:DetailWindow.GridPanel2.ColumnModel2.DefaultQuantity.Header %>"
                                                    Width="80" Align="Right">
                                                    <Editor>
                                                        <ext:NumberField ID="txtDefaultQuantity" runat="server" AllowBlank="false" AllowDecimals="false"
                                                            DataIndex="DefaultQuantity" SelectOnFocus="true" AllowNegative="false">
                                                        </ext:NumberField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="<%$ Resources:DetailWindow.GridPanel2.ColumnModel2.CommandColumn.Header %>" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources:DetailWindow.GridPanel2.ColumnModel2.GridCommand.ToolTip-Text %>" />
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
                                                DisplayInfo="false" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources:DetailWindow.GridPanel2.LoadMask.Msg %>" />
                                        <%--                                    <AjaxEvents>
                                        <AfterEdit OnEvent="SaveInvAdjDetailLine">
                                            <ExtraParams >
                                                <ext:Parameter Name="Values" Value="Ext.encode(#{GridPanel2}.getRowsValues())" Mode="Raw" />
                                            </ExtraParams>
                                        </AfterEdit>
                                    </AjaxEvents>
--%>
                                        <Listeners>
                                            <Command Handler="if (command == 'Delete'){
                                                Coolite.AjaxMethods.DeleteItem(this.getSelectionModel().getSelected().data.CFNID,{failure: function(err) {Ext.Msg.alert(CFNSetListMsg.DetailWindowDeleteTitle, err);}});
                                            }" />
                                            <BeforeEdit Handler="" />
                                            <AfterEdit Handler="" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="DraftButton" runat="server" Text="<%$ Resources:DetailWindow.DraftButton.Text%>" Icon="Add">
                    <Listeners>
                        <Click Handler="SaveGridPanel2Data();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="RevokeButton" runat="server" Text="<%$ Resources:DetailWindow.RevokeButton.Text%>" Icon="Cancel">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.Cancel({
                            success: function() {
                                Ext.getCmp('DetailWindow').hide();
                            },
                            failure: function(err) {
                                Ext.Msg.alert(CFNSetListMsg.DetailWindowRevokeTitle, err);
                            }
                        });" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <Hide Handler="#{GridPanel2}.clear();" />
            </Listeners>
        </ext:Window>
        <uc2:CFNSearchDialog ID="CFNSearchDialog1" runat="server" />
    </div>
    </form>
</body>
</html>
