<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PromotionPolicyRuleCondition.ascx.cs"
    Inherits="DMS.Website.Controls.PromotionPolicyRuleCondition" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>

<script type="text/javascript" language="javascript">
   function RefreshDetailWindow5() {
        Ext.getCmp('<%=this.cbWd5PolicyConditionFacter.ClientID%>').store.reload();  
        Ext.getCmp('<%=this.cbWd5CompareFacter.ClientID%>').store.reload();  
        Ext.getCmp('<%=this.cbWd5Symbol.ClientID%>').store.reload();  
        Ext.getCmp('<%=this.cbWd5ValueType.ClientID%>').store.reload();  
    }
    
    function RefreshDetailWindow5Value() {
        Ext.getCmp('<%=this.cbWd5Value1.ClientID%>').store.reload();  
        Ext.getCmp('<%=this.cbWd5Value2.ClientID%>').store.reload();  
    }
    
    function RefreshDetailWindow5CompareFacter() {
        Ext.getCmp('<%=this.cbWd5CompareFacter.ClientID%>').store.reload(); 
    }
    
</script>

<ext:Hidden ID="hidWd5PageType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd5PromotionState" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd5IsPageNew" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd5PolicyId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd5PolicyRuleId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd5PolicyRuleConditionId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd5UsePageId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd5PolicyConditionFacter" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd5Symbol" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd5CompareFacter" runat="server">
</ext:Hidden>
<ext:Store ID="ConditionFacterRuleStore" runat="server" OnRefreshData="ConditionFacterRuleStore_RefreshData"
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
        <Load Handler="#{cbWd5PolicyConditionFacter}.setValue(#{hidWd5PolicyConditionFacter}.getValue());" />
    </Listeners>
</ext:Store>
<ext:Store ID="CompareFacterStore" runat="server" OnRefreshData="CompareFacterStore_RefreshData"
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
        <Load Handler="#{cbWd5CompareFacter}.setValue(#{hidWd5CompareFacter}.getValue());" />
    </Listeners>
</ext:Store>
<ext:Store ID="SymbolStore" runat="server" OnRefreshData="SymbolStore_RefreshData"
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
    <Listeners>
        <Load Handler="#{cbWd5Symbol}.setValue(#{hidWd5Symbol}.getValue());" />
    </Listeners>
</ext:Store>
<ext:Store ID="ValueTypeStore" runat="server" OnRefreshData="ValueTypeStore_RefreshData"
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
</ext:Store>
<ext:Store ID="ValueStore" runat="server" OnRefreshData="ValueStore_RefreshData"
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
</ext:Store>
<ext:Window ID="wd5PolicyRuleCondition" runat="server" Icon="Group" Title="规则条件"
    Resizable="false" Header="false" Width="380" AutoShow="false" AutoHeight="true"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" ButtonAlign="Center">
    <Body>
        <ext:FormLayout ID="FormLayout21" runat="server" LabelWidth="100">
            <ext:Anchor>
                <ext:ComboBox ID="cbWd5PolicyConditionFacter" runat="server" EmptyText="选择条件因素..."
                    Width="200" Editable="false" TypeAhead="true" StoreID="ConditionFacterRuleStore"
                    ValueField="PolicyFactorId" DisplayField="FactName" BlankText="选择条件因素" AllowBlank="false"
                    Mode="Local" FieldLabel="条件因素" Resizable="true">
                    <Triggers>
                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                    </Triggers>
                    <Listeners>
                        <TriggerClick Handler="this.clearValue();" />
                    </Listeners>
                </ext:ComboBox>
            </ext:Anchor>
            <ext:Anchor>
                <ext:ComboBox ID="cbWd5Symbol" runat="server" EmptyText="选择判断符号..." Width="200" Editable="false"
                    TypeAhead="true" StoreID="SymbolStore" ValueField="Key" DisplayField="Value"
                    BlankText="选择判断符号" AllowBlank="false" Mode="Local" FieldLabel="判断符号" Resizable="true">
                    <Triggers>
                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                    </Triggers>
                    <Listeners>
                        <TriggerClick Handler="this.clearValue();" />
                    </Listeners>
                </ext:ComboBox>
            </ext:Anchor>
            <ext:Anchor>
                <ext:ComboBox ID="cbWd5ValueType" runat="server" EmptyText="选择值类型..." Width="200"
                    Editable="false" TypeAhead="true" StoreID="ValueTypeStore" ValueField="Key" DisplayField="Value"
                    BlankText="选择值类型" AllowBlank="false" Mode="Local" FieldLabel="值类型" Resizable="true">
                    <Triggers>
                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                    </Triggers>
                    <Listeners>
                        <TriggerClick Handler="this.clearValue();" />
                        <Select Handler="if(#{cbWd5ValueType}.getValue()=='AbsoluteValue') {  #{nfWd5Value1}.show();  #{nfWd5Value2}.show();  #{cbWd5Value1}.hide();  #{cbWd5Value2}.hide();  #{cbWd5CompareFacter}.hide(); #{nbWd5CompareFacterRatio}.hide();#{nbWd5CompareFacterRatio}.setValue('');} 
                        else if (#{cbWd5ValueType}.getValue()=='RelativeValue') {  #{nfWd5Value1}.hide();  #{nfWd5Value2}.hide();  #{cbWd5Value1}.show();  #{cbWd5Value2}.show();  #{cbWd5CompareFacter}.hide(); #{nbWd5CompareFacterRatio}.hide();#{nbWd5CompareFacterRatio}.setValue('');RefreshDetailWindow5Value();}
                        else if (#{cbWd5ValueType}.getValue()=='OtherFactor') {   #{nfWd5Value1}.hide();  #{nfWd5Value2}.hide();  #{cbWd5Value1}.hide();  #{cbWd5Value2}.hide();  #{cbWd5CompareFacter}.show();  #{nbWd5CompareFacterRatio}.show();#{nbWd5CompareFacterRatio}.setValue('1');RefreshDetailWindow5CompareFacter();}
                        " />
                        <%--  <Select Handler="if(#{cbWd5ValueType}.getValue()=='AbsoluteValue') { #{PanelWd5Absolute}.enable();  #{PanelWd5Relative}.disable();  #{PanelWd5OtherFactor}.disable();} 
                        else if (#{cbWd5ValueType}.getValue()=='RelativeValue') { #{PanelWd5Relative}.enable();  #{PanelWd5Absolute}.disable();  #{PanelWd5OtherFactor}.disable(); RefreshDetailWindow5Value();}
                        else if (#{cbWd5ValueType}.getValue()=='OtherFactor') { #{PanelWd5OtherFactor}.enable();  #{PanelWd5Absolute}.disable();  #{PanelWd5Relative}.disable(); RefreshDetailWindow5CompareFacter();}
                        " />--%>
                    </Listeners>
                </ext:ComboBox>
            </ext:Anchor>
            <ext:Anchor>
                <ext:ComboBox ID="cbWd5Value1" runat="server" EmptyText="选择判断值1..." Width="200" Editable="false"
                    Hidden="true" TypeAhead="true" StoreID="ValueStore" ValueField="Key" DisplayField="Value"
                    BlankText="选择判断值1" AllowBlank="false" Mode="Local" FieldLabel="引用判断值1" Resizable="true">
                    <Triggers>
                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                    </Triggers>
                    <Listeners>
                        <TriggerClick Handler="this.clearValue();" />
                    </Listeners>
                </ext:ComboBox>
            </ext:Anchor>
            <ext:Anchor>
                <ext:ComboBox ID="cbWd5Value2" runat="server" EmptyText="选择判断值2..." Width="200" Editable="false"
                    Hidden="true" TypeAhead="true" StoreID="ValueStore" ValueField="Key" DisplayField="Value"
                    BlankText="选择判断值2" Mode="Local" FieldLabel="引用判断值2" Resizable="true">
                    <Triggers>
                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                    </Triggers>
                    <Listeners>
                        <TriggerClick Handler="this.clearValue();" />
                    </Listeners>
                </ext:ComboBox>
            </ext:Anchor>
            <ext:Anchor>
                <ext:NumberField ID="nfWd5Value1" runat="server" FieldLabel="判断值1" AllowBlank="false"
                    Hidden="true" Width="200">
                </ext:NumberField>
            </ext:Anchor>
            <ext:Anchor>
                <ext:NumberField ID="nfWd5Value2" runat="server" FieldLabel="判断值2" Width="200" Hidden="true">
                </ext:NumberField>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelWd5OtherFactor" runat="server" Border="true" FormGroup="true">
                    <Body>
                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left">
                            <ext:Anchor>
                                <ext:ComboBox ID="cbWd5CompareFacter" runat="server" EmptyText="选择比较因素..." Width="200"
                                    Hidden="true" Editable="false" TypeAhead="true" StoreID="CompareFacterStore"
                                    ValueField="PolicyFactorId" DisplayField="FactName" BlankText="选择比较因素" AllowBlank="false"
                                    Mode="Local" FieldLabel="比较因素" Resizable="true">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:NumberField ID="nbWd5CompareFacterRatio" runat="server" Width="200" FieldLabel="系数">
                                </ext:NumberField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                </ext:Panel>
            </ext:Anchor>
        </ext:FormLayout>
    </Body>
    <Buttons>
        <ext:Button ID="btnWd2AddFactor" runat="server" Text="确认" Icon="LorryAdd">
            <Listeners>
                <Click Handler="if(#{cbWd5PolicyConditionFacter}.getValue()=='') { Ext.Msg.alert('Error','请选择条件因素');}
                                    else if(#{cbWd5Symbol}.getValue()=='')  { Ext.Msg.alert('Error','请选择判断符号');}
                                    else if(#{cbWd5ValueType}.getValue()=='')  { Ext.Msg.alert('Error','请选择值类型');}
                                    else if(#{cbWd5ValueType}.getValue()=='AbsoluteValue'&& #{nfWd5Value1}.getValue()=='')  { Ext.Msg.alert('Error','请填写判断值');}
                                    else if(#{cbWd5ValueType}.getValue()=='RelativeValue'&& #{cbWd5Value1}.getValue()=='')  { Ext.Msg.alert('Error','请选择引用判断值');}
                                    else if(#{cbWd5ValueType}.getValue()=='OtherFactor'&& #{cbWd5CompareFacter}.getValue()=='')  { Ext.Msg.alert('Error','请选择比较因素');}
                                    
                                    else { Coolite.AjaxMethods.PromotionPolicyRuleCondition.SaveRuleFactor(
                                            {
                                                success: function() { Ext.Msg.alert('Success', '保存成功');  RefreshDetailWindow4GV(); #{wd5PolicyRuleCondition}.hide(null);
                                                },
                                                failure: function(err) {
                                                    Ext.Msg.alert('Error', err);
                                                }
                                            }
                                         ) 
                                   } " />
            </Listeners>
        </ext:Button>
        <ext:Button ID="Button1" runat="server" Text="取消" Icon="Decline">
            <Listeners>
                <Click Handler="#{wd5PolicyRuleCondition}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
