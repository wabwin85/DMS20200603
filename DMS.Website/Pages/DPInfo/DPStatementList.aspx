<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DPStatementList.aspx.cs"
    Inherits="DMS.Website.Pages.DPInfo.DPStatementList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">

        function SelectValue(e) {
            var filterField = 'ChineseName';  //需进行模糊查询的字段
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var value = e.query;
                if (value != null && value != '') {
                    combo.store.filterBy(function(record, id) {
                        var text = record.get(filterField);
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
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <ext:Store ID="YearStore" runat="server" UseIdConfirmation="true" OnRefreshData="YearStore_RefreshData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Year">
                <Fields>
                    <ext:RecordField Name="Year" />
                </Fields>
            </ext:JsonReader>
        </Reader>
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
                    <ext:RecordField Name="DealerId" />
                    <ext:RecordField Name="DealerName" />
                    <ext:RecordField Name="YearMonth" />
                    <ext:RecordField Name="Status" />
                    <ext:RecordField Name="CreateUser" />
                    <ext:RecordField Name="CreateDate" Type="Date" />
                    <ext:RecordField Name="UpdateUser" />
                    <ext:RecordField Name="UpdateDate" Type="Date" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="查询条件" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbYear" runat="server" EmptyText="请选择年份" Width="150" Editable="false"
                                                        FieldLabel="年份" StoreID="YearStore" DisplayField="Year" ValueField="Year">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbMonth" runat="server" EmptyText="请选择月份" Width="150" Editable="false"
                                                        TypeAhead="true" FieldLabel="月份">
                                                        <Items>
                                                            <ext:ListItem Text="01" Value="01" />
                                                            <ext:ListItem Text="02" Value="02" />
                                                            <ext:ListItem Text="03" Value="03" />
                                                            <ext:ListItem Text="04" Value="04" />
                                                            <ext:ListItem Text="05" Value="05" />
                                                            <ext:ListItem Text="06" Value="06" />
                                                            <ext:ListItem Text="07" Value="07" />
                                                            <ext:ListItem Text="08" Value="08" />
                                                            <ext:ListItem Text="09" Value="09" />
                                                            <ext:ListItem Text="10" Value="10" />
                                                            <ext:ListItem Text="11" Value="11" />
                                                            <ext:ListItem Text="12" Value="12" />
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
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择经销商" Width="220" Editable="true"
                                                        Mode="Local" TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName"
                                                        FieldLabel="经销商" ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                            <BeforeQuery Fn="SelectValue" />
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
                                                    <ext:ComboBox ID="cbStatus" runat="server" EmptyText="请选择状态" Width="150" Editable="false"
                                                        TypeAhead="true" FieldLabel="状态">
                                                        <Items>
                                                            <ext:ListItem Text="已提交" Value="已提交" />
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
                            <ext:Button ID="btnInsert" runat="server" Text="新增" Icon="Add" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="top.createTab('DP_Statement_' + '00000000-0000-0000-0000-000000000000', '经销商财务风险评估 - 新建', '/Pages/DPInfo/DPStatementInfo.aspx?id=00000000-0000-0000-0000-000000000000');" />
                                </Listeners>
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
                                            <ext:Column ColumnID="YearMonth" DataIndex="YearMonth" Header="年月" Width="80">
                                            </ext:Column>
                                            <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="200">
                                            </ext:Column>
                                            <ext:Column ColumnID="Status" DataIndex="Status" Header="状态" Width="80">
                                            </ext:Column>
                                            <ext:Column ColumnID="CreateUser" DataIndex="CreateUser" Header="创建人" Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="创建时间" Width="150">
                                                <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                            </ext:Column>
                                            <ext:Column ColumnID="UpdateUser" DataIndex="UpdateUser" Header="更新人" Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="UpdateDate" DataIndex="UpdateDate" Header="更新时间" Width="150">
                                                <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                            </ext:Column>
                                            <ext:CommandColumn Width="60" Header="明细">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="明细" />
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
                                        <Command Handler="top.createTab('DP_Statement_' + Ext.getCmp('GridPanel1').getSelectionModel().getSelected().id.toString(), '经销商财务风险评估 - ' + Ext.getCmp('GridPanel1').getSelectionModel().getSelected().data.DealerName + Ext.getCmp('GridPanel1').getSelectionModel().getSelected().data.YearMonth, '/Pages/DPInfo/DPStatementInfo.aspx?id='+Ext.getCmp('GridPanel1').getSelectionModel().getSelected().id.toString());" />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                            DisplayInfo="false" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" Msg="Loading..." />
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
