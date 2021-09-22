<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ShipmentDialog.ascx.cs"
    Inherits="DMS.Website.Controls.ShipmentDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<style type="text/css">
    .x-form-empty-field {
        color: #bbbbbb;
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }

    .x-small-editor .x-form-field {
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }

    .x-small-editor .x-form-text {
        height: 20px;
        line-height: 16px;
        vertical-align: middle;
    }
</style>

<script type="text/javascript">
    //添加选中的产品
    var addItems = function (grid) {
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
            var param = '';
            for (var i = 0; i < selList.length; i++) {
                param += selList[i].id + ',';
            }
            Coolite.AjaxMethods.ShipmentDialog.DoAddItems(param);
        } else {
            Ext.MessageBox.alert('<%=GetLocalResourceObject("addItems.alert.title").ToString()%>', '<%=GetLocalResourceObject("addItems.alert.body").ToString()%>');
        }
    }

    //当变更产品线和经销商时，清空查询条件与结果
    var ClearItems = function () {
        Ext.getCmp('<%=cbWarehouse.ClientID%>').clearValue();
        Ext.getCmp('<%=GridPanel1.ClientID%>').clear();
        Ext.getCmp('<%=txtCFN.ClientID%>').setValue('');
        Ext.getCmp('<%=txtLotNumber.ClientID%>').setValue('');
        Ext.getCmp('<%=cbExpiryDateTypeWin.ClientID%>').setValue('');
    }
    var ShowEditingMask = function () {
        var win = Ext.getCmp('<%=this.DialogWindow.ClientID%>');
        win.body.mask('正在查询', 'x-mask-loading');
        SetWinBtnDisabled(win, true);
    };
    var SetWinBtnDisabled = function (win, disabled) {
        for (var i = 0; i < win.buttons.length; i++) {
            win.buttons[i].setDisabled(disabled);
            //win.body.mask().hide();
        }
    }
    var NeedSaveCfnItem = function () {
        if (Ext.getCmp('<%=hiddenQrCodes.ClientID%>').getValue() != '') {
            ShowEditingMask();
            Coolite.AjaxMethods.ShipmentDialog.SelectImportQrCode({
                success: function () {
                    var win = Ext.getCmp('<%=this.DialogWindow.ClientID%>');
                    SetWinBtnDisabled(win, false)
                    win.body.unmask();
                },
                failure: function (err) {
                    Ext.Msg.alert('Message', err);
                }
            })
        }
    }
    function btnSearchClick() {
        ShowEditingMask();
        Coolite.AjaxMethods.ShipmentDialog.btnSearchClick({
            success: function () {
                var win = Ext.getCmp('<%=this.DialogWindow.ClientID%>');
            SetWinBtnDisabled(win, false)
            win.body.unmask();
        },
            failure: function (err) {
                Ext.Msg.alert('Message', err);
            }
        })
}
function getCurrentInvRowClass(record, index) {


    if (record.data.ExpiryDateType == 'Expired') {
        return 'red-row';
    }

    if (record.data.ExpiryDateType == 'Valid1') {
        return 'orange-row';
    }

    if (record.data.ExpiryDateType == 'Valid2') {

        return 'yellow-row';

    }
    if (record.data.ExpiryDateType == 'Valid3') {
        return 'green-row';
    }
    if (index % 2 != 0)
        return 'x-grid3-row-alt';
}

function SelectValue(e) {
    var filterField = 'Name';  //需进行模糊查询的字段
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

function beforeRowSelect(s, n, k, r) {
    var hiddenIdentityType = Ext.getCmp('<%=hiddenIdentityType.ClientID%>');
        if (r.get("ExpiryDateType") == 'Expired' && hiddenIdentityType.getValue() == 'Dealer') return false;

    }

    function setCheckboxStatus(v, p, record) {
        var hiddenIdentityType = Ext.getCmp('<%=hiddenIdentityType.ClientID%>');
        if (record.get("ExpiryDateType") == 'Expired' && hiddenIdentityType.getValue() == 'Dealer') return "";
        return '<div class="x-grid3-row-checker">&#160;</div>';
    }

    Ext.onReady(function () {
        var sm = Ext.getCmp('<%=this.GridPanel1.ClientID %>').getSelectionModel();
        sm.renderer = setCheckboxStatus;
    });

</script>

<ext:Store ID="CurrentInvStore" runat="server"
    AutoLoad="false">

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
                <ext:RecordField Name="ExpiryDateType" />
                <ext:RecordField Name="IsCanOrder" />
                <ext:RecordField Name="QRCode" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="WarehouseStore" runat="server" OnRefreshData="Store_WarehouseByDealerAndTypeWithoutDWH"
    AutoLoad="true">
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
        <ext:Parameter Name="DealerId" Value="#{hiddenDialogDealerId}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{hiddenDialogDealerId}.getValue()"
            Mode="Raw" />
        <ext:Parameter Name="ProductLineId" Value="#{hiddenDialogProductLineId}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{hiddenDialogProductLineId}.getValue()"
            Mode="Raw" />
        <ext:Parameter Name="DealerWarehouseType" Value="#{hiddenWareHouseType}.getValue()"
            Mode="Raw" />
    </BaseParams>
    <Listeners>
        <Load Handler="if (#{hiddenWarehouseId}.getValue()=='') {#{cbWarehouse}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Id'):'');} else {#{cbWarehouse}.setValue(#{hiddenWarehouseId}.getValue());}" />
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
<ext:Hidden ID="hiddenQrCodes" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenWarehouseId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenCFN" runat="server">
</ext:Hidden>
<ext:Window ID="DialogWindow" runat="server" Icon="Group" Title="<%$ Resources:DialogWindow.Title%>"
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
                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbWarehouse" runat="server" EmptyText="<%$ Resources:DialogWindow.cbWarehouse.EmptyText%>"
                                                    Width="260" Editable="true" TypeAhead="true" StoreID="WarehouseStore" ValueField="Id"
                                                    DisplayField="Name" FieldLabel="<%$ Resources:DialogWindow.cbWarehouse.FieldLabel%>"
                                                    ListWidth="300" Resizable="true" AllowBlank="false">
                                                    <%-- <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:DialogWindow.cbWarehouse.FieldTrigger.Qtip%>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>--%>
                                                    <Listeners>
                                                        <BeforeQuery Fn="SelectValue" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCFN" runat="server" Width="200" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>"
                                                    EmptyText="<%$ Resources:DialogWindow.txtCFN.EmptyText%>" SelectOnFocus="true"
                                                    EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtQrCode" runat="server" Width="200" FieldLabel="二维码" EmptyText="<%$ Resources:DialogWindow.txtCFN.EmptyText%>"
                                                    SelectOnFocus="true" EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel1" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <%--          <ext:Anchor>
                                                <ext:TextField ID="txtUPN" runat="server" FieldLabel="<%$ Resources:DialogWindow.txtUPN.FieldLabel%>"
                                                    EmptyText="<%$ Resources:DialogWindow.txtUPN.EmptyText%>" Width="200" SelectOnFocus="true"
                                                    EmptyClass="x-form-empty-field" Hidden="<%$ AppSettings: HiddenUPN  %>" />
                                            </ext:Anchor>--%>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtLotNumber" runat="server" FieldLabel="<%$ Resources:DialogWindow.txtLotNumber.FieldLabel%>"
                                                    EmptyText="<%$ Resources:DialogWindow.txtLotNumber.EmptyText%>" Width="200" SelectOnFocus="true"
                                                    EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbExpiryDateTypeWin" runat="server" Width="200" Editable="false"
                                                    TypeAhead="true" StoreID="ExpiryDateTypeWinStore" ValueField="Key" DisplayField="Value"
                                                    FieldLabel="<%$ Resources:DialogWindow.ExpireDate%>" ListWidth="220" Resizable="true"
                                                    AllowBlank="true" BlankText="<%$ Resources:DialogWindow.ChoseExpireDateType%>"
                                                    EmptyText="<%$ Resources:DialogWindow.ExpireDateType.FieldLabel%>" Mode="Local">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:DialogWindow.cbWarehouse.FieldTrigger.Qtip%>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Label ID="lblHint" runat="server"  FieldLabel="查询结果说明" EmptyText ="当产品记录大于200条，以下产品列表仅显示有效期最近的200条记录！" CtCls="txtRed" />
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
                                <Click Handler="Coolite.AjaxMethods.ShipmentDialog.ImportShow({success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="btnSearch" Text="<%$ Resources:btnSearch.Text%>" runat="server" Icon="ArrowRefresh"
                            IDMode="Legacy">
                            <Listeners>
                                <Click Handler="btnSearchClick();" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout1" runat="server">
                            <ext:GridPanel ID="GridPanel1" runat="server" StoreID="CurrentInvStore" Title="<%$ Resources:GridPanel1.Title%>"
                                Border="false" Icon="Lorry" StripeRows="true" AutoWidth="true">
                                <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="<%$ Resources:GridPanel1.WarehouseName.Header%>"
                                            Width="180">
                                        </ext:Column>
                                        <ext:Column ColumnID="CFN" DataIndex="CFN" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                            Width="180">
                                        </ext:Column>
                                        <%-- <ext:Column ColumnID="UPN" DataIndex="UPN" Header="<%$ Resources: GridPanel1.UPN.Header  %>"
                                            Hidden="<%$ AppSettings: HiddenUPN  %>">
                                        </ext:Column>--%>
                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources:GridPanel1.LotNumber.Header%>">
                                        </ext:Column>
                                        <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码">
                                        </ext:Column>
                                        <ext:Column ColumnID="LotExpiredDate" DataIndex="LotExpiredDate" Header="<%$ Resources:GridPanel1.LotExpiredDate.Header%>">
                                        </ext:Column>
                                        <ext:Column ColumnID="IsCanOrder" DataIndex="IsCanOrder" Header="<%$ Resources: GridPanel1.IsCanOrder %>"
                                            Width="70">
                                        </ext:Column>
                                        <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources:GridPanel1.UnitOfMeasure.Header%>"
                                            Width="50" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="LotInvQty" DataIndex="LotInvQty" Header="<%$ Resources:GridPanel1.LotInvQty.Header%>"
                                            Width="68">
                                        </ext:Column>
                                        <ext:Column ColumnID="ExpiryDateType" DataIndex="ExpiryDateType" Header="<%$ Resources:DialogWindow.ExpireDateType%>"
                                            Width="68" Hidden="true">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <View>
                                    <ext:GridView ID="GridView1" runat="server">
                                        <GetRowClass Fn="getCurrentInvRowClass" />
                                    </ext:GridView>
                                </View>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                                        <Listeners>
                                            <BeforeRowSelect Fn="beforeRowSelect" />
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
        <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources:GridPanel1.AddItemsButton.Text%>"
            Icon="Add">
            <Listeners>
                <Click Handler="addItems(#{GridPanel1});" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Buttons>
        <ext:Button ID="btnClose" runat="server" Text="关闭" Icon="Cancel">
            <AjaxEvents>
                <Click OnEvent="CloseWindow">
                </Click>
            </AjaxEvents>
        </ext:Button>
    </Buttons>
</ext:Window>
<ext:Window ID="ImportWindow" runat="server" Icon="Group" Title="经销商二维码导入" Closable="true"
    AutoShow="false" ShowOnLoad="false" Resizable="false" Height="200" Draggable="false"
    Width="500" Modal="true" BodyStyle="padding:5px;">
    <Body>
        <ext:FormPanel ID="BasicForm" runat="server" Header="false" Border="false" BodyStyle="padding: 10px 10px 0 10px;background-color:#dfe8f6">
            <Body>
                <ext:FormLayout ID="FormLayout4" runat="server" LabelPad="20">
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
        <BeforeHide Handler="NeedSaveCfnItem();" />
    </Listeners>
</ext:Window>
<ext:KeyMap runat="server" Target="={Ext.isGecko ? Ext.getDoc() : Ext.getBody()}">
    <ext:KeyBinding>
        <Keys>
            <ext:Key Code="Enter" />
        </Keys>
        <Listeners>
            <Event Handler="btnSearchClick();" />
        </Listeners>
    </ext:KeyBinding>
</ext:KeyMap>
