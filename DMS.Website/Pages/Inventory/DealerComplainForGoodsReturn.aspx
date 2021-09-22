<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerComplainForGoodsReturn.aspx.cs"
    Inherits="DMS.Website.Pages.Inventory.DealerComplainForGoodsReturn" ValidateRequest="false" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/DealerComplainBSCEdit.ascx" TagName="DealerComplainBSCEdit"
    TagPrefix="uc" %>
<%--<%@ Register Src="../../Controls/DealerComplainCRMEdit.ascx" TagName="DealerComplainCRMEdit"
    TagPrefix="uc" %>--%>
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

        <script type="text/javascript" language="javascript">
            Ext.apply(Ext.util.Format, { number: function (v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function (format) { return function (v) { return Ext.util.Format.number(v, format); }; } });
            //刷新父窗口查询结果
            function RefreshMainPage() {
                Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
            }

            var MsgList = {
                btnInsert: {
                    FailureTitle: "<%=GetLocalResourceObject("Panel1.btnInsert.Alert.Title").ToString()%>",
                    FailureMsg: "<%=GetLocalResourceObject("Panel1.btnInsert.Alert.Body").ToString()%>"
                },
                ShowDetails: {
                    FailureTitle: "<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Alert.Title").ToString()%>",
                    FailureMsg: "<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Alert.Body").ToString()%>"
                },
                Error: "<%=GetLocalResourceObject("CheckMod.new.Alert.Title").ToString()%>"
            }

            function prepareCommand(grid, toolbar, rowIndex, record) {
                var firstButton = toolbar.items.get(0);
                if ((record.data.DC_Status == "Delivered" || record.data.DC_Status == "Completed") && record.data.DealerType == "T2") {
                    firstButton.setVisible(true);
                } else {
                    firstButton.setVisible(false);
                }
            }

            function prepareCommandExpress(grid, toolbar, rowIndex, record) {
                var hidcorptype = Ext.getCmp('<%=this.hidCorpType.ClientID%>');
                var firstButton = toolbar.items.get(0);
                if ((record.data.DC_Status != "DealerCompleted"
                    && record.data.DC_Status != "Reject"
                    && record.data.DC_Status != "Revoked"
                    && record.data.DC_Status != "Draft"
                    && record.data.DC_Status != "Completed")
                    && (hidcorptype.getValue() == "T2"
                    || hidcorptype.getValue() == "LP"
                    || hidcorptype.getValue() == "T1"
                    || hidcorptype.getValue() == "LS")) {
                    firstButton.setVisible(true);
                } else {
                    firstButton.setVisible(false);
                }
            }
            function prepareCommandIAN(grid, toolbar, rowIndex, record) {
                var hidcorptype = Ext.getCmp('<%=this.hidCorpType.ClientID%>');
                var firstButton = toolbar.items.get(0);
                if (hidcorptype.getValue() != "T2"
                    && hidcorptype.getValue() != "LP"
                    && hidcorptype.getValue() != "T1"
                   && hidcorptype.getValue() != "LS") {
                    firstButton.setVisible(true);
                } else {
                    firstButton.setVisible(false);
                }
            }

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

            function S4() {
                return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
            }
            var NewGuid = function () {
                return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
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
            <Listeners>
                <Load Handler="#{cbDealer}.setValue(#{hidInitDealerId}.getValue());" />
            </Listeners>
            <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="AdjustStatusStore" runat="server" UseIdConfirmation="true">
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
                <ext:JsonReader ReaderID="DC_ID">
                    <Fields>
                        <ext:RecordField Name="DC_ID" />
                        <ext:RecordField Name="DealerType" />
                        <ext:RecordField Name="DC_CreatedDate" />
                        <ext:RecordField Name="DC_Status" />
                        <ext:RecordField Name="DC_StatusName" />
                        <ext:RecordField Name="ComplainType" />
                        <ext:RecordField Name="IDENTITY_NAME" />
                        <ext:RecordField Name="DC_ComplainNbr" />
                        <ext:RecordField Name="DN" />
                        <ext:RecordField Name="CarrierNumber" />
                        <ext:RecordField Name="CorpName" />
                        <ext:RecordField Name="WarehouseType" />
                        <ext:RecordField Name="ReturnType" />
                        <ext:RecordField Name="PropertyRight" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="hidInitDealerId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidCorpType" runat="server">
        </ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true"
                            BodyStyle="padding: 5px;" Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="120">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="选择经销商..." Width="220" Editable="true"
                                                            TypeAhead="False" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                            Mode="Local" FieldLabel="经销商" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();this.store.clearFilter();" />
                                                                <BeforeQuery Fn="SelectValue" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="txtSubmitDateStart" runat="server" Width="160" FieldLabel="申请开始日期" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtUPN" runat="server" Width="160" FieldLabel="产品型号（UPN）" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="120">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbAdjustStatus" runat="server" EmptyText="选择单据状态..." Width="160"
                                                            Editable="false" TypeAhead="true" StoreID="AdjustStatusStore" ValueField="Key"
                                                            DisplayField="Value" FieldLabel="单据状态">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="txtSubmitDateEnd" runat="server" Width="150" FieldLabel="申请结束日期" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtLotNumber" runat="server" Width="150" FieldLabel="批号/二维码" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>

                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtComplainNumber" runat="server" Width="150" FieldLabel="申请单编号" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtApplyUser" runat="server" Width="150" FieldLabel="<%$ Resources: txtApplyUser.FieldLabel  %>" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtDN" runat="server" Width="150" FieldLabel="蓝威全球投诉号" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnExport" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy" AutoPostBack="true" OnClick="ExportExcel">
                                </ext:Button>
                                <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text %>" runat="server"
                                    Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsertBSC" runat="server" Text="新增CNF投诉" Icon="Add" IDMode="Legacy">
                                    <%--                                    <AjaxEvents>
                                        <Click Before="#{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowBSCEdit"
                                            Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                            Success="SetBSCSubmit(true);SetBSCCancel(false);SetBSCConfirm(false);SetBSCDelivered(false);RefreshDetailWindowBSC()">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}"
                                                Msg="<%$ Resources: GridPanel1.AjaxEvents.EventMask.Msg %>" />
                                            <ExtraParams>
                                                <ext:Parameter Name="DC_ID" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Click>
                                    </AjaxEvents>--%>
                                    <Listeners>
                                        <%--<Click Handler="var newid = NewGuid(); window.parent.loadExample('/Pages/Inventory/DealerComplainForCNFEdit.aspx?InstanceId=' + newid,  'subMenu' + newid, '投诉申请单');"></Click>--%>
                                        <Click Handler="var newid = NewGuid(); top.createTab({id: 'subMenu'+newid,title: '投诉申请单',url: 'Pages/Inventory/DealerComplainForCNFEdit.aspx?InstanceId='+newid});" />
                                    </Listeners>
                                </ext:Button>
                                <%--<ext:Button ID="btnInsertCRM" runat="server" Text="新增CRM投诉" Icon="Add" IDMode="Legacy">
                                <AjaxEvents>
                                    <Click Before="#{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowCRMEdit"
                                        Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                        Success="SetCRMSubmit(true);SetCRMCancel(false);SetCRMConfirm(false);SetCRMDelivered(false);">
                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}"
                                            Msg="<%$ Resources: GridPanel1.AjaxEvents.EventMask.Msg %>" />
                                        <ExtraParams>
                                            <ext:Parameter Name="DC_ID" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                            </ext:Parameter>
                                        </ExtraParams>
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>--%>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                        StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true"
                                        AutoExpandColumn="IDENTITY_NAME">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ComplainNbr" DataIndex="DC_ComplainNbr" Header="<%$ Resources: GridPanel1.ColumnModel1.ComplainNbr.Header %>"
                                                    Width="150" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="ComplainType" DataIndex="ComplainType" Header="<%$ Resources: GridPanel1.ColumnModel1.ComplainType.Header %>"
                                                    Width="120" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="CorpName" DataIndex="CorpName" Header="经销商" Width="140" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="IDENTITY_NAME" DataIndex="IDENTITY_NAME" Header="<%$ Resources: GridPanel1.ColumnModel1.ApplyUser.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="CarrierNumber" DataIndex="CarrierNumber" Header="经销商快递单号" Width="140"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="DN" DataIndex="DN" Header="蓝威全球投诉号" Width="140">
                                                </ext:Column>
                                                <ext:Column ColumnID="DC_Status" Width="180" Align="Center" DataIndex="DC_Status"
                                                    Header="<%$ Resources: GridPanel1.ColumnModel1.Status.Header %>">
                                                    <Renderer Handler="return getNameFromStoreById(AdjustStatusStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DC_CreatedDate" Width="150" Align="Center" DataIndex="DC_CreatedDate"
                                                    Header="<%$ Resources: GridPanel1.ColumnModel1.ApplyDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="PropertyRight" DataIndex="PropertyRight" Header="产品物权" Width="100"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="ReturnType" DataIndex="ReturnType" Header="波科确认处理类型" Width="100"
                                                    Align="Center">
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>"
                                                    Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:CommandColumn Width="60" Header="复制" Align="Center" Hidden="True">
                                                    <Commands>
                                                        <ext:GridCommand Icon="PastePlain" CommandName="Copy">

                                                            <ToolTip Text="复制申请单" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:CommandColumn Width="60" Header="平台确认发货或退款" Align="Center" Hidden="True">
                                                    <Commands>
                                                        <ext:GridCommand Icon="ScriptSave" CommandName="Confirm">
                                                            <ToolTip Text="平台确认发货或退款" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                    <PrepareToolbar Fn="prepareCommand" />
                                                </ext:CommandColumn>
                                                <ext:CommandColumn Width="60" Header="经销商回填快递信息" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BookEdit" CommandName="UpdateExpress">
                                                            <ToolTip Text="经销商回填快递信息" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                    <PrepareToolbar Fn="prepareCommandExpress" />
                                                </ext:CommandColumn>
                                                 <ext:CommandColumn Width="60" Header="维护全球投诉单号" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BookEdit" CommandName="UpdateIAN">
                                                            <ToolTip Text="维护全球投诉单号" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                    <PrepareToolbar Fn="prepareCommandIAN" />
                                                </ext:CommandColumn>

                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <%--<Command Handler="Coolite.AjaxMethods.DealerComplainForGoodsReturn.Show(record.data.DC_ID,record.data.ComplainType,{success:function(){if (record.data.ComplainType =='BSC') {SetBSCSubmit(false);RefreshDetailWindowBSC();} else {} if (record.data.DC_Status=='Completed') {SetBSCConfirm(true);}else {SetBSCConfirm(false);}  if (record.data.DC_Status=='Submit') {SetBSCCancel(true);} else {SetBSCCancel(false);}  if (record.data.DC_Status=='Confirmed') {SetBSCDelivered(true);} else {SetBSCDelivered(false);} if (record.data.DC_Status=='Delivered') {SetBSCConfirmed(true);} else {SetBSCConfirmed(false);} },failure:function(err){Ext.Msg.alert('Error', err);}});" />--%>
                                            <%--<Command Handler="if(command == 'Edit'){ 
                                                window.parent.createTab('/Pages/Inventory/DealerComplainForCNFEdit.aspx?InstanceId=' + record.data.DC_ID,  'subMenu' + record.data.DC_ID, '投诉申请单');
                                                }
                                                                else if(command=='Confirm'){  Ext.Msg.confirm('确认', '是否确认平台已换货给T2或寄送退款协议给T2?', function(e) { if (e == 'yes') { Coolite.AjaxMethods.DealerComplainForGoodsReturn.UpdateDealerComplain(record.data.DC_ID,{ success: function() { #{GridPanel1}.reload();Ext.MessageBox.alert('Success', '保存成功!'); },failure: function(err) {Ext.Msg.alert('Error', err);}}); } });}
                                                                else if(command=='Copy'){Coolite.AjaxMethods.DealerComplainForGoodsReturn.Show(record.data.DC_ID,'New',{success:function(){SetBSCSubmit(true);SetBSCCancel(false);SetBSCConfirm(false);SetBSCDelivered(false);RefreshDetailWindowBSC(); },failure:function(err){Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);}});}
                                                                else if(command=='UpdateIAN'){Coolite.AjaxMethods.DealerComplainForGoodsReturn.IANEditShow(record.data.DC_ID,{success:function(){},failure:function(err){}});}
                                                                else if(command=='UpdateExpress'){Coolite.AjaxMethods.DealerComplainForGoodsReturn.ExpressEditShow(record.data.DC_ID,{success:function(){},failure:function(err){}});}
                                            " />--%>
                                            

                                            <Command Handler="if(command == 'Edit'){ 
                                                top.createTab({id: 'subMenu'+ record.data.DC_ID,title: '投诉申请单',url: 'Pages/Inventory/DealerComplainForCNFEdit.aspx?InstanceId='+ record.data.DC_ID});
                                                }
                                                                else if(command=='Confirm'){  Ext.Msg.confirm('确认', '是否确认平台已换货给T2或寄送退款协议给T2?', function(e) { if (e == 'yes') { Coolite.AjaxMethods.DealerComplainForGoodsReturn.UpdateDealerComplain(record.data.DC_ID,{ success: function() { #{GridPanel1}.reload();Ext.MessageBox.alert('Success', '保存成功!'); },failure: function(err) {Ext.Msg.alert('Error', err);}}); } });}
                                                                else if(command=='Copy'){Coolite.AjaxMethods.DealerComplainForGoodsReturn.Show(record.data.DC_ID,'New',{success:function(){SetBSCSubmit(true);SetBSCCancel(false);SetBSCConfirm(false);SetBSCDelivered(false);RefreshDetailWindowBSC(); },failure:function(err){Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);}});}
                                                                else if(command=='UpdateIAN'){Coolite.AjaxMethods.DealerComplainForGoodsReturn.IANEditShow(record.data.DC_ID,{success:function(){},failure:function(err){}});}
                                                                else if(command=='UpdateExpress'){Coolite.AjaxMethods.DealerComplainForGoodsReturn.ExpressEditShow(record.data.DC_ID,{success:function(){},failure:function(err){}});}
                                            " />
                                           

                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="ResultStore"
                                                DisplayInfo="true" />
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
        <ext:Window ID="ExpressEditWindows" runat="server" Icon="Group" Title="经销商回填快递信息"
            Width="300" Height="150" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Maximizable="true">
            <Body>
                <ext:FitLayout ID="flExpressEdit" runat="server">
                    <ext:Panel ID="Panel36" runat="server" Header="false" AutoHeight="true" Border="false">
                        <Body>
                            <ext:FormLayout ID="FormLayout22" runat="server">
                                <ext:Anchor>
                                    <ext:Hidden ID="hidDcId" runat="server">
                                    </ext:Hidden>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="tfCourierNumber" runat="server" FieldLabel="快递单号">
                                    </ext:TextField>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="tfCourierCompany" runat="server" FieldLabel="快递公司">
                                    </ext:TextField>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                    </ext:Panel>
                </ext:FitLayout>
            </Body>
            <Buttons>
                <ext:Button ID="btnSubmit" runat="server" Text="保存" Icon="PageSave">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.DealerComplainForGoodsReturn.ExpressSave({success:function(){Ext.MessageBox.alert('Success', '保存成功!');#{hidDcId}.setValue('');#{tfCourierNumber}.setValue('');#{tfCourierCompany}.setValue('');#{ExpressEditWindows}.hide(null);},failure:function(err){Ext.MessageBox.alert('Failure', err);}})" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnClose" runat="server" Text="关闭" Icon="Cancel">
                    <Listeners>
                        <Click Handler="Ext.getCmp('ExpressEditWindows').hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Window ID="IANEditWindow" runat="server" Icon="Group" Title="维护全球投诉号码"
            Width="300" Height="130" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Maximizable="true">
            <Body>
                <ext:FitLayout ID="FitLayout2" runat="server">
                    <ext:Panel ID="Panel6" runat="server" Header="false" AutoHeight="true" Border="false">
                        <Body>
                            <ext:FormLayout ID="FormLayout4" runat="server">
                                <ext:Anchor>
                                    <ext:Hidden ID="hidWinDcId" runat="server">
                                    </ext:Hidden>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="txtWinComplaintID" runat="server" FieldLabel="全球投诉单号">
                                    </ext:TextField>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                    </ext:Panel>
                </ext:FitLayout>
            </Body>
            <Buttons>
                <ext:Button ID="Button1" runat="server" Text="保存" Icon="PageSave">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.DealerComplainForGoodsReturn.IANSave({success:function(){Ext.MessageBox.alert('Success', '保存成功!');#{hidWinDcId}.setValue('');#{txtWinComplaintID}.setValue('');#{IANEditWindow}.hide(null);#{ResultStore}.reload();},failure:function(err){Ext.MessageBox.alert('Failure', err);}})" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="Button2" runat="server" Text="关闭" Icon="Cancel">
                    <Listeners>
                        <Click Handler="Ext.getCmp('IANEditWindow').hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>

        <uc:DealerComplainBSCEdit ID="DealerComplainBSCEdit" runat="server" />
        <%--<uc:DealerComplainCRMEdit ID="DealerComplainCRMEdit" runat="server" />--%>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
