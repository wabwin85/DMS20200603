<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PromotionMaintain.aspx.cs" Inherits="DMS.Website.Pages.Promotion.PromotionMaintain" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html>
<%@ Register Src="../../Controls/PromotionPolicyFactorSearch.ascx" TagName="PromotionPolicyFactorSearch"
    TagPrefix="uc" %>
<%@ Register Src="../../Controls/PromotionPolicyFactorRuleSearch.ascx" TagName="PromotionPolicyFactorRuleSearch"
    TagPrefix="uc" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <ext:ScriptManager ID="ScriptManager1" runat="server" />
            <script type="text/javascript" language="javascript">
                function RefreshGridWindow3() {
                    Ext.getCmp('<%=this.GridWd3FactorRuleCondition.ClientID%>').reload();
                    Ext.getCmp('<%=this.GridWd3FactorRuleConditionSeleted.ClientID%>').reload();
                    Ext.getCmp('<%=this.GridWd2FactorRule.ClientID%>').reload();

                }

                function RefreshDetailWindow4() {

                    Ext.getCmp('<%=this.cbWd4PolicyFactorX.ClientID%>').store.reload();
                }

                var factorDescriptionWd4 = function () {
                    var cbWd4PolicyFactorX = Ext.getCmp('<%=this.cbWd4PolicyFactorX.ClientID%>');
                    var txtWd4FactorRemarkX = Ext.getCmp('<%=this.txtWd4FactorRemarkX.ClientID%>');
                    for (var i = 0 ; i < cbWd4PolicyFactorX.store.getTotalCount() ; i++) {
                        if (cbWd4PolicyFactorX.store.getAt(i).get('PolicyFactorId') == cbWd4PolicyFactorX.getValue()) {
                            txtWd4FactorRemarkX.setValue(cbWd4PolicyFactorX.store.getAt(i).get('FactDesc'));
                        }
                    }
                }

                var show = function () {
                    var type = Ext.getCmp('<%=this.type.ClientID%>');
                    if (type.getValue() == "状态调整") {
                        Coolite.AjaxMethods.GetPromotionPolicy({
                            success: function (result) {
                                if (result == '') {
                                    Ext.getCmp('<%=this.PolicyTypeNow.ClientID%>').show();
                                    Ext.getCmp('<%=this.PolicyTypeChange.ClientID%>').show();
                                }
                                else {
                                    Ext.getCmp('<%=this.PolicyTypeNow.ClientID%>').setValue("");
                                    Ext.getCmp('<%=this.PolicyTypeChange.ClientID%>').setValue("");
                                    Ext.getCmp('<%=this.PolicyTypeNow.ClientID%>').hide();
                                    Ext.getCmp('<%=this.PolicyTypeChange.ClientID%>').hide();
                                    Ext.Msg.alert('Error', '请输入正确政策编号!');
                                }
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }
                        });
                    }
                }

                function PromotionAdjustment() {
                    var id = Ext.getCmp('PromotionID').getValue();
                    var type = Ext.getCmp('type').getValue();
                    if (id == "") {
                        Ext.Msg.alert('提示', '请输入促销编号');
                        return;
                    }
                    else if (type == "") {
                        Ext.Msg.alert('提示', '请选择促销调整类型');
                        return;
                    }
                    else if (type == "状态调整" && Ext.getCmp('PolicyTypeChange').getValue() == "") {
                        Ext.Msg.alert('提示', '请选择调整状态');
                        return;
                    }
                    else {
                        var id = Ext.getCmp('PromotionID').getValue();
                        Ext.Msg.confirm('Message', '确定修改吗?', function (e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.Verification(id, type, {
                                    success: function (result) {
                                        if (result == "N") {
                                            Ext.Msg.confirm('提示', '此操作需上传附件，请确认是否上传？', function (e) {
                                                if (e == 'yes') {
                                                    Ext.getCmp('<%=this.wdAttachment.ClientID%>').show();
                                                    }
                                                });
                                            }
                                            else {
                                                Coolite.AjaxMethods.show(id);
                                            }
                                        },
                                        failure: function (err) {
                                            Ext.Msg.alert('Error', err);
                                        }
                                    });
                                }
                            });

                        }

            }


            function GetOrderSataus() {
                var txtOrderNo = Ext.getCmp('<%=this.txtReceiptNo.ClientID%>');
            if (txtOrderNo.getValue() == '') {
                Ext.Msg.alert('Message', '请输入发货单号');
                return false;
            }
            else {
                Coolite.AjaxMethods.GetPoReceiptHeader({
                    success: function () { },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                    }
                });
            }
        }




        function GetPoReceiptHeadersap() {
            var txtOrderNo = Ext.getCmp('<%=this.txtReceiptNo2.ClientID%>');
            if (txtOrderNo.getValue() == '') {
                Ext.Msg.alert('Message', '请输入发货单号');
                return false;
            }
            else {
                Coolite.AjaxMethods.GetPoReceiptHeadersap({
                    success: function () { },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                    }
                }
                );
            }
        }

        function UpdateOrderSatatus() {
            var txtOrderNo = Ext.getCmp('<%=this.txtReceiptNo.ClientID%>').getValue();
            if (txtOrderNo == '') {
                Ext.Msg.alert('Message', '请输入订单号');
                return false;
            } else {
                Ext.Msg.confirm('Message', '确定删除吗?', function (e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.Verification(txtOrderNo, '', {
                            success: function (result) {
                                if (result == "N") {
                                    Ext.Msg.confirm('提示', '此操作需上传附件，请确认是否上传？', function (e) {
                                        if (e == 'yes') {
                                            Ext.getCmp('<%=this.wdAttachment.ClientID%>').show();
                                        }
                                    });
                                }
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }
                        });
                    }
                });
            }
        }


        function UpdatePoReceipHeaderSAPNoQR() {
            var txtOrderNo2 = Ext.getCmp('<%=this.txtReceiptNo2.ClientID%>');
             if (txtOrderNo2.getValue() == '') {
                 Ext.Msg.alert('Message', '请输入收货号');
                 return false;
             }
             else {
                 Ext.Msg.confirm('Message', '确定修改吗?', function (e) {
                     if (e == 'yes') {
                         Coolite.AjaxMethods.UpdatePoReceipHeaderSAPNoQR({
                             success: function () { txtOrderNo2.setValue(''); },
                             failure: function (err) {
                                 Ext.Msg.alert('Error', err);
                             }
                         });
                     }
                 })
             }
         }
            </script>
            <ext:Store ID="FactorConditionStore" runat="server" OnRefreshData="FactorConditionStore_RefreshData"
                AutoLoad="false" UseIdConfirmation="true">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="ConditionId">
                        <Fields>
                            <ext:RecordField Name="ConditionId" />
                            <ext:RecordField Name="ConditionName" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="FactorConditionTypeStore" runat="server" UseIdConfirmation="true"
                OnRefreshData="FactorConditionTypeStore_RefreshData" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="ConditionType">
                        <Fields>
                            <ext:RecordField Name="ConditionType" />
                            <ext:RecordField Name="ConditionType" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="Wd3RuleStore" runat="server" OnRefreshData="Wd3RuleStore_RefreshData"
                AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="Id">
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="Name" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="Wd3RuleSeletedStore" runat="server" OnRefreshData="Wd3RuleSeletedStore_RefreshData"
                AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="Id">
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="Name" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="Wd3FactorRelationStore" runat="server" OnRefreshData="Wd3FactorRelationStore_RefreshData"
                AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="PolicyFactorId">
                        <Fields>
                            <ext:RecordField Name="PolicyFactorId" />
                            <ext:RecordField Name="FactId" />
                            <ext:RecordField Name="FactName" />
                            <ext:RecordField Name="FactDesc" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>

            <ext:Store ID="FolicyFactorStore" runat="server" OnRefreshData="FolicyFactorStore_RefreshData"
                AutoLoad="true">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="PolicyFactorId">
                        <Fields>
                            <ext:RecordField Name="PolicyFactorId" />
                            <ext:RecordField Name="PolicyId" />
                            <ext:RecordField Name="FactId" />
                            <ext:RecordField Name="FactName" />
                            <ext:RecordField Name="FactDesc" />
                            <ext:RecordField Name="IsGift" />
                            <ext:RecordField Name="IsPoint" />
                            <ext:RecordField Name="IsGiftName" />
                            <ext:RecordField Name="PolicyStyle" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>

            <ext:Store ID="PolicyFactorRuleStore" runat="server" AutoLoad="false" OnRefreshData="PolicyFactorRuleStore_RefreshData">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="PolicyFactorConditionId">
                        <Fields>
                            <ext:RecordField Name="PolicyFactorConditionId" />
                            <ext:RecordField Name="ConditionName" />
                            <ext:RecordField Name="PolicyFactorId" />
                            <ext:RecordField Name="ConditionId" />
                            <ext:RecordField Name="OperTag" />
                            <ext:RecordField Name="ConditionValue" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="PolicyDealerCanStore" runat="server" OnRefreshData="PolicyDealerCanStore_RefreshData"
                AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="DmaId">
                        <Fields>
                            <ext:RecordField Name="DmaId" />
                            <ext:RecordField Name="DealerName" />
                            <ext:RecordField Name="DealerFullName" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="PolicyDealerSeletedStore" runat="server" OnRefreshData="PolicyDealerSeletedStore_RefreshData"
                AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="DEALERID">
                        <Fields>
                            <ext:RecordField Name="DEALERID" />
                            <ext:RecordField Name="DealerName" />
                            <ext:RecordField Name="OperType" />
                            <ext:RecordField Name="WithType" />
                            <ext:RecordField Name="PolicyId" />
                            <ext:RecordField Name="Remark1" />
                            <ext:RecordField Name="DealerFullName" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="FactorRuleStore" runat="server" OnRefreshData="FactorRuleStore_RefreshData"
                AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="PolicyStyle" />
                            <ext:RecordField Name="RuleId" />
                            <ext:RecordField Name="PolicyId" />
                            <ext:RecordField Name="RuleDesc" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="PolicyFactorXStore" runat="server" OnRefreshData="PolicyFactorXStore_RefreshData"
                AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="PolicyFactorId">
                        <Fields>
                            <ext:RecordField Name="PolicyFactorId" />
                            <ext:RecordField Name="FactName" />
                            <ext:RecordField Name="FactDesc" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <Listeners>
                    <Load Handler="#{cbWd4PolicyFactorX}.setValue(#{hidWd4PolicyFactorX}.getValue());" />
                </Listeners>
            </ext:Store>
            <ext:Store ID="AttachmentStore" runat="server" OnRefreshData="AttachmentStore_RefreshData"
                AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="Id">
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="Attachment" />
                            <ext:RecordField Name="Name" />
                            <ext:RecordField Name="Url" />
                            <ext:RecordField Name="Type" />
                            <ext:RecordField Name="UploadUser" />
                            <ext:RecordField Name="Identity_Name" />
                            <ext:RecordField Name="UploadDate" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Hidden runat="server" ID="hidurl"></ext:Hidden>
            <ext:Hidden runat="server" ID="Hidattmentid"></ext:Hidden>
            <ext:Hidden runat="server" ID="HidFactorId"></ext:Hidden>
            <ext:Hidden runat="server" ID="HidFactConditionId"></ext:Hidden>
            <ext:Hidden runat="server" ID="HidPolicyStyle"></ext:Hidden>
            <ext:Hidden runat="server" ID="PolicyFactorId"></ext:Hidden>
            <ext:Hidden runat="server" ID="hiddenMainId"></ext:Hidden>
            <ext:Hidden runat="server" ID="hiddenCountAttachment"></ext:Hidden>
            <ext:Hidden runat="server" ID="BatchNbr"></ext:Hidden>
            <ext:Hidden runat="server" ID="hidFactId"></ext:Hidden>
            <ext:Hidden runat="server" ID="hidWd4PolicyRuleId"></ext:Hidden>
            <ext:Hidden runat="server" ID="hidWd4PolicyFactorX"></ext:Hidden>
            <ext:Hidden runat="server" ID="hidid"></ext:Hidden>
            <ext:Hidden runat="server" ID="Productline"></ext:Hidden>
            <ext:Hidden runat="server" ID="pagetype"></ext:Hidden>
            <ext:Hidden runat="server" ID="state"></ext:Hidden>


            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <Center MarginsSummary="0 5 5 5">
                            <ext:Panel ID="Panel2" runat="server" Height="300" Header="false" Border="false" Frame="true" AutoScroll="true">
                                <Body>
                                    <ext:RowLayout runat="server">
                                        <ext:LayoutRow>
                                            <ext:FieldSet ID="DivSampleBusiness" runat="server" Header="true" Frame="false" BodyBorder="true"
                                                AutoHeight="true" AutoWidth="true" Title="促销政策维护">
                                                <Body>
                                                    <ext:FormLayout runat="server" ID="a">
                                                        <ext:Anchor>
                                                            <ext:Panel ID="Panel3" runat="server" Header="false" Border="false">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth=".25">
                                                                            <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="PromotionID" runat="server" FieldLabel="政策编号" Width="170" EmptyText="请输入政策编号">
                                                                                                <Listeners>
                                                                                                    <Blur Fn="show"/>
                                                                                                </Listeners>
                                                                                            </ext:TextField>
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".25">
                                                                            <ext:Panel ID="Panel1" runat="server" Border="false" Header="false">
                                                                                <Body>

                                                                                    <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                        <ext:Anchor>
                                                                                            <ext:ComboBox ID="type" runat="server" FieldLabel="调整类型" BlankText="选择调整类型" Editable="false" Mode="Local" TypeAhead="true" Resizable="true">
                                                                                                <Items>
                                                                                                    <%--   <ext:ListItem Text="经销商范围调整" Value="经销商范围调整" />
                                                                                                    <ext:ListItem Text="产品调整" Value="产品调整" />
                                                                                                    <ext:ListItem Text="医院调整" Value="医院调整" />
                                                                                                    <ext:ListItem Text="规则调整" Value="规则调整" />--%>
                                                                                                    <ext:ListItem Text="状态调整" Value="状态调整" />
                                                                                                </Items>
                                                                                                <Triggers>
                                                                                                    <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                                                                </Triggers>
                                                                                                <Listeners>
                                                                                                    <TriggerClick Handler="this.clearValue(); #{PolicyTypeNow}.hide();#{PolicyTypeChange}.hide();" />
                                                                                                    <Select Fn="show" />
                                                                                                </Listeners>
                                                                                            </ext:ComboBox>
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>

                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".25">
                                                                            <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="130">
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="PolicyTypeNow" runat="server" FieldLabel="当前政策政策状态" Width="150" Hidden="true">
                                                                                            </ext:TextField>
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".25">
                                                                            <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                                                <Body>

                                                                                    <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                        <ext:Anchor>
                                                                                            <ext:ComboBox ID="PolicyTypeChange" runat="server" FieldLabel="政策状态调整" BlankText="选择调整状态" Editable="false" Mode="Local" TypeAhead="true" Resizable="true" Hidden="true" Width="150">
                                                                                                <Items>
                                                                                                    <ext:ListItem Text="草稿" Value="草稿" />
                                                                                                    <ext:ListItem Text="审批中" Value="审批中" />
                                                                                                    <ext:ListItem Text="无效" Value="无效" />
                                                                                                    <ext:ListItem Text="有效" Value="有效" />
                                                                                                    <ext:ListItem Text="审批拒绝" Value="审批拒绝" />
                                                                                                </Items>
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
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                                <Buttons>
                                                    <ext:Button ID="Btnadjustment" runat="server" Text="调整">
                                                        <Listeners>
                                                            <Click Handler="PromotionAdjustment()" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Buttons>
                                            </ext:FieldSet>
                                        </ext:LayoutRow>
                                        <ext:LayoutRow>
                                            <ext:FieldSet ID="FieldSet1" runat="server" Header="true" Frame="false" BodyBorder="true"
                                                AutoHeight="true" AutoWidth="true" Title="收货单数据删除" Collapsible="true">
                                                <Body>
                                                    <ext:FormLayout runat="server" ID="FormLayout7">
                                                        <ext:Anchor>
                                                            <ext:Panel ID="Panel11" runat="server" Header="false" Border="false">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth=".33">
                                                                            <ext:Panel ID="Panel12" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="txtReceiptNo" runat="server" FieldLabel="收货单编号" Width="200" EmptyText="输入收货单编号进行查询">
                                                                                            </ext:TextField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:Label ID="Label1" FieldLabel="提示" runat="server">
                                                                                            </ext:Label>
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
                                                <Buttons>
                                                    <ext:Button ID="BtnOrderQuery" runat="server" Text="查询">
                                                        <Listeners>
                                                            <Click Handler="GetOrderSataus();" />
                                                        </Listeners>
                                                    </ext:Button>
                                                    <ext:Button ID="BtnOrderUpdate" runat="server" Text="删除" Disabled="true">
                                                        <Listeners>
                                                            <Click Handler="UpdateOrderSatatus();" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Buttons>
                                            </ext:FieldSet>
                                        </ext:LayoutRow>
                                        <ext:LayoutRow>
                                            <ext:FieldSet ID="FieldSet2" runat="server" Header="true" Frame="false" BodyBorder="true"
                                                AutoHeight="true" AutoWidth="true" Title="发货单接口状态修改（重置ERP发货接口状态）" Collapsible="true">
                                                <Body>
                                                    <ext:FormLayout runat="server" ID="FormLayout9">
                                                        <ext:Anchor>
                                                            <ext:Panel ID="Panel13" runat="server" Header="false" Border="false">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth=".33">
                                                                            <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="txtReceiptNo2" runat="server" FieldLabel="发货单号" Width="200" EmptyText="输入发货单号进行查询">
                                                                                            </ext:TextField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:Label ID="message" FieldLabel="提示" runat="server">
                                                                                            </ext:Label>
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
                                                <Buttons>
                                                    <ext:Button ID="BtnProQuery2" runat="server" Text="查询">
                                                        <Listeners>
                                                            <Click Handler="GetPoReceiptHeadersap();" />
                                                        </Listeners>
                                                    </ext:Button>
                                                    <ext:Button ID="BtnOrderUpdate2" Disabled="true" runat="server" Text="重置接口状态">
                                                        <Listeners>
                                                            <Click Handler="UpdatePoReceipHeaderSAPNoQR();" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Buttons>
                                            </ext:FieldSet>
                                        </ext:LayoutRow>
                                        <ext:LayoutRow>
                                            <ext:FieldSet ID="FieldSet3" runat="server" Header="true" Frame="false" BodyBorder="true"
                                                AutoHeight="true" AutoWidth="true" Title="上传证明文件" Collapsible="true">
                                                <Body>
                                                    <ext:Panel ID="Panel15" runat="server" Header="false" Border="false" Height="300" Frame="true">
                                                        <Body>
                                                            <ext:GridPanel ID="GpWdAttachment" runat="server" StoreID="AttachmentStore" Borde="false" Header="false"
                                                                Icon="Lorry" Height="290">
                                                                <ColumnModel ID="ColumnModel5" runat="server">
                                                                    <Columns>
                                                                        <ext:Column ColumnID="Name" DataIndex="Name" Width="200" Header="附件名称">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Width="90" Header="上传人">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Width="90" Header="上传时间">
                                                                        </ext:Column>
                                                                        <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                                            <Commands>
                                                                                <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                                    <ToolTip Text="下载" />
                                                                                </ext:GridCommand>
                                                                            </Commands>
                                                                        </ext:CommandColumn>
                                                                        <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                                            <Commands>
                                                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                                                    <ToolTip Text="删除" />
                                                                                </ext:GridCommand>
                                                                            </Commands>
                                                                        </ext:CommandColumn>
                                                                    </Columns>
                                                                </ColumnModel>
                                                                <SelectionModel>
                                                                    <ext:RowSelectionModel ID="RowSelectionModel5" SingleSelect="true" runat="server">
                                                                    </ext:RowSelectionModel>
                                                                </SelectionModel>
                                                                <Listeners>
                                                                    <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            #{GpWdAttachment}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });
                                                                         }if (command == 'DownLoad'){
                                                                                    var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=dcms';
                                                                                    open(url, 'Download');
                                                                                  }  " />
                                                                </Listeners>
                                                                <BottomBar>
                                                                    <ext:PagingToolbar ID="PagingToolBarAttachment" runat="server" PageSize="15" StoreID="AttachmentStore"
                                                                        DisplayInfo="true" />
                                                                </BottomBar>
                                                                <SaveMask ShowMask="true" />
                                                                <LoadMask ShowMask="true" />
                                                            </ext:GridPanel>
                                                        </Body>
                                                    </ext:Panel>
                                                </Body>
                                            </ext:FieldSet>
                                        </ext:LayoutRow>
                                    </ext:RowLayout>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:ViewPort>
            <ext:Window ID="wdAttachment" runat="server" Icon="Group" Title="上传附件" Resizable="false"
                Header="false" Width="500" Height="150" AutoShow="false" Modal="true" ShowOnLoad="false"
                BodyStyle="padding:5px;">
                <Body>
                    <ext:FormPanel ID="AttachmentForm" runat="server" Width="500" Frame="true" Header="false"
                        AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                        <Defaults>
                            <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                            <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                            <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                        </Defaults>
                        <Body>
                            <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="80">
                                <ext:Anchor>
                                    <ext:FileUploadField ID="ufUploadAttachment" runat="server" EmptyText="选择上传附件" FieldLabel="文件"
                                        ButtonText="" Icon="ImageAdd">
                                    </ext:FileUploadField>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                        <Listeners>
                            <ClientValidation Handler="#{btnWinAttachmentSubmit}.setDisabled(!valid);" />
                        </Listeners>
                        <Buttons>
                            <ext:Button ID="btnWinAttachmentSubmit" runat="server" Text="上传附件">
                                <AjaxEvents>
                                    <Click OnEvent="UploadAttachmentClick" Before="if(!#{AttachmentForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');"
                                        Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });"
                                        Success="
                                         #{ufUploadAttachment}.setValue(''); #{wdAttachment}.hide()
                                          #{GpWdAttachment}.reload();   
                                        Ext.Msg.confirm('Message', '上传成功是否继续？', function (e) {
                         if (e == 'yes') {
                         if(#{PromotionID}.getValue()!='')              
                          {
                           Coolite.AjaxMethods.show(#{PromotionID}.getValue(), {
                           success: function () {
                           }});
                          }
					      if(#{txtReceiptNo}.getValue()!='')
                          { 
                               Coolite.AjaxMethods.UpdateOrderSatatus({   
                               success: function (){#{txtReceiptNo}.setValue();},
                               failure: function (err) {
                               Ext.Msg.alert('Error', err);}});
                           }
                         }
                              else{
                            Coolite.AjaxMethods.DeleteAttachment(#{Hidattmentid}.getValue(),#{hidurl}.getValue(),{
                                                                                        success: function() {
                                                                                            #{GpWdAttachment}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                    }})">
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                            <ext:Button ID="Button2" runat="server" Text="清除">
                                <Listeners>
                                    <Click Handler="#{AttachmentForm}.getForm().reset();#{btnWinAttachmentSubmit}.setDisabled(true);" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:FormPanel>
                </Body>
                <Listeners>
                    <BeforeShow Handler="#{ufUploadAttachment}.setValue('');" />
                </Listeners>
            </ext:Window>
            <ext:Window ID="wd7PolicyDealer" runat="server" Icon="Group" Title="政策适用对象" Resizable="false"
                Header="false" Width="600" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
                BodyStyle="padding:5px;">
                <Body>
                    <ext:FormLayout ID="FormLayout20" runat="server">
                        <ext:Anchor>
                            <ext:Panel ID="PanelWd3PolicyFactor" runat="server" Border="true" Title="查询条件" BodyStyle="padding:5px;">
                                <Body>
                                    <ext:FormLayout ID="FormLayout21" runat="server" LabelWidth="100">
                                        <ext:Anchor>
                                            <ext:TextField ID="txtWd7DealerName" runat="server" FieldLabel="经销商名称" Width="200">
                                            </ext:TextField>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                                <Buttons>
                                    <ext:Button ID="btnWd7PolicyDealerQuery" runat="server" Text="查询" Icon="ArrowRefresh">
                                        <Listeners>
                                            <Click Handler="#{PagingToolBarPolicyDealersCan}.changePage(1);" />
                                        </Listeners>
                                    </ext:Button>

                                </Buttons>
                            </ext:Panel>
                        </ext:Anchor>
                        <ext:Anchor>
                            <ext:Panel ID="PanelWd3AddFactorCondition" runat="server" BodyBorder="false" Header="false"
                                FormGroup="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout3" runat="server">
                                        <ext:GridPanel ID="GridWd7PolicyDealer" runat="server" StoreID="PolicyDealerCanStore"
                                            Border="false" Title="<font color='red'>可选经销商</font>" Icon="Lorry" StripeRows="true"
                                            Height="180" AutoScroll="true">
                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="DmaId" DataIndex="DmaId" Align="Left" Header="经销商ID" Hidden="true">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DealerFullName" DataIndex="DealerFullName" Align="Left" Header="经销商名称"
                                                        Width="300">
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="80" Header="选择" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="Add" CommandName="Add" Text="包含">
                                                                <ToolTip Text="添加" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                    <ext:CommandColumn Width="80" Header="排除" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="Delete" CommandName="Delete" Text="不包含">
                                                                <ToolTip Text="不包含" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="if (command == 'Add'){
                                        Coolite.AjaxMethods.DelaerAdd(record.data.DmaId,record.data.DealerFullName,{ success: function() { #{GridWd3PolicyDealerSeleted}.reload();#{GridWd7PolicyDealer}.reload();Ext.Msg.alert('提示','修改成功！');},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                    } 
                                    if (command == 'Delete'){
                                        Coolite.AjaxMethods.DelaerExclusive(record.data.DmaId,record.data.DealerFullName,{ success: function() { #{GridWd3PolicyDealerSeleted}.reload();#{GridWd7PolicyDealer}.reload();Ext.Msg.alert('提示','修改成功！');},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                    } 
                                    " />
                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBarPolicyDealersCan" runat="server" PageSize="10"
                                                    StoreID="PolicyDealerCanStore" DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Panel>
                        </ext:Anchor>
                        <ext:Anchor>
                            <ext:Panel ID="PanelWd3PolicyDealerSelected" runat="server" BodyBorder="false" Header="false"
                                FormGroup="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                        <ext:GridPanel ID="GridWd3PolicyDealerSeleted" runat="server" StoreID="PolicyDealerSeletedStore"
                                            Border="false" Title="<font color='red'>已选经销商</font>" Icon="Lorry" StripeRows="true"
                                            Height="200" AutoScroll="true">
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="DEALERID" DataIndex="DEALERID" Align="Left" Header="经销商ID"
                                                        Hidden="true">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DealerFullName" DataIndex="DealerFullName" Align="Left" Header="经销商名称"
                                                        Width="300">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperType" DataIndex="OperType" Align="Left" Header="类型" Width="120">
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="80" Header="删除" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="Decline" CommandName="Delete" Text="删除">
                                                                <ToolTip Text="删除" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="if (command == 'Delete'){
                                    Coolite.AjaxMethods.DeleteSelectedDealer(record.data.DEALERID,record.data.DealerFullName,{ success: function() { #{GridWd3PolicyDealerSeleted}.reload();#{GridWd7PolicyDealer}.reload();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                    } " />
                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBarPolicyDealersSelected" runat="server" PageSize="10"
                                                    StoreID="PolicyDealerSeletedStore" DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                                <Buttons>
                                    <ext:Button ID="btnPolicyDealerCancel" runat="server" Text="关闭" Icon="LorryAdd">
                                        <Listeners>
                                            <Click Handler="#{wd7PolicyDealer}.hide(null); #{PromotionID}.setValue('');#{type}.setValue('');" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </ext:Anchor>
                    </ext:FormLayout>
                </Body>
                <Listeners>
                    <BeforeHide Handler="#{PromotionID}.setValue('');#{type}.setValue('');" />
                </Listeners>
            </ext:Window>
            <ext:Window ID="wd4PolicyRule" runat="server" Icon="Group" Title="促销规则"
                Width="700" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
                Resizable="false" Header="false" CenterOnLoad="true" Maximizable="true">
                <Body>
                    <ext:BorderLayout ID="BorderLayout2" runat="server">
                        <Center>
                            <ext:GridPanel ID="GridFactorRule" runat="server" StoreID="FactorRuleStore" Border="false"
                                Icon="Lorry" StripeRows="true">
                                <ColumnModel ID="ColumnModel3" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="RuleDesc" DataIndex="RuleDesc" Align="Left" Header="描述" Width="500">
                                        </ext:Column>
                                        <ext:CommandColumn Width="50" Header="编辑" Align="Center">
                                            <Commands>
                                                <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                    <ToolTip Text="编辑" />
                                                </ext:GridCommand>
                                            </Commands>
                                        </ext:CommandColumn>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <Listeners>
                                    <Command Handler="if (command == 'Edit'){
                                                             Coolite.AjaxMethods.PromotionPolicyRuleSetShow(#{hidid}.getValue(''),record.data.RuleId,record.data.PolicyStyle,{success:function(){RefreshDetailWindow4();},failure:function(err){Ext.Msg.alert('Error', err);}})  
                                                                                  }                                                                                                       
                                                                                                         " />
                                </Listeners>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBarFactorRule" runat="server" PageSize="10" StoreID="FactorRuleStore"
                                        DisplayInfo="true" />
                                </BottomBar>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
                <Buttons>
                    <ext:Button ID="Button4" runat="server" Text="关闭" Icon="LorryAdd">
                        <Listeners>
                            <Click Handler="#{wd4PolicyRule}.hide(null); #{PromotionID}.setValue('');#{type}.setValue('');" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
                <Listeners>
                    <BeforeHide Handler="#{PromotionID}.setValue('');#{type}.setValue('');" />
                </Listeners>
            </ext:Window>
            <ext:Window ID="WindowPromotionType" runat="server" Icon="Group" Title="规则维护" Width="650"
                Height="250" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
                Resizable="false" Header="false">
                <Body>
                    <ext:BorderLayout ID="BorderLayout4" runat="server">
                        <Center MarginsSummary="5 5 5 5">
                            <ext:Panel ID="Panel10" runat="server" Header="false" Frame="true" AutoHeight="true">
                                <Body>
                                    <ext:Panel ID="Panel8" runat="server">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout2" runat="server" Split="false">
                                                <ext:LayoutColumn ColumnWidth="0.6">
                                                    <ext:Panel ID="Panel6" runat="server" Border="true" FormGroup="true">
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="140">
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="cbWd4PolicyFactorX" runat="server" Width="200"
                                                                        Editable="false" TypeAhead="true" StoreID="PolicyFactorXStore" ValueField="PolicyFactorId"
                                                                        DisplayField="FactName" AllowBlank="false" Mode="Local" FieldLabel="赠品/积分计算基数类型"
                                                                        Resizable="true">
                                                                        <Listeners>
                                                                            <Select Fn="factorDescriptionWd4" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtWd4FactorRemarkX" runat="server" FieldLabel="" ReadOnly="true"
                                                                        LabelSeparator="" Enabled="false" Width="200">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="cbWd4PolicyFactorY" runat="server" Width="200"
                                                                        Editable="false" TypeAhead="true" Mode="Local" FieldLabel="赠品/积分可订产品"
                                                                        Resizable="true">
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtWd4FactorRemarkY" runat="server" FieldLabel="" ReadOnly="true"
                                                                        LabelSeparator="" Enabled="false" Width="200">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:NumberField ID="txtFactorValueX" runat="server" Width="200" FieldLabel="赠品/积分计算系数1" DecimalPrecision="4">
                                                                    </ext:NumberField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:NumberField ID="txtFactorValueY" runat="server" Width="200" FieldLabel="赠品/积分计算系数2" DecimalPrecision="4"
                                                                        AllowBlank="false">
                                                                    </ext:NumberField>
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth="0.4">
                                                    <ext:Panel ID="Panel7" runat="server" Border="true" FormGroup="true" Title="描述" BodyStyle="padding:5px;">
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left">
                                                                <ext:Anchor>
                                                                    <ext:TextArea ID="areaWd4Desc" runat="server" FieldLabel="描述" HideLabel="true" Width="200"
                                                                        Height="120" AllowBlank="false">
                                                                    </ext:TextArea>
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:Panel>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
                <Listeners>
                    <Hide Handler="#{infoIlMessage}.setValue('');" />
                </Listeners>
                <Buttons>
                    <ext:Button ID="btnWd4AddFactor" runat="server" Text="修改系数" Icon="LorryAdd">
                        <Listeners>
                            <Click Handler="Coolite.AjaxMethods.Update({success:function(){
                     Ext.Msg.alert('提示','系数修改成功！');
                   #{WindowPromotionType}.hide();
                    },failure:function(err){Ext.Msg.alert('Error', err);}})  " />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="CloseButton" runat="server" Text="关闭" Icon="Cancel" OnClientClick="return false;">
                        <Listeners>
                            <Click Handler="#{WindowPromotionType}.hide()" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Window>
            <ext:Window ID="PolicyFactorswindow" runat="server" Icon="Group" Title="政策因素修改"
                Width="700" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
                Resizable="false" Header="false" CenterOnLoad="true" Maximizable="true">
                <Body>
                    <ext:BorderLayout ID="BorderLayout3" runat="server">
                        <Center>
                            <ext:GridPanel ID="GridFolicyFactor" runat="server" StoreID="FolicyFactorStore" Border="false"
                                Icon="Lorry" StripeRows="true">

                                <ColumnModel ID="ColumnModel4" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="FactName" DataIndex="FactName" Header="因素名称" Width="150">
                                        </ext:Column>
                                        <ext:Column ColumnID="IsGiftName" DataIndex="IsGiftName" Align="Left" Header="描述"
                                            Width="350">
                                        </ext:Column>
                                        <ext:CommandColumn Width="50" Header="编辑" Align="Center">
                                            <Commands>
                                                <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                    <ToolTip Text="编辑" />
                                                </ext:GridCommand>
                                            </Commands>
                                        </ext:CommandColumn>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" SingleSelect="true">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <Listeners>
                                    <Command Handler="if (command == 'Edit'){
Coolite.AjaxMethods.PromotionPolicyFactorSearchShow(record.data.PolicyFactorId,record.data.FactName,record.data.IsGiftName,record.data.IsGift,record.data.IsPoint,record.data.PolicyStyle,#{hidFactId}.getValue(),{success: function(){},failure: function(err) {Ext.Msg.alert('Error', err);}});
}  " />
                                </Listeners>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBarFactor" runat="server" PageSize="10" StoreID="FolicyFactorStore"
                                        DisplayInfo="true" />
                                </BottomBar>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
                <Buttons>
                    <ext:Button ID="Button1" runat="server" Text="关闭" Icon="LorryAdd">
                        <Listeners>
                            <Click Handler="#{PolicyFactorswindow}.hide();#{PromotionID}.setValue('');#{type}.setValue('');"></Click>
                        </Listeners>
                    </ext:Button>
                </Buttons>
                <Listeners>
                    <BeforeHide Handler="#{PromotionID}.setValue('');#{type}.setValue('');" />
                </Listeners>
            </ext:Window>
            <ext:Window ID="wd2PolicyFactor" runat="server" Icon="Group" Title="政策因素设定" Resizable="false"
                Header="false" Width="600" AutoScroll="true" Maximizable="true" AutoShow="false" ShowOnLoad="false"
                AutoHeight="true" Modal="true" BodyStyle="padding:5px;">
                <Body>
                    <ext:FormLayout ID="FormLayout11" runat="server">
                        <ext:Anchor>
                            <ext:Panel ID="PanelWd2PolicyFactor" runat="server" Border="true" Title="政策因素" BodyStyle="padding:5px;">
                                <Body>
                                    <ext:FormLayout ID="FormLayout12" runat="server" LabelWidth="100">
                                        <ext:Anchor>
                                            <ext:ComboBox ID="cbWd2Factor" runat="server" EmptyText="选择因素类型..." Width="200"
                                                BlankText="选择因素类型" AllowBlank="false" Mode="Local" FieldLabel="因素类型" Resizable="true">
                                                <Items>
                                                    <ext:ListItem Text="产品" Value="产品" />
                                                    <ext:ListItem Text="医院" Value="医院" />
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
                                            <ext:TextArea ID="txaWd2Remark" runat="server" Width="200" FieldLabel="描述" Height="30">
                                            </ext:TextArea>
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:ComboBox ID="cbWd2IsGift" runat="server" EmptyText="选择是否促销赠品..." Width="200"
                                                Editable="false" TypeAhead="true" Mode="Local" FieldLabel="促销赠品"
                                                Resizable="true">
                                                <Items>
                                                    <ext:ListItem Text="是" Value="Y" />
                                                    <ext:ListItem Text="否" Value="N" />
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
                                            <ext:ComboBox ID="cbWd2PointsValue" runat="server" EmptyText="选择是否积分可订购产品..." Width="200"
                                                Editable="false" TypeAhead="true" Mode="Local" FieldLabel="积分可订购产品"
                                                Resizable="true">
                                                <Items>
                                                    <ext:ListItem Text="是" Value="Y" />
                                                    <ext:ListItem Text="否" Value="N" />
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
                        </ext:Anchor>
                        <ext:Anchor>
                            <ext:Panel ID="PanelWd2AddFactorRule" runat="server" Border="true" Header="false"
                                AutoWidth="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout2" runat="server">
                                        <ext:GridPanel ID="GridWd2FactorRule" runat="server"
                                            AutoWidth="true" Border="false" Title="<font color='red'>政策因素添加成功，请给该因素设置限定条件！</font>"
                                            Icon="Lorry" StripeRows="true" Height="220" AutoScroll="true" StoreID="PolicyFactorRuleStore">
                                            <ColumnModel ID="ColumnModel6" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="ConditionName" DataIndex="ConditionName" Align="Left" Header="条件">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperTag" DataIndex="OperTag" Align="Left" Header="类型">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ConditionValue" DataIndex="ConditionValue" Align="Left" Header="描述" Width="300">
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="50" Header="编辑" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                                <ToolTip Text="编辑" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>

                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel6" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="if (command == 'Edit'){
                                                       Coolite.AjaxMethods.wd3PolicyFactorConditionshow(record.data.PolicyFactorConditionId,record.data.PolicyFactorId,{success:function(){ },failure:function(err){Ext.Msg.alert('Error', err);}});       
                                                                                  }  " />

                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10"
                                                    StoreID="PolicyFactorRuleStore" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                                <Buttons>
                                    <ext:Button ID="btnWd2Submint" runat="server" Text="关闭" Icon="LorryAdd">
                                        <Listeners>
                                            <Click Handler="#{wd2PolicyFactor}.hide();"></Click>
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </ext:Anchor>
                    </ext:FormLayout>
                </Body>
            </ext:Window>
            <ext:Window ID="wd3PolicyFactorCondition" runat="server" Icon="Group" Title="政策因素设定"
                Resizable="false" Header="false" Width="800" MinHeight="550" AutoShow="false"
                Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
                <Body>
                    <ext:BorderLayout ID="BorderLayout5" runat="server">
                        <West MinWidth="250" Split="true">
                            <ext:Panel ID="Panel16" runat="server" Border="true" Title="政策因素" BodyStyle="padding:5px;"
                                Width="250">
                                <Body>
                                    <ext:FormLayout ID="FormLayout13" runat="server" LabelWidth="70">
                                        <ext:Anchor>
                                            <ext:ComboBox ID="cbWd3FactorCondition" runat="server" EmptyText="选择条件..." Width="150"
                                                Editable="false" TypeAhead="true" StoreID="FactorConditionStore" ValueField="ConditionId"
                                                DisplayField="ConditionName" BlankText="选择条件" AllowBlank="false" Mode="Local"
                                                FieldLabel="条件" Resizable="true">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                </Triggers>
                                                <Listeners>
                                                    <TriggerClick Handler="this.clearValue(); #{cbWd3FactorConditionType}.clearValue(); #{FactorConditionTypeStore}.reload();" />
                                                </Listeners>
                                            </ext:ComboBox>
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:ComboBox ID="cbWd3FactorConditionType" runat="server" EmptyText="选择类型..." Width="150"
                                                Editable="false" TypeAhead="true" StoreID="FactorConditionTypeStore" ValueField="ConditionType"
                                                DisplayField="ConditionType" BlankText="选择类型" AllowBlank="false" Mode="Local"
                                                FieldLabel="类型" Resizable="true">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                </Triggers>
                                                <Listeners>
                                                    <TriggerClick Handler="this.clearValue();" />
                                                </Listeners>
                                            </ext:ComboBox>
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:TextField ID="txtWd3KeyValue" runat="server" FieldLabel="关键字" Width="150">
                                            </ext:TextField>
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:Panel ID="Panel17" runat="server" Border="false">
                                                <Body>
                                                    <ext:ColumnLayout ID="ColumnLayout5" runat="server" Split="false">
                                                        <ext:LayoutColumn ColumnWidth="0.3">
                                                            <ext:Panel ID="Panel19" runat="server" Border="true" FormGroup="true">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout15" runat="server" LabelAlign="Left">
                                                                        <ext:Anchor>
                                                                            <ext:Button ID="btnWd3FactorConditionQuery" runat="server" Text="查询" Icon="ArrowRefresh">
                                                                                <Listeners>
                                                                                    <Click Handler="#{PagingToolBar2}.changePage(1);" />
                                                                                </Listeners>
                                                                            </ext:Button>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth="0.4">
                                                            <ext:Panel ID="Panel20" runat="server" Border="true" FormGroup="true">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout16" runat="server" LabelAlign="Left">
                                                                        <ext:Anchor>
                                                                            <ext:Button ID="btnWd3UploadHospital" runat="server" Text="上传医院" Icon="LorryAdd"
                                                                                Hidden="true">
                                                                                <Listeners>
                                                                                    <Click Handler="Coolite.AjaxMethods.PromotionPolicyFactorRuleSearch.HospitalShow();" />
                                                                                </Listeners>
                                                                            </ext:Button>
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
                            </ext:Panel>
                        </West>
                        <Center>
                            <ext:Panel ID="Panel21" runat="server" Border="true" BodyStyle="padding:0px;">
                                <Body>
                                    <ext:FormLayout ID="FormLayout17" runat="server">
                                        <ext:Anchor>
                                            <ext:Panel ID="Panel22" runat="server" BodyBorder="false" Header="false"
                                                AutoWidth="true">
                                                <Body>
                                                    <ext:FitLayout ID="FitLayout4" runat="server">
                                                        <ext:GridPanel ID="GridWd3FactorRuleCondition" runat="server" StoreID="Wd3RuleStore"
                                                            AutoWidth="true" Border="false" Title="<font color='red'>可选约束条件</font>" Icon="Lorry"
                                                            StripeRows="true" AutoExpandColumn="Name" Height="230" AutoScroll="true">
                                                            <ColumnModel ID="ColumnModel7" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="Id" DataIndex="Id" Align="Left" Header="Id" Hidden="true">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Name" DataIndex="Name" Align="Left" Header="描述">
                                                                    </ext:Column>
                                                                    <ext:CommandColumn Width="50" Header="添加" Align="Center">
                                                                        <Commands>
                                                                            <ext:GridCommand Icon="Add" CommandName="Add">
                                                                                <ToolTip Text="添加" />
                                                                            </ext:GridCommand>
                                                                        </Commands>
                                                                    </ext:CommandColumn>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel7" SingleSelect="true" runat="server">
                                                                </ext:RowSelectionModel>
                                                            </SelectionModel>
                                                            <Listeners>
                                                                <Command Handler="if (command == 'Add'){
                                                                     Coolite.AjaxMethods.PromotionPolicyFactorRuleSearchAddRule(record.data.Id,{success: function(){RefreshGridWindow3();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                    } " />
                                                            </Listeners>
                                                            <BottomBar>
                                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="Wd3RuleStore"
                                                                    DisplayInfo="true" />
                                                            </BottomBar>
                                                            <SaveMask ShowMask="true" />
                                                            <LoadMask ShowMask="true" />
                                                        </ext:GridPanel>
                                                    </ext:FitLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>

                        </Center>
                        <South MinHeight="300" Split="true">
                            <ext:Panel ID="Panel23" runat="server" Border="true" BodyStyle="padding:0px;" Height="280">
                                <Body>
                                    <ext:FormLayout ID="FormLayout19" runat="server">
                                        <ext:Anchor>
                                            <ext:Panel ID="PanelWd3AddFactorConditionSelected" runat="server" BodyBorder="false"
                                                AutoWidth="true" Header="false" Frame="true">
                                                <Body>
                                                    <ext:FitLayout ID="FitLayout5" runat="server">
                                                        <ext:GridPanel ID="GridWd3FactorRuleConditionSeleted" runat="server" StoreID="Wd3RuleSeletedStore"
                                                            Border="false" Title="<font color='red'>已选约束条件</font>" Icon="Lorry" StripeRows="true"
                                                            AutoWidth="true" AutoExpandColumn="Name" Height="240" AutoScroll="true">
                                                            <ColumnModel ID="ColumnModel8" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="Id" DataIndex="Id" Align="Left" Header="Id" Hidden="true">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Name" DataIndex="Name" Align="Left" Header="描述">
                                                                    </ext:Column>
                                                                    <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                                        <Commands>
                                                                            <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                                                <ToolTip Text="删除" />
                                                                            </ext:GridCommand>
                                                                        </Commands>
                                                                    </ext:CommandColumn>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel8" SingleSelect="true" runat="server">
                                                                </ext:RowSelectionModel>
                                                            </SelectionModel>
                                                            <Listeners>
                                                                <Command Handler="if (command == 'Delete'){
                                    Coolite.AjaxMethods.PromotionPolicyFactorRuleSearchDeleteRule(record.data.Id,{success: function(){RefreshGridWindow3();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                    } " />
                                                            </Listeners>
                                                            <BottomBar>
                                                                <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="10" StoreID="Wd3RuleSeletedStore"
                                                                    DisplayInfo="true" />
                                                            </BottomBar>
                                                            <SaveMask ShowMask="true" />
                                                            <LoadMask ShowMask="true" />
                                                        </ext:GridPanel>
                                                    </ext:FitLayout>
                                                </Body>
                                                <Buttons>
                                                    <ext:Button ID="Button3" runat="server" Text="关闭" Icon="LorryAdd">
                                                        <Listeners>
                                                            <Click Handler="#{wd3PolicyFactorCondition}.hide()" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Buttons>
                                            </ext:Panel>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>
                        </South>
                    </ext:BorderLayout>
                </Body>
            </ext:Window>
        </div>
    </form>
</body>
</html>
