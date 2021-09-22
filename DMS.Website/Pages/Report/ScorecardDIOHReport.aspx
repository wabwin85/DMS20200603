<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ScorecardDIOHReport.aspx.cs" Inherits="DMS.Website.Pages.Report.ScorecardDIOHReport" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"> </script>

</head>
<body>
    <form id="form1" runat="server">
       <ext:ScriptManager ID="ScriptManager1" runat="server" />

        <script type="text/javascript" language="javascript">
        
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
        </script>
         

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

        <ext:Store ID="SubBUStore" runat="server" UseIdConfirmation="true" OnRefreshData="SubBUStore_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="SubBUCode">
                    <Fields>
                        <ext:RecordField Name="SubBUCode" />
                        <ext:RecordField Name="SubBUName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="SubBUCode" Direction="ASC" />
        </ext:Store>

        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="ChineseShortName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{cbDealer}.setValue(#{hidInitDealerId}.getValue());" />
            </Listeners>
        </ext:Store>

        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            UseIdConfirmation="false" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        
                        <ext:RecordField Name="Division" />
                        <ext:RecordField Name="SubBUCode" />
                        <ext:RecordField Name="SubBU" />
                        <ext:RecordField Name="SAPID" />
                        <ext:RecordField Name="DealerName" />
                         <ext:RecordField Name="DIOH" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="hidInitDealerId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidProductLine" runat="server">
        </ext:Hidden>

        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="一二级商业采购明细查询" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择经销商……"
                                                            Width="200" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                                            DisplayField="ChineseShortName" Mode="Local" FieldLabel="经销商"
                                                            ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <BeforeQuery Fn="ComboxSelValue" />
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
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="选择产品线..." Width="200"
                                                            Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                            Mode="Local" DisplayField="AttributeName" FieldLabel="产品线" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();#{cbSubBu}.clearValue();#{SubBUStore}.reload();" />
                                                                <Select Handler=" #{SubBUStore}.reload();#{cbSubBu}.clearValue(); " />
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
                                                        <ext:ComboBox ID="cbSubBu" runat="server" EmptyText="选择分产线." Width="200" Editable="false"
                                                            TypeAhead="true" StoreID="SubBUStore" ValueField="SubBUCode" Mode="Local"
                                                            DisplayField="SubBUName" FieldLabel="产品分类" Resizable="true">
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
                                <ext:Button ID="btnSubmit" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="true" OnClick="ExportExcel">
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
                                                  <ext:Column ColumnID="SAPID" Width="70" DataIndex="SAPID" Header="经销商编号">
                                                </ext:Column>
                                                 <ext:Column ColumnID="DealerName" Width="200" DataIndex="DealerName" Header="经销商名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="Division" Width="150" DataIndex="Division" Header="产品名称">
                                                </ext:Column>                                          
                                                <ext:Column ColumnID="SubBUCode" Width="150" DataIndex="SubBUCode" Header="产品分类代码">
                                                </ext:Column>
                                                <ext:Column ColumnID="SubBU" Width="120" DataIndex="SubBU" Header="产品分类名称">
                                                </ext:Column>
                                              
                                                <ext:Column ColumnID="DIOH" Width="100" DataIndex="DIOH" Header="DIOH">
                                                </ext:Column>                                              
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
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
