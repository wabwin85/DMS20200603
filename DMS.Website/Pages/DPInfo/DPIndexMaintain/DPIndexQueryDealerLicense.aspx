<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DPIndexQueryDealerLicense.aspx.cs"
    Inherits="DMS.Website.Pages.DPInfo.DPIndexMaintain.DPIndexQueryDealerLicense" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        .list-item
        {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
            padding: 3px 10px 3px 10px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #555;
        }
        .list-item h3
        {
            display: block;
            font: inherit;
            font-weight: bold;
            color: #222;
        }
        .x-form-empty-field
        {
            color: #bbbbbb;
            font: normal 11px arial, tahoma, helvetica, sans-serif;
        }
        .x-small-editor .x-form-field
        {
            font: normal 11px arial, tahoma, helvetica, sans-serif;
        }
        .x-small-editor .x-form-text
        {
            height: 20px;
            line-height: 16px;
            vertical-align: middle;
        }
        .editable-column
        {
            background: #FFFF99;
        }
        .nonEditable-column
        {
            background: #FFFFFF;
        }
        .yellow-row
        {
            background: #FFD700;
        }
        .lightyellow-row
        {
            background: #FFFFD8;
        }
        .x-panel-body
        {
            background-color: #dfe8f6;
        }
        .x-column-inner
        {
            height: auto !important;
            width: auto !important;
        }
        .list-item
        {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
            padding: 3px 10px 3px 10px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #555;
        }
    </style>
</head>
<body>

    <script src="../../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
        //触发函数
        function downloadfile(url) {
            var iframe = document.createElement("iframe");
            iframe.src = url;
            iframe.style.display = "none";
            document.body.appendChild(iframe);
        }   
    </script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
    </div>
    <ext:Hidden ID="hidDealerId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidCurSecondClassCatagory" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidCurThirdClassCatagory" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenFileName" runat="server">
    </ext:Hidden>
    <ext:Store ID="CurSecondClassCatagoryStore" runat="server">
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="CatagoryID" />
                    <ext:RecordField Name="CatagoryName" />
                    <ext:RecordField Name="CatagoryType" />
                    <ext:RecordField Name="CatagoryStatus" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="CatagoryID" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="CurThirdClassCatagoryStore" runat="server">
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="CatagoryID" />
                    <ext:RecordField Name="CatagoryName" />
                    <ext:RecordField Name="CatagoryType" />
                    <ext:RecordField Name="CatagoryStatus" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="CatagoryID" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="CurAttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="false"
        OnRefreshData="CurAttachmentStore_Refresh">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Attachment" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Url" />
                    <ext:RecordField Name="Type" />
                    <ext:RecordField Name="UploadUser" />
                    <ext:RecordField Name="Identity_Name" />
                    <ext:RecordField Name="UploadDate" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <Center>
                    <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server" Split="true" FitHeight="true">
                                <Columns>
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="WestPanel" runat="server" Title="当前CFDA证照信息" BodyStyle="padding: 5px;"
                                            Frame="false" AutoScroll="true">
                                            <Body>
                                                <ext:RowLayout ID="RowLayoutTop" runat="server">
                                                    <ext:LayoutRow>
                                                        <ext:Panel ID="Panel3" runat="server" Header="false" BodyBorder="false" BodyStyle="padding-right:6px;">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout2" runat="server" Split="true">
                                                                    <Columns>
                                                                        <ext:LayoutColumn ColumnWidth="0.5">
                                                                            <ext:Panel ID="Panel1" runat="server" Header="false" BodyBorder="false" Height="120">
                                                                                <Body>
                                                                                    <ext:FieldSet ID="FieldSetCurLicense" runat="server" Header="true" Frame="false"
                                                                                        BodyBorder="true" AutoHeight="true" AutoWidth="true" Title="医疗器械经营许可证信息">
                                                                                        <Body>
                                                                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="100">
                                                                                                <ext:Anchor>
                                                                                                    <ext:TextField ID="CurLicenseNo" runat="server" FieldLabel="证件编号" Width="120" ReadOnly="true" />
                                                                                                </ext:Anchor>
                                                                                                <ext:Anchor>
                                                                                                    <ext:TextField ID="CurLicenseNoValidFrom" runat="server" Width="120" FieldLabel="起始日期" ReadOnly="true" />
                                                                                                </ext:Anchor>
                                                                                                <ext:Anchor>
                                                                                                    <ext:TextField ID="CurLicenseNoValidTo" runat="server" Width="120" FieldLabel="结束日期" ReadOnly="true" />
                                                                                                </ext:Anchor>
                                                                                            </ext:FormLayout>
                                                                                        </Body>
                                                                                    </ext:FieldSet>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth="0.5">
                                                                            <ext:Panel ID="Panel2" runat="server" Header="false" BodyBorder="false" Height="120">
                                                                                <Body>
                                                                                    <ext:FieldSet ID="FieldSetCurFiling" runat="server" Header="true" Frame="false" BodyBorder="true"
                                                                                        AutoHeight="true" AutoWidth="true" Title="医疗器械备案凭证信息">
                                                                                        <Body>
                                                                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="100">
                                                                                                <ext:Anchor>
                                                                                                    <ext:TextField ID="CurFilingNo" runat="server" FieldLabel="证件编号" Width="120" ReadOnly="true" />
                                                                                                </ext:Anchor>
                                                                                                <ext:Anchor>
                                                                                                    <ext:TextField ID="CurFilingNoValidFrom" runat="server" FieldLabel="起始日期" Width="120" ReadOnly="true" />
                                                                                                </ext:Anchor>
                                                                                                <ext:Anchor>
                                                                                                    <ext:TextField ID="CurFilingNoValidTo" runat="server" FieldLabel="结束日期" Width="120" ReadOnly="true" />
                                                                                                </ext:Anchor>
                                                                                            </ext:FormLayout>
                                                                                        </Body>
                                                                                    </ext:FieldSet>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                    </Columns>
                                                                </ext:ColumnLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutRow>
                                                    <ext:LayoutRow>
                                                        <ext:Panel ID="Panel67" runat="server" Border="false" Header="false" BodyStyle="padding-right:10px;">
                                                            <Body>
                                                                <ext:FitLayout ID="ftCurLevel3" runat="server">
                                                                    <ext:GridPanel ID="gpCurSecondClassCatagory" runat="server" Title="二类医疗器械分类代码" StoreID="CurSecondClassCatagoryStore"
                                                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="true" Header="false"
                                                                        Icon="Lorry" Height="150" AutoWidth="true">
                                                                        <TopBar>
                                                                            <ext:Toolbar ID="Toolbar3" runat="server">
                                                                                <Items>
                                                                                    <ext:Label ID="Label1" runat="server" Text="二类医疗器械产品分类代码" Icon="Lorry" />
                                                                                    <ext:ToolbarFill ID="ToolbarFill3" runat="server" />
                                                                                </Items>
                                                                            </ext:Toolbar>
                                                                        </TopBar>
                                                                        <ColumnModel ID="ColumnModel1" runat="server">
                                                                            <Columns>
                                                                                <ext:Column ColumnID="CurCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="100">
                                                                                </ext:Column>
                                                                                <ext:Column ColumnID="CurCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                                                                </ext:Column>
                                                                                <ext:Column ColumnID="CurCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="100">
                                                                                </ext:Column>
                                                                            </Columns>
                                                                        </ColumnModel>
                                                                        <SelectionModel>
                                                                            <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server"
                                                                                MoveEditorOnEnter="true">
                                                                            </ext:RowSelectionModel>
                                                                        </SelectionModel>
                                                                        <%--  <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="50" StoreID="CurSecondClassCatagoryStore" DisplayInfo="true" />
                                                    </BottomBar>--%>
                                                                        <SaveMask ShowMask="false" />
                                                                        <LoadMask ShowMask="true" />
                                                                    </ext:GridPanel>
                                                                </ext:FitLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutRow>
                                                    <ext:LayoutRow>
                                                        <ext:Panel ID="Panel4" runat="server" Border="false" Header="false" BodyStyle="padding-right:10px;padding-top:5px;">
                                                            <Body>
                                                                <ext:FitLayout ID="FitLayout1" runat="server">
                                                                    <ext:GridPanel ID="gpCurThirdClassCatagory" runat="server" Title="三类医疗器械产品分类代码" StoreID="CurThirdClassCatagoryStore"
                                                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="true" Header="false"
                                                                        Icon="Lorry" Height="150" AutoWidth="true">
                                                                        <TopBar>
                                                                            <ext:Toolbar ID="Toolbar4" runat="server">
                                                                                <Items>
                                                                                    <ext:Label ID="Label2" runat="server" Text="三类医疗器械产品分类代码" Icon="Lorry" />
                                                                                    <ext:ToolbarFill ID="ToolbarFill4" runat="server" />
                                                                                </Items>
                                                                            </ext:Toolbar>
                                                                        </TopBar>
                                                                        <ColumnModel ID="ColumnModel2" runat="server">
                                                                            <Columns>
                                                                                <ext:Column ColumnID="CurCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="100">
                                                                                </ext:Column>
                                                                                <ext:Column ColumnID="CurCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                                                                </ext:Column>
                                                                                <ext:Column ColumnID="CurCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="100">
                                                                                </ext:Column>
                                                                            </Columns>
                                                                        </ColumnModel>
                                                                        <SelectionModel>
                                                                            <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                                                MoveEditorOnEnter="true">
                                                                            </ext:RowSelectionModel>
                                                                        </SelectionModel>
                                                                        <%-- <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar3"  runat="server" PageSize="50" StoreID="CurThirdClassCatagoryStore" DisplayInfo="true" />
                                                    </BottomBar>--%>
                                                                        <SaveMask ShowMask="false" />
                                                                        <LoadMask ShowMask="true" />
                                                                    </ext:GridPanel>
                                                                </ext:FitLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutRow>
                                                    <ext:LayoutRow>
                                                        <ext:Panel ID="Panel10" runat="server" Border="false" Header="false" BodyStyle="padding-right:10px;padding-top:5px;">
                                                            <Body>
                                                                <ext:FitLayout ID="FitLayout4" runat="server">
                                                                    <ext:GridPanel ID="gpCurAttachmentDonwload" runat="server" Title="附件列表" StoreID="CurAttachmentStore"
                                                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="true" Header="false"
                                                                        Icon="Lorry" Height="150" AutoWidth="true">
                                                                        <TopBar>
                                                                            <ext:Toolbar ID="Toolbar5" runat="server">
                                                                                <Items>
                                                                                    <ext:Label ID="Label3" runat="server" Text="附件列表" Icon="Lorry" />
                                                                                    <ext:ToolbarFill ID="ToolbarFill5" runat="server" />
                                                                                </Items>
                                                                            </ext:Toolbar>
                                                                        </TopBar>
                                                                        <ColumnModel ID="ColumnModel6" runat="server">
                                                                            <Columns>
                                                                                <ext:Column ColumnID="Name" DataIndex="Name" Header="附件名称">
                                                                                </ext:Column>
                                                                                <ext:Column ColumnID="Url" DataIndex="Url" Header="路径" Hidden="true" Width="200">
                                                                                </ext:Column>
                                                                                <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="上传人" Width="200">
                                                                                </ext:Column>
                                                                                <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="上传时间" Width="100">
                                                                                </ext:Column>
                                                                                <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                                                    <Commands>
                                                                                        <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad" ToolTip-Text="下载" />
                                                                                    </Commands>
                                                                                </ext:CommandColumn>
                                                                            </Columns>
                                                                        </ColumnModel>
                                                                        <SelectionModel>
                                                                            <ext:RowSelectionModel ID="RowSelectionModel5" SingleSelect="true" runat="server"
                                                                                MoveEditorOnEnter="true">
                                                                            </ext:RowSelectionModel>
                                                                        </SelectionModel>
                                                                        <BottomBar>
                                                                            <ext:PagingToolbar ID="PagingToolBarCurAttachement" runat="server" PageSize="100"
                                                                                StoreID="CurAttachmentStore" DisplayInfo="false" />
                                                                        </BottomBar>
                                                                        <SaveMask ShowMask="false" />
                                                                        <LoadMask ShowMask="true" />
                                                                        <Listeners>
                                                                            <Command Handler="if (command == 'DownLoad')
                                                                            {
                                                                                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=DealerLicense';
                                                                                downloadfile(url);                                                                                
                                                                            }" />
                                                                        </Listeners>
                                                                    </ext:GridPanel>
                                                                </ext:FitLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutRow>
                                                </ext:RowLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </Columns>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
