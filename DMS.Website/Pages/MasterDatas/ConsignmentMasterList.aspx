<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConsignmentMasterList.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.ConsignmentMasterList" ValidateRequest="false"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<%@ Register Src="../../Controls/ConsignmentMasterWindow.ascx" TagName="ConsignmentMasterWindow" TagPrefix="uc" %>
<%@ Register Src="../../Controls/ConsignmentCfnDialog.ascx" TagName="ConsignmentCfnDialog" TagPrefix="uc" %>
<%@ Register Src="../../Controls/ConsignmentCfnSetDialog.ascx" TagName="ConsignmentCfnSetDialog" TagPrefix="uc" %>
<%@ Register Src="../../Controls/ConsignmentDealerDailog.ascx" TagName="ConsignmentDealerDailog" TagPrefix="uc" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
<link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
    <script src="../../resources/Calculate.js" type="text/javascript"></script>
    <script type="text/javascript"  language="javascript">
      Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });
       
        var MsgList = {
			btnInsert:{
				FailureTitle:"<%=GetLocalResourceObject("Panel1.btnInsert.Alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("Panel1.btnInsert.Alert.Body").ToString()%>"
			},
			ShowDetails:{
				FailureTitle:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Alert.Body").ToString()%>"
			},
			Error:"<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>"
        }
        
        function RefreshMainPage() {
            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
        }

        
        var OrderApplyMsgList = {
            msg1:"<%=GetLocalResourceObject("loadExample.subMenu300").ToString()%>",
            msg2:"<%=GetLocalResourceObject("loadExample.subMenu301").ToString()%>"
        }
        
        
        var ReloadGridByType = function()
        {
            var detailGrid = Ext.getCmp('GridPanel1');
            detailGrid.store.reload();
            
        }
        
         var SetCellCssEditable  = function(v,m){
        m.css = "editable-column";
        return v;
        }
        
         var SetCellCssNonEditable  = function(v,m){
            m.css = "nonEditable-column";
            return v;
        }
        
        
         var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
            var id = record.data['Id'];
            
        }
        </script>
    
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
                    <ext:RecordField Name="ChineseName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="DealerTypeMainStore" runat="server" UseIdConfirmation="true" OnRefreshData="DealerTypeStore_RefreshData">
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
                    <ext:RecordField Name="OrderNo" />
                    <ext:RecordField Name="ProductLineId" />
                    <ext:RecordField Name="ConsignmentName" />
                    <ext:RecordField Name="ConsignmentDay" />
                    <ext:RecordField Name="DelayTime" />
                    <ext:RecordField Name="StartDate" />
                    <ext:RecordField Name="EndDate" />
                    <ext:RecordField Name="OrderStatus" />
                    <ext:RecordField Name="OrderType" />
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
                                                    <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout1.cbProductLine.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                        DisplayField="AttributeName" FieldLabel="<%$ Resources: Panel1.FormLayout1.cbProductLine.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout1.FieldTrigger.Qtip %>" />
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
                                                    <ext:TextField ID="txtOrderNo" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout1.txtAdjustNumber.FieldLabel %>" />
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
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout2.cbDealer.EmptyText %>"
                                                        Width="220" Editable="true" TypeAhead="true" StoreID="DealerStore" ValueField="Id"
                                                        DisplayField="ChineseName" Mode="Local" FieldLabel="<%$ Resources: Panel1.FormLayout2.cbDealer.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout2.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
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
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbOrderStatus" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout3.cbAdjustStatus.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="OrderStatusStore" ValueField="Key"
                                                        DisplayField="Value" FieldLabel="<%$ Resources: Panel1.FormLayout3.cbAdjustStatus.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout4.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbOrderType" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout3.cbOrderType.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="OrderTypeStore" ValueField="Key"
                                                        DisplayField="Value" FieldLabel="<%$ Resources: Panel1.FormLayout3.cbOrderType.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout4.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtConsignmentName" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout3.ConsignmentName.FieldLabel %>" />
                                                </ext:Anchor>                                             
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: Panel1.btnSearch.Text %>" runat="server"
                                Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: Panel1.btnInsert.Text %>"
                                Icon="Add" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="Coolite.AjaxMethods.ConsignmentMasterWindow.Show('00000000-0000-0000-0000-000000000000',{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                    StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" AutoExpandColumn="Remark">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="OrderNo" DataIndex="OrderNo" Header="<%$ Resources: GridPanel1.ColumnModel1.OrderNo.Header %>"
                                                Width="160">
                                            </ext:Column>
                                            <ext:Column ColumnID="ProductLineId" DataIndex="ProductLineId" Header="<%$ Resources: GridPanel1.ColumnModel1.AttributeName.Header %>"
                                                Width="120">
                                                <Renderer Handler="return getNameFromStoreById(ProductLineStore,{Key:'Id',Value:'AttributeName'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="OrderType" DataIndex="OrderType" Width="100" Align="Center" Header="<%$ Resources: GridPanel1.ColumnModel1.Type.Header %>">
                                                <Renderer Handler="return getNameFromStoreById(OrderTypeStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="ConsignmentName" DataIndex="ConsignmentName" Width="120" Header="<%$ Resources: GridPanel1.ColumnModel1.ConsignmentName.Header %>"
                                                Align="Right">
                                            </ext:Column>
                                            <ext:Column ColumnID="ConsignmentDay" DataIndex="ConsignmentDay" Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.ConsignmentDay.Header %>"
                                                Align="Center">
                                            </ext:Column>
                                            <ext:Column ColumnID="DelayTime" DataIndex="DelayTime" Width="80" Header="<%$ Resources: GridPanel1.ColumnModel1.DelayTime.Header %>"
                                                Align="Center">
                                            </ext:Column>
                                            <ext:Column ColumnID="StartDate" DataIndex="StartDate" Width="100" Header="<%$ Resources: GridPanel1.ColumnModel1.StartDate.Header %>" Align="Center">                                              
                                            </ext:Column>
                                             <ext:Column ColumnID="EndDate" DataIndex="EndDate" Width="120" Header="<%$ Resources: GridPanel1.ColumnModel1.EndDate.Header %>" Align="Center">                                              
                                            </ext:Column>
                                            <ext:Column ColumnID="OrderStatus" DataIndex="OrderStatus" Width="80" Header="<%$ Resources: GridPanel1.ColumnModel1.OrderStatus.Header %>"
                                                Align="Center">
                                                <Renderer Handler="return getNameFromStoreById(OrderStatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                             <ext:Column ColumnID="Remark" DataIndex="Remark" Header="<%$ Resources: GridPanel1.ColumnModel1.Remark.Header %>" Align="Center">                                              
                                            </ext:Column>
                                            <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>"
                                                Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.ToolTip.Text %>" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                            DisplayInfo="false" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" />
                                    <Listeners>
                                        <Command Handler="Coolite.AjaxMethods.ConsignmentMasterWindow.Show(record.data.Id,{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
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
    <uc:ConsignmentMasterWindow ID="ConsignmentMasterWindow1" runat="server" />
    <uc:ConsignmentCfnDialog ID="ConsignmentCfnDialog1" runat="server" />
  <uc:ConsignmentCfnSetDialog ID="ConsignmentCfnSetDialog1" runat="server" />
  <uc:ConsignmentDealerDailog  ID="ConsignmentDealerDailog1" runat="server"/>
    </form> 
    
    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>
</body>
</html>
