<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AmendmentUpdate.aspx.cs" Inherits="DMS.Website.Pages.Contract.AmendmentUpdate" %>

<%@ Register Src="~/Controls/TerritoryEditorAdmin.ascx" TagName="TerritoryEditorAdmin" TagPrefix="uc" %>
<%@ Register Src="~/Controls/AOPEditorAdmin.ascx" TagName="AopEditorAdmin" TagPrefix="uc" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
        <ext:ScriptManager ID="ScriptManager1" runat="server" />

        <script type="text/javascript">
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

            var ProductAllWindow = function () {
                var contractId = Ext.getCmp('<%=this.hidContractId.ClientID%>')
                var updateId = Ext.getCmp('<%=this.hidUpdateId.ClientID%>')
                var subbucode = Ext.getCmp('<%=this.hidSubBuCode.ClientID%>')
                var effectivedate = Ext.getCmp('<%=this.dfAmendEffectiveDate.ClientID%>')
                var companyId = Ext.getCmp('<%=this.hidCompanyId.ClientID%>')
                var productline = Ext.getCmp('<%=this.labProductLine.ClientID%>')
                var massage = "";
                if (contractId.getValue() == "") {
                    massage += "合同ID为空"
                    //Ext.Msg.alert('Error', '信息不完整，不能维护授权！');
                }
                if (updateId.getValue() == "") {
                    massage += "用户ID为空"
                }
                if (subbucode.getValue() == "") {
                    massage += "SubBU为空"
                }
                if (effectivedate.getValue() == "") {
                    massage += "开始时间为空"
                }
                if (companyId.getValue() == "")
                { massage += "公司为空" }
                if (productline.getText() == "") {
                    massage += "产品线为空"
                }
                if (massage == "") {
                    Coolite.AjaxMethods.TerritoryEditorAdmin.Show(contractId.getValue(), updateId.getValue(), 'Amendment', subbucode.getValue(), effectivedate.getValue(), companyId.getValue(), productline.getText(), { success: function () { }, failure: function (err) { Ext.Msg.alert('Error', err); } });
                }
                else {
                    //Ext.Msg.alert('Error', massage);
                    Ext.Msg.alert('Error', '信息不完整，不能维护授权！');
                };
            }
            var UpdateAOPWindow = function () {
                var contractId = Ext.getCmp('<%=this.hidContractId.ClientID%>')
                var updateId = Ext.getCmp('<%=this.hidUpdateId.ClientID%>')
                var subbucode = Ext.getCmp('<%=this.hidSubBuCode.ClientID%>')
                var effectivedate = Ext.getCmp('<%=this.dfAmendEffectiveDate.ClientID%>')
                var companyId = Ext.getCmp('<%=this.hidCompanyId.ClientID%>')
                var productline = Ext.getCmp('<%=this.labProductLine.ClientID%>')
                var massage = "";
                if (contractId.getValue() == "") {
                    massage += "合同ID为空"
                    //Ext.Msg.alert('Error', '信息不完整，不能维护授权！');
                }
                if (updateId.getValue() == "") {
                    massage += "用户ID为空"
                }
                if (subbucode.getValue() == "") {
                    massage += "SubBU为空"
                }
                if (effectivedate.getValue() == "") {
                    massage += "开始时间为空"
                }
                if (companyId.getValue() == "")
                { massage += "公司为空" }
                if (productline.getText() == "") {
                    massage += "产品线为空"
                }
                if (massage == "") {
                    Coolite.AjaxMethods.AopEditorAdmin.Show(contractId.getValue(), updateId.getValue(), 'Amendment', subbucode.getValue(), effectivedate.getValue(), companyId.getValue(), productline.getText(), { success: function () { }, failure: function (err) { Ext.Msg.alert('Error', err); } });
                }
                else {
                    //Ext.Msg.alert('Error', massage);
                    Ext.Msg.alert('Error', '信息不完整，不能维护授权！');
                };
            }
        </script>

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
            <ext:Store ID="logStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_Refreshlog" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="Id">
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
            <ext:Store ID="ContractAttachmentStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshContractAttachment" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="AttId">
                        <Fields>
                            <ext:RecordField Name="AttId" />
                            <ext:RecordField Name="FileName" />
                            <ext:RecordField Name="FileUrl" />
                            <ext:RecordField Name="CreateDate" />
                            <ext:RecordField Name="CreateUser" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <Listeners>
                    <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
                </Listeners>
            </ext:Store>
        </div>
        <div id="DivHidden">
            <ext:Hidden ID="hidContractId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidUpdateId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidContractStatus" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidSubBuCode" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidCompanyId" runat="server">
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
                                                    <asp:Literal ID="Literal1" runat="server" Text="经销商合同修改" />
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
                                                                        <Click Handler="Coolite.AjaxMethods.ContractQuery({success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});" />
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
                                                                                        <ext:Label ID="labDealerBeginDate" runat="server" FieldLabel="原协议生效日" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:ComboBox ID="cbAssessment" runat="server" EmptyText="请选择经销商..." Width="200" Editable="true"
                                                                                            TypeAhead="true" StoreID="DealerStore" ValueField="SapCode" DisplayField="ChineseShortName"
                                                                                            Mode="Local" FieldLabel="合并考核经销商" ListWidth="300" Resizable="true">
                                                                                            <Triggers>
                                                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                                                            </Triggers>
                                                                                            <Listeners>
                                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                                            </Listeners>
                                                                                        </ext:ComboBox>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextArea ID="taPurpose" runat="server" FieldLabel="<font color='red'><b>修改原因</b></font>" Width="200" Height="60">
                                                                                        </ext:TextArea>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth=".33">
                                                                        <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                    <ext:Anchor>
                                                                                        <ext:Label ID="labDealerEndDate" runat="server" FieldLabel="原协议到期日" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:DateField ID="dfAssessmentStart" runat="server" Width="200" FieldLabel="合并考核时间">
                                                                                        </ext:DateField>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth=".34">
                                                                        <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                    <ext:Anchor>
                                                                                        <ext:DateField ID="dfAmendEffectiveDate" runat="server" Width="200" FieldLabel="<font color='red'><b>修改生效日</b></font>">
                                                                                        </ext:DateField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:ComboBox ID="cbIsEquipment" runat="server" EmptyText="请选择..." Width="200" Editable="true"
                                                                                            TypeAhead="true" Mode="Local" FieldLabel="是否设备经销商" Resizable="true">
                                                                                            <Items>
                                                                                                <ext:ListItem Value="0" Text="否 / No" />
                                                                                                <ext:ListItem Value="1" Text="是/ Yes" />
                                                                                            </Items>
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
                                                    <%--合同修改明细--%>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel3" runat="server" Header="true" Title="修改后协议" BodyStyle="padding: 5px;" FormGroup="true">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth=".5">
                                                                        <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="150">
                                                                                    <ext:Anchor>
                                                                                        <ext:Button ID="ButtonTerritory" runat="server" Text="修改区域" Icon="NoteEdit">
                                                                                            <Listeners>
                                                                                                <Click Handler="ProductAllWindow();" />
                                                                                            </Listeners>
                                                                                        </ext:Button>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:RadioGroup ID="rgPayment" runat="server" FieldLabel="付款方式" Width="250">
                                                                                            <Items>
                                                                                                <ext:Radio ID="rgCOD" runat="server" BoxLabel="COD" />
                                                                                                <ext:Radio ID="rgLC" runat="server" BoxLabel="L/C" />
                                                                                                <ext:Radio ID="rgCredit" runat="server" BoxLabel="Credit" />
                                                                                            </Items>
                                                                                        </ext:RadioGroup>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:RadioGroup ID="rgIsDeposit" runat="server" FieldLabel="是否有担保？ " Width="250">
                                                                                            <Items>
                                                                                                <ext:Radio ID="rgDepositYear" runat="server" BoxLabel="是" />
                                                                                                <ext:Radio ID="rgDepositNo" runat="server" BoxLabel="否" />
                                                                                            </Items>
                                                                                        </ext:RadioGroup>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:NumberField ID="tfDeposit" runat="server" FieldLabel="保证金(CNY)" Width="250">
                                                                                        </ext:NumberField>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth=".5">
                                                                        <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="150">
                                                                                    <ext:Anchor>
                                                                                        <ext:Button ID="ButtonAOP" runat="server" Text="修改指标" Icon="NoteEdit">
                                                                                            <Listeners>
                                                                                                <Click Handler="UpdateAOPWindow();" />
                                                                                            </Listeners>
                                                                                        </ext:Button>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:RadioGroup ID="rgCreditTerm" runat="server" FieldLabel="信用期限(天数)" Width="250">
                                                                                            <Items>
                                                                                                <ext:Radio ID="rg30" runat="server" BoxLabel="30" />
                                                                                                <ext:Radio ID="rg60" runat="server" BoxLabel="60" />
                                                                                                <ext:Radio ID="rg90" runat="server" BoxLabel="90" />
                                                                                                <ext:Radio ID="rg120" runat="server" BoxLabel="120" />
                                                                                                <ext:Radio ID="rg150" runat="server" BoxLabel="150" />
                                                                                            </Items>
                                                                                        </ext:RadioGroup>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:NumberField ID="tfCreditLimit" runat="server" FieldLabel="信用额度(CNY, 含增值税)" Width="250">
                                                                                        </ext:NumberField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="tfInform" runat="server" FieldLabel="保证金形式" Width="250">
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
                                                        <ext:Hidden ID="hidContractAttachment" runat="server"></ext:Hidden>
                                                    </ext:Anchor>
                                                    <%--合同附件--%>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel14" runat="server" Header="true" Title="合同附件" BodyStyle="padding: 5px;" FormGroup="true">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="1">
                                                                        <ext:GridPanel ID="gpContractAttachment" runat="server" StoreID="ContractAttachmentStore" Icon="Lorry" StripeRows="true" Height="150">
                                                                            <TopBar>
                                                                                <ext:Toolbar ID="Toolbar1" runat="server">
                                                                                    <Items>
                                                                                        <ext:ToolbarFill />
                                                                                        <ext:Button ID="btnAddContractAttachment" runat="server" Text="上传附件" Icon="Add" Enabled="false">
                                                                                            <Listeners>
                                                                                                <Click Handler="#{windowContractAttachment}.show();" />
                                                                                            </Listeners>
                                                                                        </ext:Button>
                                                                                    </Items>
                                                                                </ext:Toolbar>
                                                                            </TopBar>
                                                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                                                <Columns>
                                                                                    <ext:Column ColumnID="FileName" DataIndex="FileName" Width="200" Header="附件名称">
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="CreateUser" DataIndex="CreateUser" Width="90" Header="上传人">
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Width="90" Header="上传时间">
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
                                                                                <ext:RowSelectionModel ID="RowSelectionModel2" runat="server">
                                                                                </ext:RowSelectionModel>
                                                                            </SelectionModel>
                                                                            <BottomBar>
                                                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="30" StoreID="ContractAttachmentStore"
                                                                                    DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                                            </BottomBar>
                                                                            <Listeners>
                                                                                <Command Handler="if (command == 'Delete'){
                                                                                        Ext.Msg.confirm('警告', '是否要删除该下载文件?',
                                                                                            function(e) {
                                                                                                if (e == 'yes') {
                                                                                                    Coolite.AjaxMethods.DeleteContractAttachment(record.data.AttId,{
                                                                                                        success: function() {
                                                                                                            #{gpContractAttachment}.reload();
                                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                                }
                                                                                            });
                                                                                    }
                                                                                    else if (command == 'DownLoad')
                                                                                    {
                                                                                        var url = '../Download.aspx?downloadname=' + escape(record.data.FileName) + '&filename=' + escape(record.data.FileUrl) + '&downtype=ContractFileAdmin';
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
                                                    <%--附件信息--%>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel60" runat="server" Header="true" Title="证明文件" BodyStyle="padding: 5px;" FormGroup="true">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout19" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth="1">
                                                                        <ext:GridPanel ID="gpAttachment" runat="server" StoreID="AttachmentStore" Icon="Lorry" StripeRows="true" Height="150">
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
                                                                                <ext:RowSelectionModel ID="RowSelectionModel3" runat="server">
                                                                                </ext:RowSelectionModel>
                                                                            </SelectionModel>
                                                                            <BottomBar>
                                                                                <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="30" StoreID="AttachmentStore"
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
                                                        <%--    <Click Handler="return NeedSave(); " />--%>
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
       <%-- 合同附件上传--%>
         <ext:Window ID="windowContractAttachment" runat="server" Icon="Group" Title="上传附件" Resizable="false"
            Header="false" Width="500" Height="150" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="ContractAttachmentForm" runat="server" Width="500" Frame="true" Header="false"
                    AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout9" runat="server" LabelWidth="120">
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadContract" runat="server" EmptyText="选择上传附件" FieldLabel="文件"
                                    ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{btnWinContractAttachmentSubmit}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="btnWinContractAttachmentSubmit" runat="server" Text="上传附件">
                            <AjaxEvents>
                                <Click OnEvent="ContractUploadClick" Before="if(!#{ContractAttachmentForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');"
                                    Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });"
                                    Success="#{gpContractAttachment}.reload();#{ContractAttachmentForm}.getForm().reset();#{btnWinContractAttachmentSubmit}.setDisabled(true);">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="Button2" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{ContractAttachmentForm}.getForm().reset();#{btnWinContractAttachmentSubmit}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </Body>
            <Listeners>
                <Hide Handler="#{gpContractAttachment}.reload();" />
                <BeforeShow Handler="#{FileUploadContract}.setValue('');" />
            </Listeners>
        </ext:Window>

        <uc:TerritoryEditorAdmin ID="TerritoryEditorDialog1" runat="server"></uc:TerritoryEditorAdmin>
        <uc:AopEditorAdmin ID="AopEditorAdmin1" runat="server"></uc:AopEditorAdmin>

    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
