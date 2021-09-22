<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderMaintain.aspx.cs"
    Inherits="DMS.Website.Pages.Order.OrderMaintain" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Import Namespace="DMS.Model.Data" %>
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
        .yellow-row
        {
            background: #FFFF99;
        }
    </style>

    <script type="text/javascript" language="javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });
        //刷新父窗口查询结果

        function GetOrderSataus() {
            var txtOrderNo = Ext.getCmp('<%=this.txtOrderNo.ClientID%>');
            if (txtOrderNo.getValue() == '') {
                Ext.Msg.alert('Message', '请输入订单号');
                return false;
            };
            Coolite.AjaxMethods.GetOrderStatus({
                success: function() { },
                failure: function(err) {
                    Ext.Msg.alert('Error', err);
                }
            }

            )

        }
        function UpdateOrderSatatus() {
            var txtOrderNo = Ext.getCmp('<%=this.txtOrderNo.ClientID%>');
            var cbOrderSatus = Ext.getCmp('<%=this.cbOrderSatus.ClientID%>');
            if (txtOrderNo.getValue() == '') {
                Ext.Msg.alert('Message', '请输入订单号');
                return false;
            };
            if (cbOrderSatus.getValue() == '') {
                Ext.Msg.alert('Message', '请选择订单状态');
                return false;
            };
            Ext.Msg.confirm('Message', '确定编辑状态吗?', function(e) {
                if (e == 'yes') {
                    Coolite.AjaxMethods.UpdateOrderSatatus({
                        success: function() { },
                        failure: function(err) {
                            Ext.Msg.alert('Error', err);
                        }
                    }

            )
                }
            }

            )

        }

        function GetPoReceiptHeader() {
            var txtOrderNo = Ext.getCmp('<%=this.txtProOrderNo.ClientID%>');
            var lbdesc = Ext.getCmp('<%=this.Label1.ClientID%>');
           
            if (txtOrderNo.getValue() == '') {
                Ext.Msg.alert('Message', '请输入发货单号');
                return false;
            };
            Coolite.AjaxMethods.GetPoReceiptHeader({
            success: function() { 
            
                },
                failure: function(err) {
                    Ext.Msg.alert('Error', err);
                }
            }

            )

        }
        function UpdatePoReceipHeaderDate() {
            var txtProOrderNo = Ext.getCmp('<%=this.txtProOrderNo.ClientID%>');
            var txthiSpmentDate = Ext.getCmp('<%=this.txthiSpmentDate.ClientID%>');
            var txtsliveryDate = Ext.getCmp('<%=this.txtsliveryDate.ClientID%>');

            if (txtProOrderNo.getValue() == '') {
                Ext.Msg.alert('Message', '请输入发货单号');
                return false;
            };
            if (txthiSpmentDate.getValue() == '' && txtsliveryDate.getValue() == '') {
                Ext.Msg.alert('Message', '发货单时间和接口时间至少选一个');
                return false;
            }

            Ext.Msg.confirm('Message', '确定编辑时间吗?', function(e) {
                if (e == 'yes') {
                    Coolite.AjaxMethods.UpdatePoReceipHeaderDate({
                        success: function() { },
                        failure: function(err) {
                            Ext.Msg.alert('Error', err);
                        }
                    }

            )
                }
            }

            )
        }
        function OrderRetrunInfo() {

            var txtSchOrderNo = Ext.getCmp('<%=this.txtSchOrderNo.ClientID%>');
            if (txtSchOrderNo.getValue() == '') {
                Ext.Msg.alert('Message', '请输退货单或寄售单号');
                return false;
            };
            Coolite.AjaxMethods.GetSCHConfirmDate({
                success: function() { },
                failure: function(err) {
                    Ext.Msg.alert('Error', err);
                }
            }

            )
        }
        function UpdateSCHConfirmDate() {
            var txtSchOrderNo = Ext.getCmp('<%=this.txtSchOrderNo.ClientID%>');
            var DataConfirmDate = Ext.getCmp('<%=this.DataConfirmDate.ClientID%>');

            if (txtSchOrderNo.getValue() == '') {
                Ext.Msg.alert('Message', '请输退货单或寄售单号');
                return false;
            };
            if (DataConfirmDate.getValue() == '') {
                Ext.Msg.alert('Message', '确认时间不能为空');
                return false;
            }

            Ext.Msg.confirm('Message', '确定编辑时间吗?', function(e) {
                if (e == 'yes') {
                    Coolite.AjaxMethods.UpdateSCHConfirmDate({
                        success: function() { },
                        failure: function(err) {
                            Ext.Msg.alert('Error', err);
                        }
                    }

            )
                }
            }

            )
        }

        var SetCellCssEditable = function(v, m) {
            m.css = "yellow-row";
            return v;
        }
    </script>

    <ext:Store ID="OrderStatusStore" runat="server" UseIdConfirmation="true">
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
    <ext:Store ID="ResultStore" runat="server" AutoLoad="false" OnRefreshData="ResultStore_RefershData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="OrderNo" />
                    <ext:RecordField Name="UPN" />
                    <ext:RecordField Name="Lot" />
                    <ext:RecordField Name="Qty" />
                    <ext:RecordField Name="UnitPric" />
                    <ext:RecordField Name="ChineseName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="HidSchId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="HidPrice" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
<%--                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="11" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="Find">
                        <Body>
                            <div style="text-align: center; color: Red; font-size: 20px;">
                                订单状态修改</div>
                        </Body>
                    </ext:Panel>
                </North>--%>
                <Center MarginsSummary="0 5 5 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false" AutoScroll="true"  BodyStyle="padding: 5px;">
                        <Body>
                            <ext:RowLayout runat="server">
                                <ext:LayoutRow>
                                    <ext:FieldSet ID="DivSampleBusiness" runat="server" Header="true" Frame="false" BodyBorder="true"
                                        AutoHeight="true" AutoWidth="true" Title="订单状态修改" Collapsible="true">
                                        <Body>
                                            <ext:FormLayout runat="server" ID="a">
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel3" runat="server" Header="false" Border="false" >
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="txtOrderNo" runat="server" FieldLabel="订单编号" Width="200" EmptyText="输入订单编号进行查询">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:Label ID="lbMessing" FieldLabel="提示" runat="server">
                                                                                    </ext:Label>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:ComboBox ID="CbOldOrderSataus" runat="server" EmptyText="" Width="150" Editable="false"
                                                                                        TypeAhead="true" StoreID="OrderStatusStore" ValueField="Key" Mode="Local" DisplayField="Value"
                                                                                        FieldLabel="订单原状态" ListWidth="300" Resizable="true" Disabled="true">
                                                                                        <Triggers>
                                                                                            <ext:FieldTrigger Icon="Clear" Qtip="" />
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
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:ComboBox ID="cbOrderSatus" runat="server" EmptyText="" Width="150" Editable="false"
                                                                                        TypeAhead="true" StoreID="OrderStatusStore" ValueField="Key" Mode="Local" DisplayField="Value"
                                                                                        FieldLabel="订单状态" ListWidth="300" Resizable="true">
                                                                                        <Triggers>
                                                                                            <ext:FieldTrigger Icon="Clear" Qtip="" />
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
                                                    </ext:Panel>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                        <Buttons>
                                            <ext:Button ID="BtnOrderQuery" runat="server" Text="查询">
                                                <Listeners>
                                                    <Click Handler="GetOrderSataus();" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="BtnOrderUpdate" runat="server" Text="编辑" Disabled="true">
                                                <Listeners>
                                                    <Click Handler="UpdateOrderSatatus();" />
                                                </Listeners>
                                            </ext:Button>
                                        </Buttons>
                                    </ext:FieldSet>
                                </ext:LayoutRow>
                                <ext:LayoutRow>
                                    <ext:FieldSet ID="FieldSet1" runat="server" Header="true" Frame="false" BodyBorder="true"
                                        AutoHeight="true" AutoWidth="true" Title="发货单发货时间、接口时间修改" Collapsible="true">
                                        <Body>
                                            <ext:FormLayout runat="server" ID="FormLayout4">
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel7" runat="server" Header="false" Border="false">
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="txtProOrderNo" runat="server" FieldLabel="发货单号" Width="200" EmptyText="输入发货单号进行查询">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:Label ID="Label1" FieldLabel="提示" runat="server">
                                                                                    </ext:Label>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:DateField ID="txtOldShipmentDate" ReadOnly="true" runat="server" FieldLabel="原发货单时间"
                                                                                        Width="200" Disabled="true">
                                                                                    </ext:DateField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:DateField ID="txthiSpmentDate" runat="server" FieldLabel="发货单时间" Width="200">
                                                                                    </ext:DateField>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel10" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:DateField ID="txtOldlsiveryDate" ReadOnly="true" Disabled="true" runat="server"
                                                                                        FieldLabel="原接口时间" Width="200">
                                                                                    </ext:DateField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:DateField ID="txtsliveryDate"  runat="server" FieldLabel="接口时间"
                                                                                        Width="200">
                                                                                    </ext:DateField>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                            </ext:ColumnLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                        <Buttons>
                                            <ext:Button ID="BtnProQuery" runat="server" Text="查询">
                                                <Listeners>
                                                    <Click Handler="GetPoReceiptHeader();" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="BtnProUpdate" Disabled="true" runat="server" Text="编辑">
                                                <Listeners>
                                                    <Click Handler="UpdatePoReceipHeaderDate();" />
                                                </Listeners>
                                            </ext:Button>
                                        </Buttons>
                                    </ext:FieldSet>
                                </ext:LayoutRow>
                                <ext:LayoutRow>
                                    <ext:FieldSet ID="FieldSet2" runat="server" Header="true" Frame="false" BodyBorder="true"
                                        AutoWidth="true" Title="退货及寄售销售单确认时间和确认价格修改" Collapsible="true" AutoScroll="true">
                                        <Body>
                                            <ext:Panel runat="server" Title="查询条件" Border="false" Header="false">
                                                <Body>
                                                    <ext:ColumnLayout runat="server">
                                                        <ext:LayoutColumn ColumnWidth=".33">
                                                            <ext:Panel ID="Panel12" runat="server" Border="false" Header="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                        <ext:Anchor>
                                                                            <ext:Panel runat="server" Border="false" Height="20">
                                                                                <Body>
                                                                                    <div style="text-align: left; color: Red; font-weight: bold;">
                                                                                        查询条件:</div>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtSchOrderNo" eadOnly="true" runat="server" FieldLabel="寄售销售单号/退货单"
                                                                                Width="200">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth=".33">
                                                            <ext:Panel ID="Panel13" runat="server" Border="false" Header="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                        <ext:Anchor>
                                                                            <ext:Panel runat="server" Height="20" Border="false">
                                                                                <Body>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtUpn" eadOnly="true" runat="server" FieldLabel="UPN" Width="200">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth=".33">
                                                            <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                        <ext:Anchor>
                                                                            <ext:Panel ID="Panel15" runat="server" Height="20" Border="false">
                                                                                <Body>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="txtLot" eadOnly="true" runat="server" FieldLabel="批次号" Width="200">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                    </ext:ColumnLayout>
                                                </Body>
                                                <Buttons>
                                                    <ext:Button ID="BtnRetrunSecher" runat="server" Text="查询">
                                                        <Listeners>
                                                            <Click Handler="OrderRetrunInfo();" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Buttons>
                                            </ext:Panel>
                                            <ext:Panel ID="Panel11" runat="server" Title="修改时间" Border="false" Header="false">
                                                <Body>
                                                    <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                        <ext:LayoutColumn ColumnWidth=".33">
                                                            <ext:Panel ID="Panel16" runat="server" Border="false" Header="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout11" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                        <ext:Anchor>
                                                                            <ext:Panel ID="Panel17" runat="server" Border="false" Height="20">
                                                                                <Body>
                                                                                    <div style="text-align: left; color: Red; font-weight: bold;">
                                                                                        退货及寄售销售单确认时间修改:</div>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:DateField ID="DataOldConfirmDate" FieldLabel="原确认时间" Disabled="true" runat="server"
                                                                                Width="200">
                                                                            </ext:DateField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:Label ID="lb3" runat="server" FieldLabel="提示">
                                                                            </ext:Label>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth=".33">
                                                            <ext:Panel ID="Panel18" runat="server" Border="false" Header="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout12" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                        <ext:Anchor>
                                                                            <ext:Panel ID="Panel19" runat="server" Height="20" Border="false">
                                                                                <Body>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:DateField ID="DataConfirmDate" FieldLabel="确认时间" runat="server" Width="200">
                                                                            </ext:DateField>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                    </ext:ColumnLayout>
                                                </Body>
                                                <Buttons>
                                                    <ext:Button ID="BtnUPdateConfirmDate" runat="server" Text="编辑" Disabled="true">
                                                        <Listeners>
                                                            <Click Handler="UpdateSCHConfirmDate();" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Buttons>
                                            </ext:Panel>
                                            <ext:Panel ID="Panel20" runat="server" Title="修改价格" Border="true" Header="false">
                                                <Body>
                                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                                        <ext:GridPanel ID="GridPanel1" runat="server" Title="修改价格" StoreID="ResultStore"
                                                            Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" Height="300" AutoScroll="true">
                                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="产品名称" Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="UPN" DataIndex="UPN" Header="产品型号" Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Lot" DataIndex="Lot" Header="批次" Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Qty" DataIndex="Qty" Header="数量" Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="UnitPric" DataIndex="UnitPric" Header="价格" Width="200">
                                                                        <Editor>
                                                                            <ext:NumberField ID="nfShipmentPriceForInv" runat="server" AllowBlank="false" DecimalPrecision="2"
                                                                                AllowDecimals="true" SelectOnFocus="true" AllowNegative="false">
                                                                            </ext:NumberField>
                                                                        </Editor>
                                                                    </ext:Column>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel6" SingleSelect="true" runat="server">
                                                                </ext:RowSelectionModel>
                                                            </SelectionModel>
                                                            <Listeners>
                                                                <BeforeEdit Handler="#{HidSchId}.setValue(this.getSelectionModel().getSelected().data.Id);
                                                            #{HidPrice}.setValue(this.getSelectionModel().getSelected().data.UnitPric);" />
                                                                <AfterEdit Handler="Coolite.AjaxMethods.SaveAdjustItem(#{HidSchId}.getValue(), #{nfShipmentPriceForInv}.getValue(),{success:function(){#{HidSchId}.setValue('');#{HidPrice}.setValue('');},failure: function(err) {Ext.Msg.alert('提示', err);}});" />
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
                                        </Body>
                                    </ext:FieldSet>
                                </ext:LayoutRow>
                            </ext:RowLayout>
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
