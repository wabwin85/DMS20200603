<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PolargessorpointLog.aspx.cs"
    Inherits="DMS.Website.Pages.Promotion.PolargessorpointLog" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Date.js" type="text/javascript"></script>

    <ext:ScriptContainer ID="ScriptContainer1" runat="server" />
</head>
<body>

    <script type="text/javascript">

        //        Ext.onReady(function() {
        //            LoadStore('_grapecity_cache_ilname', this.IlNameStore);
        //            LoadStore('_grapecity_cache_ilstatus', this.IlStatusStore);
        //            LoadStore('_grapecity_cache_ilclient', this.DealerStore);
        //        });

        //        function SetIlNameStorage() {
        //            SetStore('_grapecity_cache_ilname', this.IlNameStore);
        //        }

        //        function SetIlStatusStorage() {
        //            SetStore('_grapecity_cache_ilstatus', this.IlStatusStore);
        //        }

        //        function SetIlClientStorage() {
        //            SetStore('_grapecity_cache_ilclient', this.DealerStore);
        //        }
        function ComboxSelValue(e) {
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var input = e.query;
                if (input != null && input != '') {
                    // 检索的正则
                    var regExp = new RegExp(".*" + input + ".*");
                    // 执行检索
                    combo.store.filterBy(function (record, id) {
                        // 得到每个record的项目名称值
                        var text = record.get(combo.displayField);
                        return regExp.test(text);
                    });
                } else {
                    combo.store.clearFilter();
                }
                combo.expand();
                return false;
            }
        }
        function cbPromotionTypeChang() {

            var HidLogType = Ext.getCmp('<%=this.HidLogType.ClientID%>');
            var cbPromotionType = Ext.getCmp('<%=this.cbPromotionType.ClientID%>');
            if (HidLogType.getValue() != cbPromotionType.getValue()) {

                Coolite.AjaxMethods.LogTypeSotre_Bindata({
                    success: function () {
                        HidLogType.setValue(cbPromotionType.getValue());
                    },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);

                    }
                })
            }
        }
    </script>

    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <ext:Store ID="LogTypeSotre" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Name" />
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
                        <ext:RecordField Name="ChineseShortName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--  <Listeners>
            <Load Handler="#{cbDealer}.setValue(#{hiddenInitDealerId}.getValue());" />
        </Listeners>--%>
        </ext:Store>
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DmaName" />
                        <ext:RecordField Name="Amount" />
                        <ext:RecordField Name="LogDate" Type="Date" />
                        <ext:RecordField Name="OtherMemo" />
                        <ext:RecordField Name="OrderNo" />
                        <ext:RecordField Name="ProductLineName" />
                        <ext:RecordField Name="DLFrom" />
                        <ext:RecordField Name="Period" />
                        <ext:RecordField Name="Remark" />
                        <ext:RecordField Name="Code" />
                        <ext:RecordField Name="LtyPE" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden runat="server" ID="HidLogType">
        </ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="查询条件" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:ComboBox ID="cbPromotionType" runat="server" EmptyText="选择类型..." Width="150"
                                                            Editable="false" TypeAhead="true" Mode="Local" FieldLabel="类型">
                                                            <SelectedItem Value="Point" Text="积分" />
                                                            <Items>
                                                                <ext:ListItem Value="Point" Text="积分" />
                                                                <ext:ListItem Value="Laregss" Text="赠品" />
                                                            </Items>
                                                            <Listeners>
                                                                <Select Handler="cbPromotionTypeChang();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:ComboBox ID="CbLogType" runat="server" EmptyText="选择类型..." Width="150" Editable="false"
                                                            TypeAhead="true" Mode="Local" FieldLabel="操作类型" StoreID="LogTypeSotre" ValueField="Id"
                                                            DisplayField="Name">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:TextField ID="txtOrderNo" runat="server" Width="150" FieldLabel="订单编号" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="选择产品线" Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" Mode="Local" DisplayField="AttributeName"
                                                            FieldLabel="产品线">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:DateField runat="server" ID="StarData" FieldLabel="变更开始日期" Width="150"></ext:DateField>
                                                    </ext:Anchor>
                                                      <ext:Anchor Horizontal="60%">
                                                        <ext:TextField ID="txtEwfNo" runat="server" Width="150" FieldLabel="EWF审批编号" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="选择经销商..." Width="150" Editable="true"
                                                            TypeAhead="true" StoreID="DealerStore" ValueField="Id" Mode="Local" DisplayField="ChineseShortName"
                                                            FieldLabel="经销商">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <BeforeQuery Fn="ComboxSelValue" />
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="60%">
                                                        <ext:DateField runat="server" ID="EndData" FieldLabel="变更结束日期" Width="150"></ext:DateField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh">
                                    <Listeners>
                                        <Click Handler="#{GridPanel1}.reload();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnExport" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="true" OnClick="ExportExcel">
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="LtyPE" DataIndex="LtyPE" Header="类型" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="Code" DataIndex="Code" Header="经销商编号" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="DmaName" DataIndex="DmaName" Header="经销商名称" Width="250">
                                                </ext:Column>
                                                <ext:Column ColumnID="DLFrom" DataIndex="DLFrom" Header="操作类型" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="产品线" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount" DataIndex="Amount" Header="变更额度" Width="70">
                                                </ext:Column>
                                                <ext:Column ColumnID="LogDate" DataIndex="LogDate" Header="变更日期" Width="150">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>

                                                <ext:Column ColumnID="OrderNo" DataIndex="OrderNo" Header="订单编号" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="Remark" DataIndex="Remark" Header="EWF审批编号" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="OtherMemo" DataIndex="OtherMemo" Header="备注" Width="150">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');

        }


    </script>

</body>
</html>
