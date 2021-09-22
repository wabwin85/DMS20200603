<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractAppendix2.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractAppendix2" %>

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
    <ext:Store ID="TerritoryOld" runat="server" OnRefreshData="Store_RefreshTerritoryOld">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="HospitalName">
                <Fields>
                    <ext:RecordField Name="HospitalName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="TerritoryNew" runat="server" OnRefreshData="Store_RefreshTerritoryNew">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="HospitalName">
                <Fields>
                    <ext:RecordField Name="HospitalName" />
                    <ext:RecordField Name="DepartRemark" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="QuotaOld" runat="server" OnRefreshData="Store_RefreshQuotaOld">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Year" />
                    <ext:RecordField Name="Q1" />
                    <ext:RecordField Name="Q2" />
                    <ext:RecordField Name="Q3" />
                    <ext:RecordField Name="Q4" />
                    <ext:RecordField Name="Amount_1" />
                    <ext:RecordField Name="Amount_2" />
                    <ext:RecordField Name="Amount_3" />
                    <ext:RecordField Name="Amount_4" />
                    <ext:RecordField Name="Amount_5" />
                    <ext:RecordField Name="Amount_6" />
                    <ext:RecordField Name="Amount_7" />
                    <ext:RecordField Name="Amount_8" />
                    <ext:RecordField Name="Amount_9" />
                    <ext:RecordField Name="Amount_10" />
                    <ext:RecordField Name="Amount_11" />
                    <ext:RecordField Name="Amount_12" />
                    <ext:RecordField Name="Amount_Y" />
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
    <ext:Store ID="QuotaHospitalOld" runat="server" OnRefreshData="Store_RefreshQuotaHospitalOld">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="ProductLine" />
                    <ext:RecordField Name="HospitalId" />
                    <ext:RecordField Name="HospitalName" />
                    <ext:RecordField Name="ProductClass" />
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
                    <ext:RecordField Name="ProductLine" />
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
    <ext:Store ID="AOPHopsptalProductOld" runat="server" OnRefreshData="AOPHopsptalProductOld_RefershData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="HospitalId" />
                    <ext:RecordField Name="HospitalName" />
                    <ext:RecordField Name="ProductClass" />
                    <ext:RecordField Name="ProductClassName" />
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
                    <ext:RecordField Name="Amount_Y" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="AopHospitalProductNew" runat="server" OnRefreshData="AOPHopsptalProductNew_RefershData">
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
                    <ext:RecordField Name="Description" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="ExcludeHospitalStoreOld" runat="server" UseIdConfirmation="false"
        OnRefreshData="ExcludeHospitalStoreOld_RefershData" AutoLoad="true">
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
    <ext:Store ID="AreaStoreOld" runat="server" UseIdConfirmation="false" OnRefreshData="AreaStoreOld_OnRefreshData">
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
    <ext:Hidden ID="hdContractID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdCmID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDmaId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDivisionId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdIsEmerging" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdSubDepCode" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDealerType" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdContStatus" runat="server">
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
                        <ext:Button ID="btnCreatePdf" runat="server" Text="生成Appendix2 PDF" Icon="PageWhiteAcrobat"
                            AutoPostBack="true" OnClick="CreatePdf">
                        </ext:Button>
                        <ext:Button ID="btnSupplementary" runat="server" Text="生成补充协议" Icon="PageExcel" Hidden="true">
                            <Listeners>
                                <Click Handler="window.open('PrintPage.aspx?ContractID='+#{hdContractID}.getValue()+'&DealerID='+#{hdDmaId}.getValue());" />
                            </Listeners>
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
                                                            ReadOnly="true" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel12" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelWidth="160">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="dfAgreeExpirationDate" runat="server" Width="120" FieldLabel="Agreement Expiration Date"
                                                            ReadOnly="true" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".4">
                                        <ext:Panel ID="Panel16" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="160">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="dfAmendEffectiveDate" runat="server" Width="120" FieldLabel=" Amendment Effective Date"
                                                            ReadOnly="true" />
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
                                <ext:ColumnLayout ID="ColumnLayout10" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel33" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout14" runat="server" LabelWidth="160">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfAmendmentReasons" runat="server" FieldLabel="Purpose" Width="500"
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
                <ext:Panel ID="Panel18" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="3.  Agreement Term Amendment Descriptions">
                    <Body>
                        <ext:Panel ID="Panel2" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel4" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:Checkbox ID="cbStandard" runat="server" BoxLabel="Standard Term Amendment" HideLabel="true"
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
                        <ext:Panel ID="Panel30" runat="server">
                            <Body>
                                <ext:Panel ID="Panel46" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="150">
                                            <ext:Anchor>
                                                <ext:Checkbox ID="cbTerritory" runat="server" BoxLabel="Territory (Hospitals)" HideLabel="true"
                                                    ReadOnly="true">
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:Panel ID="Panel35" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout11" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".5">
                                                <ext:Panel ID="Panel51" runat="server" Border="true" Height="400" AutoScroll="true">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout16" runat="server">
                                                            <ext:Anchor>
                                                                <ext:GridPanel ID="gpTerritoryOld" runat="server" StoreID="TerritoryOld" Border="true"
                                                                    AutoScroll="true" Height="398" Icon="Lorry" StripeRows="true" Width="500" Title="Original Agreement Term">
                                                                    <ColumnModel ID="ColumnModel3" runat="server">
                                                                        <Columns>
                                                                            <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="Territory (Hospitals) "
                                                                                Width="200">
                                                                            </ext:Column>
                                                                        </Columns>
                                                                    </ColumnModel>
                                                                    <SelectionModel>
                                                                        <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" />
                                                                    </SelectionModel>
                                                                    <SaveMask ShowMask="true" />
                                                                    <LoadMask ShowMask="true" Msg="处理中" />
                                                                </ext:GridPanel>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:GridPanel ID="gpAreaOld" runat="server" StoreID="AreaStoreOld" Border="true"
                                                                    Hidden="true" Height="150" AutoScroll="true" Icon="Lorry" StripeRows="true" Title="Original Agreement Term">
                                                                    <ColumnModel ID="ColumnModel11" runat="server">
                                                                        <Columns>
                                                                            <ext:Column ColumnID="Description" DataIndex="Description" Header="Territory " Width="200">
                                                                            </ext:Column>
                                                                        </Columns>
                                                                    </ColumnModel>
                                                                    <SelectionModel>
                                                                        <ext:RowSelectionModel ID="RowSelectionModel11" runat="server" />
                                                                    </SelectionModel>
                                                                    <SaveMask ShowMask="true" />
                                                                    <LoadMask ShowMask="true" Msg="处理中" />
                                                                </ext:GridPanel>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:GridPanel ID="gpExcludeHosOld" runat="server" StoreID="ExcludeHospitalStoreOld"
                                                                    Hidden="true" Border="true" Height="248" AutoScroll="true" Icon="Lorry" StripeRows="true"
                                                                    Title="Exclude Hospital">
                                                                    <ColumnModel ID="ColumnModel12" runat="server">
                                                                        <Columns>
                                                                            <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="Exclude Territory (Hospitals)"
                                                                                Width="200">
                                                                            </ext:Column>
                                                                        </Columns>
                                                                    </ColumnModel>
                                                                    <SelectionModel>
                                                                        <ext:RowSelectionModel ID="RowSelectionModel12" runat="server" />
                                                                    </SelectionModel>
                                                                    <SaveMask ShowMask="true" />
                                                                    <LoadMask ShowMask="true" Msg="处理中" />
                                                                </ext:GridPanel>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".5">
                                                <ext:Panel ID="Panel37" runat="server" Border="true" Height="400" AutoScroll="true">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout20" runat="server">
                                                            <ext:Anchor>
                                                                <ext:GridPanel ID="gpTerritoryNew" runat="server" StoreID="TerritoryNew" Border="true"
                                                                    Height="398" AutoScroll="true" Icon="Lorry" StripeRows="true" Width="500" Title="Changed To">
                                                                    <ColumnModel ID="ColumnModel4" runat="server">
                                                                        <Columns>
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
                                                            <ext:Anchor>
                                                                <ext:GridPanel ID="gpAreaNew" runat="server" StoreID="AreaStore" Border="true" Height="150"
                                                                    Hidden="true" AutoScroll="true" Icon="Lorry" StripeRows="true" Title="Changed To">
                                                                    <ColumnModel ID="ColumnModel9" runat="server">
                                                                        <Columns>
                                                                            <ext:Column ColumnID="Description" DataIndex="Description" Header="Territory " Width="200">
                                                                            </ext:Column>
                                                                        </Columns>
                                                                    </ColumnModel>
                                                                    <SelectionModel>
                                                                        <ext:RowSelectionModel ID="RowSelectionModel9" runat="server" />
                                                                    </SelectionModel>
                                                                    <SaveMask ShowMask="true" />
                                                                    <LoadMask ShowMask="true" Msg="处理中" />
                                                                </ext:GridPanel>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:GridPanel ID="gpExcludeHosNew" runat="server" StoreID="ExcludeHospitalStore"
                                                                    Hidden="true" Border="true" Height="248" AutoScroll="true" Icon="Lorry" StripeRows="true"
                                                                    Title="Exclude Hospital">
                                                                    <ColumnModel ID="ColumnModel10" runat="server">
                                                                        <Columns>
                                                                            <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="Exclude Territory (Hospitals)"
                                                                                Width="200">
                                                                            </ext:Column>
                                                                        </Columns>
                                                                    </ColumnModel>
                                                                    <SelectionModel>
                                                                        <ext:RowSelectionModel ID="RowSelectionModel10" runat="server" />
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
                                <ext:Panel ID="Panel38" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout30" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".5">
                                                <ext:Panel ID="Panel39" runat="server" Border="false" BodyStyle="padding:10px;">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout18" runat="server">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfTerritoryRemarks" runat="server" Width="380" FieldLabel=" Remarks"
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
                                <ext:Panel ID="Panel47" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout25" runat="server" LabelWidth="150">
                                            <ext:Anchor>
                                                <ext:Checkbox ID="cbQuota" runat="server" BoxLabel="Purchase Quota (CNY, exclude VAT)"
                                                    HideLabel="true" ReadOnly="true">
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:Panel ID="Panel40" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout14" runat="server">
                                            <ext:LayoutColumn ColumnWidth="1">
                                                <ext:Panel ID="Panel41" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout19" runat="server">
                                                            <ext:Anchor Horizontal="95%">
                                                                <ext:GridPanel ID="gpQuotaOld" runat="server" StoreID="QuotaOld" Border="true" Icon="Lorry"
                                                                    StripeRows="true"  Title="Original Agreement Term" AutoHeight="true">
                                                                    <ColumnModel ID="ColumnModel5" runat="server">
                                                                        <Columns>
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
                                                                            <ext:Column ColumnID="Amount_1" DataIndex="Amount_1" Header="January" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_2" DataIndex="Amount_2" Header="February" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_3" DataIndex="Amount_3" Header="March" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_4" DataIndex="Amount_4" Header="April" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_5" DataIndex="Amount_5" Header="May" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_6" DataIndex="Amount_6" Header="June" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_7" DataIndex="Amount_7" Header="July" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_8" DataIndex="Amount_8" Header="August" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_9" DataIndex="Amount_9" Header="September" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_10" DataIndex="Amount_10" Header="October" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_11" DataIndex="Amount_11" Header="November" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_12" DataIndex="Amount_12" Header="December" Width="70">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="Total" Width="75">
                                                                            </ext:Column>
                                                                        </Columns>
                                                                    </ColumnModel>
                                                                    <SelectionModel>
                                                                        <ext:RowSelectionModel ID="RowSelectionModel5" runat="server" />
                                                                    </SelectionModel>
                                                                    <LoadMask ShowMask="true" Msg="处理中" />
                                                                </ext:GridPanel>
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="95%">
                                                                <ext:GridPanel ID="gpQuotaNew" runat="server" StoreID="QuotaNew" Border="true" Icon="Lorry"
                                                                    StripeRows="true"  Title="Changed To" AutoHeight="true">
                                                                    <ColumnModel ID="ColumnModel6" runat="server">
                                                                        <Columns>
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
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:Panel ID="Panel43" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout15" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".5">
                                                <ext:Panel ID="Panel44" runat="server" Border="false" BodyStyle="padding:10px;">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout21" runat="server">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfQuotaRemarks" runat="server" Width="380" FieldLabel=" Remarks"
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
                                <ext:Panel ID="Panel48" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout26" runat="server" LabelWidth="150">
                                            <ext:Anchor>
                                                <ext:Checkbox ID="cbQuotaHospital" runat="server" BoxLabel="Purchase Quota By Hospital (CNY, exclude VAT)"
                                                    HideLabel="true" ReadOnly="true">
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:Panel ID="Panel49" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout13" runat="server">
                                            <ext:LayoutColumn ColumnWidth="1">
                                                <ext:Panel ID="Panel50" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout27" runat="server">
                                                            <ext:Anchor Horizontal="95%">
                                                                <ext:GridPanel ID="gpQuotaHospitalOld" runat="server" StoreID="QuotaHospitalOld"
                                                                    Hidden="false" Border="true" Icon="Lorry" StripeRows="true"  Title="Original Agreement Term"
                                                                    AutoHeight="true">
                                                                    <ColumnModel ID="ColumnModel7" runat="server">
                                                                        <Columns>
                                                                            <ext:Column ColumnID="ProductClass" DataIndex="ProductClass" Header="Product Hierarchy"
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
                                                                            <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="Total" Width="70">
                                                                            </ext:Column>
                                                                        </Columns>
                                                                    </ColumnModel>
                                                                    <SelectionModel>
                                                                        <ext:RowSelectionModel ID="RowSelectionModel7" runat="server" />
                                                                    </SelectionModel>
                                                                    <BottomBar>
                                                                        <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="10" StoreID="QuotaHospitalOld"
                                                                            DisplayInfo="true" EmptyMsg="NoDate" />
                                                                    </BottomBar>
                                                                    <LoadMask ShowMask="true" Msg="处理中" />
                                                                </ext:GridPanel>
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="95%">
                                                                <ext:GridPanel ID="gpHospitalProductOld" runat="server" StoreID="AOPHopsptalProductOld"
                                                                    Hidden="false" Border="true" Icon="Lorry" StripeRows="true"  Title="Original Agreement Term"
                                                                    AutoHeight="true">
                                                                    <ColumnModel ID="ColumnModel1" runat="server">
                                                                        <Columns>
                                                                            <ext:Column ColumnID="ProductClassName" DataIndex="ProductClassName" Header="Product Hierarchy">
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
                                                                            <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="Total" Width="70">
                                                                            </ext:Column>
                                                                        </Columns>
                                                                    </ColumnModel>
                                                                    <SelectionModel>
                                                                        <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                                                    </SelectionModel>
                                                                    <BottomBar>
                                                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="AOPHopsptalProductOld"
                                                                            DisplayInfo="true" EmptyMsg="No Data " />
                                                                    </BottomBar>
                                                                    <LoadMask ShowMask="true" Msg="处理中..." />
                                                                </ext:GridPanel>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:Panel ID="Panel54" runat="server" Height="5">
                                </ext:Panel>
                                <ext:Panel ID="Panel52" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout16" runat="server">
                                            <ext:LayoutColumn ColumnWidth="1">
                                                <ext:Panel ID="Panel53" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout28" runat="server">
                                                            <ext:Anchor Horizontal="95%">
                                                                <ext:GridPanel ID="gpQuotaHospitalNew" runat="server" StoreID="QuotaHospitalNew"
                                                                    Hidden="false" Border="true" Icon="Lorry" StripeRows="true"  Title="Changed To"
                                                                    AutoHeight="true" AutoScroll="true">
                                                                    <ColumnModel ID="ColumnModel8" runat="server">
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
                                                                        <ext:RowSelectionModel ID="RowSelectionModel8" runat="server" />
                                                                    </SelectionModel>
                                                                    <BottomBar>
                                                                        <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="10" StoreID="QuotaHospitalNew"
                                                                            DisplayInfo="true" EmptyMsg="NoDate" />
                                                                    </BottomBar>
                                                                    <SaveMask ShowMask="true" />
                                                                    <LoadMask ShowMask="true" Msg="处理中" />
                                                                </ext:GridPanel>
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="95%">
                                                                <ext:GridPanel ID="gpAopHospitalProductNew" runat="server" StoreID="AopHospitalProductNew"
                                                                    Border="true" Hidden="true" Icon="Lorry" StripeRows="true"  Title="Changed To"
                                                                    AutoHeight="true" AutoScroll="true">
                                                                    <ColumnModel ID="ColumnModel2" runat="server">
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
                                                                        <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" />
                                                                    </SelectionModel>
                                                                    <SaveMask ShowMask="true" />
                                                                    <BottomBar>
                                                                        <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="AopHospitalProductNew"
                                                                            DisplayInfo="true" EmptyMsg="No Date" />
                                                                    </BottomBar>
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
                                <ext:Panel ID="Panel55" runat="server" Height="5">
                                </ext:Panel>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel5" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".1">
                                        <ext:Panel ID="Panel10" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:Checkbox ID="cbProductLine" runat="server" BoxLabel="Product Line" HideLabel="true"
                                                            ReadOnly="true">
                                                        </ext:Checkbox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Checkbox ID="cbPrices" runat="server" BoxLabel="Prices" HideLabel="true" ReadOnly="true">
                                                        </ext:Checkbox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Checkbox ID="cbPayment" runat="server" BoxLabel="Payment Term" HideLabel="true"
                                                            ReadOnly="true">
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
                                                        <ext:TextField ID="tfProductLine" runat="server" Width="150" FieldLabel=" Original Agreement Term"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfOATPrices" runat="server" Width="150" FieldLabel=" Original Agreement Term"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfOATPayment" runat="server" Width="150" FieldLabel=" Original Agreement Term"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel14" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="130">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfChangedProductLine" runat="server" Width="150" FieldLabel=" Changed To"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfChangedPrices" runat="server" Width="150" FieldLabel=" Changed To"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfChangedPayment" runat="server" Width="150" FieldLabel=" Changed To"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel15" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout9" runat="server" LabelWidth="130">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfProductLineRemarks" runat="server" Width="150" FieldLabel=" Remarks"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfRemarksPrices" runat="server" Width="150" FieldLabel=" Remarks"
                                                            ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfRemarksPayment" runat="server" Width="150" FieldLabel=" Remarks"
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
                        <ext:Panel ID="Panel17" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel19" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout23" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:Checkbox ID="cbSpecialAmendment" runat="server" BoxLabel="<B>Special Program Amendment:</B>"
                                                            HideLabel="true" ReadOnly="true">
                                                        </ext:Checkbox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfSpecialAmendmentRemraks" runat="server" FieldLabel="Please State Here"
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
        <ext:Panel ID="Panel31" runat="server" Header="true" Title="For National Channel Manager:   Please Complete Section 4 - 6"
            Frame="true" Icon="Application" AutoHeight="true" AutoScroll="true" Collapsible="true"
            BodyStyle="padding:10px;">
            <Body>
                <ext:Panel ID="Panel21" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="4.  Conflict of Other Exclusive Dealers">
                    <Body>
                        <ext:Panel ID="Panel22" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.33">
                                        <ext:Panel ID="Panel23" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout11" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:Label ID="lbHasConflict1" runat="server" Text="If the business proposals above increase the current product line or territory of a dealer agreement, will it have "
                                                            HideLabel="true" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="lbHasConflict2" runat="server" Text="conflicts with any other current dealers' exclusive contract terms, or will it have potential conflicts with any newly"
                                                            HideLabel="true" />
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="30%">
                                                        <ext:RadioGroup ID="rgHasConflict" runat="server" FieldLabel="appointed dealers"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioHasConflictYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioHasConflictNo" runat="server" BoxLabel="No" Checked="false" ReadOnly="true" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfHasConflictRemarks" runat="server" Width="300" FieldLabel="If yes, please state it"
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
                    Title="5.  Business Handover">
                    <Body>
                        <ext:Panel ID="Panel25" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.33">
                                        <ext:Panel ID="Panel26" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout12" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:Label ID="lbBusinessHandover1" runat="server" Text="If the business proposals above cut down the current product line, territories or purchase quotas of a dealer agreement, "
                                                            HideLabel="true" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="lbBusinessHandover2" runat="server" Text=" who will take over the abandoned business from this dealer?"
                                                            HideLabel="true" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfBusinessHandover" runat="server" Width="300" FieldLabel="If so, please indicate"
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
                <%-- <ext:Panel ID="Panel27" runat="server" AutoHeight="true" FormGroup="true" BodyBorder="true"
                    Title="6.  Supplementary Letter Preparation">
                    <Body>
                        <ext:Panel ID="Panel28" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout9" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.33">
                                        <ext:Panel ID="Panel29" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout13" runat="server" LabelWidth="450">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgSupplementaryLetter" Width="200" runat="server" FieldLabel=" Have you drafted a supplementary letter and attached it to this form"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioSupplementaryLetterYes" runat="server" BoxLabel="Yes" Checked="false"
                                                                    ReadOnly="true" />
                                                                <ext:Radio ID="radioSupplementaryLetterNo" runat="server" BoxLabel="No" Checked="false"
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
