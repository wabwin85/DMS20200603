<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InterfaceLogList.aspx.cs"
    Inherits="DMS.Website.Pages.DataInterface.InterfaceLogList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Date.js" type="text/javascript"></script>

    <ext:ScriptContainer ID="ScriptContainer1" runat="server" />

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
                    combo.store.filterBy(function(record, id) {
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

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <ext:Store ID="IlNameStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshDataInterfaceType"
        AutoLoad="true">
        <BaseParams>
            <ext:Parameter Name="Type" Value="CONST_DataInterfaceType" Mode="Value">
            </ext:Parameter>
        </BaseParams>
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
    <ext:Store ID="IlStatusStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshDictionary"
        AutoLoad="true">
        <BaseParams>
            <ext:Parameter Name="Type" Value="CONST_MakeOrder_Status" Mode="Value">
            </ext:Parameter>
        </BaseParams>
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
       
        <SortInfo Field="Key" Direction="ASC" />
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
                    <ext:RecordField Name="IL_Name" />
                    <ext:RecordField Name="IL_StartTime" />
                    <ext:RecordField Name="IL_EndTime" />
                    <ext:RecordField Name="IL_Status" />
                    <ext:RecordField Name="DMA_ChineseName" />
                    <ext:RecordField Name="IL_BatchNbr" />
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
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor Horizontal="85%">
                                                    <ext:ComboBox ID="cbIlName" runat="server" EmptyText="选择接口名称..." Width="150" Editable="false"
                                                        TypeAhead="true" StoreID="IlNameStore" ValueField="Key" Mode="Local" DisplayField="Value"
                                                        FieldLabel="接口名称">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="85%">
                                                    <ext:DateField ID="txtStartDate"   runat="server" Width="150" FieldLabel="开始日期" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor Horizontal="85%">
                                                    <ext:ComboBox ID="cbIlStatus" runat="server" EmptyText="选择接口状态..." Width="150" Editable="false"
                                                        TypeAhead="true" StoreID="IlStatusStore" ValueField="Key" Mode="Local" DisplayField="Value"
                                                        FieldLabel="接口状态">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="85%">
                                                    <ext:DateField ID="txtEndDate" runat="server" Width="150" FieldLabel="结束日期" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor Horizontal="100%">
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="选择平台商..." Width="150" Editable="true"
                                                        TypeAhead="true" StoreID="DealerStore" ValueField="Id" Mode="Local"
                                                        DisplayField="ChineseShortName" FieldLabel="平台商">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                        </Triggers>
                                                        <Listeners>
                                                           <BeforeQuery Fn="ComboxSelValue" />
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="100%">
                                                    <ext:TextField ID="txtIlBatchNbr" runat="server" Width="150" FieldLabel="批处理号" />
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="100%">
                                                    <ext:Panel ID="Panel9" runat="server">
                                                        <Buttons>
                                                            <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh">
                                                                <Listeners>
                                                                    <Click Handler="#{GridPanel1}.reload();" />
                                                                </Listeners>
                                                            </ext:Button>
                                                        </Buttons>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
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
                                            <ext:Column ColumnID="IL_Name" DataIndex="IL_Name" Header="接口名称" Width="150">
                                                <Renderer Handler="return getNameFromStoreById(IlNameStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="IL_StartTime" DataIndex="IL_StartTime" Header="开始时间" Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="IL_EndTime" DataIndex="IL_EndTime" Header="结束时间" Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="IL_Status" DataIndex="IL_Status" Header="接口状态" Width="150">
                                                <Renderer Handler="return getNameFromStoreById(IlStatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="DMA_ChineseName" DataIndex="DMA_ChineseName" Header="平台商" Width="300">
                                            </ext:Column>
                                            <ext:Column ColumnID="IL_BatchNbr" DataIndex="IL_BatchNbr" Header="批处理号" Width="200">
                                            </ext:Column>
                                            <ext:CommandColumn Width="60" Header="明细" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="进入明细" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <AjaxEvents>
                                        <Command OnEvent="ShowDetails" Failure="Ext.MessageBox.alert('Load failed', 'Error during ajax event!');"
                                            Success="">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                            <ExtraParams>
                                                <ext:Parameter Name="IL_ID" Value="#{GridPanel1}.getSelectionModel().getSelected().id"
                                                    Mode="Raw">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Command>
                                    </AjaxEvents>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                            DisplayInfo="false" />
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
    <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="日志明细" Width="980"
        Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false">
        <Body>
            <ext:BorderLayout ID="BorderLayout2" runat="server">
                <Center MarginsSummary="5 5 5 5">
                    <ext:Panel ID="Panel10" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:Panel ID="Panel6" runat="server">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".33">
                                            <ext:Panel ID="Panel11" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor Horizontal="90%">
                                                            <ext:TextField ID="infoIlName" runat="server" Width="200" FieldLabel="接口名称" ReadOnly="true" />
                                                        </ext:Anchor>
                                                        <ext:Anchor Horizontal="90%">
                                                            <ext:TextField ID="infoIlStatus" runat="server" Width="200" FieldLabel="接口状态" ReadOnly="true" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".33">
                                            <ext:Panel ID="Panel12" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor Horizontal="90%">
                                                            <ext:TextField ID="infoIlStartTime" runat="server" FieldLabel="开始时间" ReadOnly="true" />
                                                        </ext:Anchor>
                                                        <ext:Anchor Horizontal="90%">
                                                            <ext:TextField ID="infoIlDealerName" runat="server" FieldLabel="平台商" ReadOnly="true" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".33">
                                            <ext:Panel ID="Panel13" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor Horizontal="90%">
                                                            <ext:TextField ID="infoIlEndTime" runat="server" FieldLabel="结束时间" ReadOnly="true" />
                                                        </ext:Anchor>
                                                        <ext:Anchor Horizontal="90%">
                                                            <ext:TextField ID="infoIlBatchNbr" runat="server" FieldLabel="批处理号" ReadOnly="true" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                            </ext:Panel>
                            <ext:Panel ID="Panel7" runat="server">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                        <ext:LayoutColumn ColumnWidth="1">
                                            <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor Horizontal="96.5%">
                                                            <ext:TextArea ID="infoIlMessage" runat="server" Width="200" FieldLabel="日志内容" Height="330"
                                                                ReadOnly="true" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                            </ext:Panel>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
        <Listeners>
            <Hide Handler="#{infoIlMessage}.setValue('');" />
        </Listeners>
        <Buttons>
            <ext:Button ID="CloseButton" runat="server" Text="关闭" Icon="Cancel" OnClientClick="return false;">
                <Listeners>
                    <Click Handler="#{DetailWindow}.hide();" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
    </form>
      <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');

        }
   
        
    </script>
</body>
</html>
