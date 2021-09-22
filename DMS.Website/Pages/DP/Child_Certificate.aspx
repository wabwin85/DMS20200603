<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Child_Certificate.aspx.cs"
    Inherits="DMS.Website.Pages.DP.Child_Certificate" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>证照信息</title>
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
    <ext:Store ID="LinkStore5" runat="server" UseIdConfirmation="true" OnRefreshData="Link5_RefershData"
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
    <ext:Store ID="LinkStore6" runat="server" UseIdConfirmation="true" OnRefreshData="Link6_RefershData"
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
    <ext:Store ID="LinkStore7" runat="server" UseIdConfirmation="true" OnRefreshData="Link7_RefershData"
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
    <ext:Store ID="LinkStore8" runat="server" UseIdConfirmation="true" OnRefreshData="Link8_RefershData"
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
    <ext:Store ID="StoreAnnex5" runat="server" UseIdConfirmation="true" OnRefreshData="Annex5_RefershData"
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
    <ext:Store ID="StoreAnnex6" runat="server" UseIdConfirmation="true" OnRefreshData="Annex6_RefershData"
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
    <ext:Store ID="StoreAnnex7" runat="server" UseIdConfirmation="true" OnRefreshData="Annex7_RefershData"
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
    <ext:Store ID="StoreAnnex8" runat="server" UseIdConfirmation="true" OnRefreshData="Annex8_RefershData"
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
    <ext:Store ID="Store_Warning" runat="server" UseIdConfirmation="true" OnRefreshData="Warning_RefershData"
        AutoLoad="true">
        <AjaxEventConfig IsUpload="true" />
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="ID">
                <Fields>
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="BegDate" />
                    <ext:RecordField Name="EndDate" />
                    <ext:RecordField Name="Warning" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Name" Direction="ASC" />
    </ext:Store>
    <ext:Hidden runat="server" ID="hfUdstrCd">
    </ext:Hidden>
    <ext:Hidden runat="server" ID="hfVersion">
    </ext:Hidden>
    <ext:Hidden ID="hdDisID" runat="server">
    </ext:Hidden>
    <ext:TabPanel ID="TabPanel1" runat="server" Height="450" Border="false">
        <Tabs>
            <ext:Tab ID="Tab1" Hidden="true"  runat="server" Title="企业法人营业执照" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion1" runat="server" Animate="true">
                        <ext:Panel ID="Panel1" runat="server" Title="基本信息" Height="442" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel13" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_bl_begin" runat="server" FieldLabel="开始日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_bl_Legal" runat="server" FieldLabel="法人" Width="200" />
                                                    </ext:Anchor>
                                                     <ext:Anchor>
                                                        <ext:TextArea ID="tb_bl_Remarks" runat="server" FieldLabel="备注" Width="200"></ext:TextArea>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel14" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_bl_end" runat="server" FieldLabel="截止日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="ddl_bl_isnoStamp" runat="server" FieldLabel="证照是否盖章" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
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
            <ext:Tab ID="Tab2" Hidden="true"  runat="server" Title="企业组织机构代码证" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion2" runat="server" Animate="true">
                        <ext:Panel ID="Panel4" runat="server" Title="基本信息" Height="442" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel31" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_occ_begin" runat="server" FieldLabel="开始日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_occ_Code" runat="server" FieldLabel="组织机构代码证号" Width="200" />
                                                    </ext:Anchor>
                                                     <ext:Anchor>
                                                        <ext:TextField ID="tb_occ_Remarks" runat="server" FieldLabel="备注" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel32" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_occ_end" runat="server" FieldLabel="截止日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="ddl_occ_isnoStamp" runat="server" FieldLabel="证照是否盖章" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                              
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
            <ext:Tab ID="Tab3" Hidden="true"  runat="server" Title="税务登记证（国税）" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion3" runat="server" Animate="true">
                        <ext:Panel ID="Panel7" runat="server" Title="基本信息" Height="442" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel36" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_nt_begin" runat="server" FieldLabel="开始日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_nt_Code" runat="server" FieldLabel="登记证号" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="ddl_nt_Type" runat="server" FieldLabel="公司类型" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel37" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_nt_end" runat="server" FieldLabel="截止日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="ddl_nt_isnoStamp" runat="server" FieldLabel="证照是否盖章" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_nt_Remarks" runat="server" FieldLabel="备注" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
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
            <ext:Tab ID="Tab4" Hidden="true"  runat="server" Title="税务登记证（地税）" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion4" runat="server" Animate="true">
                        <ext:Panel ID="Panel10" runat="server" Title="基本信息" Height="442" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel39" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout13" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_lt_begin" runat="server" FieldLabel="开始日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_lt_Code" runat="server" FieldLabel="登记证号" Width="200" />
                                                    </ext:Anchor>
                                                      <ext:Anchor>
                                                        <ext:TextField ID="tb_lt_Remarks" runat="server" FieldLabel="备注" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel40" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout14" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_lt_end" runat="server" FieldLabel="截止日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="ddl_lt_isnoStamp" runat="server" FieldLabel="证照是否盖章" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
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
            <ext:Tab ID="Tab5" Hidden="true"  runat="server" Title="医疗器械经营企业许可证" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion5" runat="server" Animate="true">
                        <ext:Panel ID="Panel15" runat="server" Title="基本信息" Height="442" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel44" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout17" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_ml_begin" runat="server" FieldLabel="开始日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_ml_Quality" runat="server" FieldLabel="质管人员" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_ml_Address" runat="server" FieldLabel="管人员" Width="200" />
                                                    </ext:Anchor>
                                                      <ext:Anchor>
                                                        <ext:TextField ID="tb_ml_Scope" runat="server" FieldLabel="经营范围" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel45" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout18" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_ml_end" runat="server" FieldLabel="截止日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="ddl_ml_isnoStamp" runat="server" FieldLabel="证照是否盖章" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_ml_Remarks" runat="server" FieldLabel="备注" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel16" runat="server" Title="参考链接" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout9" runat="server">
                                    <ext:GridPanel ID="GridPanel9" runat="server" Title="" StoreID="LinkStore5" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel9" runat="server">
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
                                            <ext:RowSelectionModel ID="RowSelectionModel9" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar9" runat="server" PageSize="10" StoreID="LinkStore5"
                                                DisplayInfo="true" DisplayMsg="{2}个链接中第{0}-{1}个" EmptyMsg="没有链接数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel20" runat="server" Title="附件信息" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout10" runat="server">
                                    <ext:GridPanel ID="GridPanel10" runat="server" Title="" StoreID="StoreAnnex5" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel10" runat="server">
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
                                            <ext:RowSelectionModel ID="RowSelectionModel10" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar10" runat="server" PageSize="10" StoreID="StoreAnnex5"
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
            <ext:Tab ID="Tab6" Hidden="true"  runat="server" Title="药品经营许可证" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion6" runat="server" Animate="true">
                        <ext:Panel ID="Panel21" runat="server" Title="基本信息" Height="442" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout10" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel50" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout21" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_pt_begin" runat="server" FieldLabel="开始日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_pt_Quality" runat="server" FieldLabel="质管人员" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_pt_Address" runat="server" FieldLabel="仓库地址" Width="200" />
                                                    </ext:Anchor>
                                                      <ext:Anchor>
                                                        <ext:TextField ID="tb_pt_Scope" runat="server" FieldLabel="经营范围" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel49" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout22" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_pt_end" runat="server" FieldLabel="截止日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="ddl_pt_isnoStamp" runat="server" FieldLabel="证照是否盖章" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_pt_Remarks" runat="server" FieldLabel="备注" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel22" runat="server" Title="参考链接" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout11" runat="server">
                                    <ext:GridPanel ID="GridPanel11" runat="server" Title="" StoreID="LinkStore6" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel11" runat="server">
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
                                            <ext:RowSelectionModel ID="RowSelectionModel11" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar11" runat="server" PageSize="10" StoreID="LinkStore6"
                                                DisplayInfo="true" DisplayMsg="{2}个链接中第{0}-{1}个" EmptyMsg="没有链接数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel23" runat="server" Title="附件信息" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout12" runat="server">
                                    <ext:GridPanel ID="GridPanel12" runat="server" Title="" StoreID="StoreAnnex6" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel12" runat="server">
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
                                            <ext:RowSelectionModel ID="RowSelectionModel12" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar12" runat="server" PageSize="10" StoreID="StoreAnnex6"
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
            <ext:Tab ID="Tab7" Hidden="true"  runat="server" Title="危险化学品经营许可证" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion7" runat="server" Animate="true">
                        <ext:Panel ID="Panel24" runat="server" Title="基本信息" Height="442" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout12" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel54" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout25" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_hc_begin" runat="server" FieldLabel="开始日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_hc_Quality" runat="server" FieldLabel="质管人员" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_hc_Scope" runat="server" FieldLabel="经营范围" Width="200" />
                                                    </ext:Anchor>
                                                     <ext:Anchor>
                                                        <ext:TextField ID="tb_hc_Remarks" runat="server" FieldLabel="备注" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel55" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout26" runat="server" LabelAlign="Left" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="dp_hc_end" runat="server" FieldLabel="截止日期" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="ddl_hc_isnoStamp" runat="server" FieldLabel="证照是否盖章" Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tb_hc_Address" runat="server" FieldLabel="仓库地址" Width="200" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel25" runat="server" Title="参考链接" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout13" runat="server">
                                    <ext:GridPanel ID="GridPanel13" runat="server" Title="" StoreID="LinkStore7" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel13" runat="server">
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
                                            <ext:RowSelectionModel ID="RowSelectionModel13" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar13" runat="server" PageSize="10" StoreID="LinkStore7"
                                                DisplayInfo="true" DisplayMsg="{2}个链接中第{0}-{1}个" EmptyMsg="没有链接数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel26" runat="server" Title="附件信息" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout14" runat="server">
                                    <ext:GridPanel ID="GridPanel14" runat="server" Title="" StoreID="StoreAnnex7" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel14" runat="server">
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
                                            <ext:RowSelectionModel ID="RowSelectionModel14" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar14" runat="server" PageSize="10" StoreID="StoreAnnex7"
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
            <ext:Tab ID="Tab8" Hidden="true"  runat="server" Title="提醒及警告" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion8" runat="server" Animate="true">
                        <ext:Panel ID="Panel27" runat="server" Title="基本信息" Height="442">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout1" runat="server">
                                    <North Collapsible="True" Split="True">
                                        <ext:Panel ID="plSearch" runat="server" Header="false" Frame="true" AutoHeight="true"
                                            Icon="Find">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout14" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel58" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout28" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tb_LicenseName" runat="server" FieldLabel="证照名称" Width="170">
                                                                        </ext:TextField>
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
                                                        <Click Handler="#{GridPanel_Warning}.reload();" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </North>
                                    <Center Collapsible="false" Split="True">
                                        <ext:Panel runat="server" ID="Panelctl46" Border="false" Frame="false">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout17" runat="server">
                                                    <ext:GridPanel ID="GridPanel_Warning" runat="server" Title="查询结果" Header="false"
                                                        StoreID="Store_Warning" Border="false">
                                                        <ColumnModel ID="ColumnModel17" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Name" DataIndex="Name" Header="证照名称">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="BegDate" DataIndex="BegDate" Header="签发时间">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="EndDate" DataIndex="EndDate" Header="终止时间">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Warning" DataIndex="Warning" Header="提示信息">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel17" runat="server" />
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
                        <ext:Panel ID="Panel28" runat="server" Title="参考链接" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout15" runat="server">
                                    <ext:GridPanel ID="GridPanel15" runat="server" Title="" StoreID="LinkStore8" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel15" runat="server">
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
                                            <ext:RowSelectionModel ID="RowSelectionModel15" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar15" runat="server" PageSize="10" StoreID="LinkStore8"
                                                DisplayInfo="true" DisplayMsg="{2}个链接中第{0}-{1}个" EmptyMsg="没有链接数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel29" runat="server" Title="附件信息" Height="442">
                            <Body>
                                <ext:FitLayout ID="FitLayout16" runat="server">
                                    <ext:GridPanel ID="GridPanel16" runat="server" Title="" StoreID="StoreAnnex8" Border="false"
                                        Icon="Lorry">
                                        <ColumnModel ID="ColumnModel16" runat="server">
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
                                            <ext:RowSelectionModel ID="RowSelectionModel16" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar16" runat="server" PageSize="10" StoreID="StoreAnnex8"
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
