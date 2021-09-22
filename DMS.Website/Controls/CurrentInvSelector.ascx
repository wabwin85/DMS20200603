<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CurrentInvSelector.ascx.cs"
    Inherits="DMS.Website.Controls.CurrentInvSelector1" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
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
    .ext-ie7 .onepx-shift
    {
        top: 1px;
        position: relative;
    }
</style>
<ext:Window ID="CFNSelector" runat="server" Collapsible="true" Icon="Application"
    BodyStyle="padding:5px;" Title="Title">
    <Body>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <Center>
                        <ext:Panel ID="Panel7" runat="server" Title="Center">
                            <Body>
                                <ext:FitLayout ID="FitLayout2" runat="server">
                                    <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Height="300" TabPosition="Bottom">
                                        <Tabs>
                                            <ext:Tab ID="tabInvList" runat="server" Title="<%$ Resources: tabInvList.Title %>">
                                                <Body>
                                                </Body>
                                            </ext:Tab>
                                            <ext:Tab ID="tabCriteria" runat="server" Title="<%$ Resources: tabCriteria.Title %>">
                                                <Body>
                                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                                        <ext:Panel ID="Panel1" runat="server" Height="100" Title="<%$ Resources: Panel1.Title %>" Icon="Comments"
                                                            BodyStyle="background-color: transparent;">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                                        <ext:Panel ID="Panel2" runat="server" Height="200" BodyStyle="background-color: transparent;">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="Id" runat="server" FieldLabel="<%$ Resources: Panel2.Id.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="EnglishName" runat="server" FieldLabel="<%$ Resources: Panel2.EnglishName.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="ChineseName" runat="server" FieldLabel="<%$ Resources: Panel2.ChineseName.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:Checkbox ID="Implant" runat="server" FieldLabel="<%$ Resources: Panel2.Implant.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="CustomerFaceNbr" runat="server" FieldLabel="" Width="200" />
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                                        <ext:Panel ID="Panel3" runat="server" Height="200" BodyStyle="background-color: transparent;">
                                                                            <Body>
                                                                                <ext:FormLayout runat="server">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="ProductCatagoryPctId" runat="server" FieldLabel="<%$ Resources: Panel3.Id.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="LastUpdateDate" runat="server" FieldLabel="" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="DeletedFlag" runat="server" FieldLabel="" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="ProductLineBumId" runat="server" FieldLabel="<%$ Resources: Panel3.ProductLineBumId.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="LastUpdateUser" runat="server" FieldLabel="" Width="200" />
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                                        <ext:Panel ID="Panel4" runat="server" Height="200" BodyStyle="background-color: transparent;">
                                                                            <Body>
                                                                                <ext:FormLayout runat="server">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="Property1" runat="server" FieldLabel="<%$ Resources: Panel4.Property1.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="Property2" runat="server" FieldLabel="<%$ Resources: Panel4.Property2.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="Property3" runat="server" FieldLabel="<%$ Resources: Panel4.Property3.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="Property4" runat="server" FieldLabel="<%$ Resources: Panel4.Property4.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="Property5" runat="server" FieldLabel="<%$ Resources: Panel4.Property5.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="Property6" runat="server" FieldLabel="<%$ Resources: Panel4.Property6.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="Property7" runat="server" FieldLabel="<%$ Resources: Panel4.Property7.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="Property8" runat="server" FieldLabel="<%$ Resources: Panel4.Property8.FieldLabel %>" Width="200" />
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                </ext:ColumnLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:FitLayout>
                                                </Body>
                                            </ext:Tab>
                                            <ext:Tab ID="tabNewLot" runat="server" Title="<%$ Resources: tabNewLot.Title %>">
                                                <Body>
                                                    <ext:FormLayout runat="server" Width="500">
                                                        <ext:Anchor>
                                                            <ext:MultiField ID="MultiField1" runat="server" FieldLabel="<%$ Resources: tabNewLot.MultiField1.FieldLabel %>"  Width="700">
                                                                <Fields>
                                                                    <ext:Button ID="cmdFindCFN" runat="server" Icon="Magnifier" Flat="true" />
                                                                </Fields>
                                                            </ext:MultiField>
                                                        </ext:Anchor>
                                                        <%-- 
                                                        <ext:Anchor>
                                                            <ext:MultiField ID="MultiField2" runat="server" FieldLabel="产品">
                                                                <Fields>
                                                                    <ext:TextField ID="txtProductName" runat="server" />
                                                                    <ext:Button ID="cmdFindProduct" runat="server" Icon="Zoom" />
                                                                </Fields>
                                                            </ext:MultiField>
                                                        </ext:Anchor>
                                                        
                                                        --%>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Tab>
                                        </Tabs>
                                    </ext:TabPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </Body>
</ext:Window>
