<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerProfileImport.aspx.cs"
    Inherits="DMS.Website.Pages.DPInfo.DealerProfileImport" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Dealer Profile导入</title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });
    </script>

    <div id="DivStore">
        <ext:Store ID="StoImportList" runat="server" UseIdConfirmation="false" OnRefreshData="StoImportList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="SheetName" />
                        <ext:RecordField Name="LineNum" />
                        <ext:RecordField Name="ErrorDesc" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
    </div>
    <div id="DivHidden">
        <ext:Hidden ID="IptRtnVal" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptRtnMsg" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptFileName" runat="server">
        </ext:Hidden>
    </div>
    <div id="DivView">
        <ext:ViewPort ID="WdwMain" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="FrmImport" runat="server" Width="500" Frame="true" Title="数据导入"
                            AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;"
                            ButtonAlign="Left">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel11" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="100" ColumnWidth=".5">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptImportType" runat="server" EmptyText="请选择导入类型…" Width="300"
                                                            Editable="false" TypeAhead="true" FieldLabel="导入类型" ListWidth="300" Resizable="true"
                                                            AllowBlank="false" MsgTarget="Side">
                                                            <Items>
                                                                <%--<ext:ListItem Value="" Text="--第三方信息--" />--%>
                                                                <ext:ListItem Value="DPComp" Text="合规调查报告" />
                                                                <ext:ListItem Value="DPAuditChannel" Text="渠道审计结果" />
                                                                <ext:ListItem Value="DPAudit" Text="渠道审计分析评估" />
                                                                <%--<ext:ListItem Value="" Text="--合规审计报告--" />--%>
                                                                <ext:ListItem Value="DPBaseComp" Text="基础合规审计报告" />
                                                                <ext:ListItem Value="DPDeepComp" Text="深度合规审计报告" />
                                                                <%--<ext:ListItem Value="" Text="--日常管理信息--" />--%>
                                                                <ext:ListItem Value="DPTrain" Text="培训记录" />
                                                                <ext:ListItem Value="DPPrize" Text="年度奖项名单" />
                                                                <ext:ListItem Value="DPSatisfy" Text="经销商满意度" />
                                                                <ext:ListItem Value="DPPay" Text="付款结算及违约记录" />
                                                            </Items>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <Select Handler="
                                                                    if (#{IptImportType}.getValue() == 'DPPay') {
                                                                        #{IptPayVersion}.show();
                                                                        #{IptPayVersion}.setValue('');
                                                                        #{IptDealerCode}.hide();
                                                                        #{IptDPCompFile}.hide();
                                                                        #{IptSatisfyYear}.hide();
                                                                        #{IptSatisfyQuarter}.hide();
                                                                    } else if (#{IptImportType}.getValue() == 'DPComp') {
                                                                        #{IptDealerCode}.show();
                                                                        #{IptDealerCode}.setValue('');
                                                                        #{IptDPCompFile}.show();
                                                                        #{IptDPCompFile}.setValue('');
                                                                        #{IptPayVersion}.hide();
                                                                        #{IptSatisfyYear}.hide();
                                                                        #{IptSatisfyQuarter}.hide();
                                                                    } else if (#{IptImportType}.getValue() == 'DPSatisfy') {
                                                                        #{IptSatisfyYear}.show();
                                                                        #{IptSatisfyQuarter}.show();
                                                                        #{IptDealerCode}.hide();
                                                                        #{IptDPCompFile}.hide();
                                                                        #{IptPayVersion}.hide();
                                                                    } else {
                                                                        #{IptPayVersion}.hide();
                                                                        #{IptDealerCode}.hide();
                                                                        #{IptDPCompFile}.hide();
                                                                        #{IptSatisfyYear}.hide();
                                                                        #{IptSatisfyQuarter}.hide();
                                                                    }
                                                                " />
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:FileUploadField ID="IptImportFile" runat="server" EmptyText="选择导入文件(Excel格式)"
                                                            FieldLabel="文件" ButtonText="" Icon="ImageAdd" Width="300" AllowBlank="false"
                                                            MsgTarget="Side">
                                                        </ext:FileUploadField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptPayVersion" runat="server" FieldLabel="账期" Width="200" Hidden="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptDealerCode" runat="server" FieldLabel="经销商编号" Width="200" Hidden="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:FileUploadField ID="IptDPCompFile" runat="server" EmptyText="选择合规调查报告文件" FieldLabel="文件"
                                                            ButtonText="" Icon="ImageAdd" Width="300" Hidden="true">
                                                        </ext:FileUploadField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptSatisfyYear" runat="server" FieldLabel="年份" Width="200" Hidden="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptSatisfyQuarter" runat="server" EmptyText="请选择季度…" Width="200"
                                                            Editable="false" TypeAhead="true" FieldLabel="季度" ListWidth="200" Resizable="true"
                                                            MsgTarget="Side" Hidden="true">
                                                            <Items>
                                                                <ext:ListItem Value="Q1" Text="Q1" />
                                                                <ext:ListItem Value="Q2" Text="Q2" />
                                                                <ext:ListItem Value="Q3" Text="Q3" />
                                                                <ext:ListItem Value="Q4" Text="Q4" />
                                                            </Items>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Listeners>
                                <ClientValidation Handler="#{BtnImportFile}.setDisabled(!valid);" />
                            </Listeners>
                            <Buttons>
                                <ext:Button ID="BtnImportFile" runat="server" Text="上传">
                                    <AjaxEvents>
                                        <Click OnEvent="BtnImportFileClick" Before="
                                            if (!#{FrmImport}.getForm().isValid()) { return false; }
                                            if (#{IptImportType}.getValue() == 'DPPay' && #{IptPayVersion}.getValue() == '') {
                                                Ext.Msg.show({ 
                                                    title   : '提示', 
                                                    msg     : '请填写账期！', 
                                                    minWidth: 200, 
                                                    modal   : true, 
                                                    icon    : Ext.Msg.ERROR, 
                                                    buttons : Ext.Msg.OK 
                                                });
                                                return false;
                                            } else if (#{IptImportType}.getValue() == 'DPSatisfy' && (#{IptSatisfyYear}.getValue() == '' || #{IptSatisfyQuarter}.getValue() == '')) {
                                                Ext.Msg.show({ 
                                                    title   : '提示', 
                                                    msg     : '请填写年份和季度！', 
                                                    minWidth: 200, 
                                                    modal   : true, 
                                                    icon    : Ext.Msg.ERROR, 
                                                    buttons : Ext.Msg.OK 
                                                });
                                                return false;
                                            } else if (#{IptImportType}.getValue() == 'DPComp' && #{IptDPCompFile}.getValue() == '') {
                                                Ext.Msg.show({ 
                                                    title   : '提示', 
                                                    msg     : '请选择合规调查报告文件！', 
                                                    minWidth: 200, 
                                                    modal   : true, 
                                                    icon    : Ext.Msg.ERROR, 
                                                    buttons : Ext.Msg.OK 
                                                });
                                                return false;
                                            } else if (#{IptImportType}.getValue() == 'DPComp' && #{IptDealerCode}.getValue() == '') {
                                                Ext.Msg.show({ 
                                                    title   : '提示', 
                                                    msg     : '请填写经销商编号！', 
                                                    minWidth: 200, 
                                                    modal   : true, 
                                                    icon    : Ext.Msg.ERROR, 
                                                    buttons : Ext.Msg.OK 
                                                });
                                                return false;
                                            } 
                                            Ext.Msg.wait('正在上传文件...', '文件上传');" Failure="Ext.Msg.show({ 
                                            title   : '上传失败', 
                                            msg     : '文件未被成功上传！', 
                                            minWidth: 200, 
                                            modal   : true, 
                                            icon    : Ext.Msg.ERROR, 
                                            buttons : Ext.Msg.OK 
                                            });" Success="#{PagImportList}.changePage(1);">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="BtnReset" runat="server" Text="清除">
                                    <Listeners>
                                        <Click Handler="#{IptImportType}.setValue('');#{IptImportFile}.setValue('');#{IptPayVersion}.setValue('');#{IptPayVersion}.hide();#{BtnImportFile}.setDisabled(true);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnDownloadTemplate" runat="server" Text="下载模板">
                                    <Listeners>
                                        <Click Handler="
                                            if (#{IptImportType}.getValue() == 'DPPay') {
                                                window.open('../../Upload/ExcelTemplate/DealerProfile/Template_DPPay.xlsx')
                                            } else if (#{IptImportType}.getValue() == 'DPAudit') {
                                                window.open('../../Upload/ExcelTemplate/DealerProfile/Template_DPAudit.xlsx')
                                            } else if (#{IptImportType}.getValue() == 'DPBaseComp') {
                                                window.open('../../Upload/ExcelTemplate/DealerProfile/Template_DPBaseComp.xlsx')
                                            } else if (#{IptImportType}.getValue() == 'DPDeepComp') {
                                                window.open('../../Upload/ExcelTemplate/DealerProfile/Template_DPDeepComp.xlsx')
                                            } else if (#{IptImportType}.getValue() == 'DPTrain') {
                                                window.open('../../Upload/ExcelTemplate/DealerProfile/Template_DPTrain.xlsx')
                                            } else if (#{IptImportType}.getValue() == 'DPPrize') {
                                                window.open('../../Upload/ExcelTemplate/DealerProfile/Template_DPPrize.xlsx')
                                            } else if (#{IptImportType}.getValue() == 'DPSatisfy') {
                                                Ext.Msg.show({ 
                                                    title   : '提示', 
                                                    msg     : '经销商满意度由第三方提供！', 
                                                    minWidth: 200, 
                                                    modal   : true, 
                                                    icon    : Ext.Msg.ERROR, 
                                                    buttons : Ext.Msg.OK 
                                                });
                                                return false;
                                            } else if (#{IptImportType}.getValue() == 'DPAuditChannel') {
                                                window.open('../../Upload/ExcelTemplate/DealerProfile/Template_DPAuditChannel.xlsx')
                                            } else if (#{IptImportType}.getValue() == 'DPComp') {
                                                Ext.Msg.show({ 
                                                    title   : '提示', 
                                                    msg     : '合规调查报告由第三方提供！', 
                                                    minWidth: 200, 
                                                    modal   : true, 
                                                    icon    : Ext.Msg.ERROR, 
                                                    buttons : Ext.Msg.OK 
                                                });
                                                return false;
                                            }
                                        " />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="RstImportList" runat="server" Title="出错信息" StoreID="StoImportList"
                                        Border="false" Icon="Error" AutoWidth="true" StripeRows="true" EnableHdMenu="false">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="SheetName" DataIndex="SheetName" Header="工作表" Hideable="true"
                                                    Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="LineNum" DataIndex="LineNum" Header="行号">
                                                </ext:Column>
                                                <ext:Column ColumnID="ErrorDesc" DataIndex="ErrorDesc" Header="错误信息" Width="800">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="false">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagImportList" runat="server" PageSize="10" StoreID="StoImportList"
                                                DisplayInfo="true">
                                            </ext:PagingToolbar>
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="处理中…" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </div>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
