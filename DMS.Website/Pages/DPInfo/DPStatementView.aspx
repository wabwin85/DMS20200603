<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DPStatementView.aspx.cs"
    Inherits="DMS.Website.Pages.DPInfo.DPStatementView" %>

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
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; var isNegtive = (v < 0); if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = isNegtive ? psplit[0].substring(1) : psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = (isNegtive ? '-' : '') + parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });

        var DoMoneyFormat = function() {
            Ext.select('input.money').each(function(tb) {
                Ext.getCmp(tb.dom.id).setValue(Ext.util.Format.number(tb.getValue(), '0,000.00'));
            });

            Ext.select('input.number').each(function(tb) {
                Ext.getCmp(tb.dom.id).setValue(Ext.util.Format.number(tb.getValue(), '0.00'));
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
                                                            <ext:TextField ID="ym1_C09" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panel40" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label16" runat="server" Html="资产负债表">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel4" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label2" runat="server" Html="货币资金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel5" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C11" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel6" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label3" runat="server" Html="短期投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel7" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C12" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel8" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label4" runat="server" Html="应收票据">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel9" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C13" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel10" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label5" runat="server" Html="应收账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel11" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C14" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel12" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label6" runat="server" Html="存货">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel13" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C15" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel14" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label7" runat="server" Html="预付账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel15" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C16" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel16" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label8" runat="server" Html="其他流动资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel17" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C17" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panel18" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label9" runat="server" Html="流动资产总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panel19" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C18" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel20" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label10" runat="server" Html="固定资产净值">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel21" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C20" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel22" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label11" runat="server" Html="长期投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel23" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C21" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel24" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label12" runat="server" Html="无形资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel25" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C22" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel26" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label13" runat="server" Html="递延税款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel27" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C23" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel28" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label14" runat="server" Html="其他长期流动资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel29" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C24" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panel30" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label15" runat="server" Html="资产总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panel31" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C25" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel32" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label17" runat="server" Html="应付票据">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel33" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C27" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel34" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label18" runat="server" Html="短期借款/一年内到期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel35" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C28" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel36" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label19" runat="server" Html="应付账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel37" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C29" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel38" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label20" runat="server" Html="预收账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel41" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C30" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel42" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label21" runat="server" Html="应交税金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel43" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C31" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel44" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label22" runat="server" Html="应付利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel45" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C32" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel46" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label23" runat="server" Html="应付股利">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel47" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C33" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel48" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label24" runat="server" Html="其他流动负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel49" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C34" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panel50" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label25" runat="server" Html="流动负债总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panel51" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C35" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel52" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label26" runat="server" Html="长期借款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel53" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C37" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel54" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label27" runat="server" Html="其他长期负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel55" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C38" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel56" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label28" runat="server" Html="递延税款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel57" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C39" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panel58" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label29" runat="server" Html="负债总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panel59" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C40" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel60" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label30" runat="server" Html="股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel61" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C42" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel62" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label31" runat="server" Html="少数股东权益">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel63" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C43" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel64" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label32" runat="server" Html="未分配利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel65" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C44" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel66" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label33" runat="server" Html="资本公积">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel67" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C45" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel68" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label34" runat="server" Html="其他调整项">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel69" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C46" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panel70" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label35" runat="server" Html="所有者权益">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panel71" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C47" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panel72" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label36" runat="server" Html="利润表">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel73" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label37" runat="server" Html="销售收入">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel74" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C49" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel75" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label38" runat="server" Html="销售成本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel76" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C50" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel77" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label39" runat="server" Html="毛利">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel78" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C51" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel79" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label40" runat="server" Html="管理费用/营业费用">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel80" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C52" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel81" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label41" runat="server" Html="财务费用">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel82" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C53" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel83" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label42" runat="server" Html="税前利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel84" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C54" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel85" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label43" runat="server" Html="其他调整项">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel86" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C55" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel87" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label44" runat="server" Html="所得税">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panel88" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C56" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom">
                                                    <ext:Panel ID="Panel89" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label45" runat="server" Html="净利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-bottom">
                                                    <ext:Panel ID="Panel90" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym1_C57" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
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
                                                            <ext:TextField ID="ym2_C09" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym240" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym216" runat="server" Html="资产负债表">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym24" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym22" runat="server" Html="货币资金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym25" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C11" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym26" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym23" runat="server" Html="短期投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym27" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C12" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym28" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym24" runat="server" Html="应收票据">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym29" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C13" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym210" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym25" runat="server" Html="应收账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym211" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C14" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym212" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym26" runat="server" Html="存货">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym213" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C15" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym214" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym27" runat="server" Html="预付账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym215" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C16" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym216" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym28" runat="server" Html="其他流动资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym217" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C17" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym218" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym29" runat="server" Html="流动资产总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym219" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C18" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym220" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym210" runat="server" Html="固定资产净值">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym221" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C20" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym222" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym211" runat="server" Html="长期投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym223" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C21" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym224" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym212" runat="server" Html="无形资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym225" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C22" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym226" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym213" runat="server" Html="递延税款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym227" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C23" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym228" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym214" runat="server" Html="其他长期流动资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym229" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C24" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym230" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym215" runat="server" Html="资产总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym231" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C25" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym232" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym217" runat="server" Html="应付票据">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym233" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C27" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym234" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym218" runat="server" Html="短期借款/一年内到期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym235" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C28" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym236" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym219" runat="server" Html="应付账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym237" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C29" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym238" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym220" runat="server" Html="预收账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym241" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C30" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym242" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym221" runat="server" Html="应交税金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym243" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C31" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym244" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym222" runat="server" Html="应付利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym245" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C32" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym246" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym223" runat="server" Html="应付股利">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym247" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C33" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym248" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym224" runat="server" Html="其他流动负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym249" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C34" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym250" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym225" runat="server" Html="流动负债总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym251" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C35" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym252" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym226" runat="server" Html="长期借款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym253" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C37" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym254" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym227" runat="server" Html="其他长期负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym255" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C38" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym256" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym228" runat="server" Html="递延税款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym257" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C39" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym258" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym229" runat="server" Html="负债总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym259" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C40" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym260" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym230" runat="server" Html="股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym261" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C42" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym262" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym231" runat="server" Html="少数股东权益">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym263" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C43" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym264" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym232" runat="server" Html="未分配利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym265" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C44" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym266" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym233" runat="server" Html="资本公积">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym267" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C45" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym268" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym234" runat="server" Html="其他调整项">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym269" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C46" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym270" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym235" runat="server" Html="所有者权益">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym271" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C47" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym272" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym236" runat="server" Html="利润表">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym273" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym237" runat="server" Html="销售收入">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym274" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C49" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym275" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym238" runat="server" Html="销售成本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym276" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C50" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym277" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym239" runat="server" Html="毛利">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym278" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C51" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym279" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym240" runat="server" Html="管理费用/营业费用">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym280" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C52" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym281" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym241" runat="server" Html="财务费用">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym282" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C53" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym283" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym242" runat="server" Html="税前利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym284" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C54" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym285" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym243" runat="server" Html="其他调整项">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym286" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C55" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym287" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym244" runat="server" Html="所得税">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym288" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C56" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom">
                                                    <ext:Panel ID="Panelym289" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym245" runat="server" Html="净利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-bottom">
                                                    <ext:Panel ID="Panelym290" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym2_C57" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
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
                                                            <ext:TextField ID="ym3_C09" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym340" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym316" runat="server" Html="资产负债表">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym34" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym32" runat="server" Html="货币资金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym35" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C11" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym36" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym33" runat="server" Html="短期投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym37" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C12" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym38" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym34" runat="server" Html="应收票据">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym39" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C13" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym310" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym35" runat="server" Html="应收账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym311" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C14" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym312" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym36" runat="server" Html="存货">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym313" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C15" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym314" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym37" runat="server" Html="预付账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym315" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C16" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym316" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym38" runat="server" Html="其他流动资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym317" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C17" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym318" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym39" runat="server" Html="流动资产总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym319" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C18" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym320" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym310" runat="server" Html="固定资产净值">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym321" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C20" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym322" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym311" runat="server" Html="长期投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym323" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C21" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym324" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym312" runat="server" Html="无形资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym325" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C22" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym326" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym313" runat="server" Html="递延税款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym327" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C23" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym328" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym314" runat="server" Html="其他长期流动资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym329" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C24" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym330" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym315" runat="server" Html="资产总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym331" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C25" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym332" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym317" runat="server" Html="应付票据">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym333" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C27" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym334" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym318" runat="server" Html="短期借款/一年内到期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym335" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C28" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym336" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym319" runat="server" Html="应付账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym337" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C29" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym338" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym320" runat="server" Html="预收账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym341" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C30" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym342" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym321" runat="server" Html="应交税金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym343" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C31" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym344" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym322" runat="server" Html="应付利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym345" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C32" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym346" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym323" runat="server" Html="应付股利">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym347" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C33" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym348" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym324" runat="server" Html="其他流动负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym349" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C34" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym350" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym325" runat="server" Html="流动负债总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym351" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C35" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym352" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym326" runat="server" Html="长期借款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym353" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C37" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym354" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym327" runat="server" Html="其他长期负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym355" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C38" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym356" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym328" runat="server" Html="递延税款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym357" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C39" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym358" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym329" runat="server" Html="负债总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym359" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C40" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym360" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym330" runat="server" Html="股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym361" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C42" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym362" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym331" runat="server" Html="少数股东权益">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym363" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C43" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym364" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym332" runat="server" Html="未分配利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym365" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C44" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym366" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym333" runat="server" Html="资本公积">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym367" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C45" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym368" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym334" runat="server" Html="其他调整项">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym369" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C46" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym370" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym335" runat="server" Html="所有者权益">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym371" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C47" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym372" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym336" runat="server" Html="利润表">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym373" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym337" runat="server" Html="销售收入">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym374" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C49" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym375" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym338" runat="server" Html="销售成本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym376" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C50" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym377" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym339" runat="server" Html="毛利">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym378" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C51" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym379" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym340" runat="server" Html="管理费用/营业费用">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym380" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C52" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym381" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym341" runat="server" Html="财务费用">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym382" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C53" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym383" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym342" runat="server" Html="税前利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym384" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C54" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym385" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym343" runat="server" Html="其他调整项">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym386" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C55" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym387" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym344" runat="server" Html="所得税">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym388" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C56" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom">
                                                    <ext:Panel ID="Panelym389" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym345" runat="server" Html="净利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-bottom">
                                                    <ext:Panel ID="Panelym390" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym3_C57" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
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
                                                            <ext:TextField ID="ym4_C09" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym440" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym416" runat="server" Html="资产负债表">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym44" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym42" runat="server" Html="货币资金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym45" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C11" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym46" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym43" runat="server" Html="短期投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym47" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C12" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym48" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym44" runat="server" Html="应收票据">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym49" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C13" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym410" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym45" runat="server" Html="应收账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym411" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C14" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym412" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym46" runat="server" Html="存货">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym413" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C15" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym414" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym47" runat="server" Html="预付账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym415" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C16" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym416" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym48" runat="server" Html="其他流动资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym417" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C17" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym418" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym49" runat="server" Html="流动资产总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym419" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C18" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym420" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym410" runat="server" Html="固定资产净值">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym421" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C20" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym422" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym411" runat="server" Html="长期投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym423" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C21" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym424" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym412" runat="server" Html="无形资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym425" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C22" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym426" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym413" runat="server" Html="递延税款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym427" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C23" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym428" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym414" runat="server" Html="其他长期流动资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym429" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C24" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym430" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym415" runat="server" Html="资产总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym431" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C25" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym432" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym417" runat="server" Html="应付票据">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym433" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C27" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym434" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym418" runat="server" Html="短期借款/一年内到期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym435" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C28" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym436" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym419" runat="server" Html="应付账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym437" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C29" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym438" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym420" runat="server" Html="预收账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym441" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C30" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym442" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym421" runat="server" Html="应交税金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym443" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C31" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym444" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym422" runat="server" Html="应付利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym445" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C32" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym446" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym423" runat="server" Html="应付股利">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym447" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C33" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym448" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym424" runat="server" Html="其他流动负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym449" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C34" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym450" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym425" runat="server" Html="流动负债总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym451" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C35" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym452" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym426" runat="server" Html="长期借款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym453" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C37" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym454" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym427" runat="server" Html="其他长期负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym455" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C38" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym456" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym428" runat="server" Html="递延税款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym457" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C39" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym458" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym429" runat="server" Html="负债总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym459" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C40" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym460" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym430" runat="server" Html="股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym461" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C42" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym462" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym431" runat="server" Html="少数股东权益">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym463" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C43" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym464" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym432" runat="server" Html="未分配利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym465" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C44" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym466" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym433" runat="server" Html="资本公积">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym467" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C45" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym468" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym434" runat="server" Html="其他调整项">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym469" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C46" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym470" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym435" runat="server" Html="所有者权益">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym471" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C47" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym472" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym436" runat="server" Html="利润表">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym473" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym437" runat="server" Html="销售收入">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym474" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C49" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym475" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym438" runat="server" Html="销售成本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym476" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C50" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym477" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym439" runat="server" Html="毛利">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym478" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C51" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym479" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym440" runat="server" Html="管理费用/营业费用">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym480" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C52" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym481" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym441" runat="server" Html="财务费用">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym482" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C53" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym483" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym442" runat="server" Html="税前利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym484" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C54" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym485" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym443" runat="server" Html="其他调整项">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym486" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C55" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym487" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym444" runat="server" Html="所得税">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym488" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C56" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom">
                                                    <ext:Panel ID="Panelym489" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym445" runat="server" Html="净利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-bottom">
                                                    <ext:Panel ID="Panelym490" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym4_C57" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
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
                                                            <ext:TextField ID="ym5_C09" runat="server" ReadOnly="true" Cls="total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym540" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym516" runat="server" Html="资产负债表">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym54" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym52" runat="server" Html="货币资金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym55" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C11" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym56" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym53" runat="server" Html="短期投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym57" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C12" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym58" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym54" runat="server" Html="应收票据">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym59" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C13" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym510" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym55" runat="server" Html="应收账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym511" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C14" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym512" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym56" runat="server" Html="存货">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym513" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C15" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym514" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym57" runat="server" Html="预付账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym515" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C16" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym516" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym58" runat="server" Html="其他流动资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym517" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C17" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym518" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym59" runat="server" Html="流动资产总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym519" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C18" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym520" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym510" runat="server" Html="固定资产净值">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym521" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C20" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym522" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym511" runat="server" Html="长期投资">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym523" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C21" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym524" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym512" runat="server" Html="无形资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym525" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C22" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym526" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym513" runat="server" Html="递延税款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym527" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C23" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym528" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym514" runat="server" Html="其他长期流动资产">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym529" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C24" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym530" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym515" runat="server" Html="资产总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym531" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C25" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym532" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym517" runat="server" Html="应付票据">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym533" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C27" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym534" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym518" runat="server" Html="短期借款/一年内到期">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym535" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C28" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym536" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym519" runat="server" Html="应付账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym537" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C29" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym538" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym520" runat="server" Html="预收账款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym541" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C30" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym542" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym521" runat="server" Html="应交税金">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym543" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C31" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym544" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym522" runat="server" Html="应付利息">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym545" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C32" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym546" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym523" runat="server" Html="应付股利">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym547" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C33" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym548" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym524" runat="server" Html="其他流动负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym549" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C34" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym550" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym525" runat="server" Html="流动负债总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym551" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C35" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym552" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym526" runat="server" Html="长期借款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym553" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C37" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym554" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym527" runat="server" Html="其他长期负债">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym555" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C38" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym556" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym528" runat="server" Html="递延税款">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym557" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C39" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym558" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym529" runat="server" Html="负债总计">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym559" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C40" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym560" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym530" runat="server" Html="股本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym561" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C42" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym562" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym531" runat="server" Html="少数股东权益">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym563" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C43" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym564" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym532" runat="server" Html="未分配利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym565" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C44" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym566" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym533" runat="server" Html="资本公积">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym567" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C45" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym568" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym534" runat="server" Html="其他调整项">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym569" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C46" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-label">
                                                    <ext:Panel ID="Panelym570" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym535" runat="server" Html="所有者权益">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-label">
                                                    <ext:Panel ID="Panelym571" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C47" runat="server" ReadOnly="true" Cls="money total" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-right td-label" ColSpan="2">
                                                    <ext:Panel ID="Panelym572" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="281" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym536" runat="server" Html="利润表">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym573" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym537" runat="server" Html="销售收入">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym574" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C49" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym575" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym538" runat="server" Html="销售成本">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym576" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C50" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym577" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym539" runat="server" Html="毛利">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym578" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C51" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym579" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym540" runat="server" Html="管理费用/营业费用">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym580" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C52" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym581" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym541" runat="server" Html="财务费用">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym582" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C53" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym583" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym542" runat="server" Html="税前利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym584" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C54" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym585" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym543" runat="server" Html="其他调整项">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym586" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C55" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panelym587" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym544" runat="server" Html="所得税">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right">
                                                    <ext:Panel ID="Panelym588" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C56" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
                                                            </ext:TextField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom">
                                                    <ext:Panel ID="Panelym589" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="130" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Labelym545" runat="server" Html="净利润">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-right td-bottom">
                                                    <ext:Panel ID="Panelym590" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="150" Height="30">
                                                        <Body>
                                                            <ext:TextField ID="ym5_C57" runat="server" ReadOnly="true" Cls="money noborder" Width="140"
                                                                Text="">
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
                            <ext:Toolbar runat="server">
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
