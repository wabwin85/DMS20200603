<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractForm7.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractForm7" %>

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
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <ext:Hidden ID="hdDealerId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdContId" runat="server">
    </ext:Hidden>
    <div>
        <ext:Panel ID="btnPanel" runat="server" Header="false" Height="17">
            <TopBar>
                <ext:Toolbar ID="Toolbar1" runat="server">
                    <Items>
                        <ext:ToolbarFill />
                        <ext:Button ID="btnCreatePdf" runat="server" Text="生成IAF Form7 PDF" Icon="PageWhiteAcrobat"
                            AutoPostBack="true" OnClick="CreatePdf">
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </TopBar>
        </ext:Panel>
        <ext:Panel ID="plForm4" runat="server" Header="true" Title="蓝威第三方非更新/终止表 表格7"
            Frame="true" Icon="Application" AutoHeight="true" AutoScroll="true" BodyStyle="padding:10px;"
            Collapsible="false">
            <Body>
                <ext:Panel ID="Panel43" runat="server" Header="false" Frame="true" Icon="Application"
                    AutoHeight="true" AutoScroll="true" BodyStyle="padding:0px;">
                    <Body>
                        <ext:Panel ID="Panel44" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout14" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel45" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout25" runat="server" LabelWidth="650">
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:RadioGroup ID="radioHeadParm1" runat="server" LabelSeparator="" FieldLabel="1.	Non-Renewal/Termination Internal Approval Form (Section 9) prepared and routed for signature?">
                                                            <Items>
                                                                <ext:Radio ID="radioHeadParm1Yes" runat="server" BoxLabel="Yes" Checked="false" ReadOnly="true" />
                                                                <ext:Radio ID="radioHeadParm1No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:RadioGroup ID="radioHeadParm2" runat="server" LabelSeparator="" FieldLabel="2.	Have you notified Global Compliance and your Legal Department of proposed severance of relationship?">
                                                            <Items>
                                                                <ext:Radio ID="radioHeadParm2Yes" runat="server" BoxLabel="Yes" Checked="false" ReadOnly="true" />
                                                                <ext:Radio ID="radioHeadParm2No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:RadioGroup ID="radioHeadParm3" runat="server" LabelSeparator="" FieldLabel="3.	Confirm if Oral or Written Notice of Non-renewal or termination has been provided to Third Party?">
                                                            <Items>
                                                                <ext:Radio ID="radioHeadParm3Yes" runat="server" BoxLabel="Yes" Checked="false" ReadOnly="true" />
                                                                <ext:Radio ID="radioHeadParm3No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:RadioGroup ID="HeadParm4" runat="server" LabelSeparator="" FieldLabel="4.	Will a Settlement Agreement be required?">
                                                            <Items>
                                                                <ext:Radio ID="radioHeadParm4Yes" runat="server" BoxLabel="Yes" Checked="false" ReadOnly="true" />
                                                                <ext:Radio ID="radioHeadParm4No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:RadioGroup ID="HeadParm5" runat="server" LabelSeparator="" FieldLabel="5.	Will there be any Payments to Third Party (settlement amounts )or write-off of debt booked to reserve?">
                                                            <Items>
                                                                <ext:Radio ID="radioHeadParm5Yes" runat="server" BoxLabel="Yes" Checked="false" ReadOnly="true" />
                                                                <ext:Radio ID="radioHeadParm5No" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
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
                <ext:Panel ID="Panel90" runat="server" Height="10">
                    <Body>
                    </Body>
                </ext:Panel>
                <ext:Panel ID="Panel46" runat="server" BodyStyle="padding:10px;" Header="false" Frame="true"
                    Icon="Application">
                    <Body>
                        <ext:Panel ID="Panel47" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout15" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.3">
                                        <ext:Panel ID="Panel48" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout26" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfFrom7DealerName" runat="server" FieldLabel="Third Party Name"
                                                            Width="180" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.3">
                                        <ext:Panel ID="Panel49" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout27" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfFrom7Country" runat="server" FieldLabel="Country" Width="180"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.3">
                                        <ext:Panel ID="Panel22" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout13" runat="server" LabelWidth="50">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgExclusive" runat="server" LabelSeparator="" Width="200">
                                                            <Items>
                                                                <ext:Radio ID="radioExclusiveYes" runat="server" BoxLabel="Exclusive" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioExclusiveNo" runat="server" BoxLabel="Non-Exclusive" Checked="false"
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
                <ext:Panel ID="Panel38" runat="server" Height="10">
                    <Body>
                    </Body>
                </ext:Panel>
                <!--详细信息-->
                <ext:Panel ID="Panel1" runat="server" BodyBorder="true" BodyStyle="padding:10px;"
                    Header="false" Frame="true" Icon="Application">
                    <Body>
                        <ext:Panel ID="Panel2" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfContractDate" runat="server" FieldLabel="Contract Expiration Date"
                                                            Width="150" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel4" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfTerminationDate" runat="server" FieldLabel="Effective Date of Termination"
                                                            Width="150" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel9" runat="server" AutoHeight="true">
                            <Body>
                                <ext:Panel ID="Panel10" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout11" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".3">
                                                <ext:Panel ID="Panel36" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout20" runat="server">
                                                            <ext:Anchor>
                                                                <ext:Label ID="label11" runat="server" Text="Reason for Non-Renewal or Termination: (please check all that apply)"
                                                                    HideLabel="true">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:Panel ID="Panel5" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".3">
                                                <ext:Panel ID="Panel6" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout3" runat="server">
                                                            <ext:Anchor>
                                                                <ext:Checkbox ID="cbReason1" runat="server" BoxLabel="Accounts Receivable Problems"
                                                                    HideLabel="true" ReadOnly="true">
                                                                </ext:Checkbox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Checkbox ID="cbReason4" runat="server" BoxLabel="Other (please explain)" HideLabel="true"
                                                                    ReadOnly="true">
                                                                </ext:Checkbox>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".3">
                                                <ext:Panel ID="Panel7" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout4" runat="server">
                                                            <ext:Anchor>
                                                                <ext:Checkbox ID="cbReason2" runat="server" BoxLabel="Not Meeting Quota" HideLabel="true"
                                                                    ReadOnly="true">
                                                                </ext:Checkbox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfOtherRes" runat="server" LabelSeparator="" HideLabel="true"
                                                                    Width="150" ReadOnly="true">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".3">
                                                <ext:Panel ID="Panel8" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout5" runat="server">
                                                            <ext:Anchor>
                                                                <ext:Checkbox ID="cbReason3" runat="server" BoxLabel="Product Line Discontinued"
                                                                    ReadOnly="true" HideLabel="true">
                                                                </ext:Checkbox>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:Panel ID="Panel11" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel15" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfOutstandingAmount" runat="server" FieldLabel="Current Outstanding A/R Amount"
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
                                <ext:Panel ID="Panel12" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel13" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfQuotaAmount" runat="server" FieldLabel="Current Quota Amount"
                                                                    ReadOnly="true">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel14" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfActualSales" runat="server" FieldLabel="Actual Sales" ReadOnly="true">
                                                                </ext:TextField>
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
                                        <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel17" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout9" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfGoodsAmount" runat="server" FieldLabel="Return of Goods Amount"
                                                                    ReadOnly="true">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel20" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout11" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:RadioGroup ID="RadioGroup6" runat="server" FieldLabel="List of RGA Products Attached"
                                                                    Width="190">
                                                                    <Items>
                                                                        <ext:Radio ID="radioRGAAttachedYes" runat="server" BoxLabel="YES" Checked="false"
                                                                            ReadOnly="true" />
                                                                        <ext:Radio ID="radioRGAAttachedNo" runat="server" BoxLabel="NO" Checked="false" ReadOnly="true" />
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
                                <ext:Panel ID="Panel18" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel19" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout12" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:RadioGroup ID="RadioGroup7" runat="server" FieldLabel="Does the Third Party have<br/> any outstanding tenders"
                                                                    LabelSeparator="?" Width="150">
                                                                    <Items>
                                                                        <ext:Radio ID="radioOuttenderYes" runat="server" BoxLabel="YES" Checked="false" ReadOnly="true" />
                                                                        <ext:Radio ID="radioOuttenderNo" runat="server" BoxLabel="NO" Checked="false" ReadOnly="true" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel21" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfPostTermination" runat="server" FieldLabel="Tender Details:If BSC will need to honor tenders post-termination, provide details"
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
                                <ext:Panel ID="Panel23" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel24" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout14" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:RadioGroup ID="RadioGroup8" runat="server" FieldLabel="Will a Payment be Due <br/>to the Third Party"
                                                                    LabelSeparator="?" Width="150">
                                                                    <Items>
                                                                        <ext:Radio ID="radioDuePaymentYes" runat="server" BoxLabel="YES" Checked="false"
                                                                            ReadOnly="true" />
                                                                        <ext:Radio ID="radioDuePaymentNo" runat="server" BoxLabel="NO" Checked="false" ReadOnly="true" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel25" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout15" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfCreditAmount" runat="server" FieldLabel="Credit Amount" ReadOnly="true">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:Panel ID="Panel26" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel27" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout16" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:RadioGroup ID="RadioGroup9" runat="server" FieldLabel="Is a bank guarantee posted<br/> to Boston Scientific"
                                                                    LabelSeparator="?" Width="150">
                                                                    <Items>
                                                                        <ext:Radio ID="radioBankGuaranteeYes" runat="server" BoxLabel="YES" Checked="false"
                                                                            ReadOnly="true" />
                                                                        <ext:Radio ID="radioBankGuaranteeNo" runat="server" BoxLabel="NO" Checked="false"
                                                                            ReadOnly="true" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel28" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout17" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfGuaranteeAmount" runat="server" FieldLabel="Guarantee Amount"
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
                                <ext:Panel ID="Panel29" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout9" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel30" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout18" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:RadioGroup ID="Reserve" runat="server" FieldLabel="Is a reserve already<br/> posted on the books"
                                                                    LabelSeparator="?" Width="150">
                                                                    <Items>
                                                                        <ext:Radio ID="radioReserveYes" runat="server" BoxLabel="YES" Checked="false" ReadOnly="true" />
                                                                        <ext:Radio ID="radioReserveNo" runat="server" BoxLabel="NO" Checked="false" ReadOnly="true" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel31" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout19" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfReserveAmount" runat="server" FieldLabel="Reserve Amount" ReadOnly="true">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:Panel ID="Panel32" runat="server">
                                    <Body>
                                        <ext:Panel ID="Panel33" runat="server">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout12" runat="server">
                                                    <ext:LayoutColumn ColumnWidth="1">
                                                        <ext:Panel ID="Panel37" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout22" runat="server">
                                                                    <ext:Anchor>
                                                                        <ext:Label ID="Label1" runat="server" HideLabel="true" Text="Proposed Total Amount of Settlement Offer to Third Party (include all proposed write offs):">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:Panel>
                                        <ext:Panel ID="Panel35" runat="server">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout10" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".35">
                                                        <ext:Panel ID="Panel34" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout21" runat="server" LabelWidth="200">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfSettlement" runat="server" FieldLabel="Settlement" ReadOnly="true">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfWriteOff" runat="server" FieldLabel="Write off" ReadOnly="true">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <%--   <ext:RadioGroup ID="RadioReserveType" runat="server" FieldLabel="Reserve Type" LabelSeparator=""
                                                                            Width="400">
                                                                            <Items>
                                                                                <ext:Radio ID="radioReserveDebt" runat="server" BoxLabel="Bad Debt" Checked="false"
                                                                                    ReadOnly="true" />
                                                                                <ext:Radio ID="radioReserveSettlement" runat="server" BoxLabel="Settlement" Checked="false"
                                                                                    ReadOnly="true" />
                                                                                <ext:Radio ID="radioReserveReturn" runat="server" BoxLabel="Sales Return" Checked="false"
                                                                                    ReadOnly="true" />
                                                                                <ext:Radio ID="radioReserveOther" runat="server" BoxLabel="Other" Checked="false"
                                                                                    ReadOnly="true" />
                                                                            </Items>
                                                                        </ext:RadioGroup>--%>
                                                                        <ext:CheckboxGroup ID="cbgReserveType" runat="server" FieldLabel="Reserve Type" LabelSeparator=""
                                                                            Width="400">
                                                                            <Items>
                                                                                <ext:Checkbox ID="cbReserveDebt" runat="server" BoxLabel="Bad Debt" Checked="false"
                                                                                    ReadOnly="true">
                                                                                </ext:Checkbox>
                                                                                <ext:Checkbox ID="cbReserveSettlement" runat="server" BoxLabel="Settlement" Checked="false"
                                                                                    ReadOnly="true">
                                                                                </ext:Checkbox>
                                                                                <ext:Checkbox ID="cbReserveReturn" runat="server" BoxLabel="Sales Return" Checked="false"
                                                                                    ReadOnly="true">
                                                                                </ext:Checkbox>
                                                                                <ext:Checkbox ID="cbReserveOther" runat="server" BoxLabel="Other" Checked="false"
                                                                                    ReadOnly="true">
                                                                                </ext:Checkbox>
                                                                            </Items>
                                                                        </ext:CheckboxGroup>
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
                    </Body>
                </ext:Panel>
            </Body>
        </ext:Panel>
    </div>
    </form>
</body>
</html>
