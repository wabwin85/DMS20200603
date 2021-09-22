<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ShipmentCfnDialog.ascx.cs" Inherits="DMS.Website.Controls.ShipmentCfnDialog" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<ext:Hidden ID="hiddenDialogOrderId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogDealerId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogProductLineId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogHospitalId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenWareHouseType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenIsAuth" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDealerType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenShipmentDate" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenIdentityType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenQrCodes" runat="server">
</ext:Hidden>

<style type="text/css">
    .x-form-empty-field
    {
        color: #bbbbbb;
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }
    .x-small-editor .x-form-field
    {
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }
    .x-small-editor .x-form-text
    {
        height: 20px;
        line-height: 16px;
        vertical-align: middle;
    }
</style>


<script type="text/javascript">
    //添加选中的产品
    var addItemsForShipmentAdjust = function(grid, type) {
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
            var param = '';
            for (var i = 0; i < selList.length; i++) {
                param += selList[i].id + ',';
            }
            Coolite.AjaxMethods.ShipmentCfnDialog.DoAddItems(param, type,
                {
                    success: function() {
                        ReloadAdjustWindow();
                    },
                    failure: function(errMsg) {
                        Ext.Msg.alert('Error', errMsg);
                    }
                }
            );
        } else {
            Ext.MessageBox.alert('Error', '请选择');
        }
    }

    function btnSearchClickForShipment(grid) {
        var win = Ext.getCmp('<%=this.ShipmentDialogWindow.ClientID%>');

        ShowShipmentDialogEditingMask(win);
        grid.reload();
        SetShipmentDialogBtnDisabled(win, false)
        win.body.unmask();
    }

    function btnSearchClickForInventory(grid) {
        var win = Ext.getCmp('<%=this.InventoryDialogWindow.ClientID%>');

        ShowShipmentDialogEditingMask(win);
        grid.reload();
        SetShipmentDialogBtnDisabled(win, false)
        win.body.unmask();
    }

    var ShowShipmentDialogEditingMask = function(win) {
        win.body.mask('正在查询', 'x-mask-loading');
        SetShipmentDialogBtnDisabled(win, true);
    };

    var SetShipmentDialogBtnDisabled = function(win, disabled) {
        for (var i = 0; i < win.buttons.length; i++) {
            win.buttons[i].setDisabled(disabled);
        }
    }

    function getCurrentInvRowClassForShipmentCfn(record, index) {

        if (record.data.ExpiryDateTypes == 'Expired') {
            return 'red-row';
        }

        if (record.data.ExpiryDateTypes == 'Valid1') {
            return 'orange-row';
        }

        if (record.data.ExpiryDateTypes == 'Valid2') {

            return 'yellow-row';

        }
        if (record.data.ExpiryDateTypes == 'Valid3') {
            return 'green-row';
        }
        if (index % 2 != 0)
            return 'x-grid3-row-alt';
    }

    function SelectValueForShipmentCfn(e) {
        var filterField = 'Name';  //需进行模糊查询的字段
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

    function beforeRowSelectForShipmentCfn(s, n, k, r) {
        var hiddenIdentityType = Ext.getCmp('<%=hiddenIdentityType.ClientID%>');
        if (r.get("ExpiryDateType") == 'Expired' && hiddenIdentityType.getValue() == 'Dealer') return false;

    }
     var ShowEditingMask = function () {
        var win = Ext.getCmp('<%=this.InventoryDialogWindow.ClientID%>');
        win.body.mask('正在查询', 'x-mask-loading');
        SetWinBtnDisabled(win, true);
    };
    var SetWinBtnDisabled = function (win, disabled) {
        for (var i = 0; i < win.buttons.length; i++) {
            win.buttons[i].setDisabled(disabled);
            //win.body.mask().hide();
        }
    }
    var NeedSaveItem = function () {
        Ext.getCmp('<%=hiddenQrCodes.ClientID%>').getValue()
        if (Ext.getCmp('<%=hiddenQrCodes.ClientID%>').getValue() != '') {
            ShowEditingMask();
            Coolite.AjaxMethods.ShipmentCfnDialog.SelectImportQrCode({
                success: function () {
                    var win = Ext.getCmp('<%=this.InventoryDialogWindow.ClientID%>');
                    SetWinBtnDisabled(win, false)
                    win.body.unmask();
                },
                failure: function (err) {
                    Ext.Msg.alert('Messing', err);
                }
            })
        }
    }
</script>
<ext:Store ID="ShipmentStore" runat="server" AutoLoad="false" OnRefreshData="ShipmentStore_RefreshData" >
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="DealerId" />
                <ext:RecordField Name="DealerName" />
                <ext:RecordField Name="DealerCode" />
                <ext:RecordField Name="WarehouseName" />
                <ext:RecordField Name="WarehouseCode" />
                <ext:RecordField Name="HospitalName" />
                <ext:RecordField Name="ShipmentNbr" />
                <ext:RecordField Name="SubmitDate" />
                <ext:RecordField Name="ShipmentDate" />
                <ext:RecordField Name="UPN" />
                <ext:RecordField Name="UPN2" />
                <ext:RecordField Name="LotNumber" />
                <ext:RecordField Name="QRCode" />
                <ext:RecordField Name="UOM" />
                <ext:RecordField Name="ShipmentQty" />
                <ext:RecordField Name="ShipmentPrice" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="CurrentInvStore" runat="server" AutoLoad="false" OnRefreshData="CurrentInvStore_RefreshData" >
    <Reader>
        <ext:JsonReader ReaderID="LotId">
            <Fields>
                <ext:RecordField Name="LotId" />
                <ext:RecordField Name="LotInvQty" />
                <ext:RecordField Name="LotNumber" />
                <ext:RecordField Name="LotExpiredDate" />
                <ext:RecordField Name="WarehouseId" />
                <ext:RecordField Name="ProductId" />
                <ext:RecordField Name="UPN" />
                <ext:RecordField Name="UnitOfMeasure" />
                <ext:RecordField Name="CFN" />
                <ext:RecordField Name="WarehouseName" />
                <ext:RecordField Name="ExpiryDateTypes" />
                <ext:RecordField Name="IsCanOrder" />
                <ext:RecordField Name="QRCode" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="WarehouseStoreForShipment" runat="server" OnRefreshData="Store_WarehouseByDealerAndType" AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <BaseParams>
        <ext:Parameter Name="DealerId" Value="#{hiddenDialogDealerId}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{hiddenDialogDealerId}.getValue()" Mode="Raw" />
        <ext:Parameter Name="DealerWarehouseType" Value="#{hiddenWareHouseType}.getValue()" Mode="Raw" />
    </BaseParams>
    <Listeners>
        <Load Handler="#{cbWarehouseForShipment}.setValue(#{cbWarehouseForShipment}.store.getTotalCount()>0?#{cbWarehouseForShipment}.store.getAt(0).get('Id'):'');" />
        <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
    </Listeners>
    <SortInfo Field="Name" Direction="ASC" />
</ext:Store>
<ext:Store ID="WarehouseStoreForInv" runat="server" OnRefreshData="Store_WarehouseByDealerAndType" AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <BaseParams>
        <ext:Parameter Name="DealerId" Value="#{hiddenDialogDealerId}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{hiddenDialogDealerId}.getValue()" Mode="Raw" />
        <ext:Parameter Name="DealerWarehouseType" Value="#{hiddenWareHouseType}.getValue()" Mode="Raw" />
    </BaseParams>
    <Listeners>
        <Load Handler="#{cbWarehouseForInv}.setValue(#{cbWarehouseForInv}.store.getTotalCount()>0?#{cbWarehouseForInv}.store.getAt(0).get('Id'):'');" />
        <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
    </Listeners>
    <SortInfo Field="Name" Direction="ASC" />
</ext:Store>
<ext:Store ID="ExpiryDateTypeWinStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshDictionary"
    AutoLoad="true">
    <BaseParams>
        <ext:Parameter Name="Type" Value="Consts_ExpiryDate_Type" Mode="Value">
        </ext:Parameter>
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
<ext:Window ID="ShipmentDialogWindow" runat="server" Icon="Group" Title="历史销售记录"
    Width="800" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false">
    <Body>
        <ext:BorderLayout ID="BorderLayout1" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:Panel ID="Panel5" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbWarehouseForShipment" runat="server" EmptyText="请选择..."
                                                    Width="260" Editable="true" TypeAhead="true" StoreID="WarehouseStoreForShipment" ValueField="Id"
                                                    DisplayField="Name" FieldLabel="仓库"
                                                    ListWidth="300" Resizable="true" AllowBlank="false">
                                                    <Listeners>
                                                        <BeforeQuery Fn="SelectValueForShipmentCfn" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtShipmentNbrForShipment" runat="server" FieldLabel="销售单号"
                                                    EmptyText="逗号分隔,模糊查询" Width="200" SelectOnFocus="true"
                                                    EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtLotNumberForShipment" runat="server" FieldLabel="序列号\批号"
                                                    EmptyText="逗号分隔,模糊查询" Width="200" SelectOnFocus="true"
                                                    EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel1" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtHospitalNameForShipment" runat="server" FieldLabel="销售医院"
                                                    EmptyText="销售医院" Width="200" SelectOnFocus="true" ReadOnly="true"
                                                    EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCfnForShipment" runat="server" Width="200" FieldLabel="产品型号"
                                                    EmptyText="逗号分隔,模糊查询" SelectOnFocus="true"
                                                    EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtQrCodeForShipment" runat="server" Width="200" FieldLabel="二维码" 
                                                    EmptyText="逗号分隔,模糊查询" SelectOnFocus="true" 
                                                    EmptyClass="x-form-empty-field" />
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
                                <Click Handler="btnSearchClickForShipment(#{gpShipment});" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout1" runat="server">
                            <ext:GridPanel ID="gpShipment" runat="server" StoreID="ShipmentStore" Title="历史销售记录"
                                Border="false" Icon="Lorry" StripeRows="true" AutoWidth="true">
                                <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="仓库" Width="180">
                                        </ext:Column>
                                        <ext:Column ColumnID="ShipmentNbr" DataIndex="ShipmentNbr" Header="销售单号" Width="120">
                                        </ext:Column>
                                        <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="销售医院" Width="120">
                                        </ext:Column>
                                        <ext:Column ColumnID="ShipmentDate" DataIndex="ShipmentDate" Header="用量日期" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="UPN" DataIndex="UPN" Header="产品型号" Width="180">
                                        </ext:Column>
                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="序列号\批号">
                                        </ext:Column>
                                        <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码">
                                        </ext:Column>
                                        <ext:Column ColumnID="UOM" DataIndex="UOM" Header="单位">
                                        </ext:Column>
                                        <ext:Column ColumnID="ShipmentQty" DataIndex="ShipmentQty" Header="销售数量">
                                        </ext:Column>
                                        <ext:Column ColumnID="ShipmentPrice" DataIndex="ShipmentPrice" Header="销售单价">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                                    </ext:CheckboxSelectionModel>
                                </SelectionModel>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Buttons>
        <ext:Button ID="AddItemsButton" runat="server" Text="添加" Icon="Add">
            <Listeners>
                <Click Handler="addItemsForShipmentAdjust(#{gpShipment},'Shipment');" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnClose" runat="server" Text="关闭" Icon="Cancel">
            <Listeners>
                <Click Handler="#{ShipmentDialogWindow}.hide();" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Listeners>
        <Show Handler="#{cbWarehouseForShipment}.store.reload();#{gpShipment}.getStore().removeAll();" />
        <Hide Handler="#{cbWarehouseForShipment}.store.removeAll();#{gpShipment}.getStore().removeAll();"/>
    </Listeners>
</ext:Window>
<ext:Window ID="InventoryDialogWindow" runat="server" Icon="Group" Title="库存数据"
    Width="800" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="True">
                <ext:Panel ID="Panel4" runat="server" Header="False" Frame="True" 
                    AutoHeight="True" IDMode="Legacy">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbWarehouseForInv" runat="server" EmptyText="请选择..."
                                                    Width="200" Editable="true" TypeAhead="true" StoreID="WarehouseStoreForInv" ValueField="Id"
                                                    DisplayField="Name" FieldLabel="仓库"
                                                    ListWidth="300" Resizable="true" AllowBlank="false">
                                                    <Listeners>
                                                        <BeforeQuery Fn="SelectValueForShipmentCfn" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCfnForInv" runat="server" Width="200" FieldLabel="产品型号"
                                                    EmptyText="逗号分隔,模糊查询" SelectOnFocus="true"
                                                    EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtQrCodeForInv" runat="server" Width="200" FieldLabel="二维码" 
                                                    EmptyText="逗号分隔,模糊查询" SelectOnFocus="true" 
                                                    EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtLotNumberForInv" runat="server" FieldLabel="序列号\批号"
                                                    EmptyText="逗号分隔,模糊查询" Width="200" SelectOnFocus="true"
                                                    EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbExpireDateForInv" runat="server" Width="200" Editable="false"
                                                    TypeAhead="true" StoreID="ExpiryDateTypeWinStore" ValueField="Key" DisplayField="Value"
                                                    FieldLabel="有效期" ListWidth="220" Resizable="true"
                                                    AllowBlank="true" BlankText="请选择..."
                                                    EmptyText="有效期" Mode="Local">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="清空" />
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
                        <ext:Button ID="btnImport" Text="导入二维码" runat="server" Icon="add" IDMode="Legacy">
                            <Listeners>
                                <Click Handler="Coolite.AjaxMethods.ShipmentCfnDialog.ImportShow({success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="Button1" Text="查询" runat="server" Icon="ArrowRefresh" 
                            IDMode="Legacy" CommandArgument="" CommandName="" OnClientClick="">
                            <Listeners>
                                <Click Handler="btnSearchClickForInventory(#{gpInventory});" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel8" runat="server" Height="300px" Header="False" 
                    IDMode="Legacy">
                    <Body>
                        <ext:FitLayout ID="FitLayout2" runat="server">
                            <ext:GridPanel ID="gpInventory" runat="server" StoreID="CurrentInvStore" Title="当前库存记录"
                                Border="false" Icon="Lorry" StripeRows="true" AutoWidth="true">
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="仓库" Width="180">
                                        </ext:Column>
                                        <ext:Column ColumnID="CFN" DataIndex="CFN" Header="产品型号" Width="180">
                                        </ext:Column>
                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="序列号\批号">
                                        </ext:Column>
                                        <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码">
                                        </ext:Column>
                                        <ext:Column ColumnID="LotExpiredDate" DataIndex="LotExpiredDate" Header="有效期">
                                        </ext:Column>
                                        <ext:Column ColumnID="IsCanOrder" DataIndex="IsCanOrder" Header="是否可订购" Width="70">
                                        </ext:Column>
                                        <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="单位" Width="50" >
                                        </ext:Column>
                                        <ext:Column ColumnID="LotInvQty" DataIndex="LotInvQty" Header="数量" Width="68">
                                        </ext:Column>
                                        <ext:Column ColumnID="ExpiryDateTypes" DataIndex="ExpiryDateTypes" Header="类型" Width="68" Hidden="true">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <View>
                                    <ext:GridView ID="GridView2" runat="server">
                                        <GetRowClass Fn="getCurrentInvRowClassForShipmentCfn" />
                                    </ext:GridView>
                                </View>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                        <Listeners>
                                            <BeforeRowSelect Fn="beforeRowSelectForShipmentCfn" />
                                        </Listeners>
                                    </ext:CheckboxSelectionModel>
                                </SelectionModel>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Buttons>
        <ext:Button ID="Button2" runat="server" Text="添加" Icon="Add">
            <Listeners>
                <Click Handler="addItemsForShipmentAdjust(#{gpInventory},'Inventory');" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="Button3" runat="server" Text="关闭" Icon="Cancel">
            <Listeners>
                <Click Handler="#{InventoryDialogWindow}.hide();" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Listeners>
        <Show Handler="#{cbWarehouseForInv}.store.reload();#{gpInventory}.getStore().removeAll();" />
        <Hide Handler="#{cbWarehouseForInv}.store.removeAll();#{gpInventory}.getStore().removeAll();" />
    </Listeners>
</ext:Window>
<ext:Window ID="ImportWindow" runat="server" Icon="Group" Title="经销商二维码导入" Closable="true"
    AutoShow="false" ShowOnLoad="false" Resizable="false" Height="200" Draggable="false"
    Width="500" Modal="true" BodyStyle="padding:5px;">
    <Body>
        <ext:FormPanel ID="BasicForm" runat="server" Header="false" Border="false" BodyStyle="padding: 10px 10px 0 10px;background-color:#dfe8f6">
            <Body>
                <ext:FormLayout ID="FormLayout5" runat="server" LabelPad="20">
                    <ext:Anchor Horizontal="100%">

                        <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="上传文件" FieldLabel="文件"
                            ButtonText="" Icon="ImageAdd">
                        </ext:FileUploadField>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Buttons>
                <ext:Button ID="SaveButton" runat="server" Text="上传">
                    <AjaxEvents>
                        <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } " Success="">
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="ResetButton" runat="server" Text="清除">
                    <Listeners>
                        <%--  <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);#{ImportButton}.setDisabled(true);" />--%>
                        <Click Handler="#{BasicForm}.getForm().reset();" />
                    </Listeners>
                </ext:Button>

                <ext:Button ID="DownloadButton" runat="server" Text="下载模板">
                    <Listeners>
                        <Click Handler="window.open('../../Upload/ShipmentQrCOde/Template_QrCode.xls')" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:FormPanel>
    </Body>
    <Listeners>
        <BeforeHide Handler="NeedSaveItem();" />
    </Listeners>
</ext:Window>
<ext:KeyMap runat="server" Target="={Ext.isGecko ? Ext.getDoc() : Ext.getBody()}">
        <ext:KeyBinding>
            <Keys>
                <ext:Key Code="Enter" />
            </Keys>
            <Listeners>
                <Event Handler="if(#{hiddenDialogType}.getValue() == 'Shipment'){btnSearchClickForShipment(#{gpShipment});}else{btnSearchClickForInventory(#{gpInventory});};" />
            </Listeners>
        </ext:KeyBinding>    
</ext:KeyMap>
