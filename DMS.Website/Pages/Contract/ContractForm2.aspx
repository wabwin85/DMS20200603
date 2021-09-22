<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractForm2.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractForm2" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
    <ext:Hidden ID="hdContractID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdParmetType" runat="server">
    </ext:Hidden>
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <div>
        <ext:Panel ID="btnPanel" runat="server" Header="false" Height="17">
            <TopBar>
                <ext:Toolbar ID="Toolbar1" runat="server">
                    <Items>
                        <ext:ToolbarFill />
                        <ext:Button ID="btnCreatePdf" runat="server" Text="生成IAF Form2 PDF" Icon="PageWhiteAcrobat"
                            AutoPostBack="true" OnClick="CreatePdf">
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </TopBar>
        </ext:Panel>
        <ext:Panel ID="plForm3" runat="server" Header="true" Title="Internal Approval Form Form2"
            Frame="true" Icon="Application" AutoHeight="true" AutoScroll="true" BodyStyle="padding:10px;"
            Collapsible="false">
            <Body>
                <!--1.	Contract Typ-->
                <ext:Panel ID="Panel20" runat="server" FormGroup="true" BodyBorder="true" Title="1.	Contract Type">
                    <Body>
                        <ext:Panel ID="Panel3" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.55">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgContractType" runat="server" HideLabel="true">
                                                            <Items>
                                                                <ext:Radio ID="radioAgent" runat="server" BoxLabel="Agent" Checked="false" ReadOnly="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioDealer" runat="server" BoxLabel="Dealer*" Checked="false" ReadOnly="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioDistributor" runat="server" BoxLabel="Distributor" Checked="false"
                                                                    ReadOnly="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioOther" runat="server" BoxLabel="Other*" Checked="false" ReadOnly="true">
                                                                </ext:Radio>
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.45">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfContractTypeOther" runat="server" HideLabel="true" ReadOnly="true"
                                                            Width="200">
                                                        </ext:TextField>
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
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel5" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:Label ID="labelContractTypeRemarks" runat="server" HideLabel="true" Text="*Describe Dealer and/or Other (include specific activities being performed, e.g. invoicing, collections, warehouse, receivables):">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfContractTypeRemarks" runat="server" HideLabel="true" Width="500"
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
                        <ext:Panel ID="Panel9" runat="server" Header="false" Frame="true" Icon="Application"
                            AutoHeight="true" AutoScroll="true" BodyStyle="padding:0px;">
                            <Body>
                                <ext:Panel ID="Panel7" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                            <ext:LayoutColumn ColumnWidth="0.45">
                                                <ext:Panel ID="Panel8" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="120">
                                                            <ext:Anchor>
                                                                <ext:Label ID="label1" runat="server" HideLabel="true" Text="BSC Contracting Party"
                                                                    ItemCls="labelBold">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:RadioGroup ID="rgContractParty" runat="server" HideLabel="true">
                                                                    <Items>
                                                                        <ext:Radio ID="radioKerkrade" runat="server" ReadOnly="true" BoxLabel="BSIBV (Kerkrade)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioCrm" runat="server" ReadOnly="true" BoxLabel="St. Paul (CRM)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioSpecify" runat="server" ReadOnly="true" BoxLabel="Local Entity (Specify):"
                                                                            Checked="true">
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth="0.55">
                                                <ext:Panel ID="Panel6" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="120">
                                                            <ext:Anchor>
                                                                <ext:Label ID="label2" runat="server" HideLabel="true" Text="　">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfContractyPartySpecify" runat="server" HideLabel="true" ReadOnly="true">
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
                <!--2.	Third Party Information-->
                <ext:Panel ID="Panel10" runat="server" FormGroup="true" BodyBorder="true" Title="2.	Third Party Information">
                    <Body>
                        <ext:Panel ID="Panel11" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.45">
                                        <ext:Panel ID="Panel12" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfThirdPartyName" runat="server" FieldLabel="Name" Width="200"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfThirdParyAddress" ReadOnly="true" runat="server" FieldLabel="Address<br/>(Including Country)"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.55">
                                        <ext:Panel ID="Panel13" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfThirdParyRegion" ReadOnly="true" runat="server" FieldLabel="Region / Territory"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel16" runat="server" Header="false" Frame="true" Icon="Application"
                            AutoHeight="true" AutoScroll="true" BodyStyle="padding:0px;">
                            <Body>
                                <ext:Panel ID="Panel17" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                            <ext:LayoutColumn ColumnWidth="0.4">
                                                <ext:Panel ID="Panel18" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout9" runat="server" LabelWidth="200">
                                                            <ext:Anchor>
                                                                <ext:Label ID="labelContactTerms" runat="server" HideLabel="true" Text="Contract Terms"
                                                                    ItemCls="labelBold">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="tfContractTermsEffectiveDate" runat="server" FieldLabel="Effective Date"
                                                                    ReadOnly="true">
                                                                </ext:DateField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextArea ID="tfContractTermsMore2Year" runat="server" Width="200" Height="60"
                                                                    ReadOnly="true" FieldLabel="If > 2 years, please justify">
                                                                </ext:TextArea>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextArea ID="tfContractTermsExclusive" runat="server" Width="200" Height="60"
                                                                    ReadOnly="true" FieldLabel="*If “Exclusive,” please justify">
                                                                </ext:TextArea>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth="0.3">
                                                <ext:Panel ID="Panel14" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="220">
                                                            <ext:Anchor>
                                                                <ext:Label ID="label3" runat="server" HideLabel="true" Text="　">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:NumberField ID="nfContractTermsExpirationDateYear" runat="server" MinValue="0"
                                                                    MaxValue="99" MaxLength="2" ReadOnly="true" FieldLabel="Expiration Date:December 31, 20"
                                                                    LabelSeparator="" Width="50">
                                                                </ext:NumberField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth="0.30">
                                                <ext:Panel ID="Panel15" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="220">
                                                            <ext:Anchor>
                                                                <ext:Label ID="label4" runat="server" HideLabel="true" Text="　">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:RadioGroup ID="rgContractTermsExclusive" runat="server" HideLabel="true">
                                                                    <Items>
                                                                        <ext:Radio ID="radioNonExclusive" runat="server" ReadOnly="true" BoxLabel="Non-Exclusive"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioExclusive" runat="server" ReadOnly="true" BoxLabel="Exclusive*"
                                                                            Checked="false">
                                                                        </ext:Radio>
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
                    </Body>
                </ext:Panel>
                <!--3.	Additional Documentation Requested for Contract-->
                <ext:Panel ID="Panel19" runat="server" FormGroup="true" BodyBorder="true" Title="3.	Additional Documentation Requested for Contract">
                    <Body>
                        <ext:Panel ID="Panel21" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.45">
                                        <ext:Panel ID="Panel22" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout11" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgAdditionalContract" runat="server" HideLabel="true">
                                                            <Items>
                                                                <ext:Radio ID="radioAdditionalContractNone" ReadOnly="true" runat="server" BoxLabel="None"
                                                                    Checked="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioAdditionalContractContractLegalization" ReadOnly="true" runat="server"
                                                                    BoxLabel="Contract Legalization" Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioAdditionalContractImportCertificate" ReadOnly="true" runat="server"
                                                                    BoxLabel="Import Certificate" Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioAdditionalContractOther" runat="server" ReadOnly="true" BoxLabel="Other:"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.55">
                                        <ext:Panel ID="Panel23" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout12" runat="server" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfAdditionalContractOther" runat="server" HideLabel="true" ReadOnly="true">
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
                <ext:Panel ID="Panel24" runat="server" Header="false" Frame="true" Icon="Application"
                    AutoHeight="true" AutoScroll="true" BodyStyle="padding:0px;">
                    <Body>
                        <ext:Panel ID="Panel25" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel26" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout13" runat="server" LabelWidth="120">
                                                    <ext:Anchor>
                                                        <ext:Label ID="label5" runat="server" HideLabel="true" Text="NOTE: For all Contract Amendment Requests please complete required Sections, including appropriate approvals.">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="label6" runat="server" HideLabel="true" Text="(Quotas should be provided for all new product line requests)">
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
                <!--4.	BSC Product Lines (Check ALL Product Lines to be sold by Third Party)-->
                <ext:Panel ID="Panel27" runat="server" FormGroup="true" BodyBorder="true" Title="4.	BSC Product Lines (Check ALL Product Lines to be sold by Third Party)">
                    <Body>
                        <ext:Panel ID="Panel28" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel29" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout14" runat="server">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgProductLine" runat="server" HideLabel="true">
                                                            <Items>
                                                                <ext:RadioColumn ColumnWidth="0.33">
                                                                    <Items>
                                                                        <ext:Radio ID="radioProductLineCardio" runat="server" ReadOnly="true" BoxLabel="Interventional Cardiology (Cardio)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioProductLinePi" runat="server" ReadOnly="true" BoxLabel="Peripheral Interventions (PI)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioProductLineNm" runat="server" ReadOnly="true" BoxLabel="Neuromodulation (NM)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioProductLineW" runat="server" ReadOnly="true" BoxLabel="Watchman (W)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioColumn>
                                                                <ext:RadioColumn ColumnWidth="0.33">
                                                                    <Items>
                                                                        <ext:Radio ID="radioProductLineCrm" runat="server" ReadOnly="true" BoxLabel="Cardiac Rhythm Management (CRM)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioProductLineEndo" runat="server" ReadOnly="true" BoxLabel="Endoscopy (Endo)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioProductLineUro" runat="server" ReadOnly="true" BoxLabel="Urology (Uro)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioProductLineAsth" runat="server" ReadOnly="true" BoxLabel="Asthma (Asth)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioColumn>
                                                                <ext:RadioColumn ColumnWidth="0.33">
                                                                    <Items>
                                                                        <ext:Radio ID="radioProductLineWh" runat="server" ReadOnly="true" BoxLabel="Women’s Health (WH)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioProductLineEp" runat="server" ReadOnly="true" BoxLabel="Electrophysiology (EP)"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioProductLineSh" runat="server" ReadOnly="true" BoxLabel="Structural Heart (SH):"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioProductLineOther" runat="server" ReadOnly="true" BoxLabel="Other/Partial (list):"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:TextField ID="tfProductLineOther" runat="server" ReadOnly="true" HideLabel="true">
                                                                        </ext:TextField>
                                                                    </Items>
                                                                </ext:RadioColumn>
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
                <!--5.	Quotas-->
                <ext:Panel ID="Panel30" runat="server" FormGroup="true" BodyBorder="true" Title="5.	Quotas">
                    <Body>
                        <ext:Panel ID="Panel31" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout9" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.45">
                                        <ext:Panel ID="Panel32" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout15" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQuotas" runat="server" HideLabel="true">
                                                            <Items>
                                                                <ext:Radio ID="radioQuotasUs" ReadOnly="true" runat="server" BoxLabel="US $" Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQuotasEuro" ReadOnly="true" runat="server" BoxLabel="Euro" Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQuotasOther" ReadOnly="true" runat="server" BoxLabel="Other (include SFX):"
                                                                    Checked="true">
                                                                </ext:Radio>
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.55">
                                        <ext:Panel ID="Panel33" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout16" runat="server" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQuotasOther" runat="server" HideLabel="true" Width="150" ReadOnly="true">
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
                <!--6.	Payment Terms (check one)-->
                <ext:Panel ID="Panel34" runat="server" FormGroup="true" BodyBorder="true" Title="6.	Payment Terms (check one)">
                    <Body>
                        <ext:Panel ID="Panel35" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout10" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel36" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout17" runat="server">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgPaymentTerm" runat="server" HideLabel="true">
                                                            <Items>
                                                                <ext:RadioColumn Width="350">
                                                                    <Items>
                                                                        <ext:Radio ID="radioPaymentTermOpenAccount" runat="server" ReadOnly="true" BoxLabel="Open Account:"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioPaymentTermCashOnly" runat="server" ReadOnly="true" BoxLabel="Cash in Advance ONLY"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioPaymentTermCashOrLetter" runat="server" ReadOnly="true" BoxLabel="Cash in Advance or Letter of Credit (LOC):payable within"
                                                                            Checked="false">
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioColumn>
                                                                <ext:RadioColumn Width="120">
                                                                    <Items>
                                                                        <ext:NumberField ID="tfPaymentTermOpenAccountDay" runat="server" AllowNegative="false"
                                                                            AllowDecimals="false" ReadOnly="true">
                                                                        </ext:NumberField>
                                                                        <ext:Label ID="Label7" runat="server" Text="　" ReadOnly="true">
                                                                        </ext:Label>
                                                                        <%-- <ext:NumberField ID="tfPaymentTermCashOrLetterDay" runat="server" AllowNegative="false" AllowDecimals="false"  ReadOnly="true"  ></ext:NumberField>--%>
                                                                        <ext:TextField ID="tfPaymentTermCashOrLetter" runat="server">
                                                                        </ext:TextField>
                                                                    </Items>
                                                                </ext:RadioColumn>
                                                                <ext:RadioColumn Width="190">
                                                                    <Items>
                                                                        <ext:Label ID="Label9" runat="server" Text="　day terms with a credit limit of">
                                                                        </ext:Label>
                                                                        <ext:Label ID="Label8" runat="server" Text="　">
                                                                        </ext:Label>
                                                                        <ext:Label ID="Label10" runat="server" Text="　Days">
                                                                        </ext:Label>
                                                                    </Items>
                                                                </ext:RadioColumn>
                                                                <ext:RadioColumn Width="120">
                                                                    <Items>
                                                                        <ext:TextField ID="tfPaymentTermOpenAccountDayBank" runat="server" ReadOnly="true">
                                                                        </ext:TextField>
                                                                    </Items>
                                                                </ext:RadioColumn>
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
                        <ext:Panel ID="Panel37" runat="server" Header="false" Frame="true" Icon="Application"
                            AutoHeight="true" AutoScroll="true" BodyStyle="padding:0px;">
                            <Body>
                                <ext:Panel ID="Panel38" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout11" runat="server">
                                            <ext:LayoutColumn ColumnWidth="0.3">
                                                <ext:Panel ID="Panel39" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout18" runat="server" LabelWidth="120">
                                                            <ext:Anchor>
                                                                <ext:Label ID="label11" runat="server" HideLabel="true" Text="Security (if required)"
                                                                    ItemCls="labelBold">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfSecurityAmount" runat="server" FieldLabel="Amount" ReadOnly="true">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Checkbox ID="cbGuarantee1" runat="server" BoxLabel="Cash Deposit" HideLabel="true"
                                                                    ReadOnly="true">
                                                                </ext:Checkbox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Checkbox ID="cbGuarantee4" runat="server" BoxLabel="Real Estate Mortgage" HideLabel="true"
                                                                    ReadOnly="true">
                                                                </ext:Checkbox>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth="0.4">
                                                <ext:Panel ID="Panel40" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout19" runat="server" LabelWidth="120">
                                                            <ext:Anchor>
                                                                <ext:Label ID="label12" runat="server" HideLabel="true" Text="　">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Label ID="label15" runat="server" HideLabel="true" Text="　">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Checkbox ID="cbGuarantee2" runat="server" BoxLabel="Bank Guarantee" HideLabel="true"
                                                                    ReadOnly="true">
                                                                </ext:Checkbox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Panel ID="Panel49" runat="server">
                                                                    <Body>
                                                                        <ext:ColumnLayout ID="ColumnLayout14" runat="server">
                                                                            <ext:LayoutColumn ColumnWidth="0.3">
                                                                                <ext:Panel ID="Panel50" runat="server" Border="false">
                                                                                    <Body>
                                                                                        <ext:FormLayout ID="FormLayout25" runat="server" LabelWidth="120">
                                                                                            <ext:Anchor>
                                                                                                <ext:Checkbox ID="cbGuarantee5" runat="server" BoxLabel="Others" HideLabel="true"
                                                                                                    ReadOnly="true">
                                                                                                </ext:Checkbox>
                                                                                            </ext:Anchor>
                                                                                        </ext:FormLayout>
                                                                                    </Body>
                                                                                </ext:Panel>
                                                                            </ext:LayoutColumn>
                                                                            <ext:LayoutColumn ColumnWidth="0.7">
                                                                                <ext:Panel ID="Panel51" runat="server" Border="false">
                                                                                    <Body>
                                                                                        <ext:FormLayout ID="FormLayout26" runat="server" LabelWidth="120">
                                                                                            <ext:Anchor>
                                                                                                <ext:TextField ID="tfSecurityOther" runat="server" HideLabel="true" ReadOnly="true" Width="200">
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
                                            <ext:LayoutColumn ColumnWidth="0.4">
                                                <ext:Panel ID="Panel41" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout20" runat="server" LabelWidth="120">
                                                            <ext:Anchor>
                                                                <ext:Label ID="label13" runat="server" HideLabel="true" Text="　">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Label ID="label16" runat="server" HideLabel="true" Text="　">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Checkbox ID="cbGuarantee3" runat="server" BoxLabel="Company Guarantee" HideLabel="true"
                                                                    ReadOnly="true">
                                                                </ext:Checkbox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Label ID="label17" runat="server" HideLabel="true" Text="　">
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
                    </Body>
                </ext:Panel>
                <!--7.	Agent Commission Compensation*-->
                <ext:Panel ID="Panel42" runat="server" FormGroup="true" BodyBorder="true" Title="7.	Agent Commission Compensation*">
                    <Body>
                        <ext:Panel ID="Panel43" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout12" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.25">
                                        <ext:Panel ID="Panel44" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout21" runat="server" LabelWidth="120">
                                                    <ext:Anchor>
                                                        <ext:NumberField ID="tfAgentCommissionRange" runat="server" FieldLabel="Commission Range"
                                                            Width="60" ReadOnly="true">
                                                        </ext:NumberField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.25">
                                        <ext:Panel ID="Panel45" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout22" runat="server" LabelWidth="70">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgAgentCommissionPayable" runat="server" FieldLabel="Payable">
                                                            <Items>
                                                                <ext:Radio ID="radioAgentCommissionPayableMonthly" runat="server" BoxLabel="Monthly"
                                                                    Checked="false" ReadOnly="true">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioAgentCommissionPayableQuarterly" runat="server" BoxLabel="Quarterly"
                                                                    Checked="false" ReadOnly="true">
                                                                </ext:Radio>
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.5">
                                        <ext:Panel ID="Panel46" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout23" runat="server" LabelWidth="130">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgAgentCommissionAdditional" runat="server" FieldLabel="Additional payments*">
                                                            <Items>
                                                                <ext:RadioColumn Width="120">
                                                                    <Items>
                                                                        <ext:Radio ID="radioAgentCommissionAdditionalYes" runat="server" BoxLabel="Yes　-　amount"
                                                                            Checked="false" ReadOnly="true">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="radioAgentCommissionAdditionalNo" runat="server" BoxLabel="No" Checked="false"
                                                                            ReadOnly="true">
                                                                        </ext:Radio>
                                                                        <ext:Label ID="labelAgentCommissionAdditional" runat="server" Text="Type (please specify)"
                                                                            ReadOnly="true">
                                                                        </ext:Label>
                                                                    </Items>
                                                                </ext:RadioColumn>
                                                                <ext:RadioColumn Width="100">
                                                                    <Items>
                                                                        <ext:NumberField ID="tfAgentCommissionAdditionalYesRmarks" runat="server" AllowNegative="true"
                                                                            ReadOnly="true">
                                                                        </ext:NumberField>
                                                                    </Items>
                                                                </ext:RadioColumn>
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
                        <ext:Panel ID="Panel47" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout13" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel48" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:Label ID="label14" runat="server" HideLabel="true" Text="* Includes any signing bonus, up-front payment or guaranteed payment other than sales commissions (Vice President Finance (Regional) signature required)">
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
            </Body>
        </ext:Panel>
    </div>
    </form>
</body>
</html>
