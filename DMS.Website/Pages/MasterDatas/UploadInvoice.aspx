﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UploadInvoice.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.UploadInvoice" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title><%=GetLocalResourceObject("Head1.Title").ToString()%></title>
</head>
<body>

    <script type="text/javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });
        
        var MsgList = {
			SaveButton:{
				BeforeTitle:"<%=GetLocalResourceObject("SaveButton.Before.Ext.Msg.wait.Body").ToString()%>",
				BeforeMsg:"<%=GetLocalResourceObject("SaveButton.Before.Ext.Msg.wait.Title").ToString()%>",
				FailureTitle:"<%=GetLocalResourceObject("SaveButton.Failure.Ext.Msg.show.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("SaveButton.Failure.Ext.Msg.show.msg").ToString()%>"
			},
			ImportButton:{
				BeforeTitle:"<%=GetLocalResourceObject("ImportButton.Before.Ext.Msg.wait.Body").ToString()%>",
				BeforeMsg:"<%=GetLocalResourceObject("ImportButton.Before.Ext.Msg.wait.Title").ToString()%>"
			}
        }
    </script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Store ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="User" />
                        <ext:RecordField Name="UploadDate" />
                        <ext:RecordField Name="LineNbr" />
                        <ext:RecordField Name="FileName" />
                        <ext:RecordField Name="ErrorFlag" />
                        <ext:RecordField Name="ErrorDescription" />
                        <ext:RecordField Name="SapCode" />
                        <ext:RecordField Name="DmaChineseName" />
                        <ext:RecordField Name="InvoiceNo" />
                        <ext:RecordField Name="Carrier" />
                        <ext:RecordField Name="TrackingNo" />
                        <ext:RecordField Name="SendDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="LineNbr" Direction="ASC" />
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Title="<%$ Resources: BasicForm.Title %>"
                            AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                            <Defaults>
                                <ext:Parameter Name="anchor" Value="50%" Mode="Value" />
                                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                            </Defaults>
                            <Body>
                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="50">
                                    <ext:Anchor>
                                        <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="<%$ Resources: FileUploadField1.EmptyText %>"
                                            FieldLabel="<%$ Resources: FileUploadField1.FieldLabel %>" ButtonText="" Icon="ImageAdd">
                                        </ext:FileUploadField>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                            <Listeners>
                                <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                            </Listeners>
                            <Buttons>
                                <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: SaveButton.Text %>">
                                    <AjaxEvents>
                                        <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                                    Ext.Msg.wait(MsgList.SaveButton.BeforeTitle, MsgList.SaveButton.BeforeMsg);" Failure="Ext.Msg.show({ 
                                                    title   : MsgList.SaveButton.FailureTitle, 
                                                    msg     : MsgList.SaveButton.FailureMsg, 
                                                    minWidth: 200, 
                                                    modal   : true, 
                                                    icon    : Ext.Msg.ERROR, 
                                                    buttons : Ext.Msg.OK 
                                                });" Success="#{ImportButton}.setDisabled(false);#{SaveButton}.setDisabled(true);">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="ResetButton" runat="server" Text="<%$ Resources: ResetButton.Text %>">
                                    <Listeners>
                                        <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);#{ImportButton}.setDisabled(true);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="ImportButton" runat="server" Text="<%$ Resources: ImportButton.Text %>" Disabled="true">
                                    <AjaxEvents>
                                        <Click OnEvent="ImportClick" Before="Ext.Msg.wait(MsgList.ImportButton.BeforeTitle, MsgList.ImportButton.BeforeMsg);">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="DownloadButton" runat="server" Text="<%$ Resources: DownloadButton.Text %>">
                                    <Listeners>
                                        <Click Handler="window.open('../../Upload/ExcelTemplate/Template_SendInvoice.xls')" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel9" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="GridPanel3" runat="server" Title="<%$ Resources: GridPanel3.Title %>" StoreID="Store1" Border="false"
                                        Icon="Error" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="LineNbr" DataIndex="LineNbr" Header="<%$ Resources: GridPanel3.ColumnModel3.LineNbr.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="<%$ Resources: GridPanel3.ColumnModel3.SapCode.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="InvoiceNo" DataIndex="InvoiceNo" Header="<%$ Resources: GridPanel3.ColumnModel3.InvoiceNo.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Carrier" DataIndex="Carrier" Header="<%$ Resources: GridPanel3.ColumnModel3.Carrier.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="TrackingNo" DataIndex="TrackingNo" Header="<%$ Resources: GridPanel3.ColumnModel3.TrackingNo.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="SendDate" DataIndex="SendDate" Header="<%$ Resources: GridPanel3.ColumnModel3.SendDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ErrorDescription" DataIndex="ErrorDescription" Header="<%$ Resources: GridPanel3.ColumnModel3.ErrorDescription.Header %>"
                                                    Width="300">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                                DisplayInfo="true" EmptyMsg="No data to display" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel3.LoadMask.Msg %>" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Hidden ID="hidFileName" runat="server">
        </ext:Hidden>
    </div>
    </form>
</body>
</html>
