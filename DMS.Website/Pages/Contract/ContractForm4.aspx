<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractForm4.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractForm4" %>

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
        var DownloadFile = function() {
            var url = '../Download.aspx?downloadname=Form 4.pdf&filename=FromHelp.pdf';
            window.open(url, 'Download');
        }
        
    </script>

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
    <div>
        <ext:Panel ID="btnPanel" runat="server" Header="false" Height="17">
            <TopBar>
                <ext:Toolbar ID="Toolbar1" runat="server">
                    <Items>
                        <ext:ToolbarFill />
                        <ext:Button ID="btnCreatePdf" runat="server" Text="生成IAF Form4 PDF" Icon="PageWhiteAcrobat"
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
        <ext:Panel ID="plForm4" runat="server" Header="true" Title="<%$ Resources:From4.Title%>"
            Frame="true" Icon="Application" AutoHeight="true" AutoScroll="true" BodyStyle="padding:10px;"
            Collapsible="false">
            <Body>
                <span><font color="red"><b>&nbsp;&nbsp;&nbsp;*&nbsp;&nbsp;请使用英文填写表单信息<br>
                    &nbsp;</b></font></span>
                <ext:Panel ID="Panel43" runat="server" Header="false" Frame="true" Icon="Application"
                    AutoHeight="true" AutoScroll="true" BodyStyle="padding:0px;">
                    <Body>
                        <ext:Panel ID="Panel44" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout14" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel45" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout25" runat="server" LabelWidth="120">
                                                    <ext:Anchor>
                                                        <ext:Label ID="label14" runat="server" HideLabel="true" Text="<%$ Resources:Part1.Notes1%>">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Label ID="label8" runat="server" HideLabel="true" ItemCls="labelBold" Text="<%$ Resources:Part1.Notes2%>">
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
                <ext:Panel ID="Panel46" runat="server" BodyBorder="true" BodyStyle="padding:10px;">
                    <Body>
                        <ext:Panel ID="Panel47" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout15" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.45">
                                        <ext:Panel ID="Panel48" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout26" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfFrom4DealerName" runat="server" FieldLabel="<%$ Resources:Part1.DealerName%>"
                                                            ReadOnly="true" Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfFrom4Assesser" runat="server" FieldLabel="<%$ Resources:Part1.Assesser%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="tfFrom4AssessDate" runat="server" FieldLabel="<%$ Resources:Part1.AssessDate%>">
                                                        </ext:DateField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.55">
                                        <ext:Panel ID="Panel49" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout27" runat="server" LabelWidth="110">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfFrom4Country" runat="server" FieldLabel="<%$ Resources:Part1.Country%>"
                                                            Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="TextField7" runat="server" FieldLabel="<%$ Resources:Part1.Signature%>"
                                                            Width="150" Hidden="true">
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
                <!--产品储存-->
                <ext:Panel ID="Panel50" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part2.Title%>">
                    <Body>
                        <ext:Panel ID="Panel55" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout17" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel57" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout32" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityStore1" runat="server" FieldLabel="<%$ Resources:Part2.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityStore1Yes" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityStore1No" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityStore1NA" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel58" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout33" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityStore1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Part2.Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel51" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout16" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel52" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout28" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityStore2" runat="server" FieldLabel="<%$ Resources:Part2.Confirmation2%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityStore2Yes" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityStore2No" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityStore2NA" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel53" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout29" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityStore2" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Part2.Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel54" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout18" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel56" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout30" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityStore3" runat="server" FieldLabel="<%$ Resources:Part2.Confirmation3%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityStore3Yes" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityStore3No" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityStore3NA" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel59" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout31" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityStore3" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Part2.Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel60" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout19" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel61" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout34" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityStore4" runat="server" FieldLabel="<%$ Resources:Part2.Confirmation4%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityStore4Yes" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityStore4No" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityStore4NA" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel62" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout35" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityStore4" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Part2.Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel63" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout20" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel64" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout36" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityStore5" runat="server" FieldLabel="<%$ Resources:Part2.Confirmation5%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityStore5Yes" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityStore5No" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityStore5NA" runat="server" BoxLabel="<%$ Resources:Part2.Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel65" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout37" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityStore5" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Part2.Confirm.Remarks%>">
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
                <!--产品可追溯性-->
                <ext:Panel ID="Panel66" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part3.Title%>">
                    <Body>
                        <ext:Panel ID="Panel67" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout21" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel68" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout38" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityTraceability1" runat="server" FieldLabel="<%$ Resources:Part3.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityTraceability1Yes" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityTraceability1No" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityTraceability1NA" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel69" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout39" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityTraceability1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Part3.Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel70" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout22" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel71" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout40" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rfQualityTraceability2" runat="server" FieldLabel="<%$ Resources:Part3.Confirmation2%>"
                                                            LabelSeparator="">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityTraceability2Yes" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityTraceability2No" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityTraceability2NA" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel72" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout41" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityTraceability2" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Part3.Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel73" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout23" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel74" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout42" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityTraceability3" runat="server" FieldLabel="<%$ Resources:Part3.Confirmation3%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityTraceability3Yes" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityTraceability3No" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityTraceability3NA" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel75" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout43" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityTraceability3" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Part3.Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel76" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout24" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel77" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout44" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityTraceability4" runat="server" FieldLabel="<%$ Resources:Part3.Confirmation4%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityTraceability4Yes" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityTraceability4No" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityTraceability4NA" runat="server" BoxLabel="<%$ Resources:Part3.Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel78" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout45" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityTraceability4" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Part3.Confirm.Remarks%>">
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
                <!--植入报告（仅由CRM和神经调节的第三方填写）-->
                <ext:Panel ID="Panel79" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part4.Title%>">
                    <Body>
                        <ext:Panel ID="Panel80" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout25" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel81" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout46" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityImplanted1" runat="server" FieldLabel="<%$ Resources:Part4.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityImplanted1Yes" runat="server" BoxLabel="<%$ Resources:Part4.Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityImplanted1No" runat="server" BoxLabel="<%$ Resources:Part4.Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityImplanted1NA" runat="server" BoxLabel="<%$ Resources:Part4.Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel82" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout47" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityImplanted1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Part4.Confirm.Remarks%>">
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
                <!--设备维护和软件更新-->
                <ext:Panel ID="Panel83" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part5.Title%>">
                    <Body>
                        <ext:Panel ID="Panel84" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout26" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel85" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout48" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityMaintain1" runat="server" FieldLabel="<%$ Resources:Part5.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityMaintain1Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityMaintain1No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityMaintain1NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel86" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout49" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityMaintain1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel87" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout27" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel88" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout50" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityMaintain2" runat="server" FieldLabel="<%$ Resources:Part5.Confirmation2%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityMaintain2Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityMaintain2No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityMaintain2NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel89" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout51" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityMaintain2" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
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
                <!--投诉报告-->
                <ext:Panel ID="Panel90" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part6.Title%>">
                    <Body>
                        <ext:Panel ID="Panel91" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout28" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel92" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout52" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityComplain1" runat="server" FieldLabel="<%$ Resources:Part6.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityComplain1Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityComplain1No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityComplain1NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel93" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout53" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityComplain1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel94" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout29" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel95" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout54" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityComplain2" runat="server" FieldLabel="<%$ Resources:Part6.Confirmation2%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityComplain2Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityComplain2No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityComplain2NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel96" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout55" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityComplain2" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel97" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout30" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel98" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout56" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityComplain3" runat="server" FieldLabel="<%$ Resources:Part6.Confirmation3%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityComplain3Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityComplain3No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityComplain3NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel99" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout57" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityComplain3" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel100" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout31" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel101" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout58" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityComplain4" runat="server" FieldLabel="<%$ Resources:Part6.Confirmation4%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityComplain4Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false">
                                                                </ext:Radio>
                                                                <ext:Radio ID="radioQualityComplain4No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityComplain4NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel102" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout59" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityComplain4" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
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
                <!--处理生物危害产品或有害产品的退回-->
                <ext:Panel ID="Panel103" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part7.Title%>">
                    <Body>
                        <ext:Panel ID="Panel104" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout32" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel105" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout60" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityDispose1" runat="server" FieldLabel="<%$ Resources:Part7.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityDispose1Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityDispose1No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityDispose1NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel106" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout61" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityDispose1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel107" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout33" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel108" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout62" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityDispose2" runat="server" FieldLabel="<%$ Resources:Part7.Confirmation2%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityDispose2Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityDispose2No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityDispose2NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel109" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout63" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityDispose2" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel110" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout34" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel111" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout64" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityDispose3" runat="server" FieldLabel="<%$ Resources:Part7.Confirmation3%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityDispose3Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityDispose3No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityDispose3NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel112" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout65" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityDispose3" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
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
                <!--警戒事件或其他医疗器械不良事件报告-->
                <ext:Panel ID="Panel113" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part8.Title%>">
                    <Body>
                        <ext:Panel ID="Panel114" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout35" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel115" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout66" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityGuard1" runat="server" FieldLabel="<%$ Resources:Part8.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityGuard1Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityGuard1No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityGuard1NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel116" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout67" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityGuard1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel117" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout36" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel118" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout68" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityGuard2" runat="server" FieldLabel="<%$ Resources:Part8.Confirmation2%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityGuard2Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityGuard2No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityGuard2NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel119" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout69" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityGuard2" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
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
                <!--召回和其他现场活动-->
                <ext:Panel ID="Panel120" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part9.Title%>">
                    <Body>
                        <ext:Panel ID="Panel121" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout37" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel122" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout70" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityRecall1" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityRecall1Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall1No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall1NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel123" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout71" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityRecall1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel124" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout38" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel125" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout72" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityRecall2" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation2%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityRecall2Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall2No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall2NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel126" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout73" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityRecall2" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel127" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout39" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel128" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout74" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityRecall3" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation3%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityRecall3Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall3No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall3NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel129" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout75" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityRecall3" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel130" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout40" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel131" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout76" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityRecall4" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation4%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityRecall4Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall4No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall4NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel132" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout77" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityRecall4" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel133" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout41" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel134" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout78" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityRecall5" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation5%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityRecall5Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall5No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall5NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel135" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout79" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityRecall5" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel136" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout42" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel137" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout80" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityRecall6" runat="server" FieldLabel="<%$ Resources:Part9.Confirmation6%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityRecall6Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall6No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecall6NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel138" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout81" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityRecall6" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
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
                <!--示范设备-->
                <ext:Panel ID="Panel139" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part10.Title%>">
                    <Body>
                        <ext:Panel ID="Panel140" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout43" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel141" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout82" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityExample1" runat="server" FieldLabel="<%$ Resources:Part10.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityExample1Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityExample1No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityExample1NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel142" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout83" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityExample1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
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
                <!--标签控制-->
                <ext:Panel ID="Panel143" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part11.Title%>">
                    <Body>
                        <ext:Panel ID="Panel144" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout44" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel145" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout84" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityLable1" runat="server" FieldLabel="<%$ Resources:Part11.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityLable1Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityLable1No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityLable1NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel146" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout85" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityLable1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
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
                <!--培训-->
                <ext:Panel ID="Panel147" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part12.Title%>">
                    <Body>
                        <ext:Panel ID="Panel148" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout45" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel149" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout86" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityTrain1" runat="server" FieldLabel="<%$ Resources:Part12.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityTrain1Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityTrain1No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityTrain1NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel150" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout87" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityTrain1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
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
                <!--记录保留-->
                <ext:Panel ID="Panel151" runat="server" FormGroup="true" BodyBorder="true" Title="<%$ Resources:Part13.Title%>">
                    <Body>
                        <ext:Panel ID="Panel152" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout46" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.6">
                                        <ext:Panel ID="Panel153" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout88" runat="server" LabelWidth="390">
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="rgQualityRecord1" runat="server" FieldLabel="<%$ Resources:Part13.Confirmation1%>"
                                                            LabelSeparator="?">
                                                            <Items>
                                                                <ext:Radio ID="radioQualityRecord1Yes" runat="server" BoxLabel="<%$ Resources:Confirm.Yes%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecord1No" runat="server" BoxLabel="<%$ Resources:Confirm.No%>"
                                                                    Checked="false" />
                                                                <ext:Radio ID="radioQualityRecord1NA" runat="server" BoxLabel="<%$ Resources:Confirm.NotApplicable%>"
                                                                    Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.4">
                                        <ext:Panel ID="Panel154" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout89" runat="server" LabelWidth="200">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQualityRecord1" runat="server" LabelCls="labelBold" FieldLabel="<%$ Resources:Confirm.Remarks%>">
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
                <ext:Button ID="btnSaveDraft" runat="server" Text="<%$ Resources:From4.Draft%>" Icon="Disk">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveDraft();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnSubmit" runat="server" Text="<%$ Resources:From4.Submit%>" Icon="Tick"
                    Hidden="true">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveSubmit();" />
                    </Listeners>
                </ext:Button>
                <%--  <ext:Button ID="btnCancel" runat="server" Text="取消" Icon="Delete" Hidden="true">
                    <Listeners>
                        <Click Handler="" />
                    </Listeners>
                </ext:Button>--%>
            </Buttons>
        </ext:Panel>
    </div>
    </form>
</body>
</html>
