<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ConsignmentApplyHeaderWindow.ascx.cs" Inherits="DMS.Website.Controls.ConsignmentApplyHeaderWindow" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>


<ext:Store ID="OrderTrackStore" runat="server" AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CahId" />
                    <ext:RecordField Name="CahOrderNo" />
                    <ext:RecordField Name="CahSubmitDate" Type="Date" />
                    <ext:RecordField Name="CfnId" />
                    <ext:RecordField Name="PmaId" />
                    <ext:RecordField Name="CfnChineseName" />
                    <ext:RecordField Name="CfnEnglishName" />
                    <ext:RecordField Name="CfnCode" />
                    <ext:RecordField Name="CfnCode2" />
                    <ext:RecordField Name="CfnUom" />
                    <ext:RecordField Name="LotId" />
                    <ext:RecordField Name="LotNumber" />
                    <ext:RecordField Name="TotalQty" />
                    <ext:RecordField Name="PurchaseId" />
                    <ext:RecordField Name="PurchaseNo" />
                    <ext:RecordField Name="PurchaseDate" Type="Date" />
                    <ext:RecordField Name="PurchaseQty" />
                    <ext:RecordField Name="POReceiptId" />
                    <ext:RecordField Name="POReceiptNo" />
                    <ext:RecordField Name="POReceiptSapNo" />
                    <ext:RecordField Name="POReceiptDeliveryDate" />
                    <ext:RecordField Name="POReceiptDate" />
                    <ext:RecordField Name="POReceiptQty" />
                    <ext:RecordField Name="ExpirationDate" Type="Date" />
                    <ext:RecordField Name="ConsignmentDay" />
                    <ext:RecordField Name="DelayNumber" />
                    <ext:RecordField Name="ShipmentLotId" />
                    <ext:RecordField Name="ShipmentNos" />
                    <ext:RecordField Name="ShipmentDates" />
                    <ext:RecordField Name="ShipmentSubmitDates" />
                    <ext:RecordField Name="ShipmentQty" />
                    <ext:RecordField Name="ReturnLotId" />
                    <ext:RecordField Name="ReturnNos" />
                    <ext:RecordField Name="ReturnDates" />
                    <ext:RecordField Name="ReturnApprovelDates" />
                    <ext:RecordField Name="ReturnQty" />
                    <ext:RecordField Name="Qty" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
           <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
            <Load Handler="#{DetailWindow}.body.unmask();" />
            <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="OrderLogStore" runat="server" AutoLoad="false" >
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
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
        <Listeners>
           <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
            <Load Handler="#{DetailWindow}.body.unmask();" />
            <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
        </Listeners>
    </ext:Store>
 <ext:Store ID="DealerConsignmentStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Name" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
        <ext:Store ID="ProductsourceStor" runat="server" UseIdConfirmation="true">
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
        <ext:Store ID="HostitStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="ShortName" />
                    <ext:RecordField Name="Address" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Id" Direction="ASC" />
        <Listeners>
            <%--<Load Handler="#{cbProductLine}.setValue(#{cbProductLine}.store.getTotalCount()>0?#{cbProductLine}.store.getAt(0).get('Id'):'');" />--%>
        </Listeners>
    </ext:Store>
        <ext:Store ID="ProductLineDmaStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Name" />
                   
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Id" Direction="ASC" />
        </ext:Store>
            <ext:Store ID="SalesRepStor" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Email" />
                    <ext:RecordField Name="Mobile" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="DetailStore" runat="server" 
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CAH_Id" />
                    <ext:RecordField Name="CFN_Id" />
                    <ext:RecordField Name="UOM" />
                    <ext:RecordField Name="Qty" />
                    <ext:RecordField Name="Price" />
                    <ext:RecordField Name="Actual_Price" />
                    <ext:RecordField Name="Amount" />
                    <ext:RecordField Name="Remark" />
                    <ext:RecordField Name="LotNumber" />
                    <ext:RecordField Name="BarCode" />
                    <ext:RecordField Name="BarCode_Id" />
                    <ext:RecordField Name="CustomerFaceNbr" />
                    <ext:RecordField Name="CfnChineseName" />
                    <ext:RecordField Name="CfnEnglishName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
            <Load Handler="#{DetailWindow}.body.unmask();" />
            <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
        </Listeners>
    </ext:Store>
<ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="订单详情" Width="1024"
        Height="530" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
        <Body>
            <ext:BorderLayout ID="BorderLayout2" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:FormPanel ID="FormPanel1" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn ColumnWidth=".24">
                                    <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                        <Body>
                                            <%--表头信息 --%>
                                            <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="70">
                                                <%--订单类型、订单编号、提交日期 --%>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtApplyType" runat="server" ReadOnly="true" FieldLabel="申请单类型"
                                                        Width="120" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbproline" runat="server" LabelStyle="color:red;" Width="120" Editable="false"
                                                        TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName"
                                                        FieldLabel="产品线" AllowBlank="false" BlankText="产品线" EmptyText="请选择.." ListWidth="200"
                                                        Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                            <Select Handler="#{Toolbar1}.setDisabled(true);ChangeProductLine();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="txtRule" runat="server" LabelStyle="color:red;" Width="120" Editable="false"
                                                        TypeAhead="true" StoreID="DealerConsignmentStore" ValueField="Id" DisplayField="Name"
                                                        FieldLabel="寄售规则" AllowBlank="false" BlankText="寄售规则" EmptyText="寄售规则" ListWidth="200"
                                                        Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                            <Select Handler="#{Toolbar1}.setDisabled(true);SetConsignment();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".24">
                                    <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="70">
                                                <%--产品线、订单状态、财务信息 --%>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtDealerName" ReadOnly="true" runat="server" FieldLabel="经销商名称"
                                                        Width="150" />
                                            
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbProductsource" runat="server" LabelStyle="color:red;" Width="150"
                                                        Editable="false" TypeAhead="true" Disabled="false" StoreID="ProductsourceStor"
                                                        ValueField="Key" DisplayField="Value" FieldLabel="产品来源" AllowBlank="true" BlankText="产品来源"
                                                        EmptyText="请选择" ListWidth="200" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                            <Select Handler="#{Toolbar1}.setDisabled(true);ChanConsignmentFrom();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbHospital" runat="server" Width="150" Editable="true" TypeAhead="true"
                                                        StoreID="HostitStore" ValueField="Id" DisplayField="Name" LabelStyle="color:red;"
                                                        FieldLabel="医院" AllowBlank="true" BlankText="医院" EmptyText="医院" ListWidth="200"
                                                        Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                           <BeforeQuery Fn="SelectValue" />
                                                        <%--   <Select Handler="#{Toolbar1}.setDisabled(true); ChangeHospit();" />--%>
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="70">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtSubmitDate" ReadOnly="true" runat="server" FieldLabel="提交日期"
                                                        Width="130" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbSuorcePro" runat="server" LabelStyle="color:red;" Width="130"
                                                        Editable="true" TypeAhead="true" Disabled="false" StoreID="ProductLineDmaStore" ValueField="Id" DisplayField="Name"
                                                        FieldLabel="来源经销商" AllowBlank="true" BlankText="来源经销商" EmptyText="请选择" ListWidth="200"
                                                        Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                           <Select Handler="#{Toolbar1}.setDisabled(true);ChaneSourceDealer();"/>
                                                           <BeforeQuery Fn="SelectValue" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel14" runat="server" Border="false">
                                                        <Body>
                                                            <div style="color: Red;">
                                                            注:小于等于15天的寄售必须选择医院。
                                                            </div>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".22">
                                    <ext:Panel ID="Panel17" runat="server" Border="false" Header="false">
                                        <Body>
                                            <%--表头信息 --%>
                                            <ext:FormLayout ID="forminfo1" runat="server" LabelAlign="Left" LabelWidth="75">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtApplyNo" ReadOnly="true" runat="server" FieldLabel="申请单号" Width="130" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtOrderState" ReadOnly="true" runat="server" FieldLabel="订单状态"
                                                        Width="130" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtDelayState" ReadOnly="true" runat="server" FieldLabel="延期申请状态"
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
                            <ext:Tab ID="TabHeader" runat="server" Title="申请单主信息" BodyStyle="padding: 6px;" AutoScroll="true">
                                <%--表头信息 --%>
                                <Body>
                                    <ext:FitLayout ID="FTHeader" runat="server">
                                        <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout3" runat="server" Split="false">
                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                        <ext:Panel ID="Panela" runat="server" Border="true" FormGroup="true" Title="汇总信息">
                                                            <%--汇总信息 --%>
                                                            <Body>
                                                                <ext:FormLayout ID="forminfo2" runat="server" LabelAlign="Left">
                                                                    <%--金额汇总、数量汇总、VirtualDC、备注 --%>
                                                                    <ext:Anchor>
                                                                        <ext:NumberField ID="txtnumber" ReadOnly="true" runat="server" FieldLabel="申请数量汇总">
                                                                        </ext:NumberField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Label ID="lbConsignment" runat="server" FieldLabel="寄售原因">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                                                            <Body>
                                                                                <div style="color: Red;">
                                                                                    注:小于等于15天的寄售必须填写原因<br></br>
                                                                                    寄售原因中填写手术相关信息。</div>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextArea ID="txtConsignment" runat="server" Width="240" Height="80" HideLabel="true" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Label ID="lbRemark" runat="server" FieldLabel="备注说明">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextArea ID="txtRemark" runat="server" Width="240" Height="80" HideLabel="true" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.35">
                                                        <ext:Panel ID="boke" runat="server" Border="true" FormGroup="true" Title="销售信息">
                                                            <%--订单信息 --%>
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                    <%--特殊价格规则名称、特殊价格规则编号、订单联系人、联系方式、手机号码 --%>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbSale" runat="server" LabelStyle="color:red;" Width="205" Editable="false"
                                                                            TypeAhead="true" Disabled="false" StoreID="SalesRepStor" ValueField="Id" DisplayField="Id"
                                                                            FieldLabel="销售" AllowBlank="true" BlankText="销售" EmptyText="请选择" ListWidth="200"
                                                                            Resizable="true">
                                                                            <Triggers>
                                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" HideTrigger="true" />
                                                                            </Triggers>
                                                                            <Listeners>
                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                                <Select Handler="#{Toolbar1}.setDisabled(true);ChaneSale();" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtSalesName" LabelStyle="color:red;" runat="server" Width="205"
                                                                            FieldLabel="销售姓名" AllowBlank="false" BlankText="销售姓名" MsgTarget="Side" MaxLength="100" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtSalesEmail" LabelStyle="color:red;" runat="server" Width="205"
                                                                            FieldLabel="销售邮箱" AllowBlank="false" BlankText="销售邮箱" MsgTarget="Side" MaxLength="100" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtSalesPhone" LabelStyle="color:red;" runat="server" Width="205"
                                                                            FieldLabel="销售电话" AllowBlank="false" BlankText="销售电话" MsgTarget="Side" MaxLength="100" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.35">
                                                        <ext:Panel ID="Panel10" runat="server" Border="true" FormGroup="true" Title="收货人信息">
                                                            <%-- 收货信息 --%>
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left">
                                                                    <%--收货仓库选择、收货地址、收货人、收货人电话、期望到货时间、承运商 --%>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtConsignee" LabelStyle="color:red;" runat="server" Width="150"
                                                                            FieldLabel="收货人" AllowBlank="false" BlankText="请填写收货人..." MsgTarget="Side" MaxLength="250" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtConsigneeAddress" LabelStyle="color:red;" runat="server" Width="150"
                                                                            FieldLabel="收货地址" AllowBlank="false" BlankText="收货地址" MsgTarget="Side" MaxLength="200" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtConsigneePhone" LabelStyle="color:red;" runat="server" Width="150"
                                                                            FieldLabel="收货人电话" AllowBlank="false" BlankText="收货人电话" MsgTarget="Side" MaxLength="200">
                                                                        </ext:TextField>
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
                            <ext:Tab ID="TabDetail" runat="server" Title="寄售规则明细" AutoScroll="false">
                                <Body>
                                    <ext:FitLayout ID="FitLayout3" runat="server">
                                        <ext:FormPanel ID="FormPanel3" runat="server" Header="false" Border="false">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout4" runat="server" Split="false">
                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                        <ext:Panel ID="Panel11" runat="server" Border="true" FormGroup="true" Title="寄售规则明细">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left">
                                                                    <%--寄售天数... --%>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtNumberDays" ReadOnly="true" runat="server" Width="150" FieldLabel="寄售天数"
                                                                            AllowBlank="true" BlankText="寄售天数" MsgTarget="Side" MaxLength="100" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtNearlyvalidType" ReadOnly="true" runat="server" Width="150"
                                                                            FieldLabel="近效期类型" AllowBlank="true" BlankText="近效期类型" MsgTarget="Side" MaxLength="100" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtLateMoney" ReadOnly="true" LabelStyle="color:#4e79b2;" runat="server"
                                                                            Width="150" FieldLabel="滞纳金 每日金额" AllowBlank="true" BlankText="滞纳金 每日金额" MsgTarget="Side"
                                                                            MaxLength="100" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                        <ext:Panel ID="Panel12" runat="server" Border="true" FormGroup="true" Title="寄售规则明细">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left">
                                                                    <%--寄售天数... --%>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtDelaytimes" ReadOnly="true" runat="server" Width="150" FieldLabel="可延期次数"
                                                                            AllowBlank="true" BlankText="可延期次数" MsgTarget="Side" MaxLength="100" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtReturnperiod" ReadOnly="true" runat="server" Width="150" FieldLabel="退货期限"
                                                                            AllowBlank="true" BlankText="退货期限" MsgTarget="Side" MaxLength="100" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtMainMoney" ReadOnly="true" LabelStyle="color:#4e79b2;" runat="server"
                                                                            Width="150" FieldLabel="最低保证金金额" AllowBlank="true" BlankText="最低保证金金额" MsgTarget="Side"
                                                                            MaxLength="100" />
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                        <ext:Panel ID="Panel13" runat="server" Border="true" FormGroup="true" Title="寄售规则明细">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout11" runat="server" LabelAlign="Left">
                                                                    <%--寄售天数... --%>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtBeginData" ReadOnly="true" runat="server" Width="150" FieldLabel="时间期限-起始"
                                                                            AllowBlank="true" BlankText="时间期限-起始" MsgTarget="Side" MaxLength="100" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtEndData" ReadOnly="true" runat="server" Width="150" FieldLabel="时间期限-截止"
                                                                            AllowBlank="true" BlankText="时间期限-截止" MsgTarget="Side" MaxLength="100" />
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtTotalMoney" ReadOnly="true" LabelStyle="color:#4e79b2;" runat="server"
                                                                            Width="150" FieldLabel="总量控制金额" AllowBlank="true" BlankText="总量控制金额" MsgTarget="Side"
                                                                            MaxLength="100" />
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
                            <ext:Tab ID="TabInvoice" runat="server" Title="申请产品明细" AutoScroll="false">
                                <Body>
                                    <ext:FitLayout ID="FT1" runat="server">
                                        <ext:GridPanel ID="gpDetail" runat="server" Title="申请产品明细" StoreID="DetailStore"
                                            StripeRows="true" Border="false" Icon="Lorry" ClicksToEdit="1" EnableHdMenu="false"
                                            Header="false">
                                            <TopBar>
                                                <ext:Toolbar ID="Toolbar1" runat="server">
                                                    <Items>
                                                        <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                        <ext:Button ID="btnAddOtherdealersCfn" runat="server" Text="添加退货单产品" Icon="Add">
                                                         <Listeners>
                                                                <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{cbDealer}.getValue() == '' || #{cbproline}.getValue() == ''|| #{cbSuorcePro}.getValue() ==''||#{txtRule}.getValue()=='') {alert('请选择必要的信息！');return false;} 
                                                            {Coolite.AjaxMethods.ConsignmenReturnsCfn.Show(#{hidInstanceId}.getValue(),#{cbproline}.getValue(),#{cbDealer}.getValue(),#{cbSuorcePro}.getValue(),#{txtRule}.getValue(),{success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                                                            </Listeners>
                                                        
                                                        </ext:Button>
                                                        <ext:Button ID="btnAddCfn" runat="server" Text="添加产品" Icon="Add">
                                                            <Listeners>
                                                                <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{cbDealer}.getValue() == '' || #{cbproline}.getValue() == ''|| #{hidOrderType}.getValue() =='') {alert('请选择必要的信息！');return false;} 
                                                            {Coolite.AjaxMethods.ConsignmenCfn.Show(#{hidInstanceId}.getValue(),#{cbproline}.getValue(),#{cbDealer}.getValue(),#{hidPriceType}.getValue(),#{hidSpecialPrice}.getValue(),#{hidOrderType}.getValue(),{success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                                                            </Listeners>
                                                        </ext:Button>
                                                        <ext:Button ID="btnAddCfnSet" runat="server" Text="添加组产品" Icon="Add">
                                                            <Listeners>
                                                                <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{cbDealer}.getValue() == '' || #{cbproline}.getValue() == ''|| #{hidOrderType}.getValue() =='') {alert('请选择必要的信息！'); return false;} 
                                                            {Coolite.AjaxMethods.ConsignmenCfnSet.Show(#{hidInstanceId}.getValue(),#{cbproline}.getValue(),#{cbDealer}.getValue(),#{hidPriceType}.getValue(),#{hidSpecialPrice}.getValue(),#{hidOrderType}.getValue(),{success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                                                            </Listeners>
                                                        </ext:Button>
                                                    </Items>
                                                </ext:Toolbar>
                                            </TopBar>
                                            <ColumnModel ID="ColumnModel3" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Width="200" Header="产品型号">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CfnChineseName" DataIndex="CfnChineseName" Header="产品中文名">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CfnEnglishName" DataIndex="CfnEnglishName" Header="产品英文名" Width="70"
                                                        Align="Center">
                                                        <%--<Renderer Fn="SetCellCss" />--%>
                                                    </ext:Column>
                                                      <ext:Column ColumnID="UOM" DataIndex="UOM" Header="单位" Width="70"
                                                        Align="Center">
                                                        <%--<Renderer Fn="SetCellCss" />--%>
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Qty" DataIndex="Qty" Header="申请数量" Width="70" Align="Right">
                                                        <Editor>
                                                            <ext:NumberField ID="txtRequiredQty" runat="server" AllowBlank="false" AllowDecimals="false"
                                                                DataIndex="Qty" SelectOnFocus="false" AllowNegative="false">
                                                            </ext:NumberField>
                                                        </Editor>
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Price" Hidden="true" DataIndex="Price" Header="产品单价" Width="70" Align="Right">
                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                        <Editor>
                                                            <ext:NumberField ID="txtCfnPrice" runat="server" AllowBlank="false" AllowDecimals="true"
                                                                DataIndex="CfnPrice" SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                            </ext:NumberField>
                                                        </Editor>
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Amount" Hidden="true" DataIndex="Amount" Header="金额小计" Width="80" Align="Right">
                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                        <Editor>
                                                            <ext:NumberField ID="txtAmount" runat="server" AllowBlank="false" DataIndex="Amount"
                                                                SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                            </ext:NumberField>
                                                        </Editor>
                                                    </ext:Column>
                                                      <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="批号" Width="70"
                                                        Align="Center">
                                                        <%--<Renderer Fn="SetCellCss" />--%>
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <%--<View>
                                            <ext:GridView ID="GridView2" runat="server">
                                                <GetRowClass Fn="getCurrentInvRowClass" />
                                            </ext:GridView>
                                        </View>--%>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="ProductDetaile" SingleSelect="true" runat="server" MoveEditorOnEnter="true">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="ShowEditingMask();Coolite.AjaxMethods.DeleteItem(record.data.Id,{success:function(){ DetailStoreLoad();SetWinBtnDisabled(#{DetailWindow},false);},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                <BeforeEdit Handler="#{hidEditItemId}.setValue(this.getSelectionModel().getSelected().id);#{hidCustomerFaceNbr}.setValue(this.getSelectionModel().getSelected().data.CustomerFaceNbr);#{txtRequiredQty}.setValue(this.getSelectionModel().getSelected().data.RequiredQty);#{txtCfnPrice}.setValue(this.getSelectionModel().getSelected().data.Price);#{txtAmount}.setValue(this.getSelectionModel().getSelected().data.Amount);" />
                                                <AfterEdit Handler="ShowEditingMask();StoreCommitAll(this.store);UpdateItem();" />
                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="50" StoreID="DetailStore"
                                                    DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="false" />
                                            <LoadMask ShowMask="false" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                                <Listeners>
                                    <Activate Handler="Coolite.AjaxMethods.InitBtnCfnAdd();" />
                                </Listeners>
                            </ext:Tab>
                            <ext:Tab ID="TabTrack" runat="server" Title="产品追踪明细" AutoScroll="false">
                                <Body>
                                    <ext:FitLayout ID="FitLayout2" runat="server">
                                        <ext:GridPanel ID="gpTrack" runat="server" Title="产品追踪明细" StoreID="OrderTrackStore" AutoScroll="true"
                                            StripeRows="true" Collapsible="false" Border="false" Header="false" Icon="Lorry" >
                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="CfnCode" DataIndex="CfnCode" Header="产品型号" Width="90">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CfnCode2" DataIndex="CfnCode2" Header="短编号" Width="60">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="批次号" Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PurchaseNo" DataIndex="PurchaseNo" Header="订单号" Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PurchaseDate" DataIndex="PurchaseDate" Header="订单日期" Width="90">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PurchaseQty" DataIndex="PurchaseQty" Header="订单数量" Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="POReceiptNo" DataIndex="POReceiptNo" Header="发货单号" Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="POReceiptDeliveryDate" DataIndex="POReceiptDeliveryDate" Header="发货日期" Width="90">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="POReceiptQty" DataIndex="POReceiptQty" Header="发货数量" Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ReturnNos" DataIndex="ReturnNos" Header="退货单号" Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ReturnDates" DataIndex="ReturnDates" Header="退货日期" Width="90">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ReturnQty" DataIndex="ReturnQty" Header="退货数量" Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ShipmentNos" DataIndex="ShipmentNos" Header="销售单号" Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ShipmentDates" DataIndex="ShipmentDates" Header="销售日期" Width="90">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ShipmentQty" DataIndex="ShipmentQty" Header="销售数量" Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Qty" DataIndex="Qty" Header="当前库存数" Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="当前库存数" Width="70" Hidden="true" >
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ExpirationDate" DataIndex="ExpirationDate" Header="到期日期" Width="90">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DelayNumber" DataIndex="DelayNumber" Header="延期次数" Width="70">
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                                    MoveEditorOnEnter="true">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="50" StoreID="OrderTrackStore"
                                                    DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="false" />
                                            <LoadMask ShowMask="false" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="TabLog" runat="server" Title="操作记录" AutoScroll="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout4" runat="server">
                                        <ext:GridPanel ID="gpLog" runat="server" Title="操作记录" StoreID="OrderLogStore"
                                            AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                            Icon="Lorry" AutoExpandColumn="OperNote">
                                            <ColumnModel ID="ColumnModel4" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="操作人账号" Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="操作人姓名" Width="150">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="操作内容" Width="150">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="操作时间" Width="150">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="备注信息">
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                    MoveEditorOnEnter="true">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="50" StoreID="OrderLogStore"
                                                    DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="false" />
                                            <LoadMask ShowMask="false" />
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
             <ext:Button ID="BtnDelay" runat="server" Text="申请延期" Icon="Add">
                <Listeners>
                    <Click Handler="   Ext.Msg.confirm('Messgin', '确定申请?', function(e) {

                if (e == 'yes') {  Coolite.AjaxMethods.btnDelayClick(
                    {success:function(){
                    if(#{hidIsSaved}.getValue()=='True')
                    {
                    #{DetailWindow}.hide(); RefreshMainPage();
                    }
                    else if(#{hidRtnVal}.getValue()=='Error'){
                    Ext.Msg.alert('Messg',#{hidRtnMsg}.getValue());
                    }
                    
                    },failure:function(err){Ext.Msg.alert('Error', err);}});
                      }

            })" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="btnSave" runat="server" Text="保存草稿" Icon="Add">
                <Listeners>
                    <Click Handler=" Coolite.AjaxMethods.SaveDraft(
                    {success:function(){
                    if(#{hidIsSaved}.getValue()=='True')
                    {
                    #{DetailWindow}.hide(); RefreshMainPage();
                    }
                    else{
                    Ext.Msg.alert('Messg', '订单信息发生改变，请重新操作');
                    }
                    },failure:function(err){Ext.Msg.alert('Error', err);}});" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="btnDalt" runat="server" Text="删除草稿" Icon="Delete">
                <Listeners>
                    <Click Handler="
                    Ext.Msg.confirm('Message', '确定删除？',
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.DeleteDraft({success:function(){
                                       if(#{hidIsSaved}.getValue()=='True')
                    {
                    #{DetailWindow}.hide(); RefreshMainPage();
                    }
                    else{
                    Ext.Msg.alert('Messg', '订单信息发生改变，请重新操作');
                    }}
                                        
                                        ,failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="btnSubmit" runat="server" Text="提交申请" Icon="LorryAdd">
                <Listeners>
                    <Click Handler="ValidateForm();" />
                </Listeners>
            </ext:Button>
        </Buttons>
        <Listeners>
            <BeforeHide Handler="return NeedSave();" />
        </Listeners>
    </ext:Window>