<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeliveryNoteList.aspx.cs" Inherits="DMS.Website.Pages.POReceipt.DeliveryNoteList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_DealerList" AutoLoad="true">
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
            <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                     <ext:RecordField Name="Id" />
                     <ext:RecordField Name="LineNbrInFile" />
                     <ext:RecordField Name="SapCode" />
                     <ext:RecordField Name="PoNbr" />
                     <ext:RecordField Name="DeliveryNoteNbr" />
                     <ext:RecordField Name="Cfn" />
                     <ext:RecordField Name="Upn" />
                     <ext:RecordField Name="LotNumber" />
                     <ext:RecordField Name="ExpiredDate" />
                     <ext:RecordField Name="ReceiveUnitOfMeasure" />
                     <ext:RecordField Name="ReceiveQty" />
                     <ext:RecordField Name="ShipmentDate" />
                     <ext:RecordField Name="ImportFileName" />
                     <ext:RecordField Name="OrderType" />
                     <ext:RecordField Name="UnitPrice" />
                     <ext:RecordField Name="SubTotal" />
                     <ext:RecordField Name="CreateDate" />
                     <ext:RecordField Name="ProblemDescription" />
                     <ext:RecordField Name="Carrier" />
                     <ext:RecordField Name="TrackingNo" />
                     <ext:RecordField Name="ShipType" />
                     <ext:RecordField Name="Note" />
                     <ext:RecordField Name="DealeridDmaName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server" >
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbDealer" runat="server" 
                                                        EmptyText="<%$ Resources: Panel1.FormLayout1.cbDealer.EmptyText %>" 
                                                        Width="220" 
                                                        Editable="true"
                                                        Mode="Local"
                                                        TypeAhead="true" 
                                                        StoreID="DealerStore" 
                                                        ValueField="Id" 
                                                        DisplayField="ChineseName"
                                                        FieldLabel="<%$ Resources: Panel1.FormLayout1.cbDealer.FieldLabel %>" ListWidth="300" Resizable="true"
                                                    >
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout1.cbDealer.FieldTrigger.Qtip %>" />
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
                                                    <ext:ComboBox ID="cbType" runat="server" 
                                                        EmptyText="<%$ Resources: Panel1.FormLayout1.cbType.EmptyText %>" 
                                                        Width="150" 
                                                        Editable="false"
                                                        TypeAhead="true"
                                                        FieldLabel="<%$ Resources: Panel1.FormLayout1.cbType.FieldLabel %>"
                                                    >
                                                    <Items>
                                                        <ext:ListItem Text="<%$ Resources: Panel1.FormLayout1.cbType.ListItem.Text %>" Value="经销商不存在" />
                                                        <ext:ListItem Text="<%$ Resources: Panel1.FormLayout1.cbType.ListItem.Text1 %>" Value="产品型号不存在" />
                                                        <ext:ListItem Text="<%$ Resources: Panel1.FormLayout1.cbType.ListItem.Text2 %>" Value="产品线未关联" />
                                                        <ext:ListItem Text="<%$ Resources: Panel1.FormLayout1.cbType.ListItem.Text3 %>" Value="未做授权" />
                                                        <ext:ListItem Text="<%$ Resources: Panel1.FormLayout1.cbType.ListItem.Text4 %>" Value="与经销商开帐日不匹配" />
                                                    </Items>
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout1.cbType.FieldTrigger.Qtip %>" />
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
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtSapCode" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtSapCode.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtEndDate.FieldLabel %>" />
                                                </ext:Anchor>                                                
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtDeliveryNoteNbr" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout3.txtDeliveryNoteNbr.FieldLabel %>  " />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtPONbr" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout3.txtPONbr.FieldLabel %>   " />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: Panel1.btnSearch.Text %>" runat="server" Icon="ArrowRefresh">
                                <Listeners>
                                   <%-- <Click Handler="#{GridPanel1}.reload();" />--%>
                                   <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="LineNbrInFile" DataIndex="LineNbrInFile" Header="<%$ Resources: GridPanel1.ColumnModel1.LineNbrInFile.Header %>" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealeridDmaName" DataIndex="DealeridDmaName" Header="<%$ Resources: GridPanel1.ColumnModel1.DealeridDmaName.Header %>">                                                    
                                                </ext:Column>
                                                <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="<%$ Resources: GridPanel1.ColumnModel1.SapCode.Header %>">                                                    
                                                </ext:Column>
                                                <ext:Column ColumnID="PoNbr" DataIndex="PoNbr" Header="<%$ Resources: GridPanel1.ColumnModel1.PoNbr.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="DeliveryNoteNbr" DataIndex="DeliveryNoteNbr" Header="<%$ Resources: GridPanel1.ColumnModel1.DeliveryNoteNbr.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Cfn" DataIndex="Cfn" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Upn" DataIndex="Upn" Header="<%$ Resources: GridPanel1.ColumnModel1.Upn.Header %>" Hidden="<%$ AppSettings: HiddenUPN  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.LotNumber.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources: GridPanel1.ColumnModel1.ExpiredDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ReceiveUnitOfMeasure" DataIndex="ReceiveUnitOfMeasure" Header="<%$ Resources: GridPanel1.ColumnModel1.ReceiveUnitOfMeasure.Header %>" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ReceiveQty" DataIndex="ReceiveQty" Header="<%$ Resources: GridPanel1.ColumnModel1.ReceiveQty.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipmentDate" DataIndex="ShipmentDate" Header="<%$ Resources: GridPanel1.ColumnModel1.ShipmentDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ImportFileName" DataIndex="ImportFileName" Header="<%$ Resources: GridPanel1.ColumnModel1.ImportFileName.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="OrderType" DataIndex="OrderType" Header="<%$ Resources: GridPanel1.ColumnModel1.OrderType.Header %>" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="UnitPrice" DataIndex="UnitPrice" Header="<%$ Resources: GridPanel1.ColumnModel1.UnitPrice.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="SubTotal" DataIndex="SubTotal" Header="<%$ Resources: GridPanel1.ColumnModel1.SubTotal.Header %>" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="<%$ Resources: GridPanel1.ColumnModel1.CreateDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProblemDescription" DataIndex="ProblemDescription" Header="<%$ Resources: GridPanel1.ColumnModel1.ProblemDescription.Header %>">
                                                </ext:Column>
                                            </Columns>
                                    </ColumnModel>                                    
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolBar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore" DisplayInfo="false" />
                                    </BottomBar>
                                    <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>             
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>
</body>
</html>