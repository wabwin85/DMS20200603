<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderConfirmation.aspx.cs" Inherits="DMS.Website.Pages.Order.OrderConfirmation" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
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
                     <ext:RecordField Name="OrderNo" />
                     <ext:RecordField Name="SapOrderNo" />
                     <ext:RecordField Name="DealerSapCode" />
                     <ext:RecordField Name="SapCreateDate"  Type="Date"/>
                     <ext:RecordField Name="ArticleNumber" />
                     <ext:RecordField Name="OrderNum" />
                     <ext:RecordField Name="Price" />
                     <ext:RecordField Name="Amount" />
                     <ext:RecordField Name="Tax" />
                     <ext:RecordField Name="FirstAvailableDate" />
                     <ext:RecordField Name="Flag" />
                     <ext:RecordField Name="DmaId" />
                     <ext:RecordField Name="CfnId" />
                     <ext:RecordField Name="BumId" />
                     <ext:RecordField Name="PctId" />
                     <ext:RecordField Name="PohId" />
                     <ext:RecordField Name="PodId" />
                     <ext:RecordField Name="Authorized" />
                     <ext:RecordField Name="ProblemDescription" />
                     <ext:RecordField Name="LineNbr" />
                     <ext:RecordField Name="FileName" />
                     <ext:RecordField Name="ImportDate"  Type="Date"/>
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
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="100">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbDealer" runat="server" 
                                                        EmptyText="<%$ Resources: cbDealer.EmptyText %>" 
                                                        Width="220" 
                                                        Editable="true"
                                                        Mode="Local"
                                                        TypeAhead="true" 
                                                        StoreID="DealerStore" 
                                                        ValueField="Id" 
                                                        DisplayField="ChineseName"
                                                        FieldLabel="<%$ Resources: cbDealer.FieldLabel %>" ListWidth="300" Resizable="true"
                                                    >
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbDealer.FieldTrigger.Qtip %>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                    </ext:ComboBox>                                                    
                                                </ext:Anchor>
                                            
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbProblemDescription" runat="server" 
                                                        EmptyText="<%$ Resources: cbProblemDescription.EmptyText %>" 
                                                        Width="150" 
                                                        Editable="false"
                                                        TypeAhead="true"
                                                        FieldLabel="<%$ Resources: cbProblemDescription.FieldLabel %>"
                                                    >
                                                    <Items>
                                                        <ext:ListItem Text="经销商不存在" Value="经销商不存在" />
                                                        <ext:ListItem Text="产品型号不存在" Value="产品型号不存在" />
                                                        <ext:ListItem Text="产品线未关联" Value="产品线未关联" />
                                                        <ext:ListItem Text="未做授权" Value="未做授权" />
                                                        <ext:ListItem Text="关联订单不存在" Value="关联订单不存在" />
                                                    </Items>
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbProblemDescription.FieldTrigger.Qtip %>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                    </ext:ComboBox>                                                    
                                                </ext:Anchor>
                                                
                                                    <ext:Anchor>
                                                    <ext:DateField ID="txtStartDate" runat="server" Width="150" FieldLabel="<%$ Resources: txtStartDate.FieldLabel %>" />
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
                                                    <ext:TextField ID="txtSapCode" runat="server" Width="150" FieldLabel="<%$ Resources: txtSapCode.FieldLabel %>" />
                                                </ext:Anchor>
                                               
                                                   <ext:Anchor>
                                                    <ext:TextField ID="txtSAPOrderNo" runat="server" Width="150" FieldLabel="<%$ Resources: txtSAPOrderNo.FieldLabel %>" />
                                                </ext:Anchor>   
                                                 <ext:Anchor>
                                                    <ext:DateField ID="txtEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: txtEndDate.FieldLabel %>" />
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
                                                    <ext:TextField ID="txtOrderNo" runat="server" Width="150" FieldLabel="<%$ Resources: txtOrderNo.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtArticleNumber" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text %>" runat="server" Icon="ArrowRefresh">
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
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="Id" DataIndex="Id" Header="<%$ Resources: GridPanel1.Id %>" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="OrderNo" DataIndex="OrderNo" Header="<%$ Resources: GridPanel1.OrderNo %>">                                                    
                                                </ext:Column>
                                                <ext:Column ColumnID="SapOrderNo" DataIndex="SapOrderNo" Header="<%$ Resources: GridPanel1.SapOrderNo %>">                                                    
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerSapCode" DataIndex="DealerSapCode" Width="120" Header="<%$ Resources: GridPanel1.DealerSapCode %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="SapCreateDate" DataIndex="SapCreateDate" Header="<%$ Resources: GridPanel1.SapCreateDate %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArticleNumber" DataIndex="ArticleNumber" Header="<%$ Resources: resource,Lable_Article_Number %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="OrderNum" DataIndex="OrderNum" Header="<%$ Resources: GridPanel1.OrderNum %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Price" DataIndex="Price" Header="<%$ Resources: GridPanel1.Price %>" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount" DataIndex="Amount" Header="<%$ Resources: GridPanel1.Amount %>" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="Tax" DataIndex="Tax" Header="<%$ Resources: GridPanel1.Tax %>" Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="FirstAvailableDate" DataIndex="FirstAvailableDate" Width="150" Header="<%$ Resources: GridPanel1.FirstAvailableDate %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Flag" DataIndex="Flag" Header="<%$ Resources: GridPanel1.Flag %>" Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="Authorized" DataIndex="Authorized" Header="<%$ Resources: GridPanel1.Authorized %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProblemDescription" DataIndex="ProblemDescription" Header="<%$ Resources: GridPanel1.ProblemDescription %>" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="LineNbr" DataIndex="LineNbr" Header="<%$ Resources: GridPanel1.LineNbr %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="FileName" DataIndex="FileName" Header="<%$ Resources: GridPanel1.FileName %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ImportDate" DataIndex="ImportDate" Header="<%$ Resources: GridPanel1.ImportDate %>">
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
