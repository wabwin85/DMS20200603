<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UsageStatistics.aspx.cs"
    Inherits="DMS.Website.Pages.WeChat.UsageStatistics" %>

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
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Store ID="ResultStore" runat="server" AutoLoad="false" OnRefreshData="ResultStore_RefreshData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Documentnumber" />
                        <ext:RecordField Name="Status" />
                        <ext:RecordField Name="UserName" />
                        <ext:RecordField Name="DealerName" />
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
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:Panel ID="Panel1" runat="server">
                                        <Body>
                                            <ext:RowLayout ID="RowLayout" runat="server">
                                                <ext:LayoutRow>
                                                    <ext:Panel ID="Panel4" runat="server" Header="true" Title="微信使用频率" Frame="true" AutoHeight="true"
                                                        Icon="Find" Collapsible="true">
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                                <ext:LayoutColumn ColumnWidth=".3">
                                                                    <ext:Panel ID="Panel5" runat="server" Border="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout2" runat="server">
                                                                                <ext:Anchor>
                                                                                    <ext:DateField ID="startDate" runat="server" Width="180" FieldLabel="开始操作时间">
                                                                                    </ext:DateField>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".3">
                                                                    <ext:Panel ID="Panel6" runat="server" Border="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout4" runat="server">
                                                                                <ext:Anchor>
                                                                                    <ext:DateField ID="endDate" runat="server" Width="180" FieldLabel="最后操作时间">
                                                                                    </ext:DateField>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                            </ext:ColumnLayout>
                                                        </Body>
                                                        <Buttons>
                                                            <ext:Button ID="btnDownloadWechatInfo" Text="导出" Height="50" Width="150" runat="server"
                                                                Icon="PageExcel" IDMode="Legacy" AutoPostBack="true" OnClick="DownloadInfo">
                                                                <%-- <Listeners>
                                    <Click Handler="Coolite.AjaxMethods.DownloadInfo()" />
                                    </Listeners>--%>
                                                            </ext:Button>
                                                        </Buttons>
                                                    </ext:Panel>
                                                </ext:LayoutRow>
                                                <ext:LayoutRow>
                                                    <ext:Label ID="lb" runat="server" Text="&nbsp;"></ext:Label>
                                                </ext:LayoutRow>
                                                <ext:LayoutRow>
                                                    <ext:Panel ID="Panel2" runat="server" Header="true" Title="微信注册情况" Frame="true" AutoHeight="true"
                                                        Icon="Find" Collapsible="true">
                                                        <Buttons>
                                                            <ext:Button ID="btnDownloadWechatRegister" Text="导出" Height="50" Width="150" runat="server" Icon="PageExcel"
                                                                IDMode="Legacy" AutoPostBack="true" OnClick="DownloadRegister">
                                                                <%-- <Listeners>
                                    <Click Handler="Coolite.AjaxMethods.DownloadInfo()" />
                                    </Listeners>--%>
                                                            </ext:Button>
                                                        </Buttons>
                                                    </ext:Panel>
                                                </ext:LayoutRow>
                                            </ext:RowLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </div>
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
