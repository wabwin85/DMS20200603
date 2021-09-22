<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="POReceiptList.aspx.cs"
    Inherits="DMS.Website.Pages.POReceipt.POReceiptList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/POReceiptListDetail.ascx" TagName="POReceiptListDetail"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
        var MsgList = {
			ShowDetails:{
				FailureTitle:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Command.Alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Command.Alert.Body").ToString()%>"
			},
			GoodsLendingTitle:"<%=GetLocalResourceObject("MsgList.GoodsLendingTitle").ToString()%>"
        }

        var renderDealer = function(value) {
            var dealerName = "";
            var json_data = Ext.getCmp('dealerData').getValue();

            dealerName = getValueFromArray(json_data, value);
            return dealerName;
        }
        
        var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
            var id = record.data['Id'];
            if (t.className == 'imgPrint' && columnId == 'Id') {
               //showModalDialog("POReceiptPrint.aspx?id=" + id, window, "status:false;dialogWidth:850px;dialogHeight:550px");
               window.open("POReceiptPrint.aspx?id=" + id,'newwindow',
               'status=no,width=850px,height=550px,scrollbars=yes,resizable=yes,location=no,top=50,left=100');
            }
        }
        
        var poreceiptPrint = function() {
            return '<img class="imgPrint" ext:qtip="<%=GetLocalResourceObject("poreceiptPrint.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/printer.png" />';
        }
        
        function SelectValue(e) {
            var filterField = 'ChineseShortName';  //需进行模糊查询的字段
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
               var value = e.query;
                if (value != null && value != '') {
                    combo.store.filterBy(function (record, id) {
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
    //触发函数
        function downloadfile(url) {    
            var iframe = document.createElement("iframe");
            iframe.src = url;
            iframe.style.display = "none";
            document.body.appendChild(iframe);
        }

        function SetTabLogActivate() {
            var gpLog = Ext.getCmp('<%=this.gpLog.ClientID%>');
            gpLog.store.reload();
        }
    </script>

</head>
<body>
    <iframe id="ifile" style="display: none"></iframe>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
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
    </ext:Store>
    <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ChineseShortName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--<Listeners>
            <Load Handler="#{cbDealer}.setValue(#{hidInitDealerId}.getValue());" />
        </Listeners>--%>
        <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="ReceiptStatusStore" runat="server" UseIdConfirmation="true">
        <%--      <BaseParams>
            <ext:Parameter Name="Type" Value="CONST_Receipt_Status" Mode="Value">
            </ext:Parameter>
        </BaseParams>--%>
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Key" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="ReceiptTypeStore" runat="server" UseIdConfirmation="true">
        <%--        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>--%>
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Key" Direction="ASC" />
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
                    <ext:RecordField Name="PoNumber" />
                    <ext:RecordField Name="SapShipmentid" />
                    <ext:RecordField Name="DealerDmaId" />
                    <ext:RecordField Name="ReceiptDate" />
                    <ext:RecordField Name="SapShipmentDate" />
                    <ext:RecordField Name="ReceiptUserName" />
                    <ext:RecordField Name="Status" />
                    <ext:RecordField Name="VendorDmaId" />
                    <ext:RecordField Name="Type" />
                    <ext:RecordField Name="TotalQyt" />
                    <ext:RecordField Name="PurchaseOrderNbr" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--
            <SortInfo Field="DealerDmaId" Direction="ASC" />
             --%>
    </ext:Store>
    <ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="PohId" />
                    <ext:RecordField Name="OperUser" />
                    <ext:RecordField Name="OperUserId" />
                    <ext:RecordField Name="OperUserName" />
                    <ext:RecordField Name="OperType" />
                    <ext:RecordField Name="OperTypeName" />
                    <ext:RecordField Name="OperDate" Type="Date" />
                    <ext:RecordField Name="OperNote" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hidInitDealerId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="HiddFileName" runat="server" />
    <ext:Hidden ID="HiddDowleName" runat="server" />
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
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout1.cbProductLine.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                        DisplayField="AttributeName" FieldLabel="<%$ Resources: Panel1.FormLayout1.cbProductLine.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout1.cbProductLine.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtStartDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout1.txtStartDate.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtSapShipmentid" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout1.txtSapShipmentid.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtOrderNo" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout1.txtOrderNo.FieldLabel %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".4">
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout2.cbDealer.EmptyText %>"
                                                        Width="220" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                                        DisplayField="ChineseShortName" Mode="Local" FieldLabel="<%$ Resources: Panel1.FormLayout2.cbDealer.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout2.cbDealer.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                            <BeforeQuery Fn="ComboxSelValue" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtEndDate.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtCFN" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtUPN" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtUPN.FieldLabel %>"
                                                        Hidden="<%$ AppSettings: HiddenUPN  %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbReceiptType" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout3.cbReceiptType.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="ReceiptTypeStore" ValueField="Key"
                                                        DisplayField="Value" FieldLabel="<%$ Resources: Panel1.FormLayout3.cbReceiptType.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout3.cbReceiptType.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbReceiptStatus" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout3.cbReceiptStatus.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="ReceiptStatusStore" ValueField="Key"
                                                        DisplayField="Value" FieldLabel="<%$ Resources: Panel1.FormLayout3.cbReceiptStatus.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout3.cbReceiptStatus.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtLotNumber" runat="server" Width="150" FieldLabel="批号/二维码" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                        <ext:Button ID="btnImport" Text="平台及RLD发货数据导入" runat="server"
                                Icon="PageExcel" IDMode="Legacy">
                                <Listeners>
                                    <%--<Click Handler="window.parent.loadExample('/Pages/POReceipt/POReceiPtImport.aspx','subMenu301','收货数据批量上传');" />--%>
                                    <Click Handler="top.createTab({id: 'subMenu301',title: '收货数据批量上传',url: 'Pages/POReceipt/POReceiPtImport.aspx'});" />

                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: Panel1.btnSearch.Text %>" runat="server"
                                Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <%-- <Click Handler="#{GridPanel1}.reload();" />--%>
                                    <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: Panel1.btnInsert.Text %>"
                                Icon="Add" IDMode="Legacy">
                                <Listeners>
                                    <%--<Click Handler="window.parent.loadExample('/Pages/Transfer/TransferList.aspx','subMenu81',MsgList.GoodsLendingTitle);" />--%>
                                    <Click Handler="top.createTab({id: 'subMenu81',title: '导入',url: 'Pages/Transfer/TransferList.aspx'});" />

                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnExport" Text="<%$ Resources: Export %>" runat="server" Icon="PageExcel"
                                IDMode="Legacy" AutoPostBack="true" OnClick="ExportExcel">
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                    StoreID="ResultStore" StripeRows="true" Border="false" Icon="Lorry" AutoWidth="true"
                                    AutoExpandColumn="VendorDmaId">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="DealerDmaId" DataIndex="DealerDmaId" Header="<%$ Resources: GridPanel1.ColumnModel1.DealerDmaId.Header %>"
                                                Width="160">
                                                <Renderer Fn="renderDealer" />
                                            </ext:Column>
                                            <ext:Column ColumnID="SapShipmentid" DataIndex="SapShipmentid" Header="<%$ Resources: GridPanel1.ColumnModel1.SapShipmentid.Header %>"
                                                Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="PurchaseOrderNbr" DataIndex="PurchaseOrderNbr" Header="<%$ Resources: GridPanel1.ColumnModel1.PurchaseOrderNbr.Header %>"
                                                Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="PoNumber" DataIndex="PoNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.PoNumber.Header %>"
                                                Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="Type" DataIndex="Type" Header="<%$ Resources: GridPanel1.ColumnModel1.Type.Header %>"
                                                Width="70">
                                                <Renderer Handler="return getNameFromStoreById(ReceiptTypeStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="VendorDmaId" DataIndex="VendorDmaId" Header="<%$ Resources: GridPanel1.ColumnModel1.VendorDmaId.Header %>">
                                                <Renderer Fn="renderDealer" />
                                            </ext:Column>
                                            <ext:Column ColumnID="TotalQyt" DataIndex="TotalQyt" Header="<%$ Resources: GridPanel1.ColumnModel1.TotalQyt.Header %>"
                                                Width="60" Align="Right">
                                            </ext:Column>
                                            <ext:Column ColumnID="SapShipmentDate" DataIndex="SapShipmentDate" Header="<%$ Resources: GridPanel1.ColumnModel1.SapShipmentDate.Header %>"
                                                Width="80">
                                            </ext:Column>
                                            <ext:Column ColumnID="ReceiptDate" DataIndex="ReceiptDate" Header="<%$ Resources: GridPanel1.ColumnModel1.ReceiptDate.Header %>"
                                                Width="80">
                                            </ext:Column>
                                            <ext:Column ColumnID="ReceiptUserName" DataIndex="ReceiptUserName" Header="<%$ Resources: GridPanel1.ColumnModel1.ReceiptUserName.Header %>"
                                                Width="0">
                                            </ext:Column>
                                            <ext:Column ColumnID="Status" DataIndex="Status" Header="<%$ Resources: GridPanel1.ColumnModel1.Status.Header %>"
                                                Width="50">
                                                <Renderer Handler="return getNameFromStoreById(ReceiptStatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:CommandColumn Width="50" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>"
                                                Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.ToolTip.Text %>" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                            <ext:Column ColumnID="Id" DataIndex="Id" Header="<%$ Resources:GridPanel1.ColumnModel1.Id.Header %>"
                                                Align="Center" Width="50">
                                                <Renderer Fn="poreceiptPrint" />
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <AjaxEvents>
                                        <Command OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.ShowDetails.FailureTitle, MsgList.ShowDetails.FailureMsg);"
                                            Success="#{GridPanel2}.reload();#{TabPanel1}.setActiveTab(0);">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                            <ExtraParams>
                                                <ext:Parameter Name="PHR_ID" Value="#{GridPanel1}.getSelectionModel().getSelected().id"
                                                    Mode="Raw">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Command>
                                    </AjaxEvents>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" Msg="<%$ Resources: DetailStore.Listeners.Alert %>" />
                                    <Listeners>
                                        <CellClick Fn="cellClick" />
                                    </Listeners>
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CFN" />
                    <ext:RecordField Name="UPN" />
                    <ext:RecordField Name="LotNumber" />
                    <ext:RecordField Name="ExpiredDate" />
                    <ext:RecordField Name="UnitOfMeasure" />
                    <ext:RecordField Name="ReceiptQty" />
                    <ext:RecordField Name="CFNChineseName" />
                    <ext:RecordField Name="CFNEnglishName" />
                    <ext:RecordField Name="DCMQty" />
                    <ext:RecordField Name="LotDOM" />
                    <ext:RecordField Name="QRCode" />
                    <ext:RecordField Name="Property1" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('Load Exception', e.message || response.statusText);" />
        </Listeners>
        <%--        <SortInfo Field="CFN" Direction="ASC" />--%>
    </ext:Store>
    <ext:Hidden ID="hiddenHeaderId" runat="server">
    </ext:Hidden>
    <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
        Width="900" Height="490" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
        <Body>
            <ext:BorderLayout ID="BorderLayout2" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn ColumnWidth=".4">
                                    <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="50">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtDealer" runat="server" Width="200" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.txtDealer.Header %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtVendor" runat="server" Width="200" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.txtVendor.Header %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtCarrier" runat="server" Width="200" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.txtCarrier.Header %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtWarehouse" runat="server" Width="200" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.txtWarehouse.Header %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="60">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtSapNumber" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout5.txtSapNumber.Header %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtDate" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout5.txtDate.Header %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtTrackingNo" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout5.txtTrackingNo.Header %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtFromWarehouse" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout5.txtFromWarehouse.Header %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="60">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtPoNumber" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtPoNumber.Header %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtStatus" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtStatus.Header %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtShipType" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtShipType.Header %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 5 5">
                    <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                        <Tabs>
                            <ext:Tab ID="TabSearch" runat="server" Title="<%$ Resources:TabPanel1.TabSearch.Text%>"
                                AutoScroll="false">
                                <Body>
                                    <ext:FitLayout ID="FitLayout2" runat="server">
                                        <ext:GridPanel ID="GridPanel2" runat="server" Title="<%$ Resources:GridPanel2.TabSearchResult.Text%>"
                                            StoreID="DetailStore" Border="false" Icon="Lorry" StripeRows="true" EnableHdMenu="false"
                                            Header="false" AutoExpandColumn="CFNEnglishName">
                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="CFN" DataIndex="CFN" Header="<%$ Resources: resource,Lable_Article_Number  %>" Width="110">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UPN" DataIndex="UPN" Header="<%$ Resources: GridPanel2.ColumnModel2.UPN.Header %>" Width="110"
                                                        Hidden="<%$ AppSettings: HiddenUPN  %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CFNChineseName" DataIndex="CFNChineseName" Header="<%$ Resources:CFNChineseName %>" Width="120">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CFNEnglishName" DataIndex="CFNEnglishName" Header="<%$ Resources: CFNEnglishName %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel2.ColumnModel2.LotNumber.Header %>" Width="90" Align="Center">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Width="90" Align="Center">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources: GridPanel2.ColumnModel2.ExpiredDate.Header %>" Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources: GridPanel2.ColumnModel2.UnitOfMeasure.Header %>"
                                                       Width="40" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ReceiptQty" DataIndex="ReceiptQty" Header="<%$ Resources: GridPanel2.ColumnModel2.ReceiptQty.Header %>"
                                                        Align="Right" Width="50">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DCMQty" DataIndex="DCMQty" Header="<%$ Resources: GridPanel2.ColumnModel2.DCMQty.Header %>"
                                                        Align="Right" Width="50">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="LotDOM" DataIndex="LotDOM" Header="产品生产日期" Width="90" Align="Center">
                                                    </ext:Column>
                                                    <ext:CommandColumn Header="批次质检报告(CoA)下载" Align="Center" Width="60">
                                                        <Commands>
                                                            <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                <ToolTip Text="批次质检报告(CoA)下载" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="DetailStore"
                                                    DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                                            <Listeners>
                                                <Command Handler="if (command == 'DownLoad')     
                                                   {
                                             Coolite.AjaxMethods.DownloadPdf(record.data.LotNumber,record.data.Property1,record.data.UPN,
                                                {success:function(){
                                            var Downame=#{HiddDowleName}.getValue();
                                            if(Downame!='')
                                             {
                                             var fileName=#{HiddFileName}.getValue();
                                               var url = '../Download.aspx?downloadname=' + escape(Downame) + '&fileName=' + escape(fileName) + '&downtype=COA';
                                              downloadfile(url);
                                                 }
                                                },failure:function(err){Ext.Msg.alert('Error', err);}});
                                               }" />
                                            </Listeners>
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources:TabLog.Text%>" AutoScroll="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout3" runat="server">
                                        <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources:TabLog.gpLog.Text%>"
                                            StoreID="OrderLogStore" Border="false" Icon="Lorry" StripeRows="true" EnableHdMenu="false"
                                            Header="false" AutoExpandColumn="OperNote">
                                            <ColumnModel ID="ColumnModel3" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="<%$ Resources:TabLog.OperUserId.Text%>"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources:TabLog.OperUserName.Text%>"
                                                        Width="150">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="<%$ Resources:TabLog.OperTypeName.Text%>"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="<%$ Resources:TabLog.OperDate.Text%>"
                                                        Width="150">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources:TabLog.OperNote.Text%>">
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                    MoveEditorOnEnter="true">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="10" StoreID="OrderLogStore"
                                                    DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                            </BottomBar>
                                            <SaveMask ShowMask="false" />
                                            <LoadMask ShowMask="true" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                                <Listeners>
                                    <Activate Handler="SetTabLogActivate();" />
                                </Listeners>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </Center>
            </ext:BorderLayout>
        </Body>
        <Listeners>
            <Hide Handler="#{GridPanel2}.clear()" />
        </Listeners>
        <Buttons>
            <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: DetailWindow.SaveButton.Text %>"
                Icon="LorryAdd">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.DoConfirm();" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources: DetailWindow.CancelButton.Text %>"
                Icon="Cross">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.DoCancel();" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
    <ext:Hidden ID="dealerData" runat="server">
    </ext:Hidden>
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
