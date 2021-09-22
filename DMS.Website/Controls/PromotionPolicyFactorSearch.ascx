<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PromotionPolicyFactorSearch.ascx.cs"
    Inherits="DMS.Website.Controls.PromotionPolicyFactorSearch" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>

<script type="text/javascript" language="javascript">
    function RefreshDetailWindow2() {

        Ext.getCmp('<%=this.PagingToolBarFactorRelation.ClientID%>').changePage(1); 
        Ext.getCmp('<%=this.PagingToolBar1.ClientID%>').changePage(1); 
        Ext.getCmp('<%=this.cbWd2Factor.ClientID%>').store.reload();  
    }

    function RefreshFolicyFactorRuleWindow2() {
        Ext.getCmp('<%=this.GridWd2FactorRule.ClientID%>').reload();
    }
    
    function RefreshFolicyFactorRelationWindow2() {
        Ext.getCmp('<%=this.GridWd2FactorRule2.ClientID%>').reload();
    }
    
    function RefreshProductIndxWindow2() {
        Ext.getCmp('<%=this.GridWd2IndxDetail.ClientID%>').reload();
    }
    
    function closeWindow2(){
        Ext.getCmp('<%=this.wd2PolicyFactor.ClientID%>').hide(null);
    }
    function getPIndexIsErrRowClassY(record, index) {
        if (record.data.IsErr==1)
        {
           return 'yellow-row';
        }
    }
    function updatePolicyFactor() {
        Coolite.AjaxMethods.PromotionPolicyFactorSearch.UpdatePolicyFactor( {success: function() { closeWindow2(); RefreshFolicyFactorWindow();},failure: function(err) {Ext.Msg.alert('Error', err); } })
    }

</script>

<ext:Hidden ID="hidWd2PageType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd2PromotionState" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd2UsePageId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd2IsPageNew" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd2PolicyId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd2PolicyFactorId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd2ProductLine" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd2SubBU" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd2Factor" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsPointPolicy" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsPointPolicySub" runat="server">
</ext:Hidden>

<ext:Store ID="PolicyFactorStore" runat="server" OnRefreshData="PolicyFactorStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="FactId">
            <Fields>
                <ext:RecordField Name="FactId" />
                <ext:RecordField Name="FactName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbWd2Factor}.setValue(#{hidWd2Factor}.getValue());" />
    </Listeners>
</ext:Store>
<%--<ext:Store ID="IsGiftStore" runat="server" OnRefreshData="IsGiftStore_RefreshData"
    AutoLoad="false">
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
</ext:Store>--%>
<ext:Store ID="PolicyFactorRuleStore" runat="server" AutoLoad="false" OnRefreshData="PolicyFactorRuleStore_RefreshData">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="PolicyFactorConditionId">
            <Fields>
                <ext:RecordField Name="PolicyFactorConditionId" />
                <ext:RecordField Name="ConditionName" />
                <ext:RecordField Name="PolicyFactorId" />
                <ext:RecordField Name="ConditionId" />
                <ext:RecordField Name="OperTag" />
                <ext:RecordField Name="ConditionValue" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="PolicyFactorRelationStore" runat="server" AutoLoad="false" OnRefreshData="PolicyFactorRelationStore_RefreshData">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="PolicyFactorId" />
                <ext:RecordField Name="ConditionPolicyFactorId" />
                <ext:RecordField Name="FactId" />
                <ext:RecordField Name="FactName" />
                <ext:RecordField Name="FactDesc" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Window ID="wd2PolicyFactor" runat="server" Icon="Group" Title="政策因素设定" Resizable="false"
    Y="10" Header="false" Width="600" AutoShow="false" AutoScroll="true" Maximizable="true"
    AutoHeight="true" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout20" runat="server">
            <ext:Anchor>
                <ext:Panel ID="PanelWd2PolicyFactor" runat="server" Border="true" Title="政策因素" BodyStyle="padding:5px;"
                    Collapsible="true">
                    <Body>
                        <ext:FormLayout ID="FormLayout21" runat="server" LabelWidth="100">
                            <ext:Anchor>
                                <ext:ComboBox ID="cbWd2Factor" runat="server" EmptyText="选择因素类型..." Width="200" Editable="false"
                                    TypeAhead="true" StoreID="PolicyFactorStore" ValueField="FactId" DisplayField="FactName"
                                    BlankText="选择因素类型" AllowBlank="false" Mode="Local" FieldLabel="因素类型" Resizable="true">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();#{txaWd2Remark}.setValue('');#{cbWd2IsGift}.clearValue();#{cbWd2IsGift}.setVisible(false);#{cbWd2PointsValue}.setValue('');#{cbWd2PointsValue}.setVisible(false);" />
                                        <Select Handler="if(#{cbWd2Factor}.getValue()=='1') 
                                                            {
                                                                if(#{hidIsPointPolicySub}.getValue()=='促销赠品' || #{hidIsPointPolicySub}.getValue()=='促销赠品转积分'|| #{hidIsPointPolicySub}.getValue()=='满额送赠品'||#{hidIsPointPolicySub}.getValue()!='满额打折')
                                                                { 
                                                                    #{cbWd2IsGift}.setVisible(true);
                                                                }
                                                                else
                                                                {
                                                                    #{cbWd2IsGift}.setVisible(false);
                                                                }
                                                                
                                                                if(#{hidIsPointPolicySub}.getValue() !='促销赠品' && #{hidIsPointPolicySub}.getValue()!='满额送赠品' && #{hidIsPointPolicySub}.getValue()!='满额打折')
                                                                { 
                                                                    #{cbWd2PointsValue}.setVisible(true);
                                                                }else
                                                                {
                                                                    #{cbWd2PointsValue}.setVisible(false);
                                                                }
                                                                Coolite.AjaxMethods.PromotionPolicyFactorSearch.CheckIsGift({success:function(result){ 
                                                                                        if(result=='0') { #{cbWd2IsGift}.enable(); #{cbWd2PointsValue}.enable();} 
                                                                                        else if(result=='1') { #{cbWd2IsGift}.disable();#{cbWd2PointsValue}.enable();} 
                                                                                        else if(result=='2') { #{cbWd2IsGift}.enable();#{cbWd2PointsValue}.disable();} 
                                                                                        else if(result=='3') {  #{cbWd2IsGift}.disable();#{cbWd2PointsValue}.disable();} 
                                                                            },failure:function(err){Ext.Msg.alert('Error', err);}});
                                                             } 
                                                    else { 
                                                    #{cbWd2IsGift}.setVisible(false);
                                                    #{txaWd2Remark}.setValue('');
                                                    #{cbWd2IsGift}.clearValue(); 
                                                    #{cbWd2PointsValue}.setVisible(false);
                                                    #{cbWd2PointsValue}.clearValue(); }" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextArea ID="txaWd2Remark" runat="server" Width="200" FieldLabel="描述" Height="30">
                                </ext:TextArea>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:ComboBox ID="cbWd2IsGift" runat="server" EmptyText="选择是否促销赠品..." Width="200"
                                    Hidden="true" Editable="false" TypeAhead="true" Mode="Local" FieldLabel="促销赠品"
                                    Resizable="true">
                                    <Items>
                                        <ext:ListItem Text="是" Value="Y" />
                                        <ext:ListItem Text="否" Value="N" />
                                    </Items>
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <%--  <ext:NumberField ID="cbWd2PointsValue" runat="server" Width="200" FieldLabel="转换率"
                                    Hidden="true">
                                </ext:NumberField>--%>
                                <ext:ComboBox ID="cbWd2PointsValue" runat="server" EmptyText="选择是否积分可订购产品..." Width="200"
                                    Hidden="true" Editable="false" TypeAhead="true" Mode="Local" FieldLabel="积分可订购产品"
                                    Resizable="true">
                                    <Items>
                                        <ext:ListItem Text="是" Value="Y" />
                                        <ext:ListItem Text="否" Value="N" />
                                    </Items>
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnWd2AddFactor" runat="server" Text="确认" Icon="LorryAdd">
                            <Listeners>
                                <%--<Click Fn="wd2ShowFactorRule" />--%>
                                <Click Handler="if(#{cbWd2Factor}.getValue()=='') {Ext.Msg.alert('Error','请选择政策因素');} else{
                                Coolite.AjaxMethods.PromotionPolicyFactorSearch.SavePolicyFactor(
                                    {
                                        success: function() {
                                            #{cbWd2Factor}.disable();  #{cbWd2IsGift}.disable(); #{btnWd2AddFactor}.setVisible(false);#{cbWd2PointsValue}.disable();
                                           if(#{cbWd2Factor}.getValue()=='1'||#{cbWd2Factor}.getValue()=='2' || #{cbWd2Factor}.getValue()=='3')
                                           {
                                                #{PanelWd2AddFactorRule}.setVisible(true);
                                           }else if (#{cbWd2Factor}.getValue()=='6'||#{cbWd2Factor}.getValue()=='7' || #{cbWd2Factor}.getValue()=='8' || #{cbWd2Factor}.getValue()=='9'
                                            ||#{cbWd2Factor}.getValue()=='12'||#{cbWd2Factor}.getValue()=='13' || #{cbWd2Factor}.getValue()=='14' || #{cbWd2Factor}.getValue()=='15'){
                                                #{PanelWd2AddFactorRule2}.setVisible(true);
                                                if(#{cbWd2Factor}.getValue()=='6'||#{cbWd2Factor}.getValue()=='7'||#{cbWd2Factor}.getValue()=='14'||#{cbWd2Factor}.getValue()=='15')
                                                {
                                                    #{PanelWd2UploadField}.setVisible(true);
                                                }
                                           }
                                           else {
                                                #{wd2PolicyFactor}.hide(); 
                                           }
                                           RefreshFolicyFactorWindow();
                                        },
                                        failure: function(err) {
                                            Ext.Msg.alert('Error', err);
                                        }
                                    }
                                    );
                                }" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelWd2UploadField" runat="server" BodyBorder="false" Header="false"
                    AutoWidth="true" Frame="true" FormGroup="true" Hidden="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server" Split="false">
                            <ext:LayoutColumn ColumnWidth="0.3">
                                <ext:Panel ID="Panel6" runat="server" Border="true" FormGroup="true">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left">
                                            <ext:Anchor>
                                                <ext:Button ID="btnWdTopType" runat="server" Text="上传/更改指定产品指标" Icon="PackageAdd">
                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.PromotionPolicyFactorSearch.ProductIndxShow(#{cbWd2Factor}.getValue(),{success:function(){RefreshProductIndxWindow2();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                    </Listeners>
                                                </ext:Button>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth="0.6">
                                <ext:Panel ID="Panel1" runat="server" Border="true" FormGroup="true">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left">
                                            <ext:Anchor>
                                                <ext:Label ID="PanelWd2UploadAopRemark" runat="server" HideLabel="true" Text="" Width="200"
                                                    Hidden="true" LabelSeparator="">
                                                </ext:Label>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                </ext:Panel>
                <%-- <ext:FormPanel ID="PanelWd2UploadField" runat="server" Frame="true" Header="false"
                    AutoWidth="true" AutoHeight="true" Hidden="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="90%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout7" runat="server">
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadFieldAOP" runat="server" EmptyText="上传指定产品指标"
                                    FieldLabel="指定产品指标上传" ButtonText="" Icon="ImageAdd" Width="400">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{SaveButtonAOP}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="SaveButtonAOP" runat="server" Text="上传指定产品指标">
                            <AjaxEvents>
                                <Click OnEvent="UploadAOPClick" Before="if(!#{PanelWd2UploadField}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传指定产品指标...', '指定产品指标上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{FileUploadFieldAOP}.setValue(''); Ext.Msg.show({ 
                                        title   : '成功', 
                                        msg     : '上传成功', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        buttons : Ext.Msg.OK 
                                    })">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="ResetButton" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{PanelWd2UploadField}.getForm().reset();#{SaveButtonAOP}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>--%>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelWd2AddFactorRule" runat="server" Border="true" Header="false"
                    AutoWidth="true" Hidden="true">
                    <Body>
                        <ext:FitLayout ID="FitLayout3" runat="server">
                            <ext:GridPanel ID="GridWd2FactorRule" runat="server" StoreID="PolicyFactorRuleStore"
                                AutoWidth="true" AutoExpandColumn="ConditionValue" Border="false" Title="<font color='red'>政策因素添加成功，请给该因素设置限定条件！</font>"
                                Icon="Lorry" StripeRows="true" Height="120" AutoScroll="true">
                                <TopBar>
                                    <ext:Toolbar ID="Toolbar2" runat="server">
                                        <Items>
                                            <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                            <ext:Button ID="btnWd2AddFactorRule" runat="server" Text="添加" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="Coolite.AjaxMethods.PromotionPolicyFactorRuleSearch.Show(#{hidWd2PolicyId}.getValue(''),#{hidWd2PolicyFactorId}.getValue(),#{cbWd2Factor}.getValue(),'',#{hidWd2ProductLine}.getValue(),#{hidWd2SubBU}.getValue(),#{hidWd2PageType}.getValue(),#{hidWd2PromotionState}.getValue(),{success:function(){RefreshDetailWindow3();RefreshGridWindow3();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                </Listeners>
                                            </ext:Button>
                                        </Items>
                                    </ext:Toolbar>
                                </TopBar>
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="ConditionName" DataIndex="ConditionName" Align="Left" Header="条件">
                                        </ext:Column>
                                        <ext:Column ColumnID="OperTag" DataIndex="OperTag" Align="Left" Header="类型">
                                        </ext:Column>
                                        <ext:Column ColumnID="ConditionValue" DataIndex="ConditionValue" Align="Left" Header="描述">
                                        </ext:Column>
                                        <ext:CommandColumn Width="50" Header="编辑" Align="Center">
                                            <Commands>
                                                <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                    <ToolTip Text="编辑" />
                                                </ext:GridCommand>
                                            </Commands>
                                        </ext:CommandColumn>
                                        <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                            <Commands>
                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                    <ToolTip Text="删除" />
                                                </ext:GridCommand>
                                            </Commands>
                                        </ext:CommandColumn>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <Listeners>
                                    <Command Handler="if (command == 'Edit'){
                                                       Coolite.AjaxMethods.PromotionPolicyFactorRuleSearch.Show(#{hidWd2PolicyId}.getValue(''),#{hidWd2PolicyFactorId}.getValue(),#{cbWd2Factor}.getValue(),record.data.PolicyFactorConditionId,#{hidWd2ProductLine}.getValue(),#{hidWd2SubBU}.getValue(),#{hidWd2PageType}.getValue(),#{hidWd2PromotionState}.getValue(),{success:function(){RefreshGridWindow3();},failure:function(err){Ext.Msg.alert('Error', err);}});       
                                                                                  } 
                                                       if (command == 'Delete'){
                                                       Coolite.AjaxMethods.PromotionPolicyFactorSearch.FactorRuleDelete(record.data.ConditionId,record.data.PolicyFactorConditionId,{success:function(){RefreshFolicyFactorRuleWindow2();},failure:function(err){Ext.Msg.alert('Error', err);}});                               
                                                                                  } 
                                                                                                      
                                                                                                         " />
                                </Listeners>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="PolicyFactorRuleStore"
                                        DisplayInfo="true" />
                                </BottomBar>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnWd2Submint" runat="server" Text="确定" Icon="LorryAdd">
                            <Listeners>
                                <Click Handler="updatePolicyFactor();"></Click>
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelWd2AddFactorRule2" runat="server" BodyBorder="false" Header="false"
                    AutoWidth="true" FormGroup="true" Hidden="true">
                    <Body>
                        <ext:FitLayout ID="FitLayout1" runat="server">
                            <ext:GridPanel ID="GridWd2FactorRule2" runat="server" StoreID="PolicyFactorRelationStore"
                                Border="false" Title="<font color='red'>政策因素添加成功，请给该因素设置限定条件！</font>" Icon="Lorry"
                                AutoWidth="true" StripeRows="true" Height="100" AutoScroll="true">
                                <TopBar>
                                    <ext:Toolbar ID="Toolbar1" runat="server">
                                        <Items>
                                            <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                            <ext:Button ID="btnWd2FactorRule2" runat="server" Text="添加" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="Coolite.AjaxMethods.PromotionPolicyFactorRuleSearch.Show(#{hidWd2PolicyId}.getValue(''),#{hidWd2PolicyFactorId}.getValue(),#{cbWd2Factor}.getValue(),'',#{hidWd2ProductLine}.getValue(),#{hidWd2SubBU}.getValue(),#{hidWd2PageType}.getValue(),#{hidWd2PromotionState}.getValue(),{success:function(){RefreshDetailWindow3();RefreshGridWindow3();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                </Listeners>
                                            </ext:Button>
                                        </Items>
                                    </ext:Toolbar>
                                </TopBar>
                                <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="FactName" DataIndex="FactName" Align="Left" Header="关联因素">
                                        </ext:Column>
                                        <ext:Column ColumnID="FactDesc" DataIndex="FactDesc" Align="Left" Header="描述">
                                        </ext:Column>
                                        <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                            <Commands>
                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                    <ToolTip Text="删除" />
                                                </ext:GridCommand>
                                            </Commands>
                                        </ext:CommandColumn>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <Listeners>
                                    <Command Handler="if (command == 'Delete'){
                                        Coolite.AjaxMethods.PromotionPolicyFactorSearch.FactorRelationDelete(record.data.PolicyFactorId,record.data.ConditionPolicyFactorId,{success:function(){RefreshFolicyFactorRelationWindow2();},failure:function(err){Ext.Msg.alert('Error', err);}});    
                                    } 
                                    " />
                                </Listeners>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBarFactorRelation" runat="server" PageSize="10"
                                        StoreID="PolicyFactorRelationStore" DisplayInfo="true" />
                                </BottomBar>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="Button2" runat="server" Text="确定" Icon="LorryAdd">
                            <Listeners>
                                <Click Handler="updatePolicyFactor();"></Click>
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </ext:Anchor>
        </ext:FormLayout>
    </Body>
</ext:Window>
<ext:Store ID="ProductIndxStore" runat="server" OnRefreshData="ProductIndxStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="SAPCode" />
                <ext:RecordField Name="DealerName" />
                <ext:RecordField Name="PolicyFactorId" />
                <ext:RecordField Name="HospitalId" />
                <ext:RecordField Name="HospitalName" />
                <ext:RecordField Name="Period" />
                <ext:RecordField Name="TargetLevel" />
                <ext:RecordField Name="TargetValue" />
                <ext:RecordField Name="ErrMsg" />
                <ext:RecordField Name="IsErr" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Hidden ID="wd2hidProductIndxFactType" runat="server">
</ext:Hidden>
<ext:Window ID="wd2ProductIndx" runat="server" Icon="Group" Title="指定产品指标导入" Hidden="true"
    Resizable="false" Header="false" Width="700" AutoHeight="true" AutoShow="false"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout2" runat="server">
            <ext:Anchor>
                <ext:FormPanel ID="BasicIndxForm" runat="server" Frame="true" Header="false" AutoHeight="true"
                    MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="50">
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadFieldIndx" runat="server" EmptyText="请选择指定产品指标文件"
                                    FieldLabel="文件" Width="500" ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{SaveIndxButton}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="SaveIndxButton" runat="server" Text="上传指定产品指标">
                            <AjaxEvents>
                                <Click OnEvent="UploadIndxClick" Before="if(!#{BasicIndxForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传指定产品指标...', '指定产品指标上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{PagingToolBarIndx}.changePage(1);#{FileUploadFieldIndx}.setValue(''); Ext.Msg.show({ 
                                        title   : '成功', 
                                        msg     : '上传成功', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        buttons : Ext.Msg.OK 
                                    })">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="ResetIndxButton" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{BasicIndxForm}.getForm().reset();#{SaveIndxButton}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="ButtonIndxDownLoad" runat="server" Text="下载模板">
                            <Listeners>
                                <Click Handler="window.open('../../Upload/ExcelTemplate/Template_PromotionProductIndxInit.xls')" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelWd2AddProductIndx" runat="server" BodyBorder="false" Header="false"
                    FormGroup="true">
                    <Body>
                        <ext:FitLayout ID="FitLayout4" runat="server">
                            <ext:GridPanel ID="GridWd2IndxDetail" runat="server" StoreID="ProductIndxStore" Border="false"
                                Title="指定产品指标" Icon="Lorry" StripeRows="true" Height="200" AutoScroll="true">
                                <ColumnModel ID="ColumnModel3" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="SAPCode" DataIndex="SAPCode" Align="Left" Header="ERP Account"
                                            Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="DealerName" DataIndex="DealerName" Align="Left" Header="经销商名称"
                                            Width="180">
                                        </ext:Column>
                                        <ext:Column ColumnID="HospitalId" DataIndex="HospitalId" Align="Left" Header="医院代码"
                                            Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Align="Left" Header="医院名称"
                                            Width="120">
                                        </ext:Column>
                                        <ext:Column ColumnID="Period" DataIndex="Period" Align="Left" Header="期间" Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="TargetLevel" DataIndex="TargetLevel" Align="Left" Header="目标"
                                            Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="TargetValue" DataIndex="TargetValue" Align="Left" Header="指标"
                                            Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="ErrMsg" DataIndex="ErrMsg" Align="Left" Header="错误信息">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <View>
                                    <ext:GridView ID="PIGridView1" runat="server">
                                        <GetRowClass Fn="getPIndexIsErrRowClassY" />
                                    </ext:GridView>
                                </View>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModelIndx" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBarIndx" runat="server" PageSize="10" StoreID="ProductIndxStore"
                                        DisplayInfo="true" />
                                </BottomBar>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </ext:Anchor>
        </ext:FormLayout>
    </Body>
    <Buttons>
        <ext:Button ID="btnIndxCancel" runat="server" Text="关闭" Icon="LorryAdd">
            <Listeners>
                <Click Handler="#{wd2ProductIndx}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
