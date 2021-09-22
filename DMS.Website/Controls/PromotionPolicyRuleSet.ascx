<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PromotionPolicyRuleSet.ascx.cs"
    Inherits="DMS.Website.Controls.PromotionPolicyRuleSet" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>

<script type="text/javascript" language="javascript">
   function RefreshDetailWindow4() {
        Ext.getCmp('<%=this.PagingToolBarRuleDetail.ClientID%>').changePage(1); 
        Ext.getCmp('<%=this.cbWd4PolicyFactorX.ClientID%>').store.reload();  
    }
    
   function RefreshDetailWindow4CB() {
        Ext.getCmp('<%=this.cbWd4PolicyFactorX.ClientID%>').store.reload();  
    }
    
    function RefreshDetailWindow4GV() {
        Ext.getCmp('<%=this.PagingToolBarRuleDetail.ClientID%>').changePage(1); 
    }
    
   var ValidatePolicyRuleForm = function() {
        var checkError=true;
        var wdRule=Ext.getCmp('<%=this.wd4PolicyRule.ClientID%>');
         
        var styleSub=Ext.getCmp('<%=this.hidWd4PolicyStyleSub.ClientID%>');
        var policyFactorX=Ext.getCmp('<%=this.cbWd4PolicyFactorX.ClientID%>');
        var txtValueX=Ext.getCmp('<%=this.txtFactorValueX.ClientID%>');
        var txtValueY=Ext.getCmp('<%=this.txtFactorValueY.ClientID%>');
        
        var pointType=Ext.getCmp('<%=this.cbWd4PointType.ClientID%>');
        var pointValue=Ext.getCmp('<%=this.nbWd4PointValue.ClientID%>');
        
        var areaDesc=Ext.getCmp('<%=this.areaWd4Desc.ClientID%>');
        if (styleSub.getValue()=='促销赠品')
        {
            if (policyFactorX.getValue()==''){checkError=false;Ext.Msg.alert('Error','请选择 X 因素');}
            else if (txtValueX.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写 X 值');}
            else if (txtValueY.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写 Y 值');}
            else if (areaDesc.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写描述');}
        }
        else if (styleSub.getValue()=='满额送固定积分')
        {
            if (policyFactorX.getValue()==''){checkError=false;Ext.Msg.alert('Error','请选择 X 因素');}
            else if (txtValueX.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写 X 值');}
            else if (areaDesc.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写描述');}
            else if (pointValue.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写固定积分');}
        }
        else if (styleSub.getValue()=='金额百分比积分')
        {
            if (policyFactorX.getValue()==''){checkError=false;Ext.Msg.alert('Error','请选择 X 因素');}
            else if (txtValueY.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写 Y 值（比例）');}
            else if (areaDesc.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写描述');}
        }
        else if (styleSub.getValue()=='促销赠品转积分')
        {
            if (policyFactorX.getValue()==''){checkError=false;Ext.Msg.alert('Error','请选择 X 因素');}
            else if (txtValueX.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写 X 值');}
            else if (txtValueY.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写 Y 值');}
            else if (areaDesc.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写描述');}
            else if (pointType.getValue()==''){checkError=false;Ext.Msg.alert('Error','请选择转换方式');}
        }
       else if (styleSub.getValue()=='满额送赠品')
        {
            if (policyFactorX.getValue()==''){checkError=false;Ext.Msg.alert('Error','请选择 X 因素');}
            else if (txtValueX.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写 X 值');}
            else if (txtValueY.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写 Y 值');}
            else if (areaDesc.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写描述');}
        }
       else if (styleSub.getValue()=='满额打折')
        {
            if (policyFactorX.getValue()==''){checkError=false;Ext.Msg.alert('Error','请选择 X 因素');}
            else if (txtValueY.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写 Y 值');}
            else if (areaDesc.getValue()==''){checkError=false;Ext.Msg.alert('Error','请填写描述');}
        }
        if(checkError)
        {
            Coolite.AjaxMethods.PromotionPolicyRuleSet.SavePolicyRule( 
            {success: function() {  Ext.Msg.alert('Success', '保存成功'); RefreshFactorRuleWindow();wdRule.hide(null); }, failure: function(err) { Ext.Msg.alert('Error', err);} })
        }
        
    }
    
   var factorDescriptionWd4=function() {
        var cbWd4PolicyFactorX=Ext.getCmp('<%=this.cbWd4PolicyFactorX.ClientID%>');
        var txtWd4FactorRemarkX=Ext.getCmp('<%=this.txtWd4FactorRemarkX.ClientID%>');

        for (var i=0 ;i< cbWd4PolicyFactorX.store.getTotalCount(); i++){
          if( cbWd4PolicyFactorX.store.getAt(i).get('PolicyFactorId')==cbWd4PolicyFactorX.getValue()){
            txtWd4FactorRemarkX.setValue(cbWd4PolicyFactorX.store.getAt(i).get('FactDesc'));
          }
        }
    }
    
     function getPPriceIsErrRowClass(record, index) {
        if (record.data.ISErr==1)
        {
           return 'yellow-row';
        }
    }
        
    function RefreshStandardPriceWindow4() {
        Ext.getCmp('<%=this.GridWd2StandardPriceDetail.ClientID%>').reload();
    }
</script>

<ext:Hidden ID="hidWd4PageType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd4PromotionState" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd4IsPageNew" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd4PolicyId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd4PolicyRuleId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd4UsePageId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd4PolicyStyle" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd4PolicyStyleSub" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd4PolicyFactorX" runat="server">
</ext:Hidden>
<ext:Store ID="PolicyRuleDetailStore" runat="server" OnRefreshData="PolicyRuleDetailStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="RuleFactorId">
            <Fields>
                <ext:RecordField Name="RuleFactorId" />
                <ext:RecordField Name="RuleId" />
                <ext:RecordField Name="PolicyFactorId" />
                <ext:RecordField Name="FactName" />
                <ext:RecordField Name="LogicSymbol" />
                <ext:RecordField Name="LogicSymbolName" />
                <ext:RecordField Name="LogicType" />
                <ext:RecordField Name="Value1" />
                <ext:RecordField Name="Value2" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="PolicyFactorXStore" runat="server" OnRefreshData="PolicyFactorXStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="PolicyFactorId">
            <Fields>
                <ext:RecordField Name="PolicyFactorId" />
                <ext:RecordField Name="FactName" />
                <ext:RecordField Name="FactDesc" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbWd4PolicyFactorX}.setValue(#{hidWd4PolicyFactorX}.getValue());" />
    </Listeners>
</ext:Store>
<ext:Window ID="wd4PolicyRule" runat="server" Icon="Group" Title="规则维护" Resizable="false"
    Header="false" Width="600" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
    BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout20" runat="server">
            <ext:Anchor>
                <ext:Panel ID="PanelWd2AddFactorRule" runat="server" BodyBorder="false" Header="false"
                    FormGroup="true">
                    <Body>
                        <ext:FitLayout ID="FitLayout3" runat="server">
                            <ext:GridPanel ID="GridWd4RuleDetail" runat="server" StoreID="PolicyRuleDetailStore"
                                Border="false" Title="规则条件" Icon="Lorry" StripeRows="true" Height="200" AutoScroll="true">
                                <TopBar>
                                    <ext:Toolbar ID="Toolbar2" runat="server">
                                        <Items>
                                            <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                            <ext:Button ID="btnWd4AddFactorRule" runat="server" Text="添加" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="Coolite.AjaxMethods.PromotionPolicyRuleCondition.Show(#{hidWd4PolicyId}.getValue(''),#{hidWd4PolicyRuleId}.getValue(),'',#{hidWd4PageType}.getValue(''),#{hidWd4PromotionState}.getValue(''),{success:function(){ RefreshDetailWindow5();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                </Listeners>
                                            </ext:Button>
                                        </Items>
                                    </ext:Toolbar>
                                </TopBar>
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="FactName" DataIndex="FactName" Align="Left" Header="因素名称">
                                        </ext:Column>
                                        <ext:Column ColumnID="LogicSymbolName" DataIndex="LogicSymbolName" Align="Left" Header="判断符号">
                                        </ext:Column>
                                        <ext:Column ColumnID="Value1" DataIndex="Value1" Align="Left" Header="判断值1">
                                        </ext:Column>
                                        <ext:Column ColumnID="Value2" DataIndex="Value2" Align="Left" Header="判断值2">
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
                                                            Coolite.AjaxMethods.PromotionPolicyRuleCondition.Show(#{hidWd4PolicyId}.getValue(''),#{hidWd4PolicyRuleId}.getValue(),record.data.RuleFactorId,#{hidWd4PageType}.getValue(''),#{hidWd4PromotionState}.getValue(''),{success:function(){RefreshDetailWindow5();},failure:function(err){Ext.Msg.alert('Error', err);}});  
                                                      } 
                                                      if (command == 'Delete'){
                                                            Coolite.AjaxMethods.PromotionPolicyRuleSet.FactorRuleConditionDelete(record.data.RuleFactorId,{success:function(){RefreshDetailWindow4GV();},failure:function(err){Ext.Msg.alert('Error', err);}});  
                                                      } 
                                                                                                      
                                                                                                         " />
                                </Listeners>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBarRuleDetail" runat="server" PageSize="10" StoreID="PolicyRuleDetailStore"
                                        DisplayInfo="true" />
                                </BottomBar>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelWd4PolicyRule" runat="server" Border="true" Title="赠送规则" BodyStyle="padding:5px;">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server" Split="false">
                            <ext:LayoutColumn ColumnWidth="0.6">
                                <ext:Panel ID="Panel6" runat="server" Border="true" FormGroup="true">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout21" runat="server" LabelWidth="100">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbWd4PolicyRuleType" runat="server" EmptyText="选择促销类型..." Width="200"
                                                    Editable="false" TypeAhead="true" BlankText="选择促销类型" AllowBlank="false" Mode="Local"
                                                    Disabled="true" FieldLabel="促销类型" Resizable="true">
                                                    <Items>
                                                        <ext:ListItem Text="满X赠Y" Value="促销赠品" />
                                                        <ext:ListItem Text="满额送固定积分" Value="满额送固定积分" />
                                                        <ext:ListItem Text="金额百分比积分" Value="金额百分比积分" />
                                                        <ext:ListItem Text="买减/价格补偿" Value="促销赠品转积分" />
                                                    </Items>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbWd4PolicyFactorX" runat="server" EmptyText="请选择计算基数X..." Width="200"
                                                    Editable="false" TypeAhead="true" StoreID="PolicyFactorXStore" ValueField="PolicyFactorId"
                                                    DisplayField="FactName" BlankText="选择计算基数X" AllowBlank="false" Mode="Local" FieldLabel="计算基数 X"
                                                    Resizable="true">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();#{txtWd4FactorRemarkX}.setValue('');" />
                                                        <Select Fn="factorDescriptionWd4" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtWd4FactorRemarkX" runat="server" FieldLabel="" ReadOnly="true"
                                                    LabelSeparator="" Enabled="false" Width="200">
                                                </ext:TextField>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbWd4PolicyFactorY" runat="server" EmptyText="选择Y因素..." Width="200"
                                                    Editable="false" TypeAhead="true" BlankText="选择Y因素" Mode="Local" FieldLabel="Y 因素"
                                                    Resizable="true">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtWd4FactorRemarkY" runat="server" FieldLabel="" ReadOnly="true"
                                                    LabelSeparator="" Enabled="false" Width="200">
                                                </ext:TextField>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:NumberField ID="txtFactorValueX" runat="server" Width="200" FieldLabel="X 值" DecimalPrecision="4">
                                                </ext:NumberField>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:NumberField ID="txtFactorValueY" runat="server" Width="200" FieldLabel="Y 值(赠送/折扣)" DecimalPrecision="4"
                                                    AllowBlank="false">
                                                </ext:NumberField>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:NumberField ID="nbWd4PointValue" runat="server" Width="200" FieldLabel="固定积分">
                                                </ext:NumberField>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbWd4PointType" runat="server" EmptyText="请选择积分换算方式..." Width="200"
                                                    Editable="false" TypeAhead="true" BlankText="选择积分换算方式" Mode="Local" FieldLabel="积分换算方式"
                                                    Resizable="true">
                                                    <Items>
                                                        <ext:ListItem Text="按采购价" Value="采购价" />
                                                        <ext:ListItem Text="按经销商固定积分转换" Value="经销商固定积分" />
                                                    </Items>
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();#{btnWd4StandardPrice}.hide();" />
                                                        <Select Handler="if(#{cbWd4PointType}.getValue()=='经销商固定积分') {#{btnWd4StandardPrice}.show(); }else{#{btnWd4StandardPrice}.hide();}" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth="0.4">
                                <ext:Panel ID="Panel7" runat="server" Border="true" FormGroup="true" Title="描述" BodyStyle="padding:5px;">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left">
                                            <ext:Anchor>
                                                <ext:TextArea ID="areaWd4Desc" runat="server" FieldLabel="描述" HideLabel="true" Width="200"
                                                    Height="120" AllowBlank="false">
                                                </ext:TextArea>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Button ID="btnWd4StandardPrice" runat="server" Text="上传产品标准价格" Icon="PackageAdd">
                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.PromotionPolicyRuleSet.StandardPriceShow({success:function(){RefreshStandardPriceWindow4();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                    </Listeners>
                                                </ext:Button>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                </ext:Panel>
            </ext:Anchor>
        </ext:FormLayout>
    </Body>
    <Buttons>
        <ext:Button ID="btnWd4AddFactor" runat="server" Text="确认" Icon="LorryAdd">
            <Listeners>
                <Click Handler="ValidatePolicyRuleForm();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="Button1" runat="server" Text="取消" Icon="Decline">
            <Listeners>
                <Click Handler="#{wd4PolicyRule}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
<ext:Store ID="ProductStandardPriceStore" runat="server" OnRefreshData="ProductStandardPriceStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="SAPCode" />
                <ext:RecordField Name="DealerName" />
                <ext:RecordField Name="Points" />
                <ext:RecordField Name="ErrMsg" />
                <ext:RecordField Name="ISErr" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Window ID="windowStandardPrice" runat="server" Icon="Group" Title="产品补偿价格导入"
    Hidden="true" Resizable="false" Header="false" Width="700" AutoHeight="true"
    AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout2" runat="server">
            <ext:Anchor>
                <ext:FormPanel ID="BaseStandardPriceForm" runat="server" Frame="true" Header="false"
                    AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="50">
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadFieldStandardPrice" runat="server" EmptyText="请选择产品补偿金额文件"
                                    FieldLabel="文件" Width="500" ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{SaveStandardPriceButton}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="SaveStandardPriceButton" runat="server" Text="上传产品补偿金额">
                            <AjaxEvents>
                                <Click OnEvent="UploadStandardPriceClick" Before="if(!#{BaseStandardPriceForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传产品补偿金额...', '产品补偿金额上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{PagingToolBarStandardPrice}.changePage(1);#{FileUploadFieldStandardPrice}.setValue(''); Ext.Msg.show({ 
                                        title   : '成功', 
                                        msg     : '上传成功', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        buttons : Ext.Msg.OK 
                                    })">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="ResetStandardPriceButton" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{BaseStandardPriceForm}.getForm().reset();#{SaveStandardPriceButton}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="ButtonStandardPriceDownLoad" runat="server" Text="下载模板">
                            <Listeners>
                                <Click Handler="window.open('../../Upload/ExcelTemplate/Template_PromotionProductStandardPrice.xls')" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelWd2AddStandardPrice" runat="server" BodyBorder="false" Header="false"
                    FormGroup="true">
                    <Body>
                        <ext:FitLayout ID="FitLayout4" runat="server">
                            <ext:GridPanel ID="GridWd2StandardPriceDetail" runat="server" StoreID="ProductStandardPriceStore"
                                Border="false" Title="产品补偿金额" Icon="Lorry" StripeRows="true" Height="200" AutoScroll="true">
                                <ColumnModel ID="ColumnModel3" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="SAPCode" DataIndex="SAPCode" Align="Left" Header="ERP Account"
                                            Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="DealerName" DataIndex="DealerName" Align="Left" Header="经销商名称"
                                            Width="180">
                                        </ext:Column>
                                        <ext:Column ColumnID="Points" DataIndex="Points" Align="Left" Header="补偿价格" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="ErrMsg" DataIndex="ErrMsg" Align="Left" Header="错误信息">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <View>
                                    <ext:GridView ID="PSPIGridView1" runat="server">
                                        <GetRowClass Fn="getPPriceIsErrRowClass" />
                                    </ext:GridView>
                                </View>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModelStandardPrice" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBarStandardPrice" runat="server" PageSize="10" StoreID="ProductStandardPriceStore"
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
                <Click Handler="#{windowStandardPrice}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
