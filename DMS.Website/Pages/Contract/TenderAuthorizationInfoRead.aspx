<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TenderAuthorizationInfoRead.aspx.cs" Inherits="DMS.Website.Pages.Contract.TenderAuthorizationInfoRead" %>
<%@ Register Src="../../Controls/ApprovalIframe.ascx" TagName="ApprovalIframe" TagPrefix="uc1" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
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
        <div id="DivStore">
            <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine">
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
            <ext:Store ID="ProductStore" runat="server" UseIdConfirmation="false" OnRefreshData="ProductStore_RefershData" AutoLoad="false">
                <AutoLoadParams>
                    <ext:Parameter Name="start" Value="={0}" />
                    <ext:Parameter Name="limit" Value="={15}" />
                </AutoLoadParams>
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="Id">
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="HosId" />
                            <ext:RecordField Name="HosHospitalShortName" />
                            <ext:RecordField Name="HosHospitalName" />
                            <ext:RecordField Name="HosKeyAccount" />
                            <ext:RecordField Name="SubProductName" />
                            <ext:RecordField Name="RepeatDealer" />
                            <ext:RecordField Name="TCount" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <Listeners>
                    <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
                </Listeners>
            </ext:Store>
            <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshAttachment">
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
                            <ext:RecordField Name="TypeName" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <Listeners>
                    <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
                </Listeners>
            </ext:Store>
            <ext:Store ID="DealerTypeStore" runat="server" UseIdConfirmation="true" OnRefreshData="DealerTypeStore_RefreshData">
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
                <SortInfo Field="Key" Direction="ASC" />
                <Listeners>
                </Listeners>
            </ext:Store>
        </div>
        <div id="DivHidden">
            <ext:Hidden ID="hidIsPageNew" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidStates" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidDtmId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidDthId" runat="server">
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
                                                    <asp:Literal ID="Literal1" runat="server" Text="招标授权审批" />
                                                </div>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutRow>
                                    <%--主信息--%>
                                    <ext:LayoutRow>
                                        <ext:FieldSet ID="DivSampleBusiness" runat="server" Header="true" Frame="false" BodyBorder="true"
                                            AutoHeight="true" AutoWidth="true" Title="基本信息">
                                            <Body>
                                                <ext:FormLayout runat="server">
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel1" runat="server" Header="false" Border="false">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth=".3">
                                                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="AtuNo" ReadOnly="true" runat="server" FieldLabel="授权编号"
                                                                                            Width="200">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="请选择产品线…" Enabled="true"
                                                                                            Width="200" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                                                            Mode="Local" DisplayField="AttributeName" FieldLabel="产品线"
                                                                                            ListWidth="200" Resizable="true" ReadOnly="true">
                                                                                        </ext:ComboBox>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:ComboBox ID="cbDealerType" runat="server" EmptyText="请选择经销商类型…" Enabled="true"
                                                                                            Width="200" Editable="false" TypeAhead="true" StoreID="DealerTypeStore" ValueField="Key"
                                                                                            Mode="Local" DisplayField="Value" FieldLabel="经销商类型"
                                                                                            ListWidth="200" Resizable="true" ReadOnly="true">
                                                                                        </ext:ComboBox>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth=".3">
                                                                        <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="AtuApplyUser" ReadOnly="true" runat="server" FieldLabel="申请人"
                                                                                            Width="200" >
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:DateField ID="AtuBeginDate" runat="server" Width="200" FieldLabel="授权开始时间" ReadOnly="true" Enabled="true">
                                                                                        </ext:DateField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:RadioGroup ID="AtulicenseType" runat="server" FieldLabel="是否三证合一" Width="150" Enabled="true" >
                                                                                            <Items>
                                                                                                <ext:Radio ID="AtulicenseTypeYes" runat="server" BoxLabel="是"
                                                                                                    Checked="true">
                                                                                                </ext:Radio>
                                                                                                <ext:Radio ID="AtulicenseTypeNo" runat="server" BoxLabel="否"
                                                                                                    Checked="false" />
                                                                                            </Items>
                                                                                        </ext:RadioGroup>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth=".3">
                                                                        <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                    <ext:Anchor>
                                                                                        <ext:Label ID="AtuApplyDate" runat="server" FieldLabel="申请时间" Height="22" Width="200" ReadOnly="true" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:DateField ID="AtuEndDate" runat="server" Width="200" FieldLabel="授权终止时间" ReadOnly="true" Enabled="true" />
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
                                                        <ext:Panel ID="Panel7" runat="server" Header="false" Border="false">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth=".58">
                                                                        <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="AtuDealerName" runat="server" FieldLabel="经销商名称" ReadOnly="true"
                                                                                            Width="600">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="AtuMailAddress" runat="server" FieldLabel="邮寄及联系方式" EmptyText="请填写邮寄地址及收件人信息" ReadOnly="true"
                                                                                            Width="600">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextArea ID="AtuRemark" runat="server" FieldLabel="备注" EmptyText="若授权时间超过90天，请在此填写原因" ReadOnly="true"
                                                                                            Width="600" Height="44">
                                                                                        </ext:TextArea>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth=".42">
                                                                        <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="20">
                                                                                    <ext:Anchor>
                                                                                        <ext:Label ID="atuDealerRemark" runat="server" HideLabel="true" LabelSeparator="" Width="200" CtCls="txtRed" ReadOnly="true" />
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
                                    <%--授权产品信息--%>
                                    <ext:LayoutRow>
                                        <ext:Panel ID="Panel23" runat="server" Border="false" Header="false" BodyStyle="padding-bottom:5px">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                                    <ext:LayoutColumn ColumnWidth="1">
                                                        <ext:GridPanel ID="gpProduct" runat="server" Title="授权产品" StoreID="ProductStore"
                                                            AutoScroll="true" StripeRows="true" Collapsible="false" Border="true" Icon="Lorry" AutoExpandColumn="RepeatDealer"
                                                            Height="400" AutoWidth="true">
                                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="HosKeyAccount" DataIndex="HosKeyAccount" Header="医院编号" Width="150">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="医院名称" Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="SubProductName" DataIndex="SubProductName" Header="授权产品" Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RepeatDealer" DataIndex="RepeatDealer" Header="重复授权经销商">
                                                                    </ext:Column>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server">
                                                                    <Listeners>
                                                                        <RowSelect Handler="var btndel = #{BtnDelProduct}; if(btndel != null && (#{hidStates}.getValue()=='Draft' || #{hidStates}.getValue()=='Deny') ) btndel.enable();" />
                                                                    </Listeners>
                                                                </ext:RowSelectionModel>
                                                            </SelectionModel>
                                                            <BottomBar>
                                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="ProductStore"
                                                                    DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                            </BottomBar>
                                                            <SaveMask ShowMask="false" />
                                                            <LoadMask ShowMask="true" />
                                                        </ext:GridPanel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutRow>
                                    <%--附件信息--%>
                                    <ext:LayoutRow>
                                        <ext:Panel ID="Panel60" runat="server" Border="false" Header="false" BodyStyle="padding-top:5px;padding-bottom:5px;">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout19" runat="server">
                                                    <ext:LayoutColumn ColumnWidth="1">
                                                        <ext:GridPanel ID="gpAttachment" runat="server" StoreID="AttachmentStore" Title="附件信息"
                                                            Border="true" Icon="Lorry" StripeRows="true" Height="300">
                                                            <ColumnModel ID="ColumnModel8" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="200" Header="附件名称">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="TypeName" DataIndex="TypeName" Header="附件类型" Width="125">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Width="90" Header="上传人">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Width="90" Header="上传时间">
                                                                    </ext:Column>
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

                                                            <LoadMask ShowMask="true" Msg="处理中..." />
                                                        </ext:GridPanel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutRow>
                                    <ext:LayoutRow>
                                        <ext:Panel ID="TabPanel1" runat="server" Border="true" BodyBorder="true" BodyStyle="background-color: #D9E7F8;">
                                            <Body>
                                                <uc1:ApprovalIframe id="approvalIframe1" runat="server" />
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutRow>
                                </ext:RowLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="BtnApprove" runat="server" Text="通过" Icon="LorryAdd" Hidden="true" >
                                    <Listeners>
                                        <Click Handler="Ext.Msg.confirm('Message','是否执行通过？',function(e) {if (e == 'yes') { Coolite.AjaxMethods.ApprovalIframe.Approve({success: function() {Ext.Msg.alert('Success', '通过成功！'); #{BtnApprove}.disable();#{BtnRefuse}.disable();}});}});" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnRefuse" runat="server" Text="驳回" Icon="Delete" Hidden="true" >
                                    <Listeners>
                                        <Click Handler="Ext.Msg.confirm('Message','是否执行驳回？',function(e) {if (e == 'yes') { Coolite.AjaxMethods.remarkValue({success: function(result) { if(result!='' ) {Coolite.AjaxMethods.ApprovalIframe.Refuse({success: function() {Ext.Msg.alert('Success', '驳回成功！'); #{BtnApprove}.disable();#{BtnRefuse}.disable();}});} else{Ext.Msg.alert('Error', '请在审批备注中填写驳回原因！');}}});  }});" />
                                    </Listeners>
                                </ext:Button>
                                 <ext:Button ID="BtnPress" runat="server" Text="催办" Icon="Cancel" Hidden="true" >
                                    <Listeners>
                                        <Click Handler="Ext.Msg.confirm('Message','是否执行催办？',function(e) {if (e == 'yes') { Coolite.AjaxMethods.ApprovalIframe.Press({success: function() {Ext.Msg.alert('Success', '催办成功！');}});}});" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnAbandon" runat="server" Text="撤销" Icon="Delete" Hidden="true" >
                                    <Listeners>
                                        <Click Handler="Ext.Msg.confirm('Message','是否执行撤销？',function(e) {if (e == 'yes') { Coolite.AjaxMethods.ApprovalIframe.Abandon({success: function() {Ext.Msg.alert('Success', '撤销成功！'); #{BtnApprove}.disable();#{BtnRefuse}.disable();}});}});" />
                                    </Listeners>
                                </ext:Button>
                                 <ext:Button ID="Button1" runat="server" Text="关闭" Icon="Cancel" >
                                    <Listeners>
                                        <Click Handler="if(getIsEkpAccess()=='FASE'){window.close();} else{window.location.href ='/Pages/Contract/TenderAuthorizationList.aspx'}" />
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
