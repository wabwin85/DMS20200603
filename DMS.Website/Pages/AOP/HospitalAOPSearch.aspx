<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HospitalAOPSearch.aspx.cs"
    Inherits="DMS.Website.Pages.AOP.HospitalAOPSearch" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
                    <ext:RecordField Name="SAPCode" />
                    <ext:RecordField Name="DealerName" />
                    <ext:RecordField Name="ProductLineId" />
                    <ext:RecordField Name="ProductLineName" />
                    <ext:RecordField Name="CC_Code" />
                    <ext:RecordField Name="CC_NameCN" />
                    <ext:RecordField Name="PCTCode" />
                    <ext:RecordField Name="PCTName" />
                    <ext:RecordField Name="HospitalId" />
                    <ext:RecordField Name="HOS_HospitalName" />
                    <ext:RecordField Name="AOPType" />
                    <ext:RecordField Name="Year" />
                    <ext:RecordField Name="Month1" />
                    <ext:RecordField Name="Month2" />
                    <ext:RecordField Name="Month3" />
                    <ext:RecordField Name="Month4" />
                    <ext:RecordField Name="Month5" />
                    <ext:RecordField Name="Month6" />
                    <ext:RecordField Name="Month7" />
                    <ext:RecordField Name="Month8" />
                    <ext:RecordField Name="Month9" />
                    <ext:RecordField Name="Month10" />
                    <ext:RecordField Name="Month11" />
                    <ext:RecordField Name="Month12" />
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
    <ext:Store ID="SubProductStore" runat="server" AutoLoad="true" OnRefreshData="SubProductStore_RefershData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Code">
                <Fields>
                    <ext:RecordField Name="Code" />
                    <ext:RecordField Name="Namecn" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="QtSubProductStore" runat="server" AutoLoad="true" OnRefreshData="QtSubProductStore_RefershData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="CQ_Code">
                <Fields>
                    <ext:RecordField Name="CQ_Code" />
                    <ext:RecordField Name="CQ_NameCN" />
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
                                                        <ext:ComboBox ID="cbQtSubProduct" runat="server" EmptyText="指标产品分类" Width="200" Editable="true"
                                                            TypeAhead="true" Resizable="true" StoreID="QtSubProductStore" ValueField="CQ_Code"
                                                            DisplayField="CQ_NameCN" FieldLabel="指标产品分类">
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
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="请选择产品线" Width="200" Editable="false"
                                                            TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName"
                                                            FieldLabel="产品线" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <Select Handler="#{cbSubProduct}.clearValue(); #{SubProductStore}.reload(); #{cbQtSubProduct}.clearValue(); #{QtSubProductStore}.reload();" />
                                                                <TriggerClick Handler="this.clearValue(); #{cbSubProduct}.clearValue(); #{SubProductStore}.reload(); #{cbQtSubProduct}.clearValue(); #{QtSubProductStore}.reload();" />
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
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbSubProduct" runat="server" EmptyText="请选择合同产品分类" Width="200"
                                                            Editable="true" TypeAhead="true" Resizable="true" StoreID="SubProductStore" ValueField="Code"
                                                            DisplayField="Namecn" FieldLabel="产品分类">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <Select Handler="#{cbQtSubProduct}.clearValue(); #{QtSubProductStore}.reload();" />
                                                                <TriggerClick Handler="this.clearValue();  #{cbQtSubProduct}.clearValue(); #{QtSubProductStore}.reload();" />
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
                                                <ext:Column ColumnID="CC_NameCN" DataIndex="CC_NameCN" Header="合同分类" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="PCTName" DataIndex="PCTName" Header="指标分类" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="HOS_HospitalName" DataIndex="HOS_HospitalName" Header="医院名称"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="年份" Width="70">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month1" DataIndex="Month1" Header="一月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month2" DataIndex="Month2" Header="二月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month3" DataIndex="Month3" Header="三月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month4" DataIndex="Month4" Header="四月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month5" DataIndex="Month5" Header="五月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month6" DataIndex="Month6" Header="六月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month7" DataIndex="Month7" Header="七月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month8" DataIndex="Month8" Header="八月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month9" DataIndex="Month9" Header="九月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month10" DataIndex="Month10" Header="十月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month11" DataIndex="Month11" Header="十一月">
                                                </ext:Column>
                                                <ext:Column ColumnID="Month12" DataIndex="Month12" Header="十二月">
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
