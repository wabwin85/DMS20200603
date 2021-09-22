<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrderDetailWindowForAudit.ascx.cs" Inherits="DMS.Website.Controls.OrderDetailWindowForAudit" %>
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
<script type="text/javascript" language="javascript">
    //初次载入详细信息窗口时读取数据
    function RefreshDetailWindow() {
        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
        Ext.getCmp('<%=this.cbDealer.ClientID%>').store.reload();
        Ext.getCmp('<%=this.cbProductLine.ClientID%>').store.reload();
        Ext.getCmp('<%=this.gpLog.ClientID%>').reload();
    }
    //重新读取明细行
    function ReloadDetail() {
        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
    }

    //window hide前提示是否需要保存数据
    var NeedSave = function() {
        return true;
    }

    //设置是否需要保存
    var SetModified = function(isModified) {
        Ext.getCmp('<%=this.hidIsModified.ClientID%>').setValue(isModified ? "True" : "False");
    }
   
    //屏蔽刷新Store时的提示
    var StoreCommitAll = function(store) {
        for (var i = 0; i < store.getCount(); i++) {
            var record = store.getAt(i);
            if (record.dirty) {
                record.commit();
            }
        }
    }

    var ShowEditingMask = function() {
        var win = Ext.getCmp('<%=this.DetailWindow.ClientID%>');
        win.body.mask('<%=GetLocalResourceObject("ShowEditingMask.mask.Title").ToString()%>', 'x-mask-loading');
        SetWinBtnDisabled(win,true);
    }
    
    var SetWinBtnDisabled = function(win,disabled){
        for (var i = 0; i < win.buttons.length; i++) {
            win.buttons[i].setDisabled(disabled);
        }
    }

    var DoAgree = function() {
    Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("DoAgree.confirm.Body").ToString()%>',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.OrderDetailWindow.Agree(
                            {
                                success: function() {
                                    Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                    RefreshMainPage();
                                },
                                failure: function(err) {
                                    Ext.Msg.alert('Error', err);
                                }
                            }
                        );
                    }
                }
            );
    }

    var DoReject = function() {
        var txtRejectReason = Ext.getCmp('<%=this.txtRejectReason.ClientID%>');
        var tabPanel = Ext.getCmp('<%=this.TabPanel1.ClientID%>');
        if (txtRejectReason.getValue() == '' || txtRejectReason.getValue().length > 200) {
            tabPanel.setActiveTab(0);
            Ext.Msg.alert('Message', '<%=GetLocalResourceObject("DoReject.alert.Body").ToString()%>');
            return;
        }
        Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("DoReject.confirm.Body").ToString()%>',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.OrderDetailWindow.Reject(
                            {
                                success: function() {
                                    Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                    RefreshMainPage();
                                },
                                failure: function(err) {
                                    Ext.Msg.alert('Error', err);
                                }
                            }
                        );
                    }
                }
            );
    }
</script>

<ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData" AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="PohId" />
                <ext:RecordField Name="CfnId" />
                <ext:RecordField Name="CustomerFaceNbr" />
                <ext:RecordField Name="CfnChineseName" />
                <ext:RecordField Name="Uom" />
                <ext:RecordField Name="RequiredQty" />
                <ext:RecordField Name="Amount" />
                <ext:RecordField Name="ReceiptQty" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
        <Load Handler="#{DetailWindow}.body.unmask();" />
        <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
    </Listeners>
</ext:Store>
<ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData" AutoLoad="false">
     <Proxy>
        <ext:DataSourceProxy />
    </Proxy> 
     <Reader>
        <ext:JsonReader >
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
<ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine" AutoLoad="false">
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
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbProductLine}.setValue(#{cbProductLine}.store.getTotalCount()>0?#{cbProductLine}.store.getAt(0).get('Id'):'');#{hidProductLine}.setValue(#{cbProductLine}.getValue());}else{#{cbProductLine}.setValue(#{hidProductLine}.getValue());}#{cbTerritory}.store.reload();" />
    </Listeners>
    <SortInfo Field="Id" Direction="ASC" />
</ext:Store>
<ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_DealerList" AutoLoad="false">
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
    <Listeners>
        <Load Handler="#{cbDealer}.setValue(#{hidDealerId}.getValue());" />
    </Listeners>
    <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
</ext:Store>
<ext:Store ID="TerritoryStore" runat="server" UseIdConfirmation="true" OnRefreshData="TerritoryStore_RefershData" AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Code">
            <Fields>
                <ext:RecordField Name="Code" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbTerritory}.setValue(#{cbTerritory}.store.getTotalCount()>0?#{cbTerritory}.store.getAt(0).get('Code'):'');#{hidTerritoryCode}.setValue(#{cbTerritory}.getValue());}else{#{cbTerritory}.setValue(#{hidTerritoryCode}.getValue());}" />
    </Listeners>
    <SortInfo Field="Name" Direction="ASC" />
</ext:Store>
<ext:Hidden ID="hidIsPageNew" runat="server"></ext:Hidden>
<ext:Hidden ID="hidIsModified" runat="server"></ext:Hidden>
<ext:Hidden ID="hidIsSaved" runat="server"></ext:Hidden>
<ext:Hidden ID="hidInstanceId" runat="server"></ext:Hidden>
<ext:Hidden ID="hidDealerId" runat="server"></ext:Hidden>
<ext:Hidden ID="hidProductLine" runat="server"></ext:Hidden>
<ext:Hidden ID="hidOrderStatus" runat="server"></ext:Hidden>
<ext:Hidden ID="hidEditItemId" runat="server"></ext:Hidden>
<ext:Hidden ID="hidTerritoryCode" runat="server"></ext:Hidden>
<ext:Hidden ID="hidRtnVal" runat="server"></ext:Hidden>
<ext:Hidden ID="hidRtnMsg" runat="server"></ext:Hidden>
<ext:Hidden ID="hidRtnRegMsg" runat="server"></ext:Hidden>
<ext:Hidden ID="hidLatestAuditDate" runat="server"></ext:Hidden>
<ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>" Width="900"
    Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="true" Header="false" CenterOnLoad="true" Y="10">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:FormPanel ID="FormPanel1" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".4">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbDealer" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                    StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName" FieldLabel="<%$ Resources: cbDealer.FieldLabel %>" Mode="Local"
                                                    AllowBlank="false" BlankText="<%$ Resources: cbDealer.BlankText %>" EmptyText="<%$ Resources: cbDealer.EmptyText %>" ListWidth="300" Resizable="true">
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbProductLine" runat="server" Width="200" Editable="false" TypeAhead="true" Disabled="true"
                                                    StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName" FieldLabel="<%$ Resources: cbProductLine.FieldLabel %>"
                                                    AllowBlank="false" BlankText="<%$ Resources: cbProductLine.BlankText %>" EmptyText="<%$ Resources: cbProductLine.EmptyText %>" ListWidth="300" Resizable="true">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbProductLine.FieldTrigger.Qtip %>" HideTrigger="true" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                        <Select Handler="ChangeProductLine();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".35">
                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="false" >
                                    <Body>
                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderNo" runat="server" FieldLabel="<%$ Resources: txtOrderNo.FieldLabel %>" Width="200"/>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtSubmitDate" runat="server" FieldLabel="<%$ Resources: txtSubmitDate.FieldLabel %>" Width="120" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".25">
                                <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderStatus" runat="server" FieldLabel="<%$ Resources: txtOrderStatus.FieldLabel %>" Width="120" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbTerritory" runat="server" Width="120" Editable="false" TypeAhead="true" Disabled="false"
                                                    StoreID="TerritoryStore" ValueField="Code" DisplayField="Name" FieldLabel="<%$ Resources: cbTerritory.FieldLabel %>"
                                                    AllowBlank="false" BlankText="<%$ Resources: cbTerritory.BlankText %>" EmptyText="<%$ Resources: cbTerritory.EmptyText %>">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>" HideTrigger="true" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                        <Select Handler="#{hidTerritoryCode}.setValue(#{cbTerritory}.getValue());" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                </ext:FormPanel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                    <Tabs>
                        <ext:Tab ID="TabHeader" runat="server" Title="<%$ Resources: TabHeader.Title %>" BodyStyle="padding: 6px;" AutoScroll="true">
                            <Body>
                                <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel4" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel4.Title %>">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" >
                                                            <ext:Anchor>
                                                                <ext:NumberField ID="txtTotalAmount" runat="server" FieldLabel="<%$ Resources: txtTotalAmount.FieldLabel %>" ></ext:NumberField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:NumberField ID="txtTotalQty" runat="server" FieldLabel="<%$ Resources: txtTotalQty.FieldLabel %>" ></ext:NumberField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Label ID="lbRemark" runat="server" FieldLabel="<%$ Resources: lbRemark.FieldLabel %>"></ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextArea ID="txtRemark" runat="server" Width="250" Height="150" HideLabel="true" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel5" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel5.Title %>">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtContactPerson" runat="server" Width="120" FieldLabel="<%$ Resources: txtContactPerson.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: txtContactPerson.BlankText %>" MsgTarget="Side" MaxLength="100"/>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtContact" runat="server" Width="120" FieldLabel="<%$ Resources: txtContact.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: txtContact.BlankText %>" MsgTarget="Side" MaxLength="100"/>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtContactMobile" runat="server" Width="120" FieldLabel="<%$ Resources: txtContactMobile.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: txtContactMobile.BlankText %>" MsgTarget="Side" MaxLength="100"/>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Panel ID="panelRejectReason" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: panelRejectReason.Title %>">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="120">
                                                                            <ext:Anchor>
                                                                                <ext:TextArea ID="txtRejectReason" runat="server" Width="250" Height="150" HideLabel="true" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel10" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel10.Title %>">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="120">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtShipToAddress" runat="server" Width="150" FieldLabel="<%$ Resources: txtShipToAddress.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: txtShipToAddress.BlankText %>" MsgTarget="Side" MaxLength="200"></ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtConsignee" runat="server" Width="120" FieldLabel="<%$ Resources: txtConsignee.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: txtConsignee.BlankText %>" MsgTarget="Side" MaxLength="200"/>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtConsigneePhone" runat="server" Width="120" FieldLabel="<%$ Resources: txtConsigneePhone.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: txtConsigneePhone.BlankText %>" MsgTarget="Side" MaxLength="200"/>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="dtRDD" runat="server" Width="120" FieldLabel="<%$ Resources: dtRDD.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: dtRDD.BlankText %>" MsgTarget="Side" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:FormPanel>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TabDetail" runat="server" Title="<%$ Resources: TabDetail.Title %>" AutoScroll="true">
                            <Body>
                                <ext:GridPanel ID="gpDetail" runat="server" Title="<%$ Resources: gpDetail.Title %>" StoreID="DetailStore"
                                    StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" AutoWidth="true" Height="300"
                                    ClicksToEdit="1" EnableHdMenu="false">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar1" runat="server">
                                            <Items>
                                                <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                <ext:Button ID="btnAddCfnSet" runat="server" Text="<%$ Resources: btnAddCfnSet.Text %>" Icon="Add">
                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.OrderCfnSetDialog.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue(),#{hidDealerId}.getValue());"/>
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="btnAddCfn" runat="server" Text="<%$ Resources: btnAddCfn.Text %>" Icon="Add">
                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.OrderCfnDialog.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue(),#{hidDealerId}.getValue());"/>
                                                    </Listeners>
                                                </ext:Button>
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                    <ColumnModel ID="ColumnModel2" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>" Width="80">
                                            </ext:Column>
                                            <ext:Column ColumnID="CfnChineseName" DataIndex="CfnChineseName" Header="<%$ Resources: gpDetail.CfnChineseName %>" Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="Uom" DataIndex="Uom" Header="<%$ Resources: gpDetail.Uom %>" Width="50" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="RequiredQty" DataIndex="RequiredQty" Header="<%$ Resources: gpDetail.RequiredQty %>" Width="80">
                                                <Editor>
                                                    <ext:NumberField ID="txtRequiredQty" runat="server" AllowBlank="false" AllowDecimals="false"
                                                        DataIndex="RequiredQty" SelectOnFocus="true" AllowNegative="false">
                                                    </ext:NumberField>
                                                </Editor>
                                            </ext:Column>
                                            <ext:Column ColumnID="Amount" DataIndex="Amount" Header="<%$ Resources: gpDetail.Amount %>" Width="80">
                                                <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                <Editor>
                                                    <ext:NumberField ID="txtAmount" runat="server" AllowBlank="false" 
                                                        DataIndex="Amount" SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                    </ext:NumberField>
                                                </Editor>
                                            </ext:Column>
                                            <ext:Column ColumnID="ReceiptQty" DataIndex="ReceiptQty" Header="<%$ Resources: gpDetail.ReceiptQty %>" Width="80">
                                            </ext:Column>
                                            <ext:CommandColumn Width="50" Header="<%$ Resources: gpDetail.CommandColumn.Header %>" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources: gpDetail.CommandColumn.Header %>" />
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server" MoveEditorOnEnter="true">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <Command Handler="ShowEditingMask();Coolite.AjaxMethods.OrderDetailWindow.DeleteItem(record.data.Id,{success:function(){ReloadDetail();SetWinBtnDisabled(#{DetailWindow},false);},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                        <BeforeEdit Handler="#{hidEditItemId}.setValue(this.getSelectionModel().getSelected().id);#{txtRequiredQty}.setValue(this.getSelectionModel().getSelected().data.RequiredQty);#{txtAmount}.setValue(this.getSelectionModel().getSelected().data.Amount);" />
                                        <AfterEdit Handler="ShowEditingMask();StoreCommitAll(this.store);Coolite.AjaxMethods.OrderDetailWindow.UpdateItem(#{txtRequiredQty}.getValue(),#{txtAmount}.getValue(),{success:function(){#{hidEditItemId}.setValue('');ReloadDetail();SetWinBtnDisabled(#{DetailWindow},false);},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="DetailStore"
                                            DisplayInfo="false" />
                                    </BottomBar>
                                    <SaveMask ShowMask="false" />
                                    <LoadMask ShowMask="false" />
                                </ext:GridPanel>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources: TabLog.Title %>" AutoScroll="true">
                            <Body>
                                <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore" Width="870"
                                    StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" Height="300">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="<%$ Resources: gpLog.OperUserId %>" Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources: gpLog.OperUserName %>" Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="<%$ Resources: gpLog.OperTypeName %>" Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="<%$ Resources: gpLog.OperDate %>" Width="150">
                                                <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                            </ext:Column>
                                            <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources: gpLog.OperNote %>" Width="250">
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server" MoveEditorOnEnter="true">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="OrderLogStore"
                                            DisplayInfo="false" />
                                    </BottomBar>
                                    <SaveMask ShowMask="false" />
                                    <LoadMask ShowMask="true" />
                                </ext:GridPanel>
                            </Body>
                        </ext:Tab>
                    </Tabs>
                </ext:TabPanel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Buttons>
        <ext:Button ID="btnAgree" runat="server" Text="<%$ Resources: btnAgree.Text %>" Icon="LorryAdd">
            <Listeners>
                <Click Handler="DoAgree();"/>
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnReject" runat="server" Text="<%$ Resources: btnReject.Text %>" Icon="Delete">
            <Listeners>
                <Click Handler="DoReject();"/>
            </Listeners>
        </ext:Button>
    </Buttons>
    <Listeners>
        <BeforeHide Handler="return NeedSave();" />
    </Listeners>
</ext:Window>
