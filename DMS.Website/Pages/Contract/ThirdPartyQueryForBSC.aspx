<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ThirdPartyQueryForBSC.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ThirdPartyQueryForBSC" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        .yellow-row
        {
            background: #FFD700;
        }
    </style>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
        function SelectValueDealer(e) {

            var filterField = 'ChineseName';  //需进行模糊查询的字段
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
        function SelectValueHostpt(e) {

            var filterField = 'Name';  //需进行模糊查询的字段
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
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Debug">
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
      <%--  <Listeners>
            <Load Handler="#{cbDealer}.setValue(#{hidInitDealerId}.getValue());" />
        </Listeners>--%>
    </ext:Store>
        <ext:Store ID="ThirdPartyDisclosurestore" runat="server" AutoLoad="false" OnRefreshData="ThirdPartyDisclosure_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="SAPCode" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="ProductNameString" />
                        <ext:RecordField Name="HospitaCode" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="CompanyName" />
                        <ext:RecordField Name="CompanyName2" />
                        <ext:RecordField Name="Rsm" />
                        <ext:RecordField Name="Rsm2" />
                        <ext:RecordField Name="CreatDate" />
                        <ext:RecordField Name="ApprovalDate" />
                        <ext:RecordField Name="ApprovalStatus" />
                        <ext:RecordField Name="NotTP" />
                         <ext:RecordField Name="IsAt" />
                        
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
            </Listeners>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="第三方披露表查询" Frame="true"
                            AutoHeight="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel11" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择" Width="220" Editable="true"
                                                            TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                            ListWidth="300" Resizable="true" FieldLabel="经销商" Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <BeforeQuery Fn="SelectValueDealer" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtHospitName" runat="server" EmptyText="输入医院名称" Width="220" FieldLabel="医院名称">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="90">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbApprovalStatus" runat="server" EmptyText="请选择" Width="220" Editable="true"
                                                            TypeAhead="true" ListWidth="300" Resizable="true" FieldLabel="审批状态" Mode="Local">
                                                            <Items>
                                                                <ext:ListItem Value="待审批" Text="待审批" />
                                                                <ext:ListItem Value="审批通过" Text="审批通过" />
                                                                <ext:ListItem Value="审批拒绝" Text="审批拒绝" />
                                                            </Items>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                                   <ext:Anchor>
                                                     <ext:ComboBox ID="cbIsHospital" runat="server" EmptyText="请选择" Width="220" Editable="true"
                                                            TypeAhead="true" ListWidth="300" Resizable="true" FieldLabel="是否已披露医院" Mode="Local">
                                                            <Items>
                                                                <ext:ListItem Value="是" Text="是" />
                                                                <ext:ListItem Value="否" Text="否" />
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
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbIsAt" runat="server" EmptyText="请选择" Width="220" Editable="true"
                                                            TypeAhead="true" ListWidth="300" Resizable="true" FieldLabel="是否上传附件" Mode="Local">
                                                            <Items>
                                                                <ext:ListItem Value="是" Text="是" />
                                                                <ext:ListItem Value="否" Text="否" />
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
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <%--<Click Handler="#{GridPanel1}.reload();" />--%>
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
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Title="查询结果" Icon="HouseKey">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Header="false" StoreID="ThirdPartyDisclosurestore"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="SAPCode" DataIndex="SAPCode" Header="SAPCode">
                                                </ext:Column>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="经销商中文名称" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductNameString" DataIndex="ProductNameString" Header="产品线">
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitaCode" DataIndex="HospitaCode" Header="医院Code">
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header=" 医院名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="CompanyName" DataIndex="CompanyName" Header=" 第三方公司1">
                                                </ext:Column>
                                                <ext:Column ColumnID="Rsm" DataIndex="Rsm" Header=" 与第三方关系1">
                                                </ext:Column>
                                                <ext:Column ColumnID="CompanyName2" DataIndex="CompanyName2" Header="第三方公司2">
                                                </ext:Column>
                                                <ext:Column ColumnID="Rsm2" DataIndex="Rsm2" Header="与第三方关系2">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreatDate" DataIndex="CreatDate" Header="披露时间">
                                                  <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ApprovalDate" DataIndex="ApprovalDate" Header="审批时间">
                                                  <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ApprovalStatus" DataIndex="ApprovalStatus" Header="审批状态">
                                                </ext:Column>
                                                <ext:Column ColumnID="IsAt" DataIndex="IsAt" Header="是否上传附件">
                                                </ext:Column>
                                                <ext:Column ColumnID="NotTP" DataIndex="NotTP" Header="确认无披露">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="50" StoreID="ThirdPartyDisclosurestore"
                                                DisplayInfo="true" EmptyMsg="稍等" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="稍等" />
                                        <Listeners>
                                            <CellClick />
                                        </Listeners>
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

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
