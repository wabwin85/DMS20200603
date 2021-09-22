<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractAppendix4.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractAppendix4" %>

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
            background-color: #dfe8f6;
            color: Black;
        }
        .x-form-group .x-form-group-header
        {
            padding: 10px;
            border-bottom: 2px solid #99bbe8;
        }
    </style>
</head>
<body>
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <form id="form1" runat="server">
    <ext:Hidden ID="hdContractID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdCmID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDealerType" runat="server">
    </ext:Hidden>
    <div>
        <ext:Panel ID="btnPanel" runat="server" Header="false" Height="17">
            <TopBar>
                <ext:Toolbar ID="Toolbar1" runat="server">
                    <Items>
                        <ext:ToolbarFill />
                        <ext:Button ID="btnCreatePdf" runat="server" Text="生成Appendix4 PDF" Icon="PageWhiteAcrobat"
                            AutoPostBack="true" OnClick="CreatePdf">
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </TopBar>
        </ext:Panel>
        <ext:Panel ID="plAppendix1" runat="server" Header="true" Title="For Requestor:   Please Complete Section 1 - 3"
            Frame="true" Icon="Application" AutoHeight="true" AutoScroll="true" Collapsible="true"
            BodyStyle="padding:10px;">
            <Body>
                <ext:Panel ID="Panel20" runat="server" FormGroup="true" BodyBorder="true" Title="1. Division">
                    <Body>
                        <ext:Panel ID="Panel3" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.33">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="150">
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:RadioGroup ID="rgDivision" runat="server" FieldLabel="Division">
                                                            <Items>
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:Label ID="laSubBU" runat="server" FieldLabel="Sub BU">
                                                        </ext:Label>
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
                <ext:Panel ID="Panel9" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="2.  Basic Information of the Current Agreement:">
                    <Body>
                        <ext:Panel ID="Panel6" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel7" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="160">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfDealerName" runat="server" FieldLabel="Dealer Name" Width="300"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel8" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel11" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="160">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="dfAgreeEffectiveDate" runat="server" Width="120" FieldLabel="Agreement Effective Date"
                                                            Enabled="false" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel12" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelWidth="180">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="dfTermExpirationDate" runat="server" Width="120" FieldLabel="Effective Date of Termination"
                                                            Enabled="false" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".4">
                                        <ext:Panel ID="Panel16" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="140">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="RadioGroup1" runat="server" FieldLabel="Please choose one" Width="190">
                                                            <Items>
                                                                <ext:Radio ID="radioNonRenewal" runat="server" BoxLabel="Non-Renewal" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioTermination" runat="server" BoxLabel="Termination" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
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
                <ext:Panel ID="Panel18" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="3.  Reasons for Non-Renewal/Terminations: (please check all that apply)">
                    <Body>
                        <ext:Panel ID="Panel5" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel10" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:Checkbox ID="cbAccounts" runat="server" BoxLabel=" Accounts Receivable Issues"
                                                            HideLabel="true" ReadOnly="true">
                                                        </ext:Checkbox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Checkbox ID="cbOthers" runat="server" BoxLabel=" Others  (please explain):"
                                                            HideLabel="true" ReadOnly="true">
                                                        </ext:Checkbox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel13" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="170">
                                                    <ext:Anchor>
                                                        <ext:Checkbox ID="cbNoQuota" runat="server" BoxLabel="Not Meeting Quota" HideLabel="true"
                                                            ReadOnly="true">
                                                        </ext:Checkbox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfOtherReasons" runat="server" HideLabel="true" Width="200" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".4">
                                        <ext:Panel ID="Panel14" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="130">
                                                    <ext:Anchor>
                                                        <ext:Checkbox ID="cbPlDis" runat="server" BoxLabel="Product Line Discontinued" HideLabel="true"
                                                            ReadOnly="true">
                                                        </ext:Checkbox>
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
                <ext:Panel ID="Panel2" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="4.  Current Status of the Dealer">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".7">
                                <ext:Panel ID="Panel" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server">
                                            <ext:Anchor>
                                                <ext:Panel runat="server" ID="Panelset">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout13" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel15" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout25" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="rgPendingTender" runat="server" Width="260" FieldLabel="(1) Is there any pending tender issues with this dealer (if yes, please specify)"
                                                                                    LabelSeparator="?">
                                                                                    <Items>
                                                                                        <ext:Radio ID="radioPendingTenderYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                                            ReadOnly="true" />
                                                                                        <ext:Radio ID="radioPendingTenderNo" runat="server" BoxLabel="No" Checked="false"
                                                                                            ReadOnly="true" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel55" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout26" runat="server" LabelWidth="180">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfPendingTenderRemark" Width="250" runat="server" FieldLabel="Remarks"
                                                                                    ReadOnly="true">
                                                                                </ext:TextField>
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
                                                <ext:Panel runat="server" ID="Panel4">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout14" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel41" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout17" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="rgRebate" runat="server" FieldLabel="(2) Dealer Sales Rebate (CNY, inc. VAT)"
                                                                                    LabelSeparator="" Width="260">
                                                                                    <Items>
                                                                                        <ext:Radio ID="radioRebateReplacement" runat="server" BoxLabel="Exchange product"
                                                                                            Checked="false" ReadOnly="true" />
                                                                                        <ext:Radio ID="radioRebateReturn" runat="server" BoxLabel="Refund" Checked="false"
                                                                                            ReadOnly="true" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel42" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout18" runat="server" LabelWidth="180">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfRebateAmount" runat="server" FieldLabel="Sales Rebate Amount"
                                                                                    ReadOnly="true">
                                                                                </ext:TextField>
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
                                                <ext:Panel runat="server" ID="Panel43">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout15" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel44" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout19" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="rgPromotion" runat="server" FieldLabel="(3) Dealer Sales Promotion (CNY, inc. VAT)"
                                                                                    LabelSeparator="" Width="260">
                                                                                    <Items>
                                                                                        <ext:Radio ID="radioPromotionReplacement" runat="server" BoxLabel="Exchange product"
                                                                                            Checked="false" ReadOnly="true" />
                                                                                        <ext:Radio ID="radioPromotionReturn" runat="server" BoxLabel="Refund" Checked="false"
                                                                                            ReadOnly="true" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel45" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout20" runat="server" LabelWidth="180">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfPromotionAmount" runat="server" FieldLabel="Sales Promotion Amount"
                                                                                    ReadOnly="true">
                                                                                </ext:TextField>
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
                                                <ext:Panel runat="server" ID="Panel46">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout16" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel47" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout21" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="reComplaint" runat="server" FieldLabel="(4) Dealer Complance Goods Return (CNY, inc. VAT)"
                                                                                    LabelSeparator="" Width="260">
                                                                                    <Items>
                                                                                        <ext:Radio ID="radioComplaintReplacement" runat="server" BoxLabel="Exchange product"
                                                                                            Checked="false" ReadOnly="true" />
                                                                                        <ext:Radio ID="radioComplaintReturn" runat="server" BoxLabel="Refund" Checked="false"
                                                                                            ReadOnly="true" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel48" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout22" runat="server" LabelWidth="180">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfComplaintAmount" runat="server" FieldLabel="Complaint Goods Return and exchange"
                                                                                    ReadOnly="true" LabelSeparator="">
                                                                                </ext:TextField>
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
                                                <ext:Panel runat="server" ID="Panel49">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout17" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel50" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout23" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="rgTermRetn" runat="server" FieldLabel="(5) Goods Return After Temination"
                                                                                    LabelSeparator="" Width="260">
                                                                                    <Items>
                                                                                        <ext:Radio ID="radioTermRetnYes" runat="server" BoxLabel="Yes" Checked="false" ReadOnly="true" />
                                                                                        <ext:Radio ID="radioTermRetnNo" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:Panel runat="server">
                                                                                    <Body>
                                                                                        <ext:FormLayout ID="FormLayout27" runat="server">
                                                                                            <ext:Anchor>
                                                                                                <ext:RadioGroup ID="rgTermRetnReason" runat="server" FieldLabel="Goods Return Reason"
                                                                                                    HideLabel="true">
                                                                                                    <Items>
                                                                                                        <ext:Radio ID="radioTermRetnReason1" runat="server" BoxLabel="Long Expiry Products (over 6 months)"
                                                                                                            Width="50" Checked="false" ReadOnly="true" />
                                                                                                        <ext:Radio ID="radioTermRetnReason2" runat="server" BoxLabel="Short Expiry Products"
                                                                                                            Checked="false" Width="20" ReadOnly="true" />
                                                                                                        <ext:Radio ID="radioTermRetnReason3" runat="server" BoxLabel="Expired & Damaged Products"
                                                                                                            Checked="false" Width="30" ReadOnly="true" />
                                                                                                    </Items>
                                                                                                </ext:RadioGroup>
                                                                                            </ext:Anchor>
                                                                                        </ext:FormLayout>
                                                                                    </Body>
                                                                                </ext:Panel>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel51" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="180">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfTermRetnAmount" runat="server" FieldLabel="Goods return amount"
                                                                                    ReadOnly="true">
                                                                                </ext:TextField>
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
                                                <ext:Panel runat="server" ID="Panel52">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout18" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel53" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout28" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="rgScarletLetter" runat="server" FieldLabel="(6) Is the dealer certified to issue Red-piao notice from local tax bureau <br/> during the coming termination period?"
                                                                                    LabelSeparator="" Width="260">
                                                                                    <Items>
                                                                                        <ext:Radio ID="radioScarletLetterYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                                            ReadOnly="true" />
                                                                                        <ext:Radio ID="radioScarletLetterNo" runat="server" BoxLabel="No" Checked="false"
                                                                                            ReadOnly="true" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel54" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout29" runat="server" LabelWidth="180">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfScarletLetterRemark" runat="server" FieldLabel="Remarks" ReadOnly="true">
                                                                                </ext:TextField>
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
                                                <ext:Panel runat="server" ID="Panel56">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout19" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel57" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout30" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="rgDisputeMoney" runat="server" FieldLabel="(7) Any pending payment to the dealer?"
                                                                                    LabelSeparator="" Width="260">
                                                                                    <Items>
                                                                                        <ext:Radio ID="radioDisputeMoneyYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                                            ReadOnly="true" />
                                                                                        <ext:Radio ID="radioDisputeMoneyNo" runat="server" BoxLabel="No" Checked="false"
                                                                                            ReadOnly="true" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:Panel ID="Panel59" runat="server">
                                                                                    <Body>
                                                                                        <ext:FormLayout ID="FormLayout32" runat="server">
                                                                                            <ext:Anchor>
                                                                                                <ext:TextField ID="tfDisputeMoneyReason" runat="server" FieldLabel="Reason" ReadOnly="true"
                                                                                                    Width="400">
                                                                                                </ext:TextField>
                                                                                            </ext:Anchor>
                                                                                        </ext:FormLayout>
                                                                                    </Body>
                                                                                </ext:Panel>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel58" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout31" runat="server" LabelWidth="180">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfDisputeMoneyAmount" runat="server" FieldLabel="Amount" ReadOnly="true">
                                                                                </ext:TextField>
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
                                                <ext:Panel runat="server" ID="Panel60">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout20" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel61" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout33" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfCurrentAR" runat="server" FieldLabel="(8) Current A/R balance of the dealer (CNY, inc. VAT)"
                                                                                    ReadOnly="true">
                                                                                </ext:TextField>
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
                                                <ext:Panel runat="server" ID="Panel62">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout21" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel63" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout34" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:Label runat="server" ID="CashDepositLabel" HideLabel="true" Text="(9) Does the dealer have a security deposit with BSC">
                                                                                </ext:Label>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:Panel runat="server" ID="Panel64">
                                                                                    <Body>
                                                                                        <ext:ColumnLayout ID="ColumnLayout22" runat="server">
                                                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                                                <ext:Panel ID="Panel65" runat="server" Border="false">
                                                                                                    <Body>
                                                                                                        <ext:FormLayout ID="FormLayout35" runat="server" LabelWidth="150">
                                                                                                            <ext:Anchor>
                                                                                                                <ext:Panel runat="server" ID="Panel66">
                                                                                                                    <Body>
                                                                                                                        <ext:ColumnLayout ID="ColumnLayout23" runat="server">
                                                                                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                                                                                <ext:Panel ID="Panel67" runat="server" Border="false">
                                                                                                                                    <Body>
                                                                                                                                        <ext:FormLayout ID="FormLayout36" runat="server" LabelWidth="150">
                                                                                                                                            <ext:Anchor>
                                                                                                                                                <ext:RadioGroup ID="rgCashDeposit" runat="server" FieldLabel="Cash Deposit" LabelSeparator=""
                                                                                                                                                    Width="130">
                                                                                                                                                    <Items>
                                                                                                                                                        <ext:Radio ID="radioCashDepositYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                                                                                                            ReadOnly="true" />
                                                                                                                                                        <ext:Radio ID="radioCashDepositNo" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                                                                                                                    </Items>
                                                                                                                                                </ext:RadioGroup>
                                                                                                                                            </ext:Anchor>
                                                                                                                                        </ext:FormLayout>
                                                                                                                                    </Body>
                                                                                                                                </ext:Panel>
                                                                                                                            </ext:LayoutColumn>
                                                                                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                                                                                <ext:Panel ID="Panel68" runat="server" Border="false">
                                                                                                                                    <Body>
                                                                                                                                        <ext:FormLayout ID="FormLayout37" runat="server">
                                                                                                                                            <ext:Anchor>
                                                                                                                                                <ext:TextField ID="tfCashDepositAmount" runat="server" FieldLabel="Amount" ReadOnly="true">
                                                                                                                                                </ext:TextField>
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
                                                                                                                <ext:Panel runat="server" ID="Panel69">
                                                                                                                    <Body>
                                                                                                                        <ext:ColumnLayout ID="ColumnLayout25" runat="server">
                                                                                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                                                                                <ext:Panel ID="Panel70" runat="server" Border="false">
                                                                                                                                    <Body>
                                                                                                                                        <ext:FormLayout ID="FormLayout38" runat="server" LabelWidth="150">
                                                                                                                                            <ext:Anchor>
                                                                                                                                                <ext:RadioGroup ID="rgCGuarantee" runat="server" FieldLabel="Campany Guarantee" LabelSeparator=""
                                                                                                                                                    Width="130">
                                                                                                                                                    <Items>
                                                                                                                                                        <ext:Radio ID="radioCGuaranteeYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                                                                                                            ReadOnly="true" />
                                                                                                                                                        <ext:Radio ID="radioCGuaranteeNo" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                                                                                                                    </Items>
                                                                                                                                                </ext:RadioGroup>
                                                                                                                                            </ext:Anchor>
                                                                                                                                        </ext:FormLayout>
                                                                                                                                    </Body>
                                                                                                                                </ext:Panel>
                                                                                                                            </ext:LayoutColumn>
                                                                                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                                                                                <ext:Panel ID="Panel75" runat="server" Border="false">
                                                                                                                                    <Body>
                                                                                                                                        <ext:FormLayout ID="FormLayout39" runat="server">
                                                                                                                                            <ext:Anchor>
                                                                                                                                                <ext:TextField ID="tfCGuaranteeAmount" runat="server" FieldLabel="Amount" ReadOnly="true">
                                                                                                                                                </ext:TextField>
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
                                                                                            </ext:LayoutColumn>
                                                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                                                <ext:Panel ID="Panel71" runat="server" Border="false">
                                                                                                    <Body>
                                                                                                        <ext:FormLayout ID="FormLayout40" runat="server" LabelWidth="190">
                                                                                                            <ext:Anchor>
                                                                                                                <ext:Panel runat="server" ID="Panel72">
                                                                                                                    <Body>
                                                                                                                        <ext:ColumnLayout ID="ColumnLayout24" runat="server">
                                                                                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                                                                                <ext:Panel ID="Panel73" runat="server" Border="false">
                                                                                                                                    <Body>
                                                                                                                                        <ext:FormLayout ID="FormLayout41" runat="server" LabelWidth="150">
                                                                                                                                            <ext:Anchor>
                                                                                                                                                <ext:RadioGroup ID="rgBGuarantee" runat="server" FieldLabel="Bank Guarantee" LabelSeparator=""
                                                                                                                                                    Width="130">
                                                                                                                                                    <Items>
                                                                                                                                                        <ext:Radio ID="radioBGuaranteeYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                                                                                                            ReadOnly="true" />
                                                                                                                                                        <ext:Radio ID="radioBGuaranteeNo" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                                                                                                                    </Items>
                                                                                                                                                </ext:RadioGroup>
                                                                                                                                            </ext:Anchor>
                                                                                                                                        </ext:FormLayout>
                                                                                                                                    </Body>
                                                                                                                                </ext:Panel>
                                                                                                                            </ext:LayoutColumn>
                                                                                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                                                                                <ext:Panel ID="Panel74" runat="server" Border="false">
                                                                                                                                    <Body>
                                                                                                                                        <ext:FormLayout ID="FormLayout42" runat="server">
                                                                                                                                            <ext:Anchor>
                                                                                                                                                <ext:TextField ID="tfBGuaranteeAmount" runat="server" FieldLabel="Amount" ReadOnly="true">
                                                                                                                                                </ext:TextField>
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
                                                                                            </ext:LayoutColumn>
                                                                                        </ext:ColumnLayout>
                                                                                    </Body>
                                                                                </ext:Panel>
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
                                                <ext:Panel runat="server" ID="Panel76">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout26" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel77" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout43" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:RadioGroup ID="rgInventory" runat="server" FieldLabel="(10) Any back order or short term consignment need clear and issue<br/> invoices ( CNY, incl. VAT)"
                                                                                    LabelSeparator="" Width="260">
                                                                                    <Items>
                                                                                        <ext:Radio ID="radioInventoryYes" runat="server" BoxLabel="Yes" Checked="false" ReadOnly="true" />
                                                                                        <ext:Radio ID="radioInventoryNo" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                                                    </Items>
                                                                                </ext:RadioGroup>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel78" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout44" runat="server" LabelWidth="180">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfInventoryAmount" runat="server" FieldLabel="Amount" ReadOnly="true">
                                                                                </ext:TextField>
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
                                                <ext:Panel runat="server" ID="Panel79">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout27" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel80" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout45" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfEstimatedAR" runat="server" FieldLabel="(11) Estimated A/R balance after settlement ($, inc. VAT)"
                                                                                    ReadOnly="true">
                                                                                </ext:TextField>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".4">
                                                                <ext:Panel ID="Panel81" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout46" runat="server" LabelWidth="180">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfEstimatedARWirte" runat="server" FieldLabel="Included the amount pending for write off?"
                                                                                    ReadOnly="true">
                                                                                </ext:TextField>
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
                                                <ext:Panel runat="server" ID="Panel82">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout28" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".6">
                                                                <ext:Panel ID="Panel83" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout47" runat="server" LabelWidth="500">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="tfPaymentPlan" runat="server" FieldLabel="(12) If there is outstanding AR after above items on settlement, please provide payment schedule"
                                                                                    ReadOnly="true" Width="300">
                                                                                </ext:TextField>
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
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                </ext:Panel>
                <ext:Panel ID="Panel32" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="5.  Business Handover">
                    <Body>
                        <ext:Panel ID="Panel33" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout10" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel34" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout14" runat="server" LabelWidth="430">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfHandoverTake" runat="server" FieldLabel="Who will take over the business from this dealer"
                                                            Width="200" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="RadioGroup3" runat="server" HideLabel="true">
                                                            <Items>
                                                                <ext:Radio ID="radioTakeType1" runat="server" BoxLabel="BSC" Checked="false" ReadOnly="true" />
                                                                <ext:Radio ID="radioTakeType2" runat="server" BoxLabel="LP" Checked="false" ReadOnly="true" />
                                                                <ext:Radio ID="radioTakeType3" runat="server" BoxLabel="T1 Dealer" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioTakeType4" runat="server" BoxLabel="T2 Dealer" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="RadioGroup4" runat="server" FieldLabel=" If it is a new dealer, have you submitted the appointment application"
                                                            Width="200" LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioHandoverAppoinYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioHandoverAppoinNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
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
                <ext:Panel ID="Panel35" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="6.  Timeline Estimation">
                    <Body>
                        <ext:Panel ID="Panel36" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout11" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel37" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout15" runat="server" LabelWidth="430">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="RadioGroup6" runat="server" FieldLabel="  (1) Have you notified the dealer about the Non-Renewal/Termination"
                                                            Width="200" LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioTimelineHasNotifiedYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioTimelineHasNotifiedNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfTimelineWhenNotify" runat="server" FieldLabel="(2) When would you like to notify the dealer"
                                                            Width="300" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfTimelineWhenSettlement" runat="server" FieldLabel="(3) When would you like to complete the settlement"
                                                            Width="300" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfTimelineWhenHandover" runat="server" FieldLabel="(4) When would you like to complete the handover"
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
            </Body>
        </ext:Panel>
        <ext:Panel ID="Panel31" runat="server" Header="true" Title="For National Channel Manager:   Please Complete Section 8 - 11"
            Frame="true" Icon="Application" AutoHeight="true" AutoScroll="true" Collapsible="true"
            BodyStyle="padding:10px;">
            <Body>
                <ext:Panel ID="Panel21" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="7.  Internal Communications">
                    <Body>
                        <ext:Panel ID="Panel22" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.33">
                                        <ext:Panel ID="Panel23" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout11" runat="server" LabelWidth="450">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="RadioGroup5" Width="200" runat="server" FieldLabel="  Have you notified this case to DRM, Finance, Operations & HEGA"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioCommunicationsYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioCommunicationsNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
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
                <ext:Panel ID="Panel38" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="8.  Settlement Proposals">
                    <Body>
                        <ext:Panel ID="Panel39" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout12" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.33">
                                        <ext:Panel ID="Panel40" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout16" runat="server" LabelWidth="450">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="RadioGroup7" Width="200" runat="server" FieldLabel="  Have you reviewed and confirmed above settlement proposals"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioSettlementProposalsYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioSettlementProposalsNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
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
                <ext:Panel ID="Panel24" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="9.  Business Handover">
                    <Body>
                        <ext:Panel ID="Panel25" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.33">
                                        <ext:Panel ID="Panel26" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout12" runat="server" LabelWidth="450">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="RadioGroup8" Width="200" runat="server" FieldLabel=" Have you submitted new dealer appointment IAF for handover purpose"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioBusinessHandoverYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioBusinessHandoverNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfBusinessHandover_Specify" runat="server" FieldLabel="If not applicable, please specify"
                                                            Width="200" ReadOnly="true" LabelSeparator="?">
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
                <%--     <ext:Panel ID="Panel27" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="10.  IAF Preparations">
                    <Body>
                        <ext:Panel ID="Panel28" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout9" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.33">
                                        <ext:Panel ID="Panel29" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout13" runat="server" LabelWidth="450">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgIAFPreparations" Width="200" runat="server" FieldLabel=" Have you prepared Dealer Non-Renewal IAF and attached it to this form"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioIAFPreparationsYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioIAFPreparationsNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                    </Body>
                </ext:Panel>--%>
            </Body>
        </ext:Panel>
    </div>
    </form>
</body>
</html>
