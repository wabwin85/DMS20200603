<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TerminationUpdate.aspx.cs" Inherits="DMS.Website.Pages.Contract.TerminationUpdate" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"></script>

    <script src="../../resources/data-view-plugins.js" type="text/javascript"></script>
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

        .images-view .x-panel-body {
            background: white;
            font: 11px Arial, Helvetica, sans-serif;
        }

        .images-view .thumb {
            background: #dddddd;
            padding: 3px;
            height: 80px;
            width: 150px;
        }

            .images-view .thumb img {
                height: 80px;
                width: 150px;
            }

        .images-view .thumb-wrap {
            float: left;
            margin: 4px;
            margin-right: 0;
            padding: 5px;
            text-align: center;
            height: 120px;
            width: 160px;
        }

            .images-view .thumb-wrap span {
                display: block;
                overflow: hidden;
                text-align: center;
            }

        .images-view .x-view-over {
            border: 1px solid #dddddd;
            background: #efefef repeat-x left top;
            padding: 4px;
        }

        .images-view .x-view-selected {
            background: #eff5fb;
            border: 1px solid #99bbe8 no-repeat right bottom;
            padding: 4px;
        }

            .images-view .x-view-selected .thumb {
                background: transparent;
            }

        .images-view .loading-indicator {
            font-size: 11px;
            background-image: url(../../resources/images/loading.gif);
            background-repeat: no-repeat;
            background-position: left;
            padding-left: 20px;
            margin: 10px;
        }

        .txtRed {
            color: Red;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager runat="server" />
        <script type="text/javascript" language="javascript">
            var DoSubmint = function () {
                Coolite.AjaxMethods.checkAttachment({
                    success: function (result) {
                        if (result == 'success') {
                            Ext.Msg.confirm('Message', "确认提交修改？",
                                function (e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.SaveSubmint(
                                            {
                                                success: function (result) {
                                                    if (result == 'success') {
                                                        Ext.Msg.alert('Success', '保存成功!');
                                                    }
                                                    else {
                                                        Ext.Msg.alert('Error', "保存失败!");
                                                    }

                                                },
                                                failure: function (err) {
                                                    Ext.Msg.alert('Error', err);
                                                }
                                            }
                                        );
                                    }
                                }
                            );
                        }
                        else {
                            Ext.Msg.alert('Error', '请提上传证明文件后提交修改！');
                        }
                    },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                    }
                });
            }

        </script>


        <ext:Hidden ID="hidUpdateId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="contractid" runat="server"></ext:Hidden>
        <div id="DivStore">
            <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
                <Reader>
                    <ext:JsonReader ReaderID="SapCode">
                        <Fields>
                            <ext:RecordField Name="ChineseName" />
                            <ext:RecordField Name="ChineseShortName" />
                            <ext:RecordField Name="SapCode" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshAttachment" AutoLoad="false">
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
                <Listeners>
                    <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
                </Listeners>
            </ext:Store>
            <ext:Store ID="logStore" runat="server" OnRefreshData="Store_Refreshlog" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="UserName" />
                            <ext:RecordField Name="UpdateDate" Type="Date" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <Listeners>
                    <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
                </Listeners>
            </ext:Store>

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
                                                        <asp:Literal ID="Literal1" runat="server" Text="经销商Termination合同调整" />
                                                    </div>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutRow>
                                        <ext:LayoutRow>
                                            <ext:FieldSet ID="FieldSet1" runat="server" Header="true" Frame="false" BodyBorder="true"
                                                AutoHeight="true" Title="查询合同">
                                                <Body>
                                                    <ext:FormLayout runat="server">
                                                        <ext:Anchor>
                                                            <ext:Panel ID="Panel10" runat="server" Header="false" Border="false">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth=".33">
                                                                            <ext:Panel ID="Panel11" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="txtContractNo" runat="server" FieldLabel="<font color='red'><b>请输入合同编号</b></font>"
                                                                                                Width="200">
                                                                                            </ext:TextField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:Label ID="labDealerName" runat="server" FieldLabel="经销商" Width="200" />
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".33">
                                                                            <ext:Panel ID="Panel1" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                        <ext:Anchor>
                                                                                            <ext:Label ID="labProductLine" runat="server" FieldLabel="产品线" Width="200" />
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:Label ID="labContractStatus" runat="server" FieldLabel="合同状态" Width="200" />
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".34">
                                                                            <ext:Panel ID="Panel13" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                        <ext:Anchor>
                                                                                            <ext:Label ID="labSubBu" runat="server" FieldLabel="合同分类" Width="200" />
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:Label ID="labEName" runat="server" FieldLabel="申请人" Width="200" />
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                    </ext:ColumnLayout>
                                                                </Body>
                                                                <Buttons>
                                                                    <ext:Button ID="ButtonQuery" runat="server" Text="查询" Icon="ArrowRefresh">
                                                                        <Listeners>
                                                                            <Click Handler="
                                                                            if(#{txtContractNo}.getValue()==''){
                                                                            Ext.Msg.alert('Error', '合同编号不允许为空！');}
                                                                            
                                                                            else{
                                                                            Coolite.AjaxMethods.ContractQuery({success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                                                                        </Listeners>
                                                                    </ext:Button>
                                                                    <ext:Button ID="ButtonEdit" runat="server" Text="编辑" Icon="NoteEdit" Enabled="false">
                                                                        <Listeners>
                                                                            <Click Handler=" Coolite.AjaxMethods.ContractEdit({success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                                        </Listeners>
                                                                    </ext:Button>
                                                                    <ext:Button ID="ButtonAbandon" runat="server" Text="放弃" Icon="Delete" Enabled="false">
                                                                        <Listeners>
                                                                            <Click Handler=" Coolite.AjaxMethods.ContractAbandon({success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                                        </Listeners>
                                                                    </ext:Button>
                                                                </Buttons>
                                                            </ext:Panel>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:FieldSet>
                                        </ext:LayoutRow>
                                        <ext:LayoutRow>
                                            <ext:FieldSet ID="FieldSetMain" runat="server" Frame="false" BodyBorder="true" AutoHeight="true" Title="合同明细">
                                                <Body>
                                                    <ext:FormLayout runat="server">
                                                        <ext:Anchor>
                                                            <%-- 合同主信息--%>
                                                            <ext:Panel ID="PanelMain" runat="server" Header="true" Title="主信息" BodyStyle="padding: 5px;" FormGroup="true">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth=".33">
                                                                            <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                        <ext:Anchor>
                                                                                            <ext:Label ID="DealerBeginDate" runat="server" FieldLabel="原协议生效日" />
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="DealerEndTyp" runat="server" FieldLabel="终止类型">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="DealerEndTyp0" runat="server" BoxLabel="不续约">
                                                                                                    </ext:Radio>
                                                                                                    <ext:Radio ID="DealerEndTyp1" runat="server" BoxLabel="终止" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>

                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".30">
                                                                            <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                        <ext:Anchor>
                                                                                            <ext:Label ID="DealerEndDate" runat="server" FieldLabel="原协议到期日" />
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:DateField ID="PlanExpiration" runat="server" FieldLabel="终止生效日期">
                                                                                            </ext:DateField>
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".36">
                                                                            <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup17" runat="server" FieldLabel="终止原因">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="DealerEndReason1" runat="server" BoxLabel="应收帐款问题" />
                                                                                                    <ext:Radio ID="DealerEndReason2" runat="server" BoxLabel="未完成指标 " />
                                                                                                    <ext:Radio ID="DealerEndReason3" runat="server" BoxLabel="产品线停产" />
                                                                                                    <ext:Radio ID="DealerEndReason4" runat="server" BoxLabel="其他" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextArea ID="OtherReason" runat="server" Width="300" FieldLabel="其他终止原因"></ext:TextArea>
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                    </ext:ColumnLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Anchor>
                                                        <%--合同修改明细--%>
                                                        <ext:Anchor>
                                                            <ext:Panel ID="Panel3" runat="server" Header="true" Title="明细信息" BodyStyle="padding: 5px;" FormGroup="true">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth=".7">
                                                                            <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="270">
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="IsUbiddingwork" runat="server" FieldLabel="是否有未完成的投标工作?" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="TenderIssue1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="TenderIssue0" runat="server" BoxLabel="否"></ext:Radio>
                                                                                                </Items>

                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="rgIsDeposit" runat="server" FieldLabel="代理商的返利 ？" Width="500" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="Exchangeproduct1" runat="server" BoxLabel="换货 " />
                                                                                                    <ext:Radio ID="Refund1" runat="server" BoxLabel="退款 " />
                                                                                                    <ext:Radio ID="None1" runat="server" BoxLabel="无" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup1" runat="server" FieldLabel="代理商促销" Width="500" Height="20">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="Exchangeproduct2" runat="server" BoxLabel="换货" />
                                                                                                    <ext:Radio ID="Refund2" runat="server" BoxLabel="退款 " />
                                                                                                    <ext:Radio ID="None2" runat="server" BoxLabel="无" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup2" runat="server" FieldLabel="代理商投诉换货" Width="500" Height="20">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="Exchangeproduct3" runat="server" BoxLabel="换货" />
                                                                                                    <ext:Radio ID="Refund3" runat="server" BoxLabel="退款 " />
                                                                                                    <ext:Radio ID="None3" runat="server" BoxLabel="无" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup3" runat="server" FieldLabel="代理商终止后是否有退货" Width="400" Height="20">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="GoodsReturn1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="GoodsReturn0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup4" runat="server" FieldLabel="交接货原因" Width="500" Height="20">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="ReturnReason1" runat="server" BoxLabel="长效期产品（大于六个月）" />
                                                                                                    <ext:Radio ID="ReturnReason2" runat="server" BoxLabel="短效期产品 " />
                                                                                                    <ext:Radio ID="ReturnReason3" runat="server" BoxLabel="过期和损害产品" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup5" runat="server" FieldLabel="代理商是否有资质开红字通知单" Width="400" Height="20">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="CreditMemo1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="CreditMemo0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup6" runat="server" FieldLabel="是否和代理商存在争议款项，需要BSC支付代理商" Width="400" Height="20">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="IsPendingPayment1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="IsPendingPayment0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextArea ID="PendingRemark" runat="server" FieldLabel="争议款项原因" Height="50" Width="500"></ext:TextArea>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="CurrentAR" runat="server" FieldLabel="经销商应付账款" Width="400" Height="20"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".3">
                                                                            <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout11" runat="server" LabelAlign="Left" LabelWidth="180">
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="TenderIssueRemark" runat="server" FieldLabel="备注"></ext:TextField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="RebateAmt" runat="server" FieldLabel="返利金额"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="PromotionAmt" runat="server" FieldLabel="促销金额"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="ComplaintAmt" runat="server" FieldLabel="投诉换货金额"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="GoodsReturnAmt" runat="server" FieldLabel="退换货金额"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="IsRGAAttach" runat="server" FieldLabel="交接货产品清单" Height="20">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="IsRGAAttach1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="IsRGAAttach0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="CreditMemoRemark" runat="server" FieldLabel="备注"></ext:TextField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="PendingAmt" runat="server" FieldLabel="金额"></ext:NumberField>
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
                                                            <ext:Panel ID="Panel9" runat="server" Border="false" Header="false" BodyStyle="padding: 5px;">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth=".8">
                                                                            <ext:Panel ID="Panel15" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="380">
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup21" runat="server" FieldLabel="现金抵押" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="CashDeposit1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="CashDeposit0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup22" runat="server" FieldLabel="银行保函" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="BGuarantee1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="BGuarantee0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup23" runat="server" FieldLabel="公司保函" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="CGuarantee1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="CGuarantee0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup24" runat="server" FieldLabel="代理商缺货和未清的短期寄售" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="Inventory1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="Inventory0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="EstimatedAR" runat="server" FieldLabel="结算金额" Width="250"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField runat="server" ID="Wirteoff" FieldLabel="其中申请坏账损失(wirte off)" LabelSeparator="" Width="250"></ext:TextField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField runat="server" ID="PaymentPlan" FieldLabel="如果清算后仍有欠款，请填写付款计划" LabelSeparator="" Width="250"></ext:TextField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup25" runat="server" FieldLabel="坏帐计提？" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="Reserve1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="Reserve0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="ReserveAmt" runat="server" FieldLabel="坏帐金额" LabelSeparator="" Width="250"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup26" runat="server" FieldLabel="坏帐类型" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="BadDebt" runat="server" BoxLabel="Bad Debt" />
                                                                                                    <ext:Radio ID="Settlement" runat="server" BoxLabel="Settlement" />
                                                                                                    <ext:Radio ID="SalesReturn" runat="server" BoxLabel="Sales Return" />
                                                                                                    <ext:Radio ID="Other" runat="server" BoxLabel="Other " />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField runat="server" ID="TakeOver" FieldLabel="谁来接管此经销商业务" LabelSeparator="" Width="350"></ext:TextField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup7" runat="server" FieldLabel="接管经销商类型" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="BSC" runat="server" BoxLabel="BSC" />
                                                                                                    <ext:Radio ID="LP" runat="server" BoxLabel="LP" />
                                                                                                    <ext:Radio ID="T1" runat="server" BoxLabel="T1" />
                                                                                                    <ext:Radio ID="T2" runat="server" BoxLabel="T2" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup8" runat="server" FieldLabel="如果是新经销商，是否已经提交新经销商申请" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="TakeOverIsNew1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="TakeOverIsNew0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup9" runat="server" FieldLabel="是否已经通知经销商不续约或终止" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="Notified1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="Notified0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:DateField ID="WhenNotify" FieldLabel="何时通知经销商不续约或终止" runat="server" Width="200"></ext:DateField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:DateField ID="WhenSettlement" FieldLabel="何时完成结算" runat="server" Width="200"></ext:DateField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:DateField ID="WhenHandover" FieldLabel="何时完成交接工作" runat="server" Width="200"></ext:DateField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup10" runat="server" FieldLabel="该代理商是否有涉及患者随访" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="FollowUp1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="FollowUp0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextArea ID="FollowUpRemark" runat="server" FieldLabel="如果是，患者随访跟进措施" Width="350"></ext:TextArea>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup11" runat="server" FieldLabel="该代理商是否正在执行任何现场行动" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="FieldOperation1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="FieldOperation0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextArea FieldLabel="如果是，现场行动进展" ID="FieldOperationRemark" runat="server" Width="350"></ext:TextArea>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup12" runat="server" FieldLabel="该代理上是否有正在上报中的不良事件" Width="350" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="AdverseEvent1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="AdverseEvent0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextArea FieldLabel="如果是，不良事件上报进展" ID="AdverseEventRemark" runat="server" Width="350"></ext:TextArea>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup20" runat="server" FieldLabel="如为CRM代理商，已使用产品的植入单是否已提交到BSC" Width="350" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="SubmitImplant1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="SubmitImplant0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:DateField runat="server" ID="SubmitImplantRemark" FieldLabel="如果否，预计完成时间是" Width="200"></ext:DateField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup13" runat="server" FieldLabel="代理商库存产品处置情况" Width="350" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="InventoryDispose1" runat="server" BoxLabel="退回波科" />
                                                                                                    <ext:Radio ID="InventoryDispose2" runat="server" BoxLabel="转移给其他经销商" />
                                                                                                    <ext:Radio ID="InventoryDispose3" runat="server" BoxLabel="其他">
                                                                                                    </ext:Radio>
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextArea ID="InventoryDisposeRemark2" runat="server" FieldLabel="如果是其他，请说明" Width="350">
                                                                                            </ext:TextArea>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>

                                                                                            <ext:TextField ID="InventoryDisposeRemark1" runat="server" FieldLabel="如果是转移给其他代理商，代理商是" Width="350"></ext:TextField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup14" runat="server" FieldLabel="是否将此事通知到DRM, Finance, Operations & HEGA？" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="NotifiedNCM1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="NotifiedNCM0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup15" runat="server" FieldLabel="是否已审阅并确认以上结算提案, Finance, Operations & HEGA？" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="Reviewed1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="Reviewed0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:RadioGroup ID="RadioGroup16" runat="server" FieldLabel="是否已为交接工作提交新经销商申请表格？" Width="400" Height="20" LabelSeparator="">
                                                                                                <Items>
                                                                                                    <ext:Radio ID="Handover1" runat="server" BoxLabel="是" />
                                                                                                    <ext:Radio ID="Handover0" runat="server" BoxLabel="否" />
                                                                                                </Items>
                                                                                            </ext:RadioGroup>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextArea ID="HandoverRemark" runat="server" FieldLabel="如果没有请说明，请说明" Width="350">
                                                                                            </ext:TextArea>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="CurrentQuota" runat="server" FieldLabel="截至到当前季度指标总额" LabelSeparator="" Width="250"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="ActualSales" runat="server" FieldLabel="截至当前季度实际采购总额" LabelSeparator="" Width="250"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="TenderDetails" runat="server" FieldLabel="蓝威在经销商终止协议之后若要继续参加投标，请提供详细信息" LabelSeparator="" Width="250"></ext:TextField>
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>

                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".3">
                                                                            <ext:Panel ID="Panel16" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="CashDepositAmt" runat="server" FieldLabel="金额"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="BGuaranteeAmt" runat="server" FieldLabel="金额"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="CGuaranteeAmt" runat="server" FieldLabel="金额"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                        <ext:Anchor>
                                                                                            <ext:NumberField ID="InventoryAmt" runat="server" FieldLabel="金额"></ext:NumberField>
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>

                                                                    </ext:ColumnLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Anchor>
                                                        <%--附件信息--%>
                                                        <ext:Anchor>
                                                            <ext:Panel ID="Panel60" runat="server" Header="true" Title="证明文件" BodyStyle="padding: 5px;" FormGroup="true">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout19" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth="1">
                                                                            <ext:GridPanel ID="gpAttachment" StoreID="AttachmentStore" runat="server" Icon="Lorry" StripeRows="true" Height="150">
                                                                                <TopBar>
                                                                                    <ext:Toolbar ID="Toolbar7" runat="server">
                                                                                        <Items>
                                                                                            <ext:ToolbarFill />
                                                                                            <ext:Button ID="btnAddAttachment" runat="server" Text="上传附件" Icon="Add" Enabled="false">
                                                                                                <Listeners>
                                                                                                    <Click Handler="#{windowAttachment}.show();" />
                                                                                                </Listeners>
                                                                                            </ext:Button>
                                                                                        </Items>
                                                                                    </ext:Toolbar>
                                                                                </TopBar>
                                                                                <ColumnModel ID="ColumnModel8" runat="server">
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
                                                                                    <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" StoreID="AttachmentStore">
                                                                                    </ext:RowSelectionModel>
                                                                                </SelectionModel>
                                                                                <BottomBar>
                                                                                    <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="30"
                                                                                        DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                                                </BottomBar>
                                                                                <Listeners>
                                                                                    <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该下载文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            #{gpAttachment}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });
                                                                    }
                                                                    else if (command == 'DownLoad')
                                                                    {
                                                                        var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=TenderFile';
                                                                        open(url, 'Download');
                                                                    }
                                                                    " />
                                                                                </Listeners>
                                                                                <LoadMask ShowMask="true" Msg="处理中..." />
                                                                            </ext:GridPanel>
                                                                        </ext:LayoutColumn>
                                                                    </ext:ColumnLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Anchor>
                                                        <%--修改记录--%>
                                                        <ext:Anchor>
                                                            <ext:Panel ID="Panel12" runat="server" Header="true" Title="修改记录" BodyStyle="padding: 5px;" FormGroup="true">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth="1">
                                                                            <ext:GridPanel ID="gplog" runat="server" StoreID="logStore" Icon="Lorry" StripeRows="true" Height="150">
                                                                                <ColumnModel ID="ColumnModel1" runat="server">
                                                                                    <Columns>
                                                                                        <ext:Column ColumnID="UserName" DataIndex="UserName" Width="260" Header="修改人">
                                                                                        </ext:Column>
                                                                                        <ext:Column ColumnID="UpdateDate" DataIndex="UpdateDate" Width="250" Header="修改时间">
                                                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y/m/d h:i')" />
                                                                                        </ext:Column>
                                                                                    </Columns>
                                                                                </ColumnModel>
                                                                                <SelectionModel>
                                                                                    <ext:RowSelectionModel ID="RowSelectionModel1" runat="server">
                                                                                    </ext:RowSelectionModel>
                                                                                </SelectionModel>
                                                                                <BottomBar>
                                                                                    <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="5" StoreID="logStore"
                                                                                        DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                                                </BottomBar>
                                                                                <LoadMask ShowMask="true" Msg="处理中..." />
                                                                            </ext:GridPanel>
                                                                        </ext:LayoutColumn>
                                                                    </ext:ColumnLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                                <Buttons>
                                                    <ext:Button ID="BtnClose" runat="server" Text="关闭" Icon="Cancel" Enabled="false">
                                                        <Listeners>
                                                            <%--<Click Handler="#{} " />--%>
                                                        </Listeners>
                                                    </ext:Button>
                                                    <ext:Button ID="BtnApprove" runat="server" Text="提交" Icon="LorryAdd" Enabled="false">
                                                        <Listeners>
                                                            <Click Handler="DoSubmint();" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Buttons>
                                            </ext:FieldSet>
                                        </ext:LayoutRow>
                                    </ext:RowLayout>
                                </Body>

                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:ViewPort>

            <%--windowAttachment--%>
            <ext:Window ID="windowAttachment" runat="server" Icon="Group" Title="上传附件" Resizable="false"
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
                            <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="120">
                                <ext:Anchor>
                                    <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择上传附件" FieldLabel="文件"
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
                                    <Click OnEvent="UploadClick" Before="if(!#{AttachmentForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');"
                                        Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });"
                                        Success="#{gpAttachment}.reload();#{AttachmentForm}.getForm().reset();#{btnWinAttachmentSubmit}.setDisabled(true);">
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                            <ext:Button ID="ResetButton" runat="server" Text="清除">
                                <Listeners>
                                    <Click Handler="#{AttachmentForm}.getForm().reset();#{btnWinAttachmentSubmit}.setDisabled(true);" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:FormPanel>
                </Body>
                <Listeners>
                    <Hide Handler="#{gpAttachment}.reload();" />
                    <BeforeShow Handler="#{FileUploadField1}.setValue('');" />
                </Listeners>
            </ext:Window>
        </div>
    </form>
    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>
</body>
</html>
