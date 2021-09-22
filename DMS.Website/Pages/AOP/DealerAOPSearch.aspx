<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerAOPSearch.aspx.cs"
    Inherits="DMS.Website.Pages.AOP.DealerAOPSearch" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
        AutoLoad="false">
        <AutoLoadParams>
            <ext:Parameter Name="start" Value="={0}" />
            <ext:Parameter Name="limit" Value="={15}" />
        </AutoLoadParams>
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="DmaId" />
                    <ext:RecordField Name="DealerName" />
                    <ext:RecordField Name="ProductLine_BUM_ID" />
                    <ext:RecordField Name="ProductLineName" />
                    <ext:RecordField Name="SubBUName" />
                    <ext:RecordField Name="MarketType" />
                    <ext:RecordField Name="Year" />
                    <ext:RecordField Name="Amount_1" />
                    <ext:RecordField Name="Amount_2" />
                    <ext:RecordField Name="Amount_3" />
                    <ext:RecordField Name="Amount_4" />
                    <ext:RecordField Name="Amount_5" />
                    <ext:RecordField Name="Amount_6" />
                    <ext:RecordField Name="Amount_7" />
                    <ext:RecordField Name="Amount_8" />
                    <ext:RecordField Name="Amount_9" />
                    <ext:RecordField Name="Amount_10" />
                    <ext:RecordField Name="Amount_11" />
                    <ext:RecordField Name="Amount_12" />
                    <ext:RecordField Name="Amount_Y" />
                </Fields>
            </ext:JsonReader>
        </Reader>
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
        <Listeners>
            <Load Handler="#{cbDealer}.setValue(#{hidInitDealerId}.getValue());" />
        </Listeners>
    </ext:Store>
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
    <ext:Store ID="MarketTypeStore" runat="server" AutoLoad="true" OnRefreshData="MarketTypeStore_RefershData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="MarketTypeId">
                <Fields>
                    <ext:RecordField Name="MarketTypeId" />
                    <ext:RecordField Name="MarketTypeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hidInitDealerId" runat="server">
    </ext:Hidden>
    <div>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择经销商" Width="200" Editable="true"
                                                            TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName"
                                                            Mode="Local" FieldLabel="经销商" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfYear" runat="server" FieldLabel="年份" EmptyText="YYYY" Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="请选择产品线" Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName"
                                                            FieldLabel="产品线" ListWidth="300" Resizable="true">
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
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbMarketType" runat="server" EmptyText="请选择市场类型" Width="150" Editable="true"
                                                            TypeAhead="true" Resizable="true" StoreID="MarketTypeStore" ValueField="MarketTypeId"
                                                            DisplayField="MarketTypeName" FieldLabel="市场类型">
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
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商名称" Width="250">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="产品线" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="SubBUName" DataIndex="SubBUName" Header="产品分类" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="MarketType" DataIndex="MarketType" Header="市场类型" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="年份" Width="70">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_1" DataIndex="Amount_1" Header="一月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_2" DataIndex="Amount_2" Header="二月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_3" DataIndex="Amount_3" Header="三月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_4" DataIndex="Amount_4" Header="四月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_5" DataIndex="Amount_5" Header="五月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_6" DataIndex="Amount_6" Header="六月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_7" DataIndex="Amount_7" Header="七月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_8" DataIndex="Amount_8" Header="八月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_9" DataIndex="Amount_9" Header="九月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_10" DataIndex="Amount_10" Header="十月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_11" DataIndex="Amount_11" Header="十一月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_12" DataIndex="Amount_12" Header="十二月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="合计">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="Button2" runat="server" Text="导出授权" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="true" OnClick="ExportExcel">
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </div>
    </form>
</body>
</html>
