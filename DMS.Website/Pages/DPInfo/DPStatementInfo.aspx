<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DPStatementInfo.aspx.cs"
    Inherits="DMS.Website.Pages.DPInfo.DPStatementInfo" %>

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
        .money
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

        var ReCal = function(o) {
            var val = o.getValue().replace(/[,]/g, '');
            //alert(val);
            if (isNaN(val)) {
                Ext.Msg.alert('Error', '金额格式不正确');
                return;
            }
            Ext.getCmp("Panel5").body.mask('Loading...', 'x-mask-loading');
            Coolite.AjaxMethods.Calculation({
                success: function() {
                    Ext.getCmp("Panel5").body.unmask();
                    DoMoneyFormat();
                },
                failure: function(err) {
                    Ext.getCmp("Panel5").body.unmask();
                    Ext.Msg.alert('Error', err);
                }
            });
        }

        var DoSubmit = function() {
            var isValid = Ext.getCmp("FormPanel1").getForm().isValid();
            if (!isValid) {
                Ext.Msg.alert('Message', "年份、月份和币种必须填写完整！");
                return;
            }
            Ext.getCmp("Panel5").body.mask('Loading...', 'x-mask-loading');
            Coolite.AjaxMethods.Submit({
                success: function() {
                    Ext.getCmp("Panel5").body.unmask();
                    Ext.Msg.alert("注意", "提交成功", function() {
                        window.parent.closeTab('subMenuDPStatement_' + (Ext.getCmp("hidIsPageNew").getValue() == 'True' ? '00000000-0000-0000-0000-000000000000' : Ext.getCmp("hidInstanceId").getValue()));
                    });
                },
                failure: function(err) {
                    Ext.getCmp("Panel5").body.unmask();
                    Ext.Msg.alert('Error', err);
                }
            });
        }

        var DoSave = function() {
            Ext.getCmp("Panel5").body.mask('Loading...', 'x-mask-loading');
            Coolite.AjaxMethods.Save({
                success: function() {
                    Ext.getCmp("Panel5").body.unmask();
                    Ext.Msg.alert("注意", "更新成功", function() {
                        window.parent.closeTab('subMenuDPStatement_' + (Ext.getCmp("hidIsPageNew").getValue() == 'True' ? '00000000-0000-0000-0000-000000000000' : Ext.getCmp("hidInstanceId").getValue()));
                    });
                },
                failure: function(err) {
                    Ext.getCmp("Panel5").body.unmask();
                    Ext.Msg.alert('Error', err);
                }
            });
        }

        var DoShowHistory = function(key) {
            Coolite.AjaxMethods.ShowHistory(key, {
                success: function() {
                    Ext.getCmp('<%=this.PagingToolBarHistory.ClientID%>').changePage(1);
                },
                failure: function(err) {
                    Ext.Msg.alert('Error', err);
                }
            });
        }

        var DoMoneyFormat = function() {
            Ext.select('input.money').each(function(tb) {
                Ext.getCmp(tb.dom.id).setValue(Ext.util.Format.number(tb.getValue(), '0,000.00'));
            });
        }

        function SelectValue(e) {
            var filterField = 'ChineseShortName';  //需进行模糊查询的字段
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

    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="DoMoneyFormat();" />
        </Listeners>
    </ext:ScriptManager>
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
            <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
        </ext:Store>
    <ext:Store ID="MonthStore" runat="server" UseIdConfirmation="true" OnRefreshData="MonthStore_RefreshData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Month">
                <Fields>
                    <ext:RecordField Name="Month" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <BaseParams>
            <ext:Parameter Name="Year" Value="#{cbYear}.getValue()" Mode="Raw" />
            <ext:Parameter Name="DealerId" Value="#{tbDealer}.getValue()" Mode="Raw" />
        </BaseParams>
    </ext:Store>
    <ext:Hidden ID="hidInstanceId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidIsPageNew" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidShowHistoryKey" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:FormPanel ID="FormPanel1" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn ColumnWidth=".2">
                                    <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="50">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="tbDealer" runat="server" EmptyText="请选择经销商"
                                                            Width="200" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                                            DisplayField="ChineseShortName" FieldLabel="经销商"
                                                            ListWidth="300" Resizable="true" Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();#{cbMonth}.clearValue();#{MonthStore}.reload();" />
                                                                <Change Handler="#{cbMonth}.clearValue();#{MonthStore}.reload();" />
                                                                <BeforeQuery Fn="SelectValue" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".15">
                                    <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="40">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbCurrency" runat="server" EmptyText="请选择币种" Width="150" Editable="false"
                                                        TypeAhead="true" FieldLabel="币种" AllowBlank="false">
                                                        <Items>
                                                            <ext:ListItem Text="人民币" Value="人民币" />
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
                                <ext:LayoutColumn ColumnWidth=".15">
                                    <ext:Panel ID="Panel2" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="40">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbYear" runat="server" EmptyText="请选择年份" Mode="Local" Width="150"
                                                        Editable="false" FieldLabel="年份" AllowBlank="false">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();#{cbMonth}.clearValue();" />
                                                            <Select Handler="#{cbMonth}.clearValue();#{cbMonth}.store.reload();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".15">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="40">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbMonth" runat="server" EmptyText="请选择月份" StoreID="MonthStore"
                                                        DisplayField="Month" ValueField="Month" Width="150" Editable="false" FieldLabel="月份"
                                                        AllowBlank="false">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();#{tbC09}.setValue('');" />
                                                            <Select Handler="Coolite.AjaxMethods.GetDays();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".1">
                                    <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="30">
                                                <ext:Anchor>
                                                    <ext:TextField ID="tbC09" runat="server" FieldLabel="天数" Width="80" AllowDecimals="false"
                                                        DecimalPrecision="0" Disabled="true" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".25">
                                    <ext:Panel ID="Panel13" runat="server" Border="false" Header="false">
                                        <Body>
                                        </Body>
                                        <Buttons>
                                            <ext:Button ID="btnSubmit" Text="提交" runat="server" Icon="Disk" IDMode="Legacy">
                                                <Listeners>
                                                    <Click Handler="DoSubmit();" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnSave" Text="更新" runat="server" Icon="Disk" IDMode="Legacy">
                                                <Listeners>
                                                    <Click Handler="DoSave();" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnClose" runat="server" Text="关闭" Icon="Delete" IDMode="Legacy">
                                                <Listeners>
                                                    <Click Handler="window.parent.closeTab('subMenuDPStatement_' + (#{hidIsPageNew}.getValue()=='True'?'00000000-0000-0000-0000-000000000000':#{hidInstanceId}.getValue()));" />
                                                </Listeners>
                                            </ext:Button>
                                        </Buttons>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:FormPanel>
                </North>
                <Center MarginsSummary="0 5 5 5">
                    <ext:Panel ID="Panel5" runat="server" Height="300">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false" Frame="true">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout3" runat="server" Split="false">
                                            <ext:LayoutColumn ColumnWidth="0.75">
                                                <ext:Panel ID="Panel4" runat="server" Border="false" Title="资产负债表" BodyStyle="padding: 5px;">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout1" runat="server" Split="false">
                                                            <ext:LayoutColumn ColumnWidth="0.33">
                                                                <ext:Panel ID="Panel6" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left">
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField2" runat="server" FieldLabel="货币资金">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC11" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money" MaskRe="/[\-0-9\.,]/">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar2" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC11" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C11')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField3" runat="server" FieldLabel="短期投资">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC12" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar3" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC12" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C12')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField4" runat="server" FieldLabel="应收票据">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC13" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar4" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC13" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C13')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField5" runat="server" FieldLabel="应收账款">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC14" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar5" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC14" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C14')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField6" runat="server" FieldLabel="存货">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC15" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar6" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC15" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C15')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField7" runat="server" FieldLabel="预付账款">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC16" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar7" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC16" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C16')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField8" runat="server" FieldLabel="其他流动资产">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC17" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar8" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC17" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C17')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField9" runat="server" FieldLabel="<b>流动资产总计</b>">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC18" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            ReadOnly="true" Cls="money noborder" Width="120">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar9" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC18" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C18')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField10" runat="server" FieldLabel="固定资产净值">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC20" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar10" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC20" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C20')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField11" runat="server" FieldLabel="长期投资">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC21" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar11" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC21" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C21')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField12" runat="server" FieldLabel="无形资产">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC22" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar12" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC22" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C22')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField13" runat="server" FieldLabel="递延税款">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC23" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar13" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC23" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C23')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField14" runat="server" FieldLabel="其他长期流动资产">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC24" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar14" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC24" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C24')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField15" runat="server" FieldLabel="<b>资产总计</b>">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC25" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            ReadOnly="true" Cls="money noborder" Width="120">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar15" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC25" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C25')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth="0.33">
                                                                <ext:Panel ID="Panel9" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left">
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField16" runat="server" FieldLabel="应付票据">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC27" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar16" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC27" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C27')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField17" runat="server" FieldLabel="短期借款">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC28" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar17" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC28" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C28')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField18" runat="server" FieldLabel="应付账款">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC29" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar18" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC29" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C29')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField19" runat="server" FieldLabel="预收账款">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC30" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar19" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC30" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C30')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField20" runat="server" FieldLabel="应交税金">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC31" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar20" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC31" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C31')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField21" runat="server" FieldLabel="应付利息">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC32" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar21" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC32" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C32')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField22" runat="server" FieldLabel="应付股利">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC33" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar22" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC33" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C33')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField23" runat="server" FieldLabel="其他流动负债">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC34" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar23" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC34" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C34')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField24" runat="server" FieldLabel="<b>流动负债总计</b>">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC35" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            ReadOnly="true" Cls="money noborder" Width="120">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar24" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC35" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C35')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField25" runat="server" FieldLabel="长期借款">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC37" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar25" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC37" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C37')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField26" runat="server" FieldLabel="其他长期负债">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC38" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar26" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC38" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C38')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField27" runat="server" FieldLabel="递延税款">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC39" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar27" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC39" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C39')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField28" runat="server" FieldLabel="<b>负债总计</b>">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC40" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            ReadOnly="true" Cls="money noborder" Width="120">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar28" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC40" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C40')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth="0.34">
                                                                <ext:Panel ID="Panel10" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left">
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField29" runat="server" FieldLabel="股本">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC42" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar29" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC42" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C42')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField30" runat="server" FieldLabel="少数股东权益">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC43" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar30" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC43" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C43')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField31" runat="server" FieldLabel="未分配利润">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC44" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar31" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC44" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C44')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField32" runat="server" FieldLabel="资本公积">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC45" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar32" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC45" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C45')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField33" runat="server" FieldLabel="其他调整项">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC46" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar33" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC46" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C46')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField34" runat="server" FieldLabel="<b>所有者权益</b>">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC47" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            ReadOnly="true" Cls="money noborder" Width="120">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar34" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC47" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C47')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth="0.25">
                                                <ext:Panel ID="Panel1" runat="server" Border="false" Title="利润表" BodyStyle="padding: 5px;">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout4" runat="server" Split="false">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel11" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="120">
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField35" runat="server" FieldLabel="销售收入">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC49" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar35" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC49" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C49')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField1" runat="server" FieldLabel="销售成本">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC50" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar1" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC50" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C50')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField36" runat="server" FieldLabel="<B>毛利</B>">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC51" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            ReadOnly="true" Cls="money noborder" Width="120">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar36" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC51" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C51')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField37" runat="server" FieldLabel="管理费用/营业费用">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC52" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar37" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC52" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C52')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField38" runat="server" FieldLabel="财务费用">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC53" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar38" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC53" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C53')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField39" runat="server" FieldLabel="<B>税前利润</B>">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC54" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            ReadOnly="true" Cls="money noborder" Width="120">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar39" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC54" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C54')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField40" runat="server" FieldLabel="其他调整项">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC55" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar40" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC55" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C55')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField41" runat="server" FieldLabel="所得税">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC56" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            Width="120" Cls="money">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar41" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC56" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C56')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                            <ext:Anchor>
                                                                                <ext:MultiField ID="MultiField42" runat="server" FieldLabel="<B>净利润</B>">
                                                                                    <Fields>
                                                                                        <ext:TextField ID="tbC57" runat="server" AllowDecimals="true" DecimalPrecision="2"
                                                                                            ReadOnly="true" Cls="money noborder" Width="120">
                                                                                            <Listeners>
                                                                                                <Change Fn="ReCal" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                        <ext:Toolbar ID="Toolbar42" runat="server" Cls="form-toolbar" Flat="true" Width="20">
                                                                                            <Items>
                                                                                                <ext:ToolbarButton ID="btnC57" runat="server" Icon="NoteEdit" Visible="false">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="DoShowHistory('C57')" />
                                                                                                    </Listeners>
                                                                                                </ext:ToolbarButton>
                                                                                            </Items>
                                                                                        </ext:Toolbar>
                                                                                    </Fields>
                                                                                </ext:MultiField>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:FormPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Store ID="HistoryStore" runat="server" OnRefreshData="HistoryStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ValueOld" />
                    <ext:RecordField Name="ValueNew" />
                    <ext:RecordField Name="CreateUser" />
                    <ext:RecordField Name="CreateDate" Type="Date" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <BaseParams>
            <ext:Parameter Name="Key" Value="#{hidShowHistoryKey}.getValue()" Mode="Raw">
            </ext:Parameter>
        </BaseParams>
    </ext:Store>
    <ext:Window ID="HistoryWindow" runat="server" Icon="NoteEdit" Title="修改记录" Width="550"
        Height="400" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false" CenterOnLoad="true" Y="10" Maximizable="false">
        <Body>
            <ext:BorderLayout ID="BorderLayout2" runat="server">
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel12" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout2" runat="server">
                                <ext:GridPanel ID="GridHistory" runat="server" StoreID="HistoryStore" Border="false"
                                    AutoWidth="true" StripeRows="true">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="ValueOld" DataIndex="ValueOld" Header="修改前" Width="120">
                                                <Renderer Fn="Ext.util.Format.numberRenderer('0,000.00')" />
                                            </ext:Column>
                                            <ext:Column ColumnID="ValueNew" DataIndex="ValueNew" Header="修改后" Width="120">
                                                <Renderer Fn="Ext.util.Format.numberRenderer('0,000.00')" />
                                            </ext:Column>
                                            <ext:Column ColumnID="CreateUser" DataIndex="CreateUser" Header="修改人" Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="修改时间" Width="150">
                                                <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBarHistory" runat="server" PageSize="15" StoreID="HistoryStore"
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
        <Listeners>
            <Hide Handler="#{GridHistory}.clear();" />
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
