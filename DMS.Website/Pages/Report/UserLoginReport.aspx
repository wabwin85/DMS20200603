<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserLoginReport.aspx.cs" Inherits="DMS.Website.Pages.Report.UserLoginReport" %>

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
     <div>
    
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <Center MarginsSummary="0 5 0 5">
                    
                    <ext:Panel ID="Panel12" runat="server" Height="300" Header="false">
                        <Body>
                                    <rsweb:ReportViewer ID="ReportViewer1" runat="server"  ProcessingMode="Remote" >
                                    </rsweb:ReportViewer>
                                    <script language="javascript" type="text/javascript">
//                                        ResizeReport();
//                                        function ResizeReport() {
//                                            var viewer = document.getElementById("<%= ReportViewer1.ClientID %>");
//                                            var htmlheight = document.documentElement.clientHeight;
//                                            viewer.style.height = (htmlheight - 30) + "px";
//                                        }
//                                        window.onresize = function resize() { ResizeReport(); }
                                    </script>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
        
    </ext:ViewPort>
    </div>
    </form>
</body>
</html>

