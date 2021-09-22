<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AOPImport.aspx.cs" Inherits="DMS.Website.Pages.Contract.AOPImport" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .yellow-row {
            background: #FFD700;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

        <script type="text/javascript">
            Ext.apply(Ext.util.Format, { number: function (v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function (format) { return function (v) { return Ext.util.Format.number(v, format); }; } });

            function getIsErrRowClass(record, index) {
                if (record.data.ISErr == 1) {
                    return 'yellow-row';
                }
            }
        </script>

        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Store ID="UpLoadHospitalAOPStore" runat="server" OnRefreshData="UpLoadHospitalAOPStore_RefreshData"
            UseIdConfirmation="true" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="HospitalCode" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="ProductName" />
                        <ext:RecordField Name="ProductCode" />
                        <ext:RecordField Name="Year" />
                        <ext:RecordField Name="ErrMsg" />
                        <ext:RecordField Name="ISErr" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:FormPanel ID="BasicFormDealer" runat="server" Frame="true" Header="false" MonitorValid="true"
                            BodyBorder="false" BodyStyle="padding: 10px 10px 0 10px;" Height="100">
                            <Defaults>
                                <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                            </Defaults>
                            <Body>
                                <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="50">
                                    <ext:Anchor>
                                        <ext:FileUploadField ID="FileUploadFieldDealer" runat="server" EmptyText="" FieldLabel="文件"
                                            Width="500" ButtonText="" Icon="ImageAdd">
                                        </ext:FileUploadField>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                            <Listeners>
                                <ClientValidation Handler="#{SaveButtonDealer}.setDisabled(!valid);" />
                            </Listeners>
                            <Buttons>
                                <ext:Button ID="SaveButtonDealer" runat="server" Text="上传医院指标">
                                    <AjaxEvents>
                                        <Click OnEvent="UploadHospitalAOPClick" Before="if(!#{BasicFormDealer}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传医院指标...', '医院指标上传');"
                                            Success="#{PagingToolBarUpload}.changePage(1);#{FileUploadFieldDealer}.setValue(''); Ext.Msg.show({ 
                                        title   : '成功', 
                                        msg     : '上传成功', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        buttons : Ext.Msg.OK 
                                    })">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="ResetButton" runat="server" Text="清除">
                                    <Listeners>
                                        <Click Handler="#{BasicFormDealer}.getForm().reset();#{SaveButtonDealer}.setDisabled(true);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridUploadHospitalAOP" runat="server" StoreID="UpLoadHospitalAOPStore"
                                        Border="false" Title="指定经销商" Icon="Lorry" StripeRows="true" AutoScroll="true">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="HospitalCode" DataIndex="HospitalCode" Align="Left" Header="医院编码"
                                                    Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Align="Left" Header="医院名称"
                                                    Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductName" DataIndex="ProductName" Align="Left" Header="产品名称"
                                                    Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="Year" DataIndex="Year" Align="Left" Header="年份" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="ErrMsg" DataIndex="ErrMsg" Align="Left" Header="错误信息" Width="200">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <View>
                                            <ext:GridView ID="GridView1" runat="server">
                                                <GetRowClass Fn="getIsErrRowClass" />
                                            </ext:GridView>
                                        </View>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBarUpload" runat="server" PageSize="20" StoreID="UpLoadHospitalAOPStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" />
                                        <Buttons>
                                            <ext:Button ID="ButtonUploadHospitalAopSubmint" runat="server" Text="提交" Icon="LorryAdd"
                                                Hidden="true">
                                                <Listeners>
                                                    <Click Handler="Coolite.AjaxMethods.UploadHospitalAOPSubmint({ success: function() {window.parent.closeAndReloadUploadWindow();
                                    reloadHospitalFlag=true; reloadProductFlag=true;},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="Button3" runat="server" Text="关闭" Icon="LorryStop">
                                                <Listeners>
                                                    <Click Handler="window.parent.closeUploadWindow();" />
                                                </Listeners>
                                            </ext:Button>
                                        </Buttons>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Hidden ID="hidContractId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidLastContractId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDealerId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidProductLineId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidSubBuCode" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsEmerging" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidYearString" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidBeginDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidEndDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPageType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidContractType" runat="server">
        </ext:Hidden>
    </form>
</body>
</html>
