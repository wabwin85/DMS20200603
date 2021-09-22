<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Child_BasicInfo.aspx.cs"
    Inherits="DMS.Website.Pages.DP.Child_BasicInfo" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>基本信息</title>

    <script language="javascript" type="text/javascript">
        var renderUrl= function(value){
            return String.format('<a href="http://{0}" target="_blank">{1}</a>', value, value);
        }
        
        var downloadUrl=function(value){
            return String.format('<a href="{0}" target="_blank">{1}</a>', value, value);
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <ext:Store ID="LinkStore1" runat="server" UseIdConfirmation="true" OnRefreshData="Link1_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="ArchiveName" />
                    <ext:RecordField Name="ArchiveUrl" />
                    <ext:RecordField Name="FileNameReturn" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="CreateDate" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="LinkStore2" runat="server" UseIdConfirmation="true" OnRefreshData="Link2_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="ArchiveName" />
                    <ext:RecordField Name="ArchiveUrl" />
                    <ext:RecordField Name="FileNameReturn" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="CreateDate" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="LinkStore3" runat="server" UseIdConfirmation="true" OnRefreshData="Link3_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="ArchiveName" />
                    <ext:RecordField Name="ArchiveUrl" />
                    <ext:RecordField Name="FileNameReturn" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="CreateDate" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="LinkStore4" runat="server" UseIdConfirmation="true" OnRefreshData="Link4_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="ArchiveName" />
                    <ext:RecordField Name="ArchiveUrl" />
                    <ext:RecordField Name="FileNameReturn" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="CreateDate" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="StoreAnnex1" runat="server" UseIdConfirmation="true" OnRefreshData="Annex1_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="ArchiveName" />
                    <ext:RecordField Name="ArchiveUrl" />
                    <ext:RecordField Name="FileNameReturn" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="CreateDate" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="StoreAnnex2" runat="server" UseIdConfirmation="true" OnRefreshData="Annex2_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="ArchiveName" />
                    <ext:RecordField Name="ArchiveUrl" />
                    <ext:RecordField Name="FileNameReturn" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="CreateDate" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="StoreAnnex3" runat="server" UseIdConfirmation="true" OnRefreshData="Annex3_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="ArchiveName" />
                    <ext:RecordField Name="ArchiveUrl" />
                    <ext:RecordField Name="FileNameReturn" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="CreateDate" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="StoreAnnex4" runat="server" UseIdConfirmation="true" OnRefreshData="Annex4_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="ArchiveName" />
                    <ext:RecordField Name="ArchiveUrl" />
                    <ext:RecordField Name="FileNameReturn" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="CreateDate" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="Store_SCDealer" runat="server" UseIdConfirmation="true" OnRefreshData="SCDealer_RefershData"
        AutoLoad="true" OnSubmitData="Store_SCDealer_Submit">
        <AjaxEventConfig IsUpload="true" />
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Column1" />
                    <ext:RecordField Name="Column2" />
                    <ext:RecordField Name="Column3" />
                    <ext:RecordField Name="Column4" />
                    <ext:RecordField Name="Column5" />
                    <ext:RecordField Name="Column6" />
                    <ext:RecordField Name="Column7" />
                    <ext:RecordField Name="Column8" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Column1" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="Store_AboutDis" runat="server" UseIdConfirmation="true" OnRefreshData="AboutDis_RefershData"
        AutoLoad="true" OnSubmitData="Store_AboutDis_Submit">
        <AjaxEventConfig IsUpload="true" />
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Column1" />
                    <ext:RecordField Name="Column2" />
                    <ext:RecordField Name="Column3" />
                    <ext:RecordField Name="Column4" />
                    <ext:RecordField Name="Column5" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Column1" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="Store_CoopDep" runat="server" UseIdConfirmation="true" OnRefreshData="CoopDep_RefershData"
        OnSubmitData="Store_CoopDep_Submit" AutoLoad="true">
        <AjaxEventConfig IsUpload="true" />
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Column1" />
                    <ext:RecordField Name="Column2" />
                    <ext:RecordField Name="Column3" />
                    <ext:RecordField Name="Column4" />
                    <ext:RecordField Name="Column5" />
                    <ext:RecordField Name="Column6" />
                    <ext:RecordField Name="Column7" />
                    <ext:RecordField Name="Column8" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Column3" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="FranchiseStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_FranchiseRefresh"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Franchise">
                <Fields>
                    <ext:RecordField Name="Franchise" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="BuStore" runat="server" AutoLoad="true" UseIdConfirmation="true" OnRefreshData="Store_BuRefresh">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Bu">
                <Fields>
                    <ext:RecordField Name="Bu" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="StoreCoopFranch" runat="server" UseIdConfirmation="true" OnRefreshData="Store_CoopFranchiseRefresh"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Franchise">
                <Fields>
                    <ext:RecordField Name="Franchise" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="StoreCoopBu" runat="server" AutoLoad="true" UseIdConfirmation="true"
        OnRefreshData="Store_CoopBuRefresh">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Bu">
                <Fields>
                    <ext:RecordField Name="Bu" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden runat="server" ID="hfUdstrCd">
    </ext:Hidden>
    <ext:Hidden runat="server" ID="hfVersion">
    </ext:Hidden>
    <ext:Hidden ID="hdDisID" runat="server">
    </ext:Hidden>
    <ext:TabPanel ID="TabPanel1" runat="server" Height="450" Border="false">
        <Tabs>
            <ext:Tab ID="Tab1" Hidden="true" runat="server" Title="主要信息" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion1" runat="server" Animate="true">
                        <ext:Panel ID="Panel1" runat="server" Title="基本信息" Height="442">
                            <Body>
                                <ext:FormLayout ID="FormLayout11" runat="server">
                                    <ext:Anchor>
                                        <ext:Panel ID="Panel17" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel13" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfEName" runat="server" FieldLabel="英文名称" Width="150" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfCpCode" runat="server" FieldLabel="公司代码" Width="150" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel14" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="100">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfDisType" runat="server" FieldLabel="分销商类型" Width="150" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfProvince" runat="server" FieldLabel="省份" Width="150" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth=".3">
                                                        <ext:Panel ID="Panel15" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="100">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfCoopType" runat="server" FieldLabel="合作类型" Width="150" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfCity" runat="server" FieldLabel="城市" Width="150" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:Anchor>
                                    <ext:Anchor>
                                        <ext:Panel ID="Panel18" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".5">
                                                        <ext:Panel ID="Panel19" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfAddress" runat="server" FieldLabel="地址" Width="400" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel2" runat="server" Title="参考链接" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="" StoreID="LinkStore1" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="添加时间" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="添加人员">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveName" DataIndex="ArchiveName" Header="链接名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveUrl" DataIndex="ArchiveUrl" Header="链接地址">
                                                    <Renderer Fn="renderUrl" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="LinkStore1"
                                                DisplayInfo="true" DisplayMsg="{2}个链接中第{0}-{1}个" EmptyMsg="没有链接数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel3" runat="server" Title="附件信息" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout2" runat="server">
                                    <ext:GridPanel ID="GridPanel2" runat="server" Title="" StoreID="StoreAnnex1" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="添加时间" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="添加人员">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveName" DataIndex="ArchiveName" Header="附件名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveUrl" DataIndex="ArchiveUrl" Header="附件地址">
                                                    <Renderer Fn="downloadUrl" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="StoreAnnex1"
                                                DisplayInfo="true" DisplayMsg="{2}个附件中第{0}-{1}个" EmptyMsg="没有附件数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </ext:Accordion>
                </Body>
            </ext:Tab>
            <ext:Tab ID="Tab2" Hidden="true" runat="server" Title="二级经销商信息" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion2" runat="server" Animate="true">
                        <ext:Panel ID="Panel4" runat="server" Title="基本信息" Height="442" >
                            <Body>
                                <ext:BorderLayout ID="BorderLayout1" runat="server">
                                    <North Collapsible="True" Split="True">
                                        <ext:Panel ID="plSearch" runat="server" Header="true" Frame="true" AutoHeight="true" Border="false"
                                            Icon="Find">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel16" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbFranchise" runat="server" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                                            FieldLabel="Franchise" TriggerAction="All" ValueField="Franchise" DisplayField="Franchise"
                                                                            StoreID="FranchiseStore">
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="全选" />
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
                                                        <ext:Panel ID="Panel20" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="100">
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbBu" runat="server" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                                            FieldLabel="Bu" TriggerAction="All" ValueField="Bu" DisplayField="Bu" StoreID="BuStore">
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="全选" />
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
                                                        <Click Handler="#{GridPanel_SCDealer}.reload();" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="Button1" Text="导出" runat="server" Icon="PageExcel">
                                                    <Listeners>
                                                        <Click Handler="#{GridPanel_SCDealer}.submitData(false);" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </North>
                                    <Center Collapsible="false" Split="True">
                                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="false">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout9" runat="server">
                                                    <ext:GridPanel ID="GridPanel_SCDealer" runat="server" Title="查询结果" Header="false"
                                                        StoreID="Store_SCDealer" Border="false"  Icon="Lorry" StripeRows="true">
                                                        <ColumnModel ID="ColumnModel9" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Column1" DataIndex="Column1" Header="Franchise">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column2" DataIndex="Column2" Header="BU">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column3" DataIndex="Column3" Header="二级经销商代码">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column4" DataIndex="Column4" Header="二级经销商名称">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column5" DataIndex="Column5" Header="级别">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column6" DataIndex="Column6" Header="开始合作日期">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column7" DataIndex="Column7" Header="终止合作日期">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column8" DataIndex="Column8" Header="合作状态">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel9" runat="server" />
                                                        </SelectionModel>
                                                        <SaveMask ShowMask="true" />
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </Center>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel5" runat="server" Title="参考链接" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="GridPanel3" runat="server" Title="" StoreID="LinkStore2" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="添加时间" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="添加人员">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveName" DataIndex="ArchiveName" Header="链接名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveUrl" DataIndex="ArchiveUrl" Header="链接地址">
                                                    <Renderer Fn="renderUrl" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="10" StoreID="LinkStore2"
                                                DisplayInfo="true" DisplayMsg="{2}个链接中第{0}-{1}个" EmptyMsg="没有链接数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel6" runat="server" Title="附件信息" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout4" runat="server">
                                    <ext:GridPanel ID="GridPanel4" runat="server" Title="" StoreID="StoreAnnex2" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel4" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="添加时间" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="添加人员">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveName" DataIndex="ArchiveName" Header="附件名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveUrl" DataIndex="ArchiveUrl" Header="附件地址">
                                                    <Renderer Fn="downloadUrl" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="10" StoreID="StoreAnnex2"
                                                DisplayInfo="true" DisplayMsg="{2}个附件中第{0}-{1}个" EmptyMsg="没有附件数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </ext:Accordion>
                </Body>
            </ext:Tab>
            <ext:Tab ID="Tab3" Hidden="true" runat="server" Title="关联经销商信息" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion3" runat="server" Animate="true">
                        <ext:Panel ID="Panel7" runat="server" Title="基本信息" Height="442">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout2" runat="server">
                                    <North Collapsible="True" Split="True">
                                        <ext:Panel ID="Panel21" runat="server" Header="false" Frame="true" AutoHeight="true"
                                            Border="false" Icon="Find">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel22" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfDisName" runat="server" FieldLabel="经销商名称" Width="150" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel23" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                    <ext:Anchor>
                                                                        <ext:DateField runat="server" ID="FromDate" Vtype="daterange" FieldLabel="开始合作时间"
                                                                            Width="150">
                                                                            <Listeners>
                                                                                <Render Handler="this.endDateField = '#{ToDate}'" />
                                                                            </Listeners>
                                                                        </ext:DateField>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth=".3">
                                                        <ext:Panel ID="Panel25" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                    <ext:Anchor>
                                                                        <ext:DateField runat="server" ID="ToDate" Vtype="daterange" FieldLabel="结束合作时间" Width="150">
                                                                            <Listeners>
                                                                                <Render Handler="this.startDateField = '#{FromDate}'" />
                                                                            </Listeners>
                                                                        </ext:DateField>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                            <Buttons>
                                                <ext:Button ID="Button2" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="#{GridPanel_AbuntDis}.reload();" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="Button3" Text="导出" runat="server" Icon="PageExcel">
                                                    <Listeners>
                                                        <Click Handler="#{GridPanel_AbuntDis}.submitData(false);" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </North>
                                    <Center Collapsible="false" Split="True">
                                        <ext:Panel runat="server" ID="Panel24" Border="false" Frame="false">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout10" runat="server">
                                                    <ext:GridPanel ID="GridPanel_AbuntDis" runat="server" Title="查询结果" Header="false"
                                                        StoreID="Store_AboutDis" Border="false">
                                                        <ColumnModel ID="ColumnModel10" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Column1" DataIndex="Column1" Header="经销商代码">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column2" DataIndex="Column2" Header="经销商名称">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column3" DataIndex="Column3" Header="开始合作日期">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column4" DataIndex="Column4" Header="终止合作日期">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column5" DataIndex="Column5" Header="合作状态">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel10" runat="server" />
                                                        </SelectionModel>
                                                        <SaveMask ShowMask="true" />
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </Center>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel8" runat="server" Title="参考链接" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout7" runat="server">
                                    <ext:GridPanel ID="GridPanel7" runat="server" Title="" StoreID="LinkStore3" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel7" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="添加时间" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="添加人员">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveName" DataIndex="ArchiveName" Header="链接名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveUrl" DataIndex="ArchiveUrl" Header="链接地址">
                                                    <Renderer Fn="renderUrl" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel7" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar7" runat="server" PageSize="10" StoreID="LinkStore3"
                                                DisplayInfo="true" DisplayMsg="{2}个链接中第{0}-{1}个" EmptyMsg="没有链接数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel9" runat="server" Title="附件信息" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout5" runat="server">
                                    <ext:GridPanel ID="GridPanel5" runat="server" Title="" StoreID="StoreAnnex3" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel5" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="添加时间" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="添加人员">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveName" DataIndex="ArchiveName" Header="附件名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveUrl" DataIndex="ArchiveUrl" Header="附件地址">
                                                    <Renderer Fn="downloadUrl" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel5" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar5" runat="server" PageSize="10" StoreID="StoreAnnex3"
                                                DisplayInfo="true" DisplayMsg="{2}个附件中第{0}-{1}个" EmptyMsg="没有附件数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </ext:Accordion>
                </Body>
            </ext:Tab>
            <ext:Tab ID="Tab4" Hidden="true" runat="server" Title="合作业务部门" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion4" runat="server" Animate="true">
                        <ext:Panel ID="Panel10" runat="server" Title="基本信息" Height="442">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout3" runat="server">
                                    <North Collapsible="True" Split="True">
                                        <ext:Panel ID="Panel26" runat="server" Header="false" Frame="true" AutoHeight="true"
                                            Border="false" Icon="Find">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel27" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbCoopFranchise" runat="server" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                                            FieldLabel="Franchise" TriggerAction="All" ValueField="Franchise" DisplayField="Franchise"
                                                                            StoreID="StoreCoopFranch">
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="全选" />
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
                                                        <ext:Panel ID="Panel28" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout12" runat="server" LabelAlign="Left" LabelWidth="100">
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbCoopBu" runat="server" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                                            FieldLabel="Bu" TriggerAction="All" ValueField="Bu" DisplayField="Bu" StoreID="StoreCoopBu">
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="全选" />
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
                                                <ext:Button ID="Button4" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="#{GridPanel_CoopDep}.reload();" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="Button5" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="#{GridPanel_CoopDep}.submitData(false);" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </North>
                                    <Center Collapsible="false" Split="True">
                                        <ext:Panel runat="server" ID="Panel29" Border="false" Frame="false">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout11" runat="server">
                                                    <ext:GridPanel ID="GridPanel_CoopDep" runat="server" Title="查询结果" Header="false"
                                                        StoreID="Store_CoopDep" Border="false">
                                                        <ColumnModel ID="ColumnModel11" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Column1" DataIndex="Column1" Header="Franchise">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column2" DataIndex="Column2" Header="BU">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column3" DataIndex="Column3" Header="分销商子代码">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column4" DataIndex="Column4" Header="分销商子名称">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column5" DataIndex="Column5" Header="级别">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column6" DataIndex="Column6" Header="开始合作日期">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column7" DataIndex="Column7" Header="终止合作日期">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column8" DataIndex="Column8" Header="合作状态">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel11" runat="server" />
                                                        </SelectionModel>
                                                        <SaveMask ShowMask="true" />
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </Center>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel11" runat="server" Title="参考链接" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout8" runat="server">
                                    <ext:GridPanel ID="GridPanel8" runat="server" Title="" StoreID="LinkStore4" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel8" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="添加时间" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="添加人员">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveName" DataIndex="ArchiveName" Header="链接名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveUrl" DataIndex="ArchiveUrl" Header="链接地址">
                                                    <Renderer Fn="renderUrl" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel8" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar8" runat="server" PageSize="10" StoreID="LinkStore4"
                                                DisplayInfo="true" DisplayMsg="{2}个链接中第{0}-{1}个" EmptyMsg="没有链接数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel12" runat="server" Title="附件信息" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout6" runat="server">
                                    <ext:GridPanel ID="GridPanel6" runat="server" Title="" StoreID="StoreAnnex4" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel6" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="添加时间" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="添加人员">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveName" DataIndex="ArchiveName" Header="附件名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArchiveUrl" DataIndex="ArchiveUrl" Header="附件地址">
                                                    <Renderer Fn="downloadUrl" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel6" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar6" runat="server" PageSize="10" StoreID="StoreAnnex4"
                                                DisplayInfo="true" DisplayMsg="{2}个附件中第{0}-{1}个" EmptyMsg="没有附件数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </ext:Accordion>
                </Body>
            </ext:Tab>
        </Tabs>
    </ext:TabPanel>
    </form>
</body>
</html>
