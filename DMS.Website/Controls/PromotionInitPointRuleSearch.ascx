<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PromotionInitPointRuleSearch.ascx.cs" Inherits="DMS.Website.Controls.PromotionInitPointRuleSearch" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>

<script type="text/javascript" language="javascript">
    function RefreshDetailWindow3() {
        Ext.getCmp('<%=this.cbWd3FactorCondition.ClientID%>').store.reload();
        Ext.getCmp('<%=this.cbWd3FactorConditionType.ClientID%>').store.reload();

    }

    function RefreshGridWindow3() {
        Ext.getCmp('<%=this.GridWd3FactorRuleCondition.ClientID%>').reload();
        Ext.getCmp('<%=this.GridWd3FactorRuleConditionSeleted.ClientID%>').reload();
    }
    function closeWindow3() {
        Ext.getCmp('<%=this.wd3PolicyFactorCondition.ClientID%>').hide(null);
    }

</script>

<ext:Hidden ID="hidWd3PageType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd3PromotionState" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd3UsePageId" runat="server">
</ext:Hidden>
<%--页面状态参数--%>
<ext:Hidden ID="hidWd3IsPageNew" runat="server">
</ext:Hidden>
<%--条件ID--%>
<ext:Hidden ID="hidWd3FactConditionId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidFlowId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd3ProductLine" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd3SubBU" runat="server">
</ext:Hidden>
<ext:Store ID="FactorConditionStore" runat="server" OnRefreshData="FactorConditionStore_RefreshData"
    UseIdConfirmation="true" AutoLoad="true">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="ConditionId">
            <Fields>
                <ext:RecordField Name="ConditionId" />
                <ext:RecordField Name="ConditionName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="FactorConditionTypeStore" runat="server" UseIdConfirmation="true"
    OnRefreshData="FactorConditionTypeStore_RefreshData" AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="ConditionType">
            <Fields>
                <ext:RecordField Name="ConditionType" />
                <ext:RecordField Name="ConditionType" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbWd3FactorConditionType}.setValue(#{cbWd3FactorConditionType}.store.getTotalCount()>0?#{cbWd3FactorConditionType}.store.getAt(0).get('ConditionType'):'');" />
    </Listeners>
</ext:Store>
<ext:Store ID="Wd3RuleStore" runat="server" OnRefreshData="Wd3RuleStore_RefreshData"
    AutoLoad="false">
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
</ext:Store>
<ext:Store ID="Wd3RuleSeletedStore" runat="server" OnRefreshData="Wd3RuleSeletedStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Name" />
                <ext:RecordField Name="RangeType" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Window ID="wd3PolicyFactorCondition" runat="server" Icon="Group" Title="产品范围设定"
    Resizable="false" Y="20" Header="false" Width="800" MinHeight="400" AutoShow="false"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:BorderLayout ID="BorderLayout1" runat="server">
            <West MinWidth="250" Split="true">
                <ext:Panel ID="PanelWd3PolicyFactor" runat="server" Border="true" Title="产品范围" BodyStyle="padding:5px;"
                    Width="250">
                    <Body>
                        <ext:FormLayout ID="FormLayout21" runat="server" LabelWidth="70">
                            <ext:Anchor>
                                <ext:ComboBox ID="cbWd3FactorCondition" runat="server" EmptyText="选择条件..." Width="150"
                                    Editable="false" TypeAhead="true" StoreID="FactorConditionStore" ValueField="ConditionId"
                                    DisplayField="ConditionName" BlankText="选择条件" AllowBlank="false" Mode="Local"
                                    FieldLabel="条件" Resizable="true">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue(); #{cbWd3FactorConditionType}.clearValue(); #{FactorConditionTypeStore}.reload();" />
                                        <Select Handler="#{FactorConditionTypeStore}.reload(); " />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:ComboBox ID="cbWd3FactorConditionType" runat="server" EmptyText="选择类型..." Width="150"
                                    Editable="false" TypeAhead="true" StoreID="FactorConditionTypeStore" ValueField="ConditionType"
                                    DisplayField="ConditionType" BlankText="选择类型" AllowBlank="false" Mode="Local"
                                    FieldLabel="类型" Resizable="true">
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField ID="txtWd3KeyValue" runat="server" FieldLabel="关键字" Width="150">
                                </ext:TextField>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:Panel ID="Panel8" runat="server" Border="false">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout4" runat="server" Split="false">
                                            <ext:LayoutColumn ColumnWidth="0.3">
                                                <ext:Panel ID="Panel11" runat="server" Border="true" FormGroup="true">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:Button ID="btnWd3AddFactorCondition" runat="server" Text="确认" Icon="LorryAdd" Hidden="true">
                                                                    <Listeners>
                                                                        <%--<Click Fn="wd2ShowFactorRule" />--%>
                                                                        <Click Handler="if(#{cbWd3FactorCondition}.getValue()=='' || #{cbWd3FactorConditionType}.getValue()=='') {Ext.Msg.alert('Error','请选择因素的条件及类型');} else{
                                                    Coolite.AjaxMethods.PromotionInitPointRuleSearch.SavePolicyFactorCondition(
                                                        {
                                                            success: function() {
                                                                #{cbWd3FactorCondition}.disable();  #{cbWd3FactorConditionType}.disable();  #{txtWd3KeyValue}.setVisible(true); #{btnWd3FactorConditionQuery}.setVisible(true);
                                                                #{PanelWd3AddFactorCondition}.setVisible(true);#{PanelWd3AddFactorConditionSelected}.setVisible(true);#{btnWd3AddFactorCondition}.setVisible(false);
                                                                
                                                                
                                                            },
                                                            failure: function(err) {
                                                                Ext.Msg.alert('Error', err);
                                                            }
                                                        }
                                                        );
                                                    }" />
                                                                    </Listeners>
                                                                </ext:Button>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth="0.3">
                                                <ext:Panel ID="Panel12" runat="server" Border="true" FormGroup="true">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left">
                                                            <ext:Anchor>
                                                                <ext:Button ID="btnWd3FactorConditionQuery" runat="server" Text="查询" Icon="ArrowRefresh">
                                                                    <Listeners>
                                                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
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
                </ext:Panel>
            </West>
            <Center>
                <ext:Panel ID="Panel1" runat="server" Border="true" BodyStyle="padding:0px;">
                    <Body>
                        <ext:FormLayout ID="FormLayout5" runat="server">
                            <ext:Anchor>
                                <ext:Panel ID="PanelWd3AddFactorCondition" runat="server" BodyBorder="false" Header="false"
                                    AutoWidth="true" Hidden="true">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout3" runat="server">
                                            <ext:GridPanel ID="GridWd3FactorRuleCondition" runat="server" StoreID="Wd3RuleStore"
                                                AutoWidth="true" Border="false" Title="<font color='red'>可选约束条件</font>" Icon="Lorry"
                                                StripeRows="true" AutoExpandColumn="Name" Height="115" AutoScroll="true">
                                                <ColumnModel ID="ColumnModel2" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="Id" DataIndex="Id" Align="Left" Header="Id" Hidden="true">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Name" DataIndex="Name" Align="Left" Header="描述">
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="50" Header="添加" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="Add" CommandName="Add">
                                                                    <ToolTip Text="添加" />
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
                                                    <Command Handler="if (command == 'Add'){
                                                                     Coolite.AjaxMethods.PromotionInitPointRuleSearch.AddRule(record.data.Id,record.data.Name,{success: function(){RefreshGridWindow3();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                    } " />
                                                </Listeners>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="Wd3RuleStore"
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
                </ext:Panel>
            </Center>
            <South MinHeight="150" Split="true">
                <ext:Panel ID="Panel2" runat="server" Border="true" BodyStyle="padding:0px;" Height="190">
                    <Body>
                        <ext:FormLayout ID="FormLayout1" runat="server">
                            <ext:Anchor>
                                <ext:Panel ID="PanelWd3AddFactorConditionSelected" runat="server" BodyBorder="false"
                                    AutoWidth="true" Header="false" Hidden="true">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout1" runat="server">
                                            <ext:GridPanel ID="GridWd3FactorRuleConditionSeleted" runat="server" StoreID="Wd3RuleSeletedStore"
                                                Border="false" Title="<font color='red'>已选约束条件</font>" Icon="Lorry" StripeRows="true"
                                                AutoWidth="true" AutoExpandColumn="Name" Height="100" AutoScroll="true">
                                                <ColumnModel ID="ColumnModel1" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="Id" DataIndex="Id" Align="Left" Header="Id" Hidden="true">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Name" DataIndex="Name" Align="Left" Header="描述">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="RangeType" DataIndex="RangeType" Align="Left" Header="类型" Width="80">
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="Delete" CommandName="Delete">
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
                                    Coolite.AjaxMethods.PromotionInitPointRuleSearch.DeleteRule(record.data.Id,record.data.Name,{success: function(){RefreshGridWindow3();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                    } " />
                                                </Listeners>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="Wd3RuleSeletedStore"
                                                        DisplayInfo="true" />
                                                </BottomBar>
                                                <SaveMask ShowMask="true" />
                                                <LoadMask ShowMask="true" />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                    <Buttons>
                                        <ext:Button ID="Button1" runat="server" Text="确定" Icon="LorryAdd">
                                            <Listeners>
                                                <Click Handler="closeWindow3();checkProductSet();"></Click>
                                            </Listeners>
                                        </ext:Button>
                                    </Buttons>
                                </ext:Panel>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                </ext:Panel>
            </South>
        </ext:BorderLayout>
    </Body>
    <Listeners>
        <BeforeHide Handler="return checkProductSet();" />
    </Listeners>
</ext:Window>
