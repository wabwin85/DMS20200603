<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerPriceInit.aspx.cs"
    Inherits="DMS.Website.Pages.Order.DealerPriceInit" ValidateRequest="false" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/DealerPriceDetailWindow.ascx" TagName="DealerPriceDetailWindow"
    TagPrefix="uc" %>
<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />

    <script type="text/javascript" language="javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });
        //刷新父窗口查询结果
        function RefreshMainPage() {
            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
        }

        var DealerPriceMsgList = {
            msg1: '<%=GetLocalResourceObject("loadExample.subMenu230").ToString()%>'
        }
    </script>

    <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="DPH_ID">
                <Fields>
                    <ext:RecordField Name="DPH_ID" />
                    <ext:RecordField Name="DPH_Remark" />
                    <ext:RecordField Name="DPH_USER" />
                    <ext:RecordField Name="DPH_LP" />
                    <ext:RecordField Name="DPH_NBR" />                    
                    <ext:RecordField Name="DPH_UploadDate" Type="Date" />
                    <ext:RecordField Name="DPH_STATUS" />    
                    
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hidInitDealerId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidHeaderId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidRtnVal" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidNewOrderInstanceId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidRtnMsg" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidCorpType" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true"
                        BodyStyle="padding: 5px;" Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".25">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtSubmitDateStart" runat="server" Width="150" FieldLabel="<%$ Resources: txtSubmitDateStart.FieldLabel %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".25">
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtSubmitDateEnd" runat="server" Width="150" FieldLabel="<%$ Resources: txtSubmitDateEnd.FieldLabel %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".25">
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtCfn" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".25">
                                    <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtUploadNbr" runat="server" Width="150" FieldLabel="<%$ Resources: txtUploadNbr.FieldLabel  %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text %>" runat="server"
                                Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                    <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnImport" runat="server" Text="<%$ Resources: btnImport.Text %>"
                                Icon="Disk" IDMode="Legacy">
                                <Listeners>
                                    <%--<Click Handler="window.parent.loadExample('/Pages/Order/DealerPriceImport.aspx','subMenu230',DealerPriceMsgList.msg1);" />--%>
                                    <Click Handler="top.createTab({id: 'subMenu230',title: '导入',url: 'Pages/Order/DealerPriceImport.aspx'});" />

                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 5 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                    StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true"
                                    AutoExpandColumn="DPH_Remark">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="DPH_NBR" Width="150" Align="Center" DataIndex="DPH_NBR"
                                                Header="<%$ Resources: GridPanel1.ColumnModel1.UploadNbr.Header %>">                                                
                                            </ext:Column>
                                            <ext:Column ColumnID="DPH_UploadDate" Width="150" Align="Center" DataIndex="DPH_UploadDate"
                                                Header="<%$ Resources: GridPanel1.ColumnModel1.UploadDate.Header %>">
                                                <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                            </ext:Column>
                                            <ext:Column ColumnID="DPH_USER" DataIndex="DPH_USER" Align="Center" Header="<%$ Resources: GridPanel1.ColumnModel1.User.Header %>"
                                                Width="150">
                                            </ext:Column>
                                             <ext:Column ColumnID="DPH_LP" DataIndex="DPH_LP" Align="Center" Header="<%$ Resources: GridPanel1.ColumnModel1.LP.Header %>"
                                                Width="180">
                                            </ext:Column>
                                            <ext:Column ColumnID="DPH_Remark" DataIndex="DPH_Remark" Header="<%$ Resources: GridPanel1.ColumnModel1.Remark.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="DPH_STATUS" DataIndex="DPH_STATUS" Header="更新状态">
                                            </ext:Column>
                                            <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>"
                                                Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>" />
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
                                        <Command Handler="Coolite.AjaxMethods.DealerPriceDetailWindow.Show(record.data.DPH_ID,{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="ResultStore"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <uc:DealerPriceDetailWindow ID="DealerPriceDetailWindow" runat="server" />
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
