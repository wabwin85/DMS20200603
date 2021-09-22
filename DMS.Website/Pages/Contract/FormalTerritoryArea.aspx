<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormalTerritoryArea.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.FormalTerritoryArea" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>TerritoryArea</title>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <style type="text/css">
        .yellow-row
        {
            background: #FFD700;
        }
    </style>

    <script type="text/javascript">
        var ClosePage = function() {
            window.open('', '_self');
            window.close();
        }
    </script>

    <ext:Store ID="ExcludeHospitalStore" runat="server" UseIdConfirmation="false" OnRefreshData="ExcludeHospitalStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="HosId">
                <Fields>
                    <ext:RecordField Name="HosHospitalName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="AreaStore" runat="server" UseIdConfirmation="false" OnRefreshData="AreaStore_OnRefreshData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="TerId">
                <Fields>
                    <ext:RecordField Name="Description" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="pnlCenter" runat="server" Title="授权区域" Icon="Basket" IDMode="Legacy"
                        AutoScroll="true">
                        <Listeners>
                            <Expand Handler="" />
                        </Listeners>
                        <Body>
                            <ext:FitLayout ID="FitLayout2" runat="server">
                                <ext:GridPanel ID="gpArea" runat="server" Title="授权区域" Header="false" AutoExpandColumn="Description"
                                    StoreID="AreaStore" Border="false" Icon="Lorry" StripeRows="true">
                                    <ColumnModel ID="ColumnModel2" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="Description" DataIndex="Description" Header="区域名称">
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <LoadMask ShowMask="true" Msg="处理中..." />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
                <South Collapsible="true" Split="True" MarginsSummary="0 5 5 5">
                    <ext:Panel ID="pnlSouth" runat="server" Title="区域内排除医院" Icon="Basket" Height="300"
                        AutoScroll="true" IDMode="Legacy">
                        <Listeners>
                            <Expand Handler="" />
                        </Listeners>
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="gpExcludeHospital" runat="server" Title="区域内排除医院" Header="false"
                                    AutoExpandColumn="HosHospitalName" StoreID="ExcludeHospitalStore" Border="false"
                                    Icon="Lorry" StripeRows="true">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="医院名称">
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <LoadMask ShowMask="true" Msg="处理中..." />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="Button1" runat="server" Text="关闭" Icon="Cancel" CommandArgument=""
                                CommandName="" IDMode="Legacy">
                                <Listeners>
                                    <Click Fn="ClosePage" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </South>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Hidden ID="hdDmaId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDivisionId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdSubDepCode" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidContractId" runat="server">
    </ext:Hidden>
    </form>
</body>
</html>
