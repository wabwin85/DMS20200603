<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TransferUnfreezeDialog.ascx.cs" Inherits="DMS.Website.Controls.TransferUnfreezeDialog" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<ext:Hidden ID="hiddenDialogTransferId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogDealerFromId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogDealerToId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogProductLineId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogDealerToDefaultWarehouseId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogTransferType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenQrCodes" runat="server">
</ext:Hidden>
<script language="javascript">
    //添加选中的产品
      var addItems = function(grid) {
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
            //返回选择行的数量
            //Ext.MessageBox.alert('Message', selList.length);
            //var selJson = Ext.util.JSON.encode(selList);
            //测试grid中的数据操作 selList[i].id
            //for (var i = 0; i < selList.length; i++) {
            //    Ext.Msg.alert('Message', String.format('LotId={0} LotNumber={1}', selList[i].data.LotId, selList[i].data.LotNumber));
            //}
            //将选择的行的id拼成一串字符作为参数
            var param = '';
            for (var i = 0; i < selList.length; i++) {
                param += selList[i].id + ',';
            }
            //Coolite.AjaxMethods.UC.DoAddItems(param);
            Coolite.AjaxMethods.UC.DoYes(param);
        } else {
            Ext.MessageBox.alert('错误', '请选择要添加的产品');
        }
      }

    //当变更产品线和经销商时，清空查询条件与结果
    var ClearItems = function() {
        Ext.getCmp('<%=cbWarehouse.ClientID%>').clearValue();
        //alert("111");
        //下面这句也可以清空数据
        //Ext.getCmp('<%=GridPanel1.ClientID%>').getStore().removeAll();
        Ext.getCmp('<%=GridPanel1.ClientID%>').clear();
        //Ext.getCmp('<%=GridPanel1.ClientID%>').getSelectionModel().clearSelections();
        //Ext.getCmp('<%=CurrentInvStore.ClientID%>').removeAll();
        //Ext.getCmp('<%=GridPanel1.ClientID%>').getStore().reload();
        //alert("222");
        Ext.getCmp('<%=txtCFN.ClientID%>').setValue('');
        Ext.getCmp('<%=txtUPN.ClientID%>').setValue('');
        Ext.getCmp('<%=txtLotNumber.ClientID%>').setValue('');
    }
    function SelectValue(e) {
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

    //关闭页面
    var closeWindow = function() {
        Ext.getCmp('<%=this.DialogWindow.ClientID%>').hide();
        clearItems();
        //ReloadDetail();
    }

    //清除页面查询结果
    var clearItems = function() {
        Ext.getCmp('<%=this.GridPanel1.ClientID%>').clear();
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
    var NeedSaveItem = function () {
        Ext.getCmp('<%=hiddenQrCodes.ClientID%>').getValue()
        if (Ext.getCmp('<%=hiddenQrCodes.ClientID%>').getValue() != '') {
            ShowEditingMask();
            Coolite.AjaxMethods.UC.SelectImportQrCode({
                success: function () {
                    var win = Ext.getCmp('<%=this.DialogWindow.ClientID%>');
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

<ext:Store ID="CurrentInvStore" runat="server" OnRefreshData="CurrentInvStore_RefershData"
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
                <ext:RecordField Name="ChineseName" />
                <ext:RecordField Name="EnglishName" />
                 <ext:RecordField Name="QRCode" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <%--    <SortInfo Field="LotId" Direction="ASC" />--%>
</ext:Store>
<ext:Store ID="WarehouseStore" runat="server" UseIdConfirmation="true">
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbWarehouse}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Id'):'');" />
        <LoadException Handler="Ext.Msg.alert('产品下载失败', e.message || response.statusText);" />
    </Listeners>
    <%-- <SortInfo Field="Name" Direction="ASC" />--%>
</ext:Store>

<ext:Window ID="DialogWindow" runat="server" Icon="Group" Title="物料选择"
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
                                                <ext:ComboBox ID="cbWarehouse" runat="server" EmptyText="请选择分仓库"
                                                    Width="260" Editable="true" TypeAhead="true" StoreID="WarehouseStore" ValueField="Id"
                                                    DisplayField="Name" FieldLabel="冻结仓库"
                                                    ListWidth="300" Resizable="true">
                                                    <Listeners>
                                                        <BeforeQuery Fn="SelectValue" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCFN" runat="server" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>"
                                                    EmptyText="逗点分隔，可多个模糊查询" Width="200" SelectOnFocus="true"
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
                                                <ext:TextField ID="txtUPN" runat="server" FieldLabel="条形码"
                                                    EmptyText="逗点分隔，可多个模糊查询" Width="200" SelectOnFocus="true"
                                                    EmptyClass="x-form-empty-field" Hidden="<%$ AppSettings: HiddenUPN  %>" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtLotNumber" runat="server" FieldLabel="序列号/批号"
                                                    EmptyText="逗点分隔，可多个模糊查询" Width="200"
                                                    SelectOnFocus="true" EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtQrCode" runat="server" FieldLabel="二维码"
                                                    EmptyText="逗点分隔，可多个模糊查询" Width="200"
                                                    SelectOnFocus="true" EmptyClass="x-form-empty-field" />
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
                                <Click Handler="Coolite.AjaxMethods.UC.ImportShow({success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="btnSearch" Text="查询" runat="server"
                            Icon="ArrowRefresh" IDMode="Legacy">
                            <Listeners>
                                <Click Handler="#{GridPanel1}.reload();" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout1" runat="server">
                            <ext:GridPanel ID="GridPanel1" runat="server" StoreID="CurrentInvStore" Title="查询结果"
                                Border="false" Icon="Lorry" StripeRows="true" AutoExpandColumn="ChineseName"
                                Header="false">
                                <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="分仓库"
                                            Width="150">
                                        </ext:Column>
                                        <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="英文名称"
                                            Width="200">
                                        </ext:Column>
                                        <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="中文名称">
                                        </ext:Column>
                                        <ext:Column ColumnID="CFN" Width="100" DataIndex="CFN" Header="产品型号">
                                        </ext:Column>
                                        <ext:Column ColumnID="UPN" Width="100" DataIndex="UPN" Header="条形码"
                                            Hidden="<%$ AppSettings: HiddenUPN  %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="LotNumber" Width="80" DataIndex="LotNumber" Header="序列号/批号">
                                        </ext:Column>
                                         <ext:Column ColumnID="QRCode" Width="80" DataIndex="QRCode" Header="二维码">
                                        </ext:Column>
                                        
                                        <ext:Column ColumnID="LotExpiredDate" Width="70" DataIndex="LotExpiredDate" Header="有效期">
                                        </ext:Column>
                                        <ext:Column ColumnID="UnitOfMeasure" Width="50" DataIndex="UnitOfMeasure" Header="单位"
                                            Hidden="<%$ AppSettings: HiddenUOM  %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="LotInvQty" DataIndex="LotInvQty" Header="库存数量"
                                            Width="68">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server" />
                                </SelectionModel>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" Msg="处理中" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Buttons>
        <ext:Button ID="AddItemsButton" runat="server" Text="添加"
            Icon="Add">
            <Listeners>
                <Click Handler="addItems(#{GridPanel1});" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Buttons>
        <ext:Button ID="CloseWindow" runat="server" Text="关闭"
            Icon="Delete">
            <Listeners>
                <Click Handler="closeWindow();" />
            </Listeners>
        </ext:Button>
    </Buttons>
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
                <Event Handler="#{GridPanel1}.reload();" />
            </Listeners>
        </ext:KeyBinding>    
</ext:KeyMap>