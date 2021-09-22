<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerMaster.aspx.cs" Inherits="DMS.Website.Pages.DP.DealerMaster" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <ext:Store ID="VersionStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_VersionList"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Version">
                <Fields>
                    <ext:RecordField Name="Version" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <Load Handler="#{ddlVersion}.setValue(#{ddlVersion}.store.getTotalCount()>0?#{ddlVersion}.store.getAt(0).get('Version'):'');" />
        </Listeners>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server" AutoWidth="true" Height="450">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <West MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="大类信息" Frame="true" Icon="Information" BodyStyle="text-align:center;padding:2px;"
                        Width="120" AutoScroll="true" ButtonAlign="Center">
                        <Body>
                            <ext:FormLayout ID="FormLayout4" runat="server">
                                <ext:Anchor>
                                    <ext:LinkButton ID="Button1" runat="server" CtCls="sidebar" Width="55" Height="55" StyleSpec="padding:2px;"
                                        Hidden="true" Text="<img src='logo_BasicInfo.png'  style='border-width: 0px;width:55px;height:45px;text-align:center;' /><br/><font color='navy'><b>&nbsp常用信息&nbsp</b></font>">
                                        <AjaxEvents>
                                            <Click OnEvent="Button_Click" />
                                        </AjaxEvents>
                                    </ext:LinkButton>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:LinkButton ID="Button2" runat="server" CtCls="sidebar" Width="55" Height="55" StyleSpec="padding:2px;"
                                        Hidden="true" Text="<img src='logo_Organization.png'  style='border-width: 0px;width:55px;height:45px;text-align:center;' /><br/><font color='navy'><b>&nbsp架构发展&nbsp</b></font>">
                                        <AjaxEvents>
                                            <Click OnEvent="Button_Click" />
                                        </AjaxEvents>
                                    </ext:LinkButton>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:LinkButton ID="Button3" runat="server" CtCls="sidebar" Width="55" Height="55" StyleSpec="padding:2px;"
                                        Hidden="true" Text="<img src='logo_DandB.png'  style='border-width: 0px;width:55px;height:45px;text-align:center;' /><br/><font color='navy'><b>&nbsp邓白氏信息&nbsp</b></font>">
                                        <AjaxEvents>
                                            <Click OnEvent="Button_Click" />
                                        </AjaxEvents>
                                    </ext:LinkButton>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:LinkButton ID="Button4" runat="server" CtCls="sidebar" Width="55" Height="55" StyleSpec="padding:2px;"
                                        Hidden="true" Text="<img src='logo_Certificate.png'  style='border-width: 0px;width:55px;height:45px; text-align:center;' /><br/><font color='navy'><b>&nbsp证照信息&nbsp</b></font>">
                                        <AjaxEvents>
                                            <Click OnEvent="Button_Click" />
                                        </AjaxEvents>
                                    </ext:LinkButton>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:LinkButton ID="Button5" runat="server" CtCls="sidebar" Width="55" Height="55" StyleSpec="padding:2px;"
                                        Hidden="true" Text="<img src='logo_Rename.png'  style='border-width: 0px;width:55px;height:45px; text-align:center;' /><br/><font color='navy'><b>&nbsp更名记录&nbsp</b></font>">
                                        <AjaxEvents>
                                            <Click OnEvent="Button_Click" />
                                        </AjaxEvents>
                                    </ext:LinkButton>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:LinkButton ID="Button6" runat="server" CtCls="sidebar" Width="55" Height="55" StyleSpec="padding:2px;"
                                        Hidden="true" Text="<img src='logo_contract.png'  style='border-width: 0px;width:55px;height:45px;text-align:center;' /><br/><font color='navy'><b>&nbsp合同信息&nbsp</b></font>">
                                        <AjaxEvents>
                                            <Click OnEvent="Button_Click" />
                                        </AjaxEvents>
                                    </ext:LinkButton>
                                </ext:Anchor>
                              <%--  <ext:Anchor>
                                    <ext:LinkButton ID="Button7" runat="server" CtCls="sidebar" Width="55" Height="55" StyleSpec="padding:2px;"
                                        Hidden="true" Text="<img src='logo_KPI.png'  style='border-width: 0px;width:55px;height:45px;text-align:center;' /><br/><font color='navy'><b>&nbsp关键绩效&nbsp</b></font>">
                                        <AjaxEvents>
                                            <Click OnEvent="Button_Click" />
                                        </AjaxEvents>
                                    </ext:LinkButton>
                                </ext:Anchor>--%>
                                <ext:Anchor>
                                    <ext:LinkButton ID="Button8" runat="server" CtCls="sidebar" Width="55" Height="55" StyleSpec="padding:2px;"
                                        Hidden="true" Text="<img src='logo_course.png'  style='border-width: 0px;width:55px;height:45px;text-align:center;' /><br/><font color='navy'><b>&nbsp培训记录&nbsp</b></font>">
                                        <AjaxEvents>
                                            <Click OnEvent="Button_Click" />
                                        </AjaxEvents>
                                    </ext:LinkButton>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:LinkButton ID="Button9" runat="server" CtCls="sidebar" Width="55" Height="55" StyleSpec="padding:2px;"
                                        Hidden="true" Text="<img src='logo_award.png'  style='border-width: 0px;width:55px;height:45px;text-align:center;' /><br/><font color='navy'><b>&nbsp奖惩记录&nbsp</b></font>">
                                        <AjaxEvents>
                                            <Click OnEvent="Button_Click" />
                                        </AjaxEvents>
                                    </ext:LinkButton>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:LinkButton ID="Button10" runat="server" CtCls="sidebar" Width="55" Height="55" StyleSpec="padding:2px;"
                                        Hidden="true" Text="<img src='logo_audit.png'  style='border-width: 0px;width:55px;height:45px;text-align:center;' /><br/><font color='navy'><b>&nbsp审计记录&nbsp</b></font>">
                                        <AjaxEvents>
                                            <Click OnEvent="Button_Click" />
                                        </AjaxEvents>
                                    </ext:LinkButton>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                    </ext:Panel>
                </West>
                <Center MarginsSummary="5 5 5 5">
                    <ext:Panel ID="Panel2" runat="server" Title="" Frame="true" Header="false" Height="450">
                        <Body>
                            <ext:BorderLayout ID="BorderLayout2" runat="server">
                                <Center MarginsSummary="0 0 0 0" AutoHide="true" MaxHeight="0">
                                    <ext:Panel ID="Panel_Body" runat="server" Collapsible="true" Height="450">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                    <ext:ToolbarTextItem ID="ttiVersion" runat="server" Text="<b>常用信息-版本：</b>" />
                                                    <ext:ComboBox ID="ddlVersion" runat="server" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                        TriggerAction="All" ValueField="Version" DisplayField="Version" StoreID="VersionStore">
                                                        <Listeners>
                                                            <Select Handler="Coolite.AjaxMethods.OnSelectIndexChanged();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                 <%--   <ext:Button ID="btVersion" runat="server" Text="版本比较" Icon="Information" LabelStyle="margin-right:10px;float:right;">
                                                        <AjaxEvents>
                                                            <Click OnEvent="BtVersion_Click">
                                                                <EventMask ShowMask="true" MinDelay="250" />
                                                            </Click>
                                                        </AjaxEvents>
                                                    </ext:Button>--%>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <Body>
                                            <%--  <ext:TabPanel ID="TabPanel1" runat="server" Height="450" Border="false" BodyBorder="false">
                                                <AutoLoad Mode="IFrame" ShowMask="true" />
                                            </ext:TabPanel>--%>
                                            <ext:Panel ID="TabPanel1" runat="server" Height="450" Border="false" BodyBorder="false" BodyStyle="background-color: #D9E7F8;">
                                                <AutoLoad Mode="IFrame" ShowMask="true">
                                                </AutoLoad>
                                            </ext:Panel>
                                        </Body>
                                    </ext:Panel>
                                </Center>
                            </ext:BorderLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Hidden ID="hfDearId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hfUdstrCd" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hfParentModleID" runat="server">
    </ext:Hidden>
    <ext:Window ID="WindowComparisonConfirm" runat="server" Title="版本比较" Width="680"
        Height="450" Modal="true" Collapsible="true" Maximizable="true" ShowOnLoad="false">
        <AutoLoad Mode="IFrame">
        </AutoLoad>
    </ext:Window>
    </form>
</body>
</html>
