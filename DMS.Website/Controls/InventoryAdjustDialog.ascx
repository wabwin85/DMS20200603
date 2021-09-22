<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="InventoryAdjustDialog.ascx.cs"
    Inherits="DMS.Website.Controls.InventoryAdjustDialog" %>
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

<script language="javascript">
    //添加选中的产品
    var addItems = function (grid) {
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
            var param = '';
            for (var i = 0; i < selList.length; i++) {
                param += selList[i].id + ',';
            }
            Coolite.AjaxMethods.UC.DoAddItems(param);
        } else {
            Ext.MessageBox.alert('<%=GetLocalResourceObject("addItems.alert.title").ToString()%>', '<%=GetLocalResourceObject("addItems.alert.body").ToString()%>');
        }
    }

    //当变更产品线和经销商时，清空查询条件与结果
    var ClearItems = function () {
        Ext.getCmp('<%=cbWarehouse.ClientID%>').clearValue();
        Ext.getCmp('<%=GridPanel1.ClientID%>').clear();
        Ext.getCmp('<%=txtCFN.ClientID%>').setValue('');
        Ext.getCmp('<%=txtUPN.ClientID%>').setValue('');
        Ext.getCmp('<%=txtLotNumber.ClientID%>').setValue('');

        Ext.getCmp('<%=GridPanel2.ClientID%>').clear();
        Ext.getCmp('<%=txtCFN_CFN.ClientID%>').setValue('');
        Ext.getCmp('<%=txtUPN_CFN.ClientID%>').setValue('');
    }
    function beforeRowSelect(s, n, k, r) {
       
        var hiddenReve3 = Ext.getCmp('<%=hiddenReve3.ClientID%>');
        var hiddenDialogAdjustType=Ext.getCmp('<%=hiddenDialogAdjustType.ClientID%>');
        if (r.get("Price") <= 0 && (hiddenReve3.getValue() == 'Normal' || hiddenReve3.getValue() == 'DefaultWH') && (hiddenDialogAdjustType.getValue() == "Return" || hiddenDialogAdjustType.getValue() == "Exchange")) {
        
            return false;
        }
       
    }

    function setCheckboxStatus(v, p, record) {
     
        var hiddenReve3 = Ext.getCmp('<%=hiddenReve3.ClientID%>');
        var hiddenDialogAdjustType=Ext.getCmp('<%=hiddenDialogAdjustType.ClientID%>');
        if (record.get("Price") <= 0 && (hiddenReve3.getValue() == 'Normal' || hiddenReve3.getValue() == 'DefaultWH') && (hiddenDialogAdjustType.getValue() == "Return" || hiddenDialogAdjustType.getValue() == "Exchange")) {
           
            return "";
        }
        return '<div class="x-grid3-row-checker">&#160;</div>';

       
    }

    //变更仓库时获取类型,如果类型时Consignment，LP_Consignment，Borrow，隐藏价格列
    function ChanageWhouse() {
    
        var hiddenReve3 = Ext.getCmp('<%=hiddenReve3.ClientID%>');
        var store = Ext.getCmp('<%=cbWarehouse.ClientID%>').store;
        var WhouseId = Ext.getCmp('<%=cbWarehouse.ClientID%>').getValue();
         var hiddenDialogAdjustType=Ext.getCmp('<%=hiddenDialogAdjustType.ClientID%>');
        var type = store.getById(WhouseId).get('Type');
        if (hiddenDialogAdjustType.getValue() == "Return" || hiddenDialogAdjustType.getValue() == "Exchange") {
            if (type == 'Consignment' || type == 'LP_Consignment' || type == 'Borrow') {
                Ext.getCmp('<%=GridPanel1.ClientID%>').getColumnModel().setHidden(11, true);
            }
            else if (type == "DefaultWH" || type == "Normal") {
                Ext.getCmp('<%=GridPanel1.ClientID%>').getColumnModel().setHidden(11, false);
            }
        }
        else {
              Ext.getCmp('<%=GridPanel1.ClientID%>').getColumnModel().setHidden(11, true);
        }
     
        hiddenReve3.setValue(type);
    }
    function SetGriHIde() {
        var hiddenDialogAdjustType = Ext.getCmp('<%=hiddenDialogAdjustType.ClientID%>');
        if (hiddenDialogAdjustType.getValue() != "Return" && hiddenDialogAdjustType.getValue() != "Exchange") {
            Ext.getCmp('<%=GridPanel1.ClientID%>').getColumnModel().setHidden(11, true);
        }
        else {
  Ext.getCmp('<%=GridPanel1.ClientID%>').getColumnModel().setHidden(11, false);
        }
    }
    Ext.onReady(function () {

    var sm = Ext.getCmp('<%=this.GridPanel1.ClientID %>').getSelectionModel();
        sm.renderer = setCheckboxStatus;
    });
</script>

<ext:Store ID="CurrentInvStore" runat="server" OnRefreshData="CurrentInvStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
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
                <ext:RecordField Name="ChineseName" />
                <ext:RecordField Name="EnglishName" />
                <ext:RecordField Name="QRCode" />
                <ext:RecordField Name="Price" Type="Float" />
            </Fields>
        </ext:JsonReader>
    </Reader>
     <Listeners>
        <Load Handler="SetGriHIde();" />
    </Listeners>
    <%--    <SortInfo Field="CFN, UPN, LotNumber" Direction="ASC" />--%>
</ext:Store>
<ext:Store ID="CurrentCfnStore" runat="server" OnRefreshData="CurrentCfnStore_RefershData"
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
                <ext:RecordField Name="EngName" />
                <ext:RecordField Name="ChnName" />
                <ext:RecordField Name="UnitOfMeasure" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <%--    <SortInfo Field="CFN, UPN" Direction="ASC" />--%>
</ext:Store>
<ext:Store ID="WarehouseStore" runat="server">
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Name" />
                <ext:RecordField Name="Type" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbWarehouse}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Id'):'');#{hiddenReve3}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Type'):''); " />
        <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
    </Listeners>
    <%--<SortInfo Field="Name" Direction="ASC" />--%>
</ext:Store>
<ext:Hidden ID="hiddenDialogAdjustId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogDealerId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogProductLineId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogAdjustType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenWarehouseType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDealerType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenReve3" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenReturnApplyType" runat="server">
</ext:Hidden>
<ext:Window ID="DialogWindow" runat="server" Icon="Group" Title="<%$ Resources: DialogWindow.Title %>"
    Width="900" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
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
                                                <ext:ComboBox ID="cbWarehouse" runat="server" EmptyText="<%$ Resources: DialogWindow.cbWarehouse.EmptyText %>"
                                                    Width="260" Editable="false" TypeAhead="true" StoreID="WarehouseStore" ValueField="Id"
                                                    DisplayField="Name" FieldLabel="<%$ Resources: DialogWindow.cbWarehouse.FieldLabel %>"
                                                    ListWidth="300" Resizable="true">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DialogWindow.cbWarehouse.FieldTrigger.Qtip %>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <Select Handler="ChanageWhouse();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCFN" runat="server" Width="200" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>"
                                                    EmptyText="<%$ Resources: DialogWindow.txtCFN.EmptyText %>" SelectOnFocus="true"
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
                                                <ext:TextField ID="txtUPN" runat="server" FieldLabel="<%$ Resources: DialogWindow.txtUPN.FieldLabel %>" EmptyText="<%$ Resources: DialogWindow.txtUPN.EmptyText %>"
                                                    Width="200" SelectOnFocus="true" EmptyClass="x-form-empty-field" Hidden="<%$ AppSettings: HiddenUPN  %>" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtLotNumber" runat="server" FieldLabel="<%$ Resources: DialogWindow.txtLotNumber.FieldLabel %>" EmptyText="<%$ Resources: DialogWindow.txtLotNumber.EmptyText %>"
                                                    Width="200" SelectOnFocus="true" EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtQrCode" runat="server" FieldLabel="<%$ Resources: GridPanel1.QRCode.Header %>" EmptyText="<%$ Resources: DialogWindow.txtLotNumber.EmptyText %>"
                                                    Width="200" SelectOnFocus="true" EmptyClass="x-form-empty-field" />
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
                                <Click Handler="if (#{cbWarehouse}.getValue()==''){Ext.Msg.alert('Failed','请选择仓库');}else{#{GridPanel1}.reload()}" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout1" runat="server">
                            <ext:GridPanel ID="GridPanel1" runat="server" StoreID="CurrentInvStore" Title="<%$ Resources: GridPanel1.Title %>"
                                Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" Header="false" AutoExpandColumn="ChineseName">
                                <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="WarehouseName" Width="170" DataIndex="WarehouseName" Header="<%$ Resources: GridPanel1.WarehouseName.Header %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="EnglishName" Width="210" DataIndex="EnglishName" Header="<%$ Resources: GridPanel1.EnglishName.Header %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel1.chineseName.Header %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="CFN" Width="100" DataIndex="CFN" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="UPN" Width="100" DataIndex="UPN" Header="<%$ Resources: GridPanel1.UPN.Header %>" Hidden="<%$ AppSettings: HiddenUPN  %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="LotNumber" Width="100" DataIndex="LotNumber" Header="<%$ Resources: GridPanel1.LotNumber.Header %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="QRCode" Width="100" DataIndex="QRCode" Header="<%$ Resources: GridPanel1.QRCode.Header  %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="LotExpiredDate" Width="100" DataIndex="LotExpiredDate" Header="<%$ Resources: GridPanel1.LotExpiredDate.Header %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="UnitOfMeasure" Width="50" DataIndex="UnitOfMeasure" Header="<%$ Resources: GridPanel1.UnitOfMeasure.Header %>" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="LotInvQty" Width="50" DataIndex="LotInvQty" Header="<%$ Resources: GridPanel1.LotInvQty.Header %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="Price" Width="50" DataIndex="Price" Header="产品价格">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                        <Listeners>
                                            <BeforeRowSelect Fn="beforeRowSelect" />
                                        </Listeners>
                                    </ext:CheckboxSelectionModel>
                                </SelectionModel>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Buttons>
        <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources: GridPanel1.AddItemsButton.Text %>" Icon="Add">
            <Listeners>
                <Click Handler="addItems(#{GridPanel1});" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Listeners>
        <%--<Show Handler="if(#{hiddenDialogAdjustType}.getValue()=='Return' && #{hiddenDealerType}.getValue()=='T2' && #{hiddenWarehouseType}.getValue()=='Consignment'){#{cbWarehouse}.hide();#{GridPanel1}.colModel.setHidden(1,true);}else{#{cbWarehouse}.show();#{GridPanel1}.colModel.setHidden(1,false);}" />--%>
    </Listeners>
</ext:Window>
<ext:Window ID="DialogWindow_CFN" runat="server" Icon="Group" Title="<%$ Resources: DialogWindow_CFN.Title %>" Width="800"
    Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:Panel ID="Panel4" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCFN_CFN" runat="server" Width="200" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>"
                                                    SelectOnFocus="true" EmptyText="<%$ Resources: DialogWindow_CFN.txtCFN_CFN.EmptyText %>" EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Checkbox ID="chkIsShareCFN" runat="server" FieldLabel="<%$ Resources: DialogWindow_CFN.chkIsShareCFN.FieldLabel %>" Visible="false">
                                                </ext:Checkbox>
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
                                                <ext:TextField ID="txtUPN_CFN" runat="server" FieldLabel="<%$ Resources: DialogWindow_CFN.txtUPN_CFN.FieldLabel %>" SelectOnFocus="true"
                                                    Width="200" EmptyText="<%$ Resources: DialogWindow_CFN.txtUPN_CFN.EmptyText %>" EmptyClass="x-form-empty-field" Hidden="<%$ AppSettings: HiddenUPN  %>" />

                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbWarehouse2" runat="server" EmptyText="<%$ Resources: DialogWindow.cbWarehouse.EmptyText %>" Width="260" Editable="false"
                                                    TypeAhead="true" StoreID="WarehouseStore" ValueField="Id" DisplayField="Name"
                                                    FieldLabel="<%$ Resources: DialogWindow.cbWarehouse.FieldLabel %>" ListWidth="300" Resizable="true" AllowBlank="false">
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnSearch_CFN" Text="<%$ Resources: btnSearch_CFN.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                            <Listeners>
                                <Click Handler="#{GridPanel2}.reload();" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 0 5">
                <ext:Panel ID="Panel8" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout2" runat="server">
                            <ext:GridPanel ID="GridPanel2" runat="server" StoreID="CurrentCfnStore" Title="<%$ Resources: GridPanel2.Title %>"
                                Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" AutoExpandColumn="ChnName">
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="CFN" DataIndex="CFN" Width="100" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="UPN" DataIndex="UPN" Width="100" Header="<%$ Resources: GridPanel2.UPN.Header %>" Hidden="<%$ AppSettings: HiddenUPN  %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="EngName" DataIndex="EngName" Width="200" Header="<%$ Resources: GridPanel2.EngName.Header %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="ChnName" DataIndex="ChnName" Header="<%$ Resources: GridPanel2.ChnName.Header %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="UnitOfMeasure" Width="80" DataIndex="UnitOfMeasure" Header="<%$ Resources: GridPanel2.UnitOfMeasure.Header %>" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="CurrentCfnStore"
                                        DisplayInfo="false" />
                                </BottomBar>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server" />
                                </SelectionModel>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Buttons>
        <ext:Button ID="AddItemsButton_CFN" runat="server" Text="<%$ Resources: GridPanel2.AddItemsButton_CFN.Text %>" Icon="Add">
            <Listeners>
                <Click Handler="if (#{cbWarehouse2}.getValue()==''){alert('请选择移入仓库');return false;}addItems(#{GridPanel2});" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
<ext:KeyMap runat="server" Target="={Ext.isGecko ? Ext.getDoc() : Ext.getBody()}">
    <ext:KeyBinding>
        <Keys>
            <ext:Key Code="Enter" />
        </Keys>
        <Listeners>
            <Event Handler="if(#{hiddenDialogAdjustType}.getValue() == 'CTOS'){#{GridPanel1}.reload();};" />
        </Listeners>
    </ext:KeyBinding>
</ext:KeyMap>
