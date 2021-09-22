<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractForm3.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractForm3" %>

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
				ConfirmMsg5:"<%=GetLocalResourceObject("Part5.Operation.ConfirmDelete").ToString()%>",
				ConfirmMsg6:"<%=GetLocalResourceObject("Part6.Operation.ConfirmDelete").ToString()%>",
				ConfirmMsg7:"<%=GetLocalResourceObject("Part7.Operation.ConfirmDelete").ToString()%>",
				ConfirmMsg8:"<%=GetLocalResourceObject("Part8.Operation.ConfirmDelete").ToString()%>"
			}
        }
        
         var DownloadFile=function()
        {
            var url = '../Download.aspx?downloadname=Form 3 - Third Party Disclosure Form - CN 注释.pdf&filename=FromHelp.pdf';
            window.open(url,'Download');                                                        
        }
        
    </script>

    <ext:Store ID="BusReferStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshBusRefer">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CmId" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Address" />
                    <ext:RecordField Name="Country" />
                    <ext:RecordField Name="ContactPerson" />
                    <ext:RecordField Name="Telephone" />
                    <ext:RecordField Name="UpdateUser" />
                    <ext:RecordField Name="UpdateDate" />
                    <ext:RecordField Name="CreateUser" />
                    <ext:RecordField Name="CreateDate" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
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
    <ext:Store ID="CorporateEntityStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshCorporateEntity">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CmId" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Owership" />
                    <ext:RecordField Name="Country" />
                    <ext:RecordField Name="Register" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="CreateUser" />
                    <ext:RecordField Name="UpdateDate" />
                    <ext:RecordField Name="UpdateUser" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="PublicOfficeStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshPublicOffice">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CmId" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Relation" />
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
                <ext:Toolbar ID="Toolbar7" runat="server">
                    <Items>
                        <ext:ToolbarFill />
                        <ext:Button ID="btnCreatePdf" runat="server" Text="生成IAF Form3 PDF" Icon="PageWhiteAcrobat"
                            AutoPostBack="true" OnClick="CreatePdf">
                        </ext:Button>
                        <ext:Button ID="Button1" runat="server" Text="帮助" Icon="Help">
                            <Listeners>
                                <Click Fn="DownloadFile" />
                            </Listeners>
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </TopBar>
        </ext:Panel>
        <ext:Panel ID="plForm3" runat="server" Header="true" Title="<%$ Resources:From3.Title%>"
            Frame="true" Icon="Application" AutoHeight="true" AutoScroll="true" BodyStyle="padding:10px;"
            Collapsible="false">
            <Body>
                <%--  <a href="../../Upload/ExcelTemplate/Supplementary_Letter.xls" target="_self" ><span style=" color: Red;"><b>下载教程</b></span></a> <br/>--%>
                <span><font color="red"><b>&nbsp;&nbsp;&nbsp;*&nbsp;&nbsp;请使用英文填写表单信息，填写过程中如有疑问，可点击页面右上角『帮助』按钮下载帮助文档</b></font></span>
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
                                                            EmptyText="如果办公地址与注册地址不同,请同时填写注册地址和办公地址" AllowBlank="false" BlankText="如果办公地址与注册地址不同,请同时填写注册地址和办公地址。填写地址的格式：门牌号，街道，地区，城市，省份"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfTelephony" runat="server" FieldLabel="<%$ Resources:Part1.Telephony%>"
                                                            AllowBlank="false" BlankText="请填写固定电话或者手机号，固定电话前请加区号" EmptyText="请填写固定电话或者手机号，固定电话前请加区号"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfContactPerson" runat="server" FieldLabel="<%$ Resources:Part1.ContactPerson%>"
                                                            AllowBlank="false" BlankText="请填写联系人全名" EmptyText="请填写联系人全名" Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfContactEmail" runat="server" FieldLabel="<%$ Resources:Part1.ContactEmail%>"
                                                            AllowBlank="false" BlankText="请填写联系人的电子邮件" EmptyText="请填写联系人的电子邮件" Width="150">
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
                                                            EmptyText="请填写营业执照注册号" AllowBlank="false" BlankText="请填写营业执照注册号" Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfCountry" runat="server" FieldLabel="<%$ Resources:Part1.Country%>"
                                                            EmptyText="请填写China" AllowBlank="false" BlankText="请填写China" Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfFax" runat="server" FieldLabel="<%$ Resources:Part1.Fax%>" Width="150"
                                                            AllowBlank="false" BlankText="请填写办公室传真，传真号前请加区号" EmptyText="请填写办公室传真，传真号前请加区号">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWebsite" runat="server" FieldLabel="<%$ Resources:Part1.Website%>"
                                                            Width="150" AllowBlank="false" BlankText="若公司有网站，请填写；若无，请填写“N/A”" EmptyText="若公司有网站，请填写；若无，请填写“N/A”">
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
                                                                                            AllowBlank="false" LabelSeparator="">
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
                <%-- 2.商业推介 --%>
                <ext:Panel ID="Panel10" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part2.Title%>">
                    <Body>
                        <ext:Label ID="label3" runat="server" Text="<%$ Resources:Part2.Notes1%>" />
                        <ext:GridPanel ID="gpBusRefer" StoreID="BusReferStore" runat="server" Border="true"
                            StripeRows="true" Header="false" Height="200">
                            <TopBar>
                                <ext:Toolbar runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnAddBusRefer" runat="server" Text="<%$ Resources:Part2.BtnAdd%>"
                                            Icon="Add">
                                            <Listeners>
                                                <Click Handler="Coolite.AjaxMethods.ShowBusReferWindow({failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                            </Listeners>
                                        </ext:Button>
                                    </Items>
                                </ext:Toolbar>
                            </TopBar>
                            <ColumnModel ID="ColumnModel1" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="150" Header="<%$ Resources:Part2.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Address" DataIndex="Address" Width="150" Header="<%$ Resources:Part2.Header.Address%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Country" DataIndex="Country" Header="<%$ Resources:Part2.Header.Country%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="ContactPerson" DataIndex="ContactPerson" Header="<%$ Resources:Part2.Header.ContactPerson%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Telephone" DataIndex="Telephone" Width="150" Header="<%$ Resources:Part2.Header.Telephone%>">
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
                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                            </SelectionModel>
                            <Listeners>
                                <Command Handler="if (command == 'Delete'){
                                                                Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg2,
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.DeleteBusReferItem(record.data.Id,{success:function(){#{gpBusRefer}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                    }});
                                                                }
                                                  else if (command == 'Edit'){
                                                                Coolite.AjaxMethods.EditBusReferItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                            </Listeners>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part2.Operation.Processing%>" />
                        </ext:GridPanel>
                    </Body>
                </ext:Panel>
                <%-- 3.医疗器械或制药公司 --%>
                <ext:Panel ID="Panel11" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part3.Title%>">
                    <Body>
                        <ext:Label ID="label5" runat="server" Text="<%$ Resources:Part3.Notes1%>" />
                        <ext:GridPanel ID="gpMedicalDevices" runat="server" StoreID="MedicalDevicesStore"
                            Border="true" StripeRows="true" Header="false" Height="200">
                            <TopBar>
                                <ext:Toolbar ID="Toolbar1" runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnAddMedicalDevices" runat="server" Text="<%$ Resources:Part3.BtnAdd%>"
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
                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="150" Header="<%$ Resources:Part3.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Describe" DataIndex="Describe" Width="250" Header="<%$ Resources:Part3.Header.Describe%>">
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
                                <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" />
                            </SelectionModel>
                            <Listeners>
                                <Command Handler="if (command == 'Delete'){
                                                                Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg3,
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.DeleteMedicalDevicesItem(record.data.Id,{success:function(){#{gpMedicalDevices}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                    }});
                                                                }
                                                  else if (command == 'Edit'){
                                                                Coolite.AjaxMethods.EditMedicalDevicesItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                            </Listeners>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part3.Operation.Processing%>" />
                        </ext:GridPanel>
                    </Body>
                </ext:Panel>
                <%-- 4.营业执照、许可或登记情况 --%>
                <ext:Panel ID="Panel12" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part4.Title%>">
                    <Body>
                        <ext:Label ID="label6" runat="server" Text="<%$ Resources:Part4.Notes1%>" />
                        <ext:GridPanel ID="gpBusLicense" runat="server" StoreID="BusinessLicenseStore" Border="true"
                            StripeRows="true" Header="false" Height="200">
                            <TopBar>
                                <ext:Toolbar ID="Toolbar2" runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnAddBusLicense" runat="server" Text="<%$ Resources:Part4.BtnAdd%>"
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
                                    <ext:Column ColumnID="Country" DataIndex="Country" Width="150" Header="<%$ Resources:Part4.Header.Country%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="300" Header="<%$ Resources:Part4.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="AuthOrg" DataIndex="AuthOrg" Width="150" Header="<%$ Resources:Part4.Header.AuthOrg%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="RegisterDate" DataIndex="RegisterDate" Width="300" Header="<%$ Resources:Part4.Header.RegisterDate%>">
                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                    </ext:Column>
                                    <ext:Column ColumnID="RegisterNumber" DataIndex="RegisterNumber" Width="300" Header="<%$ Resources:Part4.Header.RegisterNumber%>">
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
                                <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" />
                            </SelectionModel>
                            <Listeners>
                                <Command Handler="if (command == 'Delete'){
                                                                Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg4,
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.DeleteBusLicenseItem(record.data.Id,{success:function(){#{gpBusLicense}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                    }});
                                                                }
                                                  else if (command == 'Edit'){
                                                                Coolite.AjaxMethods.EditBusLicenseItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                            </Listeners>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part4.Operation.Processing%>" />
                        </ext:GridPanel>
                    </Body>
                </ext:Panel>
                <%-- 5.公司董事及主要高层人员的背景信息 --%>
                <ext:Panel ID="Panel13" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part5.Title%>">
                    <Body>
                        <ext:Label ID="label7" runat="server" Text="<%$ Resources:Part5.Notes1%>" />
                        <ext:GridPanel ID="gpSeniorCompany" runat="server" StoreID="SeniorCompanyStore" Border="true"
                            StripeRows="true" Header="false" Height="200">
                            <TopBar>
                                <ext:Toolbar ID="Toolbar3" runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnAddSeniorCompany" runat="server" Text="<%$ Resources:Part5.BtnAdd%>"
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
                                    <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources:Part5.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Position" DataIndex="Position" Header="<%$ Resources:Part5.Header.Position%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="BusinessAddress" DataIndex="BusinessAddress" Width="150" Header="<%$ Resources:Part5.Header.BusinessAddress%>">
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
                                <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" />
                            </SelectionModel>
                            <Listeners>
                                <Command Handler="if (command == 'Delete'){
                                                                Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg5,
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.DeleteSeniorCompanyItem(record.data.Id,{success:function(){#{gpSeniorCompany}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                    }});
                                                                }
                                                  else if (command == 'Edit'){
                                                                Coolite.AjaxMethods.EditSeniorCompanyItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                            </Listeners>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part5.Operation.Processing%>" />
                        </ext:GridPanel>
                    </Body>
                </ext:Panel>
                <%-- 6.公司所有人及股东的背景信息 --%>
                <ext:Panel ID="Panel14" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part6.Title%>">
                    <Body>
                        <ext:Label ID="label8" runat="server" Text="请提供所有贵公司所有人及股东的下列资料。若为上市公司，只需提供公司所有权占5%及以上的所有人和股东的资料。若所有人或股东为其他公司，请列出该公司及其最终实益拥有人（即自然人）及任何中间实体。若有必要，请上传附件，提供额外的资料。（此项为必填项）" />
                        <ext:GridPanel ID="gpCompanyStockholder" runat="server" StoreID="CompanyStockholderStore"
                            Border="true" StripeRows="true" Header="false" Height="200">
                            <TopBar>
                                <ext:Toolbar ID="Toolbar4" runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnAddCompanyStockholder" runat="server" Text="<%$ Resources:Part6.BtnAdd%>"
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
                                    <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources:Part6.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Ownership" DataIndex="Ownership" Header="<%$ Resources:Part6.Header.Ownership%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="BusinessAddress" DataIndex="BusinessAddress" Header="<%$ Resources:Part6.Header.BusinessAddress%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Telephone" DataIndex="Telephone" Header="<%$ Resources:Part6.Header.Telephone%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Fax" DataIndex="Fax" Header="<%$ Resources:Part6.Header.Fax%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Email" DataIndex="Email" Header="<%$ Resources:Part6.Header.Email%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="HomeAddress" DataIndex="HomeAddress" Header="<%$ Resources:Part6.Header.HomeAddress%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Pbumport" DataIndex="Pbumport" Header="<%$ Resources:Part6.Header.Pbumport%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="IdentityCard" DataIndex="IdentityCard" Header="<%$ Resources:Part6.Header.IdentityCard%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Birthday" DataIndex="Birthday" Header="<%$ Resources:Part6.Header.Birthday%>">
                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                    </ext:Column>
                                    <ext:Column ColumnID="Birthplace" DataIndex="Birthplace" Header="<%$ Resources:Part6.Header.Birthplace%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Country" DataIndex="Country" Header="<%$ Resources:Part6.Header.Country%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Register" DataIndex="Register" Header="<%$ Resources:Part6.Header.Register%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Possessor" DataIndex="Possessor" Header="<%$ Resources:Part6.Header.Possessor%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="MiddleEntity" DataIndex="MiddleEntity" Header="<%$ Resources:Part6.Header.MiddleEntity%>">
                                    </ext:Column>
                                    <ext:CommandColumn Width="80" Header="<%$ Resources:Part6.Header.Operation%>" Align="Center">
                                        <Commands>
                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                <ToolTip Text="<%$ Resources:Part6.Operation.Detail%>" />
                                            </ext:GridCommand>
                                            <ext:CommandSeparator />
                                            <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                <ToolTip Text="<%$ Resources:Part6.Operation.Delete%>" />
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
                                                                Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg6,
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.DeleteCompanyStockholderItem(record.data.Id,{success:function(){#{gpCompanyStockholder}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                    }});
                                                                }
                                                  else if (command == 'Edit'){
                                                                Coolite.AjaxMethods.EditCompanyStockholderItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                            </Listeners>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part6.Operation.Processing%>" />
                        </ext:GridPanel>
                    </Body>
                </ext:Panel>
                <%-- 7.公司拥有的全部实体的背景信息 --%>
                <ext:Panel ID="Panel15" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part7.Title%>">
                    <Body>
                        <ext:Label ID="label9" runat="server" Text="<%$ Resources:Part7.Notes1%>" />
                        <ext:GridPanel ID="gpCorporateEntity" runat="server" StoreID="CorporateEntityStore"
                            Border="true" StripeRows="true" Header="false" Height="200">
                            <TopBar>
                                <ext:Toolbar ID="Toolbar5" runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnAddCorporateEntity" runat="server" Text="<%$ Resources:Part7.BtnAdd%>"
                                            Icon="Add">
                                            <Listeners>
                                                <Click Handler="Coolite.AjaxMethods.ShowCorporateEntityWindow();" />
                                            </Listeners>
                                        </ext:Button>
                                    </Items>
                                </ext:Toolbar>
                            </TopBar>
                            <ColumnModel ID="ColumnModel6" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="150" Header="<%$ Resources:Part7.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Owership" DataIndex="Owership" Header="<%$ Resources:Part7.Header.Owership%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Country" DataIndex="Country" Header="<%$ Resources:Part7.Header.Country%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Register" DataIndex="Register" Width="150" Header="<%$ Resources:Part7.Header.Register%>">
                                    </ext:Column>
                                    <ext:CommandColumn Width="80" Header="<%$ Resources:Part7.Header.Operation%>" Align="Center">
                                        <Commands>
                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                <ToolTip Text="<%$ Resources:Part7.Operation.Detail%>" />
                                            </ext:GridCommand>
                                            <ext:CommandSeparator />
                                            <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                <ToolTip Text="<%$ Resources:Part7.Operation.Delete%>" />
                                            </ext:GridCommand>
                                        </Commands>
                                    </ext:CommandColumn>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel6" runat="server" />
                            </SelectionModel>
                            <Listeners>
                                <Command Handler="if (command == 'Delete'){
                                                                Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg7,
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.DeleteCorporateEntityItem(record.data.Id,{success:function(){#{gpCorporateEntity}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                    }});
                                                                }
                                                  else if (command == 'Edit'){
                                                                Coolite.AjaxMethods.EditCorporateEntityItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                            </Listeners>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part7.Operation.Processing%>" />
                        </ext:GridPanel>
                    </Body>
                </ext:Panel>
                <%-- 8.公职 --%>
                <ext:Panel ID="Panel16" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part8.Title%>">
                    <Body>
                        <ext:Label ID="label10" runat="server" Text="<%$ Resources:Part8.Notes1%>" />
                        <ext:GridPanel ID="gpPublicOffice" runat="server" StoreID="PublicOfficeStore" Border="true"
                            StripeRows="true" Header="false" Height="200">
                            <TopBar>
                                <ext:Toolbar ID="Toolbar6" runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnAddPublicOffice" runat="server" Text="<%$ Resources:Part8.BtnAdd%>"
                                            Icon="Add">
                                            <Listeners>
                                                <Click Handler="Coolite.AjaxMethods.ShowPublicOfficeWindow();" />
                                            </Listeners>
                                        </ext:Button>
                                    </Items>
                                </ext:Toolbar>
                            </TopBar>
                            <ColumnModel ID="ColumnModel7" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="150" Header="<%$ Resources:Part8.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Relation" DataIndex="Relation" Width="150" Header="<%$ Resources:Part8.Header.Relation%>">
                                    </ext:Column>
                                    <ext:CommandColumn Width="80" Header="<%$ Resources:Part8.Header.Operation%>" Align="Center">
                                        <Commands>
                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                <ToolTip Text="<%$ Resources:Part8.Operation.Detail%>" />
                                            </ext:GridCommand>
                                            <ext:CommandSeparator />
                                            <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                <ToolTip Text="<%$ Resources:Part8.Operation.Delete%>" />
                                            </ext:GridCommand>
                                        </Commands>
                                    </ext:CommandColumn>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel7" runat="server" />
                            </SelectionModel>
                            <Listeners>
                                <Command Handler="if (command == 'Delete'){
                                                                Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg8,
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.DeletePublicOfficeItem(record.data.Id,{success:function(){#{gpPublicOffice}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                    }});
                                                                }
                                                  else if (command == 'Edit'){
                                                                Coolite.AjaxMethods.EditPublicOfficeItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                            </Listeners>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part8.Operation.Processing%>" />
                        </ext:GridPanel>
                    </Body>
                </ext:Panel>
                <%-- 9.其他信息 --%>
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
                <%-- 10.信息发布 --%>
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
                <%-- 11.签字名信息 --%>
                <ext:Panel ID="PanelSign" runat="server" FormGroup="true" BodyBorder="true" Title="签名信息">
                    <Body>
                        <ext:GridPanel ID="gpPanelSign" runat="server" StoreID="CompanyStockholderStore"
                            Border="true" StripeRows="true" Header="false" Height="150" AutoScroll="true"
                            AutoExpandColumn="IdentityCard">
                            <ColumnModel ID="ColumnModel8" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources:Part6.Header.Name%>">
                                    </ext:Column>
                                    <ext:Column ColumnID="IdentityCard" DataIndex="IdentityCard" Header="<%$ Resources:Part6.Header.IdentityCard%>">
                                    </ext:Column>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel8" runat="server" />
                            </SelectionModel>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:Part6.Operation.Processing%>" />
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
        <%-- 2.商业推介 --%>
        <ext:Hidden ID="hiddenWinBusReferDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowBusRefer" runat="server" Icon="Group" Title="<%$ Resources:Part2.Window.Title%>"
            Resizable="false" Header="false" Width="390" Height="230" AutoShow="false" Modal="true"
            ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout11" runat="server">
                    <ext:Anchor>
                        <ext:Panel ID="Panel25" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel26" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusReferName" runat="server" FieldLabel="<%$ Resources:Part2.Window.Name%>"
                                                            AllowBlank="false" BlankText="请填写商业推介公司的中英文完整名称" EmptyText="请填写商业推介公司的中英文完整名称"
                                                            Width="220" LabelSeparator="">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusReferAddress" runat="server" FieldLabel="<%$ Resources:Part2.Window.Address%>"
                                                            AllowBlank="false" BlankText="请提供详细的地址<br/>填写格式：门牌号，街道，地区，城市，省份" EmptyText="请提供详细的地址"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusReferCountry" runat="server" FieldLabel="<%$ Resources:Part2.Window.Country%>"
                                                            AllowBlank="false" BlankText="商业推介公司所在的国家" EmptyText="商业推介公司所在的国家" Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusReferContactPerson" runat="server" FieldLabel="<%$ Resources:Part2.Window.ContactPerson%>"
                                                            AllowBlank="false" BlankText="请填写联系人全名" EmptyText="请填写联系人全名" Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusReferTelephone" runat="server" FieldLabel="<%$ Resources:Part2.Window.Telephone%>"
                                                            AllowBlank="false" BlankText="请填写联系人手机号" EmptyText="请填写联系人手机号" Width="220">
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
                <ext:Button ID="btnBusReferSubmit" runat="server" Text="<%$ Resources:Part2.Window.Btn.Submit%>"
                    CausesValidation="true" ValidationGroup="RuleSetA" Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveBusRefer({success:function(result){ if(result=='') {Ext.Msg.alert('Success', '保存成功');} else {Ext.Msg.alert('Error', result);}},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnBusReferCancel" runat="server" Text="<%$ Resources:Part2.Window.Btn.Cancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowBusRefer}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <%-- 3.医疗器械或制药公司 --%>
        <ext:Hidden ID="hiddenWinMedicalDevicesDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowMedicalDevices" runat="server" Icon="Group" Title="<%$ Resources:Part3.Window.Title%>"
            Resizable="false" Header="false" Width="390" Height="160" AutoShow="false" Modal="true"
            ShowOnLoad="false" BodyStyle="padding:5px;">
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
                                                        <ext:TextField ID="tfWinMedicalDevicesName" runat="server" FieldLabel="<%$ Resources:Part3.Window.Name%>"
                                                            AllowBlank="false" BlankText="请填写所代理的其他医疗器械或制药公司全称。<br/>若无，请填写“None”" EmptyText="请填写所代理的其他医疗器械或制药公司全称"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinMedicalDevicesDescribe" runat="server" FieldLabel="<%$ Resources:Part3.Window.Describe%>"
                                                            AllowBlank="false" BlankText="请填写所代理的其他医疗器械或制药公司的产品名称。<br/>若无，请填写“None”" EmptyText="请填写所代理的其他医疗器械或制药公司的产品名称"
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
                <ext:Button ID="btnMedicalDevicesSubmit" runat="server" Text="<%$ Resources:Part3.Window.Btn.Submit%>"
                    Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveMedicalDevices({success:function(result){ if(result=='') {Ext.Msg.alert('Success', '保存成功');} else {Ext.Msg.alert('Error', result);}},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnMedicalDevicesCancel" runat="server" Text="<%$ Resources:Part3.Window.Btn.Cancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowMedicalDevices}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <%-- 4.营业执照、许可或登记情况 --%>
        <ext:Hidden ID="hiddenWinBusLicenseDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowBusLicense" runat="server" Icon="Group" Title="<%$ Resources:Part4.Window.Title%>"
            Resizable="false" Header="false" Width="400" AutoHeight="true" AutoShow="false"
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
                                                        <%--  <ext:TextField ID="tfWinBusLicenseName" runat="server" FieldLabel="<%$ Resources:Part4.Window.Name%>"
                                                            EmptyText="请填写Business License" AllowBlank="false" BlankText="请填写Business License"
                                                            Width="170" LabelSeparator="">
                                                        </ext:TextField>--%>
                                                        <ext:ComboBox ID="cbWinBusLicenseName" runat="server" EmptyText="请选择证照名称" Editable="false" Width="170"
                                                            TypeAhead="true" Mode="Local" FieldLabel="<%$ Resources:Part4.Window.Name%>"
                                                            AllowBlank="false" Resizable="true">
                                                            <Items>
                                                                <ext:ListItem Text="营业执照" Value="Business License" />
                                                                <ext:ListItem Text="医疗器械经营许可证" Value="Permit License of Medical Device" />
                                                            </Items>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusLicenseCountry" runat="server" FieldLabel="<%$ Resources:Part4.Window.Country%>"
                                                            EmptyText="请填写《营业执照》签发国家" AllowBlank="false" BlankText="请填写《营业执照》签发国家，“China”"
                                                            Width="170" LabelSeparator="">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusLicenseAuthOrg" runat="server" FieldLabel="<%$ Resources:Part4.Window.AuthOrg%>"
                                                            EmptyText="请填写AIC,发证省份和城市" AllowBlank="false" BlankText="请填写AIC,发证省份和城市" Width="170">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="tfWinBusLicenseRegisterDate" runat="server" FieldLabel="<%$ Resources:Part4.Window.Date%>"
                                                            EmptyText="请填写登记日期" AllowBlank="false" BlankText="请填写登记日期">
                                                        </ext:DateField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinBusLicenseRegisterNumber" runat="server" FieldLabel="<%$ Resources:Part4.Window.Number%>"
                                                            EmptyText="请填写登记编号" AllowBlank="false" BlankText="请填写登记编号" Width="170" LabelSeparator="">
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
                <ext:Button ID="btnBusLicenseSubmit" runat="server" Text="<%$ Resources:Part4.Window.Submit%>"
                    Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveBusLicense({success:function(result){ if(result=='') {Ext.Msg.alert('Success', '保存成功');} else {Ext.Msg.alert('Error', result);}},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnBusLicenseCancel" runat="server" Text="<%$ Resources:Part4.Window.Cancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowBusLicense}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <%-- 5.公司董事及主要高层人员的背景信息 --%>
        <ext:Hidden ID="hiddenWinSeniorCompanyDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowSeniorCompany" runat="server" Icon="Group" Title="<%$ Resources:Part5.Window.Title%>"
            Resizable="false" Header="false" Width="430" Height="410" AutoShow="false" Modal="true"
            ShowOnLoad="false" BodyStyle="padding:5px;">
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
                                                        <ext:TextField ID="tfWinSeniorCompanyName" runat="server" FieldLabel="<%$ Resources:Part5.Window.Name%>"
                                                            BlankText="请填写贵公司董事及各主要高层人员（董事长、总经理、首席财务官等）的全名（中英文名）" EmptyText="请填写贵公司董事及各主要高层人员的全名"
                                                            Width="200" AllowBlank="false" LabelSeparator="">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyPosition" runat="server" FieldLabel="<%$ Resources:Part5.Window.Position%>"
                                                            BlankText="请填写该高层人员职务" EmptyText="请填写该高层人员职务" Width="200" AllowBlank="false"
                                                            LabelSeparator="">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyBusinessAddress" runat="server" FieldLabel="<%$ Resources:Part5.Window.BusinessAddress%>"
                                                            AllowBlank="false" BlankText="填写地址的格式<br/>门牌号，街道，地区，城市，省份，国家" EmptyText="请填写办公地址"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyTelephone" runat="server" FieldLabel="<%$ Resources:Part5.Window.Telephone%>"
                                                            AllowBlank="false" BlankText="请填写固定电话或者手机号，固定电话前请加区号" EmptyText="请填写固定电话或者手机号，固定电话前请加区号"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyFax" runat="server" FieldLabel="<%$ Resources:Part5.Window.Fax%>"
                                                            AllowBlank="false" BlankText="请填写办公室传真，传真号前请加区号" EmptyText="请填写办公室传真，传真号前请加区号"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyEmail" runat="server" FieldLabel="<%$ Resources:Part5.Window.Email%>"
                                                            AllowBlank="false" BlankText="请填写邮件地址" EmptyText="请填写邮件地址" Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyHomeAddress" runat="server" FieldLabel="<%$ Resources:Part5.Window.HomeAddress%>"
                                                            AllowBlank="false" BlankText="请提供详细的居住地址 <br/> 填写地址的格式：门牌号，街道，地区，城市，省份，国家" EmptyText="请提供详细的居住地址"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyPbumport" runat="server" FieldLabel="<%$ Resources:Part5.Window.Pbumport%>"
                                                            AllowBlank="false" BlankText="请填写护照号，若无，请填写“N/A”" EmptyText="请填写护照号，若无，请填写“N/A”"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyIdentityCard" runat="server" FieldLabel="<%$ Resources:Part5.Window.IdentityCard%>"
                                                            EmptyText="请填写18位居民身份证号" AllowBlank="false" BlankText="<%$ Resources:Part5.Window.IdentityCard.BlankText%>"
                                                            Width="200">
                                                            <Listeners>
                                                                <Blur Fn="onFocus5" />
                                                            </Listeners>
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="tfWinSeniorCompanyBirthday" runat="server" FieldLabel="<%$ Resources:Part5.Window.Birthday%>"
                                                            Disabled="true">
                                                        </ext:DateField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinSeniorCompanyBirthplace" runat="server" FieldLabel="<%$ Resources:Part5.Window.Birthplace%>"
                                                            AllowBlank="false" BlankText="请填写出生地点<br>填写格式：城市，省份" EmptyText="请填写出生地点" Width="200">
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
                <ext:Button ID="btnSeniorCompanySubmit" runat="server" Text="<%$ Resources:Part5.Window.Submit%>"
                    Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveSeniorCompany({success:function(result){ if(result=='') {Ext.Msg.alert('Success', '保存成功');} else {Ext.Msg.alert('Error', result);}},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnSeniorCompanyCancel" runat="server" Text="<%$ Resources:Part5.Window.Cancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowSeniorCompany}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <%-- 6.公司所有人及股东的背景信息 --%>
        <ext:Hidden ID="hiddenWinCompanyStockholderDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowCompanyStockholder" runat="server" Icon="Group" Title="<%$ Resources:Part6.Window.Title%>"
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
                                                        <ext:TextField ID="tfWinCompanyStockholderName" runat="server" FieldLabel="<%$ Resources:Part6.Window.Name%>"
                                                            BlankText="请填写股东全名（中英文名）" EmptyText="请填写股东全名（中英文名）" AllowBlank="false" Width="220"
                                                            LabelSeparator="">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:NumberField ID="tfWinCompanyStockholderOwnership" runat="server" FieldLabel="<%$ Resources:Part6.Window.Ownership%>"
                                                            BlankText="请填写股东所有权占比%" EmptyText="请填写股东所有权占比%" AllowBlank="false" AllowDecimals="true"
                                                            AllowNegative="false" Width="220" LabelSeparator="">
                                                        </ext:NumberField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCompanyStockholderBusinessAddress" runat="server" FieldLabel="<%$ Resources:Part6.Window.BusinessAddress%>"
                                                            AllowBlank="false" BlankText="请填写办公地址" EmptyText="请填写办公地址" Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCompanyStockholderTelephone" runat="server" FieldLabel="<%$ Resources:Part6.Window.Telephone%>"
                                                            AllowBlank="false" BlankText="请填写固定电话或者手机号，固定电话前请加区号" EmptyText="请填写固定电话或者手机号，固定电话前请加区号"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCompanyStockholderFax" runat="server" FieldLabel="<%$ Resources:Part6.Window.Fax%>"
                                                            AllowBlank="false" BlankText="请填写办公室传真，传真号前请加区号" EmptyText="请填写办公室传真，传真号前请加区号"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCompanyStockholderEmail" runat="server" FieldLabel="<%$ Resources:Part6.Window.Email%>"
                                                            AllowBlank="false" BlankText="请填写邮件地址" EmptyText="请填写邮件地址" Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel35" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout11" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth=".5">
                                                                        <ext:Panel ID="Panel36" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout18" runat="server" LabelWidth="120">
                                                                                    <ext:Anchor>
                                                                                        <ext:Label ID="lbWinCompanyStockholderPerson" runat="server" HideLabel="true" Text="<%$ Resources:Part6.Window.Person%>"
                                                                                            ItemCls="labelBold" LabelCls="labelBold">
                                                                                        </ext:Label>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderHomeAddress" runat="server" FieldLabel="<%$ Resources:Part6.Window.HomeAddress%>"
                                                                                            EmptyText="请提供详细的居住地址" Width="140">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderPbumport" runat="server" FieldLabel="<%$ Resources:Part6.Window.Pbumport%>"
                                                                                            EmptyText="请填写护照号，若无，请填写“N/A”" Width="140">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderIdentityCard" runat="server" FieldLabel="<%$ Resources:Part6.Window.IdentityCard%>"
                                                                                            EmptyText="请填写18位居民身份证号" Width="140">
                                                                                            <Listeners>
                                                                                                <Blur Fn="onFocus6" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:DateField ID="dfWinCompanyStockholderBirthday" runat="server" FieldLabel="<%$ Resources:Part6.Window.Birthday%>"
                                                                                            Disabled="true">
                                                                                        </ext:DateField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderBirthplace" runat="server" FieldLabel="<%$ Resources:Part6.Window.Birthplace%>"
                                                                                            EmptyText="请填写出生地点" Width="140">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth=".5">
                                                                        <ext:Panel ID="Panel37" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout19" runat="server" LabelWidth="120">
                                                                                    <ext:Anchor>
                                                                                        <ext:Label ID="lbWinCompanyStockholderCompary" runat="server" HideLabel="true" Text="<%$ Resources:Part6.Window.Compary%>"
                                                                                            ItemCls="labelBold" LabelCls="labelBold">
                                                                                        </ext:Label>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderCountry" runat="server" FieldLabel="<%$ Resources:Part6.Window.Country%>"
                                                                                            EmptyText="股东公司成立所在国家" Width="140">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderRegister" runat="server" FieldLabel="<%$ Resources:Part6.Window.Register%>"
                                                                                            EmptyText="股东公司《营业执照》注册号" Width="140">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderPossessor" runat="server" FieldLabel="<%$ Resources:Part6.Window.Possessor%>"
                                                                                            EmptyText="股东公司最终实益拥有人（即自然人）的全名及所有权占比%" Width="140">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfWinCompanyStockholderMiddleEntity" runat="server" FieldLabel="<%$ Resources:Part6.Window.MiddleEntity%>"
                                                                                            EmptyText="中间实体，若无，请填写“N/A”" Width="140">
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
                <ext:Button ID="btnCompanyStockholderSubmit" runat="server" Text="<%$ Resources:Part6.Window.Submit%>"
                    Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveCompanyStockholder({success:function(result){ if(result=='') {Ext.Msg.alert('Success', '保存成功');} else {Ext.Msg.alert('Error', result);}},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnCompanyStockholderCancel" runat="server" Text="<%$ Resources:Part6.Window.Cancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowCompanyStockholder}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <%-- 7.公司拥有的全部实体的背景信息 --%>
        <ext:Hidden ID="hiddenWinCorporateEntityDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowCorporateEntity" runat="server" Icon="Group" Title="<%$ Resources:Part7.Window.Title%>"
            Resizable="false" Header="false" Width="390" Height="205" AutoShow="false" Modal="true"
            ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout20" runat="server">
                    <ext:Anchor>
                        <ext:Panel ID="Panel38" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout12" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel39" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout21" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCorporateEntityName" runat="server" FieldLabel="<%$ Resources:Part7.Window.Name%>"
                                                            AllowBlank="false" BlankText="请填写子公司或合资企业公司全称（中英文），若无，请填写“None”" EmptyText="公司全称（中英文）"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:NumberField ID="tfWinCorporateEntityOwership" runat="server" FieldLabel="<%$ Resources:Part7.Window.Owership%>"
                                                            AllowBlank="false" BlankText="请填写子公司或合资企业与公司的所有权占比%，若无，请填写“None”" EmptyText="所有权占比%"
                                                            Width="220">
                                                        </ext:NumberField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCorporateEntityCountry" runat="server" FieldLabel="<%$ Resources:Part7.Window.Country%>"
                                                            AllowBlank="false" BlankText="请填写子公司或合资企业成立国家，若无，请填写“None”" EmptyText="子公司成立国家"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinCorporateEntityRegister" runat="server" FieldLabel=" <%$ Resources:Part7.Window.Register%>"
                                                            AllowBlank="false" BlankText="请填写子公司或合资企业《营业执照》注册号，若无，请填写“None”" EmptyText="《营业执照》注册号"
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
                <ext:Button ID="btnCorporateEntitySubmit" runat="server" Text="<%$ Resources:Part7.Window.Submit%>"
                    Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveCorporateEntity({success:function(result){ if(result=='') {Ext.Msg.alert('Success', '保存成功');} else {Ext.Msg.alert('Error', result);}},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnCorporateEntityCancel" runat="server" Text="<%$ Resources:Part7.Window.Cancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowCorporateEntity}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <%-- 8.公职 --%>
        <ext:Hidden ID="hiddenWinPublicOfficeDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowPublicOffice" runat="server" Icon="Group" Title="<%$ Resources:Part8.Window.Title%>"
            Resizable="false" Header="false" Width="390" AutoHeight="true" AutoShow="false"
            Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout22" runat="server">
                    <ext:Anchor>
                        <ext:Panel ID="Panel40" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout13" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel41" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout23" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinPublicOfficeName" runat="server" FieldLabel="<%$ Resources:Part8.Window.Name%>"
                                                            EmptyText="请填写政府官员的全名（中英文）" AllowBlank="false" BlankText="若有，请填写政府官员的全名（中英文）；若无，请填写“None”"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinPublicOfficeRelation" runat="server" FieldLabel="<%$ Resources:Part8.Window.Relation%>"
                                                            EmptyText="请填写政府隶属关系" AllowBlank="false" BlankText="若有，请填写政府隶属关系；若无，请填写“None”"
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
                <ext:Button ID="btnPublicOfficeSubmit" runat="server" Text="<%$ Resources:Part8.Window.Submit%>"
                    Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SavePublicOffice({success:function(result){ if(result=='') {Ext.Msg.alert('Success', '保存成功');} else {Ext.Msg.alert('Error', result);}},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnPublicOfficeCancel" runat="server" Text="<%$ Resources:Part8.Window.Cancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowPublicOffice}.hide();" />
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
