<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractDealerHospitalProductAOPQuery.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractDealerHospitalProductAOPQuery" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>经销商指标设定</title>
    <style type="text/css">
        .x-grid3-col-Q2, .x-grid3-col-RefQ2, .x-grid3-col-Q4, .x-grid3-col-RefQ4, .x-grid3-col-DiffUnit1, .x-grid3-col-DiffUnit2, .x-grid3-col-DiffUnit3, .x-grid3-col-DiffUnit4, .x-grid3-col-DiffUnit5, .x-grid3-col-DiffUnit6, .x-grid3-col-DiffUnit7, .x-grid3-col-DiffUnit8, .x-grid3-col-DiffUnit9, .x-grid3-col-DiffUnit10, .x-grid3-col-DiffUnit11, .x-grid3-col-DiffUnit12
        {
            background-color: #EDEEF0;
        }
        .x-grid3-col-RefAmount2, .x-grid3-col-DiffAmount2, .x-grid3-col-AOPD_Amount_2, .x-grid3-col-RefAmount4, .x-grid3-col-DiffAmount4, .x-grid3-col-AOPD_Amount_4, .x-grid3-col-RefAmount6, .x-grid3-col-DiffAmount6, .x-grid3-col-AOPD_Amount_6, .x-grid3-col-RefAmount8, .x-grid3-col-DiffAmount8, .x-grid3-col-AOPD_Amount_8, .x-grid3-col-RefAmount10, .x-grid3-col-DiffAmount10, .x-grid3-col-AOPD_Amount_10, .x-grid3-col-RefAmount12, .x-grid3-col-DiffAmount12, .x-grid3-col-AOPD_Amount_12
        {
            background-color: #EDEEF0;
        }
        .x-grid3-col-RefYear, .x-grid3-col-UnitY, .x-grid3-col-AOPD_Amount_Y, .x-grid3-col-RefAmountTotal, .x-grid3-col-DiffAmountY
        {
            background-color: #BBFFBB;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });

        var ClosePage = function() {
            window.open('', '_self');
            window.close();
        }

        var Img = '<img src="{0}"></img>';
        var change = function(value) {
            if (value == 'New') {
                return String.format(Img, '/resources/images/icons/flag_ch.png');
            }
            else {
                return "";
            }
        }

        var Img2 = '<img src="{0}" alt="经销商指标小于医院指标或者大于医院指标的20%"></img>';
        var change2 = function(value) {
            if (value == '1') {
                return String.format(Img2, '/resources/images/icons/exclamation.png');
            }
            else {
                return "";
            }
        }

        var template = '<span style="color:{0};">{1}</span>';
        var changeValueSty = function(value) {
            return String.format(template, (value != 0) ? 'red' : 'green', value);
        }

        var template = '<span style="color:{0}; width:100%; margin:0 0 0 0; font-size:larger;">{1}</span>';
        var changeColumn1 = function(value) {
            return String.format(template, 'green', value);
        }
    </script>

    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Debug">
        </ext:ScriptManager>
        <ext:Store ID="AOPProductClassStore" runat="server" OnRefreshData="AOPProductClass_RefreshData"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="CQ_ID">
                    <Fields>
                        <ext:RecordField Name="CQ_ID" />
                        <ext:RecordField Name="CQ_NameCN" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:JsonStore ID="AOPStore" runat="server" UseIdConfirmation="false" OnRefreshData="AOPStore_RefershData"
            AutoLoad="true">
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={10}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="ProductName" />
                        <ext:RecordField Name="OperType" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="Year" />
                        <ext:RecordField Name="Unit1" />
                        <ext:RecordField Name="Unit2" />
                        <ext:RecordField Name="Unit3" />
                        <ext:RecordField Name="Unit4" />
                        <ext:RecordField Name="Unit5" />
                        <ext:RecordField Name="Unit6" />
                        <ext:RecordField Name="Unit7" />
                        <ext:RecordField Name="Unit8" />
                        <ext:RecordField Name="Unit9" />
                        <ext:RecordField Name="Unit10" />
                        <ext:RecordField Name="Unit11" />
                        <ext:RecordField Name="Unit12" />
                        <ext:RecordField Name="Q1" />
                        <ext:RecordField Name="Q2" />
                        <ext:RecordField Name="Q3" />
                        <ext:RecordField Name="Q4" />
                        <ext:RecordField Name="UnitY" />
                        <ext:RecordField Name="RefUnit1" />
                        <ext:RecordField Name="RefUnit2" />
                        <ext:RecordField Name="RefUnit3" />
                        <ext:RecordField Name="RefUnit4" />
                        <ext:RecordField Name="RefUnit5" />
                        <ext:RecordField Name="RefUnit6" />
                        <ext:RecordField Name="RefUnit7" />
                        <ext:RecordField Name="RefUnit8" />
                        <ext:RecordField Name="RefUnit9" />
                        <ext:RecordField Name="RefUnit10" />
                        <ext:RecordField Name="RefUnit11" />
                        <ext:RecordField Name="RefUnit12" />
                        <ext:RecordField Name="RefQ1" />
                        <ext:RecordField Name="RefQ2" />
                        <ext:RecordField Name="RefQ3" />
                        <ext:RecordField Name="RefQ4" />
                        <ext:RecordField Name="RefYear" />
                        <ext:RecordField Name="DiffUnit1" />
                        <ext:RecordField Name="DiffUnit2" />
                        <ext:RecordField Name="DiffUnit3" />
                        <ext:RecordField Name="DiffUnit4" />
                        <ext:RecordField Name="DiffUnit5" />
                        <ext:RecordField Name="DiffUnit6" />
                        <ext:RecordField Name="DiffUnit7" />
                        <ext:RecordField Name="DiffUnit8" />
                        <ext:RecordField Name="DiffUnit9" />
                        <ext:RecordField Name="DiffUnit10" />
                        <ext:RecordField Name="DiffUnit11" />
                        <ext:RecordField Name="DiffUnit12" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="ProductName" Direction="ASC" />
        </ext:JsonStore>
        <ext:JsonStore ID="AOPDealerStore" runat="server" UseIdConfirmation="false" OnRefreshData="AOPDealerStore_RefershData"
            AutoLoad="true">
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={10}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="AOPD_Contract_ID" />
                        <ext:RecordField Name="AOPD_Dealer_DMA_ID" />
                        <ext:RecordField Name="AOPD_ProductLine_BUM_ID" />
                        <ext:RecordField Name="AOPD_Year" />
                        <ext:RecordField Name="AOPD_Amount_1" />
                        <ext:RecordField Name="AOPD_Amount_2" />
                        <ext:RecordField Name="AOPD_Amount_3" />
                        <ext:RecordField Name="AOPD_Amount_4" />
                        <ext:RecordField Name="AOPD_Amount_5" />
                        <ext:RecordField Name="AOPD_Amount_6" />
                        <ext:RecordField Name="AOPD_Amount_7" />
                        <ext:RecordField Name="AOPD_Amount_8" />
                        <ext:RecordField Name="AOPD_Amount_9" />
                        <ext:RecordField Name="AOPD_Amount_10" />
                        <ext:RecordField Name="AOPD_Amount_11" />
                        <ext:RecordField Name="AOPD_Amount_12" />
                        <ext:RecordField Name="AOPD_Amount_Y" />
                        <ext:RecordField Name="RefAmount1" />
                        <ext:RecordField Name="RefAmount2" />
                        <ext:RecordField Name="RefAmount3" />
                        <ext:RecordField Name="RefAmount4" />
                        <ext:RecordField Name="RefAmount5" />
                        <ext:RecordField Name="RefAmount6" />
                        <ext:RecordField Name="RefAmount7" />
                        <ext:RecordField Name="RefAmount8" />
                        <ext:RecordField Name="RefAmount9" />
                        <ext:RecordField Name="RefAmount10" />
                        <ext:RecordField Name="RefAmount11" />
                        <ext:RecordField Name="RefAmount12" />
                        <ext:RecordField Name="RefAmountTotal" />
                        <ext:RecordField Name="DiffAmount1" />
                        <ext:RecordField Name="DiffAmount2" />
                        <ext:RecordField Name="DiffAmount3" />
                        <ext:RecordField Name="DiffAmount4" />
                        <ext:RecordField Name="DiffAmount5" />
                        <ext:RecordField Name="DiffAmount6" />
                        <ext:RecordField Name="DiffAmount7" />
                        <ext:RecordField Name="DiffAmount8" />
                        <ext:RecordField Name="DiffAmount9" />
                        <ext:RecordField Name="DiffAmount10" />
                        <ext:RecordField Name="DiffAmount11" />
                        <ext:RecordField Name="DiffAmount12" />
                        <ext:RecordField Name="DiffAmountY" />
                        <ext:RecordField Name="FormalAmount_1" />
                        <ext:RecordField Name="FormalAmount_2" />
                        <ext:RecordField Name="FormalAmount_3" />
                        <ext:RecordField Name="FormalAmount_4" />
                        <ext:RecordField Name="FormalAmount_5" />
                        <ext:RecordField Name="FormalAmount_6" />
                        <ext:RecordField Name="FormalAmount_7" />
                        <ext:RecordField Name="FormalAmount_8" />
                        <ext:RecordField Name="FormalAmount_9" />
                        <ext:RecordField Name="FormalAmount_10" />
                        <ext:RecordField Name="FormalAmount_11" />
                        <ext:RecordField Name="FormalAmount_12" />
                        <ext:RecordField Name="FormalAmountY" />
                        <ext:RecordField Name="RmkBody" />
                        <ext:RecordField Name="RefD_H" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="AOPD_Dealer_DMA_ID" Direction="ASC" />
        </ext:JsonStore>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" MarginsSummary="0 5 0 5">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".7">
                                        <ext:Panel ID="Panel1" runat="server" Border="false" Height="22">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                    <ext:LayoutColumn ColumnWidth=".5">
                                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="txtQueryHospitalName" runat="server" Width="200" FieldLabel="医院名称">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth=".5">
                                                        <ext:Panel ID="Panel4" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbQueryProductClass" runat="server" EmptyText="请选择产品分..." Width="200"
                                                                            Editable="true" TypeAhead="true" StoreID="AOPProductClassStore" ValueField="CQ_ID"
                                                                            DisplayField="CQ_NameCN" Mode="Local" FieldLabel="指标产品分类" Resizable="true">
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
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel2" runat="server" Border="false" Height="22">
                                            <Buttons>
                                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="#{PagingToolBarAOP}.changePage(1);" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center Collapsible="True" MarginsSummary="0 5 5 5">
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Title="经销商医院指标列表: <img src='/resources/images/icons/flag_ch.png' > </img> 代表本次新授权医院"
                            Icon="HouseKey">
                            <Body>
                                <ext:FitLayout ID="FitLayout2" runat="server">
                                    <ext:GridPanel ID="GridPanelAOPStore" runat="server" Header="false" StoreID="AOPStore"
                                        Border="false" Icon="Lorry" AutoExpandMax="250" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="OperType" DataIndex="OperType" Align="Center" Width="26" MenuDisabled="true">
                                                    <Renderer Fn="change" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineId" DataIndex="ProductLineId" Header="产品线" Width="150"
                                                    Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="年度" Width="50" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="医院名称" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductName" DataIndex="ProductName" Header="产品分类" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="RefYear" DataIndex="RefYear" Header="合计<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="UnitY" DataIndex="UnitY" Header="合计<br/>实际" Width="60" Align="Center"
                                                    Css="styColumn_Green">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefQ1" DataIndex="RefQ1" Header="Q1<br/>标准" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Q1" DataIndex="Q1" Header="Q1<br/>实际" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefQ2" DataIndex="RefQ2" Header="Q2<br/>标准" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Q2" DataIndex="Q2" Header="Q2<br/>实际" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefQ3" DataIndex="RefQ3" Header="Q3<br/>标准" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Q3" DataIndex="Q3" Header="Q3<br/>实际" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefQ4" DataIndex="RefQ4" Header="Q4<br/>标准" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Q4" DataIndex="Q4" Header="Q4<br/>实际" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit1" DataIndex="RefUnit1" Header="一月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit1" DataIndex="Unit1" Header="一月<br/>实际" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit1" DataIndex="DiffUnit1" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit2" DataIndex="RefUnit2" Header="二月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit2" DataIndex="Unit2" Header="二月<br/>实际" Width="60" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit2" DataIndex="DiffUnit2" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit3" DataIndex="RefUnit3" Header="三月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit3" DataIndex="Unit3" Header="三月<br/>实际" Width="60" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit3" DataIndex="DiffUnit3" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit4" DataIndex="RefUnit4" Header="四月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit4" DataIndex="Unit4" Header="四月<br/>实际" Width="60" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit4" DataIndex="DiffUnit4" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit5" DataIndex="RefUnit5" Header="五月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit5" DataIndex="Unit5" Header="五月<br/>实际" Width="60" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit5" DataIndex="DiffUnit5" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit6" DataIndex="RefUnit6" Header="六月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit6" DataIndex="Unit6" Header="六月<br/>实际" Width="60" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit6" DataIndex="DiffUnit6" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit7" DataIndex="RefUnit7" Header="七月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit7" DataIndex="Unit7" Header="七月<br/>实际" Width="60" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit7" DataIndex="DiffUnit7" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit8" DataIndex="RefUnit8" Header="八月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit8" DataIndex="Unit8" Header="八月<br/>实际" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit8" DataIndex="DiffUnit8" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit9" DataIndex="RefUnit9" Header="九月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit9" DataIndex="Unit9" Header="九月<br/>实际" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit9" DataIndex="DiffUnit9" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit10" DataIndex="RefUnit10" Header="十月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit10" DataIndex="Unit10" Header="十月<br/>实际" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit10" DataIndex="DiffUnit10" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit11" DataIndex="RefUnit11" Header="十一月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit11" DataIndex="Unit11" Header="十一月<br/>实际" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit11" DataIndex="DiffUnit11" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefUnit12" DataIndex="RefUnit12" Header="十二月<br/>标准" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Unit12" DataIndex="Unit12" Header="十二月<br/>实际" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffUnit12" DataIndex="DiffUnit12" Header="差异" Width="60" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBarAOP" runat="server" PageSize="10" StoreID="AOPStore"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                    <South Collapsible="True" MarginsSummary="0 5 0 5">
                        <ext:Panel runat="server" ID="PanelDealerAop" Border="false" Frame="true" Title="经销商指标列表 <img src='/resources/images/icons/exclamation.png' > </img> 经销商指标小于医院指标或者大于医院指标的20% (不含税指标)"
                            Icon="HouseKey" Height="200" ButtonAlign="Left">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="GridDealerAop" runat="server" Header="false" StoreID="AOPDealerStore"
                                        Border="false" Icon="Lorry" AutoExpandColumn="AOPD_Dealer_DMA_ID" AutoExpandMax="250"
                                        AutoExpandMin="150" StripeRows="true">
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="RefD_H" DataIndex="RefD_H" Align="Center" Width="30" MenuDisabled="true">
                                                    <Renderer Fn="change2" />
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Dealer_DMA_ID" DataIndex="AOPD_Dealer_DMA_ID" Header="经销商"
                                                    Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_ProductLine_BUM_ID" DataIndex="AOPD_ProductLine_BUM_ID"
                                                    Header="产品线" Width="100" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Year" DataIndex="AOPD_Year" Header="年度" Width="50">
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmountTotal" DataIndex="RefAmountTotal" Header="医院<br/>指标合计"
                                                    Width="70" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_Y" DataIndex="AOPD_Amount_Y" Header="经销商<br/>指标合计"
                                                    Width="70" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmountY" DataIndex="DiffAmountY" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount1" DataIndex="RefAmount1" Header="一月<br/>医院" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_1" DataIndex="AOPD_Amount_1" Header="一月" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount1" DataIndex="DiffAmount1" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount2" DataIndex="RefAmount2" Header="二月<br/>医院" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_2" DataIndex="AOPD_Amount_2" Header="二月" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount2" DataIndex="DiffAmount2" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount3" DataIndex="RefAmount3" Header="三月<br/>医院" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_3" DataIndex="AOPD_Amount_3" Header="三月" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount3" DataIndex="DiffAmount3" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount4" DataIndex="RefAmount4" Header="四月<br/>医院" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_4" DataIndex="AOPD_Amount_4" Header="四月" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount4" DataIndex="DiffAmount4" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount5" DataIndex="RefAmount5" Header="五月<br/>医院" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_5" DataIndex="AOPD_Amount_5" Header="五月" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount5" DataIndex="DiffAmount5" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount6" DataIndex="RefAmount6" Header="六月<br/>医院" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_6" DataIndex="AOPD_Amount_6" Header="六月" Width="50"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount6" DataIndex="DiffAmount6" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount7" DataIndex="RefAmount7" Header="七月<br/>医院" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_7" DataIndex="AOPD_Amount_7" Header="七月" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount7" DataIndex="DiffAmount7" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount8" DataIndex="RefAmount8" Header="八月<br/>医院" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_8" DataIndex="AOPD_Amount_8" Header="八月" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount8" DataIndex="DiffAmount8" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount9" DataIndex="RefAmount9" Header="九月<br/>医院" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_9" DataIndex="AOPD_Amount_9" Header="九月" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount9" DataIndex="DiffAmount9" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount10" DataIndex="RefAmount10" Header="十月<br/>医院" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_10" DataIndex="AOPD_Amount_10" Header="十月" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount10" DataIndex="DiffAmount10" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount11" DataIndex="RefAmount11" Header="十一月<br/>医院" Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_11" DataIndex="AOPD_Amount_11" Header="十一月" Align="Center"
                                                    Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount11" DataIndex="DiffAmount11" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RefAmount12" DataIndex="RefAmount12" Header="十二月<br/>医院" Width="60"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPD_Amount_12" DataIndex="AOPD_Amount_12" Header="十二月" Align="Center"
                                                    Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffAmount12" DataIndex="DiffAmount12" Header="差异" Width="60"
                                                    Align="Center">
                                                    <Renderer Fn="changeValueSty" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RmkBody" DataIndex="RmkBody" Header="备注" Align="Center" Width="150">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" SingleSelect="true" />
                                        </SelectionModel>
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="Button2" runat="server" Text="导出医院指标" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="true" OnClick="ExportHospitalExcel">
                                </ext:Button>
                                <ext:Button ID="Button1" runat="server" Text="导出经销商指标" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="true" OnClick="ExportDealerExcel">
                                </ext:Button>
                                <ext:Button ID="Button5" runat="server" Text="退出" Icon="Cancel" CommandArgument=""
                                    CommandName="" IDMode="Legacy">
                                    <Listeners>
                                        <Click Fn="ClosePage" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </South>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Hidden ID="hidContractID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDealerID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDivisionID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidProductLineId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HidEffectiveDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HidExpirationDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsEmerging" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidYearString" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPartsContractCode" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPartsContractId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidMinYear" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidContractType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="prodLineData" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidBeginYearMinMonth" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidCheckHospitalProudct" runat="server">
        </ext:Hidden>
    </div>
    </form>
</body>
</html>
