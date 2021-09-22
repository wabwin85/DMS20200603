<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TerritoryForSynthesReport.aspx.cs" Inherits="DMS.Website.Pages.Report.TerritoryForSynthesReport" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
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
</head>
<body>
   <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />


    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true" >
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="Find">
                  
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy"
                                AutoPostBack="true">
                                <AjaxEvents>
                                    <Click OnEvent="btnSearch_Click">
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel12" runat="server"  Height="300" Header="false">
                        <Body>
                            <rsweb:ReportViewer ID="ReportViewer1" runat="server" ProcessingMode="Remote">
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
