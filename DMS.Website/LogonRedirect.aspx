<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogonRedirect.aspx.cs" Inherits="DMS.Website.LogonRedirect" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/jquery.min.js") %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            window.location = 'Logon.aspx?' + location.href.substring(location.href.indexOf('#') + 1)
        })
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
