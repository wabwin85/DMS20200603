<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractMaster.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractMaster" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>

        <script type="text/javascript" language="javascript">
            function prepareCommand(grid, toolbar, rowIndex, record) {
                var firstButton = toolbar.items.get(0);

                var dealertype = record.data.DealerType;
                var contstatus = record.data.ContStatus;
                var parmetType = record.data.ParmetType;

                if (((dealertype == 'T1' || dealertype == 'LP' || dealertype == 'LS') && contstatus != 'Reject' && contstatus != 'Approving') || (dealertype == 'T2')) {
                    firstButton.setVisible(true);
                } else {
                    firstButton.setVisible(false);
                }
            }

            function getDealerTypeName(values) {
                if (values == 'T1') {
                    return "一级经销商";
                }
                else if (values == 'T2') {
                    return "二级经销商";
                }
                else if (values == 'LP') {
                    return "平台经销商";
                } else if (values == 'LS') {
                    return "配送商";
                }
                else {
                    return values;
                }
            }

            function ComboxSelValue(e) {
                var combo = e.combo;
                combo.collapse();
                if (!e.forceAll) {
                    var input = e.query;
                    if (input != null && input != '') {
                        // 检索的正则
                        var regExp = new RegExp(".*" + input + ".*");
                        // 执行检索
                        combo.store.filterBy(function (record, id) {
                            // 得到每个record的项目名称值
                            var text = record.get(combo.displayField);
                            return regExp.test(text);
                        });
                    } else {
                        combo.store.clearFilter();
                    }
                    combo.expand();
                    return false;
                }
            }

        </script>

        <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="ContractID">
                    <Fields>
                        <ext:RecordField Name="ContractID" />
                        <ext:RecordField Name="DealerID" />
                        <ext:RecordField Name="CmID" />
                        <ext:RecordField Name="DealerCnName" />
                        <ext:RecordField Name="DealerEnName" />
                        <ext:RecordField Name="DealerType" />
                        <ext:RecordField Name="Division" />
                        <ext:RecordField Name="EffectiveDate" />
                        <ext:RecordField Name="ExpirationDate" />
                        <ext:RecordField Name="ContStatus" />
                        <ext:RecordField Name="ContType" />
                        <ext:RecordField Name="ParmetType" />
                        <ext:RecordField Name="SubDeptName" />
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
        <ext:Store ID="StatusStore" runat="server" OnRefreshData="StatusStore_RefreshData"
            AutoLoad="true">
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
        </ext:Store>
        <ext:Store ID="DivisionStore" runat="server" AutoLoad="true" OnRefreshData="DivisionStore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="DivisionCode">
                    <Fields>
                        <ext:RecordField Name="DivisionName" />
                        <ext:RecordField Name="DivisionCode" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="ContractTypeStore" runat="server" OnRefreshData="ContractTypeStore_RefreshData"
            AutoLoad="true">
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
        </ext:Store>
        <ext:Store ID="TakeEffectStateStore" runat="server" UseIdConfirmation="false" AutoLoad="false" OnRefreshData="TakeEffectStateStore_RefreshData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Nbr">
                    <Fields>
                        <ext:RecordField Name="Nbr" />
                        <ext:RecordField Name="Massage" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="hidInitDealerId" runat="server">
        </ext:Hidden>
        <div>
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="True">
                            <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources:plSearch.Title%>"
                                Frame="true" AutoHeight="true" Icon="Find">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources:cbDealer.EmptyText%>"
                                                                Width="200" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                                                DisplayField="ChineseShortName" Mode="Local" FieldLabel="<%$ Resources:cbDealer.FieldLabel%>"
                                                                ListWidth="300" Resizable="true">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:cbDealer.Clear%>" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <BeforeQuery Fn="ComboxSelValue" />
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtDealerNameFuzzyCN" runat="server" Width="200" FieldLabel="<%$ Resources:txtDealer.FieldLabel%>">
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbStatus" runat="server" EmptyText="<%$ Resources:cbStatus.EmptyText%>"
                                                                Width="200" Editable="true" TypeAhead="true" Resizable="true" StoreID="StatusStore"
                                                                ValueField="Key" DisplayField="Value" FieldLabel="<%$ Resources:cbStatus.FieldLabel%>">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:cbStatus.Clear%>" />
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
                                                            <ext:DateField ID="dfStartBeginDate" runat="server" Width="150" FieldLabel="<%$ Resources:dfStartBeginDate.FieldLabel%>" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:DateField ID="dfStopBeginDate" runat="server" Width="150" FieldLabel="<%$ Resources:dfStopBeginDate.FieldLabel%>" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDivision" runat="server" EmptyText="<%$ Resources:cbDivision.EmptyText%>"
                                                                Width="150" Editable="false" TypeAhead="true" StoreID="DivisionStore" ValueField="DivisionName"
                                                                Mode="Local" DisplayField="DivisionName" FieldLabel="<%$ Resources:cbDivision.FieldLabel%>"
                                                                ListWidth="300" Resizable="true">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:cbDivision.Clear%>" />
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
                                                            <ext:DateField ID="dfStartEndDate" runat="server" Width="150" FieldLabel="<%$ Resources:dfStartEndDate.FieldLabel%>" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:DateField ID="dfStopEndDate" runat="server" Width="150" FieldLabel="<%$ Resources:dfStopEndDate.FieldLabel %>" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbContractType" runat="server" EmptyText="<%$ Resources:cbContractType.EmptyText %>"
                                                                Width="150" Editable="true" TypeAhead="true" Resizable="true" StoreID="ContractTypeStore"
                                                                ValueField="Key" DisplayField="Value" FieldLabel="<%$ Resources:cbContractType.FieldLabel %>">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:cbContractType.Clear %>" />
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
                                    </ext:ColumnLayout>
                                </Body>
                                <Buttons>
                                    <ext:Button ID="btnSearch" Text="<%$ Resources:Panel1.btnSearch.Text %>" runat="server"
                                        Icon="ArrowRefresh" IDMode="Legacy">
                                        <Listeners>
                                            <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnAdd" runat="server" Text="新增(Form3~6)" Icon="Add" IDMode="Legacy"
                                        Hidden="true">
                                        <Listeners>
                                            <%--<Click Handler="window.parent.loadExample('/Pages/Contract/ContractDeatil.aspx','subMenu304_01','新增经销商合同(Form3~6)');" />--%>
                                                <Click Handler="top.createTab({id: 'subMenu304_01',title: '新增经销商合同(Form3~6)',url: 'Pages/Contract/ContractDeatil.aspx'});" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </North>
                        <Center>
                            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                        <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources:GridPanel1.Title %>"
                                            StoreID="ResultStore" Border="false" Icon="Lorry" StripeRows="true">
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    <ext:Column Hidden="True" ColumnID="DealerEnName" DataIndex="DealerEnName" Header="<%$ Resources:GridPanel1.DealerEnName %>"
                                                        Width="220">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DealerCnName" DataIndex="DealerCnName" Header="<%$ Resources:GridPanel1.DealerCnName %>"
                                                        Width="210">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DealerType" DataIndex="DealerType" Header="<%$ Resources:GridPanel1.DealerType %>"
                                                        Width="80">
                                                        <Renderer Handler="return getDealerTypeName(value);" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ParmetType" DataIndex="ParmetType" Header="<%$ Resources:GridPanel1.ContractType %>"
                                                        Width="120">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="EffectiveDate" DataIndex="EffectiveDate" Header="<%$ Resources:GridPanel1.EffectiveDate %>"
                                                        Width="120">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ExpirationDate" DataIndex="ExpirationDate" Header="<%$ Resources:GridPanel1.ExpirationDate %>"
                                                        Width="120">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Division" DataIndex="Division" Header="<%$ Resources:GridPanel1.Division %>"
                                                        Width="150">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="SubDeptName" DataIndex="SubDeptName" Header="<%$ Resources:GridPanel1.SubDeptName %>"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ContStatus" Width="100" Align="Center" DataIndex="ContStatus"
                                                        Header="<%$ Resources:GridPanel1.Status %>">
                                                        <Renderer Handler="return getNameFromStoreById(StatusStore,{Key:'Key',Value:'Value'},value);" />
                                                    </ext:Column>
                                                    <ext:CommandColumn Hidden="True" Width="50" Header="<%$ Resources:GridPanel1.Detail %>" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                                <ToolTip Text="<%$ Resources:GridPanel1.Detail %>" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                        <PrepareToolbar Fn="prepareCommand" />
                                                    </ext:CommandColumn>
                                                    <ext:CommandColumn Hidden="True" Width="70" Header="<%$ Resources:GridPanel1.TakeEffectState %>" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="NoteEdit" CommandName="TakeEffectState">
                                                                <ToolTip Text="<%$ Resources:GridPanel1.TakeEffectState %>" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="
                                                if (command == 'Edit')
                                                                   {
                                                                    var contid = record.data.ContractID;
                                                                    var parmetType = record.data.ParmetType;
                                                                    var dealerType = record.data.DealerType;
                                                                    
                                                                    window.location.href = '/Pages/Contract/ContractDeatil.aspx?ContractID=' + contid + '&ParmetType=' + parmetType + '&DealerType=' + dealerType;
                                                                   
                                                                   }
                                              
                                                else if (command == 'TakeEffectState')
                                                                   {
                                                                    Coolite.AjaxMethods.Show(record.data.ContractID,{success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});

                                                                   }
                                              " />

                                                <CellClick />
                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                    DisplayInfo="true" EmptyMsg="<%$ Resources:GridPanel1.NoDate %>" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel1.LoadMask.Msg %>" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:ViewPort>
            <ext:Window ID="TakeEffectStateWindow" runat="server" Icon="Group" Title="合同生效状态明细" Width="450" Height="300"
                AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Resizable="false" Header="false" CenterOnLoad="true"
                Y="50" Maximizable="false">
                <Body>
                    <ext:FitLayout ID="FitLayout2" runat="server">
                        <ext:GridPanel ID="GridPanel2" runat="server" Title="合同生效状态明细" StoreID="TakeEffectStateStore" AutoScroll="true"
                            StripeRows="true" Collapsible="false" Border="false" Header="false" Icon="Lorry">
                            <ColumnModel ID="ColumnModel" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="Nbr" DataIndex="Nbr" Header="编号" Width="80">
                                    </ext:Column>
                                    <ext:Column ColumnID="Massage" DataIndex="Massage" Header="状态消息" Width="344">
                                    </ext:Column>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel" SingleSelect="true" runat="server"
                                    MoveEditorOnEnter="true">
                                </ext:RowSelectionModel>
                            </SelectionModel>
                            <SaveMask ShowMask="false" />
                            <LoadMask ShowMask="false" />
                        </ext:GridPanel>
                    </ext:FitLayout>
                </Body>
                <Listeners>
                    <BeforeHide Handler="" />
                </Listeners>
            </ext:Window>
            <ext:Hidden ID="hidInstanceId" runat="server">
            </ext:Hidden>
        </div>
    </form>
</body>
</html>
