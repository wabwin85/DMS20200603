<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TenderAuthorizationList.aspx.cs" Inherits="DMS.Website.Pages.Contract.TenderAuthorizationList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"> </script>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <script type="text/javascript" language="javascript">
            function prepareCommand(grid, toolbar, rowIndex, record) {
                var firstButton = toolbar.items.get(0);
                var parmetType = record.data.States;
                if (parmetType == "审批通过") {
                    firstButton.setVisible(true);
                } else {
                    firstButton.setVisible(false);
                }
            }

            function prepareCommander(grid, toolbar, rowIndex, record) {
                var firstButton = toolbar.items.get(0);
                var parmetType = record.data.States;
                var apyusercode = record.data.UserCode;
                var usercode = Ext.getCmp('<%=this.hidUserCode.ClientID%>').getValue();
                if ((parmetType == "审批拒绝" || parmetType == "草稿") && apyusercode.toLowerCase() == usercode.toLowerCase()) {
                    firstButton.setVisible(true);
                } else {
                    firstButton.setVisible(false);
                }
            }

            function prepareCommandApply(grid, toolbar, rowIndex, record) {
                var firstButton = toolbar.items.get(0);
                var parmetType = record.data.States;
                var apyusercode = record.data.UserCode;
                var usercode = Ext.getCmp('<%=this.hidUserCode.ClientID%>').getValue();
                if (parmetType == "审批中" || (parmetType == "审批拒绝" && apyusercode.toLowerCase() == usercode.toLowerCase())) {
                    firstButton.setVisible(true);
                } else {
                    firstButton.setVisible(false);
                }
            }

        </script>
        <ext:Store ID="HospitalStore" runat="server" UseIdConfirmation="false" OnRefreshData="HospitalStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="DTH_ID" />
                        <ext:RecordField Name="DTH_DTM_ID" />
                        <ext:RecordField Name="HOS_HospitalName" />
                        <ext:RecordField Name="DTH_HospitalDept" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <%-- 授权类型 --%>
        <ext:Store ID="ExpAuthorizationStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="ExpHospitalStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="HospitalId">
                    <Fields>
                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="HospitalName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="HospitalId" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="StatesStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>

        <ext:Store ID="AuthorizationStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            UseIdConfirmation="false" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="DTM_ID" />
                        <ext:RecordField Name="DTM_NO" />
                        <ext:RecordField Name="DTM_DealerName" />
                        <ext:RecordField Name="DTM_ApplicType" />
                        <ext:RecordField Name="DTM_BeginDate" />
                        <ext:RecordField Name="DTM_EndDate" />
                        <ext:RecordField Name="UserCode" />
                        <ext:RecordField Name="UserName" />
                        <ext:RecordField Name="CreateDate" />
                        <ext:RecordField Name="States" />
                        <ext:RecordField Name="ApprovedDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <div id="DivHidden">
            <ext:Hidden ID="hidDtmId" runat="server"></ext:Hidden>
            <ext:Hidden runat="server" ID="HiddenID"></ext:Hidden>
            <ext:Hidden runat="server" ID="hidUserCode"></ext:Hidden>
            <ext:Hidden runat="server" ID="DTM_NO"></ext:Hidden>
            <ext:Hidden runat="server" ID="ExpHospital"></ext:Hidden>
        </div>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="招标授权书查询" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="150">
                                                    <ext:Anchor>
                                                        <ext:TextField runat="server" ID="AuthorizationNo" FieldLabel="授权书编号" Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField runat="server" ID="dealer" FieldLabel="经销商" Width="150"></ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbStatesType" runat="server" EmptyText="全部"
                                                            Width="150" Editable="false" TypeAhead="true" StoreID="StatesStore" ValueField="Key"
                                                            Mode="Local" DisplayField="Value" FieldLabel="审批状态">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField runat="server" ID="Hospital" FieldLabel="医院名称" Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="120">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="StartBeginsDate" runat="server" Width="150" FieldLabel="授权起始开始时间" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="StartEndDate" runat="server" Width="150" FieldLabel="授权终止开始时间" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="BeginApprovedDate" runat="server" Width="150" FieldLabel="审批完成时间开始" />
                                                    </ext:Anchor>
                                                    <%-- 授权类型--%>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="Authorization" runat="server" EmptyText="全部"
                                                            Width="150" Editable="false" TypeAhead="true" StoreID="AuthorizationStore" ValueField="Key"
                                                            Mode="Local" DisplayField="Value" FieldLabel="授权类型">
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
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="120">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="StopBeginsDate" runat="server" Width="150" FieldLabel="授权起始结束时间" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="StopEndDate" runat="server" Width="150" FieldLabel="授权终止结束时间" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="EndApprovedDate" runat="server" Width="150" FieldLabel="审批完成时间终止" />
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
                                <ext:Button ID="Button1" Text="导出" runat="server" Icon="PageExcel" OnClick="ExportToExcel" AutoPostBack="true" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btninsert" runat="server" Text="新增" Icon="Add">
                                    <Listeners>
                                        <Click Handler="window.location.href ='/Pages/Contract/TenderAuthorizationInfo.aspx';" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DTM_NO" DataIndex="DTM_NO" Header="授权书编号" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="DTM_DealerName" DataIndex="DTM_DealerName" Header="经销商名称" Width="190">
                                                </ext:Column>
                                                <%-- 授权类型--%>
                                                <ext:Column ColumnID="DTM_ApplicType" DataIndex="DTM_ApplicType" Header="授权类型" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="DTM_BeginDate" DataIndex="DTM_BeginDate" Header="授权开始时间" Width="100">
                                                    <%--    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />--%>
                                                </ext:Column>
                                                <ext:Column ColumnID="DTM_EndDate" DataIndex="DTM_EndDate" Header="授权终止时间" Width="100">
                                                    <%-- <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />--%>
                                                </ext:Column>
                                                <ext:Column ColumnID="States" DataIndex="States" Header="审批状态" Width="90">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="申请人" Width="90">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="申请时间" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="ApprovedDate" DataIndex="ApprovedDate" Header="审批完成时间" Width="100">
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="编辑">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="编辑" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                    <PrepareToolbar Fn="prepareCommander" />
                                                </ext:CommandColumn>
                                                <ext:CommandColumn Width="60" Header="导出">
                                                    <Commands>
                                                        <ext:GridCommand Icon="PageWhiteAcrobat" CommandName="Export">
                                                            <ToolTip Text="导出授权书" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                    <PrepareToolbar Fn="prepareCommand" />
                                                </ext:CommandColumn>

                                                <ext:CommandColumn Width="60" Header="审批">
                                                    <Commands>
                                                        <ext:GridCommand Icon="PageGo" CommandName="Look">
                                                            <ToolTip Text="授权审批" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                    <PrepareToolbar Fn="prepareCommandApply" />
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler=" if(command == 'Export')
                                                { 
                                                    Coolite.AjaxMethods.ExportWindowShow(record.data.DTM_ID);
                                                }
                                                else if (command == 'Edit'){
                                                    window.location.href ='/Pages/Contract/TenderAuthorizationInfo.aspx?DtmId=' + record.data.DTM_ID;
                                                }
                                                else if(command == 'Look')
                                                {
                                                    Coolite.AjaxMethods.GetEkpHistoryPageUrl(record.data.DTM_ID,{success:function(res){window.open(res,'full','fullscreen');}});
                                                }
                                                ;" />
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
        <%-- 导出弹窗 HospitalStore--%>
        <ext:Window ID="ExportWindow" runat="server" Icon="Group" Title="导出授权书"
            Width="400" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
            <Body>
                <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="100">
                    <ext:Anchor>
                        <ext:TextField runat="server" ID="ApplicType" FieldLabel="合同类型" Enabled="false" Width="210"></ext:TextField>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:ComboBox ID="cbFileType" runat="server" EmptyText="请选择授权类型" Editable="false" TypeAhead="true"
                            StoreID="ExpAuthorizationStore" ValueField="Key" Mode="Local" DisplayField="Value" FieldLabel="授权类型" Resizable="true">
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
            <Buttons>
                <ext:Button ID="BtnDownload" runat="server" Text="导出授权书">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.BtnDownloadPDF({
                                success: function(result) {
                                  var url = '../Download.aspx?downloadname=' + escape(#{DTM_NO}.getValue()) + '&filename=' + escape(result) + '&downtype=TenderFile';
                                    open(url, 'Download');
                                },failure: function(err) {
                                     Ext.Msg.alert('Error', err);
                                    }
                            });" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="Close" runat="server" Text="关闭" Icon="PageCancel" IDMode="Legacy">
                    <Listeners>
                        <Click Handler="#{ExportWindow}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
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
