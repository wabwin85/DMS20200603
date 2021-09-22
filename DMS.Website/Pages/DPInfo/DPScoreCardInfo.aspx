<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DPScoreCardInfo.aspx.cs"
    Inherits="DMS.Website.Pages.DPInfo.DPScoreCardInfo" %>

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
    </style>
</head>
<body>

    <script language="javascript" type="text/javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; var isNegtive = (v < 0); if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = isNegtive ? psplit[0].substring(1) : psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = (isNegtive ? '-' : '') + parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });

        Ext.apply(Ext.form.VTypes, {
            money: function(val, field) {
                return !isNaN(val.replace(/[,]/g, ''));
            }
        });

        var DoCalculation = function() {
            if (!IsFormValid()) {
                Ext.Msg.alert('Message', "必须填写完整！");
                return;
            }
            Ext.getCmp("TabPanel1").body.mask('Loading...', 'x-mask-loading');
            Coolite.AjaxMethods.Calculation({
                success: function() {
                    Ext.getCmp("TabPanel1").body.unmask();
                    Ext.Msg.alert("注意", "计算成功", function() { DoMoneyFormat(); });
                },
                failure: function(err) {
                    Ext.getCmp("TabPanel1").body.unmask();
                    Ext.Msg.alert('Error', err);
                }
            });
        }

        var DoSave = function() {
            if (!IsFormValid()) {
                Ext.Msg.alert('Message', "必须填写完整！");
                return;
            }
            Ext.getCmp("TabPanel1").body.mask('Loading...', 'x-mask-loading');
            Coolite.AjaxMethods.Save({
                success: function() {
                    Ext.getCmp("TabPanel1").body.unmask();
                    Ext.Msg.alert("注意", "保存成功", function() {
                        window.parent.closeTab('subMenuDPScoreCard_' + Ext.getCmp("hidDealerId").getValue());
                    });
                },
                failure: function(err) {
                    Ext.getCmp("TabPanel1").body.unmask();
                    Ext.Msg.alert('Error', err);
                }
            });
        }

        var DoMoneyFormat = function() {
            Ext.select('input.money').each(function(tb) {
                Ext.getCmp(tb.dom.id).setValue(Ext.util.Format.number(tb.getValue(), '0,000.00'));
            });

            Ext.select('input.number').each(function(tb) {
                Ext.getCmp(tb.dom.id).setValue(Ext.util.Format.number(tb.getValue(), '0.00'));
            });
        }

        var ChangeYearMonth = function() {
            var cy = Ext.getCmp("tbSD26").getValue();
            var fy = Ext.getCmp("tbSE26").getValue();
            if (cy != '' && fy != '') {
                Ext.getCmp("TabPanel1").body.mask('Loading...', 'x-mask-loading');
                Coolite.AjaxMethods.Calculation({
                    success: function() {
                        Ext.getCmp("TabPanel1").body.unmask();

                        Ext.getCmp("tbSF27").setValue(Ext.getCmp("tbSE27").getValue());
                        Ext.getCmp("tbSF28").setValue(Ext.getCmp("tbSE28").getValue());
                        Ext.getCmp("tbSF29").setValue(Ext.getCmp("tbSE29").getValue());
                        Ext.getCmp("tbSF30").setValue(Ext.getCmp("tbSE30").getValue());
                        Ext.getCmp("tbSF32").setValue(Ext.getCmp("tbSE32").getValue());
                        Ext.getCmp("tbSF33").setValue(Ext.getCmp("tbSE33").getValue());
                        Ext.getCmp("tbSF34").setValue(Ext.getCmp("tbSE34").getValue());
                        Ext.getCmp("tbSF35").setValue(Ext.getCmp("tbSE35").getValue());
                        Ext.getCmp("tbSF36").setValue(Ext.getCmp("tbSE36").getValue());

                        DoMoneyFormat();
                    },
                    failure: function(err) {
                        Ext.getCmp("TabPanel1").body.unmask();
                        Ext.Msg.alert('Error', err);
                    }
                });
            }
        }

        var IsFormValid = function() {
            var i = 0;
            Ext.select('.require').each(function(tb) {
                if (!Ext.getCmp(tb.dom.id).validate())
                    i++;
            });
            return i == 0;
        }

        var reloadFlag1 = false;
        var reloadFlag2 = false;
        var lastQuery = '';

        var StatementView = function() {
            //alert(Ext.getCmp("cbYearMonth1").getValue());
            Ext.getCmp('Tab3').autoLoad.url = 'DPStatementView.aspx?dealerid=' + Ext.getCmp('hidDealerId').getValue() + '&ym1=' + Ext.getCmp("cbYearMonth1").getValue() + '&ym2=' + Ext.getCmp("cbYearMonth2").getValue() + '&ym3=' + Ext.getCmp("cbYearMonth3").getValue() + '&ym4=' + Ext.getCmp("cbYearMonth4").getValue() + '&ym5=' + Ext.getCmp("cbYearMonth5").getValue();
            Ext.getCmp('Tab3').reload();
            Ext.getCmp('Tab4').autoLoad.url = 'DPRatioView.aspx?dealerid=' + Ext.getCmp('hidDealerId').getValue() + '&ym1=' + Ext.getCmp("cbYearMonth1").getValue() + '&ym2=' + Ext.getCmp("cbYearMonth2").getValue() + '&ym3=' + Ext.getCmp("cbYearMonth3").getValue() + '&ym4=' + Ext.getCmp("cbYearMonth4").getValue() + '&ym5=' + Ext.getCmp("cbYearMonth5").getValue();
            Ext.getCmp('Tab5').autoLoad.url = 'DPCashFlowView.aspx?dealerid=' + Ext.getCmp('hidDealerId').getValue() + '&ym1=' + Ext.getCmp("cbYearMonth1").getValue() + '&ym2=' + Ext.getCmp("cbYearMonth2").getValue() + '&ym3=' + Ext.getCmp("cbYearMonth3").getValue() + '&ym4=' + Ext.getCmp("cbYearMonth4").getValue() + '&ym5=' + Ext.getCmp("cbYearMonth5").getValue();

            var currentQuery = Ext.getCmp("cbYearMonth1").getValue() + Ext.getCmp("cbYearMonth2").getValue() + Ext.getCmp("cbYearMonth3").getValue() + Ext.getCmp("cbYearMonth4").getValue() + Ext.getCmp("cbYearMonth5").getValue();
            //alert("last:" + lastQuery + "\t current:" + currentQuery);
            reloadFlag1 = (lastQuery != currentQuery);
            reloadFlag2 = (lastQuery != currentQuery);

            lastQuery = currentQuery;
        }
    </script>

    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="DoMoneyFormat();" />
        </Listeners>
    </ext:ScriptManager>
    <ext:Store ID="YearMonthStore" runat="server" UseIdConfirmation="true" OnRefreshData="YearMonthStore_RefreshData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="YearMonth">
                <Fields>
                    <ext:RecordField Name="YearMonth" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hidInstanceId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidDealerId" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <Center>
                    <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true" TabPosition="Bottom">
                        <Tabs>
                            <ext:Tab ID="Tab1" runat="server" Title="Definition" BodyStyle="padding: 0px;" AutoScroll="true"
                                Frame="true" Hidden="true">
                                <Body>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="Tab2" runat="server" Title="Finance Scorecard" BodyStyle="padding: 0px;"
                                AutoScroll="true" Frame="true">
                                <Body>
                                    <ext:TableLayout ID="TableLayout1" runat="server" Columns="1">
                                        <%--TABLE 1--%>
                                        <ext:Cell>
                                            <ext:Panel ID="Panel181" runat="server" Header="false" Border="false" Width="980">
                                                <Body>
                                                    <ext:TableLayout ID="TableLayout8" runat="server" Columns="1">
                                                        <ext:Cell CellCls="td-left td-label td-right td-bottom">
                                                            <ext:Panel ID="Panel182" runat="server" Header="false" Border="false" BodyStyle="padding:5px; text-align:center;"
                                                                Width="805" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label80" runat="server" Html="<b>经销商财务风险评估</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                    </ext:TableLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Cell>
                                        <%--TABLE 1--%>
                                        <ext:Cell>
                                            <ext:Panel ID="Panel3" runat="server" Header="false" Border="false" Width="980">
                                                <Body>
                                                    <ext:TableLayout ID="TableLayout2" runat="server" Columns="6">
                                                        <%--ROW 1--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label19" runat="server" Html="<b>客户编码</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell ColSpan="5" CellCls="td-right">
                                                            <ext:Panel ID="Panel2" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="704" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbDealerCode" runat="server" ReadOnly="true" Cls="noborder" Width="500"
                                                                        Text="">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 2--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel4" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label1" runat="server" Html="<b>公司名称</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell ColSpan="5" CellCls="td-right">
                                                            <ext:Panel ID="Panel5" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="704" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbDealerName" runat="server" ReadOnly="true" Cls="noborder" Width="500"
                                                                        Text="">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 3--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel6" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label2" runat="server" Html="<b>审核日期</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell ColSpan="5" CellCls="td-right">
                                                            <ext:Panel ID="Panel7" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="704" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbCreateDate" runat="server" ReadOnly="true" Cls="noborder" Width="500"
                                                                        Text="">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 4--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel8" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label3" runat="server" Html="<b>风险指数</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel9" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSC06" runat="server" ReadOnly="true" Cls="noborder" Width="90"
                                                                        Text="">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel10" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSD06" runat="server" ReadOnly="true" Cls="noborder" Width="190"
                                                                        Text="">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell ColSpan="2" CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel11" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="201" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label6" runat="server" Html="<b>最高付款条件</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel12" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG06" runat="server" ReadOnly="true" Cls="noborder" Width="190"
                                                                        Text="">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 5--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel13" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label7" runat="server" Html="<b>付款条件建议</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel14" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:ComboBox ID="tbSC07" runat="server" Width="90" Editable="false" AllowBlank="false"
                                                                        Cls="require">
                                                                        <Items>
                                                                            <ext:ListItem Text="COD" Value="0" />
                                                                            <ext:ListItem Text="30" Value="30" />
                                                                            <ext:ListItem Text="60" Value="60" />
                                                                            <ext:ListItem Text="90" Value="90" />
                                                                            <ext:ListItem Text="120" Value="120" />
                                                                            <ext:ListItem Text="150" Value="150" />
                                                                            <ext:ListItem Text="180" Value="180" />
                                                                        </Items>
                                                                        <Triggers>
                                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                        </Triggers>
                                                                        <Listeners>
                                                                            <TriggerClick Handler="this.clearValue();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel15" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label9" runat="server" Text="NET">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell ColSpan="2" CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel16" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="201" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label10" runat="server" Html="<b>季度销量预期</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel17" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG07" runat="server" Cls="money require" MaskRe="/[\-0-9\.,]/"
                                                                        Width="150" AllowBlank="false" Vtype="money" VtypeText="请输入金额">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 6--%>
                                                        <ext:Cell CellCls="td-label td-left td-bottom">
                                                            <ext:Panel ID="Panel18" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label8" runat="server" Html="<b>付款额度建议</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left td-bottom">
                                                            <ext:Panel ID="Panel19" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="lbCurrency1" runat="server" Text="人民币">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left td-bottom">
                                                            <ext:Panel ID="Panel20" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSD08" runat="server" ReadOnly="true" Cls="money noborder" Width="150"
                                                                        Text="">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-label td-left td-bottom">
                                                            <ext:Panel ID="Panel21" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label12" runat="server" Html="<b>年销量预期</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left td-bottom">
                                                            <ext:Panel ID="Panel23" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="lbCurrency2" runat="server" Text="人民币">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right td-bottom">
                                                            <ext:Panel ID="Panel22" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG08" runat="server" Cls="money require" MaskRe="/[\-0-9\.,]/"
                                                                        Width="150" AllowBlank="false" Vtype="money" VtypeText="请输入金额">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                    </ext:TableLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Cell>
                                        <%--TABLE 2--%>
                                        <ext:Cell>
                                            <ext:Panel ID="Panel24" runat="server" Header="false" Border="false" Width="980">
                                                <Body>
                                                    <ext:TableLayout ID="TableLayout3" runat="server" Columns="2">
                                                        <%--ROW 1--%>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel25" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label4" runat="server" Html="<b>Risk Scorecard</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel26" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSC12" runat="server" ReadOnly="true" Cls="noborder number"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                    </ext:TableLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Cell>
                                        <%--TABLE 3--%>
                                        <ext:Cell>
                                            <ext:Panel ID="Panel27" runat="server" Header="false" Border="false" Width="980">
                                                <Body>
                                                    <ext:TableLayout ID="TableLayout4" runat="server" Columns="3">
                                                        <%--ROW 1--%>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel28" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="300" Height="20">
                                                                <Body>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel29" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label11" runat="server" Text="Percentage">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel50" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label31" runat="server" Text="Score">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 2--%>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel30" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="300" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label13" runat="server" Html="Total Weighted Score on Basic Information">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel31" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label14" runat="server" Text="20%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel32" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF14" runat="server" ReadOnly="true" Cls="noborder number"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 3--%>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel33" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="300" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label5" runat="server" Html="Total Weighted Score on Financial Analysis">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel34" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label15" runat="server" Text="45%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel35" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF15" runat="server" ReadOnly="true" Cls="noborder number"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 4--%>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel36" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="300" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label17" runat="server" Html="Total Weighted Score on History Tansactions">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel37" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label18" runat="server" Text="35%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel38" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF16" runat="server" ReadOnly="true" Cls="noborder number"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                    </ext:TableLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Cell>
                                        <%--TABLE 4--%>
                                        <ext:Cell>
                                            <ext:Panel ID="Panel39" runat="server" Header="false" Border="false" Width="980">
                                                <Body>
                                                    <ext:TableLayout ID="TableLayout5" runat="server" Columns="5">
                                                        <%--ROW 1--%>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel40" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label16" runat="server" Html="<b>基础信息</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel41" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel63" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label20" runat="server" Html="<u>情况</u>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel64" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label39" runat="server" Html="<u>评估结果</u>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel65" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label40" runat="server" Html="<u>分数</u>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 2--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel42" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label21" runat="server" Html="员工人数">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel67" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label42" runat="server" Text="15%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel43" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD19" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="false" Width="150" MinValue="1">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel66" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSE19" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel68" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF19" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 3--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel44" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label22" runat="server" Html="公司性质">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel45" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label23" runat="server" Text="25%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel46" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:ComboBox ID="tbSD20" runat="server" Width="190" Editable="false" AllowBlank="false"
                                                                        Cls="require">
                                                                        <Items>
                                                                            <ext:ListItem Text="Proprietorship/Partnership" Value="Proprietorship/Partnership" />
                                                                            <ext:ListItem Text="Private Corporation" Value="Private Corporation" />
                                                                            <ext:ListItem Text="Public Listed" Value="Public Listed" />
                                                                            <ext:ListItem Text="Government Owned" Value="Government Owned" />
                                                                            <ext:ListItem Text="Global Company" Value="Global Company" />
                                                                        </Items>
                                                                        <Triggers>
                                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                        </Triggers>
                                                                        <Listeners>
                                                                            <TriggerClick Handler="this.clearValue();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel47" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSE20" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel48" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF20" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 4--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel49" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label26" runat="server" Html="注册资本">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel51" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label27" runat="server" Text="25%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel52" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSD21" runat="server" Cls="money require" MaskRe="/[\-0-9\.,]/"
                                                                        Width="150" AllowBlank="false" Vtype="money" VtypeText="请输入金额">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel53" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSE21" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel54" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF21" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 5--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel55" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label30" runat="server" Html="经营年限">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel56" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label32" runat="server" Text="15%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel57" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD22" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="false" Width="150">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel58" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSE22" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel59" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF22" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 6--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel60" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label35" runat="server" Html="管理能力">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel61" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label36" runat="server" Text="25%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel62" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:ComboBox ID="tbSD23" runat="server" Width="190" Editable="false" AllowBlank="false"
                                                                        Cls="require">
                                                                        <Items>
                                                                            <ext:ListItem Text="Inefficient" Value="Inefficient" />
                                                                            <ext:ListItem Text="Below Average" Value="Below Average" />
                                                                            <ext:ListItem Text="Average" Value="Average" />
                                                                            <ext:ListItem Text="Above Average" Value="Above Average" />
                                                                            <ext:ListItem Text="Efficient" Value="Efficient" />
                                                                        </Items>
                                                                        <Triggers>
                                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                        </Triggers>
                                                                        <Listeners>
                                                                            <TriggerClick Handler="this.clearValue();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel69" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSE23" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel70" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF23" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 7--%>
                                                        <ext:Cell CellCls="td-left td-label td-bottom">
                                                            <ext:Panel ID="Panel71" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label24" runat="server" Html="Sub-Total">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left td-bottom">
                                                            <ext:Panel ID="Panel72" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label25" runat="server" Text="100%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell ColSpan="2" CellCls="td-left td-bottom">
                                                            <ext:Panel ID="Panel73" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="301" Height="30">
                                                                <Body>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right td-bottom">
                                                            <ext:Panel ID="Panel75" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF24" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                    </ext:TableLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Cell>
                                        <%--TABLE 5--%>
                                        <ext:Cell>
                                            <ext:Panel ID="Panel74" runat="server" Header="false" Border="false" Width="980">
                                                <Body>
                                                    <ext:TableLayout ID="TableLayout6" runat="server" Columns="7">
                                                        <%--ROW 1--%>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel76" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label28" runat="server" Html="<b>财务分析</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel77" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel78" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:ComboBox ID="tbSD26" runat="server" Mode="Local" StoreID="YearMonthStore" DisplayField="YearMonth"
                                                                        ValueField="YearMonth" EmptyText="请选择年月" Width="90" Editable="false" AllowBlank="false"
                                                                        Cls="require">
                                                                        <Listeners>
                                                                            <Select Handler="ChangeYearMonth();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel79" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:ComboBox ID="tbSE26" runat="server" Mode="Local" StoreID="YearMonthStore" DisplayField="YearMonth"
                                                                        ValueField="YearMonth" EmptyText="请选择年月" Width="90" Editable="false" AllowBlank="false"
                                                                        Cls="require">
                                                                        <Listeners>
                                                                            <Select Handler="ChangeYearMonth();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel80" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label34" runat="server" Html="<u>调整</u>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel101" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label48" runat="server" Html="<u>评估结果</u>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel102" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label49" runat="server" Html="<u>分数</u>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 2--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel81" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label37" runat="server" Html="Z-Score">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel82" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label38" runat="server" Text="35%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel83" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD27" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel84" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSE27" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel85" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF27" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="true" DecimalPrecision="2" Width="90">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel103" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG27" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel104" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSH27" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 3--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel86" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label41" runat="server" Html="流动比率">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel87" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label43" runat="server" Text="10%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel88" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD28" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel89" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSE28" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel90" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF28" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="true" DecimalPrecision="2" Width="90">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel91" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG28" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel92" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSH28" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 4--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel93" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label44" runat="server" Html="现金比率">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel94" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label45" runat="server" Text="10%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel95" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD29" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel96" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSE29" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel97" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF29" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="true" DecimalPrecision="2" Width="90">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel98" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG29" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel99" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSH29" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 5--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel100" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="40">
                                                                <Body>
                                                                    <ext:Label ID="Label46" runat="server" Html="Financing Surplus (Requirement)/Total AR">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel105" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label47" runat="server" Text="10%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel106" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel107" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSE30" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel108" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF30" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="true" DecimalPrecision="2" Width="90">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel109" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG30" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel110" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSH30" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 6--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel111" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label50" runat="server" Html="负债/股本">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel112" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label51" runat="server" Text="10%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel113" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD32" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel114" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSE32" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel115" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF32" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="true" DecimalPrecision="2" Width="90">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel116" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG32" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel117" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSH32" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 7--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel118" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label52" runat="server" Html="息税前利润/利息">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel119" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label53" runat="server" Text="5%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel120" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD33" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel121" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSE33" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel122" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF33" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="true" DecimalPrecision="2" Width="90">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel123" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG33" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel124" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSH33" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 8--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel125" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label54" runat="server" Html="存货周转天数">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel126" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label55" runat="server" Text="5%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel127" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD34" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel128" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSE34" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel129" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF34" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="true" DecimalPrecision="2" Width="90">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel130" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG34" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel131" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSH34" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 9--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel132" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label56" runat="server" Html="融资天数">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel133" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label57" runat="server" Text="5%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel134" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD35" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel135" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSE35" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel136" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF35" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="true" DecimalPrecision="2" Width="90">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel137" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG35" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel138" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSH35" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 10--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel139" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label58" runat="server" Html="股本收益率">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel140" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label59" runat="server" Text="10%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel141" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD36" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel142" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSE36" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel143" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF36" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="true" DecimalPrecision="2" Width="90">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel144" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSG36" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel145" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSH36" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 11--%>
                                                        <ext:Cell CellCls="td-left td-label td-bottom">
                                                            <ext:Panel ID="Panel146" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label60" runat="server" Html="Sub-Total">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left td-bottom">
                                                            <ext:Panel ID="Panel147" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label61" runat="server" Text="100%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left td-bottom" ColSpan="4">
                                                            <ext:Panel ID="Panel148" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="403" Height="30">
                                                                <Body>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right td-bottom">
                                                            <ext:Panel ID="Panel152" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSH37" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                    </ext:TableLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Cell>
                                        <%--TABLE 6--%>
                                        <ext:Cell>
                                            <ext:Panel ID="Panel149" runat="server" Header="false" Border="false" Width="980">
                                                <Body>
                                                    <ext:TableLayout ID="TableLayout7" runat="server" Columns="5">
                                                        <%--ROW 1--%>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel150" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label62" runat="server" Html="<b>付款情况</b>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel151" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel153" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label63" runat="server" Html="<u>情况</u>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel154" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label64" runat="server" Html="<u>评估结果</u>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell>
                                                            <ext:Panel ID="Panel155" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="20">
                                                                <Body>
                                                                    <ext:Label ID="Label65" runat="server" Html="<u>分数</u>">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 2--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel156" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label66" runat="server" Html="平均延迟付款天数">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel157" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label67" runat="server" Text="40%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel158" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD40" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="false" Width="90">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel159" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSE40" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel160" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF40" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 3--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel161" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label68" runat="server" Html="应付账款周转天数">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel162" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label69" runat="server" Text="30%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel163" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD41" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel164" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSE41" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel165" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF41" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 4--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel166" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label70" runat="server" Html="和波科合作年数">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel167" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label71" runat="server" Text="10%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel168" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSD42" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel169" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSE42" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel170" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF42" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 5--%>
                                                        <ext:Cell CellCls="td-left td-label">
                                                            <ext:Panel ID="Panel171" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label72" runat="server" Html="和其他公司合作付款延迟天数">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel172" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label73" runat="server" Text="20%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel173" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSD43" runat="server" Cls="number require" AllowBlank="false"
                                                                        AllowDecimals="false" Width="90">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left">
                                                            <ext:Panel ID="Panel174" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:TextField ID="tbSE43" runat="server" ReadOnly="true" Cls="number noborder" Width="90">
                                                                    </ext:TextField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right">
                                                            <ext:Panel ID="Panel175" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF43" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <%--ROW 6--%>
                                                        <ext:Cell CellCls="td-left td-label td-bottom">
                                                            <ext:Panel ID="Panel176" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="200" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label74" runat="server" Html="Sub-Total">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-left td-bottom">
                                                            <ext:Panel ID="Panel177" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:Label ID="Label75" runat="server" Text="100%">
                                                                    </ext:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell ColSpan="2" CellCls="td-left td-bottom">
                                                            <ext:Panel ID="Panel178" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="201" Height="30">
                                                                <Body>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Cell>
                                                        <ext:Cell CellCls="td-right td-bottom">
                                                            <ext:Panel ID="Panel179" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                                Width="100" Height="30">
                                                                <Body>
                                                                    <ext:NumberField ID="tbSF44" runat="server" ReadOnly="true" Cls="number noborder"
                                                                        Width="90" AllowDecimals="true" DecimalPrecision="2">
                                                                    </ext:NumberField>
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
                                            <ext:ToolbarButton ID="btnCalculation" runat="server" Text="重新计算" Icon="Calculator">
                                                <Listeners>
                                                    <Click Handler="DoCalculation();" />
                                                </Listeners>
                                            </ext:ToolbarButton>
                                            <ext:ToolbarButton ID="btnSave" runat="server" Text="保存" Icon="Disk">
                                                <Listeners>
                                                    <Click Handler="DoSave();" />
                                                </Listeners>
                                            </ext:ToolbarButton>
                                            <ext:ToolbarButton ID="Btn_export" runat="server" Text="导出" Icon="Disk"
                                                AutoPostBack="true" OnClick="ExportExcel">
                                            </ext:ToolbarButton>
                                        </Items>
                                    </ext:Toolbar>
                                </BottomBar>
                            </ext:Tab>
                            <ext:Tab ID="Tab3" runat="server" Title="Statements" BodyStyle="padding: 0px;" AutoScroll="true"
                                Frame="true">
                                <AutoLoad Mode="IFrame" ShowMask="true" Url="DPStatementView.aspx" MaskMsg="Loading Statements">
                                </AutoLoad>
                                <TopBar>
                                    <ext:Toolbar ID="Toolbar2" runat="server">
                                        <Items>
                                            <ext:Label ID="Label29" runat="server" Text="月份1：">
                                            </ext:Label>
                                            <ext:ComboBox ID="cbYearMonth1" runat="server" Width="90" Mode="Local" Editable="false"
                                                StoreID="YearMonthStore" DisplayField="YearMonth" ValueField="YearMonth">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                </Triggers>
                                                <Listeners>
                                                    <TriggerClick Handler="this.clearValue();" />
                                                </Listeners>
                                            </ext:ComboBox>
                                            <ext:ToolbarSpacer Width="10">
                                            </ext:ToolbarSpacer>
                                            <ext:Label ID="Label33" runat="server" Text="月份2：">
                                            </ext:Label>
                                            <ext:ComboBox ID="cbYearMonth2" runat="server" Width="90" Mode="Local" Editable="false"
                                                StoreID="YearMonthStore" DisplayField="YearMonth" ValueField="YearMonth">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                </Triggers>
                                                <Listeners>
                                                    <TriggerClick Handler="this.clearValue();" />
                                                </Listeners>
                                            </ext:ComboBox>
                                            <ext:ToolbarSpacer Width="10">
                                            </ext:ToolbarSpacer>
                                            <ext:Label ID="Label76" runat="server" Text="月份3：">
                                            </ext:Label>
                                            <ext:ComboBox ID="cbYearMonth3" runat="server" Width="90" Mode="Local" Editable="false"
                                                StoreID="YearMonthStore" DisplayField="YearMonth" ValueField="YearMonth">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                </Triggers>
                                                <Listeners>
                                                    <TriggerClick Handler="this.clearValue();" />
                                                </Listeners>
                                            </ext:ComboBox>
                                            <ext:ToolbarSpacer Width="10">
                                            </ext:ToolbarSpacer>
                                            <ext:Label ID="Label77" runat="server" Text="月份4：">
                                            </ext:Label>
                                            <ext:ComboBox ID="cbYearMonth4" runat="server" Width="90" Mode="Local" Editable="false"
                                                StoreID="YearMonthStore" DisplayField="YearMonth" ValueField="YearMonth">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                </Triggers>
                                                <Listeners>
                                                    <TriggerClick Handler="this.clearValue();" />
                                                </Listeners>
                                            </ext:ComboBox>
                                            <ext:ToolbarSpacer Width="10">
                                            </ext:ToolbarSpacer>
                                            <ext:Label ID="Label78" runat="server" Text="月份5：">
                                            </ext:Label>
                                            <ext:ComboBox ID="cbYearMonth5" runat="server" Width="90" Mode="Local" Editable="false"
                                                StoreID="YearMonthStore" DisplayField="YearMonth" ValueField="YearMonth">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                </Triggers>
                                                <Listeners>
                                                    <TriggerClick Handler="this.clearValue();" />
                                                </Listeners>
                                            </ext:ComboBox>
                                            <ext:ToolbarSpacer Width="10">
                                            </ext:ToolbarSpacer>
                                            <ext:ToolbarButton ID="btnRefresh" runat="server" Text="查看" Icon="Magnifier">
                                                <Listeners>
                                                    <Click Handler="StatementView();" />
                                                </Listeners>
                                            </ext:ToolbarButton>
                                        </Items>
                                    </ext:Toolbar>
                                </TopBar>
                            </ext:Tab>
                            <ext:Tab ID="Tab4" runat="server" Title="Ratios" BodyStyle="padding: 0px;" AutoScroll="true"
                                Frame="true">
                                <AutoLoad Mode="IFrame" ShowMask="true" Url="DPRatioView.aspx" MaskMsg="Loading Ratios">
                                </AutoLoad>
                                <Listeners>
                                    <Activate Handler="if (reloadFlag1) {reloadFlag1 = false; this.reload();}" />
                                </Listeners>
                            </ext:Tab>
                            <ext:Tab ID="Tab5" runat="server" Title="Cashflow" BodyStyle="padding: 0px;" AutoScroll="true"
                                Frame="true">
                                <AutoLoad Mode="IFrame" ShowMask="true" Url="DPCashFlowView.aspx" MaskMsg="Loading Cashflow">
                                </AutoLoad>
                                <Listeners>
                                    <Activate Handler="if (reloadFlag2) {reloadFlag2 = false; this.reload();}" />
                                </Listeners>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>
</body>
</html>
