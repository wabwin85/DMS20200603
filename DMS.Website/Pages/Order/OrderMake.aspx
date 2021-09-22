<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderMake.aspx.cs" Inherits="DMS.Website.Pages.Order.OrderMake" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/OrderDetailWindowForMake.ascx" TagName="OrderDetailWindow" TagPrefix="uc" %>
<%@ Register Src="../../Controls/OrderCfnDialog.ascx" TagName="OrderCfnDialog" TagPrefix="uc" %>
<%@ Register Src="../../Controls/OrderCfnSetDialog.ascx" TagName="OrderCfnSetDialog" TagPrefix="uc" %>

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

        var RenderIsLocked = function(value) {
            return value == "1" ? "<%=GetLocalResourceObject("cbIsLocked.ListItem.Text1").ToString()%>" : "<%=GetLocalResourceObject("cbIsLocked.ListItem.Text2").ToString()%>";
        }

        var RenderCheckBox = function(value) {
            return "<input type='checkbox' name='chkItem' value='" + value + "'>";
        }

        function CheckAll() {
            var chklist = document.getElementsByName("chkItem");
            var isChecked = document.getElementById("chkAllItem").checked;
            //alert(chklist.length);
            for (var i = 0; i < chklist.length; i++) {
                chklist[i].checked = isChecked;
                //alert(chklist[i].value);
            }
        }

        function GetSelectedItem() {
            var list = "";
            var chklist = document.getElementsByName("chkItem");
            for (var i = 0; i < chklist.length; i++) {
                if (chklist[i].checked) {
                    list += chklist[i].value + ',';
                }
            }
            return list;
        }

        var DoLock = function() {
            var list = GetSelectedItem();
            if (list.length > 0) {
                Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("Function.DoLock.Ext.Msg.confirm.Message").ToString()%>',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.Lock(list,
                        {
                            success: function() {
                                RefreshMainPage();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                        );
                    } else {

                    }
                });
            } else {
                Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("Function.DoLock.Ext.MessageBox.alert.Message").ToString()%>');
            }
        }

        var DoUnlock = function() {
            var list = GetSelectedItem();
            if (list.length > 0) {
                Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("Function.DoUnlock.Ext.Msg.confirm.Message").ToString()%>',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.Unlock(list,
                        {
                            success: function() {
                                RefreshMainPage();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                        );
                    } else {

                    }
                });
            } else {
                Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("Function.DoUnlock.Ext.MessageBox.alert.Message").ToString()%>');
            }
        }

        var DoMakeManual = function() {
            var list = GetSelectedItem();
            if (list.length > 0) {
                Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("Function.DoMakeManual.Ext.Msg.confirm.Message").ToString()%>',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.MakeManual(list,
                        {
                            success: function() {
                                RefreshMainPage();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                        );
                    } else {

                    }
                });
            } else {
                Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("Function.DoMakeManual.Ext.MessageBox.alert.Message").ToString()%>');
            }
        }
    </script>
    <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine" AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
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
            <Load Handler="#{cbProductLine}.setValue(#{cbProductLine}.store.getTotalCount()>0?#{cbProductLine}.store.getAt(0).get('Id'):'');"  />
        </Listeners>
    </ext:Store>
    <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_DealerList" AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ChineseName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="OrderStatusStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshDictionary" AutoLoad="true">
        <BaseParams>
            <ext:Parameter Name="Type" Value="CONST_Order_Status" Mode="Value"></ext:Parameter>
        </BaseParams>
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
                     <ext:RecordField Name="ProductLineBumId" />
                     <ext:RecordField Name="DmaId" />
                     <ext:RecordField Name="OrderStatus" />
                     <ext:RecordField Name="SubmitUser" />
                     <ext:RecordField Name="SubmitDate" Type="Date" />
                     <ext:RecordField Name="IsLocked" />
                     <ext:RecordField Name="CanMake" />
                     <ext:RecordField Name="CanLock" />
                     <ext:RecordField Name="TotalQty" />
                     <ext:RecordField Name="TotalAmount" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="DmaId" Direction="DESC" />
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources: cbProductLine.EmptyText %>" Width="150"
                                                        Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                        DisplayField="AttributeName" FieldLabel="<%$ Resources: cbProductLine.FieldLabel %>" ListWidth="300" Resizable="true">
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
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: cbDealer.EmptyText %>" Width="220" Editable="true"
                                                        TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName" Mode="Local"
                                                        FieldLabel="<%$ Resources: cbDealer.FieldLabel %>" ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Triggers.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
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
                                                    <ext:ComboBox ID="cbOrderStatus" runat="server" EmptyText="<%$ Resources: cbOrderStatus.EmptyText %>" Width="150"
                                                        Editable="false" TypeAhead="true" StoreID="OrderStatusStore" ValueField="Key"
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
                                                    <ext:ComboBox ID="cbIsLocked" runat="server" EmptyText="<%$ Resources: cbIsLocked.EmptyText %>" Width="150"
                                                        Editable="false" TypeAhead="true" FieldLabel="<%$ Resources: cbIsLocked.FieldLabel %>">
                                                        <Items>
                                                            <ext:ListItem Text="<%$ Resources: cbIsLocked.ListItem.Text1 %>" Value="1" />
                                                            <ext:ListItem Text="<%$ Resources: cbIsLocked.ListItem.Text2 %>" Value="0" />
                                                        </Items>
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
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="document.getElementById('chkAllItem').checked=false;#{GridPanel1}.reload();" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnLock" Text="<%$ Resources: btnLock.Text %>" runat="server" Icon="Lock" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="DoLock();" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnUnlock" Text="<%$ Resources: btnUnlock.Text %>" runat="server" Icon="LockDelete" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="DoUnlock();" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnMake" Text="<%$ Resources: btnMake.Text %>" runat="server" Icon="DiskDownload" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="DoMakeManual();" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" StoreID="ResultStore"
                                    Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="chkId" DataIndex="Id" Header="<input type='checkbox' id='chkAllItem' onclick='CheckAll()'>" Width="50" Sortable="false">
                                                <Renderer Fn="RenderCheckBox" />
                                            </ext:Column>
                                            <ext:Column ColumnID="DmaId" DataIndex="DmaId" Header="<%$ Resources: GridPanel1.ColumnModel1.DmaId.Header %>" Width="180" >
                                                <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="OrderNo" DataIndex="OrderNo" Header="<%$ Resources: GridPanel1.ColumnModel1.OrderNo.Header %>" Width="180" >
                                            </ext:Column>
                                            <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="<%$ Resources: GridPanel1.ColumnModel1.TotalQty.Header %>" >
                                            </ext:Column>
                                            <ext:Column ColumnID="TotalAmount" DataIndex="TotalAmount" Header="<%$ Resources: GridPanel1.ColumnModel1.TotalAmount.Header %>" >
                                                <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                            </ext:Column>
                                            <ext:Column ColumnID="SubmitDate" DataIndex="SubmitDate" Header="<%$ Resources: GridPanel1.ColumnModel1.SubmitDate.Header %>" >
                                                <Renderer  Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                            </ext:Column>
                                            <ext:Column ColumnID="OrderStatus" DataIndex="OrderStatus" Header="<%$ Resources: GridPanel1.ColumnModel1.OrderStatus.Header %>" >
                                                <Renderer Handler="return getNameFromStoreById(OrderStatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="IsLocked" DataIndex="IsLocked" Header="<%$ Resources: GridPanel1.ColumnModel1.IsLocked.Header %>" >
                                                <Renderer  Fn="RenderIsLocked" />
                                            </ext:Column>
                                            <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Text %>" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Text %>" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <Command Handler="Coolite.AjaxMethods.OrderDetailWindow.Show(record.data.Id,{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore" DisplayInfo="false" />
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
    <uc:OrderDetailWindow ID="OrderDetailWindow1" runat="server" /> 
    <uc:OrderCfnDialog ID="OrderCfnDialog1" runat="server" />
    <uc:OrderCfnSetDialog ID="OrderCfnSetDialog1" runat="server" />
    </form>
</body>
</html>
