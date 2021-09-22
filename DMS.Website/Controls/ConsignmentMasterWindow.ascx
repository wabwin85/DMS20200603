<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ConsignmentMasterWindow.ascx.cs"
    Inherits="DMS.Website.Controls.ConsignmentMasterWindow" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
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
    .editable-column
    {
        background: #FFFF99;
    }
    .nonEditable-column
    {
        background: #FFFFFF;
    }
    .yellow-row
    {
        background: #FFD700;
    }
</style>

<script type="text/javascript" language="javascript">
    var odwMsgList = {
        msg1:"<%=GetLocalResourceObject("ValidateForm.confirm.Body").ToString()%>",
        msg3:"<%=GetLocalResourceObject("Revoke.Alert.Title").ToString()%>"
    }
    //初次载入详细信息窗口时读取数据
    function RefreshDetailWindow() {
        //Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
        Ext.getCmp('<%=this.PagingToolBar2.ClientID%>').changePage(1); 
        Ext.getCmp('<%=this.gpLog.ClientID%>').reload();       
        Ext.getCmp('<%=this.PagingToolBar3.ClientID%>').changePage(1); 
        Ext.getCmp('<%=this.cbOrderType.ClientID%>').store.reload();   
        Ext.getCmp('<%=this.cbProductLine.ClientID%>').store.reload();        
    }
    
    
    function DetailStoreLoad() {
        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
        
    }
    function cbConsignmentDayChang()
    {
    var cbConsignmentDay=Ext.getCmp('<%=this.cbConsignmentDay.ClientID%>');
   var   txtConsignmentDay=Ext.getCmp('<%=this.txtConsignmentDay.ClientID%>');
 
    if(cbConsignmentDay.getValue()=='0')
    {
      txtConsignmentDay.setValue('');
     Ext.getCmp('<%=this.txtConsignmentDay.ClientID%>').show();
    }
    else{
    txtConsignmentDay.setValue(cbConsignmentDay.getValue());
    Ext.getCmp('<%=this.txtConsignmentDay.ClientID%>').hide();
    }
    }
    //重新读取明细行
    function ReloadDetail() {
        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
    }
   function ReDelare(){
   
    Ext.getCmp('<%=this.DealerPanel.ClientID%>').reload();
   }
    //表单验证
    function ValidateForm() {
        var errMsg = "";
        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
        var rtnRegMsg = Ext.getCmp('<%=this.hidRtnRegMsg.ClientID%>');
        
        var isForm1Valid = Ext.getCmp('<%=this.FormPanel1.ClientID%>').getForm().isValid();
        var isForm2Valid = Ext.getCmp('<%=this.FormPanel2.ClientID%>').getForm().isValid();

        var tabPanel = Ext.getCmp('<%=this.TabPanel1.ClientID%>')
        var txtRemark = Ext.getCmp('<%=this.txtRemark.ClientID%>');
        var dtSDD = Ext.getCmp('<%=this.dtStartDate.ClientID%>');
        var dtEDD = Ext.getCmp('<%=this.dtEndDate.ClientID%>');
       var txtConsignmentDay= Ext.getCmp('<%=this.txtConsignmentDay.ClientID%>');
        
        if (!isForm1Valid || !isForm2Valid) {
            errMsg = '<%=GetLocalResourceObject("ValidateForm.errMsgForm").ToString()%>';
        }
        if (txtRemark.getValue().length > 200) {
            errMsg+= '<%=GetLocalResourceObject("ValidateForm.errMsgConst").ToString()%>';
        }
        if(dtEDD < dtSDD){
            errMsg+= '<%=GetLocalResourceObject("ValidateForm.errMsgDate").ToString()%>';
        }
        
        
        if (errMsg != "") {
            Ext.Msg.alert('Message', errMsg);
          return false;
        } else {
         if(parseInt(txtConsignmentDay.getValue())<=0)
        {
          Ext.Msg.alert('Message',"寄售天数必须大于0");
          return false;
        }
        Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        
                                            Coolite.AjaxMethods.ConsignmentMasterWindow.CheckedSubmit(
                                            {
                                                success: function() {
                                                if(rtnVal.getValue()=='Success')
                                                {
                                                 Coolite.AjaxMethods.ConsignmentMasterWindow.Submit({
                                                 
                                                   success: function() {
                                                    Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                        RefreshMainPage();
                                                   },
                                                   failure: function(err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                                 })
                                                }
                                                else if(rtnVal.getValue()=='Error')
                                                {
                                                 Ext.Msg.alert('Error', rtnMsg.getValue());
                                                }
                                                },
                                           
                                                failure: function(err) {
                                                    Ext.Msg.alert('Error', err);
                                                }
                                                })
                                            }    
                                    
                                });
        }
    }

    //window hide前提示是否需要保存数据
    var NeedSave = function() {
        var isModified = Ext.getCmp('<%=this.hidIsModified.ClientID%>').getValue() == "True" ? true : false;
        var isPageNew = Ext.getCmp('<%=this.hidIsPageNew.ClientID%>').getValue() == "True" ? true : false;
        var isSaved = Ext.getCmp('<%=this.hidIsSaved.ClientID%>').getValue() == "True" ? true : false;
        //alert("isModified=" + isModified + " isPageNew=" + isPageNew + " isSaved=" + isSaved);
      
        if (!isSaved) {
            if (isModified) {
                Ext.Msg.confirm('Warning', '<%=GetLocalResourceObject("NeedSave.confirm.Body").ToString()%>',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.ConsignmentMasterWindow.SaveDraft(
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
                    } else {
                   
                        if (isPageNew) {
                            Coolite.AjaxMethods.ConsignmentMasterWindow.DeleteDraft(
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
                        } else {
                            Ext.getCmp('<%=this.hidIsSaved.ClientID%>').setValue("True");
                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                        }
                    }
                });
                return false;
            } 
        }
    }

    //设置是否需要保存
    var SetModified = function(isModified) {
        Ext.getCmp('<%=this.hidIsModified.ClientID%>').setValue(isModified ? "True" : "False");
    }

    //变更产品线
    var ChangeProductLine = function() {
        var cbProductLine = Ext.getCmp('<%=this.cbProductLine.ClientID%>');
        var hidProductLine = Ext.getCmp('<%=this.hidProductLine.ClientID%>');
        //alert("ChangeProductLine");
        if (hidProductLine.getValue() != cbProductLine.getValue()) {
            Ext.Msg.confirm('Warning', '产品线发送改变，将删除产品和原有销售',
                        function(e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.ConsignmentMasterWindow.ChangeProductLine(
                                {
                                    success: function() {
                                        hidProductLine.setValue(cbProductLine.getValue());
                                        SetModified(true);
                                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').enable();
                                         
                                       
                                         Ext.getCmp('<%=this.DealerPanel.ClientID%>').reload();
                                        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
                                        clearItems();
                                    },
                                    failure: function(err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                                );
                            }
                            else {
                                cbProductLine.setValue(hidProductLine.getValue());
                                Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);
                               
                            }
                        }
                    );
        }else{
            Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);
          
        }
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
        win.body.mask('<%=GetLocalResourceObject("ShowEditingMask.mask").ToString()%>', 'x-mask-loading');
        SetWinBtnDisabled(win,true);
    }
    
    var SetWinBtnDisabled = function (win, disabled) {
        for (var i = 0; i < win.buttons.length; i++) {
            win.buttons[i].setDisabled(disabled);
        }
    }
   
    
    var SetCellCssEditable  = function(v,m){
        m.css = "editable-column";
        return v;
    }
    
     var SetCellCssNonEditable  = function(v,m){
        m.css = "";
        return v;
    }
    
</script>

<ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="PohId" />
                <ext:RecordField Name="CfnId" />
                <ext:RecordField Name="CustomerFaceNbr" />
                <ext:RecordField Name="CfnChineseName" />
                <ext:RecordField Name="CfnEnglishName" />
                <ext:RecordField Name="CfnPrice" />
                <ext:RecordField Name="Uom" />
                <ext:RecordField Name="RequiredQty" />
                <ext:RecordField Name="Amount" />
                <ext:RecordField Name="ShortName" />
                <ext:RecordField Name="Remark" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
        <Load Handler="#{DetailWindow}.body.unmask();" />
        <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
    </Listeners>
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
<ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine"
    AutoLoad="false">
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
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbProductLine}.setValue(#{cbProductLine}.store.getTotalCount()>0?#{cbProductLine}.store.getAt(0).get('Id'):'');#{hidProductLine}.setValue(#{cbProductLine}.getValue());}else{#{cbProductLine}.setValue(#{hidProductLine}.getValue());}" />
    </Listeners>
    <SortInfo Field="Id" Direction="ASC" />
</ext:Store>
<ext:Store ID="OrderTypeStorewin" runat="server" UseIdConfirmation="true" AutoLoad="false"
    OnRefreshData="OrderTypeStore_RefreshData">
    <Reader>
        <ext:JsonReader ReaderID="Key">
            <Fields>
                <ext:RecordField Name="Key" />
                <ext:RecordField Name="Value" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbOrderType}.setValue(#{hidOrderType}.getValue());" />
    </Listeners>
</ext:Store>
<ext:Store ID="ConsignmenDealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="ConsignmenDealerStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="DmaId" />
                <ext:RecordField Name="ProductLineId" />
                <ext:RecordField Name="ConsignmentName" />
                <ext:RecordField Name="Name" />
                <ext:RecordField Name="SAPCode" />
                <ext:RecordField Name="DealerType" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
        <Load Handler="#{DetailWindow}.body.unmask();" />
        <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
    </Listeners>
    <BaseParams>
    </BaseParams>
</ext:Store>
<ext:Hidden ID="hidIsPageNew" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsModified" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsSaved" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidInstanceId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidProductLine" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidOrderStatus" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidEditItemId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnVal" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnMsg" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnRegMsg" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidLatestAuditDate" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidOrderType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPriceType" runat="server">
</ext:Hidden>
<ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
    Width="980" Height="490" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:FormPanel ID="FormPanel1" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".33">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                    <Body>
                                        <%--表头信息 --%>
                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="100">
                                            <%--订单类型、订单编号 --%>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbOrderType" runat="server" EmptyText="<%$ Resources: cbOrderType.EmptyText %>"
                                                    Width="150" Editable="false" TypeAhead="true" StoreID="OrderTypeStorewin" ValueField="Key"
                                                    AllowBlank="false" Mode="Local" DisplayField="Value" FieldLabel="<%$ Resources: txtOrderType.FieldLabel %>">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbOrderType.FieldTrigger.Qtip %>"
                                                            HideTrigger="true" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderNo" runat="server" FieldLabel="<%$ Resources: txtOrderNo.FieldLabel %>"
                                                    Width="150" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".34">
                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <%--产品线、订单状态 --%>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbProductLine" runat="server" Width="150" Editable="false" TypeAhead="true"
                                                    Disabled="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName"
                                                    FieldLabel="<%$ Resources: cbProductLine.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: cbProductLine.BlankText %>"
                                                    EmptyText="<%$ Resources: cbProductLine.EmptyText %>" ListWidth="200" Resizable="true">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbOrderType.FieldTrigger.Qtip %>"
                                                            HideTrigger="true" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                        <%--<Select Handler="#{btnAddCfn}.setDisabled(true);#{btnAddCfnSet}.setDisabled(true);ChangeProductLine();" />--%>
                                                        <Select Handler="#{Toolbar1}.setDisabled(true);ChangeProductLine();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderStatus" runat="server" FieldLabel="<%$ Resources: txtOrderStatus.FieldLabel %>"
                                                    Width="150" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".33">
                                <ext:Panel ID="Panel17" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout23" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtSubmitDate" runat="server" FieldLabel="<%$ Resources: txtSubmitDate.FieldLabel %>"
                                                    Width="130" />
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
                        <ext:Tab ID="TabHeader" runat="server" Title="<%$ Resources: TabHeader.Title %>"
                            BodyStyle="padding: 6px;" AutoScroll="true">
                            <%--表头信息 --%>
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout3" runat="server" Split="false">
                                                <ext:LayoutColumn ColumnWidth="0.3">
                                                    <ext:Panel ID="Panel4" runat="server" Border="true" FormGroup="true">
                                                        <%--寄售规则名称、近效期规则、寄售天数、备注 --%>
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left">
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtConsignmentName" LabelStyle="color:red;" runat="server" FieldLabel="<%$ Resources: txtConsignmentName.FieldLabel %>" AllowBlank="false" >
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                        <ext:ComboBox ID="cbConsignmentDay" LabelStyle="color:red;"  runat="server" EmptyText="请选择"
                                                           Editable="true" TypeAhead="true" AllowBlank="true"
                                                           Width="150" Resizable="true" FieldLabel="选择寄售天数" Mode="Local">
                                                          <Items>
                                                          <ext:ListItem Value="15" Text="15天" />
                                                          <ext:ListItem Value="30" Text="30天" />
                                                          <ext:ListItem Value="0" Text="自定义天数" />
                                                          </Items>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <Select Handler="cbConsignmentDayChang();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:NumberField ID="txtConsignmentDay" Hidden="true" LabelStyle="color:red;" runat="server" FieldLabel="<%$ Resources: txtConsignmentDay.FieldLabel %>" AllowBlank="false" >
                                                                    </ext:NumberField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Label ID="lbConsignment" runat="server" FieldLabel="备注">
                                                                    </ext:Label>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextArea ID="txtRemark" runat="server" Width="240" Height="120" HideLabel="true" />
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth="0.3">
                                                    <ext:Panel ID="Panel5" runat="server" Border="true" FormGroup="true">
                                                        <%--订单信息 --%>
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left">
                                                                <%--开始时间、结束时间、可延期次数 --%>
                                                                <ext:Anchor>
                                                                    <ext:DateField ID="dtStartDate" runat="server" LabelStyle="color:red;" Width="120"
                                                                        FieldLabel="<%$ Resources: txtStartDate.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: txtStartDate.BlankText %>"
                                                                        MsgTarget="Side" MaxLength="100" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:DateField ID="dtEndDate" runat="server" LabelStyle="color:red;" Width="120"
                                                                        FieldLabel="<%$ Resources: txtEndDate.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: txtEndDate.BlankText %>"
                                                                        MsgTarget="Side" MaxLength="100" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:NumberField ID="txtDelayTime" LabelStyle="color:red;" runat="server" Width="120"
                                                                        FieldLabel="<%$ Resources: txtDelayTime.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: txtDelayTime.BlankText %>"
                                                                        MsgTarget="Side" MaxLength="100" />
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:FormPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TbDMs" runat="server" Title="经销商列表" AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout2" runat="server">
                                    <ext:GridPanel ID="DealerPanel" runat="server" Title="经销商列表" StoreID="ConsignmenDealerStore"
                                        AutoScroll="true" Border="false" Icon="Lorry" AutoWidth="true" AutoExpandColumn="Id"
                                        Header="false" StripeRows="true">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar2" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                    <ext:Button ID="BtnDeclareAdd"  runat="server" Text="添加" Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="if(#{hidInstanceId}.getValue() == '' || #{hidProductLine}.getValue() == '') {alert('请等待数据加载完毕！');} else {Coolite.AjaxMethods.ConsignmentDealerDailog.Show(#{hidProductLine}.getValue(),#{hidInstanceId}.getValue());}" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="Name" DataIndex="Name" Header="中文名" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="SAPCode" DataIndex="SAPCode" Header="SAP账号">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerType" DataIndex="DealerType" Header="经销商类型">
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="操作" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <Listeners>
                                            <Command Handler="ShowEditingMask();Coolite.AjaxMethods.ConsignmentMasterWindow.DeleteItem(record.data.Id,{success:function(){ReDelare();SetWinBtnDisabled(#{DetailWindow},false);},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="20" StoreID="ConsignmenDealerStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="false" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                            <Listeners>
                                <Activate Handler="Coolite.AjaxMethods.ConsignmentMasterWindow.InitBtnCfnAdd();" />
                            </Listeners>
                        </ext:Tab>
                        <ext:Tab ID="TabDetail" runat="server" Title="<%$ Resources: TabDetail.Title %>"
                            AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FT1" runat="server">
                                    <ext:GridPanel ID="gpDetail" runat="server" Title="<%$ Resources: gpDetail.Title %>"
                                        StoreID="DetailStore" StripeRows="true" Border="false" Icon="Lorry" ClicksToEdit="1"
                                        EnableHdMenu="false" Header="false" AutoExpandColumn="CfnChineseName">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                    <ext:Button ID="btnAddCfnSet" runat="server" Text="<%$ Resources: btnAddCfnSet.Text %>"
                                                        Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="if(#{hidInstanceId}.getValue() == '' || #{hidProductLine}.getValue() == '') {alert('请等待数据加载完毕！');} else {Coolite.AjaxMethods.ConsignmentCfnSetDialog.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue());}" />
                                                        </Listeners>
                                                    </ext:Button>
                                                    <ext:Button ID="btnAddCfn" runat="server" Text="<%$ Resources: btnAddCfn.Text %>"
                                                        Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="if(#{hidInstanceId}.getValue() == ''|| #{hidProductLine}.getValue() == '') {alert('请等待数据加载完毕！');} else {Coolite.AjaxMethods.ConsignmentCfnDialog.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue());}" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CustomerFaceNbr" Width="120" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ShortName" DataIndex="ShortName" Header="<%$ Resources: gpDetail.Property %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnEnglishName" Width="200" DataIndex="CfnEnglishName" Header="<%$ Resources: gpDetail.CfnEnglishName %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnChineseName" DataIndex="CfnChineseName" Header="<%$ Resources: gpDetail.CfnChineseName %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="RequiredQty" DataIndex="RequiredQty" Width="100" Header="<%$ Resources: gpDetail.RequiredQty %>">
                                                    <Editor>
                                                        <ext:NumberField ID="txtRequiredQty" runat="server" AllowBlank="false" AllowDecimals="false"
                                                            DataIndex="RequiredQty" SelectOnFocus="false" AllowNegative="false">
                                                        </ext:NumberField>
                                                    </Editor>
                                                    <%--<Renderer Fn="SetCellCss" />--%>
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnPrice" Hidden="true" DataIndex="CfnPrice" Width="70" Header="<%$ Resources: gpDetail.CfnPrice %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Uom" DataIndex="Uom" Width="50" Header="<%$ Resources: gpDetail.Uom %>"
                                                    Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount" DataIndex="Amount" Hidden="true" Width="100" Header="<%$ Resources: gpDetail.Amount %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Remark" DataIndex="Remark" Width="100" Header="<%$ Resources: gpDetail.Remark %>">
                                               
                                                    <%--<Renderer Fn="SetCellCss" />--%>
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="<%$ Resources: gpDetail.CommandColumn.Header %>"
                                                    Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources: gpDetail.CommandColumn.Header %>" />
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="ShowEditingMask();Coolite.AjaxMethods.ConsignmentMasterWindow.DeletePlineItem(record.data.Id,{success:function(){ReloadDetail();SetWinBtnDisabled(#{DetailWindow},false);},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                            <BeforeEdit Handler="#{hidEditItemId}.setValue(this.getSelectionModel().getSelected().id);#{txtRequiredQty}.setValue(this.getSelectionModel().getSelected().data.RequiredQty);" />
                                            <AfterEdit Handler="ShowEditingMask();StoreCommitAll(this.store);Coolite.AjaxMethods.ConsignmentMasterWindow.UpdateItem(#{txtRequiredQty}.getValue(),{success:function(){#{hidEditItemId}.setValue(''); DetailStoreLoad(); SetWinBtnDisabled(#{DetailWindow}, false); },failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="50" StoreID="DetailStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="false" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                            <Listeners>
                                <Activate Handler="Coolite.AjaxMethods.ConsignmentMasterWindow.InitBtnCfnAdd();" />
                            </Listeners>
                        </ext:Tab>
                        <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources: TabLog.Title %>" AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FT2" runat="server">
                                    <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore"
                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                        Icon="Lorry" AutoExpandColumn="OperNote">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="<%$ Resources: gpLog.OperUserId %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources: gpLog.OperUserName %>"
                                                    Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="<%$ Resources: gpLog.OperTypeName %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="<%$ Resources: gpLog.OperDate %>"
                                                    Width="150">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources: gpLog.OperNote %>">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="50" StoreID="OrderLogStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                    </Tabs>
                </ext:TabPanel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Buttons>
        <ext:Button ID="btnSaveDraft" runat="server" Text="<%$ Resources: btnSaveDraft.Text %>"
            Icon="Add">
            <Listeners>
                <Click Handler="Coolite.AjaxMethods.ConsignmentMasterWindow.SaveDraft({success:function(){#{DetailWindow}.hide();RefreshMainPage();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnDeleteDraft" runat="server" Text="<%$ Resources: btnDeleteDraft.Text %>"
            Icon="Delete">
            <Listeners>
                <Click Handler="
                    Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.ConsignmentMasterWindow.DeleteDraft({success:function(){#{DetailWindow}.hide();#{hidIsSaved}.setValue('True'); RefreshMainPage();},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnSubmit" runat="server" Text="<%$ Resources: btnSubmit.Text %>"
            Icon="LorryAdd">
            <Listeners>
                <Click Handler="ValidateForm();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnRevoke" runat="server" Text="<%$ Resources: btnRevoke.Text %>"
            Icon="Decline">
            <Listeners>
                <Click Handler="Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.ConsignmentMasterWindow.Revoke({success:function(){#{DetailWindow}.hide();RefreshMainPage();Ext.Msg.alert('Message',odwMsgList.msg3);},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Listeners>
        <BeforeHide Handler="return NeedSave();" />
    </Listeners>
</ext:Window>
