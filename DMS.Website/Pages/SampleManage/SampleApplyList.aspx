<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SampleApplyList.aspx.cs"
    Inherits="DMS.Website.Pages.SampleManage.SampleApplyList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"></script>

    <style type="text/css">
        .x-form-empty-field {
            color: #bbbbbb;
            font: normal 11px arial, tahoma, helvetica, sans-serif;
        }

        .x-small-editor .x-form-field {
            font: normal 11px arial, tahoma, helvetica, sans-serif;
        }

        .x-small-editor .x-form-text {
            height: 20px;
            line-height: 16px;
            vertical-align: middle;
        }

        .editable-column {
            background: #FFFF99;
        }

        .nonEditable-column {
            background: #FFFFFF;
        }

        .yellow-row {
            background: #FFD700;
        }

        .lightyellow-row {
            background: #FFFFD8;
        }

        .x-panel-body {
            background-color: #dfe8f6;
        }

        .x-column-inner {
            height: auto !important;
            width: auto !important;
        }

        .list-item {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
            padding: 3px 10px 3px 10px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #555;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />

        <script type="text/javascript">
            var SampleDetailsRender = function (para) {
                return '<img class="imgEdit" ext:qtip="明细" style="cursor:pointer;" src="../../resources/images/icons/vcard_edit.png" />';
            }

            var cellClick = function (grid, rowIndex, columnIndex, e) {  //gradpanel events
                var t = e.getTarget();

                var record = grid.getStore().getAt(rowIndex);  // Get the Record

                var test = "1";

                var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

                if (t.className == 'imgEdit' && columnId == 'Details') {

                    //                window.parent.loadExample('/Pages/SampleManage/SampleReturnInfo.aspx?HeadId=' + record.data["Id"]+,'&ReturnNo=' + record.data["ReturnNo"]);
                    //window.parent.loadExample('/Pages/SampleManage/SampleApplyInfo.aspx?HeadId=' + record.data["Id"], 'dp' + record.data["Id"], '样品申请单 - ' + record.data["ApplyNo"]);
                    top.createTab({ id: 'dp' + record.data["Id"], title: '样品申请单', url: 'Pages/SampleManage/SampleApplyInfo.aspx?HeadId=' + record.data["Id"] });
                    
                }
            }

            function SampleDetailsApproval(grid, toolbar, rowIndex, record) {
                var firstButton = toolbar.items.get(0);
                var parmetType = record.data.SampleType;
                var parmetStatus = record.data.ApplyStatus;
                if (parmetType == "商业样品" && parmetStatus == "InApproval") {
                    firstButton.setVisible(true);
                } else {
                    firstButton.setVisible(false);
                }
            }
        </script>

        <div id="DivStore">
            <ext:Store ID="StoSampleList" runat="server" AutoLoad="true" OnRefreshData="StoSampleList_RefershData">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="Id">
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="SampleType" />
                            <ext:RecordField Name="Qty" />
                            <ext:RecordField Name="ApplyDate" />
                            <ext:RecordField Name="ApplyNo" />
                            <ext:RecordField Name="ApplyStatus" />
                            <ext:RecordField Name="Remark" />
                            <ext:RecordField Name="ApplyUser" />
                            <ext:RecordField Name="HospName" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="StoSampleStatus" runat="server" UseIdConfirmation="true">
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
        </div>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="样品申请列表" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".25">
                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptSampleType" runat="server" EmptyText="请选择样品类型" Editable="false"
                                                            TypeAhead="true" Resizable="true" FieldLabel="样品类型" Width="200">
                                                            <Items>
                                                                <ext:ListItem Text="商业样品" Value="商业样品" />
                                                                <ext:ListItem Text="测试样品" Value="测试样品" />
                                                                <ext:ListItem Text="临床样品" Value="临床样品" />
                                                            </Items>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <BeforeQuery />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptHosName" FieldLabel="医院" Width="200" runat="server">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".25">
                                        <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptApplyNo" runat="server" FieldLabel="申请单编号" LabelWidth="80"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptApplyUser" runat="server" FieldLabel="申请人" Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".25">
                                        <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptApplyStatus" runat="server" EmptyText="请选择申请状态" Editable="false"
                                                            TypeAhead="true" Resizable="true" FieldLabel="申请状态" Width="200">
                                                            <Items>
                                                                <ext:ListItem Text="新申请" Value="New" />
                                                                <ext:ListItem Text="审批中" Value="InApproval" />
                                                                <ext:ListItem Text="审批通过" Value="Approved" />
                                                                <ext:ListItem Text="审批拒绝" Value="Deny" />
                                                                <ext:ListItem Text="已发货" Value="Delivery" />
                                                                <ext:ListItem Text="收货确认" Value="Receive" />
                                                                <ext:ListItem Text="已完成" Value="Complete" />
                                                            </Items>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <BeforeQuery />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tbUPN" runat="server" FieldLabel="UPN" Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".25">
                                        <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="ddlStatus" runat="server" EmptyText="请选择发货状态" Editable="false"
                                                            TypeAhead="true" Resizable="true" FieldLabel="发货状态" Width="200">
                                                            <Items>
                                                                <ext:ListItem Text="DP确认采购" Value="DP" />
                                                                <ext:ListItem Text="SS确认发货" Value="CS" />
                                                                <ext:ListItem Text="RA确认收货" Value="Complete" />
                                                            </Items>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <BeforeQuery />
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
                                <ext:Button ID="BtnSearch" Text="查询" runat="server" Icon="ArrowRefresh">
                                    <Listeners>
                                        <Click Handler="#{PagSampleList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="RstSampleList" runat="server" Title="样品申请列表" StoreID="StoSampleList"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ApplyNo" DataIndex="ApplyNo" Header="申请单编号" Width="180">
                                                </ext:Column>
                                                <ext:Column ColumnID="HospName" DataIndex="HospName" Header="医院" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="Qty" DataIndex="Qty" Header="申请数量" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="ApplyUser" DataIndex="ApplyUser" Header="申请人" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ApplyDate" DataIndex="ApplyDate" Header="申请日期" Width="150" Align="Right">
                                                </ext:Column>
                                                <ext:Column ColumnID="ApplyStatus" DataIndex="ApplyStatus" Header="状态" Align="Center">
                                                    <Renderer Handler="return getNameFromStoreById(StoSampleStatus,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Details" Header="明细" Width="50" Align="Center" Fixed="true"
                                                    MenuDisabled="true" Resizable="false">
                                                    <Renderer Fn="SampleDetailsRender" />
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="审批">
                                                    <Commands>
                                                        <ext:GridCommand Icon="PageEdit" CommandName="Apprpval">
                                                            <ToolTip Text="审批" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                    <PrepareToolbar Fn="SampleDetailsApproval" />
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <CellClick Fn="cellClick" />
                                            <%--<Command Handler="if(command == 'Apprpval')
                                                {
                                                 Coolite.AjaxMethods.CheckApply(record.data.Id,
                                                    {success: function(result) { 
                                                        if(result==''){
                                                            window.parent.loadExample('/Pages/SampleManage/SampleApplyApproval.aspx?HeadId=' + record.data.Id, 'dp' + record.data.Id, '样品申请单 - ' + record.data.ApplyNo);
                                                        }else
                                                        {
                                                            Ext.Msg.alert('Error', result);
                                                        }},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                 
                                                }
                                                ;" />--%>

                                                <Command Handler="if(command == 'Apprpval')
                                                    {
                                                     Coolite.AjaxMethods.CheckApply(record.data.Id,
                                                        {success: function(result) { 
                                                            if(result==''){
                                                                top.createTab({id:'dp' + record.data.Id,title: '样品申请单',url: 'Pages/SampleManage/SampleApplyApproval.aspx?HeadId=' + record.data.Id});
                                                               
                                                            }else
                                                            {
                                                                Ext.Msg.alert('Error', result);
                                                            }},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                 
                                                    }
                                                    ;" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagSampleList" runat="server" PageSize="15" StoreID="StoSampleList"
                                                DisplayInfo="false" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="正在查询..." />
                                        <Listeners>
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </form>
</body>
</html>
