<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerPriceQuery.aspx.cs"
    Inherits="DMS.Website.Pages.Order.DealerPriceQuery" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <script type="text/javascript" language="javascript">
    function ComboxSelValue(e) {
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var input = e.query;
                if (input != null && input != '') {
                    // 检索的正则
                    var regExp = new RegExp(".*" + input + ".*");
                    // 执行检索
                    combo.store.filterBy(function(record, id) {
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
    <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="AttributeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Id" Direction="ASC" />
        <Listeners>
            <Load Handler="" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="PriceTypeStore" runat="server" OnRefreshData="PriceTypeStore_RefreshData"
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
    <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="GroupId" />
                    <ext:RecordField Name="SapCode" />
                    <ext:RecordField Name="DmaName" />
                    <ext:RecordField Name="ParentDmaName" />
                    <ext:RecordField Name="CfnId" />
                    <ext:RecordField Name="CustomerFaceNbr" />
                    <ext:RecordField Name="CfnChineseName" />
                    <ext:RecordField Name="CfnDescription" />
                    <ext:RecordField Name="ProductLineBumId" />
                    <ext:RecordField Name="PriceType" />
                    <ext:RecordField Name="PriceTypeValue" />
                    <ext:RecordField Name="Price" />
                    <ext:RecordField Name="Currency" />
                    <ext:RecordField Name="Uom" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hidInitDealerId" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: cbDealer.EmptyText %>" Width="220" Editable="true"
                                                        TypeAhead="false" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                        Mode="Local" FieldLabel="<%$ Resources: cbDealer.FieldLabel %>" ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Triggers.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <BeforeQuery Fn="ComboxSelValue" />
                                                            <TriggerClick Handler="this.clearValue();this.store.clearFilter();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtCfn" runat="server" Width="150" FieldLabel="<%$ Resources: txtCfn.FieldLabel %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources: cbProductLine.EmptyText %>" Width="150" Editable="false"
                                                        TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" Mode="Local" DisplayField="AttributeName"
                                                        FieldLabel="<%$ Resources: cbProductLine.FieldLabel %>" ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Triggers.Qtip %>" />
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
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbPriceType" runat="server" EmptyText="<%$ Resources: cbPriceType.EmptyText %>" Width="150" Editable="false"
                                                        TypeAhead="true" StoreID="PriceTypeStore" ValueField="Key" Mode="Local" DisplayField="Value"
                                                        FieldLabel="<%$ Resources: cbPriceType.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Triggers.Qtip%>" />
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
                            <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text%>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnExport" Text="<%$ Resources: btnExport.Text%>" runat="server" Icon="PageExcel" IDMode="Legacy"
                                AutoPostBack="true" OnClick="ExportExcel">
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 5 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title%>" StoreID="ResultStore"
                                    Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" AutoExpandColumn="ParentDmaName">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="DmaName" DataIndex="DmaName" Header="<%$ Resources: GridPanel1.ColumnModel1.DmaId.Header%>" Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="<%$ Resources: GridPanel1.ColumnModel1.DmaSapCode.Header%>" Width="80">
                                            </ext:Column>
                                            <ext:Column ColumnID="ParentDmaName" DataIndex="ParentDmaName" Header="<%$ Resources: GridPanel1.ColumnModel1.ParentDmaId.Header%>" Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="CustomerFaceNbr" Width="120" DataIndex="CustomerFaceNbr" Header="<%$ Resources: GridPanel1.ColumnModel1.Cfn.Header%>">
                                            </ext:Column>
                                            <ext:Column ColumnID="CfnChineseName" Width="200" DataIndex="CfnChineseName" Header="<%$ Resources: GridPanel1.ColumnModel1.CfnCN.Header%>">
                                            </ext:Column>
                                            <ext:Column ColumnID="CfnDescription" Width="180" DataIndex="CfnDescription" Header="<%$ Resources: GridPanel1.ColumnModel1.CfnEN.Header%>">
                                            </ext:Column>
                                            <ext:Column ColumnID="ProductLineBumId" Width="100" DataIndex="ProductLineBumId"
                                                Header="<%$ Resources: GridPanel1.ColumnModel1.ProductLine.Header%>">
                                                <Renderer Handler="return getNameFromStoreById(ProductLineStore,{Key:'Id',Value:'AttributeName'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="PriceTypeValue" DataIndex="PriceTypeValue" Header="<%$ Resources: GridPanel1.ColumnModel1.PriceType.Header%>" Width="80">
                                            </ext:Column>
                                            <ext:Column ColumnID="Price" Width="70" Align="Right" DataIndex="Price" Header="<%$ Resources: GridPanel1.ColumnModel1.CfnPrice.Header%>">
                                            </ext:Column>
                                            <ext:Column ColumnID="Currency" Width="70" Align="Center" DataIndex="Currency" Header="<%$ Resources: GridPanel1.ColumnModel1.Currency.Header%>">
                                            </ext:Column>
                                            <ext:Column ColumnID="Uom" Width="70" Align="Center" DataIndex="Uom" Header="<%$ Resources: GridPanel1.ColumnModel1.Uom.Header%>">
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <Command Handler="" />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="ResultStore"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
