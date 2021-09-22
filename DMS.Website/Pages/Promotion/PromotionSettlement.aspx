<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PromotionSettlement.aspx.cs" Inherits="DMS.Website.Pages.Promotion.PromotionSettlement" %>


<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/PromotionGiftUpload.ascx" TagName="PromotionGiftUpload"
    TagPrefix="uc" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"> </script>
    <script language="javascript" type="text/javascript">
        var addItems = function (grid) {

            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
                var param = '';

                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.PolicyId + ',';
                }
                Coolite.AjaxMethods.Submint(param);

            } else {
                Ext.MessageBox.alert('错误', '请选择需要结算的政策');
            }
        }

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
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
            <Listeners>
                <Load Handler="" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="PeriodStore" runat="server" OnRefreshData="PeriodStore_RefreshData"
            AutoLoad="true">
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
        <ext:Store ID="CalPeriodStore" runat="server" OnRefreshData="CalPeriodStore_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="AccountMonth">
                    <Fields>
                        <ext:RecordField Name="Period" />
                        <ext:RecordField Name="AccountMonth" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            UseIdConfirmation="false" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="PolicyId">
                    <Fields>
                        <ext:RecordField Name="PolicyId" />
                        <ext:RecordField Name="PolicyNo" />
                        <ext:RecordField Name="PolicyName" />
                        <ext:RecordField Name="PolicyStyle" />
                        <ext:RecordField Name="Period" />
                        <ext:RecordField Name="CalPeriod" />
                        <ext:RecordField Name="ProductLineName" />
                        <ext:RecordField Name="DivisionName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="hidPeriod" runat="server">
        </ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="促销结算查询" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtPolicyNo" runat="server" Width="200" FieldLabel="政策编号" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="选择产品线..." Width="200"
                                                            Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                            Mode="Local" DisplayField="AttributeName" FieldLabel="产品线" Resizable="true">
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
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtPolicyName" runat="server" Width="200" FieldLabel="政策名称" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbPeriod" runat="server" EmptyText="选择结算周期..." Width="200" Editable="false"
                                                            TypeAhead="true" StoreID="PeriodStore" ValueField="Key" Mode="Local" DisplayField="Value"
                                                            FieldLabel="结算周期" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue(); #{hidPeriod}.setValue(''); #{cbCalPeriod}.setValue(''); #{CalPeriodStore}.reload();" />
                                                                <Select Handler=" #{hidPeriod}.setValue(#{cbPeriod}.getValue()); #{cbCalPeriod}.setValue(''); #{CalPeriodStore}.reload(); " />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProType" runat="server" EmptyText="请选择促销类型..." Width="200" Editable="false"
                                                            TypeAhead="true" Mode="Local" FieldLabel="促销类型" Resizable="true">
                                                            <Items>
                                                                <ext:ListItem Text="赠品" Value="赠品" />
                                                                <ext:ListItem Text="积分" Value="积分" />
                                                                <%-- <ext:ListItem Text="即买即赠" Value="即时买赠" />--%>
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
                                                        <ext:ComboBox ID="cbCalPeriod" runat="server" EmptyText="选择账期..." Width="200" Editable="false"
                                                            TypeAhead="true" StoreID="CalPeriodStore" ValueField="AccountMonth" Mode="Local"
                                                            DisplayField="AccountMonth" FieldLabel="账期" Resizable="true">
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
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="PolicyId" DataIndex="PolicyId" Header="政策主键" Width="100" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="PolicyNo " DataIndex="PolicyNo" Header="政策编号" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="PolicyName" Width="250" DataIndex="PolicyName" Header="政策名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineName" Width="150" DataIndex="ProductLineName" Header="产品线">
                                                </ext:Column>
                                                <ext:Column ColumnID="PolicyStyle" Width="150" DataIndex="PolicyStyle" Header="促销类型">
                                                </ext:Column>
                                                <ext:Column ColumnID="Period" Width="100" DataIndex="Period" Header="结算周期">
                                                </ext:Column>
                                                <ext:Column ColumnID="CalPeriod" Width="100" DataIndex="CalPeriod" Header="结算账期">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                                <Listeners>
                                                </Listeners>
                                            </ext:CheckboxSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="ResultStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnTick" runat="server" Text="结账" Icon="Tick">
                                    <Listeners>
                                        <Click Handler="addItems(#{GridPanel1});" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
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
