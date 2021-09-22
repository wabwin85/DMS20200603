<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractAppendix1.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractAppendix1" %>

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
    <ext:Store ID="TerritoryNew" runat="server" OnRefreshData="Store_RefreshTerritoryNew">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ContractId" />
                    <ext:RecordField Name="ContractType" />
                    <ext:RecordField Name="ProductLine" />
                    <ext:RecordField Name="HosId" />
                    <ext:RecordField Name="HospitalName" />
                    <ext:RecordField Name="TerritoryType" />
                    <ext:RecordField Name="DepartRemark" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="QuotaNew" runat="server" OnRefreshData="Store_RefreshQuotaNew">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="ProductLine" />
                    <ext:RecordField Name="CCName" />
                    <ext:RecordField Name="Year" />
                    <ext:RecordField Name="Q1" />
                    <ext:RecordField Name="Q2" />
                    <ext:RecordField Name="Q3" />
                    <ext:RecordField Name="Q4" />
                    <ext:RecordField Name="M1" />
                    <ext:RecordField Name="M2" />
                    <ext:RecordField Name="M3" />
                    <ext:RecordField Name="M4" />
                    <ext:RecordField Name="M5" />
                    <ext:RecordField Name="M6" />
                    <ext:RecordField Name="M7" />
                    <ext:RecordField Name="M8" />
                    <ext:RecordField Name="M9" />
                    <ext:RecordField Name="M10" />
                    <ext:RecordField Name="M11" />
                    <ext:RecordField Name="M12" />
                    <ext:RecordField Name="Amount_Y" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="QuotaHospitalNew" runat="server" OnRefreshData="Store_RefreshQuotaHospitalNew">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="ContractId" />
                    <ext:RecordField Name="CQName" />
                    <ext:RecordField Name="HospitalId" />
                    <ext:RecordField Name="HospitalName" />
                    <ext:RecordField Name="Year" />
                    <ext:RecordField Name="January" />
                    <ext:RecordField Name="February" />
                    <ext:RecordField Name="March" />
                    <ext:RecordField Name="April" />
                    <ext:RecordField Name="May" />
                    <ext:RecordField Name="June" />
                    <ext:RecordField Name="July" />
                    <ext:RecordField Name="August" />
                    <ext:RecordField Name="September" />
                    <ext:RecordField Name="October" />
                    <ext:RecordField Name="November" />
                    <ext:RecordField Name="December" />
                    <ext:RecordField Name="AmountY" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="QuotaHospitalProductNew" runat="server" OnRefreshData="Store_RefreshQuotaHospitalProductNew">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="ContractId" />
                    <ext:RecordField Name="ProductLine" />
                    <ext:RecordField Name="ProductClassName" />
                    <ext:RecordField Name="HospitalId" />
                    <ext:RecordField Name="HospitalName" />
                    <ext:RecordField Name="Year" />
                    <ext:RecordField Name="January" />
                    <ext:RecordField Name="February" />
                    <ext:RecordField Name="March" />
                    <ext:RecordField Name="April" />
                    <ext:RecordField Name="May" />
                    <ext:RecordField Name="June" />
                    <ext:RecordField Name="July" />
                    <ext:RecordField Name="August" />
                    <ext:RecordField Name="September" />
                    <ext:RecordField Name="October" />
                    <ext:RecordField Name="November" />
                    <ext:RecordField Name="December" />
                    <ext:RecordField Name="AmountY" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="ExcludeHospitalStore" runat="server" UseIdConfirmation="false" OnRefreshData="ExcludeHospitalStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="HosId">
                <Fields>
                    <ext:RecordField Name="HosId" />
                    <ext:RecordField Name="HosHospitalShortName" />
                    <ext:RecordField Name="HosHospitalName" />
                    <ext:RecordField Name="HosGrade" />
                    <ext:RecordField Name="HosKeyAccount" />
                    <ext:RecordField Name="HosProvince" />
                    <ext:RecordField Name="HosCity" />
                    <ext:RecordField Name="HosDistrict" />
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
                    <ext:RecordField Name="TerId" />
                    <ext:RecordField Name="Description" />
                    <ext:RecordField Name="Selected" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hdContractID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdCmID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDealerType" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDivision" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDmaId" runat="server">
    </ext:Hidden>
    <div>
        <ext:Panel ID="btnPanel" runat="server" Header="false" Height="17">
            <TopBar>
                <ext:Toolbar ID="Toolbar1" runat="server">
                    <Items>
                        <ext:ToolbarFill />
                        <ext:Button ID="Button1" runat="server" Text="导出授权" Icon="PageExcel" IDMode="Legacy"
                            AutoPostBack="true" OnClick="ExportExcel">
                        </ext:Button>
                        <ext:Button ID="btnCreatePdf" runat="server" Text="生成Appendix1 PDF" Icon="PageWhiteAcrobat"
                            AutoPostBack="true" OnClick="CreatePdf">
                        </ext:Button>
                        <ext:Button ID="btnAgreement" runat="server" Text="生成经销商协议" Icon="PageExcel" Hidden="true">
                            <Listeners>
                                <Click Handler="window.open('PrintPage.aspx?ContractID='+#{hdContractID}.getValue()+'&DealerID='+#{hdDmaId}.getValue()+'&OperationType=Appointment');" />
                            </Listeners>
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </TopBar>
        </ext:Panel>
        <ext:Panel ID="plAppendix1" runat="server" Header="true" Title="For Recommender :   Please Complete Section 1 - 5"
            Frame="true" Icon="Application" AutoHeight="true" AutoScroll="true" Collapsible="true"
            BodyStyle="paddingtop:0px;paddingbottom:10px;paddingright:10px;paddingleft:10px;">
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
                                                    <ext:Anchor>
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
                        <ext:Panel ID="Panel2" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.5">
                                        <ext:Panel ID="Panel4" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfRecommender" runat="server" FieldLabel="Recommender" Width="250"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.5">
                                        <ext:Panel ID="Panel5" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfJobTitle" runat="server" FieldLabel="Job Title" Width="250"
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
                    </Body>
                </ext:Panel>
                <ext:Panel ID="Panel9" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="2.  Basic Information of the Dealer Candidate Recommended (Please use Chinese for local dealers)">
                    <Body>
                        <ext:Panel ID="Panel6" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel7" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfCompanyNameEn" runat="server" FieldLabel="Company Name" Width="550"
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
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel11" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfContactPerson" runat="server" FieldLabel="Contact Person" Width="250"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfOfficeNumber" runat="server" FieldLabel="Office Number" Width="250"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel12" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfEmail" runat="server" FieldLabel="Email Address" Width="250"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfMobile" runat="server" FieldLabel="Mobile Phone" Width="250"
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
                        <ext:Panel ID="Panel13" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel14" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfAddress" runat="server" FieldLabel="Office Address" Width="550"
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
                        <ext:Panel ID="Panel15" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel16" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfCompanyType" runat="server" FieldLabel="Company Type" Width="250"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfRegisteredCapital" runat="server" FieldLabel="Registered Capital"
                                                            Width="250" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel17" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout9" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfEstablishedTime" runat="server" FieldLabel="Established Time"
                                                            Width="250" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWebsite" runat="server" FieldLabel="Website" Width="250" ReadOnly="true">
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
                <ext:Panel ID="Panel18" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="3.  Supporting Documents">
                    <Body>
                        <ext:Panel ID="Panel10" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.33">
                                        <ext:Panel ID="Panel19" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="200">
                                                    <ext:Anchor Horizontal="30%">
                                                        <ext:RadioGroup ID="rgBusinessLicense" runat="server" FieldLabel="(1) Business License">
                                                            <Items>
                                                                <ext:Radio ID="radioBusinessLicenseYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioBusinessLicenseNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="lbBusinessLicenseRemark" runat="server" Text="(Please do NOT go ahead with the recommendation if the dealer does not pass the annual inspection of local AIC)"
                                                            HideLabel="true" />
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="30%">
                                                        <ext:RadioGroup ID="rgMedicalLicense" runat="server" FieldLabel="(2) Medical Device License">
                                                            <Items>
                                                                <ext:Radio ID="radioMedicalLicenseYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioMedicalLicenseNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="lbMedicalLicenseRemark" runat="server" Text="(Please do NOT go ahead with the recommendation if the license does not cover the SFDA categories of BSC products)"
                                                            HideLabel="true" />
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="30%">
                                                        <ext:RadioGroup ID="rgTaxCertificate" runat="server" FieldLabel="(3) Tax Registration Certificate">
                                                            <Items>
                                                                <ext:Radio ID="radioTaxCertificateYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioTaxCertificateNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="lbTaxCertificateRemark" runat="server" HideLabel="true" LabelStyle="font-weight:bold;font-style:italic;"
                                                            Text="(Please do NOT go ahead with the recommendation if the dealer does not pass the annual inspection of local Tax Bureau)" />
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
                <ext:Panel ID="Panel21" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="4.  Sales & Marketing Competency">
                    <Body>
                        <ext:Panel ID="Panel22" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.33">
                                        <ext:Panel ID="Panel23" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout11" runat="server" LabelWidth="250">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tbHealthcareExperience" runat="server" Width="300" FieldLabel="(1) Healthcare Industry Experience (years)"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tbInterventionalExperience" runat="server" Width="300" FieldLabel="(2) Interventional Experience (years)"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tbKolRelationships" runat="server" Width="300" FieldLabel="(3) KOL Relationships (years)"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tbBusinessPartnerships" runat="server" Width="300" FieldLabel="(4) Business Partnerships (MNC Principals)"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="30%">
                                                        <ext:Label ID="Label3" runat="server" HideLabel="true" Text="If dealer candidates possess none of above competencies, please provide justifications below:" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tbJustifications" runat="server" Width="300" FieldLabel="Justifications"
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
                    </Body>
                </ext:Panel>
                <ext:Panel ID="Panel24" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="5.  Preliminary Business Proposals">
                    <Body>
                        <ext:Panel ID="Panel25" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout9" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.33">
                                        <ext:Panel ID="Panel26" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout12" runat="server" LabelWidth="250">
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:RadioGroup ID="rgContractType" runat="server" FieldLabel="(1) Contract Type">
                                                            <Items>
                                                                <ext:Radio ID="radioDistributor" runat="server" BoxLabel="Distributor" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioDealer" runat="server" BoxLabel="Dealer" Checked="false" ReadOnly="true" />
                                                                <ext:Radio ID="radioAgent" runat="server" BoxLabel="Agent" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:RadioGroup ID="rgBscEntity" runat="server" FieldLabel="(2) BSC Entity">
                                                            <Items>
                                                                <ext:Radio ID="radioChina" runat="server" BoxLabel="China" Checked="false" ReadOnly="true" />
                                                                <ext:Radio ID="radioHongKong" runat="server" BoxLabel="Hong Kong" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioInternational" runat="server" BoxLabel="International" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:RadioGroup ID="rgExclusiveness" runat="server" FieldLabel="(3) Exclusiveness">
                                                            <Items>
                                                                <ext:Radio ID="radioExclusive" runat="server" BoxLabel="Exclusive" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioNonExclusive" runat="server" BoxLabel="Non-Exclusive" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioHidden" runat="server" BoxLabel="" Checked="false" Hidden="true"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel30" runat="server" Border="false">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout11" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="0.15">
                                                                        <ext:Panel ID="Panel27" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout13" runat="server" LabelWidth="100">
                                                                                    <ext:Anchor Horizontal="60%">
                                                                                        <ext:Label ID="lbAgreementTerm" runat="server" Text="(4) Agreement Term:" HideLabel="true" />
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth="0.25">
                                                                        <ext:Panel ID="Panel28" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout14" runat="server" LabelWidth="100">
                                                                                    <ext:Anchor>
                                                                                        <ext:DateField ID="dfEffective" runat="server" FieldLabel="Effective Date" Enabled="false">
                                                                                        </ext:DateField>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth="0.25">
                                                                        <ext:Panel ID="Panel29" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout15" runat="server" LabelWidth="100">
                                                                                    <ext:Anchor>
                                                                                        <ext:DateField ID="dfExpiration" runat="server" FieldLabel="Expiration Date" Enabled="false">
                                                                                        </ext:DateField>
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
                                                        <ext:Panel ID="Panel53" runat="server" Border="false">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout18" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="0.2">
                                                                        <ext:Panel ID="Panel55" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout23" runat="server" LabelWidth="150">
                                                                                    <ext:Anchor Horizontal="60%">
                                                                                        <ext:Label ID="Label2" runat="server" Text="(5) Product Line (if partial, please list):"
                                                                                            HideLabel="true" />
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                                        <ext:Panel ID="Panel62" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout29" runat="server" LabelWidth="100">
                                                                                    <ext:Anchor>
                                                                                        <ext:RadioGroup ID="rgProductLine" runat="server" HideLabel="true">
                                                                                            <Items>
                                                                                                <ext:Radio ID="radioProductLineAll" runat="server" BoxLabel="All products of Urology"
                                                                                                    Checked="false" ReadOnly="true" />
                                                                                                <ext:Radio ID="radioProductLinePartial" runat="server" BoxLabel="Partial" Checked="false"
                                                                                                    ReadOnly="true" />
                                                                                            </Items>
                                                                                        </ext:RadioGroup>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth="0.4">
                                                                        <ext:Panel ID="Panel63" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout30" runat="server">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="ProductLineText" runat="server" HideLabel="true" Width="300" ReadOnly="true">
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
                                                        <ext:Panel ID="Panel64" runat="server" Border="false">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout22" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="0.15">
                                                                        <ext:Panel ID="Panel66" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout32" runat="server" LabelWidth="150">
                                                                                    <ext:Anchor>
                                                                                        <ext:Label ID="Label7" runat="server" Text="(6) Pricing:" HideLabel="true" />
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth="0.15">
                                                                        <ext:Panel ID="Panel71" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout35" runat="server" LabelWidth="50">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfPricing" runat="server" FieldLabel="Discount" Width="100" ReadOnly="true"
                                                                                            LabelSeparator="">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfRebate" runat="server" FieldLabel="Rebate" Width="100" ReadOnly="true"
                                                                                            LabelSeparator="">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth="0.2">
                                                                        <ext:Panel ID="Panel65" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout31" runat="server" LabelWidth="100">
                                                                                    <ext:Anchor Horizontal="60%">
                                                                                        <ext:Label ID="Label1" runat="server" Text="% off standard price list." HideLabel="true" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor Horizontal="60%">
                                                                                        <ext:Label ID="Label9" runat="server" Text="% of the quarter purchase ammount." HideLabel="true" />
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth="0.5">
                                                                        <ext:Panel ID="Panel70" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout34" runat="server" LabelWidth="50">
                                                                                    <ext:Anchor Horizontal="60%">
                                                                                        <ext:TextField ID="tfDiscountRemarks" runat="server" FieldLabel="Remarks" Width="200"
                                                                                            ReadOnly="true">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor Horizontal="60%">
                                                                                        <ext:TextField ID="tfRebateRemarks" runat="server" FieldLabel="Remarks" Width="200"
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
                                                        <ext:Label ID="lbTerritory" runat="server" Text="(7) Territory (Hospitals)" HideLabel="true" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="PanelArea" runat="server" Border="false" Hidden="true">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout25" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="0.5">
                                                                        <ext:Panel ID="Panel72" runat="server" Border="false" BodyStyle="padding-left:15px;">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout37" runat="server" LabelWidth="100">
                                                                                    <ext:Anchor Horizontal="45%">
                                                                                        <ext:GridPanel ID="GridPanel3" runat="server" StoreID="AreaStore" Border="true" AutoHeight="true"
                                                                                            Icon="Lorry" StripeRows="true" Title="Territory Renewal Term">
                                                                                            <ColumnModel ID="ColumnModel3" runat="server">
                                                                                                <Columns>
                                                                                                    <ext:Column ColumnID="Description" DataIndex="Description" Header="Territory " Width="200">
                                                                                                    </ext:Column>
                                                                                                </Columns>
                                                                                            </ColumnModel>
                                                                                            <SaveMask ShowMask="true" />
                                                                                            <LoadMask ShowMask="true" Msg="处理中" />
                                                                                        </ext:GridPanel>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:GridPanel ID="GridPanel5" runat="server" StoreID="ExcludeHospitalStore" Border="true"
                                                                                            AutoHeight="true" Icon="Lorry" StripeRows="true" Title="Exclude Hospital">
                                                                                            <ColumnModel ID="ColumnModel5" runat="server">
                                                                                                <Columns>
                                                                                                    <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="Exclude Territory (Hospitals)"
                                                                                                        Width="200">
                                                                                                    </ext:Column>
                                                                                                </Columns>
                                                                                            </ColumnModel>
                                                                                            <SelectionModel>
                                                                                                <ext:RowSelectionModel ID="RowSelectionModel5" runat="server" />
                                                                                            </SelectionModel>
                                                                                            <SaveMask ShowMask="true" />
                                                                                            <LoadMask ShowMask="true" Msg="处理中" />
                                                                                        </ext:GridPanel>
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
                                                        <ext:Panel ID="PanelAreaHHosPital" runat="server" Border="false">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout19" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="0.5">
                                                                        <ext:Panel ID="Panel57" runat="server" Border="false" BodyStyle="padding-left:15px;">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout25" runat="server" LabelWidth="100">
                                                                                    <ext:Anchor Horizontal="45%">
                                                                                        <ext:GridPanel ID="GridPanel4" runat="server" StoreID="TerritoryNew" Border="true"
                                                                                            AutoHeight="true" Icon="Lorry" StripeRows="true" Title="Territory (Hospitals) Renewal Term">
                                                                                            <ColumnModel ID="ColumnModel4" runat="server">
                                                                                                <Columns>
                                                                                                    <ext:Column ColumnID="ProductLine" DataIndex="ProductLine" Header="Product Line"
                                                                                                        Width="150" Hidden="true">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="Territory (Hospitals)"
                                                                                                        Width="200">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="DepartRemark" DataIndex="DepartRemark" Header="Remark" Width="300">
                                                                                                    </ext:Column>
                                                                                                </Columns>
                                                                                            </ColumnModel>
                                                                                            <SelectionModel>
                                                                                                <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" />
                                                                                            </SelectionModel>
                                                                                            <SaveMask ShowMask="true" />
                                                                                            <LoadMask ShowMask="true" Msg="处理中" />
                                                                                        </ext:GridPanel>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor Horizontal="60%">
                                                                                        <ext:Label ID="Label5" runat="server" HideLabel="true" />
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
                                                        <ext:Label ID="LabelQyotas" runat="server" Text="(8) Purchase Quotas By Dealer (CNY, exclude VAT)"
                                                            HideLabel="true" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel58" runat="server" Border="false">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout20" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="0.8">
                                                                        <ext:Panel ID="Panel59" runat="server" Border="false" BodyStyle="padding-left:15px;">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout26" runat="server">
                                                                                    <ext:Anchor Horizontal="95%">
                                                                                        <ext:GridPanel ID="GridPanel6" runat="server" StoreID="QuotaNew" Border="true" Icon="Lorry"
                                                                                            StripeRows="true" Width="500" Title="Purchase Quota  Renewal Term" AutoHeight="true">
                                                                                            <ColumnModel ID="ColumnModel6" runat="server">
                                                                                                <Columns>
                                                                                                    <ext:Column ColumnID="ProductLine" DataIndex="ProductLine" Header="Product Line"
                                                                                                        Width="110" Hidden="true">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="CCName" DataIndex="CCName" Header="Sub BU" Width="75">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="Year" DataIndex="Year" Header="Year" Width="75">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="Q1" DataIndex="Q1" Header="Q1" Width="75" Hidden="true">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="Q2" DataIndex="Q2" Header="Q2" Width="75" Hidden="true">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="Q3" DataIndex="Q3" Header="Q3" Width="75" Hidden="true">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="Q4" DataIndex="Q4" Header="Q4" Width="75" Hidden="true">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M1" DataIndex="M1" Header="January" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M2" DataIndex="M2" Header="February" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M3" DataIndex="M3" Header="March" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M4" DataIndex="M4" Header="April" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M5" DataIndex="M5" Header="May" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M6" DataIndex="M6" Header="June" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M7" DataIndex="M7" Header="July" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M8" DataIndex="M8" Header="August" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M9" DataIndex="M9" Header="September" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M10" DataIndex="M10" Header="October" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M11" DataIndex="M11" Header="November" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="M12" DataIndex="M12" Header="December" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="Total" Width="75">
                                                                                                    </ext:Column>
                                                                                                </Columns>
                                                                                            </ColumnModel>
                                                                                            <SelectionModel>
                                                                                                <ext:RowSelectionModel ID="RowSelectionModel6" runat="server" />
                                                                                            </SelectionModel>
                                                                                            <SaveMask ShowMask="true" />
                                                                                            <LoadMask ShowMask="true" Msg="处理中" />
                                                                                        </ext:GridPanel>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor Horizontal="60%">
                                                                                        <ext:Label ID="Label6" runat="server" HideLabel="true" />
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
                                                        <ext:Label ID="LabelQyotasForHosp" runat="server" Text="(9) Purchase Quotas By Hospital (CNY, exclude VAT)"
                                                            HideLabel="true" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="PanelQuotaHospital" runat="server" Border="false">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout24" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="0.8">
                                                                        <ext:Panel ID="Panel73" runat="server" Border="false" BodyStyle="padding-left:15px;">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout36" runat="server" LabelWidth="100">
                                                                                    <ext:Anchor Horizontal="95%">
                                                                                        <ext:GridPanel ID="GridPanel2" runat="server" StoreID="QuotaHospitalNew" Border="true"
                                                                                            Icon="Lorry" StripeRows="true" Width="500" Title="Purchase Quota  Renewal Term"
                                                                                            AutoHeight="true" AutoScroll="true">
                                                                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                                                                <Columns>
                                                                                                    <ext:Column ColumnID="CQName" DataIndex="CQName" Header="Product Hierarchy" Width="110">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="Hospital" Width="110">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="Year" DataIndex="Year" Header="Year" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="January" DataIndex="January" Header="January" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="February" DataIndex="February" Header="February" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="March" DataIndex="March" Header="March" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="April" DataIndex="April" Header="April" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="May" DataIndex="May" Header="May" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="June" DataIndex="June" Header="June" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="July" DataIndex="July" Header="July" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="August" DataIndex="August" Header="August" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="September" DataIndex="September" Header="September" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="October" DataIndex="October" Header="October" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="November" DataIndex="November" Header="November" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="December" DataIndex="December" Header="December" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="AmountY" DataIndex="AmountY" Header="Total" Width="70">
                                                                                                    </ext:Column>
                                                                                                </Columns>
                                                                                            </ColumnModel>
                                                                                            <SelectionModel>
                                                                                                <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" />
                                                                                            </SelectionModel>
                                                                                            <SaveMask ShowMask="true" />
                                                                                            <BottomBar>
                                                                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="QuotaHospitalNew"
                                                                                                    DisplayInfo="true" EmptyMsg="NoDate" />
                                                                                            </BottomBar>
                                                                                            <LoadMask ShowMask="true" Msg="处理中" />
                                                                                        </ext:GridPanel>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor Horizontal="60%">
                                                                                        <ext:Label ID="Label4" runat="server" HideLabel="true" />
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
                                                        <ext:Panel ID="PanelQuotaHospitalProduct" runat="server" Border="false">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout21" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="0.8">
                                                                        <ext:Panel ID="Panel61" runat="server" Border="false" BodyStyle="padding-left:15px;">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout28" runat="server" LabelWidth="100">
                                                                                    <ext:Anchor Horizontal="95%">
                                                                                        <ext:GridPanel ID="GridPanel1" runat="server" StoreID="QuotaHospitalProductNew" Border="true"
                                                                                            Icon="Lorry" StripeRows="true" Width="500" Title="Purchase Quota  Renewal Term"
                                                                                            AutoHeight="true" AutoScroll="true">
                                                                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                                                                <Columns>
                                                                                                    <ext:Column ColumnID="ProductClassName" DataIndex="ProductClassName" Header="Product Hierarchy"
                                                                                                        Width="110">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="Hospital" Width="110">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="Year" DataIndex="Year" Header="Year" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="January" DataIndex="January" Header="January" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="February" DataIndex="February" Header="February" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="March" DataIndex="March" Header="March" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="April" DataIndex="April" Header="April" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="May" DataIndex="May" Header="May" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="June" DataIndex="June" Header="June" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="July" DataIndex="July" Header="July" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="August" DataIndex="August" Header="August" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="September" DataIndex="September" Header="September" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="October" DataIndex="October" Header="October" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="November" DataIndex="November" Header="November" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="December" DataIndex="December" Header="December" Width="70">
                                                                                                    </ext:Column>
                                                                                                    <ext:Column ColumnID="AmountY" DataIndex="AmountY" Header="Total" Width="70">
                                                                                                    </ext:Column>
                                                                                                </Columns>
                                                                                            </ColumnModel>
                                                                                            <SelectionModel>
                                                                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                                                                            </SelectionModel>
                                                                                            <SaveMask ShowMask="true" />
                                                                                            <BottomBar>
                                                                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="QuotaHospitalProductNew"
                                                                                                    DisplayInfo="true" EmptyMsg="NoDate" />
                                                                                            </BottomBar>
                                                                                            <LoadMask ShowMask="true" Msg="处理中" />
                                                                                        </ext:GridPanel>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor Horizontal="60%">
                                                                                        <ext:Label ID="Label8" runat="server" HideLabel="true" />
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
                                                        <ext:TextField ID="tfSpecialSales" runat="server" FieldLabel="(10) Special Sales Programs"
                                                            Hidden="true" Width="350" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfPaymentTerm" runat="server" FieldLabel="(10) Payment Term" Width="350"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfCreditLimit" runat="server" FieldLabel="(11) Credit Limit" Width="350"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfSecurityDeposit" runat="server" FieldLabel="(12) Security Deposit"
                                                            Width="350" ReadOnly="true">
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
        <ext:Panel ID="Panel31" runat="server" Header="true" Title="For National Channel Manager:   Please Complete Section 6- 11"
            Frame="true" Icon="Application" AutoHeight="true" AutoScroll="true" Collapsible="true"
            BodyStyle="padding:10px;">
            <Body>
                <ext:Panel ID="Panel32" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="6.  Independent Interview & Site Check">
                    <Body>
                        <ext:Panel ID="Panel35" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout12" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel36" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout17" runat="server" LabelWidth="120">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="tfInterviewTime" runat="server" FieldLabel="Time of Interview"
                                                            Enabled="false">
                                                        </ext:DateField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel37" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout18" runat="server" LabelWidth="70">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfVenue" runat="server" FieldLabel="Venue" Width="150" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".4">
                                        <ext:Panel ID="Panel33" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout16" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfInterviewee" runat="server" FieldLabel="Interviewee" Width="150"
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
                        <ext:Panel ID="Panel38" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout13" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel39" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout19" runat="server" LabelWidth="120">
                                                    <ext:Anchor>
                                                        <ext:Label ID="lbFindings" runat="server" HideLabel="true" Text="If there are any particular findings during the interview and site check, please list here:">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfFindings" runat="server" FieldLabel="Findings" Width="300" ReadOnly="true">
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
                <ext:Panel ID="Panel67" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="7. COC/Quality Traning">
                    <Body>
                        <ext:Panel ID="Panel68" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout23" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel69" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout33" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="dfTraningDate" runat="server" FieldLabel="COC/Quality Traning"
                                                            Enabled="false">
                                                        </ext:DateField>
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
                <ext:Panel ID="Panel34" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="8.  Non-Compete Requirement">
                    <Body>
                        <ext:Panel ID="Panel40" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout10" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel42" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout21" runat="server" LabelWidth="300">
                                                    <ext:Anchor Horizontal="45%">
                                                        <ext:RadioGroup ID="rgCompetingProduct" runat="server" FieldLabel="Does the dealer have sub-dealers currently"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioCompetingProductYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioCompetingProductNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfCompetingProduct" runat="server" FieldLabel="If yes, please state here"
                                                            Width="300" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="lbCompetingProductRemark" runat="server" HideLabel="true" Text="(If yes, please ask the dealer to provide a Non-Compete Commitment before appointment process)">
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
                <ext:Panel ID="Panel43" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="9.  Sub-Dealers">
                    <Body>
                        <ext:Panel ID="Panel46" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout15" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel48" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="300">
                                                    <ext:Anchor Horizontal="45%">
                                                        <ext:RadioGroup ID="rgSubDealer" runat="server" FieldLabel="Does the dealer have sub-dealers currently"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioSubDealerYes" runat="server" BoxLabel="Yes" Checked="false" ReadOnly="true" />
                                                                <ext:Radio ID="radioSubDealerNo" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="lbSubDealerRemark" runat="server" HideLabel="true" Text="(If yes, please inform the dealer that our agreement does not allow sub-dealers without BSC prior authorizations )">
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
                <ext:Panel ID="Panel51" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="10.  FCPA Concerns">
                    <Body>
                        <ext:Panel ID="Panel52" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout17" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel54" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout27" runat="server" LabelWidth="300">
                                                    <ext:Anchor Horizontal="45%">
                                                        <ext:RadioGroup ID="rgGovernmentOfficials" runat="server" FieldLabel="(1)  Recommended by Government Officials"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioGovernmentOfficialsYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioGovernmentOfficialsNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="45%">
                                                        <ext:RadioGroup ID="rgCompanyGovernment" runat="server" FieldLabel="(2)  Company Has Government Background"
                                                            LabelSeparator="?" ReadOnly="true">
                                                            <Items>
                                                                <ext:Radio ID="radioCompanyGovernmentYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioCompanyGovernmentNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="45%">
                                                        <ext:RadioGroup ID="rgShareholdersGovernment" runat="server" FieldLabel="(3)  Shareholders Have Government Background"
                                                            LabelSeparator="?" ReadOnly="true">
                                                            <Items>
                                                                <ext:Radio ID="rgShareholdersGovernmentYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="rgShareholdersGovernmentNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="lbOthers" runat="server" FieldLabel="(4)  Others (please illustrate)"
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
                <ext:Panel ID="Panel41" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="11.  Conflict of Interest">
                    <Body>
                        <ext:Panel ID="Panel44" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout14" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel45" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout20" runat="server" LabelWidth="300">
                                                    <ext:Anchor Horizontal="45%">
                                                        <ext:RadioGroup ID="rgConflict" runat="server" FieldLabel="Does the dealer have conflict of interest issues </br> with BSC current employees"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioConflictYes" runat="server" BoxLabel="Yes" Checked="false" ReadOnly="true" />
                                                                <ext:Radio ID="radioConflictNo" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfConflict" runat="server" FieldLabel="If yes, please state here"
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
                <ext:Panel ID="Panel47" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="12.  Conflict of Other Exclusive Dealers">
                    <Body>
                        <ext:Panel ID="Panel49" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout16" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel50" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout22" runat="server" LabelWidth="300">
                                                    <ext:Anchor Horizontal="45%">
                                                        <ext:RadioGroup ID="rgOtherExclusiveDealers" runat="server" FieldLabel="Does the business proposal above have conflicts </br> with any other current exclusive dealer's contract terms"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioOtherExclusiveDealersYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioOtherExclusiveDealersNo" runat="server" BoxLabel="No" Checked="false"
                                                                    ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tbOtherExclusiveDealers" runat="server" FieldLabel="If yes, please state here"
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
    </div>
    </form>
</body>
</html>
