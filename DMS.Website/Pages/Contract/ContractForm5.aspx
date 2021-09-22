<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractForm5.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractForm5" %>

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
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <ext:Hidden ID="hdCmId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDealerId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdCmStatus" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDealerCnName" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdContStatus" runat="server">
    </ext:Hidden>
      <ext:Hidden ID="hdContId" runat="server">
    </ext:Hidden>
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript" language="javascript">
        var DownloadFile = function() {
        var url = '../Download.aspx?downloadname=Form 5.pdf&filename=FromHelp.pdf';
            window.open(url, 'Download');
        }
        
    </script>

    <div>
        <ext:Panel ID="btnPanel" runat="server" Header="false" Height="17">
            <TopBar>
                <ext:Toolbar ID="Toolbar1" runat="server">
                    <Items>
                        <ext:ToolbarFill />
                        <ext:Button ID="btnCreatePdf" runat="server" Text="生成IAF Form5 PDF" Icon="PageWhiteAcrobat"
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
        <ext:Panel ID="Panel155" runat="server" Header="true" Title="反腐败保证 表格5" Frame="true"
            Icon="Application" AutoHeight="true" AutoScroll="true" BodyStyle="padding:10px;"
            Collapsible="false">
            <Body>
                <span><font color="red"><b>&nbsp;&nbsp;&nbsp;*&nbsp;&nbsp;请使用英文填写表单信息<br>
                    &nbsp;</b></font></span>
                <div style="font-family: 微软雅黑; font-size: 13px;">
                    <ext:Label runat="server" ID="lbMe" HideLabel="true" Text="<%$ Resources:From5.Information1%>">
                    </ext:Label>
                    <ext:TextField ID="tfAntiCorruptionName" runat="server" Width="165" />
                    <ext:Label runat="server" ID="Label1" HideLabel="true" Text="<%$ Resources:From5.Information2%>">
                    </ext:Label>
                    <ext:TextField ID="tfAntiCorruptionDealer" runat="server" Width="165" ReadOnly="true" />
                    <span id="spanDetail" runat="server"></span>
                </div>
                <ext:Panel ID="Panel21" runat="server" FormGroup="true" BodyBorder="true" Title="签名信息">
                    <Body>
                        <ext:Panel ID="Panel22" runat="server" Header="false" Frame="true" Icon="Application"
                            AutoHeight="true" AutoScroll="true" BodyStyle="padding:0px;">
                            <Body>
                                <ext:Panel ID="Panel23" runat="server">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                            <ext:LayoutColumn ColumnWidth="1">
                                                <ext:Panel ID="Panel24" runat="server" Border="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="120">
                                                            <ext:Anchor>
                                                                <ext:Label ID="lbThirdParty" runat="server" FieldLabel="第三方名称">
                                                                </ext:Label>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfName" runat="server" FieldLabel="姓名">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfTital" runat="server" FieldLabel="头衔">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="dfSingeDate" runat="server" FieldLabel="日期">
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
    </div>
    </form>
</body>
</html>
