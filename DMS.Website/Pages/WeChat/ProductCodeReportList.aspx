<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductCodeReportList.aspx.cs"
    Inherits="DMS.Website.Pages.WeChat.ProductCodeReportList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>唯一码举报</title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

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
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <div id="DivStore">
        <ext:Store ID="StoReportList" runat="server" UseIdConfirmation="false" OnRefreshData="StoReportList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="ReportId">
                    <Fields>
                        <ext:RecordField Name="ReportId" />
                        <ext:RecordField Name="ReportContact" />
                        <ext:RecordField Name="ReportContent" />
                        <ext:RecordField Name="ScanResult" />
                        <ext:RecordField Name="ProductImage" />
                        <ext:RecordField Name="ProductImageUrl" />
                        <ext:RecordField Name="AddressImage" />
                        <ext:RecordField Name="AddressImageUrl" />
                        <ext:RecordField Name="ReportTime" />
                        <ext:RecordField Name="ReportUser" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
    </div>
    <div id="DivHidden">
        <ext:Hidden ID="IptReportId" runat="server">
        </ext:Hidden>
    </div>
    <div id="DivView">
        <ext:ViewPort ID="WdwMain" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="QryReportContent" runat="server" Width="150" FieldLabel="举报内容">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="QryReportContact" runat="server" Width="150" FieldLabel="举报人联系方式">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="BtnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagReportList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="RstReportList" runat="server" Title="查询结果" StoreID="StoReportList"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ReportContact" DataIndex="ReportContact" Header="举报人联系方式" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="ReportContent" DataIndex="ReportContent" Header="举报内容" Width="400">
                                                </ext:Column>
                                                <ext:Column ColumnID="ReportTime" DataIndex="ReportTime" Header="举报时间" Width="150">
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="明细" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="明细" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagReportList" runat="server" PageSize="15" StoreID="StoReportList"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </BottomBar>
                                        <Listeners>
                                            <Command Handler="
                                                if (command == 'Edit') {
                                                    Coolite.AjaxMethods.ShowReportInfo(
                                                        record.data.ReportId,
                                                        {
                                                            success: function() {
                                                                #{WdwReportInfo}.show();
                                                            },
                                                            failure: function(err) {
                                                                Ext.Msg.alert('Error', err);
                                                            }
                                                        }
                                                    );
                                                }
                                            " />
                                        </Listeners>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Window ID="WdwReportInfo" runat="server" Icon="Group" Title="唯一码举报" Resizable="false"
            Header="false" Width="390" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout9" runat="server">
                    <ext:Anchor>
                        <ext:Panel ID="Panel27" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel28" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:Label runat="server" ID="IptReportContent" FieldLabel="举报内容">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="IptReportContact" runat="server" FieldLabel="举报人联系方式">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="IptReportTime" runat="server" FieldLabel="举报时间">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:HyperLink ID="IptScanResult" runat="server" Target="Blank" FieldLabel="查询结果" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:HyperLink ID="IptProductImage" runat="server" Target="Blank" FieldLabel="实物照片" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:HyperLink ID="IptAddressImage" runat="server" Target="Blank" FieldLabel="地点照片" />
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
            <Buttons>
                <ext:Button ID="BtnBack" runat="server" Text="返回" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{WdwReportInfo}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
    </div>
    </form>
</body>
</html>
