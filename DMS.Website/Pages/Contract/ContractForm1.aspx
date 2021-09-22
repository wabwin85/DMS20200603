<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractForm1.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractForm1" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .x-form-group .x-form-group-header-text
        {
            background-color: #dfe8f6 !important;
            color: Black !important;
            font-family: "微软雅黑" !important;
            font-size: 11px !important;
        }
        .x-form-group .x-form-group-header
        {
            padding: 10px !important;
            border-bottom: 2px solid #99bbe8 !important;
        }
        .x-panel-mc
        {
            font: normal 12px "微软雅黑" ,tahoma,arial,helvetica,sans-serif !important;
            font-weight: bold !important;
        }
        .labelBold
        {
            font-weight: bold !important;
        }
    </style>
</head>
<body>
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <form id="form1" runat="server">
    <ext:Hidden ID="hdContractID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdParmetType" runat="server">
    </ext:Hidden>
     <ext:Hidden ID="hdDrmPrintName" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDrmPrintDate" runat="server">
    </ext:Hidden>
    <div>
        <ext:Panel ID="btnPanel" runat="server" Header="false" Height="17">
            <TopBar>
                <ext:Toolbar ID="Toolbar1" runat="server">
                    <Items>
                        <ext:ToolbarFill />
                        <ext:Button ID="btnCreatePdf" runat="server" Text="生成IAF Form1 PDF" Icon="PageWhiteAcrobat"
                            AutoPostBack="true" OnClick="CreatePdf">
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </TopBar>
        </ext:Panel>
        <ext:Panel ID="plForm4" runat="server" Header="true" Title="Third Party Appointment / Renewal Checklist"
            Frame="true" Icon="Application" AutoHeight="true" AutoScroll="true" BodyStyle="padding:10px;"
            Collapsible="false">
            <Body>
                <ext:Panel ID="Panel46" runat="server" BodyBorder="true" BodyStyle="padding:10px;">
                    <Body>
                        <ext:Panel ID="Panel47" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout15" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel48" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout26" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfFrom1Country" runat="server" FieldLabel="Country" Width="150"
                                                            ReadOnly="true" Text="China">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfFrom1DealerName" runat="server" FieldLabel="Proposed Third Party"
                                                            Width="300" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                    </Body>
                </ext:Panel>
                <!--产品储存-->
                <ext:Panel ID="Panel50" runat="server" BodyBorder="true" AutoScroll="true" BodyStyle="padding:0px;"
                    Header="false" Frame="true" Icon="Application">
                    <Body>
                        <ext:Panel ID="Panel55" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout17" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.7">
                                        <ext:Panel ID="Panel57" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout32" runat="server" LabelWidth="670">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgConfirm1" runat="server" FieldLabel="1.	The Relationship Manager (RM) confirms completion of the Third Party Appointment/Renewal<br/> Checklist (Form 1), the Internal Approval Form (Form 2), the Third Party Disclosure Form (Form 3),<br/> the Quality Self-Assessment Checklist (Form 4), the delivery of a copy of the Conduct to the Third <br/>Party and any sub-contractors, the Anti-Corruption  Certification (Form 5), the Transacting Business<br/> with Integrity Attendance Sheet (Form 6) and Forms 1-6 sent to Corporate Third Party Management"
                                                            LabelSeparator=".">
                                                            <Items>
                                                                <ext:Radio ID="radioConfirm1Yes" runat="server" BoxLabel="Yes" ReadOnly="true" Checked="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioConfirm1No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.3">
                                        <ext:Panel ID="Panel19" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout13" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:Hidden ID="Hidden6" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel1" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.7">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="670">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgConfirm2" runat="server" FieldLabel="2.	RM is satisfied that the Third Party is qualified for the services to be performed and that there<br/> are no “red flag” issues or, alternatively, all “red flag” issues have been addressed by Regional<br/> Legal/Regional Compliance"
                                                            LabelSeparator=".">
                                                            <Items>
                                                                <ext:Radio ID="radioConfirm2Yes" runat="server" BoxLabel="Yes" Checked="true" ReadOnly="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioConfirm2No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:Hidden ID="hd" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel4" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.7">
                                        <ext:Panel ID="Panel5" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="670">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgConfirm3" runat="server" FieldLabel="3.	RM believes that the Third Party does not have any conflicts of interests involving Boston Scientific<br/> or its employees, including representation of competitive products.  If there are any, please elaborate<br/> on a separate attachment"
                                                            LabelSeparator=".">
                                                            <Items>
                                                                <ext:Radio ID="radioConfirm3Yes" runat="server" BoxLabel="Yes" Checked="true" ReadOnly="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioConfirm3No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.3">
                                        <ext:Panel ID="Panel6" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:Hidden ID="Hidden1" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel7" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.7">
                                        <ext:Panel ID="Panel8" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="670">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgConfirm4" runat="server" FieldLabel="4.	RM confirms that Third Party was not initially identified or recommended by a representative or<br/> employee of a non-U.S. government or governmental entity, such as a state-owned or controlled <br/>hospital or clinic, or any other foreign official"
                                                            LabelSeparator=".">
                                                            <Items>
                                                                <ext:Radio ID="radioConfirm4Yes" runat="server" BoxLabel="Yes" Checked="true" ReadOnly="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioConfirm4No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.3">
                                        <ext:Panel ID="Panel9" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:Hidden ID="Hidden2" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel10" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.7">
                                        <ext:Panel ID="Panel11" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="670">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgConfirm5" runat="server" FieldLabel="5.	The RM believes that the Third Party is reputable and honest and has a strong reputation for<br/> quality and honesty in the business community, that the Third Party will comply with Boston Scientific’s<br/> requirement that all product be promoted and sold only on the basis of quality, service, price and <br/>other legitimate clinical attributes, and that the Third Party understands that the payment of inducements<br/> for any purpose is strictly prohibited"
                                                            LabelSeparator=".">
                                                            <Items>
                                                                <ext:Radio ID="radioConfirm5Yes" runat="server" BoxLabel="Yes" Checked="true" ReadOnly="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioConfirm5No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.3">
                                        <ext:Panel ID="Panel12" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:Hidden ID="Hidden3" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel13" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.7">
                                        <ext:Panel ID="Panel14" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout9" runat="server" LabelWidth="670">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgConfirm6" runat="server" FieldLabel="6.	If a renewal, RM has discussed with the Dealer or Distributor the Dealer or Distributor’s<br/> sponsorship activities and any other financial arrangements with health care professionals (HCPs),<br/> including gifts, donations or other financial contributions during the course of their current agreement<br/> term and the RM has reported any sponsorship activities or other financial arrangements with HCPs<br/> he/she is aware of that are not in compliance with the requirements outlined in the Transacting Business<br/> with Integrity presentation to Global Compliance or the Legal Department"
                                                            LabelSeparator=".">
                                                            <Items>
                                                                <ext:Radio ID="radioConfirm6Yes" runat="server" BoxLabel="Yes" Checked="false" ReadOnly="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioConfirm6No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.3">
                                        <ext:Panel ID="Panel15" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:Hidden ID="Hidden4" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel16" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.7">
                                        <ext:Panel ID="Panel17" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout11" runat="server" LabelWidth="670">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgConfirm7" runat="server" FieldLabel="7.	If a renewal, RM has discussed with the Third Party the Third Party’s sales or financial arrangements<br/> with customers, sub-contractors and other third parties, including rebates, discounts and other <br/>financial arrangements that benefit the customer, sub-contractor or third party, and the RM has<br/> reported any financial arrangements he/she is aware of that are not in compliance with the requirements <br/>outlined in the Transacting Business with Integrity presentation to Global Compliance or the Legal Department"
                                                            LabelSeparator=".">
                                                            <Items>
                                                                <ext:Radio ID="radioConfirm7Yes" runat="server" BoxLabel="Yes" Checked="false" ReadOnly="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioConfirm7No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.3">
                                        <ext:Panel ID="Panel18" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout12" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:Hidden ID="hidDivision" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                    </Body>
                </ext:Panel>
            </Body>
        </ext:Panel>
    </div>
    </form>
</body>
</html>
