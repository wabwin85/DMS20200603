<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GiftMaintainList.aspx.cs"
    Inherits="DMS.Website.Pages.Promotion.GiftMaintainList" %>

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
    
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />

    <script type="text/javascript" language="javascript">
     var PrintRender = function () {
            return '<img class="imgPrint" ext:qtip="查看" style="cursor:pointer;" src="../../resources/images/icons/page.png" />';
        }
    function ValidateForm() {
        var errMsg = "";
        var isForm1Valid = <%=FormPanelHard.ClientID%>.getForm().isValid();
      
        if (!isForm1Valid) {
            errMsg = "导出信息填写不完整" ;
        }
        if (errMsg != "") {
            Ext.Msg.alert('Message', errMsg);
            return false;
        } else {
           return true;
        }
    
    }  
    function RefreshPages() {
        Ext.getCmp('<%=this.GridPanel1.ClientID%>').store.reload();
    }
    
     var cellViewClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
            var id = record.data['FlowId'];
            if (t.className == 'imgPrint' && columnId == 'Print') {
                window.open("GiftMaintainView.aspx?FlowId=" + id);
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
            <ext:JsonReader ReaderID="FlowId">
                <Fields>
                    <ext:RecordField Name="FlowId" />
                    <ext:RecordField Name="Description" />
                    <ext:RecordField Name="Bu" />
                    <ext:RecordField Name="Period" />
                    <ext:RecordField Name="AccountMonth" />
                    <ext:RecordField Name="Status" />
                    <ext:RecordField Name="CreateBy" />
                    <ext:RecordField Name="CreateTime" />
                    <ext:RecordField Name="FlowType" />
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
                    <ext:Panel ID="Panel1" runat="server" Title="促销赠品管理查询" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
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
                            <ext:Button ID="btnExport" runat="server" Text="下载计算结果" Icon="ApplicationGet" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="#{DetailDownLoadWindow}.show();" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="Button1" runat="server" Text="发起审批流程" Icon="ApplicationAdd" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="Coolite.AjaxMethods.PromotionGiftUpload.Show({success:function(){PageClear();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
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
                                            <ext:Column ColumnID="FlowId" DataIndex="FlowId" Header="结算流程编号" Width="100" Hidden="true">
                                            </ext:Column>
                                            <ext:Column ColumnID="Description " DataIndex="Description" Header="流程描述" Width="250">
                                            </ext:Column>
                                            <ext:Column ColumnID="Bu" Width="150" DataIndex="Bu" Header="产品线">
                                            </ext:Column>
                                            <ext:Column ColumnID="AccountMonth" Width="150" DataIndex="AccountMonth" Header="账期">
                                            </ext:Column>
                                            <ext:Column ColumnID="Status" Width="100" DataIndex="Status" Header="状态">
                                            </ext:Column>
                                            <ext:Column ColumnID="FlowType" Width="100" DataIndex="FlowType" Header="类型">
                                            </ext:Column>
                                            <ext:Column ColumnID="CreateTime" Width="100" DataIndex="CreateTime" Header="提交时间">
                                            </ext:Column>
                                             <ext:Column ColumnID="Print" DataIndex="FlowId" Header="查看" Align="Center" Width="60">
                                                <Renderer Fn="PrintRender" />
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                       <CellClick Fn="cellViewClick" />
                                    </Listeners>
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
    <uc:PromotionGiftUpload ID="PromotionGiftUpload1" runat="server"></uc:PromotionGiftUpload>
    <ext:Store ID="wdCalPeriodStore" runat="server" OnRefreshData="wdCalPeriodStore_RefreshData"
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
    <ext:Hidden ID="hidWdPeriod" runat="server">
    </ext:Hidden>
    <ext:Window ID="DetailDownLoadWindow" runat="server" Icon="Group" Title="下载计算结果"
        Width="400" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false" CenterOnLoad="true" Maximizable="true">
        <Body>
            <ext:FitLayout ID="FitLayout2" runat="server">
                <ext:FormPanel ID="FormPanelHard" runat="server" Header="false" Border="false" BodyStyle="padding:5px;">
                    <Body>
                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left">
                            <ext:Anchor>
                                <ext:ComboBox ID="cbWdProductLine" runat="server" EmptyText="选择产品线..." Width="200"
                                    Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                    Mode="Local" DisplayField="AttributeName" FieldLabel="产品线" Resizable="true" AllowBlank="false">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:ComboBox ID="cbWdPeriod" runat="server" EmptyText="选择结算周期..." Width="200" Editable="false"
                                    AllowBlank="false" TypeAhead="true" StoreID="PeriodStore" ValueField="Key" Mode="Local"
                                    DisplayField="Value" FieldLabel="结算周期" Resizable="true">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue(); #{hidWdPeriod}.setValue(''); #{cbWdCalPeriod}.setValue(''); #{wdCalPeriodStore}.reload();" />
                                        <Select Handler=" #{hidWdPeriod}.setValue(#{cbWdPeriod}.getValue()); #{cbWdCalPeriod}.setValue(''); #{wdCalPeriodStore}.reload(); " />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:ComboBox ID="cbWdCalPeriod" runat="server" EmptyText="选择账期..." Width="200" Editable="false"
                                    AllowBlank="false" TypeAhead="true" StoreID="wdCalPeriodStore" ValueField="AccountMonth"
                                    Mode="Local" DisplayField="AccountMonth" FieldLabel="账期" Resizable="true">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                             <ext:Anchor>
                                <ext:ComboBox ID="cbType" runat="server" EmptyText="选择类型..." Width="200" Editable="false"
                                    AllowBlank="false" TypeAhead="true" 
                                    Mode="Local"  FieldLabel="类型" Resizable="true">
                                    <Items>
                                        <ext:ListItem Text="赠品" Value="赠品" />
                                        <ext:ListItem Text="积分" Value="积分" />
                                    </Items>
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" HideTrigger="true" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                </ext:FormPanel>
            </ext:FitLayout>
        </Body>
        <Buttons>
        <%--    <ext:Button ID="Button2" Text="下载" runat="server" Icon="PageExcel" IDMode="Legacy"
                OnClientClick="var result = ValidateForm(); if (!result) return false; " AutoPostBack="true"
                OnClick="ExportDetail">
            </ext:Button>--%>
            
             <ext:Button ID="Button2" runat="server" Text="下载"
                     Icon="PageExcel">
                    <Listeners>
                        <Click  Handler=" var result = ValidateForm(); if (!result) return false; window.open('GiftDownload.aspx?ExportType='+#{cbType}.getValue()
                        +'&BUName='+#{cbWdProductLine}.getValue()
                        +'&Period='+#{cbWdPeriod}.getValue()
                        +'&CalPeriod='+#{cbWdCalPeriod}.getValue() );" />
                    </Listeners>
                </ext:Button>
            
            <ext:Button ID="CancelButton" runat="server" Text="关闭" Icon="Cross">
                <Listeners>
                    <Click Handler="#{DetailDownLoadWindow}.hide(null);" />
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
