<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Child_Contract.aspx.cs"
    Inherits="DMS.Website.Pages.DP.Child_Contract" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>合同信息</title>
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
    <ext:Store ID="Store_Contract" runat="server" UseIdConfirmation="true" OnRefreshData="Contract_RefershData"
        AutoLoad="true">
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
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Column1" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="Store_File" runat="server" UseIdConfirmation="true" OnRefreshData="File_RefershData"
        AutoLoad="true">
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
                    <ext:RecordField Name="Column6" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Column1" Direction="ASC" />
    </ext:Store>
    <ext:Hidden runat="server" ID="hfUdstrCd">
    </ext:Hidden>
    <ext:Hidden runat="server" ID="hfVersion">
    </ext:Hidden>
    <ext:Hidden ID="hdDisID" runat="server">
    </ext:Hidden>
    <ext:TabPanel ID="TabPanel1" runat="server" Height="450" Border="false">
        <Tabs>
            <ext:Tab ID="Tab1" Hidden="true" runat="server" Title="合同记录" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion2" runat="server" Animate="true">
                        <ext:Panel ID="Panel4" runat="server" Title="基本信息" Height="442">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout1" runat="server">
                                    <North Collapsible="True" Split="True">
                                        <ext:Panel ID="plSearch" runat="server" Header="false" Frame="true" AutoHeight="true"
                                            Icon="Find">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel16" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="110">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfContractBegin" runat="server" FieldLabel="合同起始时间" Width="200" EmptyText="YYYYMMDD" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="110">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfContractEnd" runat="server" FieldLabel="合同终止时间" Width="200" EmptyText="YYYYMMDD" />
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
                                                        <Click Handler="#{GridPanel_Contract}.reload();" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </North>
                                    <Center Collapsible="false" Split="True">
                                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="false">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout9" runat="server">
                                                    <ext:GridPanel ID="GridPanel_Contract" runat="server" Title="查询结果" Header="false"
                                                        StoreID="Store_Contract" Border="false">
                                                        <ColumnModel ID="ColumnModel9" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Column1" DataIndex="Column1" Header="经销商合同号">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column2" DataIndex="Column2" Header="合同名称">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column3" DataIndex="Column3" Header="合同起始时间">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column4" DataIndex="Column4" Header="合同终止时间">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column5" DataIndex="Column5" Header="部门">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column6" DataIndex="Column6" Header="合同类型">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column7" DataIndex="Column7" Header="备注">
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
                                    <ext:GridPanel ID="GridPanel3" runat="server" Title="" StoreID="LinkStore1" Border="false"
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
                                            <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="10" StoreID="LinkStore1"
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
                                    <ext:GridPanel ID="GridPanel4" runat="server" Title="" StoreID="StoreAnnex1" Border="false"
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
                                            <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="10" StoreID="StoreAnnex1"
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
            <ext:Tab ID="Tab2" Hidden="true" runat="server" Title="文件记录" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion1" runat="server" Animate="true">
                        <ext:Panel ID="Panel2" runat="server" Title="基本信息" Height="442">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout2" runat="server">
                                    <North Collapsible="True" Split="True">
                                        <ext:Panel ID="Panel3" runat="server" Header="false" Frame="true" AutoHeight="true"
                                            Icon="Find">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel7" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfFileCode" runat="server" FieldLabel="授权编号" Width="150" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel8" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfFileBegin" runat="server" FieldLabel="授权起始时间" Width="150" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth=".3">
                                                        <ext:Panel ID="Panel9" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="100">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfFileEnd" runat="server" FieldLabel="授权结束时间" Width="150" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                            <Buttons>
                                                <ext:Button ID="Button1" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="#{GridPanel_File}.reload();" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </North>
                                    <Center Collapsible="false" Split="True">
                                        <ext:Panel runat="server" ID="Panel10" Border="false" Frame="false">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout1" runat="server">
                                                    <ext:GridPanel ID="GridPanel_File" runat="server" Title="查询结果" Header="false" StoreID="Store_File"
                                                        Border="false">
                                                        <ColumnModel ID="ColumnModel1" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Column1" DataIndex="Column1" Header="授权编号">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column2" DataIndex="Column2" Header="出具日期">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column3" DataIndex="Column3" Header="所属部门">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column4" DataIndex="Column4" Header="起始授权期限">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column5" DataIndex="Column5" Header="终止授权期限">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column6" DataIndex="Column6" Header="类型">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Column7" DataIndex="Column7" Header="备注">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
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
                                <ext:FitLayout ID="FitLayout2" runat="server">
                                    <ext:GridPanel ID="GridPanel2" runat="server" Title="" StoreID="LinkStore2" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel2" runat="server">
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
                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="LinkStore2"
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
                                <ext:FitLayout ID="FitLayout5" runat="server">
                                    <ext:GridPanel ID="GridPanel5" runat="server" Title="" StoreID="StoreAnnex2" Border="false"
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
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="StoreAnnex2"
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
