<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PromotionView.aspx.cs" Inherits="DMS.Website.Pages.Promotion.PromotionView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Promotion View</title>
    <style type="text/css">
        html,
        body {
            margin: 0;
        }
    </style>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/kendo-2017.2.504/js/jquery.min.js") %>"></script>
    <script type="text/javascript">
        var initLayout = function () {
            $('#div2').height($(window).height());
        }

        $(document).ready(function () {
            if (top != self) {
                initLayout();
                $(window).resize(function () {
                    initLayout();
                })
            }
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="div2" style="width: 100%; overflow-y: auto;">
            <div id="div1" runat="server" style="padding:10px;">
            </div>
        </div>
    </form>
</body>
</html>
