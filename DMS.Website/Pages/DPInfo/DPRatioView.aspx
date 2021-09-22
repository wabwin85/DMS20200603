<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DPRatioView.aspx.cs" Inherits="DMS.Website.Pages.DPInfo.DPRatioView" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        *
        {
            font-family: 微软雅黑 !important;
            font-size: 12px;
        }
        .x-table-layout
        {
            padding: 5px;
        }
        .td-label div
        {
            background-color: #99bbe8;
            font-weight: bold;
        }
        .td-left
        {
            border-style: solid;
            border-color: #000000;
            border-width: 1px 0px 0px 1px;
        }
        .td-right
        {
            border-style: solid;
            border-color: #000000;
            border-width: 1px 1px 0px 1px;
        }
        .td-bottom
        {
            border-bottom-width: 1px;
        }
        .money
        {
            text-align: right;
        }
        .number
        {
            text-align: right;
        }
        .percentage
        {
            text-align: right;
        }
        .noborder
        {
            border: none !important;
            background-image: none !important;
            background-color: #dfe8f6;
        }
        .total
        {
            border: none !important;
            background-image: none !important;
            background-color: #99bbe8;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <script language="javascript" type="text/javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } if (format.lastIndexOf('%') != -1) { v *= 100; } else { v *= 1; } if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; var isNegtive = (v < 0); if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = isNegtive ? psplit[0].substring(1) : psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = (isNegtive ? '-' : '') + parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });

        var DoMoneyFormat = function() {
            Ext.select('input.money').each(function(tb) {
                Ext.getCmp(tb.dom.id).setValue(Ext.util.Format.number(tb.getValue(), '0,000.00'));
            });

            Ext.select('input.number').each(function(tb) {
                Ext.getCmp(tb.dom.id).setValue(Ext.util.Format.number(tb.getValue(), '0.00'));
            });

            Ext.select('input.percentage').each(function(tb) {
                Ext.getCmp(tb.dom.id).setValue(Ext.util.Format.number(tb.getValue(), '0.00%'));
            });
        }
        var ExportExcel = function() {

            Coolite.AjaxMethods.ExportExcel({
                success: function() {

                },
                failure: function(err) {
                    Ext.getCmp("TabPanel1").body.unmask();
                    Ext.Msg.alert('Error', err);
                }
            })
        }
    </script>

    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="DoMoneyFormat();" />
        </Listeners>
    </ext:ScriptManager>
    <ext:Hidden ID="hidDealerId" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <Center>
                    <ext:Panel ID="Panel1" runat="server" Border="false" Header="false" Width="1600"
                        AutoScroll="true" Frame="true">
                        <Body>
                            <ext:TableLayout ID="TableLayout2" runat="server" Columns="5">
                                <ext:Cell>
                                    <ext:Panel ID="ym1_panel" runat="server" Header="false" Border="false" Width="300"
                                        Hidden="true">
                                        <Body>
                                            <ext:TableLayout ID="TableLayout5" runat="server" Columns="2">
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panel91" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label46" runat="server" Html="会计期限">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panel92" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="tbYearMonth1" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panel2" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label1" runat="server" Html="天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panel3" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB08" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panel40" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label16" runat="server" Html="流动性分析">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel4" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label2" runat="server" Html="营运资金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel5" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB10" runat="server" ReadOnly="true" Cls="money noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel6" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label3" runat="server" Html="流动比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel7" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB11" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel8" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label4" runat="server" Html="速动比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel9" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB12" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel10" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label5" runat="server" Html="营运资金/总资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel11" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB13" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel12a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label6a" runat="server" Html="现金比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel13a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB14" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panel40a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label16a" runat="server" Html="负债管理及负担">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel4a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label2a" runat="server" Html="负债/股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel5a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB16" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel6a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label3a" runat="server" Html="流动负债/股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel7a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB17" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel8a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label4a" runat="server" Html="息税前利润/利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel9a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB18" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel10a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label5a" runat="server" Html="经营现金流/利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel11a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB19" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel12a1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label6a1" runat="server" Html="息税前利润/总负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel13a1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB20" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panel40b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label16b" runat="server" Html="营运周期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel4b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label2b" runat="server" Html="营运投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel5b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB22" runat="server" ReadOnly="true" Cls="money noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel6b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label3b" runat="server" Html="应收账款周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel7b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB23" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel8b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label4b" runat="server" Html="存货周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel9b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB24" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel10b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label5b" runat="server" Html="经营周期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel11b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB25" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel12b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label6b" runat="server" Html="应付账款周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel13b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB26" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel12b1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label6b1" runat="server" Html="融资天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel13b1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB27" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panel12" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label6" runat="server" Html="盈利能力">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel13" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label7" runat="server" Html="毛利率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel14" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB30" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel15" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label8" runat="server" Html="股本收益率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel16" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB31" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel17" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label9" runat="server" Html="资产收益率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel18" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB32" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel19" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label10" runat="server" Html="净利润率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel20" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB33" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel21" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label11" runat="server" Html="股息/净收入">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel22" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB34" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panel23" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label12" runat="server" Html="破产预测">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom">
                                                    <ext:Panel ID="Panel24" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label13" runat="server" Html="Z-Score">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-bottom">
                                                    <ext:Panel ID="Panel25" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_RB36" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                            </ext:TableLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:Cell>
                                <ext:Cell>
                                    <ext:Panel ID="ym2_panel" runat="server" Header="false" Border="false" Width="300"
                                        Hidden="true">
                                        <Body>
                                            <ext:TableLayout ID="TableLayout1" runat="server" Columns="2">
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym291" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym246" runat="server" Html="会计期限">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym292" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="tbYearMonth2" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym22" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym21" runat="server" Html="天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym23" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB08" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym240" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym216" runat="server" Html="流动性分析">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym24" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym22" runat="server" Html="营运资金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym25" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB10" runat="server" ReadOnly="true" Cls="money noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym26" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym23" runat="server" Html="流动比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym27" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB11" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym28" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym24" runat="server" Html="速动比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym29" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB12" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym210" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym25" runat="server" Html="营运资金/总资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym211" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB13" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym212a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym26a" runat="server" Html="现金比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym213a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB14" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym240a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym216a" runat="server" Html="负债管理及负担">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym24a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym22a" runat="server" Html="负债/股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym25a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB16" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym26a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym23a" runat="server" Html="流动负债/股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym27a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB17" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym28a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym24a" runat="server" Html="息税前利润/利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym29a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB18" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym210a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym25a" runat="server" Html="经营现金流/利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym211a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB19" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym212a1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym26a1" runat="server" Html="息税前利润/总负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym213a1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB20" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym240b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym216b" runat="server" Html="营运周期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym24b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym22b" runat="server" Html="营运投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym25b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB22" runat="server" ReadOnly="true" Cls="money noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym26b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym23b" runat="server" Html="应收账款周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym27b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB23" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym28b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym24b" runat="server" Html="存货周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym29b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB24" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym210b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym25b" runat="server" Html="经营周期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym211b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB25" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym212b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym26b" runat="server" Html="应付账款周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym213b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB26" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym212b1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym26b1" runat="server" Html="融资天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym213b1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB27" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym212" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym26" runat="server" Html="盈利能力">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym213" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym27" runat="server" Html="毛利率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym214" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB30" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym215" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym28" runat="server" Html="股本收益率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym216" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB31" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym217" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym29" runat="server" Html="资产收益率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym218" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB32" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym219" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym210" runat="server" Html="净利润率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym220" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB33" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym221" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym211" runat="server" Html="股息/净收入">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym222" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB34" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym223" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym212" runat="server" Html="破产预测">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom">
                                                    <ext:Panel ID="Panelym224" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym213" runat="server" Html="Z-Score">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-bottom">
                                                    <ext:Panel ID="Panelym225" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_RB36" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                            </ext:TableLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:Cell>
                                <ext:Cell>
                                    <ext:Panel ID="ym3_panel" runat="server" Header="false" Border="false" Width="300"
                                        Hidden="true">
                                        <Body>
                                            <ext:TableLayout ID="TableLayout3" runat="server" Columns="2">
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym391" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym346" runat="server" Html="会计期限">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym392" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="tbYearMonth3" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym32" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym31" runat="server" Html="天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym33" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB08" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym340" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym316" runat="server" Html="流动性分析">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym34" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym32" runat="server" Html="营运资金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym35" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB10" runat="server" ReadOnly="true" Cls="money noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym36" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym33" runat="server" Html="流动比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym37" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB11" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym38" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym34" runat="server" Html="速动比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym39" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB12" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym310" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym35" runat="server" Html="营运资金/总资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym311" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB13" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym312a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym36a" runat="server" Html="现金比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym313a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB14" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym340a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym316a" runat="server" Html="负债管理及负担">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym34a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym32a" runat="server" Html="负债/股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym35a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB16" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym36a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym33a" runat="server" Html="流动负债/股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym37a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB17" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym38a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym34a" runat="server" Html="息税前利润/利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym39a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB18" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym310a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym35a" runat="server" Html="经营现金流/利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym311a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB19" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym312a1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym36a1" runat="server" Html="息税前利润/总负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym313a1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB20" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym340b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym316b" runat="server" Html="营运周期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym34b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym32b" runat="server" Html="营运投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym35b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB22" runat="server" ReadOnly="true" Cls="money noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym36b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym33b" runat="server" Html="应收账款周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym37b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB23" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym38b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym34b" runat="server" Html="存货周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym39b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB24" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym310b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym35b" runat="server" Html="经营周期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym311b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB25" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym312b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym36b" runat="server" Html="应付账款周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym313b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB26" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym312b1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym36b1" runat="server" Html="融资天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym313b1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB27" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym312" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym36" runat="server" Html="盈利能力">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym313" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym37" runat="server" Html="毛利率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym314" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB30" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym315" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym38" runat="server" Html="股本收益率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym316" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB31" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym317" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym39" runat="server" Html="资产收益率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym318" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB32" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym319" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym310" runat="server" Html="净利润率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym320" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB33" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym321" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym311" runat="server" Html="股息/净收入">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym322" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB34" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym323" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym312" runat="server" Html="破产预测">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom">
                                                    <ext:Panel ID="Panelym324" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym313" runat="server" Html="Z-Score">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-bottom">
                                                    <ext:Panel ID="Panelym325" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_RB36" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                            </ext:TableLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:Cell>
                                <ext:Cell>
                                    <ext:Panel ID="ym4_panel" runat="server" Header="false" Border="false" Width="300"
                                        Hidden="true">
                                        <Body>
                                            <ext:TableLayout ID="TableLayout4" runat="server" Columns="2">
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym491" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym446" runat="server" Html="会计期限">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym492" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="tbYearMonth4" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym42" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym41" runat="server" Html="天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym43" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB08" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym440" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym416" runat="server" Html="流动性分析">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym44" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym42" runat="server" Html="营运资金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym45" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB10" runat="server" ReadOnly="true" Cls="money noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym46" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym43" runat="server" Html="流动比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym47" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB11" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym48" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym44" runat="server" Html="速动比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym49" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB12" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym410" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym45" runat="server" Html="营运资金/总资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym411" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB13" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym412a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym46a" runat="server" Html="现金比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym413a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB14" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym440a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym416a" runat="server" Html="负债管理及负担">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym44a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym42a" runat="server" Html="负债/股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym45a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB16" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym46a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym43a" runat="server" Html="流动负债/股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym47a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB17" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym48a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym44a" runat="server" Html="息税前利润/利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym49a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB18" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym410a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym45a" runat="server" Html="经营现金流/利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym411a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB19" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym412a1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym46a1" runat="server" Html="息税前利润/总负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym413a1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB20" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym440b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym416b" runat="server" Html="营运周期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym44b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym42b" runat="server" Html="营运投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym45b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB22" runat="server" ReadOnly="true" Cls="money noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym46b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym43b" runat="server" Html="应收账款周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym47b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB23" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym48b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym44b" runat="server" Html="存货周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym49b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB24" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym410b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym45b" runat="server" Html="经营周期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym411b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB25" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym412b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym46b" runat="server" Html="应付账款周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym413b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB26" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym412b1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym46b1" runat="server" Html="融资天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym413b1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB27" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym412" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym46" runat="server" Html="盈利能力">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym413" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym47" runat="server" Html="毛利率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym414" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB30" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym415" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym48" runat="server" Html="股本收益率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym416" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB31" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym417" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym49" runat="server" Html="资产收益率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym418" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB32" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym419" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym410" runat="server" Html="净利润率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym420" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB33" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym421" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym411" runat="server" Html="股息/净收入">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym422" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB34" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym423" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym412" runat="server" Html="破产预测">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom">
                                                    <ext:Panel ID="Panelym424" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym413" runat="server" Html="Z-Score">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-bottom">
                                                    <ext:Panel ID="Panelym425" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_RB36" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                            </ext:TableLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:Cell>
                                <ext:Cell>
                                    <ext:Panel ID="ym5_panel" runat="server" Header="false" Border="false" Width="300"
                                        Hidden="true">
                                        <Body>
                                            <ext:TableLayout ID="TableLayout6" runat="server" Columns="2">
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym591" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym546" runat="server" Html="会计期限">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym592" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="tbYearMonth5" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym52" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym51" runat="server" Html="天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym53" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB08" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym540" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym516" runat="server" Html="流动性分析">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym54" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym52" runat="server" Html="营运资金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym55" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB10" runat="server" ReadOnly="true" Cls="money noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym56" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym53" runat="server" Html="流动比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym57" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB11" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym58" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym54" runat="server" Html="速动比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym59" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB12" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym510" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym55" runat="server" Html="营运资金/总资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym511" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB13" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym512a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym56a" runat="server" Html="现金比率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym513a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB14" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym540a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym516a" runat="server" Html="负债管理及负担">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym54a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym52a" runat="server" Html="负债/股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym55a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB16" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym56a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym53a" runat="server" Html="流动负债/股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym57a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB17" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym58a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym54a" runat="server" Html="息税前利润/利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym59a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB18" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym510a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym55a" runat="server" Html="经营现金流/利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym511a" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB19" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym512a1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym56a1" runat="server" Html="息税前利润/总负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym513a1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB20" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym540b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym516b" runat="server" Html="营运周期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym54b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym52b" runat="server" Html="营运投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym55b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB22" runat="server" ReadOnly="true" Cls="money noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym56b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym53b" runat="server" Html="应收账款周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym57b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB23" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym58b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym54b" runat="server" Html="存货周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym59b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB24" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym510b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym55b" runat="server" Html="经营周期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym511b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB25" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym512b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym56b" runat="server" Html="应付账款周转天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym513b" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB26" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym512b1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym56b1" runat="server" Html="融资天数">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym513b1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB27" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym512" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym56" runat="server" Html="盈利能力">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym513" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym57" runat="server" Html="毛利率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym514" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB30" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym515" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym58" runat="server" Html="股本收益率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym516" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB31" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym517" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym59" runat="server" Html="资产收益率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym518" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB32" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym519" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym510" runat="server" Html="净利润率">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym520" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB33" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym521" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym511" runat="server" Html="股息/净收入">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym522" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB34" runat="server" ReadOnly="true" Cls="percentage noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym523" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym512" runat="server" Html="破产预测">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom">
                                                    <ext:Panel ID="Panelym524" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym513" runat="server" Html="Z-Score">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-bottom">
                                                    <ext:Panel ID="Panelym525" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_RB36" runat="server" ReadOnly="true" Cls="number noborder"
                                                                Width="140" Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                            </ext:TableLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:Cell>
                            </ext:TableLayout>
                        </Body>
                        <BottomBar>
                            <ext:Toolbar ID="Toolbar1" runat="server">
                                <Items>
                                    <ext:ToolbarButton ID="Btn_export" runat="server" Text="导出" Icon="Disk" AutoPostBack="true"
                                        OnClick="ExportExcel">
                                    </ext:ToolbarButton>
                                </Items>
                            </ext:Toolbar>
                        </BottomBar>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>
</body>
</html>
