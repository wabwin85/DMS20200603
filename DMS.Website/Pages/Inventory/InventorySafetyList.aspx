<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InventorySafetyList.aspx.cs"
    Inherits="DMS.Website.Pages.Inventory.InventorySafetyList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/CFNSearchDialog.ascx" TagName="CFNSearchDialog"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/T.R/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>InventorySafetyList</title>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>

        <script language="javascript">
        var MsgList = {
			AfterEdit:{
				FailureTitle:"<%=GetLocalResourceObject("GridPanel1.Listeners.Alert.Title").ToString()%>"
			},
			RevokeButton:{
				FailureTitle:"<%=GetLocalResourceObject("DetailWindow.RevokeButton.Listeners.Alert.Title").ToString()%>"
			}
        }

            var InvQtySearch = function(pagingtoolbar) {
                if (Ext.getCmp('cbDealer').getValue() == '') {
                    Ext.Msg.alert('<%=GetLocalResourceObject("InvQtySearch.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("InvQtySearch.Alert.Body").ToString()%>');
                } else {
                    pagingtoolbar.changePage(1);
                }
            }
            var SaveGridPanel2DB = function(grid) {
                if (grid.hasSelection()) {
                    var selList = grid.selModel.getSelections();
                    var param = '';
                    for (var i = 0; i < selList.length; i++) {
                        param += selList[i].get('CFN_ID') + ',';
                    }
                    Coolite.AjaxMethods.SaveData(param, {
                        success: function() {
                            Ext.getCmp('txtCfnANWin').setValue('');
                            Ext.getCmp('GridPanel2').clear();
                            Ext.getCmp('chkIsShareCFN').setValue(false);
                            Ext.getCmp('GridPanel1').store.reload();
                            Ext.getCmp('DetailWindow').hide();
                        },
                        failure: function(err) {
                        Ext.Msg.alert('<%=GetLocalResourceObject("SaveGridPanel2DB.failure.Alert.Title").ToString()%>', err);
                        }
                    });

                } else {
                Ext.MessageBox.alert('<%=GetLocalResourceObject("SaveGridPanel2DB.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("SaveGridPanel2DB.Alert.Body").ToString()%>');
                }


            }
            var CopyInventoryToSafety = function(grid) {
            Ext.Msg.confirm('Warning', '<%=GetLocalResourceObject("CopyInventoryToSafety.Confirm.Body").ToString()%>',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.UpdateSafetyQty({
                            success: function() {
                                grid.store.reload();
                            },
                            failure: function(err) {
                            Ext.Msg.alert('<%=GetLocalResourceObject("CopyInventoryToSafety.Alert.Title").ToString()%>', err);
                            }
                        });
                    } else {
                    }
                });
            }
            
            var OrderApplyMsgList = {
            msg1:"<%=GetLocalResourceObject("loadExample.subMenu299").ToString()%>"
        }
        </script>

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
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DMA_ChineseName" />
                        <ext:RecordField Name="ArticleNumber" />
                        <ext:RecordField Name="ProductLineName" />
                        <ext:RecordField Name="CFN_ID" />
                        <ext:RecordField Name="DMA_ID" />
                        <ext:RecordField Name="InvActualQty" />
                        <ext:RecordField Name="InvSaftyQty" />
                        <ext:RecordField Name="WarehouseName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="ArticleNumber" Direction="ASC" />
        </ext:Store>
        <ext:Hidden ID="hiddenCurrentEditID" runat="server" />
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>"
                            Frame="true" AutoHeight="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: plSearch.FormLayout1.cbDealer.EmptyText %>"
                                                            Width="220" Editable="true" TypeAhead="true" StoreID="DealerStore" ValueField="Id"
                                                            DisplayField="ChineseName" Mode="Local" FieldLabel="<%$ Resources: plSearch.FormLayout1.cbDealer.FieldLabel %>"
                                                            ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.FormLayout1.FieldTrigger.Qtip %>" />
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
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtCfnAN" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="<%$ Resources: plSearch.btnSearch.Text %>" runat="server"
                                    Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="InvQtySearch(#{PagingToolBar1});" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnCopy" Text="<%$ Resources: plSearch.btnCopy.Text %>" runat="server"
                                    Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="CopyInventoryToSafety(#{GridPanel1});" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnImport" runat="server" Text="<%$ Resources: btnImport.Text %>" Icon="Disk" IDMode="Legacy">
                                    <Listeners>
                                        <%--<Click Handler="window.parent.loadExample('/Pages/Inventory/InventorySafetyImport.aspx','subMenu299',OrderApplyMsgList.msg1);" />--%>
                                        <Click Handler="top.createTab({id: 'subMenu299',title: '导入',url: 'Pages/Inventory/InventorySafetyImport.aspx'});" />

                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                        StoreID="ResultStore" Border="false" Icon="Lorry" EnableHdMenu="false" StripeRows="true">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                    <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources: GridPanel1.AddItemsButton.Text %>"
                                                        Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="Coolite.AjaxMethods.DetailWindowShow();" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DMAChineseName" DataIndex="DMA_ChineseName" Header="<%$ Resources: GridPanel1.ColumnModel1.DMAChineseName.Header %>"
                                                    Width="180" />
                                                
                                                <ext:Column ColumnID="ArticleNumber" DataIndex="ArticleNumber" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                    Width="180" />
                                                <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductLineName.Header %>"
                                                    Width="180" />
                                                <ext:Column ColumnID="InvActualQty" DataIndex="InvActualQty" Header="<%$ Resources: GridPanel1.ColumnModel1.InvActualQty.Header %>"
                                                    Align="Right" />
                                              <ext:Column ColumnID="InvSaftyQtyQuery" DataIndex="InvSaftyQty" Header="<%$ Resources: GridPanel1.ColumnModel1.InvSaftyQtyQuery.Header %>"
                                                    Align="Right" />
                                                <ext:Column ColumnID="InvSaftyQtyEdit" DataIndex="InvSaftyQty" Header="<%$ Resources: GridPanel1.ColumnModel1.InvSaftyQtyEdit.Header %>"
                                                    Align="Right">
                                                    <Editor>
                                                        <ext:NumberField ID="txtSaftyQty" runat="server" AllowBlank="false" AllowDecimals="false"
                                                            DataIndex="InvSaftyQty" SelectOnFocus="true" AllowNegative="false">
                                                        </ext:NumberField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="<%$ Resources: GridPanel1.ColumnModel1.WarehouseName.Header %>" Width="180" />
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <BeforeEdit Handler="#{hiddenCurrentEditID}.setValue(this.getSelectionModel().getSelected().id); " />
                                            <AfterEdit Handler="
                                                    Coolite.AjaxMethods.SaveItem(#{txtSaftyQty}.getValue(),{failure: function(err) {Ext.Msg.alert(MsgList.AfterEdit.FailureTitle, err);}});" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="false" />
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
        <ext:Store ID="ActualQtyStore" runat="server" OnRefreshData="ActualQtyStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="CFN_ID">
                    <Fields>
                        <ext:RecordField Name="ArticleNumber" />
                        <ext:RecordField Name="CFN_ID" />
                        <ext:RecordField Name="EngName" />
                        <ext:RecordField Name="ChnName" />
                        <ext:RecordField Name="InvActualQty" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="ArticleNumber" Direction="ASC" />
        </ext:Store>
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
            Width="900" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
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
                                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="120">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtCfnANWin" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Checkbox ID="chkIsShareCFN" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.chkIsShareCFN.FieldLabel %>">
                                                                </ext:Checkbox>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                    <Buttons>
                                        <ext:Button ID="btnSearchWin" Text="<%$ Resources: DetailWindow.btnSearchWin.Text %>"
                                            runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                            <Listeners>
                                                <%--<Click Handler="#{GridPanel2}.reload();" />--%>
                                                <Click Handler="#{PagingToolBar2}.changePage(1);" />
                                            </Listeners>
                                        </ext:Button>
                                    </Buttons>
                                </ext:Panel>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel10" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout2" runat="server">
                                    <ext:GridPanel ID="GridPanel2" runat="server" Title="<%$ Resources: GridPanel2.Title %>"
                                        StoreID="ActualQtyStore" StripeRows="true" Collapsible="true" Border="false"
                                        Icon="Lorry" AutoWidth="true" ClicksToEdit="1">
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ArticleNumberWin" DataIndex="ArticleNumber" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="EngName" DataIndex="EngName" Header="<%$ Resources: GridPanel2.ColumnModel2.EngName.Header %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="EngName" DataIndex="EngName" Header="<%$ Resources: GridPanel2.ColumnModel2.EngName.Header1 %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="ActualQuantityWin" DataIndex="InvActualQty" Header="<%$ Resources: GridPanel2.ColumnModel2.ActualQuantityWin.Header %>"
                                                    Width="80" Align="Right">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="ActualQtyStore"
                                                DisplayInfo="false" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="DraftButton" runat="server" Text="<%$ Resources: DetailWindow.DraftButton.Text %>"
                    Icon="Add">
                    <Listeners>
                        <Click Handler="SaveGridPanel2DB(#{GridPanel2});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="RevokeButton" runat="server" Text="<%$ Resources: DetailWindow.RevokeButton.Text %>"
                    Icon="Cancel">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.Cancel({
                            success: function() {
                                #{txtCfnANWin}.setValue('');
                                #{GridPanel2}.clear();
                                #{chkIsShareCFN}.setValue(false);
                                #{DetailWindow}.hide(); 
                            },
                            failure: function(err) {
                                Ext.Msg.alert(MsgList.RevokeButton.FailureTitle, err);
                            }
                        });" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
            </Listeners>
        </ext:Window>
    </div>
    </form>
</body>
</html>
