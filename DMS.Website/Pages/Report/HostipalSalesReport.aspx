<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HostipalSalesReport.aspx.cs" Inherits="DMS.Website.Pages.Contract.HostipalSales" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>


</head>
<body>
    <form id="form1" runat="server">

        <script type="text/javascript" language="javascript">
            function prepareCommand(grid, toolbar, rowIndex, record) {
                var firstButton = toolbar.items.get(0);

                var dealertype = record.data.DealerType;
                var contstatus = record.data.ContStatus;
                var parmetType = record.data.ParmetType;

                if (((dealertype == 'T1' || dealertype == 'LP') && contstatus != 'Reject' && contstatus != 'Approving') || (dealertype == 'T2')) {
                    firstButton.setVisible(true);
                } else {
                    firstButton.setVisible(false);
                }
            }
            function getDealerTypeName(values) {
                if (values == 'T1') {
                    return "一级经销商";
                }
                else if (values == 'T2') {
                    return "二级经销商";
                }
                else if (values == 'LP') {
                    return "平台经销商";
                }
                else {
                    return values;
                }
            }

            function ComboxSelValue(e) {
                var combo = e.combo;
                combo.collapse();
                if (!e.forceAll) {
                    var input = e.query;
                    if (input != null && input != '') {
                        // 检索的正则
                        var regExp = new RegExp(".*" + input + ".*");
                        // 执行检索
                        combo.store.filterBy(function (record, id) {
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
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
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
        </ext:Store>
        <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        
                        <ext:RecordField Name="DivisionID" />
                        <ext:RecordField Name="Division" />
                        <ext:RecordField Name="SubBUCode" />
                        <ext:RecordField Name="SubBU" />
                        <ext:RecordField Name="SAPID" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="DMSCode" />
                        <ext:RecordField Name="Hospital" />
                        <ext:RecordField Name="Province" />
                        <ext:RecordField Name="City" />
                        <ext:RecordField Name="UPN" />
                        <ext:RecordField Name="UPN_Description" />
                        <ext:RecordField Name="LOT" />
                        <ext:RecordField Name="EXPDate" />
                        <ext:RecordField Name="QTY" />
                        <ext:RecordField Name="SellingPriceWithVAT" />
                        <ext:RecordField Name="City" />
                        <ext:RecordField Name="TransactionDate" />
                        <ext:RecordField Name="InputTime" />
                    </Fields>
                </ext:JsonReader>             
            </Reader>
            <SortInfo Field="InputTime" Direction="DESC" />
        </ext:Store>
        <ext:Hidden ID="Hidden1" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidProductLine" runat="server">
        </ext:Hidden>
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
            <Listeners>
                <Load Handler="#{cbDealer}.setValue(#{hidInitDealerId}.getValue());" />
            </Listeners>
        </ext:Store>

        <ext:Store ID="Store1" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="AttributeName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Id" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="Store2" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="AttributeName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Id" Direction="ASC" />
        </ext:Store>

        <ext:Store ID="SubBUStore" runat="server" UseIdConfirmation="true" OnRefreshData="SubBUStore_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="SubBUCode">
                    <Fields>
                        <ext:RecordField Name="SubBUCode" />
                        <ext:RecordField Name="SubBUName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>

            <SortInfo Field="SubBUCode" Direction="ASC" />
        </ext:Store>

        <ext:Hidden ID="hidInitDealerId" runat="server">
        </ext:Hidden>
        <div>
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="True">
                            

                           <ext:Panel ID="Panel8" runat="server" Title="医院库存明细查询" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Find">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择经销商中文名称..."
                                                                Width="200" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                                                DisplayField="ChineseShortName" Mode="Local" FieldLabel="经销商中文名称"
                                                                ListWidth="300" Resizable="true">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <BeforeQuery Fn="ComboxSelValue" />
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        

                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel2" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout2" runat="server">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="选择产品线..." Width="200"
                                                                Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                                Mode="Local" DisplayField="AttributeName" FieldLabel="产品线" Resizable="true">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();#{cbSubBu}.clearValue();#{SubBUStore}.reload();" />
                                                                    <Select Handler=" #{SubBUStore}.reload();#{cbSubBu}.clearValue(); " />
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
                                                            <ext:ComboBox ID="cbSubBu" runat="server" EmptyText="选择分线" Width="200" Editable="false"
                                                                TypeAhead="true" StoreID="SubBUStore" ValueField="SubBUCode" Mode="Local"
                                                                DisplayField="SubBUName" FieldLabel="产品分类" Resizable="true">
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
                                    <ext:Button ID="btnSubmit" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy"
                                        AutoPostBack="true" OnClick="ExportExcel">
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </North>


                        <Center>
                            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                        <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果"
                                            StoreID="ResultStore" Border="false" Icon="Lorry" StripeRows="true">
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    
                                                    <ext:Column ColumnID="Division" DataIndex="Division" Header="产品线 "
                                                        Width="70">
                                                    </ext:Column>
                                                   
                                                    <ext:Column ColumnID="SAPID" DataIndex="SAPID" Header="经销商编号"
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商名称"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DMSCode" DataIndex="DMSCode" Header="医院编号"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Hospital" DataIndex="Hospital" Header="医院名称"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Province" DataIndex="Province" Header="医院所在省"
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="City" DataIndex="City" Header="医院所在市" 
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UPN" DataIndex="UPN" Header="产品型号"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UPN_Description" DataIndex="UPN_Description" Header="产品型号描述"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="LOT" DataIndex="LOT" Header="批号"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="EXPDate" DataIndex="EXPDate" Header="过期时间"  
                                                        Width="100">
                                                         <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d ')" />      
                                                    </ext:Column>
                                                    <ext:Column ColumnID="QTY" DataIndex="QTY" Header="数量"
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="SellingPriceWithVAT" DataIndex="SellingPriceWithVAT" Header="销售价格（含税）"
                                                        Width="100">
                                                    </ext:Column>                                                                        
                                                    <ext:Column ColumnID="TransactionDate" DataIndex="TransactionDate" Header="交易日期"
                                                        Width="100">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d ')" />   
                                                    </ext:Column>
                                                    <ext:Column ColumnID="InputTime" DataIndex="InputTime" Header="销售上报日期"
                                                        Width="100">
                                                         <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d ')" />    
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="if (command == 'Edit')
                                                                   {
                                                                    var contid = record.data.ContractID;
                                                                    var parmetType = record.data.ParmetType;
                                                                    var dealerType = record.data.DealerType;
                                                                    
                                                                    window.location.href = '/Pages/Contract/ContractDeatil.aspx?ContractID=' + contid + '&ParmetType=' + parmetType + '&DealerType=' + dealerType;
                                                                   
                                                                   }
                                              " />
                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="ResultStore"
                                                    DisplayInfo="true" EmptyMsg="没有数据显示" />

                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="处理中..." />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:ViewPort>

        </div>


    </form>
</body>
</html>
