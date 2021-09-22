<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderAudit.aspx.cs" Inherits="DMS.Website.Pages.Order.OrderAudit" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/OrderDetailWindowLPForAudit.ascx" TagName="OrderDetailWindowLP"
    TagPrefix="uc" %>
<%@ Register Src="../../Controls/OrderCfnDialog.ascx" TagName="OrderCfnDialog" TagPrefix="uc" %>
<%@ Register Src="../../Controls/OrderCfnSetDialog.ascx" TagName="OrderCfnSetDialog"
    TagPrefix="uc" %>
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
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });
        //刷新父窗口查询结果
        function RefreshMainPage() {
            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
        }
        function SelectValue(e) {
            var filterField = 'ChineseShortName';  //需进行模糊查询的字段
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var value = e.query;
                if (value != null && value != '') {
                    combo.store.filterBy(function(record, id) {
                        var text = record.get(filterField);
                        if (text != null && text != "") {
                            // 用自己的过滤规则,如写正则式
                            return (text.indexOf(value) != -1);
                        }
                        else {
                            return false;
                        }
                    });
                } else {
                    combo.store.clearFilter();
                }
                combo.onLoad(); //不加第一次会显示不出来  
                combo.expand();
                return false;
            }
        }
        var PrintRender = function() {
            return '<img class="imgPrint" ext:qtip="<%=GetLocalResourceObject("OrderPrint.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/printer.png" />';

        }

        var cellClick = function(grid, rowIndex, columnIndex, e) {

            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record           

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
            var id = record.data['Id'];
            if (t.className == 'imgPrint' && columnId == 'Print') {
                window.open("OrderPrint.aspx?OrderID=" + id);
            }
        }
        
    </script>

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
            <%--<Load Handler="#{cbProductLine}.setValue(#{cbProductLine}.store.getTotalCount()>0?#{cbProductLine}.store.getAt(0).get('Id'):'');"  />--%>
        </Listeners>
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
        <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="OrderStatusStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--<SortInfo Field="Key" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="OrderTypeStore" runat="server" UseIdConfirmation="true">
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
                    <ext:RecordField Name="DmaSapCode" />
                    <ext:RecordField Name="OrderNo" />
                    <ext:RecordField Name="ProductLineBumId" />
                    <ext:RecordField Name="DmaId" />
                    <ext:RecordField Name="OrderStatus" />
                    <ext:RecordField Name="OrderType" />
                    <ext:RecordField Name="SubmitUser" />
                    <ext:RecordField Name="SubmitDate" Type="Date" />
                    <ext:RecordField Name="IsLocked" />
                    <ext:RecordField Name="TotalQty" />
                    <ext:RecordField Name="TotalAmount" />
                    <ext:RecordField Name="ShipToAddress" />
                    <ext:RecordField Name="Remark" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true"
                        BodyStyle="padding: 5px;" Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources: cbProductLine.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                        DisplayField="AttributeName" FieldLabel="<%$ Resources: cbProductLine.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Triggers.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtSubmitDateStart" runat="server" Width="150" FieldLabel="<%$ Resources: txtSubmitDateStart.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtCfn" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" />
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
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: cbDealer.EmptyText %>"
                                                        Width="220" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                                        DisplayField="ChineseShortName" Mode="Local" FieldLabel="<%$ Resources: cbDealer.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Triggers.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();this.store.clearFilter();" />
                                                            <BeforeQuery Fn="SelectValue" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtSubmitDateEnd" runat="server" Width="150" FieldLabel="<%$ Resources: txtSubmitDateEnd.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtOrderNo" runat="server" Width="150" FieldLabel="<%$ Resources: txtOrderNo.FieldLabel %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbOrderStatus" runat="server" EmptyText="<%$ Resources: cbOrderStatus.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="OrderStatusStore" ValueField="Key"
                                                        DisplayField="Value" FieldLabel="<%$ Resources: cbOrderStatus.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Triggers.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbOrderType" runat="server" EmptyText="<%$ Resources: cbOrderType.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="OrderTypeStore" ValueField="Key"
                                                        Mode="Local" DisplayField="Value" FieldLabel="<%$ Resources: cbOrderType.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Triggers.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="Remark" runat="server" Width="150" FieldLabel="备注" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text %>" runat="server"
                                Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <%-- <Click Handler="#{GridPanel1}.reload();" />--%>
                                    <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnSubmit" Text="导出操作日志" runat="server" Icon="PageExcel" IDMode="Legacy"
                                AutoPostBack="true" OnClick="ExportExcel">
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 5 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                    StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true"
                                    AutoExpandColumn="Remark">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="DmaId" DataIndex="DmaId" Header="<%$ Resources: GridPanel1.ColumnModel1.DmaId.Header %>"
                                                Width="200">
                                                <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="DmaSapCode" DataIndex="DmaSapCode" Header="<%$ Resources: GridPanel1.ColumnModel1.DmaSapCode.Header %>"
                                                Width="70">
                                            </ext:Column>
                                            <ext:Column ColumnID="OrderNo" DataIndex="OrderNo" Header="<%$ Resources: GridPanel1.ColumnModel1.OrderNo.Header %>"
                                                Width="120">
                                            </ext:Column>
                                            <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Width="70" Align="Right" Header="<%$ Resources: GridPanel1.ColumnModel1.TotalQty.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="TotalAmount" DataIndex="TotalAmount" Width="80" Align="Right" Header="<%$ Resources: GridPanel1.ColumnModel1.TotalAmount.Header %>">
                                                <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                            </ext:Column>
                                            <ext:Column ColumnID="SubmitDate" DataIndex="SubmitDate" Align="Center" Header="<%$ Resources: GridPanel1.ColumnModel1.SubmitDate.Header %>">
                                                <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                            </ext:Column>
                                            <ext:Column ColumnID="ShipToAddress" DataIndex="ShipToAddress" Width="150" Header="<%$ Resources: GridPanel1.ColumnModel1.ShipToAddress.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="Remark" DataIndex="Remark" Header="<%$ Resources: GridPanel1.ColumnModel1.Remark.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="OrderType" DataIndex="OrderType" Width="100" Align="Center" Header="<%$ Resources: GridPanel1.ColumnModel1.OrderType.Header %>">
                                                <Renderer Handler="return getNameFromStoreById(OrderTypeStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="OrderStatus" DataIndex="OrderStatus" Width="80" Align="Center" Header="<%$ Resources: GridPanel1.ColumnModel1.OrderStatus.Header %>">
                                                <Renderer Handler="return getNameFromStoreById(OrderStatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:CommandColumn Width="50" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>"
                                                Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                            <ext:Column ColumnID="Print" DataIndex="DmaId" Align="Center" Width="50" Header="<%$ Resources: GridPanel1.ColumnModel1.Print.Header %>">
                                                <Renderer Fn="PrintRender" />
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <Command Handler="Coolite.AjaxMethods.OrderDetailWindowLP.Show(record.data.Id,{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                        <CellClick Fn="cellClick" />
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
    <uc:OrderDetailWindowLP ID="OrderDetailWindow1" runat="server" />
    <%--<uc:OrderCfnDialog ID="OrderCfnDialog1" runat="server" />
    <uc:OrderCfnSetDialog ID="OrderCfnSetDialog1" runat="server" />--%>
    </form>
    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>
</body>
</html>
