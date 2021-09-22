<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="InvenrotyQROperationCfnDailog.ascx.cs"
    Inherits="DMS.Website.Controls.InvenrotyQROperationCfnDailog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
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

<script language="javascript" type="text/javascript">

    //添加选中的二维码和LotId
    var addItems = function(grid) {
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
            var type = Ext.getCmp('<%=this.hidType.ClientID%>');
            var param = '';
            for (var i = 0; i < selList.length; i++) {
                if (type.getValue() == 'Shipment') {
                    AddQrCode(selList[i].id, selList[i].data.QrCode, selList[i].data.WHMId);

                }
                else if (type.getValue() == 'stock') {
                    Addstock(selList[i].id, selList[i].data.QrCode, selList[i].data.WHMId);
                }
                Ext.getCmp('<%=this.GridPanel2.ClientID%>').getStore().removeAll();
                Ext.getCmp('<%=this.CfnWindow.ClientID%>').hide();
                Ext.MessageBox.alert('Message', '添加成功');
            }


        } else {
            Ext.MessageBox.alert('Message', '确定要添加选中的产品？');
        }
    }

    //关闭页面
    var closeWindow = function() {
        Ext.getCmp('<%=this.CfnWindow.ClientID%>').hide();
        clearItems();
        //ReloadDetail();
    }

    //清除页面查询结果
    var clearItems = function() {
        Ext.getCmp('<%=this.GridPanel2.ClientID%>').clear();
    }

    function beforeRowSelect(s, n, k, r) {
        if (r.get("IsCanOrder") == '否' || r.get("IsCanOrder") == '否（经销商资质无此分类代码）') return false;
    }



 
</script>

<ext:Store ID="CfnStore" runat="server" AutoLoad="false" OnRefreshData="CfnStore_RefreshData">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="ChineseName" />
                <ext:RecordField Name="CustomerFaceNbr" />
                <ext:RecordField Name="Qty" />
                <ext:RecordField Name="LotNumber" />
                <ext:RecordField Name="QrCode" />
                <ext:RecordField Name="LotId" />
                <ext:RecordField Name="WHMId" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="CfnWarehouseStore" runat="server" AutoLoad="false">
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbfWarehouse}.setValue(#{cbfWarehouse}.store.getTotalCount()>0?#{cbfWarehouse}.store.getAt(0).get('Id'):'');" />
        <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
    </Listeners>
</ext:Store>
<ext:Hidden ID="hidCfnUpn" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidCfnLot" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidQrCode" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidDelarId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnVal" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnMsg" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidType" runat="server">
</ext:Hidden>
<ext:Window ID="CfnWindow" runat="server" Icon="Group" Title="添加产品" Width="800" Height="400"
    AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Resizable="false"
    Header="false">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:Panel ID="Panel4" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".6">
                                <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbfWarehouse" runat="server" EmptyText="请选择仓库" Width="200" Editable="false"
                                                    TypeAhead="true" StoreID="CfnWarehouseStore" ValueField="Id" DisplayField="Name"
                                                    FieldLabel="仓库" AllowBlank="false" ListWidth="300" Resizable="true">
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                        <%--  <Select Handler="ChangeTransferType();#{cbWinTransferWarehouse}.store.reload();"/>--%>
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".6">
                                <ext:Panel ID="Panel1" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="120">
                                            <ext:Anchor>
                                                <ext:TextField ID="tfQrCode" runat="server" Width="150" FieldLabel="二维码" SelectOnFocus="true"
                                                    EmptyText="" EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <%--<ext:LayoutColumn ColumnWidth=".4">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false" LabelWidth="80">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left">
                                            <ext:Anchor>
                                                <ext:Checkbox ID="chkShare" runat="server" FieldLabel="只显示可订产品:" Hidden="true">
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Checkbox ID="chkDisplayCanOrder" runat="server" Checked="true" FieldLabel="只显示可订产品" Hidden="false">
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>--%>
                        </ext:ColumnLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                            <Listeners>
                                <%--<Click Handler="#{GridPanel2}.reload();" />--%>
                                <Click Handler="#{PagingToolBar2}.changePage(1);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel8" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout2" runat="server">
                            <ext:GridPanel ID="GridPanel2" runat="server" StoreID="CfnStore" Title="产品列表" Border="false"
                                Icon="Lorry" StripeRows="true" AutoExpandColumn="ChineseName" Header="false">
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="产品型号">
                                        </ext:Column>
                                        <ext:Column ColumnID="ChineseName" Width="200" DataIndex="ChineseName" Header="产品中文名">
                                        </ext:Column>
                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="批次号">
                                        </ext:Column>
                                        <ext:Column ColumnID="QrCode" DataIndex="QrCode" Header="二维码" Width="200">
                                        </ext:Column>
                                        <ext:Column ColumnID="Qty" DataIndex="Qty" Header="库存" Width="50" Align="Center">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="CfnStore"
                                        DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                </BottomBar>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server" HideCheckAll="true"
                                        SingleSelect="true">
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
        <ext:KeyMap ID="KeyMap1" runat="server" Target="={Ext.isGecko ? Ext.getDoc() : Ext.getBody()}">
            <ext:KeyBinding>
                <Keys>
                    <ext:Key Code="ENTER" />
                </Keys>
                <Listeners>
                    <Event Handler="#{PagingToolBar2}.changePage(1);" />
                </Listeners>
            </ext:KeyBinding>
            <ext:KeyBinding Shift="true">
                <Keys>
                    <ext:Key Code="ENTER" />
                </Keys>
                <Listeners>
                    <Event Handler="addItems(#{GridPanel2});" />
                </Listeners>
            </ext:KeyBinding>
        </ext:KeyMap>
    </Body>
    <Buttons>
        <ext:Button ID="AddItemsButton" runat="server" Text="添加" Icon="Add">
            <Listeners>
                <Click Handler="addItems(#{GridPanel2});" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Buttons>
        <ext:Button ID="CloseWindow" runat="server" Text="关闭" Icon="Delete">
            <Listeners>
                <Click Handler="closeWindow();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
