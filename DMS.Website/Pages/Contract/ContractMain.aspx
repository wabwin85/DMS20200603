<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractMain.aspx.cs" Inherits="DMS.Website.Pages.Contract.ContractMain" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>

        <script type="text/javascript" language="javascript">
            function getDealerTypeName(values) {
                if (values == 'T1') {
                    return "一级经销商";
                }
                else if (values == 'T2') {
                    return "二级经销商";
                }
                else if (values == 'LP') {
                    return "物流平台或RLD";
                }
                else if (values == 'HQ') {
                    return "波科公司";
                }
                else {
                    return values;
                }
            }          
        </script>

        <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="ChineseShortName" />
                        <ext:RecordField Name="EnglishName" />
                        <ext:RecordField Name="EnglishShortName" />
                        <ext:RecordField Name="Nbr" />
                        <ext:RecordField Name="SapCode" />
                        <ext:RecordField Name="DealerType" />
                        <ext:RecordField Name="CompanyType" />
                        <ext:RecordField Name="CompanyGrade" />
                        <ext:RecordField Name="DealerAuthentication" />
                        <ext:RecordField Name="FirstContractDate" />
                        <ext:RecordField Name="RegisteredAddress" />
                        <ext:RecordField Name="Address" />
                        <ext:RecordField Name="ShipToAddress" />
                        <ext:RecordField Name="PostalCode" />
                        <ext:RecordField Name="Phone" />
                        <ext:RecordField Name="Fax" />
                        <ext:RecordField Name="ContactPerson" />
                        <ext:RecordField Name="Email" />
                        <ext:RecordField Name="GeneralManager" />
                        <ext:RecordField Name="LegalRep" />
                        <ext:RecordField Name="RegisteredCapital" />
                        <ext:RecordField Name="Bank" />
                        <ext:RecordField Name="BankAccount" />
                        <ext:RecordField Name="TaxNo" />
                        <ext:RecordField Name="License" />
                        <ext:RecordField Name="LicenseLimit" />
                        <ext:RecordField Name="Province" />
                        <ext:RecordField Name="City" />
                        <ext:RecordField Name="District" />
                        <ext:RecordField Name="SalesMode" />
                        <ext:RecordField Name="Taxpayer" />
                        <ext:RecordField Name="Finance" />
                        <ext:RecordField Name="FinancePhone" />
                        <ext:RecordField Name="FinanceEmail" />
                        <ext:RecordField Name="Payment" />
                        <ext:RecordField Name="EstablishDate" />
                        <ext:RecordField Name="SystemStartDate" />
                        <ext:RecordField Name="Certification" />
                        <ext:RecordField Name="HostCompanyFlag" />
                        <ext:RecordField Name="DealerOrderNbrName" />
                        <ext:RecordField Name="SapInvoiceToEmail" />
                        <ext:RecordField Name="LastUpdateDate" Type="Date" />
                        <ext:RecordField Name="LastUpdateUser" />
                        <ext:RecordField Name="LastUpdateUserName" />
                        <ext:RecordField Name="ActiveFlag" />
                        <ext:RecordField Name="DeletedFlag" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="ChineseShortName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{cbDealer}.setValue(#{hidInitDealerId}.getValue());" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="DealerTypeStore" runat="server" UseIdConfirmation="true" OnRefreshData="DealerTypeStore_RefreshData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Key" Direction="ASC" />
            <Listeners>
            </Listeners>
        </ext:Store>
        <ext:Hidden ID="hidInitDealerId" runat="server">
        </ext:Hidden>
        <div>
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="True">
                            <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                                Icon="Find">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择经销商..." Width="200" Editable="true"
                                                                TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                                Mode="Local" FieldLabel="经销商中文名称" ListWidth="300" Resizable="true">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel2" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout2" runat="server">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDealerType" runat="server" EmptyText="请选择经销商类型..." Width="200"
                                                                Editable="true" TypeAhead="true" StoreID="DealerTypeStore" ValueField="Key" DisplayField="Value"
                                                                Mode="Local" FieldLabel="经销商类型" ListWidth="300" Resizable="true">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel3" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout3" runat="server">
                                                        <ext:Anchor>
                                                            <ext:Hidden runat="server" ID="hidNull">
                                                            </ext:Hidden>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                                <Buttons>
                                    <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                        <Listeners>
                                            <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </North>
                        <Center>
                            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                        <ext:GridPanel ID="GridDealerInfor" runat="server" Title="查询结果" StoreID="ResultStore"
                                            Border="false" Icon="Lorry" StripeRows="true">
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="Id" DataIndex="Id" Header="经销商ID" Width="250" Hidden="true">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ChineseShortName" DataIndex="ChineseShortName" Header="经销商中文名称" Width="250">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="经销商英文名称" Width="250"
                                                        Hidden="true">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DealerType" DataIndex="DealerType" Header="经销商类型">
                                                        <Renderer Handler="return getDealerTypeName(value);" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Address" DataIndex="Address" Header="地址">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Province" Hidden="true" DataIndex="Province" Header="省份">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="City" Hidden="true" DataIndex="City" Header="城市">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PostalCode" DataIndex="PostalCode" Header="邮编">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Phone" DataIndex="Phone" Header="电话">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Fax" DataIndex="Fax" Header="传真">
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="50" Header="披露" Align="Center" Hidden="true">
                                                        <Commands>
                                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                                <ToolTip Text="披露" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                    <ext:CommandColumn Width="50" Header="披露" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="NoteEdit" CommandName="look">
                                                                <ToolTip Text="披露" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="if (command == 'Edit')
                                                                   {
                                                                    var dealerId = record.data.Id;
                                                                    window.location.href = '/Pages/Contract/ContractThirdParty.aspx?DealerId=' + dealerId;
                                                                   }
                                                 if (command == 'look'){
                                                   var dealerId = record.data.Id;
                                                   window.location.href = '/Pages/Contract/ContractThirdPartyV2.aspx?DealerId=' + dealerId;
                                                }
                                              " />
                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                    DisplayInfo="true" EmptyMsg="没有数据显示" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="处理中..." />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:ViewPort>
            <ext:Hidden ID="hdDealerId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hdProductLineId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hdMarketType" runat="server">
            </ext:Hidden>
        </div>
    </form>
</body>
</html>
