<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderApplyLP.aspx.cs" Inherits="DMS.Website.Pages.Order.OrderApplyLP"
    ValidateRequest="false" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/OrderDetailWindowLP.ascx" TagName="OrderDetailWindowLP"
    TagPrefix="uc" %>
<%@ Register Src="../../Controls/OrderCfnDialogLP.ascx" TagName="OrderCfnDialogLP"
    TagPrefix="uc" %>
<%@ Register Src="../../Controls/OrderCfnSetDialog.ascx" TagName="OrderCfnSetDialog"
    TagPrefix="uc" %>
<%@ Register Src="../../Controls/OrderCfnDialogLPPRO.ascx" TagName="OrderCfnDialogLPPRO"
    TagPrefix="uc" %>
<%@ Register Src="../../Controls/OrderHospital.ascx" TagName="OrderHospital"
    TagPrefix="uc" %>
    
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
    <style type="text/css">        
        .yellow-row
        {
            background: #FFFF99;
        }
    </style>

    <script type="text/javascript" language="javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });
        //刷新父窗口查询结果
        function RefreshMainPage() {
            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
        }
        
        var OrderApplyMsgList = {
            msg1:"<%=GetLocalResourceObject("loadExample.subMenu230").ToString()%>"
        }
        
        var orderModify = function (value, cellmeta, record, rowIndex, columnIndex, store) {
            var isNotHQ = Ext.getCmp('<%=this.hidCorpType.ClientID%>').getValue() == "HQ" ? false : true;
             var orderType = record.data['OrderType'];      
             var productLine = record.data['ProductLineBumId'];            
            if ('<%=IsDealer.ToString() %>'=='True' && isNotHQ ){
                if((productLine != '8f15d92a-47e4-462f-a603-f61983d61b7b' && Ext.getCmp('<%=this.hidCorpType.ClientID%>').getValue() == 'T1') || Ext.getCmp('<%=this.hidCorpType.ClientID%>').getValue() == 'LP'|| Ext.getCmp('<%=this.hidCorpType.ClientID%>').getValue() == 'LS')
                {
                    if (value == '<%=PurchaseOrderStatus.Submitted.ToString() %>' || value == '<%=PurchaseOrderStatus.Uploaded.ToString() %>' ){
                       if (orderType == '<%=PurchaseOrderType.Normal.ToString() %>' || orderType == '<%=PurchaseOrderType.SpecialPrice.ToString() %>' || orderType == '<%=PurchaseOrderType.Transfer.ToString() %>'|| orderType == '<%=PurchaseOrderType.ClearBorrowManual.ToString() %>' || orderType == '<%=PurchaseOrderType.PEGoodsReturn.ToString() %>' || orderType == '<%=PurchaseOrderType.EEGoodsReturn.ToString() %>' || orderType == '<%=PurchaseOrderType.BOM.ToString() %>'){
                         return '<img class="imgModify" ext:qtip="<%=GetLocalResourceObject("OrderModify.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/page_edit.png" />';
                       }
                    } 
                }
            }
            
        }
        
         var PrintRender = function () {
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
            
           
            if (t.className == 'imgModify' && columnId == 'Id') {
                var ordertype = record.data['OrderType'];
                if (ordertype == '<%=PurchaseOrderType.ClearBorrowManual.ToString() %>')
                {
                    Ext.Msg.alert('提示', '清指定批号订单已提交，如要修改，请撤销订单后重新申请！');
                }
                else
                {
                   //存放headerId
                   Ext.getCmp('<%=this.hidHeaderId.ClientID%>').setValue(id);
                   var dealerStore = Ext.getCmp('<%=this.cbDealer.ClientID%>').store;
                   //先调用方法，复制一个订单              
                   Coolite.AjaxMethods.OrderApplyLP.CopyForTemporary(id,
                                                    {
                                                        success: function() {
                                                              if (Ext.getCmp('<%=this.hidRtnVal.ClientID%>').getValue() == "statusChange") {                       
                                                                    Ext.Msg.alert('Error', '<%=GetLocalResourceObject("cellClick.Error.statusChange").ToString()%>');
                                                              } else if (Ext.getCmp('<%=this.hidRtnVal.ClientID%>').getValue() == "Success") {
                                                                    
                                                                    var newHeaderId = Ext.getCmp('<%=this.hidNewOrderInstanceId.ClientID%>').getValue();
                                                                    
                                                                    //打开这个订单
                                                                    Coolite.AjaxMethods.OrderDetailWindowLP.Show(newHeaderId,id,getNameFromStoreById(dealerStore,{Key:'Id',Value:'ChineseName'},id),
                                                                    {
                                                                        success:function(){
                                                                          RefreshDetailWindow();
                                                                        },
                                                                        failure:function(err){
                                                                          Ext.Msg.alert('Error', err);
                                                                        }
                                                                    });
                                                                    
                                                              }
                                                        },
                                                        failure: function(err) {
                                                            Ext.Msg.alert('Error', err);
                                                        }
                                                    });
               //获取新订单的ID
               
               //打开复制的               
                }
            }
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
        
    function getIsAutoGenClearBorrowRowClass(record, index) {
        if (record.data.IsAutoGenClearBorrow > 0 && record.data.OrderStatus =='<%=PurchaseOrderStatus.Draft.ToString() %>')
        {
           return 'yellow-row';
              
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
            <%--<Load Handler="#{cbProductLine}.setValue(#{cbProductLine}.store.getTotalCount()>0?#{cbProductLine}.store.getAt(0).get('Id'):'');" />--%>
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
        <%-- <Listeners>
            <Load Handler="#{cbDealer}.setValue(#{hidInitDealerId}.getValue());" />
        </Listeners>--%>
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
        <SortInfo Field="Key" Direction="ASC" />
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
                    <ext:RecordField Name="IsAutoGenClearBorrow" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hidInitDealerId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidHeaderId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidNewOrderInstanceId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidRtnVal" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidRtnMsg" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidCorpType" runat="server">
    </ext:Hidden>
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
                                                        Mode="Local" DisplayField="AttributeName" FieldLabel="<%$ Resources: cbProductLine.FieldLabel %>"
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
                                                        Mode="Local" DisplayField="Value" FieldLabel="<%$ Resources: cbOrderStatus.FieldLabel %>">
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
                                                    <ext:TextField ID="txRemark" runat="server" Width="150" FieldLabel="<%$ Resources: txRemark.FieldLabel %>" />
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
                                 
                                    <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: btnInsert.Text %>"
                                Icon="Add" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="Coolite.AjaxMethods.OrderDetailWindowLP.Show('00000000-0000-0000-0000-000000000000',#{cbDealer}.getValue(),#{cbDealer}.getRawValue(),{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnImport" runat="server" Text="<%$ Resources: btnImport.Text %>"
                                Icon="Disk" IDMode="Legacy">
                                <Listeners>
                                    <%--<Click Handler="window.parent.loadExample('/Pages/Order/OrderImportLP.aspx','subMenu230',OrderApplyMsgList.msg1);" />--%>
                                    <Click Handler="top.createTab({id: 'subMenu230',title: '导入',url: 'Pages/Order/OrderImportLP.aspx'});" />

                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnSubmit" Text="导出操作日志" runat="server" Icon="PageExcel" IDMode="Legacy"
                                AutoPostBack="true" OnClick="ExportExcel">
                            </ext:Button>
                            <ext:Button ID="btnExpInvoice" Text="导出发票" runat="server" Icon="PageExcel" IDMode="Legacy"
                                AutoPostBack="true" OnClick="ExportInvoice">
                            </ext:Button>
                            <ext:Button ID="btnExpDetail" Text="导出明细" runat="server" Icon="PageExcel" IDMode="Legacy"
                                AutoPostBack="true" OnClick="ExportDetail">
                            </ext:Button>
                            <ext:Button ID="btnStockprice" runat="server" Text="库存及价格查询"
                                Icon="ArrowRefresh" IDMode="Legacy"  >
                                <Listeners>
                                   <%-- <Click Handler="window.parent.loadExample('/Pages/Inventory/QueryInventoryPrice.aspx', 'we', '库存及价格查询');" />--%>

                                    <Click Handler="top.createTab({id: 'we',title: '库存及价格查询',url: 'Pages/Inventory/QueryInventoryPrice.aspx'});" />
                                </Listeners>
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
                                            <ext:Column ColumnID="TotalAmount" DataIndex="TotalAmount" Width="80" Align="Right"
                                                Header="<%$ Resources: GridPanel1.ColumnModel1.TotalAmount.Header %>">
                                                <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                            </ext:Column>
                                            <ext:Column ColumnID="SubmitDate" DataIndex="SubmitDate" Align="Center" Header="<%$ Resources: GridPanel1.ColumnModel1.SubmitDate.Header %>">
                                                <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                            </ext:Column>
                                            <ext:Column ColumnID="ShipToAddress" DataIndex="ShipToAddress" Width="150" Header="<%$ Resources: GridPanel1.ColumnModel1.ShipToAddress.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="Remark" DataIndex="Remark" Header="<%$ Resources: GridPanel1.ColumnModel1.Remark.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="OrderType" DataIndex="OrderType" Align="Center" Width="100"
                                                Header="<%$ Resources: GridPanel1.ColumnModel1.OrderType.Header %>">
                                                <Renderer Handler="return getNameFromStoreById(OrderTypeStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="OrderStatus" DataIndex="OrderStatus" Align="Center" Width="80"
                                                Header="<%$ Resources: GridPanel1.ColumnModel1.OrderStatus.Header %>">
                                                <Renderer Handler="return getNameFromStoreById(OrderStatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:CommandColumn ColumnID="OrderDetail" Align="Center" Width="50" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                            <ext:Column ColumnID="Id" DataIndex="OrderStatus" Align="Center" Width="50" Header="<%$ Resources:GridPanel1.ColumnModel1.Modify.Header %>">
                                                <Renderer Fn="orderModify" />
                                            </ext:Column>
                                            <ext:Column ColumnID="Print" DataIndex="DmaId" Align="Center" Width="50" Header="<%$ Resources: GridPanel1.ColumnModel1.Print.Header %>">
                                                <Renderer Fn="PrintRender" />
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <View>
                                        <ext:GridView ID="GridView1" runat="server">
                                            <GetRowClass Fn="getIsAutoGenClearBorrowRowClass" />
                                        </ext:GridView>
                                    </View>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <Command Handler="Coolite.AjaxMethods.OrderDetailWindowLP.Show(record.data.Id,record.data.DmaId,getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},record.data.DmaId),{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                        <CellClick Fn="cellClick" />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="ResultStore"
                                            DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}"  />
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
    <uc:OrderDetailWindowLP ID="OrderDetailWindowLP1" runat="server" />
    <uc:OrderCfnDialogLP ID="OrderCfnDialog1" runat="server" />
    <uc:OrderCfnSetDialog ID="OrderCfnSetDialog1" runat="server" />
    <uc:OrderCfnDialogLPPRO ID="OrderCfnDialogPro1" runat="server" />
    <uc:OrderHospital ID="OrderHospital1" runat="server" />
     
    <ext:Window ID="WindowPrintOrderSet" runat="server" Title="<%$ Resources: OrderPrint.img.ext:qtip %>"
        Width="680" Height="450" Modal="true" Collapsible="false" Maximizable="false"
        ShowOnLoad="false">
        <AutoLoad Mode="IFrame">
        </AutoLoad>
    </ext:Window>
     <ext:Hidden ID="dealerData" runat="server">
    </ext:Hidden>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
