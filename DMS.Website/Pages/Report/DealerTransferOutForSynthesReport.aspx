<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerTransferOutForSynthesReport.aspx.cs" Inherits="DMS.Website.Pages.Report.DealerTransferOutForSynthesReport" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
    
    <style type="text/css">
        .list-item
        {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
            padding: 3px 10px 3px 10px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #555;
        }
        .list-item h3
        {
            display: block;
            font: inherit;
            font-weight: bold;
            color: #222;
        }
    </style>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
    <script src="../../resources/Date.js" type="text/javascript"></script>
    

    
</head>
<body>
    <form id="form1" runat="server">
    

       <ext:ScriptManager ID="ScriptManager1" runat="server" />

<script type="text/javascript">

     function CheckCondition()
     {
     
        var StartDate = <%=txtStartDate.ClientID%>.getValue();
        if (StartDate == "")
        {
            alert('<%=GetLocalResourceObject("CheckCondition.StartDate.Alert").ToString()%>');
            return false;
        }
        
        var EndDate = <%=txtEndDate.ClientID%>.getValue();
        if (EndDate == "")
        {
            alert('<%=GetLocalResourceObject("CheckCondition.EndDate.Alert").ToString()%>');
            return false;
        }
        
       
        if (StartDate > EndDate)
        {
            alert('<%=GetLocalResourceObject("CheckCondition.Earlier.Alert").ToString()%>');
            return false;
        }
        
        var r = StartDate.DateAdd("m", 3);
        if(r <= EndDate)
        {
            alert('<%=GetLocalResourceObject("CheckCondition.Range.Alert").ToString()%>');
            return false;
        }
        
        
        
        return true;
     }
    
</script>

    <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine" AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
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
    
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel2" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbProductLine" runat="server" 
                                                    EmptyText="<%$ Resources: Panel1.FormLayout3.cbProductLine.EmptyText %>" 
                                                    Width="150" 
                                                    Editable="false"
                                                    TypeAhead="true" 
                                                    StoreID="ProductLineStore" 
                                                    ValueField="Id" 
                                                    DisplayField="AttributeName"
                                                    FieldLabel="<%$ Resources: Panel1.FormLayout3.cbProductLine.FieldLabel %>"                                                    
                                                    >
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout3.cbProductLine.FieldTrigger.Qtip %>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtStartDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout1.txtStartDate.FieldLabel %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtEndDate.FieldLabel %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: Panel1.btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy" AutoPostBack="true" OnClientClick="var result = CheckCondition(); if (!result) return false;">
                               <AjaxEvents>
                                    <Click OnEvent="btnSearch_Click"></Click>
                               </AjaxEvents>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    
                    <ext:Panel ID="Panel12" runat="server" Height="300" Header="false">
                        <Body>
                                    <rsweb:ReportViewer ID="ReportViewer1" runat="server"  ProcessingMode="Remote" >
                                    </rsweb:ReportViewer>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
        
    </ext:ViewPort>




    </form>
</body>
</html>
