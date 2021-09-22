<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HosSales.aspx.cs" Inherits="DMS.Website.HosSales" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta name="viewport" content="height=device-height,width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no" />
    <title>医院销量明细</title>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Debug">
        </ext:ScriptManager>
        <span id="spSales" runat="server"></span>
        <asp:HiddenField ID="hfBarch" runat="server" />
        <table>
        <tr>
        <td style="width:20%; font-size:small;" >
        </td>
        </tr>
        </table>
    </div>
    </form>
</body>
</html>