<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractForm3Equipment.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractForm3Equipment" %>

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

    <script type="text/javascript" language="javascript">
        var setAlldisabled = function() {
            document.getElementById("tfDealerNameCn").disabled = true;
            document.getElementById("tfAddress").disabled = true;
            document.getElementById("tfTelephony").disabled = true;
            document.getElementById("tfContactPerson").disabled = true;
            document.getElementById("tfCharter").disabled = true;
            document.getElementById("tfCountry").disabled = true;
            document.getElementById("tfFax").disabled = true;
            document.getElementById("tfWebsite").disabled = true;
            document.getElementById("tfContactEmail").disabled = true;

            document.getElementById("btnAddBusRefer").disabled = true;
            document.getElementById("btnAddMedicalDevices").disabled = true;
            document.getElementById("btnAddBusLicense").disabled = true;
            document.getElementById("btnAddSeniorCompany").disabled = true;
            document.getElementById("btnAddCompanyStockholder").disabled = true;
            document.getElementById("btnAddCorporateEntity").disabled = true;
            document.getElementById("btnAddPublicOffice").disabled = true;

            document.getElementById("btnSaveDraft").disabled = true;
            document.getElementById("btnSubmit").disabled = true;
        }
        var onFocus5 = function() {
            if (Ext.getCmp('tfWinSeniorCompanyIdentityCard').getValue() != '' && Ext.getCmp('tfWinSeniorCompanyIdentityCard').getValue().length != 18) {

                Ext.Msg.alert('Error', '国家居民ID填写错误');
            } else {
                if (Ext.getCmp('tfWinSeniorCompanyIdentityCard').getValue() != '') {
                    var birth = Ext.getCmp('tfWinSeniorCompanyIdentityCard').getValue().substring(6, 14);
                    var birthValue = birth.substring(0, 4) + '/' + birth.substring(4, 6) + '/' + birth.substring(6, 8);
                    Ext.getCmp('tfWinSeniorCompanyBirthday').setValue(birthValue);
                }
            }
        }
        var onFocus6 = function() {
            if (Ext.getCmp('tfWinCompanyStockholderIdentityCard').getValue() != '' && Ext.getCmp('tfWinCompanyStockholderIdentityCard').getValue().length != 18) {

                Ext.Msg.alert('Error', '国家居民ID填写错误');
            } else {
                if (Ext.getCmp('tfWinCompanyStockholderIdentityCard').getValue() != '') {
                    var birth = Ext.getCmp('tfWinCompanyStockholderIdentityCard').getValue().substring(6, 14);
                    var birthValue = birth.substring(0, 4) + '/' + birth.substring(4, 6) + '/' + birth.substring(6, 8);
                    Ext.getCmp('dfWinCompanyStockholderBirthday').setValue(birthValue);
                }
            }
        }
       var onFocus7 = function() {
            if (Ext.getCmp('tfIdentity').getValue() != '' && Ext.getCmp('tfIdentity').getValue().length != 18) {

                Ext.Msg.alert('Error', '国家居民ID填写错误');
            } else {
               
                  var birth = Ext.getCmp('tfIdentity').getValue().substring(6, 14);
                  var birthValue = birth.substring(0, 4) + '/' + birth.substring(4, 6) + '/' + birth.substring(6, 8);
                  Ext.getCmp('dfDate').setValue(birthValue);
                
            }
        }
        var MsgList = {
        DeleteItem:{
				ConfirmMsg2:"<%=GetLocalResourceObject("Part2.Operation.ConfirmDelete").ToString()%>",
				ConfirmMsg3:"<%=GetLocalResourceObject("Part3.Operation.ConfirmDelete").ToString()%>",
				ConfirmMsg4:"<%=GetLocalResourceObject("Part4.Operation.ConfirmDelete").ToString()%>",
				ConfirmMsg5:"<%=GetLocalResourceObject("Part5.Operation.ConfirmDelete").ToString()%>"
			}
        }
    </script>

    <ext:Store ID="MedicalDevicesStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshMedicalDevices">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CmId" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Describe" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="CreateUser" />
                    <ext:RecordField Name="UpdateDate" />
                    <ext:RecordField Name="UpdateUser" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="BusinessLicenseStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshBusinessLicense">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CmId" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Country" />
                    <ext:RecordField Name="AuthOrg" />
                    <ext:RecordField Name="RegisterDate" Type="Date" />
                    <ext:RecordField Name="RegisterNumber" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="CreateUser" />
                    <ext:RecordField Name="UpdateDate" />
                    <ext:RecordField Name="UpdateUser" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="SeniorCompanyStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshSeniorCompany">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CmId" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Position" />
                    <ext:RecordField Name="BusinessAddress" />
                    <ext:RecordField Name="Telephone" />
                    <ext:RecordField Name="Fax" />
                    <ext:RecordField Name="Email" />
                    <ext:RecordField Name="HomeAddress" />
                    <ext:RecordField Name="Pbumport" />
                    <ext:RecordField Name="IdentityCard" />
                    <ext:RecordField Name="Birthday" Type="Date" />
                    <ext:RecordField Name="Birthplace" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="CreateUser" />
                    <ext:RecordField Name="UpdateDate" />
                    <ext:RecordField Name="UpdateUser" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="CompanyStockholderStore" runat="server" UseIdConfirmation="false"
        OnRefreshData="Store_RefreshCompanyStockholder">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CmId" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Ownership" />
                    <ext:RecordField Name="BusinessAddress" />
                    <ext:RecordField Name="Telephone" />
                    <ext:RecordField Name="Fax" />
                    <ext:RecordField Name="Email" />
                    <ext:RecordField Name="HomeAddress" />
                    <ext:RecordField Name="Pbumport" />
                    <ext:RecordField Name="IdentityCard" />
                    <ext:RecordField Name="Birthday" Type="Date" />
                    <ext:RecordField Name="Birthplace" />
                    <ext:RecordField Name="Country" />
                    <ext:RecordField Name="Register" />
                    <ext:RecordField Name="Possessor" />
                    <ext:RecordField Name="MiddleEntity" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="CreateUser" />
                    <ext:RecordField Name="UpdateDate" />
                    <ext:RecordField Name="UpdateUser" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <form id="form1" runat="server">
    <div>
        <ext:Hidden ID="hdCmId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hdDealerId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hdCmStatus" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hdParamBus" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hdContStatus" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hdLicense" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hdSeniorCompany" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hdCompany" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hdCompanyValue" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hdDealerCnName" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hdParmetType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hdContId" runat="server">
        </ext:Hidden>
          <ext:Hidden ID="hdSignTp" runat="server">
        </ext:Hidden>
        <ext:Panel ID="btnPanel" runat="server" Header="false" Height="17">
            <TopBar>
                <ext:Toolbar ID="Toolbar10" runat="server">
                    <Items>
                        <ext:ToolbarFill />
                        <ext:Button ID="btnCreatePdf" runat="server" Text="生成IAF Form3 PDF" Icon="PageWhiteAcrobat"
                            AutoPostBack="true" OnClick="CreatePdf">
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </TopBar>
        </ext:Panel>
        <ext:Panel ID="plForm3" runat="server" Header="true" Title="<%$ Resources:From3.Title%>"
            Frame="true" Icon="Application" AutoHeight="true" AutoScroll="true" BodyStyle="padding:10px;"
            Collapsible="false">
            <Body>
                <%-- 1.公司信息 --%>
                <ext:Panel ID="Panel20" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part1.Title%>">
                    <Body>
                        <ext:Panel ID="Panel3" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.45">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfDealerNameCn" runat="server" FieldLabel="<%$ Resources:Part1.DealerName%>"
                                                            ReadOnly="true" Width="150" AllowBlank="false" BlankText="<%$ Resources:Part1.DealerName.BlankText%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfAddress" runat="server" FieldLabel="<%$ Resources:Part1.Address%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfTelephony" runat="server" FieldLabel="<%$ Resources:Part1.Telephony%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfContactPerson" runat="server" FieldLabel="<%$ Resources:Part1.ContactPerson%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfContactEmail" runat="server" FieldLabel="<%$ Resources:Part1.ContactEmail%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Hidden ID="hdDealerEnName" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.55">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfCharter" runat="server" FieldLabel="<%$ Resources:Part1.Charter%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfCountry" runat="server" FieldLabel="<%$ Resources:Part1.Country%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfFax" runat="server" FieldLabel="<%$ Resources:Part1.Fax%>" Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWebsite" runat="server" FieldLabel="<%$ Resources:Part1.Website%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel4" runat="server">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="0.4">
                                                                        <ext:Panel ID="Panel5" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="110">
                                                                                    <ext:Anchor>
                                                                                        <ext:RadioGroup ID="rgPubliclyTraded" runat="server" FieldLabel="<%$ Resources:Part1.PubliclyTraded%>"
                                                                                            LabelSeparator="?">
                                                                                            <Items>
                                                                                                <ext:Radio ID="radioPubliclyTradedYes" runat="server" BoxLabel="<%$ Resources:Part1.PubliclyTradedYes%>"
                                                                                                    Checked="false">
                                                                                                </ext:Radio>
                                                                                                <ext:Radio ID="radioPubliclyTradedNo" runat="server" BoxLabel="<%$ Resources:Part1.PubliclyTradedNo%>"
                                                                                                    Checked="false">
                                                                                                </ext:Radio>
                                                                                            </Items>
                                                                                        </ext:RadioGroup>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth="0.6">
                                                                        <ext:Panel ID="Panel6" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="150">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfExchange" runat="server" FieldLabel="<%$ Resources:Part1.Exchange%>"
                                                                                            LabelSeparator="?">
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
                    </Body>
                </ext:Panel>
                <ext:Panel ID="Panel9" runat="server" Header="false" Frame="true" Icon="Application"
                    AutoHeight="true" AutoScroll="true" BodyStyle="padding:0px;">
                    <Body>
                        <ext:Panel ID="Panel7" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel8" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="120">
                                                    <ext:Anchor>
                                                        <ext:Label ID="label1" runat="server" HideLabel="true" Text="<%$ Resources:Part1.Notes1%>">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="label2" runat="server" HideLabel="true" Text="<%$ Resources:Part1.Notes2%>">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="label4" runat="server" HideLabel="true" ItemCls="labelBold" Text="<%$ Resources:Part1.Notes3%>">
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
                <%-- 2.医疗器械或制药公司 --%>
                <ext:Panel ID="Panel11" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part2.Title%>">
                    <Body>
                        <ext:Label ID="label5" runat="server" Text="<%$ Resources:Part2.Notes1%>" />
                        <ext:GridPanel ID="gpMedicalDevices" runat="server" StoreID="MedicalDevicesStore"
                            Border="true" StripeRows="true" Header="false" Height="200">
                            <TopBar>
                                <ext:Toolbar ID="Toolbar2" runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnAddMedicalDevices" runat="server" Text="<%$ Resources:Part2.BtnAdd%>"
                                            Icon="Add">
                                            <Listeners>
                                                <Click Handler="Coolite.AjaxMethods.ShowMedicalDevicesWindow();" />
                                            </Listeners>
                                        </ext:Button>
                                    </Items>
                                </ext:Toolbar>
                            </TopBar>
                            <ColumnModel ID="ColumnModel2" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="150" Header="<%$ Resources:Part2.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Describe" DataIndex="Describe" Width="250" Header="<%$ Resources:Part2.Header.Describe%>">
                                    </ext:Column>
                                    <ext:CommandColumn Width="80" Header="<%$ Resources:Part2.Header.Operation%>" Align="Center">
                                        <Commands>
                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                <ToolTip Text="<%$ Resources:Part2.Operation.Detail%>" />
                                            </ext:GridCommand>
                                            <ext:CommandSeparator />
                                            <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                <ToolTip Text="<%$ Resources:Part2.Operation.Delete%>" />
                                            </ext:GridCommand>
                                        </Commands>
                                    </ext:CommandColumn>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" />
                            </SelectionModel>
                            <Listeners>
                                <Command Handler="if (command == 'Delete'){
                                                                Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg2,
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.DeleteMedicalDevicesItem(record.data.Id,{success:function(){#{gpMedicalDevices}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                    }});
                                                                }
                                                  else if (command == 'Edit'){
                                                                Coolite.AjaxMethods.EditMedicalDevicesItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                            </Listeners>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part2.Operation.Processing%>" />
                        </ext:GridPanel>
                    </Body>
                </ext:Panel>
                <%-- 3.营业执照、许可或登记情况 --%>
                <ext:Panel ID="Panel12" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part3.Title%>">
                    <Body>
                        <ext:Label ID="label6" runat="server" Text="<%$ Resources:Part3.Notes1%>" />
                        <ext:GridPanel ID="gpBusLicense" runat="server" StoreID="BusinessLicenseStore" Border="true"
                            StripeRows="true" Header="false" Height="200">
                            <TopBar>
                                <ext:Toolbar ID="Toolbar3" runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnAddBusLicense" runat="server" Text="<%$ Resources:Part3.BtnAdd%>"
                                            Icon="Add">
                                            <Listeners>
                                                <Click Handler="Coolite.AjaxMethods.ShowBusLicenseWindow();" />
                                            </Listeners>
                                        </ext:Button>
                                    </Items>
                                </ext:Toolbar>
                            </TopBar>
                            <ColumnModel ID="ColumnModel3" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="Country" DataIndex="Country" Width="150" Header="<%$ Resources:Part3.Header.Country%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="300" Header="<%$ Resources:Part3.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="AuthOrg" DataIndex="AuthOrg" Width="150" Header="<%$ Resources:Part3.Header.AuthOrg%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="RegisterDate" DataIndex="RegisterDate" Width="300" Header="<%$ Resources:Part3.Header.RegisterDate%>">
                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                    </ext:Column>
                                    <ext:Column ColumnID="RegisterNumber" DataIndex="RegisterNumber" Width="300" Header="<%$ Resources:Part3.Header.RegisterNumber%>">
                                    </ext:Column>
                                    <ext:CommandColumn Width="80" Header="<%$ Resources:Part3.Header.Operation%>" Align="Center">
                                        <Commands>
                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                <ToolTip Text="<%$ Resources:Part3.Operation.Detail%>" />
                                            </ext:GridCommand>
                                            <ext:CommandSeparator />
                                            <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                <ToolTip Text="<%$ Resources:Part3.Operation.Delete%>" />
                                            </ext:GridCommand>
                                        </Commands>
                                    </ext:CommandColumn>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" />
                            </SelectionModel>
                            <Listeners>
                                <Command Handler="if (command == 'Delete'){
                                                                Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg3,
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.DeleteBusLicenseItem(record.data.Id,{success:function(){#{gpBusLicense}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                    }});
                                                                }
                                                  else if (command == 'Edit'){
                                                                Coolite.AjaxMethods.EditBusLicenseItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                            </Listeners>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part3.Operation.Processing%>" />
                        </ext:GridPanel>
                    </Body>
                </ext:Panel>
                <%-- 4.公司董事及主要高层人员的背景信息 --%>
                <ext:Panel ID="Panel13" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part4.Title%>">
                    <Body>
                        <ext:Label ID="label7" runat="server" Text="<%$ Resources:Part4.Notes1%>" />
                        <ext:GridPanel ID="gpSeniorCompany" runat="server" StoreID="SeniorCompanyStore" Border="true"
                            StripeRows="true" Header="false" Height="200">
                            <TopBar>
                                <ext:Toolbar ID="Toolbar4" runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnAddSeniorCompany" runat="server" Text="<%$ Resources:Part4.BtnAdd%>"
                                            Icon="Add">
                                            <Listeners>
                                                <Click Handler="Coolite.AjaxMethods.ShowSeniorCompanyWindow();" />
                                            </Listeners>
                                        </ext:Button>
                                    </Items>
                                </ext:Toolbar>
                            </TopBar>
                            <ColumnModel ID="ColumnModel4" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources:Part4.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Position" DataIndex="Position" Header="<%$ Resources:Part4.Header.Position%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="BusinessAddress" DataIndex="BusinessAddress" Width="150" Header="<%$ Resources:Part4.Header.BusinessAddress%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Telephone" DataIndex="Telephone" Header="<%$ Resources:Part4.Header.Telephone%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Fax" DataIndex="Fax" Header="<%$ Resources:Part4.Header.Fax%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Email" DataIndex="Email" Header="<%$ Resources:Part4.Header.Email%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="HomeAddress" DataIndex="HomeAddress" Header="<%$ Resources:Part4.Header.HomeAddress%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Pbumport" DataIndex="Pbumport" Header="<%$ Resources:Part4.Header.Pbumport%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="IdentityCard" DataIndex="IdentityCard" Header="<%$ Resources:Part4.Header.IdentityCard%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Birthday" DataIndex="Birthday" Header="<%$ Resources:Part4.Header.Birthday%>">
                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                    </ext:Column>
                                    <ext:Column ColumnID="Birthplace" DataIndex="Birthplace" Header="<%$ Resources:Part4.Header.Birthplace%>">
                                    </ext:Column>
                                    <ext:CommandColumn Width="80" Header="<%$ Resources:Part4.Header.Operation%>" Align="Center">
                                        <Commands>
                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                <ToolTip Text="<%$ Resources:Part4.Operation.Detail%>" />
                                            </ext:GridCommand>
                                            <ext:CommandSeparator />
                                            <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                <ToolTip Text="<%$ Resources:Part4.Operation.Delete%>" />
                                            </ext:GridCommand>
                                        </Commands>
                                    </ext:CommandColumn>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" />
                            </SelectionModel>
                            <Listeners>
                                <Command Handler="if (command == 'Delete'){
                                                                Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg4,
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.DeleteSeniorCompanyItem(record.data.Id,{success:function(){#{gpSeniorCompany}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                    }});
                                                                }
                                                  else if (command == 'Edit'){
                                                                Coolite.AjaxMethods.EditSeniorCompanyItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                            </Listeners>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part4.Operation.Processing%>" />
                        </ext:GridPanel>
                    </Body>
                </ext:Panel>
                <%-- 5.公司所有人及股东的背景信息 --%>
                <ext:Panel ID="Panel14" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part5.Title%>">
                    <Body>
                        <ext:GridPanel ID="gpCompanyStockholder" runat="server" StoreID="CompanyStockholderStore"
                            Border="true" StripeRows="true" Header="false" Height="200">
                            <TopBar>
                                <ext:Toolbar ID="Toolbar5" runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnAddCompanyStockholder" runat="server" Text="<%$ Resources:Part5.BtnAdd%>"
                                            Icon="Add">
                                            <Listeners>
                                                <Click Handler="Coolite.AjaxMethods.ShowCompanyStockholderWindow();" />
                                            </Listeners>
                                        </ext:Button>
                                    </Items>
                                </ext:Toolbar>
                            </TopBar>
                            <ColumnModel ID="ColumnModel5" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources:Part5.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Ownership" DataIndex="Ownership" Header="<%$ Resources:Part5.Header.Ownership%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="BusinessAddress" DataIndex="BusinessAddress" Header="<%$ Resources:Part5.Header.BusinessAddress%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Telephone" DataIndex="Telephone" Header="<%$ Resources:Part5.Header.Telephone%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Fax" DataIndex="Fax" Header="<%$ Resources:Part5.Header.Fax%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Email" DataIndex="Email" Header="<%$ Resources:Part5.Header.Email%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="HomeAddress" DataIndex="HomeAddress" Header="<%$ Resources:Part5.Header.HomeAddress%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Pbumport" DataIndex="Pbumport" Header="<%$ Resources:Part5.Header.Pbumport%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="IdentityCard" DataIndex="IdentityCard" Header="<%$ Resources:Part5.Header.IdentityCard%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Birthday" DataIndex="Birthday" Header="<%$ Resources:Part5.Header.Birthday%>">
                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                    </ext:Column>
                                    <ext:Column ColumnID="Birthplace" DataIndex="Birthplace" Header="<%$ Resources:Part5.Header.Birthplace%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Country" DataIndex="Country" Header="<%$ Resources:Part5.Header.Country%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Register" DataIndex="Register" Header="<%$ Resources:Part5.Header.Register%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Possessor" DataIndex="Possessor" Header="<%$ Resources:Part5.Header.Possessor%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="MiddleEntity" DataIndex="MiddleEntity" Header="<%$ Resources:Part5.Header.MiddleEntity%>">
                                    </ext:Column>
                                    <ext:CommandColumn Width="80" Header="<%$ Resources:Part5.Header.Operation%>" Align="Center">
                                        <Commands>
                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                <ToolTip Text="<%$ Resources:Part5.Operation.Detail%>" />
                                            </ext:GridCommand>
                                            <ext:CommandSeparator />
                                            <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                <ToolTip Text="<%$ Resources:Part5.Operation.Delete%>" />
                                            </ext:GridCommand>
                                        </Commands>
                                    </ext:CommandColumn>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel5" runat="server" />
                            </SelectionModel>
                            <Listeners>
                                <Command Handler="if (command == 'Delete'){
                                                                Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg5,
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.DeleteCompanyStockholderItem(record.data.Id,{success:function(){#{gpCompanyStockholder}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                    }});
                                                                }
                                                  else if (command == 'Edit'){
                                                                Coolite.AjaxMethods.EditCompanyStockholderItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                            </Listeners>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part5.Operation.Processing%>" />
                        </ext:GridPanel>
                    </Body>
                </ext:Panel>
                <%-- 6.请提供银行账户的详细信息 --%>
                <ext:Panel ID="Panel16" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part6.Title%>">
                    <Body>
                        <ext:Panel ID="Panel15" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.45">
                                        <ext:Panel ID="Panel25" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfBankName" runat="server" FieldLabel="<%$ Resources:Part6.BankName%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfBankAddress" runat="server" FieldLabel="<%$ Resources:Part6.BankAddress%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfBankAccount" runat="server" FieldLabel="<%$ Resources:Part6.BankAccount%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.55">
                                        <ext:Panel ID="Panel10" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout11" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:Label runat="server" ID="lbPart6" FieldLabel="" HideLabel="true">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfBankCountry" runat="server" FieldLabel="<%$ Resources:Part6.BankCountry%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfBankSwift" runat="server" FieldLabel="<%$ Resources:Part6.BankSwift%>"
                                                            Width="150">
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
                <%-- 7.其他信息 --%>
                <ext:Panel ID="Panel17" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part9.Title%>">
                    <Body>
                        <ext:Panel ID="Panel18" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel19" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelWidth="500" LabelAlign="Left">
                                                    <ext:Anchor Horizontal="70%">
                                                        <ext:RadioGroup ID="rgProperty1" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioProperty1Yes" runat="server" BoxLabel="<%$ Resources:Part9.ConfirmationYes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioProperty1No" runat="server" BoxLabel="<%$ Resources:Part9.ConfirmationNo%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextArea ID="tfDesc1" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation.Detail%>"
                                                            Width="300" Height="50">
                                                        </ext:TextArea>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="70%">
                                                        <ext:RadioGroup ID="rgProperty2" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation2%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioProperty2Yes" runat="server" BoxLabel="<%$ Resources:Part9.ConfirmationYes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioProperty2No" runat="server" BoxLabel="<%$ Resources:Part9.ConfirmationNo%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextArea ID="tfDesc2" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation.Detail%>"
                                                            Width="300" Height="50">
                                                        </ext:TextArea>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="70%">
                                                        <ext:RadioGroup ID="rgProperty3" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation3%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioProperty3Yes" runat="server" BoxLabel="<%$ Resources:Part9.ConfirmationYes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioProperty3No" runat="server" BoxLabel="<%$ Resources:Part9.ConfirmationNo%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextArea ID="tfDesc3" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation.Detail%>"
                                                            Width="300" Height="50">
                                                        </ext:TextArea>
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
                <%-- 8.信息发布 --%>
                <ext:Panel ID="Panel21" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part10.Title%>">
                    <Body>
                        <ext:Panel ID="Panel22" runat="server" Header="false" Frame="true" Icon="Application"
                            AutoHeight="true" AutoScroll="true" BodyStyle="padding:0px;">
                            <Body>
                                <ext:Panel ID="Panel23" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                            <ext:LayoutColumn ColumnWidth="1">
                                                <ext:Panel ID="Panel24" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="120">
                                                            <ext:Anchor>
                                                                <ext:Label ID="label11" runat="server" HideLabel="true" Text="<%$ Resources:Part10.Notes1%>">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Label ID="label12" runat="server" HideLabel="true" Text="<%$ Resources:Part10.Notes2%>"
                                                                    ItemCls="labelBold">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Label ID="label13" runat="server" HideLabel="true" Text="<%$ Resources:Part10.Notes3%>">
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
                <%-- 9.签字名信息 --%>
                <ext:Panel ID="Panel38" runat="server" FormGroup="true" BodyBorder="true" Title="签名信息">
                    <Body>
                        <ext:GridPanel ID="gpPanelSign" runat="server" StoreID="CompanyStockholderStore"
                            Border="true" StripeRows="true" Header="false" Height="150" AutoScroll="true"  AutoExpandColumn="IdentityCard">
                            <ColumnModel ID="ColumnModel8" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources:Part5.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="IdentityCard" DataIndex="IdentityCard" Header="<%$ Resources:Part5.Header.IdentityCard%>">
                                    </ext:Column>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel8" runat="server" />
                            </SelectionModel>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part5.Operation.Processing%>" />
                        </ext:GridPanel>
                        <ext:Panel ID="Panel43" runat="server" Frame="true" Title="请给公司性质的股东指派信息确认人" AutoScroll="true"
                            BodyStyle="padding:0px;">
                            <Body>
                                <ext:Panel ID="Panel44" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout14" runat="server">
                                            <ext:LayoutColumn ColumnWidth="0.3">
                                                <ext:Panel ID="Panel45" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="100">
                                                            <ext:Anchor>
                                                                <ext:Label ID="lbThirdParty" runat="server" FieldLabel="公司名称">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfSignUserName" runat="server" FieldLabel="签字人">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth="0.3">
                                                <ext:Panel ID="Panel46" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout25" runat="server" LabelWidth="100">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfIdentity" runat="server" FieldLabel="居民身份证">
                                                                    <Listeners>
                                                                        <Blur Fn="onFocus7" />
                                                                    </Listeners>
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfSignTital" runat="server" FieldLabel="签字人职位">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth="0.4">
                                                <ext:Panel ID="Panel47" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout26" runat="server" LabelWidth="100">
                                                            <ext:Anchor>
                                                                <ext:DateField ID="dfDate" runat="server" FieldLabel="出生日期" ReadOnly="true" Disabled="true">
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
                    </Body>
                </ext:Panel>
            </Body>
            <Buttons>
                <ext:Button ID="btnSaveDraft" runat="server" Text="<%$ Resources:From3.Btn.Draft%>"
                    Icon="Disk">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveDraft()" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnSubmit" runat="server" Text="<%$ Resources:From3.Btn.Submit%>"
                    Icon="Tick" Hidden="true">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveSubmit();" />
                    </Listeners>
                </ext:Button>
                <%--  <ext:Button ID="btnCancel" runat="server" Text="取消" Icon="Delete" Hidden="true">
                    <Listeners>
                        <Click Handler="" />
                    </Listeners>
                </ext:Button>--%>
            </Buttons>
            <LoadMask ShowMask="true" Msg="<%$ Resources:From3.Processing%>" />
        </ext:Panel>
        <%-- 2.医疗器械或制药公司 --%>
        <ext:Hidden ID="hiddenWinMedicalDevicesDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowMedicalDevices" runat="server" Icon="Group" Title="<%$ Resources:Part2.Window.Title%>"
            Resizable="false" Header="false" Width="390" AutoHeight="true" AutoShow="false"
            Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout9" runat="server">
                    <ext:Anchor>
                        <ext:Panel ID="Panel27" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel28" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinMedicalDevicesName" runat="server" FieldLabel="<%$ Resources:Part2.Window.Name%>"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinMedicalDevicesDescribe" runat="server" FieldLabel="<%$ Resources:Part2.Window.Describe%>"
                                                            Width="220">
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
            <Buttons>
                <ext:Button ID="btnMedicalDevicesSubmit" runat="server" Text="<%$ Resources:Part2.Window.Btn.Submit%>"
                    Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveMedicalDevices();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnMedicalDevicesCancel" runat="server" Text="<%$ Resources:Part2.Window.Btn.Cancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowMedicalDevices}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <%-- 3.营业执照、许可或登记情况 --%>
        <ext:Hidden ID="hiddenWinBusLicenseDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowBusLicense" runat="server" Icon="Group" Title="<%$ Resources:Part3.Window.Title%>"
            Resizable="false" Header="false" Width="390" AutoHeight="true" AutoShow="false"
            Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout12" runat="server">
                    <ext:Anchor>
                        <ext:Panel ID="Panel29" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel30" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout13" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusLicenseCountry" runat="server" FieldLabel="<%$ Resources:Part3.Window.Country%>"
                                                            Width="170" LabelSeparator="">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusLicenseName" runat="server" FieldLabel="<%$ Resources:Part3.Window.Name%>"
                                                            Width="170" LabelSeparator="">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusLicenseAuthOrg" runat="server" FieldLabel="<%$ Resources:Part3.Window.AuthOrg%>"
                                                            Width="170">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="tfWinBusLicenseRegisterDate" runat="server" FieldLabel="<%$ Resources:Part3.Window.Date%>">
                                                        </ext:DateField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusLicenseRegisterNumber" runat="server" FieldLabel="<%$ Resources:Part3.Window.Number%>"
                                                            Width="170" LabelSeparator="">
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
            <Buttons>
                <ext:Button ID="btnBusLicenseSubmit" runat="server" Text="<%$ Resources:Part3.Window.Submit%>"
                    Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveBusLicense();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnBusLicenseCancel" runat="server" Text="<%$ Resources:Part3.Window.Cancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowBusLicense}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <%-- 4.公司董事及主要高层人员的背景信息 --%>
        <ext:Hidden ID="hiddenWinSeniorCompanyDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowSeniorCompany" runat="server" Icon="Group" Title="<%$ Resources:Part4.Window.Title%>"
            Resizable="false" Header="false" Width="430" AutoHeight="true" AutoShow="false"
            Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout14" runat="server">
                    <ext:Anchor>
                        <ext:Panel ID="Panel31" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout9" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel32" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout15" runat="server" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyName" runat="server" FieldLabel="<%$ Resources:Part4.Window.Name%>"
                                                            Width="200" AllowBlank="false" LabelSeparator="">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyPosition" runat="server" FieldLabel="<%$ Resources:Part4.Window.Position%>"
                                                            Width="200" AllowBlank="false" LabelSeparator="">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyBusinessAddress" runat="server" FieldLabel="<%$ Resources:Part4.Window.BusinessAddress%>"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyTelephone" runat="server" FieldLabel="<%$ Resources:Part4.Window.Telephone%>"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyFax" runat="server" FieldLabel="<%$ Resources:Part4.Window.Fax%>"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyEmail" runat="server" FieldLabel="<%$ Resources:Part4.Window.Email%>"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyHomeAddress" runat="server" FieldLabel="<%$ Resources:Part4.Window.HomeAddress%>"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyPbumport" runat="server" FieldLabel="<%$ Resources:Part4.Window.Pbumport%>"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyIdentityCard" runat="server" FieldLabel="<%$ Resources:Part4.Window.IdentityCard%>"
                                                            AllowBlank="false" BlankText="<%$ Resources:Part4.Window.IdentityCard.BlankText%>"
                                                            Width="200">
                                                            <Listeners>
                                                                <Blur Fn="onFocus5" />
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="tfWinSeniorCompanyBirthday" runat="server" FieldLabel="<%$ Resources:Part4.Window.Birthday%>"
                                                            Disabled="true">
                                                        </ext:DateField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyBirthplace" runat="server" FieldLabel="<%$ Resources:Part4.Window.Birthplace%>"
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
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Buttons>
                <ext:Button ID="btnSeniorCompanySubmit" runat="server" Text="<%$ Resources:Part4.Window.Submit%>"
                    Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveSeniorCompany();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnSeniorCompanyCancel" runat="server" Text="<%$ Resources:Part4.Window.Cancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowSeniorCompany}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <%-- 5.公司所有人及股东的背景信息 --%>
        <ext:Hidden ID="hiddenWinCompanyStockholderDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowCompanyStockholder" runat="server" Icon="Group" Title="<%$ Resources:Part5.Window.Title%>"
            Resizable="false" Header="false" Width="700" AutoHeight="true" AutoShow="false"
            Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout16" runat="server">
                    <ext:Anchor>
                        <ext:Panel ID="Panel33" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout10" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel34" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout17" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCompanyStockholderName" runat="server" FieldLabel="<%$ Resources:Part5.Window.Name%>"
                                                            AllowBlank="false" Width="220" LabelSeparator="">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:NumberField ID="tfWinCompanyStockholderOwnership" runat="server" FieldLabel="<%$ Resources:Part5.Window.Ownership%>"
                                                            AllowBlank="false" AllowDecimals="true" AllowNegative="false" Width="220" LabelSeparator="">
                                                        </ext:NumberField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCompanyStockholderBusinessAddress" runat="server" FieldLabel="<%$ Resources:Part5.Window.BusinessAddress%>"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCompanyStockholderTelephone" runat="server" FieldLabel="<%$ Resources:Part5.Window.Telephone%>"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCompanyStockholderFax" runat="server" FieldLabel="<%$ Resources:Part5.Window.Fax%>"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCompanyStockholderEmail" runat="server" FieldLabel="<%$ Resources:Part5.Window.Email%>"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel35" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout11" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth=".5">
                                                                        <ext:Panel ID="Panel36" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout18" runat="server" LabelWidth="150">
                                                                                    <ext:Anchor>
                                                                                        <ext:Label ID="lbWinCompanyStockholderPerson" runat="server" HideLabel="true" Text="<%$ Resources:Part5.Window.Person%>"
                                                                                            ItemCls="labelBold" LabelCls="labelBold">
                                                                                        </ext:Label>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderHomeAddress" runat="server" FieldLabel="<%$ Resources:Part5.Window.HomeAddress%>"
                                                                                            Width="120">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderPbumport" runat="server" FieldLabel="<%$ Resources:Part5.Window.Pbumport%>"
                                                                                            Width="120">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderIdentityCard" runat="server" FieldLabel="<%$ Resources:Part5.Window.IdentityCard%>"
                                                                                            Width="120">
                                                                                            <Listeners>
                                                                                                <Blur Fn="onFocus6" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:DateField ID="dfWinCompanyStockholderBirthday" runat="server" FieldLabel="<%$ Resources:Part5.Window.Birthday%>"
                                                                                            Disabled="true">
                                                                                        </ext:DateField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderBirthplace" runat="server" FieldLabel="<%$ Resources:Part5.Window.Birthplace%>"
                                                                                            Width="120">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth=".5">
                                                                        <ext:Panel ID="Panel37" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout19" runat="server" LabelWidth="150">
                                                                                    <ext:Anchor>
                                                                                        <ext:Label ID="lbWinCompanyStockholderCompary" runat="server" HideLabel="true" Text="<%$ Resources:Part5.Window.Compary%>"
                                                                                            ItemCls="labelBold" LabelCls="labelBold">
                                                                                        </ext:Label>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderCountry" runat="server" FieldLabel="<%$ Resources:Part5.Window.Country%>"
                                                                                            Width="120">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderRegister" runat="server" FieldLabel="<%$ Resources:Part5.Window.Register%>"
                                                                                            Width="120">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderPossessor" runat="server" FieldLabel="<%$ Resources:Part5.Window.Possessor%>"
                                                                                            Width="120">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderMiddleEntity" runat="server" FieldLabel="<%$ Resources:Part5.Window.MiddleEntity%>"
                                                                                            Width="120">
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
            <Buttons>
                <ext:Button ID="btnCompanyStockholderSubmit" runat="server" Text="<%$ Resources:Part5.Window.Submit%>"
                    Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveCompanyStockholder();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnCompanyStockholderCancel" runat="server" Text="<%$ Resources:Part5.Window.Cancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowCompanyStockholder}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
    </div>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
