<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TrainScoreManage.aspx.cs"
    Inherits="DMS.Website.Pages.DealerTrain.TrainScoreManage" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>课程成绩导入</title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });

        function RefreshMainPage() {
            Ext.getCmp('<%=this.RstTrainList.ClientID%>').reload();
        }

        var editId = '';

        var renderDealerCode = function(value, meta, record, row, col, store) {
            if (record.data.DealerCodeDesc != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.DealerCodeDesc + '"';
            }
            if (editId == record.id) {
                return "<div id='DivDealerCode'><\/div>";
            }
            return value;
        }

        var renderSalesName = function(value, meta, record, row, col, store) {
            if (record.data.SalesNameDesc != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.SalesNameDesc + '"';
            }
            if (editId == record.id) {
                return "<div id='DivSalesName'><\/div>";
            }
            return value;
        }

        var renderIsPass = function(value, meta, record, row, col, store) {
            if (record.data.IsPassDesc != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.IsPassDesc + '"';
            }
            if (editId == record.id) {
                return "<div id='DivIsPass'><\/div>";
            }
            return value;
        }

        var renderEditControls = function(record) {
            var tbDealerCode = new Ext.form.TextField({ id: "IptDealerCode", xtype: "textfield", width: 90, maxLength: 50, allowBlank: false, renderTo: 'DivDealerCode' });
            var tbSalesName = new Ext.form.TextField({ id: "IptSalesName", xtype: "textfield", width: 90, maxLength: 50, allowBlank: false, renderTo: 'DivSalesName' });
            var tbIsPass = new Ext.form.ComboBox({ id: "IptIsPass", store: new Ext.data.SimpleStore({ fields: ['value', 'text'], data: [['通过', '通过'], ['不通过', '不通过']] }), mode: 'local', emptyText: '请选择', valueField: 'value', displayField: 'text', triggerAction: 'all', editable: false, width: 90, maxLength: 50, allowBlank: false, renderTo: 'DivIsPass' });

            tbDealerCode.setValue(record.data.DealerCode);
            tbSalesName.setValue(record.data.SalesName);
            tbIsPass.setValue(record.data.IsPass);
        }

        var rowCommand = function(command, record, row) {
            if (command == "Edit") {
                editId = record.id;
                Ext.getCmp('<%=this.RstImportList.ClientID %>').getView().refresh(true);
                renderEditControls(record);
            }
            else if (command == "Cancel") {
                editId = '';
                Ext.getCmp('<%=this.RstImportList.ClientID %>').getView().refresh(true);
            } else if (command == "Save") {
                var dealerCode = Ext.getCmp('IptDealerCode');
                var salesName = Ext.getCmp('IptSalesName');
                var isPass = Ext.getCmp('IptIsPass');
                if (dealerCode.isValid()
                        && salesName.isValid()
                        && isPass.isValid()) {
                    Coolite.AjaxMethods.SaveTrainOnlineScore(
                        record.id,
                        dealerCode.getValue(),
                        salesName.getValue(),
                        isPass.getValue(),
                        {
                            success: function() {
                                record.set('DealerCode', dealerCode.getValue());
                                record.set('SalesName', salesName.getValue());
                                record.set('IsPass', isPass.getValue());
                                record.commit();
                                editId = '';
                                Ext.getCmp('<%=this.RstImportList.ClientID %>').getView().refresh(true);
                                //renderEditControls(record);    
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    );
                }
            } else if (command == "Delete") {
                Coolite.AjaxMethods.DeleteTrainOnlineScore(
                    record.id,
                    {
                        success: function() {
                            editId = '';
                            Ext.getCmp('<%=this.RstImportList.ClientID %>').deleteSelected();
                            record.commit();
                            Ext.getCmp('<%=this.RstImportList.ClientID %>').getView().refresh(true);
                        },
                        failure: function(err) {
                            Ext.Msg.alert('Error', err);
                        }
                    }
                );
            }
        }

        var prepareCommand = function(grid, command, record, row) {
            command.hidden = true;

            if (editId == record.id) {
                if (command.command == "Save" || command.command == "Cancel") {
                    command.hidden = false;
                }
            } else {
                if (command.command == "Delete" || command.command == "Edit") {
                    command.hidden = false;
                }
            }
        }  
    </script>

    <div id="DivStore">
        <ext:Store ID="StoTrainList" runat="server" UseIdConfirmation="false" OnRefreshData="StoTrainList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="TrainId">
                    <Fields>
                        <ext:RecordField Name="TrainId" />
                        <ext:RecordField Name="TrainName" />
                        <ext:RecordField Name="TrainBu" />
                        <ext:RecordField Name="TrainStartTime" />
                        <ext:RecordField Name="TrainEndTime" />
                        <ext:RecordField Name="TrainArea" />
                        <ext:RecordField Name="IsSign" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoTrainBu" runat="server" UseIdConfirmation="true">
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
        <ext:Store ID="StoTrainArea" runat="server" OnRefreshData="StoTrainArea_RefreshData"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoTrainOnlineType" runat="server" OnRefreshData="StoTrainOnlineType_RefreshData"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoTrainOnlineList" runat="server" OnRefreshData="StoTrainOnlineList_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="TrainDetailId">
                    <Fields>
                        <ext:RecordField Name="TrainDetailId" />
                        <ext:RecordField Name="TrainType" />
                        <ext:RecordField Name="TrainContent1" />
                        <ext:RecordField Name="TrainContent2" />
                        <ext:RecordField Name="TrainContent3" />
                        <ext:RecordField Name="TrainContent4" />
                        <ext:RecordField Name="TrainContent5" />
                        <ext:RecordField Name="TrainContent6" />
                        <ext:RecordField Name="TrainContent7" />
                        <ext:RecordField Name="TrainContent8" />
                        <ext:RecordField Name="TrainContent9" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoImportList" runat="server" UseIdConfirmation="false" OnRefreshData="StoImportList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="TrainScoreId">
                    <Fields>
                        <ext:RecordField Name="TrainScoreId" />
                        <ext:RecordField Name="LineNum" />
                        <ext:RecordField Name="DealerCode" />
                        <ext:RecordField Name="SalesName" />
                        <ext:RecordField Name="IsPass" />
                        <ext:RecordField Name="DealerCodeDesc" />
                        <ext:RecordField Name="SalesNameDesc" />
                        <ext:RecordField Name="IsPassIsPassDesc" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
    </div>
    <div id="DivHidden">
        <ext:Hidden ID="IptRtnVal" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptRtnMsg" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptTrainId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptTrainOnlineId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptFileName" runat="server">
        </ext:Hidden>
    </div>
    <div id="DivView">
        <ext:ViewPort ID="WdwMain" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="PnlSearch" runat="server" Header="true" Title="查询条件" Frame="true"
                            AutoHeight="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="QryTrainBu" runat="server" EmptyText="请选择产品线…" Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="StoTrainBu" ValueField="Id" DisplayField="AttributeName"
                                                            FieldLabel="产品线" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="QryTrainName" runat="server" Width="150" FieldLabel="课程名称">
                                                        </ext:TextField>
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
                                                        <ext:DateField ID="QryTrainStartBeginTime" runat="server" Width="150" FieldLabel="课程起始开始时间" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="QryTrainStartEndTime" runat="server" Width="150" FieldLabel="课程终止开始时间" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="QryTrainEndBeginTime" runat="server" Width="150" FieldLabel="课程起始结束时间" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="QryTrainEndEndTime" runat="server" Width="150" FieldLabel="课程终止结束时间" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="BtnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagTrainList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="RstTrainList" runat="server" Title="查询结果" StoreID="StoTrainList"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="TrainName" DataIndex="TrainName" Header="课程名称" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="TrainBu" DataIndex="TrainBu" Header="产品线" Width="150">
                                                    <Renderer Handler="return getNameFromStoreById(StoTrainBu,{Key:'Id',Value:'AttributeName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="TrainStartTime" DataIndex="TrainStartTime" Header="开始时间">
                                                </ext:Column>
                                                <ext:Column ColumnID="TrainEndTime" DataIndex="TrainEndTime" Header="终止时间">
                                                </ext:Column>
                                                <ext:Column ColumnID="TrainArea" DataIndex="TrainArea" Header="区域" Width="150">
                                                    <Renderer Handler="return getNameFromStoreById(StoTrainArea,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:CheckColumn ColumnID="IsSign" DataIndex="IsSign" Header="是否被签约" Align="Center">
                                                </ext:CheckColumn>
                                                <ext:CommandColumn Width="50" Header="操作" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="查看" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="
                                                if (command == 'Edit') {
                                                    Coolite.AjaxMethods.ShowTrainInfo(
                                                        record.data.TrainId,
                                                        {
                                                            success: function() {
                                                                #{RstTrainOnlineList}.reload();
                                                                #{WdwTrainInfo}.show();
                                                            },
                                                            failure: function(err) {
                                                                Ext.Msg.alert('Error', err);
                                                            }
                                                        }
                                                    );
                                                }
                                            " />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagTrainList" runat="server" PageSize="15" StoreID="StoTrainList"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中…" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Window ID="WdwTrainInfo" runat="server" Icon="Group" Title="培训课程" Resizable="false"
            Header="false" Width="800" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="FrmTrainInfo" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel11" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptTrainBu" runat="server" EmptyText="请选择产品线…" Width="200" Editable="false"
                                                            TypeAhead="true" StoreID="StoTrainBu" ValueField="Id" AllowBlank="false" DisplayField="AttributeName"
                                                            FieldLabel="产品线" ListWidth="300" Resizable="true" Enabled="false">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="IptTrainStartTime" runat="server" FieldLabel="课程起始时间" Width="200"
                                                            Format="Y-m-d" AllowBlank="false" Enabled="false" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextArea ID="IptTrainDesc" runat="server" FieldLabel="课程介绍" Width="200" Enabled="false">
                                                        </ext:TextArea>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel4" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptTrainName" runat="server" FieldLabel="课程名称" AllowBlank="false"
                                                            Width="200" Enabled="false">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="IptTrainEndTime" runat="server" FieldLabel="课程终止时间" AllowBlank="false"
                                                            Format="Y-m-d" Width="200" Enabled="false" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptTrainArea" runat="server" EmptyText="请选择区域…" Width="200" Editable="false"
                                                            AllowBlank="false" TypeAhead="true" StoreID="StoTrainArea" ValueField="Key" DisplayField="Value"
                                                            FieldLabel="区域" ListWidth="300" Resizable="true" Enabled="false">
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
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0">
                            <Tabs>
                                <ext:Tab ID="TabOnline" runat="server" Title="在线学习">
                                    <Body>
                                        <ext:FitLayout ID="FTHeader" runat="server">
                                            <ext:GridPanel ID="RstTrainOnlineList" runat="server" Title="在线学习" StoreID="StoTrainOnlineList"
                                                StripeRows="true" Border="false" Icon="Lorry" Header="false">
                                                <ColumnModel ID="ColumnModel2" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="TrainContent1" DataIndex="TrainContent1" Header="在线学习类型">
                                                            <Renderer Handler="return getNameFromStoreById(StoTrainOnlineType,{Key:'Key',Value:'Value'},value);" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TrainContent2" DataIndex="TrainContent2" Header="学习内容">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TrainContent3" DataIndex="TrainContent3" Header="学习方法">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TrainContent4" DataIndex="TrainContent4" Header="截止时间" Align="Right">
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="80" Header="操作" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="NoteEdit" CommandName="Import">
                                                                    <ToolTip Text="导入" />
                                                                </ext:GridCommand>
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" />
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagTrainOnlineList" runat="server" PageSize="10" StoreID="StoTrainOnlineList"
                                                        DisplayInfo="true" />
                                                </BottomBar>
                                                <Listeners>
                                                    <Command Handler="
                                                        if (command == 'Import') {
                                                            Coolite.AjaxMethods.ShowTrainOnlineInfo(record.data.TrainDetailId);
                                                        }
                                                    " />
                                                </Listeners>
                                                <SaveMask ShowMask="false" />
                                                <LoadMask ShowMask="false" />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                            </Tabs>
                        </ext:TabPanel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnCloseTrain" runat="server" Text="关闭" Icon="LorryAdd">
                    <Listeners>
                        <Click Handler="#{WdwTrainInfo}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Window ID="WdwTrainExamImport" runat="server" Icon="Group" Title="考试成绩导入" Resizable="false"
            Header="false" Width="750" Height="450" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:BorderLayout ID="BorderLayout3" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="FrmTrainOnlineInfo" runat="server" Header="false" Frame="true"
                            AutoHeight="true" MonitorValid="true">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel5" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout5" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptTrainOnlineType" runat="server" EmptyText="请在线学习类型…" Width="220"
                                                            Editable="false" AllowBlank="false" TypeAhead="true" StoreID="StoTrainOnlineType"
                                                            ValueField="Key" DisplayField="Value" FieldLabel="在线学习类型" ListWidth="220" Resizable="true"
                                                            Enabled="false">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptTrainOnlineContent" runat="server" FieldLabel="学习方法" AllowBlank="false"
                                                            Width="220" Enabled="false">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:FileUploadField ID="IptImportFile" runat="server" EmptyText="选择产品导入文件(Excel格式)"
                                                            FieldLabel="文件" ButtonText="" Icon="ImageAdd" Width="220" AllowBlank="false">
                                                        </ext:FileUploadField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel6" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptTrainOnlineName" runat="server" FieldLabel="学习内容" AllowBlank="false"
                                                            Width="220" Enabled="false">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="IptTrainOnlineEndTime" runat="server" Width="220" FieldLabel="截止时间"
                                                            AllowBlank="false" Enabled="false" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Listeners>
                                <ClientValidation Handler="#{BtnImportFile}.setDisabled(!valid);" />
                            </Listeners>
                            <Buttons>
                                <ext:Button ID="BtnImportFile" runat="server" Text="上传">
                                    <AjaxEvents>
                                        <Click OnEvent="BtnImportFileClick" Before="
                                            if (!#{FrmTrainOnlineInfo}.getForm().isValid()) { return false; } 
                                            Ext.Msg.wait('正在上传文件...', '文件上传');" Failure="Ext.Msg.show({ 
                                            title   : '上传失败', 
                                            msg     : '文件未被成功上传！', 
                                            minWidth: 200, 
                                            modal   : true, 
                                            icon    : Ext.Msg.ERROR, 
                                            buttons : Ext.Msg.OK 
                                            });" Success="#{BtnImportDatabase}.setDisabled(false);#{PagImportList}.changePage(1);">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="BtnReset" runat="server" Text="清除">
                                    <Listeners>
                                        <Click Handler="#{IptImportFile}.setValue('');#{BtnImportFile}.setDisabled(true);#{BtnImportDatabase}.setDisabled(true);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnImportDatabase" runat="server" Text="导入数据库">
                                    <AjaxEvents>
                                        <Click OnEvent="BtnImportDatabaseClick" Before="
                                            Ext.Msg.wait('正在导入...',
                                            '文件导入');"
                                            Success="#{PagImportList}.changePage(1)">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="BtnDownloadTemplate" runat="server" Text="下载模板" AutoPostBack="true" OnClick="BtnDownloadTemplate_Click">
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel7" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout2" runat="server">
                                    <ext:GridPanel ID="RstImportList" runat="server" Title="出错信息" StoreID="StoImportList"
                                        Border="false" Icon="Error" AutoWidth="true" StripeRows="true" EnableHdMenu="false">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="LineNum" DataIndex="LineNum" Header="行号">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerCode" DataIndex="DealerCode" Header="经销商Code">
                                                    <Renderer Fn="renderDealerCode" />
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesName" DataIndex="SalesName" Header="销售姓名">
                                                    <Renderer Fn="renderSalesName" />
                                                </ext:Column>
                                                <ext:Column ColumnID="IsPass" DataIndex="IsPass" Header="是否通过">
                                                    <Renderer Fn="renderIsPass" />
                                                </ext:Column>
                                                <ext:ImageCommandColumn Width="80">
                                                    <Commands>
                                                        <ext:ImageCommand CommandName="Edit" Icon="TableEdit">
                                                            <ToolTip Text="Edit" />
                                                        </ext:ImageCommand>
                                                        <ext:ImageCommand CommandName="Save" Icon="Disk">
                                                            <ToolTip Text="Save" />
                                                        </ext:ImageCommand>
                                                        <ext:ImageCommand CommandName="Cancel" Icon="ArrowUndo">
                                                            <ToolTip Text="Cancel" />
                                                        </ext:ImageCommand>
                                                        <ext:ImageCommand CommandName="Delete" Icon="Cross">
                                                            <ToolTip Text="Delete" />
                                                        </ext:ImageCommand>
                                                    </Commands>
                                                    <PrepareCommand Fn="prepareCommand" />
                                                </ext:ImageCommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" />
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Fn="rowCommand" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagImportList" runat="server" PageSize="10" StoreID="StoImportList"
                                                DisplayInfo="true">
                                                <Listeners>
                                                    <BeforeChange Handler="editId=''" />
                                                </Listeners>
                                            </ext:PagingToolbar>
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中…" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnCancelExamImport" runat="server" Text="返回" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{WdwTrainExamImport}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
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
