<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SampleApplyInfo.aspx.cs"
    Inherits="DMS.Website.Pages.SampleManage.SampleApplyInfo" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"></script>

    <script src="../../resources/data-view-plugins.js" type="text/javascript"></script>

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
        .images-view .x-panel-body
        {
            background: white;
            font: 11px Arial, Helvetica, sans-serif;
        }
        .images-view .thumb
        {
            background: #dddddd;
            padding: 3px;
            height: 80px;
            width: 150px;
        }
        .images-view .thumb img
        {
            height: 80px;
            width: 150px;
        }
        .images-view .thumb-wrap
        {
            float: left;
            margin: 4px;
            margin-right: 0;
            padding: 5px;
            text-align: center;
            height: 120px;
            width: 160px;
        }
        .images-view .thumb-wrap span
        {
            display: block;
            overflow: hidden;
            text-align: center;
        }
        .images-view .x-view-over
        {
            border: 1px solid #dddddd;
            background: #efefef repeat-x left top;
            padding: 4px;
        }
        .images-view .x-view-selected
        {
            background: #eff5fb;
            border: 1px solid #99bbe8 no-repeat right bottom;
            padding: 4px;
        }
        .images-view .x-view-selected .thumb
        {
            background: transparent;
        }
        .images-view .loading-indicator
        {
            font-size: 11px;
            background-image: url(../../resources/images/loading.gif);
            background-repeat: no-repeat;
            background-position: left;
            padding-left: 20px;
            margin: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />

    <script type="text/javascript">
        function SaveDpDelivery() {
            var errMsg = "";

            var isFormValid = Ext.getCmp('<%=this.FrmDpDelivery.ClientID%>').getForm().isValid();

            if (!isFormValid) {
                errMsg = "请填写完整发货信息";
            } else {
                var remainQty = parseFloat(Ext.getCmp('<%=this.IptDpDeliveryRemainQuantity.ClientID%>').getValue());
                var deliveryQty = parseFloat(Ext.getCmp('<%=this.IptDpDeliveryQuantity.ClientID%>').getValue());
                var convertFactor = parseInt(Ext.getCmp('<%=this.IptDpDelvieryConvertFactor.ClientID%>').getValue());
                if (deliveryQty > remainQty) {
                    errMsg = "发货数量不能大于剩余数量";
                } else {
                    var re = /^[1-9]\d*$/;
                    if (!re.test(deliveryQty * convertFactor)) {
                        errMsg = "填写的销售数量有误";
                    }
                }
            }

            if (errMsg != "") {
                Ext.Msg.alert('Message', errMsg);
            } else {
            Ext.Msg.confirm('Message', "是否确认采购数量？",
                    function(e) {
                        if (e == 'yes') {
                            Coolite.AjaxMethods.SaveDpDelivery(
                                {
                                    success: function() {
                                        Ext.Msg.alert('Message', 'DP确认采购数量成功');
                                        Ext.getCmp('<%=this.WdwDpDelivery.ClientID%>').hide();
                                        Ext.getCmp('<%=this.RstSampleTrace.ClientID%>').reload();
                                        Ext.getCmp('<%=this.RstDelivery.ClientID%>').reload();
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
        }

        function SaveIeDelivery(deliveryId) {
            var errMsg = "";

            Ext.Msg.confirm('Message', "是否确认清关数量？",
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.SaveIeDelivery(
                            deliveryId,
                            {
                                success: function() {
                                    Ext.Msg.alert('Message', 'IE确认清关数量成功');
                                    Ext.getCmp('<%=this.RstSampleTrace.ClientID%>').reload();
                                    Ext.getCmp('<%=this.RstDelivery.ClientID%>').reload();
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

        function SaveCsDelivery(deliveryId) {
            var errMsg = "";

            Ext.Msg.confirm('Message', "是否RA确认发货数量？",
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.SaveCsDelivery(
                            deliveryId,
                            {
                                success: function() {
                                    Ext.Msg.alert('Message', 'RA确认发货数量成功');
                                    Ext.getCmp('<%=this.RstSampleTrace.ClientID%>').reload();
                                    Ext.getCmp('<%=this.RstDelivery.ClientID%>').reload();
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

        var PrepareIeDelivery = function(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            if (record.data.DeliveryStatus != 'DP确认采购') {
                firstButton.hide();
            }
        }

        var PrepareCsDelivery = function(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            if (record.data.DeliveryStatus != 'DP确认采购') {
                firstButton.hide();
            }
        }

        var PrepareDpDelivery = function(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            //if (Ext.getCmp("IsNewCertificate").getValue() != 'True') {
            if (Ext.getCmp('<%=this.IsNewCertificate.ClientID%>').getValue() != 'True') {
                firstButton.hide();
            }
        }

            var DoAgree = function() {
                Ext.Msg.confirm('Message', "是否确认审批通过？",
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.Agree(
                            {
                                success: function() {
                                    
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
<%--        <ext:Store ID="StoSampleTesting" runat="server" AutoLoad="true" OnRefreshData="StoSampleTesting_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="SampleTestingId">
                    <Fields>
                        <ext:RecordField Name="SampleTestingId" />
                        <ext:RecordField Name="Division" />
                        <ext:RecordField Name="Priority" />
                        <ext:RecordField Name="Certificate" />
                        <ext:RecordField Name="CostCenter" />
                        <ext:RecordField Name="ArrivalDate" />
                        <ext:RecordField Name="Irf" />
                        <ext:RecordField Name="Ra" />
                        <ext:RecordField Name="SortNo" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
--%>        <ext:Store ID="StoUpn" runat="server" AutoLoad="true" OnRefreshData="StoUpn_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="SampleUpnId">
                    <Fields>
                        <ext:RecordField Name="SampleUpnId" />
                        <ext:RecordField Name="UpnNo" />
                        <ext:RecordField Name="ProductName" />
                        <ext:RecordField Name="ProductDesc" />
                        <ext:RecordField Name="ApplyQuantity" />
                        <ext:RecordField Name="ConfirmQuantity" />
                        <ext:RecordField Name="Lot" />
                        <ext:RecordField Name="LotReuqest" />
                        <ext:RecordField Name="ProductMemo" />
                        <ext:RecordField Name="SortNo" />
                        <ext:RecordField Name="Cost" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoSampleTrace" runat="server" AutoLoad="true" OnRefreshData="StoSampleTrace_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Lot">
                    <Fields>
                        <ext:RecordField Name="UpnNo" />
                        <ext:RecordField Name="Lot" />
                        <ext:RecordField Name="DeliveryQuantity" />
                        <ext:RecordField Name="ReciveQuantity" />
                        <ext:RecordField Name="EvalQuantity" />
                        <ext:RecordField Name="ReturnQuantity" />
                        <ext:RecordField Name="RemainQuantity" />
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
        <ext:Store ID="StoDelivery" runat="server" AutoLoad="true" OnRefreshData="StoDelivery_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="DeliveryId">
                    <Fields>
                        <ext:RecordField Name="DeliveryId" />
                        <ext:RecordField Name="UpnNo" />
                        <ext:RecordField Name="ProductName" />
                        <ext:RecordField Name="ProductDesc" />
                        <ext:RecordField Name="DeliveryQuantity" />
                        <ext:RecordField Name="Lot" />
                        <ext:RecordField Name="DeliveryStatus" />
                        <ext:RecordField Name="ProductMemo" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoRemain" runat="server" AutoLoad="false" OnRefreshData="StoRemain_RefershData">
            <Reader>
                <ext:JsonReader ReaderID="UpnNo">
                    <Fields>
                        <ext:RecordField Name="UpnNo" />
                        <ext:RecordField Name="ProductName" />
                        <ext:RecordField Name="ProductDesc" />
                        <ext:RecordField Name="RemainQuantity" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoEval" runat="server" AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="EvalUrl">
                    <Fields>
                        <ext:RecordField Name="EvalName" />
                        <ext:RecordField Name="EvalUrl" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
    </div>
    <div id="DivHidden">
        <ext:Hidden ID="IptSampleHeadId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IsNewCertificate" runat="server">
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
                                                <asp:Literal ID="Literal1" runat="server" Text="样品申请单" /></div>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutRow>
                                <ext:LayoutRow>
                                    <ext:FieldSet ID="DivSampleBusiness" runat="server" Header="true" Frame="false" BodyBorder="true"
                                        AutoHeight="true" AutoWidth="true" Title="样品申请单" Hidden="true">
                                        <Body>
                                            <ext:FormLayout runat="server" ID="a">
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel1" runat="server" Header="false" Border="false">
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessSampleType" ReadOnly="true" runat="server" FieldLabel="样品类型"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptApplyUser" ReadOnly="true" runat="server" FieldLabel="申请人"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessApplyStatus" ReadOnly="true" runat="server" FieldLabel="单据状态"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessHospName" ReadOnly="true" runat="server" FieldLabel="医院名称"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessReceiptUser" ReadOnly="true" runat="server" FieldLabel="收货人"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessIrfNo" ReadOnly="true" runat="server" FieldLabel="IRF编号"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <%--<ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessApplyDate" ReadOnly="true" runat="server" FieldLabel="申请日期"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessApplyDept" ReadOnly="true" runat="server" FieldLabel="部门"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>--%>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:Label ID="Label1" runat="server" LabelSeparator="&nbsp;" Text="&nbsp;" Height="22" />
                                                                                </ext:Anchor>
                                                                                <%--<ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessApplyQuantity" ReadOnly="true" runat="server" FieldLabel="申请数量"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>--%>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptApplyDate" ReadOnly="true" runat="server" FieldLabel="申请时间"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessApplyNo" ReadOnly="true" runat="server" FieldLabel="申请单编号"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessHpspAddress" ReadOnly="true" runat="server" FieldLabel="医院地址"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessReceiptPhone" ReadOnly="true" runat="server" FieldLabel="收货人联系方式"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <%--<ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessApplyDivision" ReadOnly="true" runat="server" FieldLabel="事业部"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessApplyCost" ReadOnly="true" runat="server" FieldLabel="费用分摊"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>--%>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".34">
                                                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:Label ID="Label2" runat="server" LabelSeparator="&nbsp;" Text="&nbsp;" Height="22" />
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptCostCenter" ReadOnly="true" runat="server" FieldLabel="CostCenter"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessApplyPurpose" ReadOnly="true" runat="server" FieldLabel="申请目的"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessTrialDoctor" ReadOnly="true" runat="server" FieldLabel="试用医生姓名"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessReceiptAddress" ReadOnly="true" runat="server" FieldLabel="收货地址"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>                                                                                
                                                                                <%--<ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessProcessUser" ReadOnly="true" runat="server" FieldLabel="使用人"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessApplyUser" ReadOnly="true" runat="server" FieldLabel="申请者"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessArrivalDate" ReadOnly="true" runat="server" FieldLabel="期望到货时间"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>--%>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                            </ext:ColumnLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel7" runat="server" Header="false" Border="false">
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                                <ext:LayoutColumn ColumnWidth=".66">
                                                                    <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <%--<ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessDealerName" ReadOnly="true" runat="server" FieldLabel="经销商"
                                                                                        Width="600" Height="22">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>--%>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="Ipt6MonthsExpProduct" ReadOnly="true" runat="server" FieldLabel="是否接受<6个月效期的产品"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextArea ID="IptBusinessApplyMemo" ReadOnly="true" runat="server" FieldLabel="备注"
                                                                                        Width="600" Height="44">
                                                                                    </ext:TextArea>
                                                                                </ext:Anchor>                                                                                
                                                                                <ext:Anchor>
                                                                                    <ext:Checkbox ID="IptBusinessConfirmItem1" ReadOnly="true" runat="server" FieldLabel="已确认事项1"
                                                                                        Width="600" BoxLabel="样品需在收到后尽快试用，三十天内上传样品评估表">
                                                                                    </ext:Checkbox>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:Checkbox ID="IptBusinessConfirmItem2" ReadOnly="true" runat="server" FieldLabel="已确认事项1"
                                                                                        Width="600" BoxLabel="样品不得转售">
                                                                                    </ext:Checkbox>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                            </ext:ColumnLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:FieldSet>
                                </ext:LayoutRow>
                                <ext:LayoutRow>
                                    <ext:FieldSet ID="DivSampleTest" runat="server" Header="true" Frame="false" BodyBorder="true"
                                        AutoHeight="true" AutoWidth="true" Title="样品申请单" Hidden="true">
                                        <Body>
                                            <ext:FormLayout runat="server" ID="FormLayout8">
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel13" runat="server" Header="false" Border="false">
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestSampleType" ReadOnly="true" runat="server" FieldLabel="样品类型"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestApplyStatus" ReadOnly="true" runat="server" FieldLabel="单据状态"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestApplyDate" ReadOnly="true" runat="server" FieldLabel="申请日期"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestApplyDept" ReadOnly="true" runat="server" FieldLabel="部门"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestCustType" ReadOnly="true" runat="server" FieldLabel="客户类型"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="tbDivision" ReadOnly="true" runat="server" FieldLabel="业务部"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="tbCostCenter" ReadOnly="true" runat="server" FieldLabel="成本中心"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="tbRA" ReadOnly="true" runat="server" FieldLabel="RA项目"
                                                                                        Width="300">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel15" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:Label ID="Label3" runat="server" LabelSeparator="&nbsp;" Text="&nbsp;" Height="22" />
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestApplyQuantity" ReadOnly="true" runat="server" FieldLabel="申请数量"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestApplyNo" ReadOnly="true" runat="server" FieldLabel="申请单编号"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestApplyDivision" ReadOnly="true" runat="server" FieldLabel="事业部"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestCustName" ReadOnly="true" runat="server" FieldLabel="客户名称"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="tbPriority" ReadOnly="true" runat="server" FieldLabel="优先级"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="tbArrivalDate" ReadOnly="true" runat="server" FieldLabel="期望到货日期"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>  
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestReceiptUser" ReadOnly="true" runat="server" FieldLabel="收货人"
                                                                                        Width="200" Height="22">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>                                                                              
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".34">
                                                                    <ext:Panel ID="Panel16" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout11" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:Label ID="Label4" runat="server" LabelSeparator="&nbsp;" Text="&nbsp;" Height="22" />
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestProcessUser" ReadOnly="true" runat="server" FieldLabel="使用人"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestApplyUser" ReadOnly="true" runat="server" FieldLabel="申请人"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestApplyCost" ReadOnly="true" runat="server" FieldLabel="费用分摊"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestApplyPurpose" ReadOnly="true" runat="server" FieldLabel="申请目的"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="tbCertificate" ReadOnly="true" runat="server" FieldLabel="注册证"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="tbIRF" ReadOnly="true" runat="server" FieldLabel="IRF#"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestReceiptPhone" ReadOnly="true" runat="server" FieldLabel="收货人联系方式"
                                                                                        Width="200" Height="22">
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
                                                    <ext:Panel ID="Panel17" runat="server" Header="false" Border="false">
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                                                <ext:LayoutColumn ColumnWidth=".66">
                                                                    <ext:Panel ID="Panel18" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout12" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestDealerName" ReadOnly="true" runat="server" FieldLabel="经销商"
                                                                                        Width="600" Height="22">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextArea ID="IptTestApplyMemo" ReadOnly="true" runat="server" FieldLabel="备注"
                                                                                        Width="600" Height="44">
                                                                                    </ext:TextArea>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".34">
                                                                    <ext:Panel ID="Panel22" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout15" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:TextArea ID="IptTestReceiptAddress" ReadOnly="true" runat="server" FieldLabel="收货地址"
                                                                                        Width="200" Height="44">
                                                                                    </ext:TextArea>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptTestCostCenter" ReadOnly="true" runat="server" FieldLabel="CostCenter"
                                                                                        Width="200" Hidden="true">
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
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:FieldSet>
                                </ext:LayoutRow>
                                
                                <ext:LayoutRow>
                                    <ext:FieldSet ID="DivSampleClin" runat="server" Header="true" Frame="false" BodyBorder="true"
                                        AutoHeight="true" AutoWidth="true" Title="临床样品申请单" Hidden="true">
                                        <Body>
                                            <ext:FormLayout runat="server" ID="FormLayout4">
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel8" runat="server" Header="false" Border="false">
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel10" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinSampleType" ReadOnly="true" runat="server" FieldLabel="样品类型"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinApplyStatus" ReadOnly="true" runat="server" FieldLabel="单据状态"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinApplyDate" ReadOnly="true" runat="server" FieldLabel="申请时间"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinApplyPurpose" ReadOnly="true" runat="server" FieldLabel="申请目的"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinCostCenter" ReadOnly="true" runat="server" FieldLabel="成本中心"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinReceiptUser" ReadOnly="true" runat="server" FieldLabel="收货人"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinReceiptAddress" ReadOnly="true" runat="server" FieldLabel="联系地址"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor> 
                                                                                <%--<ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessApplyDate" ReadOnly="true" runat="server" FieldLabel="申请日期"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptBusinessApplyDept" ReadOnly="true" runat="server" FieldLabel="部门"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>--%>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".33">
                                                                    <ext:Panel ID="Panel11" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:Label ID="Label5" runat="server" LabelSeparator="&nbsp;" Text="&nbsp;" Height="22" />
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinApplyNo" ReadOnly="true" runat="server" FieldLabel="申请单编号"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinHospName" ReadOnly="true" runat="server" FieldLabel="医院名称"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinHospAddress" ReadOnly="true" runat="server" FieldLabel="医院地址"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinReceiptPhone" ReadOnly="true" runat="server" FieldLabel="联系方式"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinApplyMemo" ReadOnly="true" runat="server" FieldLabel="备注"
                                                                                        Width="200" >
                                                                                    </ext:TextField>
                                                                                </ext:Anchor> 
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".34">
                                                                    <ext:Panel ID="Panel12" runat="server" Border="false" Header="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout13" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                <ext:Anchor>
                                                                                    <ext:Label ID="Label6" runat="server" LabelSeparator="&nbsp;" Text="&nbsp;" Height="22" />
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinApplyUser" ReadOnly="true" runat="server" FieldLabel="申请人"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinHospCode" ReadOnly="true" runat="server" FieldLabel="医院编号"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinRoom" ReadOnly="true" runat="server" FieldLabel="科室"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClinReceiptPhone2" ReadOnly="true" runat="server" FieldLabel="联系方式2"
                                                                                        Width="200">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="IptClin6MonthsExpProduct" ReadOnly="true" runat="server" FieldLabel="是否接受<6个月效期的产品"
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
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:FieldSet>
                                </ext:LayoutRow>
<%--                                <ext:LayoutRow>
                                    <ext:Panel ID="Panel58" runat="server" Border="false" Header="false" BodyStyle="padding-top:5px;padding-bottom:5px;">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout21" runat="server">
                                                <ext:LayoutColumn ColumnWidth="1">
                                                    <ext:GridPanel ID="RstSampleTesting" runat="server" Title="检测样品" StoreID="StoSampleTesting"
                                                        AutoScroll="false" StripeRows="true" Collapsible="false" Border="true" Header="true"
                                                        Icon="Lorry" AutoExpandColumn="Ra" Height="200" AutoWidth="true" Hidden="true">
                                                        <ColumnModel ID="ColumnModel5" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Division" DataIndex="Division" Header="业务部" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Priority" DataIndex="Priority" Header="优先级" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Certificate" DataIndex="Certificate" Header="注册证" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="CostCenter" DataIndex="CostCenter" Header="成本中心" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ArrivalDate" DataIndex="ArrivalDate" Header="期望到货日期" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Irf" DataIndex="Irf" Header="IRF#" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Ra" DataIndex="Ra" Header="RA项目" Width="150">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel5" SingleSelect="true" runat="server"
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
--%>                                <ext:LayoutRow>
                                    <ext:Panel ID="Panel57" runat="server" Border="false" Header="false" BodyStyle="padding-top:5px;padding-bottom:5px;">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout18" runat="server">
                                                <ext:LayoutColumn ColumnWidth="1">
                                                    <ext:GridPanel ID="RstUpn" runat="server" Title="UPN列表" StoreID="StoUpn" AutoScroll="false"
                                                        StripeRows="true" Collapsible="false" Border="true" Header="true" Icon="Lorry"
                                                        AutoExpandColumn="ProductMemo" Height="200" AutoWidth="true" Hidden="true">
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
                                                                <ext:Column ColumnID="Cost" DataIndex="Cost" Header="Cost" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductMemo" DataIndex="ProductMemo" Header="备注" Width="150">
                                                                </ext:Column>
                                                                <ext:CommandColumn Width="100" Header="DP确认采购数量" Align="Center" Hidden="true">
                                                                    <Commands>
                                                                        <ext:GridCommand ToolTip-Text="DP确认采购数量" CommandName="DpDelivery" Icon="BookNext">
                                                                        </ext:GridCommand>
                                                                    </Commands>
                                                                    <PrepareToolbar Fn="PrepareDpDelivery" />
                                                                </ext:CommandColumn>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                                                MoveEditorOnEnter="true">
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <Listeners>
                                                            <Command Handler="
                                                                if (command == 'DpDelivery') {                                                                    
                                                                    //alert(record.data.SampleUpnId);
                                                                    #{IptDpDeliveryUpn}.setValue('');
                                                                    #{IptDpDeliveryRemainQuantity}.setValue('');
                                                                    #{IptDpDeliveryProductName}.setValue('');
                                                                    #{IptDpDeliveryProductDesc}.setValue('');
                                                                    #{IptDpDeliveryQuantity}.setValue('');
                                                                    #{IptDpDeliveryLot}.setValue('');
                                                                    #{IptDpDeliveryMemo}.setValue('');
                                                                    #{IptDpDelvieryConvertFactor}.setValue('');
                                                                    #{StoRemain}.reload();
                                                                    //#{WdwDpDelivery}.show();
                                                                    Coolite.AjaxMethods.ShowDpDelivery(record.data.SampleUpnId);
                                                                }
                                                            " />
                                                        </Listeners>
                                                        <SaveMask ShowMask="false" />
                                                        <LoadMask ShowMask="true" />
                                                    </ext:GridPanel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutRow>
                                <ext:LayoutRow>
                                    <ext:Panel ID="Panel23" runat="server" Border="false" Header="false" BodyStyle="padding-top:5px;padding-bottom:5px;">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                                <ext:LayoutColumn ColumnWidth="1">
                                                    <ext:GridPanel ID="RstDelivery" runat="server" Title="发货数据" StoreID="StoDelivery"
                                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="true" Icon="Lorry"
                                                        AutoExpandColumn="ProductMemo" Height="200" AutoWidth="true" Hidden="true">
                                                        <TopBar>
                                                            <ext:Toolbar ID="Toolbar2" runat="server">
                                                                <Items>
                                                                    <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                                    <ext:Button ID="BtnAddDelivery" runat="server" Text="DP发货" Icon="Add" Hidden="true">
                                                                        <Listeners>
                                                                            <Click Handler="
                                                                                #{IptDpDeliveryUpn}.setValue('');
                                                                                #{IptDpDeliveryRemainQuantity}.setValue('');
                                                                                #{IptDpDeliveryProductName}.setValue('');
                                                                                #{IptDpDeliveryProductDesc}.setValue('');
                                                                                #{IptDpDeliveryQuantity}.setValue('');
                                                                                #{IptDpDeliveryLot}.setValue('');
                                                                                #{IptDpDeliveryMemo}.setValue('');
                                                                                #{StoRemain}.reload();
                                                                                #{WdwDpDelivery}.show();
                                                                            " />
                                                                        </Listeners>
                                                                    </ext:Button>
                                                                </Items>
                                                            </ext:Toolbar>
                                                        </TopBar>
                                                        <ColumnModel ID="ColumnModel1" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="UpnNo" DataIndex="UpnNo" Header="UPN编号" Width="100">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductName" DataIndex="ProductName" Header="产品名称" Width="200">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductDesc" DataIndex="ProductDesc" Header="描述" Width="200">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="DeliveryQuantity" DataIndex="DeliveryQuantity" Header="发货数量"
                                                                    Width="100">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Lot" DataIndex="Lot" Header="批号" Width="100">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductMemo" DataIndex="ProductMemo" Header="备注" Width="200">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="DeliveryStatus" DataIndex="DeliveryStatus" Header="状态" Width="100">
                                                                </ext:Column>
                                                                <ext:CommandColumn Width="100" Header="IE确认清关数量" Align="Center" Hidden="true">
                                                                    <Commands>
                                                                        <ext:GridCommand ToolTip-Text="IE确认清关数量" CommandName="IeDelivery" Icon="BookNext">
                                                                        </ext:GridCommand>
                                                                    </Commands>
                                                                    <PrepareToolbar Fn="PrepareIeDelivery" />
                                                                </ext:CommandColumn>
                                                                <ext:CommandColumn Width="100" Header="RA确认" Align="Center" Hidden="true">
                                                                    <Commands>
                                                                        <ext:GridCommand ToolTip-Text="RA确认" CommandName="CsDelivery" Icon="BookNext">
                                                                        </ext:GridCommand>
                                                                    </Commands>
                                                                    <PrepareToolbar Fn="PrepareCsDelivery" />
                                                                </ext:CommandColumn>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server"
                                                                MoveEditorOnEnter="true">
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <Listeners>
                                                            <Command Handler="
                                                                if (command == 'IeDelivery') {
                                                                    SaveIeDelivery(record.data.DeliveryId);
                                                                } else if (command == 'CsDelivery') {
                                                                    SaveCsDelivery(record.data.DeliveryId);
                                                                }
                                                            " />
                                                        </Listeners>
                                                        <SaveMask ShowMask="false" />
                                                        <LoadMask ShowMask="true" />
                                                    </ext:GridPanel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutRow>
                                <ext:LayoutRow>
                                    <ext:Panel ID="Panel60" runat="server" Border="false" Header="false" BodyStyle="padding-top:5px;padding-bottom:5px;">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout19" runat="server">
                                                <ext:LayoutColumn ColumnWidth="1">
                                                    <ext:GridPanel ID="RstSampleTrace" runat="server" Title="样品追踪" StoreID="StoSampleTrace"
                                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="true" Header="true"
                                                        Icon="Lorry" Height="200" AutoWidth="true" Hidden="true">
                                                        <ColumnModel ID="ColumnModel3" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="UpnNo" DataIndex="UpnNo" Header="UPN编号" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Lot" DataIndex="Lot" Header="批次" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="DeliveryQuantity" DataIndex="DeliveryQuantity" Header="已发货数量"
                                                                    Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ReciveQuantity" DataIndex="ReciveQuantity" Header="确认收货数量"
                                                                    Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="EvalQuantity" DataIndex="EvalQuantity" Header="上传评估单数量" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ReturnQuantity" DataIndex="ReturnQuantity" Header="退货数量" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="RemainQuantity" DataIndex="RemainQuantity" Header="剩余数量" Width="150">
                                                                </ext:Column>
                                                                <ext:CommandColumn Width="50" Header="样品评估单" Align="Center">
                                                                    <Commands>
                                                                        <ext:GridCommand Icon="DiskDownload" CommandName="Show">
                                                                            <ToolTip Text="样品评估单" />
                                                                        </ext:GridCommand>
                                                                    </Commands>
                                                                </ext:CommandColumn>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                                MoveEditorOnEnter="true">
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <SaveMask ShowMask="false" />
                                                        <LoadMask ShowMask="true" />
                                                        <Listeners>
                                                            <Command Handler="   if (command == 'Show') {
                                                                    var headerId = #{IptSampleHeadId}.getValue();
                                                                    Coolite.AjaxMethods.ShowSampleEval(
                                                                        headerId,
                                                                        record.data.UpnNo,
                                                                        record.data.Lot,
                                                                        {
                                                                            
                                                                            failure: function(err) {Ext.Msg.alert('Error', err);}
                                                                        }
                                                                    );
                                                                }" />
                                                        </Listeners>
                                                    </ext:GridPanel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutRow>
                                <ext:LayoutRow>
                                    <ext:Panel ID="Panel56" runat="server" Border="false" Header="false" BodyStyle="padding-top:5px;padding-bottom:5px;">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout20" runat="server">
                                                <ext:LayoutColumn ColumnWidth="1">
                                                    <ext:GridPanel ID="RstOperLog" runat="server" Title="操作记录" StoreID="StoOperLog" AutoScroll="true"
                                                        StripeRows="true" Collapsible="false" Border="true" Icon="Lorry" AutoExpandColumn="OperNote"
                                                        Height="200" AutoWidth="true" Hidden="true">
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
                            <ext:Button ID="BtnClose" runat="server" Text="关闭" Icon="Cancel">
                                <Listeners>
                                    <Click Handler="top.ExampleTabs.closeTab(top.ExampleTabs.getActiveTab(), 'close');" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="BtnApprove" runat="server" Text="审批通过" Icon="LorryAdd">
                                <Listeners>
                                    <Click Handler="DoAgree();" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Window ID="WdwDpDelivery" runat="server" Icon="Group" Title="DP确认采购数量" Resizable="false"
        Header="false" Width="390" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
        BodyStyle="padding:5px;">
        <Body>
            <ext:FormLayout ID="FormLayout16" runat="server">
                <ext:Anchor>
                    <ext:FormPanel ID="FrmDpDelivery" runat="server" BodyBorder="false" Header="false"
                        BodyStyle="padding:5px;">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                <ext:LayoutColumn ColumnWidth=".5">
                                    <ext:Panel ID="Panel24" runat="server" Border="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout17" runat="server" LabelWidth="100">
                                                <ext:Anchor>
                                                    <ext:TextField ID="IptDpDeliveryUpn" runat="server" FieldLabel="UPN编号" Width="220" ReadOnly="true">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:NumberField ID="IptDpDeliveryRemainQuantity" runat="server" FieldLabel="剩余数量"
                                                        AllowBlank="false" Width="220" AllowDecimals="true" AllowNegative="false">
                                                    </ext:NumberField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="IptDpDeliveryProductName" runat="server" FieldLabel="产品名称" AllowBlank="true"
                                                        Width="220" ReadOnly="true">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="IptDpDeliveryProductDesc" runat="server" FieldLabel="描述" AllowBlank="true"
                                                        Width="220" ReadOnly="true">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:NumberField ID="IptDpDeliveryQuantity" runat="server" FieldLabel="发货数量" AllowBlank="false"
                                                        Width="220" AllowDecimals="true" AllowNegative="false">
                                                    </ext:NumberField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="IptDpDeliveryLot" runat="server" FieldLabel="批号" AllowBlank="false"
                                                        Width="220">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="IptDpDeliveryMemo" runat="server" FieldLabel="备注" Width="220">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="IptDpDelvieryConvertFactor" runat="server" FieldLabel="转换率" Width="220" Hidden="true">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:FormPanel>
                </ext:Anchor>
            </ext:FormLayout>
        </Body>
        <Buttons>
            <ext:Button ID="BtnSaveDpDelivery" runat="server" Text="提交" Icon="Tick">
                <Listeners>
                    <Click Handler="SaveDpDelivery();" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="BtnCancelDpDelivery" runat="server" Text="返回" Icon="Delete">
                <Listeners>
                    <Click Handler="#{WdwDpDelivery}.hide();" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
    <ext:Window ID="WdwSampleEval" runat="server" Icon="Group" Title="样品评估单" Resizable="false"
        Header="false" Width="600" Height="400" ShowOnLoad="false" BodyStyle="padding:5px;" Cls="images-view">
        <Body>
                    <ext:FitLayout ID="FitLayout1" runat="server">
                        <ext:DataView ID="DataView1" runat="server" StoreID="StoEval" AutoHeight="true" MultiSelect="true"
                            OverClass="x-view-over" ItemSelector="div.thumb-wrap" EmptyText="No images to display">
                            <Template ID="Template1" runat="server">
                            <tpl for=".">
			                      <a href="{EvalUrl}" title="{EvalName}" target="_blank" >
                                <img alt="{EvalName}" src="{EvalUrl}" class="thumb-wrap"/></a>
                            </tpl>
                            <div class="x-clear"></div>  
                            </Template>
                        </ext:DataView>
                    </ext:FitLayout>
        </Body>
        <Buttons>
            <ext:Button ID="Button2" runat="server" Text="返回" Icon="Delete">
                <Listeners>
                    <Click Handler="#{WdwSampleEval}.hide();" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
