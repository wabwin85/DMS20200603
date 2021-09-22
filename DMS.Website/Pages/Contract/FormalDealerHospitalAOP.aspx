<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormalDealerHospitalAOP.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.FormalDealerHospitalAOP" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>经销商医院指标</title>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });

        var ClosePage = function() {
            window.open('', '_self');
            window.close();
        }

    </script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Debug">
        </ext:ScriptManager>
        <ext:Store ID="YearStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshFY"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="COP_Period" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="COP_Period" Direction="ASC" />
        </ext:Store>
        <ext:JsonStore ID="AOPStore" runat="server" UseIdConfirmation="false" OnRefreshData="AOPStore_RefershData"
            AutoLoad="true">
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={15}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="ProductLine" />
                        <ext:RecordField Name="ProductClass" />
                        <ext:RecordField Name="Year" />
                        <ext:RecordField Name="January" />
                        <ext:RecordField Name="February" />
                        <ext:RecordField Name="March" />
                        <ext:RecordField Name="April" />
                        <ext:RecordField Name="May" />
                        <ext:RecordField Name="June" />
                        <ext:RecordField Name="July" />
                        <ext:RecordField Name="August" />
                        <ext:RecordField Name="September" />
                        <ext:RecordField Name="October" />
                        <ext:RecordField Name="November" />
                        <ext:RecordField Name="December" />
                        <ext:RecordField Name="Amount_Y" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="ProductLine" Direction="ASC" />
        </ext:JsonStore>
        <ext:JsonStore ID="AOPStoreDealer" runat="server" UseIdConfirmation="false" OnRefreshData="AOPStoreDealer_RefershData"
            AutoLoad="true">
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={15}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="ProductClass" />
                        <ext:RecordField Name="Year" />
                        <ext:RecordField Name="Amount_1" />
                        <ext:RecordField Name="Amount_2" />
                        <ext:RecordField Name="Amount_3" />
                        <ext:RecordField Name="Amount_4" />
                        <ext:RecordField Name="Amount_5" />
                        <ext:RecordField Name="Amount_6" />
                        <ext:RecordField Name="Amount_7" />
                        <ext:RecordField Name="Amount_8" />
                        <ext:RecordField Name="Amount_9" />
                        <ext:RecordField Name="Amount_10" />
                        <ext:RecordField Name="Amount_11" />
                        <ext:RecordField Name="Amount_12" />
                        <ext:RecordField Name="Amount_Y" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="ProductClass" Direction="ASC" />
        </ext:JsonStore>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbYear" runat="server" EmptyText="选择年度..." Width="200" Editable="true"
                                                            TypeAhead="true" StoreID="YearStore" ValueField="COP_Period" DisplayField="COP_Period"
                                                            ListWidth="200" Resizable="true" FieldLabel="年度" Mode="Local">
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
                                        <Click Handler="#{PagingToolBar1}.doLoad(0);#{PagingToolBar2}.doLoad(0);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="Button1" runat="server" Text="关闭" Icon="Cancel" CommandArgument=""
                                    CommandName="" IDMode="Legacy">
                                    <Listeners>
                                        <Click Fn="ClosePage" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Title="经销商医院指标列表 (不含税指标)"
                            Icon="HouseKey">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Header="false" StoreID="AOPStore" Border="false"
                                        Icon="Lorry" AutoExpandColumn="HospitalName" AutoExpandMax="250" AutoExpandMin="150"
                                        StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ProductClass" DataIndex="ProductClass" Header="产品分类">
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="医院">
                                                </ext:Column>
                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="年度">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="合计(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="January" DataIndex="January" Header="一月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="February" DataIndex="February" Header="二月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="March" DataIndex="March" Header="三月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="April" DataIndex="April" Header="四月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="May" DataIndex="May" Header="五月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="June" DataIndex="June" Header="六月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="July" DataIndex="July" Header="七月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="August" DataIndex="August" Header="八月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="September" DataIndex="September" Header="九月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="October" DataIndex="October" Header="十月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="November" DataIndex="November" Header="十一月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="December" DataIndex="December" Header="十二月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="AOPStore"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                    <South Collapsible="True" Split="True">
                        <ext:Panel runat="server" ID="Panel1" Border="false" Frame="true" Title="经销商指标列表 (不含税指标)"
                            AutoHeight="true" Icon="HouseKey">
                            <Body>
                                <ext:FitLayout ID="FitLayout2" runat="server">
                                    <ext:GridPanel ID="GridPanel2" runat="server" Header="false" StoreID="AOPStoreDealer"
                                        Border="false" Icon="Lorry" AutoExpandColumn="ProductClass" Height="150" StripeRows="true">
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ProductClass" DataIndex="ProductClass" Header="产品分类">
                                                </ext:Column>
                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="年度">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="合计(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_1" DataIndex="Amount_1" Header="一月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_2" DataIndex="Amount_2" Header="二月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_3" DataIndex="Amount_3" Header="三月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_4" DataIndex="Amount_4" Header="四月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_5" DataIndex="Amount_5" Header="五月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_6" DataIndex="Amount_6" Header="六月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_7" DataIndex="Amount_7" Header="七月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_8" DataIndex="Amount_8" Header="八月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_9" DataIndex="Amount_9" Header="九月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_10" DataIndex="Amount_10" Header="十月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_11" DataIndex="Amount_11" Header="十一月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_12" DataIndex="Amount_12" Header="十二月(￥)">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" SingleSelect="true" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="AOPStoreDealer"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </South>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Hidden ID="hidDealerID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDivisionID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsEmerging" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPartsContractCode" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidContractId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidBeginDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidEndDate" runat="server">
        </ext:Hidden>
    </div>
    </form>
</body>
</html>
