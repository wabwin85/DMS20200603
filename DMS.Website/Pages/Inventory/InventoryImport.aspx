<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InventoryImport.aspx.cs"
    Inherits="DMS.Website.Pages.Inventory.InventoryImport" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/T.R/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>InventoryImport</title>

    <script src="../../resources/cooliteHelper.js" type="text/javascript">

    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>

        <script type="text/javascript">
       

            var InvQtySearch = function(pagingtoolbar) {
                if (Ext.getCmp('cbDealer').getValue() == '') {
                    Ext.Msg.alert('<%=GetLocalResourceObject("InvQtySearch.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("InvQtySearch.Alert.Body").ToString()%>');
                } 
                else if (Ext.getCmp('txtImportDate').getValue() == '') {
                   Ext.Msg.alert('<%=GetLocalResourceObject("InvQtySearch.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("InvQtySearch.Alert.Date.Body").ToString()%>');
                }
                else {
                    pagingtoolbar.changePage(1);
                }
            }
           
            var OrderApplyMsgList = {
                    msg1:"<%=GetLocalResourceObject("loadExample.subMenu279").ToString()%>"
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
                        <ext:RecordField Name="DealerSapCode" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="Warehouse" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="WarehouseType" />
                        <ext:RecordField Name="ArticleNumber" />
                        <ext:RecordField Name="UploadDate" />
                        <ext:RecordField Name="Qty" />
                        <ext:RecordField Name="Period" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--<SortInfo Field="ArticleNumber" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="Store1" runat="server" UseIdConfirmation="true">
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
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="170">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtImportDate" runat="server" Width="80" FieldLabel="<%$ Resources: plSearch.ImportDate %> "
                                                            AllowBlank="false" LabelCls="xx" />
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
                                <ext:Button ID="btnImport" runat="server" Text="<%$ Resources: btnImport.Text %>"
                                    Icon="Disk" IDMode="Legacy">
                                    <Listeners>
                                        <%--<Click Handler="window.parent.loadExample('/Pages/Inventory/InventoryInit.aspx','subMenu279',OrderApplyMsgList.msg1);" />--%>
                                        <Click Handler="top.createTab({id: 'subMenu279',title: '导入',url: 'Pages/Inventory/InventoryInit.aspx'});" />

                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="Panel3" Border="false" Frame="true" AutoScroll="true" >
                            <Body>
                                <ext:Panel runat="server" ID="Panel8" Border="false" Frame="false" Height="365px">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout1" runat="server">
                                            <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                                StoreID="ResultStore" Border="false" Icon="Lorry" EnableHdMenu="false" StripeRows="true">
                                                <ColumnModel ID="ColumnModel1" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="DealerSapCode" DataIndex="DealerSapCode" Header="<%$ Resources: GridPanel1.DealerSapCode %>"
                                                            Width="100" />
                                                        <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="<%$ Resources: GridPanel1.ColumnModel1.DMAChineseName.Header %>"
                                                            Width="180" />
                                                        <ext:Column ColumnID="Warehouse" DataIndex="Warehouse" Header="<%$ Resources: GridPanel1.ColumnModel1.WarehouseName.Header %>"
                                                            Width="200" />
                                                        <ext:Column ColumnID="WarehouseType" DataIndex="WarehouseType" Header="<%$ Resources: GridPanel1.WarehouseType %>"
                                                            Width="100" />
                                                        <ext:Column ColumnID="ArticleNumber" DataIndex="ArticleNumber" Header="<%$ Resources: GridPanel1.ArticleNumber %>"
                                                            Width="120" />
                                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel1.LotNumber %>"
                                                            Width="120" />
                                                        <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources: GridPanel1.ExpiredDate %>"
                                                            Width="100" />
                                                        <ext:Column ColumnID="Qty" DataIndex="Qty" Header="<%$ Resources: GridPanel1.Qty %>"
                                                            Align="Right">
                                                        </ext:Column>
                                                        <%-- <ext:Column ColumnID="Period" DataIndex="Period" Header="库存期间" Width="130" />--%>
                                                        <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="<%$ Resources: GridPanel1.UploadDate %>"
                                                            Width="130" />
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
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
                                <ext:Panel runat="server" ID="Panel4" Border="false" Frame="false" >
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".10">
                                                <ext:Panel ID="Panel5" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="50">
                                                            <ext:Anchor>
                                                                <ext:Label ID="txtTotalCount" runat="server" FieldLabel="<%$ Resources: Panel.txtTotalCount %>" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel6" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="50">
                                                            <ext:Anchor>
                                                                <ext:Label ID="txtTotalQty" runat="server" FieldLabel="<%$ Resources: Panel.txtTotalQty %>">
                                                                </ext:Label>
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
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </div>
    </form>
</body>
</html>
