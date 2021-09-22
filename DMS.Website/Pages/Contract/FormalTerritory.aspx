<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormalTerritory.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.FormalTerritory" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/PartsSelectorDialog.ascx" TagName="PartsSelectorDialog"
    TagPrefix="uc1" %>
<%@ Register Src="../../Controls/HospitalSelectorDialog.ascx" TagName="HospitalSelectorDialog"
    TagPrefix="uc1" %>
<%@ Register Src="../../Controls/HospitalSelectdDelDialog.ascx" TagName="HospitalSelectdDelDialog"
    TagPrefix="uc1" %>
<%@ Register Src="../../Controls/AuthorizationSelectorDialog.ascx" TagName="AuthSelectorDialog"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>DealerContractQuery</title>
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

    <ext:Store ID="StoreHospital" runat="server" UseIdConfirmation="false" OnRefreshData="StoreHospital_RefershData"
        AutoLoad="true">
        <AutoLoadParams>
            <ext:Parameter Name="start" Value="={0}" />
            <ext:Parameter Name="limit" Value="={15}" />
        </AutoLoadParams>
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="HospitalID">
                <Fields>
                    <ext:RecordField Name="HospitalID" />
                    <ext:RecordField Name="HospitalShortName" />
                    <ext:RecordField Name="HospitalName" />
                    <ext:RecordField Name="Grade" />
                    <ext:RecordField Name="Account" />
                    <ext:RecordField Name="Province" />
                    <ext:RecordField Name="City" />
                    <ext:RecordField Name="District" />
                    <ext:RecordField Name="Depart" />
                    <ext:RecordField Name="HosDepartTypeName" />
                    <ext:RecordField Name="DepartRemark" />
                    <ext:RecordField Name="HosRemark" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="pnlSouth" runat="server" Title="包含医院" Icon="Basket" Height="280" IDMode="Legacy">
                        <Listeners>
                            <Expand Handler="" />
                        </Listeners>
                        <Body>
                            <ext:FitLayout ID="FitLayout2" runat="server">
                                <ext:GridPanel ID="gplAuthHospital" runat="server" Title="包含医院" Header="false" AutoExpandColumn="HospitalName"
                                    StoreID="StoreHospital" Border="false" Icon="Lorry" StripeRows="true">
                                    <Buttons>
                                        <ext:Button ID="Button1" runat="server" Text="关闭" Icon="Cancel" CommandArgument=""
                                            CommandName="" IDMode="Legacy">
                                            <Listeners>
                                                <Click Fn="ClosePage" />
                                            </Listeners>
                                        </ext:Button>
                                    </Buttons>
                                    <ColumnModel ID="ColumnModel2" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Width="500" Header="医院名称">
                                            </ext:Column>
                                            <ext:Column ColumnID="Account" DataIndex="Account" Width="150" Header="医院编号">
                                            </ext:Column>
                                            <ext:Column ColumnID="Grade" DataIndex="Grade" Width="100" Header="医院等级" Hidden="true">
                                            </ext:Column>
                                            <ext:Column ColumnID="Province" DataIndex="Province" Width="100" Header="省份">
                                            </ext:Column>
                                            <ext:Column ColumnID="City" DataIndex="City" Width="100" Header="城市">
                                            </ext:Column>
                                            <ext:Column ColumnID="District" DataIndex="District" Width="100" Header="区/县" Hidden="true">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosDepartTypeName" Width="100" Header="科室类型">
                                            </ext:Column>
                                            <ext:Column DataIndex="Depart" Width="100" Header="科室名称">
                                            </ext:Column>
                                            <ext:Column Width="200" DataIndex="DepartRemark" Header="科室备注">
                                            </ext:Column>
                                            <ext:Column ColumnID="HosRemark" DataIndex="HosRemark" Width="100" Header="医院备注">
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="StoreHospital"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <LoadMask ShowMask="true" Msg="处理中..." />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
                <South Collapsible="false" Split="True" MarginsSummary="0 5 5 5">
                    <ext:Hidden runat="server" ID="hidPage">
                    </ext:Hidden>
                </South>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Hidden ID="hiddenDealer" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidDivisionID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidIsEmerging" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidPartsContractCode" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidContractId" runat="server">
    </ext:Hidden>
    </form>
</body>
</html>
