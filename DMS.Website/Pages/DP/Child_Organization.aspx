<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Child_Organization.aspx.cs"
    Inherits="DMS.Website.Pages.DP.Child_Organization" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>架构发展</title>
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
                    <ext:RecordField Name="AddDate" />
                    <ext:RecordField Name="AddUser" />
                    <ext:RecordField Name="LinkName" />
                    <ext:RecordField Name="LinkUrl" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="AddDate" Direction="ASC" />
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
                    <ext:RecordField Name="AddDate" />
                    <ext:RecordField Name="AddUser" />
                    <ext:RecordField Name="LinkName" />
                    <ext:RecordField Name="LinkUrl" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="AddDate" Direction="ASC" />
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
                    <ext:RecordField Name="AddDate" />
                    <ext:RecordField Name="AddUser" />
                    <ext:RecordField Name="AnnexName" />
                    <ext:RecordField Name="AnnexUrl" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="AddDate" Direction="ASC" />
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
                    <ext:RecordField Name="AddDate" />
                    <ext:RecordField Name="AddUser" />
                    <ext:RecordField Name="AnnexName" />
                    <ext:RecordField Name="AnnexUrl" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="AddDate" Direction="ASC" />
    </ext:Store>
    <ext:Hidden runat="server" ID="hfUdstrCd">
    </ext:Hidden>
    <ext:Hidden runat="server" ID="hfVersion">
    </ext:Hidden>
    <ext:Hidden ID="hdDisID" runat="server">
    </ext:Hidden>
    <ext:TabPanel ID="TabPanel1" runat="server" Height="450" Border="false">
        <Tabs>
            <ext:Tab ID="Tab1" Hidden="true"  runat="server" Title="公司架构" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion1" runat="server" Animate="true">
                        <ext:Panel ID="Panel1" runat="server" Title="基本信息" Height="442" AutoScroll="true"  BodyStyle="padding:5px;">
                            <Body>
                                <ext:FormLayout ID="FormLayout11" runat="server">
                                    <ext:Anchor>
                                        <ext:Panel ID="Panel17" runat="server" BodyBorder="false" Header="false" >
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel13" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="110">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column1" runat="server" FieldLabel="总经理" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column4" runat="server" FieldLabel="法人" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column7" runat="server" FieldLabel="质量管理人员" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column10" runat="server" FieldLabel="人力资源人员" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column13" runat="server" FieldLabel="合规人员" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column16" runat="server" FieldLabel="财务人员" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column19" runat="server" FieldLabel="采购人员" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column22" runat="server" FieldLabel="仓库人员" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column25" runat="server" FieldLabel="合同管理人员" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column28" runat="server" FieldLabel="数据管理人员" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column31" runat="server" FieldLabel="销售经理名称" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column34" runat="server" FieldLabel="销售人员" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column36" runat="server" FieldLabel="部门" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column38" runat="server" FieldLabel="销售人员2" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column40" runat="server" FieldLabel="部门" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column42" runat="server" FieldLabel="销售人员3" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column44" runat="server" FieldLabel="部门" Width="170" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel14" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="110">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column2" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column5" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column8" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column11" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column14" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column17" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column20" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column23" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column26" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column29" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column32" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column35" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column37" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column39" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column41" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column43" runat="server" FieldLabel="联系电话" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column45" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth=".3">
                                                        <ext:Panel ID="Panel15" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="110">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column3" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column6" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column9" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column12" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column15" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column18" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column21" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column24" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column27" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column30" runat="server" FieldLabel="邮箱地址" Width="170" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column33" runat="server" FieldLabel="邮箱地址" Width="170" />
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
                                        <ext:Panel ID="Panel18" runat="server" BodyBorder="false" Header="false">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".5">
                                                        <ext:Panel ID="Panel19" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="110">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="Column46" runat="server" FieldLabel="申请人邮箱地址" Width="600"  />
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
            <ext:Tab ID="Tab2" Hidden="true" runat="server" Title="公司发展方向与经营产品定位" Border="false" BodyStyle="background-color: #D9E7F8;">
                <Body>
                    <ext:Accordion ID="Accordion2" runat="server" Animate="true">
                        <ext:Panel ID="Panel4" runat="server" Title="基本信息" Height="442" BodyStyle="padding:5px;">
                            <Body>
                                <ext:FormLayout ID="FormLayout4" runat="server">
                                    <ext:Anchor>
                                        <ext:TextArea ID="taDeveloping" FieldLabel="发展方向说明" runat="server" BoxLabel="CheckBox"
                                            Width="400" />
                                    </ext:Anchor>
                                    <ext:Anchor>
                                        <ext:TextArea ID="taPP" FieldLabel="产品定位说明" runat="server" BoxLabel="CheckBox"
                                            Width="400" />
                                    </ext:Anchor>
                                </ext:FormLayout>
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
        </Tabs>
    </ext:TabPanel>
    </form>
</body>
</html>
