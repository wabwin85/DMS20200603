<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SampleReturnInfo.aspx.cs"
    Inherits="DMS.Website.Pages.SampleManage.SampleReturnInfo" %>

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
        .x-form-empty-field
        {
            color: #bbbbbb;
            font: normal 11px arial, tahoma, helvetica, sans-serif;
        }
        .x-small-editor .x-form-field
        {
            font: normal 11px arial, tahoma, helvetica, sans-serif;
        }
        .x-small-editor .x-form-text
        {
            height: 20px;
            line-height: 16px;
            vertical-align: middle;
        }
        .editable-column
        {
            background: #FFFF99;
        }
        .nonEditable-column
        {
            background: #FFFFFF;
        }
        .yellow-row
        {
            background: #FFD700;
        }
        .lightyellow-row
        {
            background: #FFFFD8;
        }
        .x-panel-body
        {
            background-color: #dfe8f6;
        }
        .x-column-inner
        {
            height: auto !important;
            width: auto !important;
        }
        .list-item
        {
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
        function SaveReceive() {
            Ext.Msg.confirm('Message', "是否确认收货？",
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.SaveReceive(
                            {
                                success: function() {
                                    Ext.Msg.alert('Message', '确认收货成功！');
                                    Ext.getCmp('<%=this.BtnReceive.ClientID%>').hide();
                                    Ext.getCmp('<%=this.IptReturnStatus.ClientID%>').setValue('确认收货');
                                    Ext.getCmp('<%=this.RstOperLog.ClientID%>').reload();
                                },
                                failure: function(err) {
                                    Ext.Msg.alert('Error', err);
                                }
                            }
                        );
                    }
                }
            );
        }
    </script>

    <div id="DivStore">
        <ext:Store ID="StoUpn" runat="server" AutoLoad="true" OnRefreshData="StoUpn_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="SampleUpnId">
                    <Fields>
                        <ext:RecordField Name="SampleUpnId" />
                        <ext:RecordField Name="ApplyNo" />
                        <ext:RecordField Name="UpnNo" />
                        <ext:RecordField Name="ProductName" />
                        <ext:RecordField Name="ProductDesc" />
                        <ext:RecordField Name="ApplyQuantity" />
                        <ext:RecordField Name="ConfirmQuantity" />
                        <ext:RecordField Name="Lot" />
                        <ext:RecordField Name="LotReuqest" />
                        <ext:RecordField Name="ProductMemo" />
                        <ext:RecordField Name="SortNo" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoOperLog" runat="server" AutoLoad="true" OnRefreshData="StoOperLog_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="OperUserName" />
                        <ext:RecordField Name="OperType" />
                        <ext:RecordField Name="OperDate" Type="Date" />
                        <ext:RecordField Name="OperNote" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
    </div>
    <div id="DivHidden">
        <ext:Hidden ID="IptSampleHeadId" runat="server">
        </ext:Hidden>
    </div>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <Center MarginsSummary="0 0 0 0">
                    <ext:Panel ID="Panel2" runat="server" Header="false" BodyStyle="padding: 5px;" AutoScroll="true">
                        <Body>
                            <ext:RowLayout ID="RowLayout1" runat="server">
                                <ext:LayoutRow>
                                    <ext:Panel ID="Panel6" runat="server" Header="false" Frame="false" BodyBorder="false"
                                        AutoHeight="true">
                                        <Body>
                                            <div style="text-align: center; font-size: medium; font-family: 微软雅黑;">
                                                <asp:Literal ID="Literal1" runat="server" Text="样品退货单" /></div>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutRow>
                                <ext:LayoutRow>
                                    <ext:FieldSet ID="DivSampleReturn" runat="server" Header="true" Frame="false" BodyBorder="true"
                                        AutoHeight="true" AutoWidth="true" Title="样品退货单">
                                        <Body>
                                            <ext:FormLayout runat="server" ID="a">
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel20" runat="server" Header="false" Border="false">
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel21" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout13" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptSampleType" ReadOnly="true" runat="server" FieldLabel="样品类型"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptReturnNo" ReadOnly="true" runat="server" FieldLabel="退货单编号"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptReturnStatus" ReadOnly="true" runat="server" FieldLabel="单据状态"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <%--<ext:Anchor>
                                                                                    <ext:TextField ID="IptReturnRequire" ReadOnly="true" runat="server" FieldLabel="退货要求"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptReturnDept" ReadOnly="true" runat="server" FieldLabel="部门"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>--%>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel22" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout14" runat="server" LabelAlign="Left" LabelWidth="110">
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptReturnDate" ReadOnly="true" runat="server" FieldLabel="申请日期"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptApplyNo" ReadOnly="true" runat="server" FieldLabel="申请单编号"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                               <ext:Anchor>
                                                                                    <ext:TextField ID="IptCourierNumber" ReadOnly="true" runat="server" FieldLabel="提货地址/快递单号"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".34">
                                                                    <ext:Panel ID="Panel27" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout15" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptReturnUser" ReadOnly="true" runat="server" FieldLabel="申请人"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <%--<ext:Anchor>
                                                                                    <ext:TextField ID="IptProcessUser" ReadOnly="true" runat="server" FieldLabel="处理人"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>--%>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptReturnHosp" ReadOnly="true" runat="server" FieldLabel="医院"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                 <ext:Anchor>
                                                                                    <ext:TextField ID="IptReturnQuantity" ReadOnly="true" runat="server" FieldLabel="申请退货总数量"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                            </ext:ColumnLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel28" runat="server" Header="false" Border="false">
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                                                <ext:LayoutColumn ColumnWidth=".66">
                                                                    <ext:Panel ID="Panel29" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout18" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <%--<ext:Anchor>
                                                                                    <ext:TextField ID="IptDealerName" ReadOnly="true" runat="server" FieldLabel="经销商"
                                                                                        Width="600">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptReturnReason" ReadOnly="true" runat="server" FieldLabel="退货原因"
                                                                                        Width="600">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>--%>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptReturnMemo" ReadOnly="true" runat="server" FieldLabel="备注"
                                                                                        Width="600">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <%--<ext:LayoutColumn ColumnWidth=".34">
                                                                    <ext:Panel ID="Panel33" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout21" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                               
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>--%>
                                                            </ext:ColumnLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:FieldSet>
                                </ext:LayoutRow>
                                <ext:LayoutRow>
                                    <ext:Panel ID="Panel57" runat="server" Border="false" Header="false" BodyStyle="padding-top:5px;padding-bottom:5px;">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout18" runat="server">
                                                <ext:LayoutColumn ColumnWidth="1">
                                                    <ext:GridPanel ID="RstUpn" runat="server" Title="UPN列表" StoreID="StoUpn" AutoScroll="false"
                                                        StripeRows="true" Collapsible="false" Border="true" Header="true" Icon="Lorry"
                                                        AutoExpandColumn="ProductMemo" Height="200" AutoWidth="true">
                                                        <ColumnModel ID="ColumnModel2" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="UpnNo" DataIndex="UpnNo" Header="UPN编号" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductName" DataIndex="ProductName" Header="产品名称" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductDesc" DataIndex="ProductDesc" Header="描述" Width="180">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ApplyQuantity" DataIndex="ApplyQuantity" Header="申请数量" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Lot" DataIndex="Lot" Header="批号#" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="LotReuqest" DataIndex="LotReuqest" Header="RA批次要求" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductMemo" DataIndex="ProductMemo" Header="备注" Width="150">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                                                MoveEditorOnEnter="true">
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <SaveMask ShowMask="false" />
                                                        <LoadMask ShowMask="true" />
                                                    </ext:GridPanel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutRow>
                                <ext:LayoutRow>
                                    <ext:Panel ID="Panel19" runat="server" Border="false" Header="false" BodyStyle="padding-top:5px;padding-bottom:5px;">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout20" runat="server">
                                                <ext:LayoutColumn ColumnWidth="1">
                                                    <ext:GridPanel ID="RstOperLog" runat="server" Title="操作记录" StoreID="StoOperLog" AutoScroll="true"
                                                        StripeRows="true" Collapsible="false" Border="true" Icon="Lorry" AutoExpandColumn="OperNote"
                                                        Height="200" AutoWidth="true">
                                                        <ColumnModel ID="ColumnModel4" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="操作人姓名" Width="200">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="OperType" DataIndex="OperType" Header="操作类型" Width="200">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="操作日期" Width="200">
                                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                                </ext:Column>
                                                                <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="备注" Width="200">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server"
                                                                MoveEditorOnEnter="true">
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <SaveMask ShowMask="false" />
                                                        <LoadMask ShowMask="true" />
                                                    </ext:GridPanel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutRow>
                            </ext:RowLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="BtnReceive" runat="server" Text="确认收货" Icon="BookNext" Hidden="true">
                                <Listeners>
                                    <Click Handler="SaveReceive();" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="BtnClose" runat="server" Text="关闭" Icon="Cancel">
                                <Listeners>
                                    <Click Handler="top.ExampleTabs.closeTab(top.ExampleTabs.getActiveTab(), 'close');" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
