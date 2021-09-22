<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PromotionPolicy.aspx.cs"
    Inherits="DMS.Website.Pages.Order.PromotionPolicy" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript">

    </script>

    <style type="text/css">
        .column-color
        {
            background-color: #F0F8FF;
        }
        .column-coloryellow
        {
            background-color: Yellow;
        }
    </style>

    <script type="text/javascript">
        function SelectDealerValue(e) {
            var filterField = 'ChineseName';  //需进行模糊查询的字段
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var value = e.query;
                if (value != null && value != '') {
                    combo.store.filterBy(function(record, id) {
                        var text = record.get(filterField);
                        value = value.replace(/\s/g, '');
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

        var SetCellColor = function(v, m) {
            m.css = "column-color";
            return v;
        }

        var SetCellColor2 = function(v, m) {
            m.css = "column-coloryellow";
            return v;
        }

        var CheckStatus = function() {
            var grid = Ext.getCmp('GridPanel1');
            var record = grid.store.getById(hiddenCurrentEditId.getValue());
            //            m.css = "nonEditable-column";
            //            return v;
            if (record.data.IsApproved != '待批') {
                Ext.Msg.alert('', '已审批的政策不能调整数量');
                return false;

            }

        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Store ID="ResultStore" runat="server" AutoLoad="false" OnRefreshData="ResultStore_RefreshData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Dmaid" />
                        <ext:RecordField Name="Division" />
                        <ext:RecordField Name="ProductLine" />
                        <ext:RecordField Name="PRName" />
                        <ext:RecordField Name="BeginDate" />
                        <ext:RecordField Name="EndDate" />
                        <ext:RecordField Name="ComputeCycle" />
                        <ext:RecordField Name="CreateTime" />
                        <ext:RecordField Name="FreeQty" />
                        <ext:RecordField Name="ClearQty" />
                        <ext:RecordField Name="AdjustQty" />
                        <ext:RecordField Name="AdjustRemark" />
                        <ext:RecordField Name="AvaliableQty" />
                        <ext:RecordField Name="IsApproved" />
                        <ext:RecordField Name="AdjustQtyForT2">
                        </ext:RecordField>
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="AttributeName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Id" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{cmbDealers}.setValue(#{hiddenInitDealerId}.getValue());" />
            </Listeners>
        </ext:Store>
        <ext:Hidden ID="hiddenInitDealerId" runat="server">
        </ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtPromotionCode" runat="server" Width="180" FieldLabel="政策编号">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="dfBeginDate" runat="server" Width="180" FieldLabel="政策开始时间">
                                                        </ext:DateField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cmbApprovalStatus" runat="server" Width="180" FieldLabel="审批状态"
                                                            AllowBlank="true">
                                                            <Items>
                                                                <ext:ListItem Text="待批" Value="Submitted" />
                                                                <ext:ListItem Text="同意" Value="Approved" />
                                                                <ext:ListItem Text="拒绝" Value="Reject" />
                                                            </Items>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="Clear" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtPromotionName" runat="server" Width="180" FieldLabel="政策名称">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="dtPromotionEndate" runat="server" Width="180" FieldLabel="政策结束时间">
                                                        </ext:DateField>
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
                                                        <ext:ComboBox ID="cmbProductLine" runat="server" Width="180" FieldLabel="产品线" AllowBlank="true"
                                                            StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="Clear" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cmbDealers" runat="server" Width="180" FieldLabel="经销商" AllowBlank="true"
                                                            Editable="true" TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName"
                                                            Mode="Local" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="Clear" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <BeforeQuery Fn="SelectDealerValue" />
                                                            </Listeners>
                                                        </ext:ComboBox>
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
                                        <Click Handler="#{PageToolBar2}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnDownload" Text="导出" runat="server" Icon="PageExcel" AutoPostBack="true"
                                    IDMode="Legacy" OnClick="DownloadInfo">
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="Id" DataIndex="Id" Header="Id" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="Dmaid" DataIndex="Dmaid" Header="经销商" Width="210">
                                                    <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Division" DataIndex="Division" Header="部门" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLine" DataIndex="ProductLine" Header="产品线">
                                                </ext:Column>
                                                <ext:Column ColumnID="PRName" DataIndex="PRName" Header="政策名称" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="BeginDate" DataIndex="BeginDate" Header="开始日期">
                                                </ext:Column>
                                                <ext:Column ColumnID="EndDate" DataIndex="EndDate" Header="结束日期">
                                                </ext:Column>
                                                <ext:Column ColumnID="ComputeCycle" DataIndex="ComputeCycle" Header="计算周期">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateTime" DataIndex="CreateTime" Header="计算日期">
                                                </ext:Column>
                                                <ext:Column ColumnID="FreeQty" DataIndex="FreeQty" Header="赠品<br>数量" Align="Right"
                                                    Width="50">
                                                </ext:Column>
                                                <ext:Column ColumnID="ClearQty" DataIndex="ClearQty" Header="订单已<br>用数量" Align="Right"
                                                    Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="AdjustQtyForT2" DataIndex="AdjustQtyForT2" Header="二级调<br>整数量"
                                                    Align="Right" Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="AdjustQty" DataIndex="AdjustQty" Header="调整<br>数量" Align="Right"
                                                    Width="50">
                                                    <Editor>
                                                        <ext:NumberField ID="nfAdjustQty" runat="server" AllowBlank="true" AllowDecimals="true"
                                                            SelectOnFocus="true" AllowNegative="true">
                                                        </ext:NumberField>
                                                    </Editor>
                                                    <Renderer Fn="SetCellColor" />
                                                </ext:Column>
                                                <ext:Column ColumnID="AdjustRemark" DataIndex="AdjustRemark" Header="调整备注">
                                                    <Editor>
                                                        <ext:TextField ID="contxtRemark" runat="server" AllowBlank="true" SelectOnFocus="true"
                                                            AllowNegative="false" MaxLength="300">
                                                        </ext:TextField>
                                                    </Editor>
                                                    <Renderer Fn="SetCellColor" />
                                                </ext:Column>
                                                <ext:Column ColumnID="AvaliableQty" DataIndex="AvaliableQty" Header="可用数量" Align="Right">
                                                    <Renderer Fn="SetCellColor2" />
                                                </ext:Column>
                                                <ext:Column ColumnID="IsApproved" DataIndex="IsApproved" Header="审批状态">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PageToolBar2" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="true" EmptyMsg="没有数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="Load" />
                                        <Listeners>
                                            <ValidateEdit Fn="CheckStatus" />
                                            <AfterEdit Handler="
                                            Coolite.AjaxMethods.SaveItem(#{nfAdjustQty}.getValue(),#{contxtRemark}.getValue(),{success:function(){#{nfAdjustQty}.setValue('');#{contxtRemark}.setValue('');}});" />
                                            <%--将当前编辑行Id保存下来 --%>
                                            <BeforeEdit Handler="#{hiddenCurrentEditId}.setValue(this.getSelectionModel().getSelected().id); 
                                                         
                                                            #{contxtRemark}.setValue(this.getSelectionModel().getSelected().data.AdjustRemark);" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Hidden ID="hiddenCurrentEditId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenAdjustQty" runat="server">
        </ext:Hidden>
    </div>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

    </form>
</body>
</html>
