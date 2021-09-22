<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractThirdParty.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractThirdParty" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .x-form-group .x-form-group-header-text
        {
            background-color: #dfe8f6 !important;
            color: Black !important;
            font-family: "微软雅黑" !important;
            font-size: 11px !important;
        }
        .x-form-group .x-form-group-header
        {
            padding: 10px !important;
            border-bottom: 2px solid #99bbe8 !important;
        }
        .x-panel-mc
        {
            font: normal 12px "微软雅黑" ,tahoma,arial,helvetica,sans-serif !important;
            font-weight: bold !important;
        }
        .labelBold
        {
            font-weight: bold !important;
        }
        .txtRed
        {
            color: Red;
            font-weight: bold;
        }
    </style>

    <script language="javascript" type="text/javascript">
        //设定无披露
        var addItems = function(grid) {

            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
                var param = '';

                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.Id + ',';
                }

                Coolite.AjaxMethods.SetNoDisclosure(param);


            } else {
                Ext.MessageBox.alert('错误', '请选择医院');
            }
        }

        //添加选中的产品线
        var addPL = function(grid) {
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
           
            var param = '';
            for (var i = 0; i < selList.length; i++) {
                param += selList[i].data.DivisionName + ',';
            }
            Coolite.AjaxMethods.SaveProductLine(param,
                        {
                            success: function() {
                           
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                        );

        } else {
            Ext.MessageBox.alert('Message', '确定要添加选中的产品线？');
        }
    }

    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script language="javascript" type="text/javascript">
        var DownloadFile = function() {
        var url = '../Download.aspx?downloadname=第三方公司披露操作方法.docx&filename=FromHelp.pdf';
            window.open(url, 'Download');
        }
        
        var DownloadTemplate = function() {
        var url = '../Download.aspx?downloadname=ThirdPartyTemplate.zip&filename=ThirdPartyTemplate.zip';
            window.open(url, 'Download');
        }
    </script>

    <ext:Hidden ID="hdDmaId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdProductLineId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdMarketType" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDealerType" runat="server">
    </ext:Hidden>
    <ext:Store ID="ThirdPartyDisclosureStore" runat="server" UseIdConfirmation="false"
        OnRefreshData="Store_RefreshThirdPartyDisclosure">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="DmaId" />
                    <ext:RecordField Name="HospitalId" />
                    <ext:RecordField Name="HospitalName" />
                    <ext:RecordField Name="CompanyName" />
                    <ext:RecordField Name="Rsm" />
                    <ext:RecordField Name="CompanyName2" />
                    <ext:RecordField Name="Rsm2" />
                    <ext:RecordField Name="ProductNameString" />
                    <ext:RecordField Name="NotTP" />
                    <ext:RecordField Name="ApprovalStatus" />
                    <ext:RecordField Name="ApprovalDate" />
                    <ext:RecordField Name="ApprovalName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="RsType" runat="server" AutoLoad="true" OnRefreshData="Store_RsType">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
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
        <ext:Store ID="CurrentProductLineStore" runat="server" OnRefreshData="ProductLineStore_RefreshData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="ProductLineId">
                <Fields>
                    <ext:RecordField Name="ProductLineId" />
                    <ext:RecordField Name="ProductLineName" />
                    <ext:RecordField Name="DivisionName" />
                    <ext:RecordField Name="StartDate" />
                    <ext:RecordField Name="EndDate" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Panel ID="btnPanel" runat="server" Header="false" Height="17">
        <TopBar>
            <ext:Toolbar ID="Toolbar1" runat="server">
                <Items>
                    <ext:ToolbarFill />
                    <ext:Button ID="btnCreatePdf" runat="server" Text="生成第三方披露表 PDF" Icon="PageWhiteAcrobat"
                        AutoPostBack="true" OnClick="CreatePdf">
                    </ext:Button>
                    <ext:Button ID="btnCancel" runat="server" Text="返回" Icon="Delete">
                        <Listeners>   
                            <Click Handler="window.location.href='/Pages/Contract/ContractMain.aspx';" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="Button1" runat="server" Text="使用帮助" Icon="Help"  Hidden="true">
                        <Listeners>
                            <Click Fn="DownloadFile" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="Button3" runat="server" Text="使用帮助及模板" Icon="Help">
                        <Listeners>
                            <Click Fn="DownloadTemplate" />
                        </Listeners>
                    </ext:Button>
                </Items>
            </ext:Toolbar>
        </TopBar>
    </ext:Panel>
    <ext:Panel ID="Panel3" runat="server" Header="true" Title="第三方披露表" Frame="true" Icon="Application"
        AutoHeight="true" AutoScroll="true" BodyStyle="padding:10px;" Collapsible="false">
        <Body>
            <ext:Panel ID="Panel10" runat="server" Header="false" BodyBorder="false" AutoHeight="true">
                <Body>
                    <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="190">
                        <ext:Anchor>
                            <ext:Label ID="Label3" runat="server" FieldLabel="" HideLabel="true" LabelSeparator=""
                                CtCls="txtRed" Text="提示：第三方公司披露的详细要求以及需签署的文件模板请从右上角“使用帮助及模板”中获得">
                            </ext:Label>
                        </ext:Anchor>
                    </ext:FormLayout>
                </Body>
            </ext:Panel>
            <ext:Panel ID="plSearch" runat="server" Header="true" BodyBorder="false" FormGroup="true"
                AutoHeight="true" Title="公司信息">
                <Body>
                    <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="190">
                        <ext:Anchor>
                            <ext:TextField ID="tfDealerNameCn" runat="server" FieldLabel="公司名称（本表简称“公司”)" ReadOnly="true"
                                Width="300">
                            </ext:TextField>
                        </ext:Anchor>
                    </ext:FormLayout>
                </Body>
            </ext:Panel>
            <ext:Panel ID="plForm3" runat="server" Header="true" Title="第三方公司披露" FormGroup="true"
                BodyBorder="true" AutoHeight="true">
                <Body>
                    <ext:Panel ID="Panel1" runat="server" Header="false" BodyBorder="true" AutoHeight="true">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtHospitalName" runat="server" Width="180" FieldLabel="医院名称" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".7">
                                    <ext:Panel ID="Panel6" runat="server" Border="false" Header="false" BodyStyle="padding:1px;">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                        <Listeners>
                                                            <Click Handler="#{PagingToolBar1}.changePage(1);" />
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
                    <ext:Panel ID="Panel2" runat="server" Header="false" BodyBorder="true" AutoHeight="true">
                        <TopBar>
                            <ext:Toolbar ID="Toolbar6" runat="server">
                                <Items>
                                    <ext:ToolbarFill />
                                    <ext:Button ID="btnTick" runat="server" Text="确认无披露" Icon="Tick">
                                        <Listeners>
                                            <Click Handler="addItems(#{gpThirdPartyDisclosure});" />
                                        </Listeners>
                                    </ext:Button>
                                </Items>
                            </ext:Toolbar>
                        </TopBar>
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="gpThirdPartyDisclosure" runat="server" StoreID="ThirdPartyDisclosureStore"
                                    Border="false" StripeRows="true" Header="false" AutoHeight="true">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                            </ext:Column>
                                            <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Width="150" Header="医院名称">
                                            </ext:Column>
                                            <ext:Column ColumnID="ProductNameString" DataIndex="ProductNameString" Width="100"
                                                Header="合作产品线">
                                            </ext:Column>
                                            <ext:Column ColumnID="CompanyName" DataIndex="CompanyName" Width="130" Header="公司名称1">
                                            </ext:Column>
                                            <ext:Column ColumnID="Rsm" DataIndex="Rsm" Width="180" Header="与贵司或医院关系1">
                                            </ext:Column>
                                            <ext:Column ColumnID="CompanyName2" DataIndex="CompanyName2" Width="130" Header="公司名称2">
                                            </ext:Column>
                                            <ext:Column ColumnID="Rsm2" DataIndex="Rsm2" Width="180" Header="与贵司或医院关系2">
                                            </ext:Column>
                                            <ext:CheckColumn ColumnID="NotTP" DataIndex="NotTP" Header="无披露" Width="50">
                                            </ext:CheckColumn>
                                            <ext:Column ColumnID="ApprovalStatus" DataIndex="ApprovalStatus" Header="审批状态" Width="80">
                                            </ext:Column>
                                            <ext:Column ColumnID="ApprovalName" DataIndex="ApprovalName" Header="审批人" Width="80">
                                            </ext:Column>
                                            <ext:Column ColumnID="ApprovalDate" DataIndex="ApprovalDate" Header="审批时间" Width="80">
                                            </ext:Column>
                                            <ext:CommandColumn Header="操作" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="明细" />
                                                    </ext:GridCommand>
                                                    <%--       <ext:CommandSeparator />--%>
                                                    <ext:GridCommand Icon="Delete" CommandName="Delete" Hidden="true">
                                                        <ToolTip Text="删除" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                            <Listeners>
                                            </Listeners>
                                        </ext:CheckboxSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ThirdPartyDisclosureStore"
                                            DisplayInfo="true" EmptyMsg="没有数据显示" />
                                    </BottomBar>
                                    <Listeners>
                                        <Command Handler="if (command == 'Delete'){
                                                        Ext.Msg.confirm('Message', '是否要删除?',
                                                        function(e) {
                                                            if (e == 'yes') {
                                                                Coolite.AjaxMethods.DeleteThirdPartyDisclosureItem(record.data.Id,{success:function(){#{gpThirdPartyDisclosure}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                            }});
                                                        }
                                          else if (command == 'Edit'){
                                                        Coolite.AjaxMethods.EditThirdPartyDisclosureItem(record.data.Id,{success:function(){#{GpWdAttachment}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                                    </Listeners>
                                    <LoadMask ShowMask="true" Msg="处理中……" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                    <ext:Panel ID="Panel9" runat="server" Header="false" Frame="true" Icon="Application"
                        AutoHeight="true" AutoScroll="true" BodyStyle="padding:1px;">
                        <Body>
                            <ext:Panel ID="Panel7" runat="server">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                        <ext:LayoutColumn ColumnWidth="1">
                                            <ext:Panel ID="Panel8" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="120">
                                                        <ext:Anchor>
                                                            <ext:Label ID="label1" runat="server" HideLabel="true" Text="兹通知，在贵司披露第三方公司时，蓝威或其代理公司可能会购买尽职调查验证报告及/或调查性的尽职调查报告，以获取有关各种事项的信息，包括但不限于公司结构、所有权、商务实践、银行记录、资信状况、破产程序、犯罪记录、民事记录、一般声誉及个人品质（包括前述任何项目，以及个人的教育程度、从业历史等），并有权根据报告结果拒绝与该第三方公司合作。若贵司未主动披露第三方公司，蓝威或其代理公司发现后，蓝威或其代理公司保留扣减贵司返利，直至解除合同取消授权等措施的权利。">
                                                            </ext:Label>
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
                </Body>
            </ext:Panel>
            <ext:Panel ID="Panel21" runat="server" FormGroup="true" BodyBorder="true" Title="确认信息"
                AutoHeight="true">
                <Body>
                    <ext:Panel ID="Panel22" runat="server" Header="false" Frame="true" Icon="Application"
                        AutoScroll="true" BodyStyle="padding:0px;">
                        <Body>
                            <ext:Panel ID="Panel4" runat="server">
                                <Body>
                                    <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="120">
                                        <ext:Anchor>
                                            <ext:Label ID="Label2" runat="server" HideLabel="true" LabelSeparator="" Text="本人已详读并充分明白上述通知，并确认在此提供的全部信息真实准确，本人经授权代表公司签字确认。">
                                            </ext:Label>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>
                            <ext:Panel ID="Panel23" runat="server">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                        <ext:LayoutColumn ColumnWidth="0.4">
                                            <ext:Panel ID="Panel24" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="120">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="tdUserName" runat="server" FieldLabel="姓名">
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="tfPosition" runat="server" FieldLabel="职位">
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:DateField ID="dpSignature" runat="server" FieldLabel="日期">
                                                            </ext:DateField>
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
                </Body>
                <Buttons>
                    <ext:Button ID="btnSubmit" runat="server" Text="保存" Icon="Tick">
                        <Listeners>
                            <Click Handler="Coolite.AjaxMethods.SaveSubmit();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Panel>
        </Body>
    </ext:Panel>
    <%-- 2.第三方披露表 --%>
    <ext:Hidden ID="hiddenWinThirdPartyDetailId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenHospitalId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenCountAttachment" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenProductLineName" runat="server">
    </ext:Hidden>
    <ext:Window ID="windowThirdParty" runat="server" Icon="Group" Title="第三方披露表" Resizable="false"
        Header="false" Width="500" Height="430" AutoShow="false" Modal="true" ShowOnLoad="false"
        BodyStyle="padding:5px;">
        <Body>
            <ext:FitLayout ID="FitLayout2" runat="server">
                <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                    <Tabs>
                        <ext:Tab ID="TabHeader" runat="server" Title="政策概要" BodyStyle="padding: 6px;" AutoScroll="true">
                            <%--表头信息 --%>
                            <Body>
                                <ext:FitLayout ID="FTHeader" runat="server">
                                    <ext:FormPanel ID="FormPanelHard" runat="server" Header="false" Border="false">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout1" runat="server" Split="false">
                                                <ext:LayoutColumn ColumnWidth=".5">
                                                    <ext:Panel ID="Panel26" runat="server" Border="false">
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="120">
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="tfWinHospitalName" runat="server" FieldLabel="医院名称" Width="220"
                                                                        ReadOnly="true">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                        <ext:Panel ID="pan" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:ColumnLayout ID="ColumnLayout4" runat="server" Split="false">
                                                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                                                        <ext:Panel ID="Panel" runat="server" Border="true" FormGroup="true">
                                                                                            <Body>
                                                                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left">
                                                                                                    <ext:Anchor>
                                                                                                        <ext:Label ID="lbPLAlert" runat="server" FieldLabel="合作产品线" Text=""></ext:Label>
                                                                                                    </ext:Anchor>
                                                                                                </ext:FormLayout>
                                                                                            </Body>
                                                                                        </ext:Panel>
                                                                                    </ext:LayoutColumn>
                                                                                    <ext:LayoutColumn ColumnWidth="0.7">
                                                                                        <ext:Panel ID="Panel11" runat="server" Border="true" FormGroup="true">
                                                                                            <Body>
                                                                                                <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left">
                                                                                                    <ext:Anchor>
                                                                                                         <ext:Button ID="btnWdProductLine" runat="server" Text="添加" Icon="PackageAdd" FieldLabel="产品线">
                                                                                                            <Listeners>
                                                                                                                <Click Handler="Coolite.AjaxMethods.ProductLineShow();" />
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
                                                                <ext:Anchor>
                                                                    <ext:Label ID="Label4" runat="server" FieldLabel="" CtCls="txtRed" HideLabel="true" Text="     提示：请选择该第三方公司在该医院销售的所有产品线"></ext:Label>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Checkbox ID="chNotTP" runat="server" FieldLabel="无披露">
                                                                        <Listeners>
                                                                            <Check Handler="#{AjaxMethods}.changeWinPageValue();" />
                                                                        </Listeners>
                                                                    </ext:Checkbox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="tfWinCompanyName" runat="server" FieldLabel="第三方公司1" Width="220">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="cbWinRs" runat="server" Width="220" Editable="true" TypeAhead="true"
                                                                        Resizable="true" StoreID="RsType" ValueField="Key" DisplayField="Value" FieldLabel="与贵司或医院关系1">
                                                                        <Listeners>
                                                                            <Select Handler="#{tfWinRsm}.setValue(''); #{tfWinRsm}.setValue(this.getText()); if(this.getText()=='经销商指定公司') {#{lbWinRsmRemark}.setText('请上传文件：贵司与第三方公司的合同、合规附件、合规/质量培训签到表和质量自检表，请在查询页面下载相关模板'); } else if(this.getText()=='医院指定公司') {#{lbWinRsmRemark}.setText('请上传证明文件：第三方与医院的合同，或医院公函，或医院公告，或医院官方网站说明，或经BSC销售团队确认的经销商声明');} else{#{lbWinRsmRemark}.setText('');}" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="tfWinRsm" runat="server" FieldLabel="" Width="220" LabelSeparator=""
                                                                        ReadOnly="true">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Label ID="lbWinRsmRemark" runat="server" LabelSeparator="">
                                                                    </ext:Label>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="tfWinCompanyName2" runat="server" FieldLabel="第三方公司2" Width="220">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="cbWinRs2" runat="server" Width="220" Editable="true" TypeAhead="true"
                                                                        Resizable="true" StoreID="RsType" ValueField="Key" DisplayField="Value" FieldLabel="与贵司或医院关系2">
                                                                        <Listeners>
                                                                            <Select Handler="#{tfWinRsm2}.setValue(''); #{tfWinRsm2}.setValue(this.getText());if(this.getText()=='经销商指定公司') {#{lbWinRsmRemark2}.setText('请上传文件：贵司与第三方公司的合同、合规附件、合规/质量培训签到表和质量自检表，请在查询页面下载相关模板'); } else if(this.getText()=='医院指定公司') {#{lbWinRsmRemark2}.setText('请上传证明文件：第三方与医院的合同，或医院公函，或医院公告，或医院官方网站说明，或经BSC销售团队确认的经销商声明');} else{#{lbWinRsmRemark2}.setText('');}" />
                                                                        </Listeners>
                                                                    </ext:ComboBox> 
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="tfWinRsm2" runat="server" FieldLabel="" Width="220" LabelSeparator=""
                                                                        ReadOnly="true">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Label ID="lbWinRsmRemark2" runat="server" LabelSeparator="">
                                                                    </ext:Label>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextArea ID="taWinApprovalRemark" runat="server" FieldLabel="审批意见" Width="220"
                                                                        Hidden="true">
                                                                    </ext:TextArea>
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:FormPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="Tab3" runat="server" Title="附件" AutoScroll="true">
                            <%-- 附件管理--%>
                            <Body>
                                <ext:FitLayout ID="FitLayout5" runat="server">
                                    <ext:GridPanel ID="GpWdAttachment" runat="server" StoreID="AttachmentStore" Border="false"
                                        Icon="Lorry">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar4" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill4" runat="server" />
                                                    <ext:Button ID="btnPolicyAttachmentAdd" runat="server" Text="新增附件" Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="Coolite.AjaxMethods.AttachmentShow();" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
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
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                    </Tabs>
                </ext:TabPanel>
            </ext:FitLayout>
        </Body>
        <Buttons>
            <ext:Button ID="btnThirdPartyApproval" runat="server" Text="审批通过" Icon="Tick">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.Approval({success: function() {
                                                                                            #{windowThirdParty}.hide(); #{gpThirdPartyDisclosure}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="btnThirdPartyReject" runat="server" Text="审批拒绝" Icon="Decline">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.Reject({ success: function() {
                                                                                            #{windowThirdParty}.hide();#{gpThirdPartyDisclosure}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="btnThirdPartySubmit" runat="server" Text="提交" Icon="Tick">
                <Listeners>
                    <Click Handler=" if((#{tfWinRsm}.getValue()=='医院指定公司' ||#{tfWinRsm2}.getValue()=='医院指定公司')&&  #{hiddenCountAttachment}.getValue() == '0' ) { Ext.Msg.alert('Error','请先上传证明文件后在提交！');}else{Coolite.AjaxMethods.SaveThirdParty({success: function() { },failure: function(err) {Ext.Msg.alert('Error', err);}});}" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="btnThirdPartyCancel" runat="server" Text="返回" Icon="Delete">
                <Listeners>
                    <Click Handler="#{windowThirdParty}.hide();" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
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
                                        Ext.Msg.wait('正在上传附件...', '附件上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{GpWdAttachment}.reload();#{ufUploadAttachment}.setValue('')">
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
        <ext:Window ID="wdProductLine" runat="server" Icon="Group" Title="添加产品线" Width="500" Height="400" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Resizable="false" Header="false">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <Center MarginsSummary="0 5 5 5">
                        <ext:Panel ID="Panel14" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="GridPanel2" runat="server" StoreID="CurrentProductLineStore" Title="产品线列表" Border="false" Icon="Lorry" StripeRows="true" AutoExpandColumn="ProductLineName" Header="false">
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DivisionName" DataIndex="DivisionName" Header="BU">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineName" Width="200" DataIndex="ProductLineName" Header="产品线名称">
                                                </ext:Column>                                       
                                            </Columns>
                                        </ColumnModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="CurrentProductLineStore" />
                                        </BottomBar>
                                         <SelectionModel>
                                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                                            </ext:CheckboxSelectionModel>
                                        </SelectionModel>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
                <ext:KeyMap ID="KeyMap1" runat="server" Target="={Ext.isGecko ? Ext.getDoc() : Ext.getBody()}">
                    <ext:KeyBinding>
                        <Keys>
                            <ext:Key Code="ENTER" />
                        </Keys>
                        <Listeners>
                            <Event Handler="#{PagingToolBar2}.changePage(1);" />
                        </Listeners>
                    </ext:KeyBinding>
                    <ext:KeyBinding Shift="true">
                        <Keys>
                            <ext:Key Code="ENTER" />
                        </Keys>
                        <Listeners>
                            <Event Handler="addPL(#{GridPanel2});" />
                        </Listeners>
                    </ext:KeyBinding>
                </ext:KeyMap>
            </Body>
            <Buttons>
                <ext:Button ID="AddItemsButton" runat="server" Text="添加" Icon="Add">
                    <Listeners>
                        <Click Handler="addPL(#{GridPanel2});#{wdProductLine}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Buttons>
                <ext:Button ID="CloseWindow" runat="server" Text="关闭" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{wdProductLine}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
    </form>
</body>
</html>
