<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AOPEditorAdmin.ascx.cs" Inherits="DMS.Website.Controls.AOPEditorAdmin" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<script type="text/javascript">
    var CheckHospitalNull = function () {
        var amount1 = Ext.getCmp('<%=this.nfAmount1.ClientID%>').getValue();
            var amount2 = Ext.getCmp('<%=this.nfAmount2.ClientID%>').getValue();
            var amount3 = Ext.getCmp('<%=this.nfAmount3.ClientID%>').getValue();
            var amount4 = Ext.getCmp('<%=this.nfAmount4.ClientID%>').getValue();
            var amount5 = Ext.getCmp('<%=this.nfAmount5.ClientID%>').getValue();
            var amount6 = Ext.getCmp('<%=this.nfAmount6.ClientID%>').getValue();
            var amount7 = Ext.getCmp('<%=this.nfAmount7.ClientID%>').getValue();
            var amount8 = Ext.getCmp('<%=this.nfAmount8.ClientID%>').getValue();
            var amount9 = Ext.getCmp('<%=this.nfAmount9.ClientID%>').getValue();
            var amount10 = Ext.getCmp('<%=this.nfAmount10.ClientID%>').getValue();
            var amount11 = Ext.getCmp('<%=this.nfAmount11.ClientID%>').getValue();
            var amount12 = Ext.getCmp('<%=this.nfAmount12.ClientID%>').getValue();
            if (amount1 == "" || amount2 == "" || amount3 == "" || amount4 == "" || amount5 == "" || amount6 == ""
                || amount7 == "" || amount8 == "" || amount9 == "" || amount10 == "" || amount11 == "" || amount12 == "") {
                alert('请完整填写医院指标信息');
                return false;
            }
            return true;
        }
        var CheckDealerNull = function () {
            var amount1 = Ext.getCmp('<%=this.NumberField1.ClientID%>').getValue();
           var amount2 = Ext.getCmp('<%=this.NumberField2.ClientID%>').getValue();
           var amount3 = Ext.getCmp('<%=this.NumberField3.ClientID%>').getValue();
           var amount4 = Ext.getCmp('<%=this.NumberField4.ClientID%>').getValue();
           var amount5 = Ext.getCmp('<%=this.NumberField5.ClientID%>').getValue();
           var amount6 = Ext.getCmp('<%=this.NumberField6.ClientID%>').getValue();
           var amount7 = Ext.getCmp('<%=this.NumberField7.ClientID%>').getValue();
           var amount8 = Ext.getCmp('<%=this.NumberField8.ClientID%>').getValue();
           var amount9 = Ext.getCmp('<%=this.NumberField9.ClientID%>').getValue();
           var amount10 = Ext.getCmp('<%=this.NumberField10.ClientID%>').getValue();
           var amount11 = Ext.getCmp('<%=this.NumberField11.ClientID%>').getValue();
           var amount12 = Ext.getCmp('<%=this.NumberField12.ClientID%>').getValue();
           if (amount1 == "" || amount2 == "" || amount3 == "" || amount4 == "" || amount5 == "" || amount6 == ""
               || amount7 == "" || amount8 == "" || amount9 == "" || amount10 == "" || amount11 == "" || amount12 == "") {
               alert('请完整填写商业采购指标信息');
               return false;
           }
           return true;
        }
     var afterSaveHospitalAOPDetails = function () {
        Ext.Msg.alert('提示', '保存成功');
        Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
    }
    var afterSaveDealerAOPDetails = function () {
        Ext.Msg.alert('提示', '保存成功');
        Ext.getCmp('<%=this.GridDealerAop.ClientID%>').reload();
    }

</script>
<ext:Store ID="HospitalAOPStore" runat="server" UseIdConfirmation="false" OnRefreshData="HospitalAOPStore_RefershData" AutoLoad="false">
    <AutoLoadParams>
        <ext:Parameter Name="start" Value="={0}" />
        <ext:Parameter Name="limit" Value="={15}" />
    </AutoLoadParams>
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="DealerId" />
                <ext:RecordField Name="HospitalId" />
                <ext:RecordField Name="CQId" />
                <ext:RecordField Name="CQName" />
                <ext:RecordField Name="HospitalName" />
                <ext:RecordField Name="Year" />
                <ext:RecordField Name="Q1" />
                <ext:RecordField Name="Q2" />
                <ext:RecordField Name="Q3" />
                <ext:RecordField Name="Q4" />
                <ext:RecordField Name="Amount_1" />
                <ext:RecordField Name="Amount_2" />
                <ext:RecordField Name="Amount_3" />
                <ext:RecordField Name="Amount_4" />
                <ext:RecordField Name="Amount_5" />
                <ext:RecordField Name="Amount_6" />
                <ext:RecordField Name="Amount_7" />
                <ext:RecordField Name="Amount_8" />
                <ext:RecordField Name="Amount_9" />
                <ext:RecordField Name="Amount_10" />
                <ext:RecordField Name="Amount_11" />
                <ext:RecordField Name="Amount_12" />
                <ext:RecordField Name="Amount_Y" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="DealerAOPStore" runat="server" UseIdConfirmation="false" OnRefreshData="DealerAOPStore_RefershData" AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="CCId" />
                <ext:RecordField Name="CCName" />
                <ext:RecordField Name="DealerId" />
                <ext:RecordField Name="Year" />
                <ext:RecordField Name="Q1" />
                <ext:RecordField Name="Q2" />
                <ext:RecordField Name="Q3" />
                <ext:RecordField Name="Q4" />
                <ext:RecordField Name="Amount_1" />
                <ext:RecordField Name="Amount_2" />
                <ext:RecordField Name="Amount_3" />
                <ext:RecordField Name="Amount_4" />
                <ext:RecordField Name="Amount_5" />
                <ext:RecordField Name="Amount_6" />
                <ext:RecordField Name="Amount_7" />
                <ext:RecordField Name="Amount_8" />
                <ext:RecordField Name="Amount_9" />
                <ext:RecordField Name="Amount_10" />
                <ext:RecordField Name="Amount_11" />
                <ext:RecordField Name="Amount_12" />
                <ext:RecordField Name="Amount_Y" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Hidden ID="hiddenContractId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenTempId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidContractType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidSubBU" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidBeginDate" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDealer" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenProductLine" runat="server">
</ext:Hidden>

<ext:Window ID="AOPWindow" runat="server" Icon="Group" Title="调整指标" AutoShow="false" ShowOnLoad="false" Resizable="false" Draggable="false" Height="550" Width="900" AutoScroll="true"
    Modal="true" BodyStyle="padding:5px;">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North Collapsible="True" Split="True">
                <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                    Icon="Find">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                            <ext:LayoutColumn ColumnWidth=".3">
                                <ext:Panel ID="Panel3" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:NumberField ID="nfYear" runat="server" FieldLabel="指标年份"></ext:NumberField>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".3">
                                <ext:Panel ID="Panel2" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server">
                                            <ext:Anchor>
                                                <ext:TextField ID="tfHospitalName" runat="server" FieldLabel="医院名称" Width="150" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".4">
                                <ext:Panel ID="Panel1" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout1" runat="server">
                                            <ext:Anchor>
                                                <ext:TextField ID="tfProductName" runat="server" FieldLabel="产品分类名称" Width="150" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                            <Listeners>
                                <Click Handler="#{PagingToolBar1}.doLoad(0);" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="Button1" runat="server" Text="关闭" Icon="Disk" CommandArgument=""
                            CommandName="" IDMode="Legacy">
                            <Listeners>
                                <Click Handler="#{AOPWindow}.hide(null);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel runat="server" Title="医院指标" Icon="Lorry" ID="plHospitalAop" Border="false" Height="220"
                    IDMode="Legacy">
                    <Body>
                        <ext:FitLayout ID="FitLayout1" runat="server">
                            <ext:GridPanel ID="GridPanel1" runat="server" Header="false" StoreID="HospitalAOPStore" Border="false"
                                Icon="Lorry" AutoExpandColumn="DealerId" AutoExpandMax="250" AutoExpandMin="150"
                                StripeRows="true">
                                <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>
                                        <ext:CommandColumn ColumnID="Details" Header="修改" Align="Center" Width="60">
                                            <Commands>
                                                <ext:GridCommand Icon="VcardEdit" CommandName="Modify" ToolTip-Text="修改">
                                                </ext:GridCommand>
                                            </Commands>
                                        </ext:CommandColumn>
                                        <ext:Column ColumnID="DealerId" DataIndex="DealerId" Header="" Width="60" Hidden="true">
                                        </ext:Column>
                                        <ext:Column ColumnID="CQName" DataIndex="CQName" Header="产品分类" Width="60">
                                        </ext:Column>
                                           <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="医院名称" Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="Year" DataIndex="Year" Header="年份" Width="60">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="合计" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Q1" DataIndex="Q1" Header="Q1" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Q2" DataIndex="Q2" Header="Q2" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Q3" DataIndex="Q3" Header="Q3" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Q4" DataIndex="Q4" Header="Q4" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_1" DataIndex="Amount_1" Header="1月" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_2" DataIndex="Amount_2" Header="2月" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_3" DataIndex="Amount_3" Header="3月" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_4" DataIndex="Amount_4" Header="4月" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_5" DataIndex="Amount_5" Header="5月" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_6" DataIndex="Amount_6" Header="6月" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_7" DataIndex="Amount_7" Header="7月" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_8" DataIndex="Amount_8" Header="8月" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_9" DataIndex="Amount_9" Header="9月" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_10" DataIndex="Amount_10" Header="10月" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_11" DataIndex="Amount_11" Header="11月" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_12" DataIndex="Amount_12" Header="12月" Width="90">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="HospitalAOPStore"
                                        DisplayInfo="true" EmptyMsg="无数据…" />
                                </BottomBar>
                                <LoadMask ShowMask="true" Msg="正在加载……" />
                                <AjaxEvents>
                                    <Command OnEvent="EditAop_Click">
                                        <ExtraParams>
                                            <ext:Parameter Name="editData" Value="Ext.encode(#{GridPanel1}.getRowsValues())"
                                                Mode="Raw">
                                            </ext:Parameter>
                                        </ExtraParams>
                                    </Command>
                                </AjaxEvents>
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </Center>
            <South Collapsible="True" MarginsSummary="0 5 0 5">
                <ext:Panel runat="server" ID="PanelDealerAop" Border="false" Frame="true" Title="销商商业采购指标"
                    Icon="HouseKey" Height="180" ButtonAlign="Left">
                    <Body>
                        <ext:FitLayout ID="FitLayout7" runat="server">
                            <ext:GridPanel ID="GridDealerAop" runat="server" Header="false" StoreID="DealerAOPStore"
                                Border="false" Icon="Lorry" AutoExpandColumn="DealerId" AutoExpandMax="250"
                                AutoExpandMin="150" StripeRows="true">
                                <ColumnModel ID="ColumnModel5" runat="server">
                                    <Columns>
                                        <ext:CommandColumn ColumnID="Details" Header="修改" Width="50" Align="Center">
                                            <Commands>
                                                <ext:GridCommand Icon="VcardEdit" CommandName="Modify">
                                                </ext:GridCommand>
                                            </Commands>
                                        </ext:CommandColumn>
                                        <ext:Column ColumnID="DealerId" DataIndex="DealerId" Header="" Width="60" Hidden="true">
                                        </ext:Column>
                                        <ext:Column ColumnID="CCName" DataIndex="CCName" Header="产品分类" Width="60">
                                        </ext:Column>
                                        <ext:Column ColumnID="Year" DataIndex="Year" Header="年份" Width="90"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="合计" Width="90">
                                        </ext:Column>
                                        <ext:Column ColumnID="Q1" DataIndex="Q1" Header="Q1" Width="70" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Q2" DataIndex="Q2" Header="Q2" Width="70" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Q3" DataIndex="Q3" Header="Q3" Width="70" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Q4" DataIndex="Q4" Header="Q4" Width="70" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_1" DataIndex="Amount_1" Header="一月" Width="65"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_2" DataIndex="Amount_2" Header="二月" Width="65"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_3" DataIndex="Amount_3" Header="三月" Width="65"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_4" DataIndex="Amount_4" Header="四月" Width="65"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_5" DataIndex="Amount_5" Header="五月" Width="65"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_6" DataIndex="Amount_6" Header="六月" Width="65"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_7" DataIndex="Amount_7" Header="七月" Width="65"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_8" DataIndex="Amount_8" Header="八月" Width="65"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_9" DataIndex="Amount_9" Header="九月" Width="65"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_10" DataIndex="Amount_10" Header="十月" Width="65"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_11" DataIndex="Amount_11" Header="十一月" Align="Center"
                                            Width="65">
                                        </ext:Column>
                                        <ext:Column ColumnID="Amount_12" DataIndex="Amount_12" Header="十二月" Align="Center"
                                            Width="65">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel5" runat="server" SingleSelect="true" />
                                </SelectionModel>
                                <LoadMask ShowMask="true" Msg="处理中..." />
                                <AjaxEvents>
                                    <Command OnEvent="EditDealerAop_Click">
                                        <ExtraParams>
                                            <ext:Parameter Name="editData" Value="Ext.encode(#{GridDealerAop}.getRowsValues())"
                                                Mode="Raw">
                                            </ext:Parameter>
                                        </ExtraParams>
                                    </Command>
                                </AjaxEvents>
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </South>
        </ext:BorderLayout>
    </Body>
</ext:Window>
<ext:Hidden ID="hidAopid" runat="server"></ext:Hidden>
<ext:Window ID="EditHospitalDepWindow" runat="server" Icon="Group" Title="指标调整"
    Width="520" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false" Maximizable="true">
    <Body>
        <ext:Panel ID="Details" runat="server" Frame="true" Header="false">
            <Body>
                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="150">
                    <ext:Anchor Horizontal="100%">
                        <ext:Label runat="server" ID="txtYear" FieldLabel="年份">
                        </ext:Label>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:Label runat="server" ID="txtAopProductName" FieldLabel="产品分类">
                        </ext:Label>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:Label runat="server" ID="txtAopHospitalName" FieldLabel="医院名称">
                        </ext:Label>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount1" runat="server" FieldLabel="1月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount2" runat="server" FieldLabel="2月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount3" runat="server" FieldLabel="3月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount4" runat="server" FieldLabel="4月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount5" runat="server" FieldLabel="5月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount6" runat="server" FieldLabel="6月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount7" runat="server" FieldLabel="7月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount8" runat="server" FieldLabel="8月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount9" runat="server" FieldLabel="9月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount10" runat="server" FieldLabel="10月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount11" runat="server" FieldLabel="11月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="nfAmount12" runat="server" FieldLabel="12月"></ext:NumberField>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Buttons>
               <%-- <ext:Button ID="SaveButton" runat="server" Text="提交" Icon="Disk">
                    <Listeners>
                        <Click Handler="saveHospitalAop()" />
                    </Listeners>
                </ext:Button>--%>
                 <ext:Button ID="Button2" runat="server" Text="提交" Icon="Disk">
                    <AjaxEvents>
                        <Click OnEvent="SaveHospitalAOP_Click" Success="afterSaveHospitalAOPDetails();" Before="return CheckHospitalNull();">
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="CancelButton" runat="server" Text="关闭窗口" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{EditHospitalDepWindow}.hide(null);#{GridPanel1}.reload();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Panel>
    </Body>

</ext:Window>
<ext:Hidden ID="hidDealerAopId" runat="server"></ext:Hidden>
<ext:Window ID="EditDealerWindow" runat="server" Icon="Group" Title="指标调整"
    Width="520" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false" Maximizable="true">
    <Body>
        <ext:Panel ID="Panel4" runat="server" Frame="true" Header="false">
            <Body>
                <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="150">
                    <ext:Anchor Horizontal="100%">
                        <ext:Label runat="server" ID="lbDealerYear" FieldLabel="年份">
                        </ext:Label>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:Label runat="server" ID="lbCcName" FieldLabel="产品分类">
                        </ext:Label>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField1" runat="server" FieldLabel="1月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField2" runat="server" FieldLabel="2月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField3" runat="server" FieldLabel="3月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField4" runat="server" FieldLabel="4月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField5" runat="server" FieldLabel="5月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField6" runat="server" FieldLabel="6月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField7" runat="server" FieldLabel="7月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField8" runat="server" FieldLabel="8月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField9" runat="server" FieldLabel="9月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField10" runat="server" FieldLabel="10月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField11" runat="server" FieldLabel="11月"></ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="NumberField12" runat="server" FieldLabel="12月"></ext:NumberField>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Buttons>
                <%-- <ext:Button ID="Button2" runat="server" Text="提交" Icon="Disk">
                    <Listeners>
                        <Click Handler="saveDealerAop()" />
                    </Listeners>
                </ext:Button>--%>
                <ext:Button ID="SaveUnitButton" runat="server" Text="提交" Icon="Disk">
                    <AjaxEvents>
                        <Click OnEvent="SaveDealerAOP_Click" Success="afterSaveDealerAOPDetails();" Before="return CheckDealerNull();">
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="Button3" runat="server" Text="关闭窗口" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{EditDealerWindow}.hide(null);#{GridDealerAop}.reload();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Panel>
    </Body>

</ext:Window>
