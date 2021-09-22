<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShipmentInitList.aspx.cs" Inherits="DMS.Website.Pages.Shipment.ShipmentInitList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/AuthorizationDialog.ascx" TagName="AuthorizationDialog"
    TagPrefix="uc" %>

<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <style type="text/css">
            .yellow-row {
                background: #FFFF99;
            }

            .txtRed {
                color: Red;
                font-weight: bold;
            }

            .txtGree {
                color: green;
                font-weight: bold;
            }
        </style>

        <script type="text/javascript" language="javascript">
            Ext.apply(Ext.util.Format, { number: function (v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function (format) { return function (v) { return Ext.util.Format.number(v, format); }; } });
            //刷新父窗口查询结果
            function SelectValue(e) {
                var filterField = 'ChineseShortName';  //需进行模糊查询的字段
                var combo = e.combo;
                combo.collapse();
                if (!e.forceAll) {
                    var value = e.query;
                    if (value != null && value != '') {
                        combo.store.filterBy(function (record, id) {
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
            function RefreshDetailWindow() {
                Ext.getCmp('<%=this.PagingToolBar2.ClientID%>').changePage(1);
            }
            var Img = '<img src="{0}"></img>';
            var change = function (value) {
                if (value == '1') {
                    return String.format(Img, '/resources/images/icons/cross.png');
                }
                else if (value == '0') {
                    return String.format(Img, '/resources/images/icons/tick.png');
                }
                else {
                    //return "";
                    return String.format(Img, '/resources/images/icons/bullet_go.png');
                }
            }

            var renderDataErrorType = function (value) {
                if (value == '产品' || value == '授权') {
                    return '<a class="ErrorTypeQuery" ext:qtip="点击查看授权" style="cursor:pointer;">' + value + '</a>';
                } else {
                    return value;
                }
            }

            var cellClick = function (grid, rowIndex, columnIndex, e) {

                var t = e.getTarget();
                var record = grid.getStore().getAt(rowIndex);  // Get the Record   
                var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
                if (t.className == 'ErrorTypeQuery' && columnId == 'ErrorType') {
                    Coolite.AjaxMethods.AuthorizationDialog.AuthorizationShow(record.data.UPN, record.data.DmaId, { success: function () { }, failure: function (err) { Ext.Msg.alert('Error', err); } });
                }
            }

        </script>

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
        </ext:Store>
        <ext:Store ID="ShipmentStatusStore" runat="server" UseIdConfirmation="true">
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
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="OrderNo" />
                        <ext:RecordField Name="SubmitDate" Type="Date" />
                        <ext:RecordField Name="InitStatus" />
                        <ext:RecordField Name="TotalQty" />
                        <ext:RecordField Name="OperType" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="查询条件" AutoHeight="true"
                            BodyStyle="padding: 5px;" Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择经销商…"
                                                            Width="220" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                                            DisplayField="ChineseShortName" Mode="Local" FieldLabel="经销商"
                                                            ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();this.store.clearFilter();" />
                                                                <BeforeQuery Fn="SelectValue" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbShipmentInitStatus" runat="server" EmptyText="请选择处理状态…"
                                                            Width="220" Editable="false" TypeAhead="true" StoreID="ShipmentStatusStore" ValueField="Key"
                                                            Mode="Local" DisplayField="Value" FieldLabel="处理状态">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
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
                                                        <ext:DateField ID="txtSubmitDateStart" runat="server" Width="150" FieldLabel="导入开始日期" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtShipmentInitNo" runat="server" Width="220" FieldLabel="导入编号" />
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
                                                        <ext:DateField ID="txtSubmitDateEnd" runat="server" Width="150" FieldLabel="导入终止日期" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnImport" runat="server" Text="导入"
                                    Icon="Disk" IDMode="Legacy">
                                    <Listeners>
                                        <%--<Click Handler="window.parent.loadExample('/Pages/Shipment/ShipmentInit.aspx','subMenu440','销售单导入');" />--%>
                                        <Click Handler="top.createTab({id: 'subMenu440',title: '销售单导入',url: 'Pages/Shipment/ShipmentInit.aspx'});" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnExpDetail" Text="导出错误数据" runat="server" Icon="PageExcel" IDMode="Legacy" Hidden="true"
                                    AutoPostBack="true" OnClick="ExportDetail">
                                </ext:Button>
                                <ext:Button ID="btnSearch" Text="查询" runat="server"
                                    Icon="ArrowRefresh" IDMode="Legacy">
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
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果"
                                        StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="OrderNo" DataIndex="OrderNo" Header="编号" Width="160">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperType" DataIndex="OperType" Header="操作类型" Width="160">
                                                </ext:Column>
                                                <ext:Column ColumnID="DmaId" DataIndex="DmaId" Header="经销商" Width="220">
                                                    <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="SubmitDate" DataIndex="SubmitDate" Header="导入时间" Width="150">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Width="120" Header="导入总数量">
                                                </ext:Column>
                                                <ext:Column ColumnID="InitStatus" DataIndex="InitStatus" Width="150"
                                                    Header="导入状态">
                                                    <Renderer Handler="return getNameFromStoreById(ShipmentStatusStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:CommandColumn ColumnID="OrderDetail" Align="Center" Width="50" Header="明细">
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
                                            <Command Handler="Coolite.AjaxMethods.ShipmentInitList.Show(record.data.OrderNo,record.data.InitStatus,{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="ResultStore"
                                                DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
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
        <uc:AuthorizationDialog ID="AuthorizationDialog1" runat="server"></uc:AuthorizationDialog>
        <ext:Store ID="InitMassageStore" runat="server" OnRefreshData="InitMassageStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="LineNbr">
                    <Fields>
                        <ext:RecordField Name="LineNbr" />
                        <ext:RecordField Name="TypeFlg" />
                        <ext:RecordField Name="Warehouse" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="HospitalOffice" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="UPN" />
                        <ext:RecordField Name="UOM" />
                        <ext:RecordField Name="UOMQty" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="QrCode" />
                        <ext:RecordField Name="ShipmentDate" />
                        <ext:RecordField Name="ExpiredDate" Type="Date" />
                        <ext:RecordField Name="InvQty" />
                        <ext:RecordField Name="ShipmentQty" />
                        <ext:RecordField Name="InvRemnantQty" />
                        <ext:RecordField Name="UnitPrice" />
                        <ext:RecordField Name="ErrorType" />
                        <ext:RecordField Name="ErrorMassage" />
                        <ext:RecordField Name="ProposedMassage" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="hiddenInitNo" runat="server" />
        <ext:Hidden ID="hiddenStatus" runat="server" />
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="销售单导入结果查询" Width="980" Height="460" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:1px;" Resizable="false" Header="false" CenterOnLoad="true"
            Y="10" Maximizable="true">
            <Body>
                <ext:FitLayout ID="FitLayout2" runat="server">
                    <ext:GridPanel ID="windGpMassage" runat="server" Title="结果查询"
                        StoreID="InitMassageStore" Border="false" Icon="Error" AutoWidth="true" StripeRows="true"
                        EnableHdMenu="false">
                        <TopBar>
                            <ext:Toolbar ID="Toolbar1" runat="server">
                                <Items>
                                    <ext:Label ID="lblResult" runat="server" Text="" Icon="Cross" CtCls="txtRed" />
                                    <ext:Label ID="lblInvSum" runat="server" Text="" Icon="Tick" CtCls="txtGree" />
                                    <ext:Label ID="lblProcessing" runat="server" Text="" Icon="BulletGo" X="500" />
                                </Items>
                                <Items>
                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                    <ext:Label ID="lbTotal" runat="server" Text="" Icon="Sum" />
                                    <ext:Label ID="lbQuantity" runat="server" Text="" Icon="Sum" />
                                </Items>
                            </ext:Toolbar>
                        </TopBar>
                        <ColumnModel ID="ColumnModel9" runat="server">
                            <Columns>
                                <ext:Column ColumnID="LineNbr" DataIndex="LineNbr" Header="行号" Sortable="false" Width="45">
                                </ext:Column>
                                <ext:Column ColumnID="TypeFlg" DataIndex="TypeFlg" Align="Center" Width="50" MenuDisabled="true" Header="结果">
                                    <Renderer Fn="change" />
                                </ext:Column>
                                <ext:Column ColumnID="ShipmentDate" DataIndex="ShipmentDate" Header="销量日期" Sortable="false" Width="100">
                                    <%--  <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />--%>
                                </ext:Column>
                                <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="医院" Sortable="false" Width="150">
                                </ext:Column>
                                <ext:Column ColumnID="HospitalOffice" DataIndex="HospitalOffice" Header="科室" Sortable="false" Width="120">
                                </ext:Column>
                                <ext:Column ColumnID="Warehouse" DataIndex="Warehouse" Header="仓库" Sortable="false" Width="150">
                                </ext:Column>
                                <ext:Column ColumnID="UPN" DataIndex="UPN" Header="产品编号" Sortable="false" Width="100">
                                </ext:Column>
                                <ext:Column ColumnID="UOM" DataIndex="UOM" Header="包装" Sortable="false" Width="50">
                                </ext:Column>
                                <ext:Column ColumnID="UOMQty" DataIndex="UOMQty" Header="包装数" Sortable="false" Width="50">
                                </ext:Column>
                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="批号" Sortable="false" Width="100">
                                </ext:Column>
                                <ext:Column ColumnID="QrCode" DataIndex="QrCode" Header="二维码" Sortable="false" Width="150">
                                </ext:Column>
                                <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="产品有效期" Sortable="false" Width="100">
                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                </ext:Column>
                                <ext:Column ColumnID="InvQty" DataIndex="InvQty" Header="可用库存" Sortable="false" Width="80">
                                </ext:Column>
                                <ext:Column ColumnID="ShipmentQty" DataIndex="ShipmentQty" Header="销售数量" Sortable="false" Width="80">
                                </ext:Column>
                                <ext:Column ColumnID="InvRemnantQty" DataIndex="InvRemnantQty" Header="剩余库存" Sortable="false" Width="80">
                                </ext:Column>
                                <ext:Column ColumnID="UnitPrice" DataIndex="UnitPrice" Header="销售单价" Sortable="false" Width="80">
                                </ext:Column>
                                <ext:Column ColumnID="ErrorType" DataIndex="ErrorType" Header="错误类型" Sortable="false" Width="120">
                                    <Renderer Fn="renderDataErrorType" />
                                </ext:Column>
                                <%--<ext:Column ColumnID="InitResult" DataIndex="InitResult" Header="授权查询" Sortable="false" Width="100">
                                </ext:Column>--%>
                                <ext:Column ColumnID="ErrorMassage" DataIndex="ErrorMassage" Header="错误描述" Sortable="false" Width="230">
                                </ext:Column>
                                <ext:Column ColumnID="ProposedMassage" DataIndex="ProposedMassage" Header="建议修改" Sortable="false" Width="230">
                                </ext:Column>
                            </Columns>
                        </ColumnModel>
                        <%--  <View>
                            <ext:GridView ID="GridView1" runat="server">
                                <GetRowClass Fn="getIsErrorInvoiceInitClass" />
                            </ext:GridView>
                        </View>--%>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                MoveEditorOnEnter="false">
                            </ext:RowSelectionModel>
                        </SelectionModel>
                        <Listeners>
                            <CellClick Fn="cellClick" />
                        </Listeners>
                        <BottomBar>
                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="100" StoreID="InitMassageStore" DisplayInfo="false">
                            </ext:PagingToolbar>
                        </BottomBar>
                        <LoadMask ShowMask="true" Msg="Loading..." />
                    </ext:GridPanel>

                </ext:FitLayout>
            </Body>
            <Buttons>
                <ext:Button ID="Button1" Text="导出错误数据" runat="server" Icon="PageExcel" IDMode="Legacy"
                    AutoPostBack="true" OnClick="ExportDetail">
                </ext:Button>
                <ext:Button ID="DeleteButton" runat="server" Text="关闭" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{DetailWindow}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <Hide Handler="#{windGpMassage}.clear();" />
            </Listeners>
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
