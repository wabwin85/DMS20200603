<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EndoScoreCardAttachment.aspx.cs"
    Inherits="DMS.Website.Pages.ScoreCard.EndoScoreCardAttachment" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .editable-column
        {
            background: #FFFF99;
        }
        .nonEditable-column
        {
            background: #FFFFFF;
        } 
    </style>

    <script language="javascript">

        var rowCommand = function(command, record, row) {
            if (command == "Delete") {
                Coolite.AjaxMethods.Delete(
                    record.id,
                    {
                        success: function() {
                            editId = '';
                            Ext.getCmp('<%=this.gpFile.ClientID %>').deleteSelected();
                        },
                        failure: function(err) {
                            Ext.Msg.alert('Error', err);
                        }
                    }
                );
            }

        }  
     
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ChineseName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true">
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
    <ext:JsonStore ID="FileUploadStore" runat="server" UseIdConfirmation="false" OnRefreshData="FileUploadStore_RefershData"
        AutoLoad="true">
        <AutoLoadParams>
            <ext:Parameter Name="start" Value="={0}" />
            <ext:Parameter Name="limit" Value="={15}" />
        </AutoLoadParams>
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Attachment" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Url" />
                    <ext:RecordField Name="Type" />
                    <ext:RecordField Name="TypeName" />
                    <ext:RecordField Name="Remark" />
                    <ext:RecordField Name="UploadUser" />
                    <ext:RecordField Name="Identity_Name" />
                    <ext:RecordField Name="UploadDate" Type="Date" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Id" Direction="ASC" />
    </ext:JsonStore>
    <ext:Hidden ID="hiddenESCId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenDealerId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenProductLineId" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:Panel ID="Panel11" runat="server">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtDealerWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.FieldLabel %>"
                                                                ReadOnly="true" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtScoreCardNumberWin" Width="150" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout5.txtScoreCardNumberWin.FieldLabel %>"
                                                                ReadOnly="true" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtProductLineWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.FieldLabel %>"
                                                                ReadOnly="true" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtStatusWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtStatusWin.FieldLabel %>"
                                                                ReadOnly="true" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtYearWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtYearWin.FieldLabel %>"
                                                                ReadOnly="true" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtQuarterWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtQuarterWin.FieldLabel %>"
                                                                ReadOnly="true" />
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
                </North>
                <Center MarginsSummary="0 5 5 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="gpFile" runat="server" Title="<%$ Resources: gpFile.Title %>"
                                    StoreID="FileUploadStore" StripeRows="true" Collapsible="false" Border="false"
                                    Icon="Lorry"  Header="false">
                                    <ColumnModel ID="ColumnModel4" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="Id" DataIndex="Id" Width="100" Hidden="true">
                                            </ext:Column>
                                            <ext:Column ColumnID="TypeName" DataIndex="TypeName" Header="<%$ Resources: gpFile.FileType %>"
                                                Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources: gpFile.FileName %>"
                                                Width="250">
                                            </ext:Column>
                                            <ext:Column ColumnID="Remark" DataIndex="Remark" Header="<%$ Resources: gpFile.FileRemark %>"
                                                Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="<%$ Resources: gpFile.FileUploadUser %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="<%$ Resources: gpFile.FileUploadDate %>"
                                                Width="180">
                                                <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                            </ext:Column>
                                            <ext:CommandColumn Width="50" Header="<%$ Resources: gpFile.FileDownLoad %>" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                        <ToolTip Text="<%$ Resources: gpFile.FileDownLoad %>" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="FileUploadStore"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                      <Listeners>
                                        <Command Handler="if (command == 'DownLoad')
                                                                    {
                                                                        var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url);
                                                                        open(url, 'Download');
                                                                    }" />
                                    </Listeners>
                                    <LoadMask ShowMask="true" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
