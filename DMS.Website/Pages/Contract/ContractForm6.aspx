<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractForm6.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractForm6" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript" language="javascript">
        var MsgList = {
        DeleteItem:{
				ConfirmMsg:"<%=GetLocalResourceObject("From6.Operation.ConfirmDelete").ToString()%>"
			}
        }
        
         var DownloadFile = function() {
            var url = '../Download.aspx?downloadname=Form 6.pdf&filename=FromHelp.pdf';
            window.open(url, 'Download');
        }
    </script>

    <ext:Hidden ID="hdCmId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdCmStatus" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDealerEnName" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdContStatus" runat="server">
    </ext:Hidden>
     <ext:Hidden ID="hdContId" runat="server">
    </ext:Hidden>
    <ext:Store ID="TrainingSignInStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshTrainingSignIn">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="TsiId" />
                    <ext:RecordField Name="TsiCmId" />
                    <ext:RecordField Name="TsiName" />
                    <ext:RecordField Name="TsiDealerName" />
                    <ext:RecordField Name="TsiTrainingDate" Type="Date" />
                    <ext:RecordField Name="BlCreateDate" />
                    <ext:RecordField Name="BlCreateUser" />
                    <ext:RecordField Name="BlUpdateDate" />
                    <ext:RecordField Name="BlUpdateUser" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <div>
        <ext:Panel ID="btnPanel" runat="server" Header="false" Height="17">
            <TopBar>
                <ext:Toolbar ID="Toolbar1" runat="server">
                    <Items>
                        <ext:ToolbarFill />
                        <ext:Button ID="btnCreatePdf" runat="server" Text="生成IAF Form6 PDF" Icon="PageWhiteAcrobat"
                            AutoPostBack="true" OnClick="CreatePdf">
                        </ext:Button>
                        <ext:Button ID="Button1" runat="server" Text="帮助" Icon="Help">
                            <Listeners>
                                <Click Fn="DownloadFile" />
                            </Listeners>
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </TopBar>
        </ext:Panel>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" BodyBorder="false" Height="0"
                            Title="<%$ Resources:From6.Title%>">
                            <Body>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel ID="plForm3" runat="server" Header="true" Title="<%$ Resources:From6.Title%>"
                            BodyBorder="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="gpTrainingSignIn" runat="server" StoreID="TrainingSignInStore"
                                        Border="false" StripeRows="true" Header="false">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar2" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill />
                                                    <ext:Button ID="btnTrainingSignIn" runat="server" Text="<%$ Resources:From6.BtnAdd%>"
                                                        Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="Coolite.AjaxMethods.ShowTrainingSignInWindow();" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="TsiName" DataIndex="TsiName" Width="150" Header="<%$ Resources:From6.Header.Name%>">
                                                </ext:Column>
                                                <ext:Column ColumnID="TsiDealerName" DataIndex="TsiDealerName" Width="250" Header="<%$ Resources:From6.Header.DealerName%>">
                                                </ext:Column>
                                                <ext:Column ColumnID="TsiTrainingDate" DataIndex="TsiTrainingDate" Align="Center"
                                                    Header="<%$ Resources:From6.Header.Date%>">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:CommandColumn Width="80" Header="<%$ Resources:From6.Header.Operation%>" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="<%$ Resources:From6.Header.Detail%>" />
                                                        </ext:GridCommand>
                                                        <ext:CommandSeparator />
                                                        <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                            <ToolTip Text="<%$ Resources:From6.Operation.Delete%>" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="TrainingSignInStore"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources:From6.Gird.NoData%>" />
                                        </BottomBar>
                                        <Listeners>
                                            <Command Handler="if (command == 'Delete'){
                                                        Ext.Msg.confirm('Message', MsgList.DeleteItem.ConfirmMsg,
                                                        function(e) {
                                                            if (e == 'yes') {
                                                                Coolite.AjaxMethods.DeleteTrainingSignInItem(record.data.TsiId,{success:function(){#{gpTrainingSignIn}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                            }});
                                                        }
                                          else if (command == 'Edit'){
                                                        Coolite.AjaxMethods.EditTrainingSignInItem(record.data.TsiId,{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                                        </Listeners>
                                        <LoadMask ShowMask="true" Msg="<%$ Resources:From6.Processing%>" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                    <South>
                        <ext:Panel ID="Panel21" runat="server" FormGroup="false" BodyBorder="true" Title="签名信息"
                            Height="130">
                            <Body>
                                <ext:Panel ID="Panel22" runat="server" Header="false" Frame="true" Icon="Application"
                                    AutoScroll="true" BodyStyle="padding:0px;">
                                    <Body>
                                        <ext:Panel ID="Panel23" runat="server">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                        <ext:Panel ID="Panel24" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="120">
                                                                    <ext:Anchor>
                                                                        <ext:Label ID="lbThirdParty" runat="server" FieldLabel="第三方名称">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfUserName" runat="server" FieldLabel="代表名称">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.3">
                                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="120">
                                                                    <ext:Anchor>
                                                                        <ext:DateField ID="dfSingeDate" runat="server" FieldLabel="培训日期">
                                                                        </ext:DateField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfTital" runat="server" FieldLabel="代表职位">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.4">
                                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="120">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfPresentedBy" runat="server" FieldLabel="培训人员">
                                                                        </ext:TextField>
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
                                <ext:Button ID="btnSaveDraft" runat="server" Text="保存草稿" Icon="Disk">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.SaveDraft();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnSubmit" runat="server" Text="提交" Icon="Tick" Hidden="true">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.SaveSubmit();" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </South>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <%-- 2.反腐败培训签到 --%>
        <ext:Hidden ID="hiddenWinTrainingSignInDetailId" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowTrainingSignIn" runat="server" Icon="Group" Title="<%$ Resources:From6.Window.Title%>"
            Resizable="false" Header="false" Width="410" Height="175" AutoShow="false" Modal="true"
            ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout11" runat="server">
                    <ext:Anchor>
                        <ext:Panel ID="Panel25" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel26" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="130">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinTrainingSignInName" runat="server" FieldLabel="<%$ Resources:From6.Window.Name%>"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinTrainingSignInDealerName" runat="server" FieldLabel="<%$ Resources:From6.Window.DealerName%>"
                                                            Width="220" ReadOnly="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="dfWinTrainingSignInDate" runat="server" Width="100" FieldLabel="<%$ Resources:From6.Window.Date%>" />
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
                <ext:Button ID="btnTrainingSignInSubmit" runat="server" Text="<%$ Resources:From6.Window.BtnSubmint%>"
                    Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveTrainingSignIn();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnTrainingSignInCancel" runat="server" Text="<%$ Resources:From6.Window.BtnCancel%>"
                    Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowTrainingSignIn}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
    </div>
    </form>
</body>
</html>
