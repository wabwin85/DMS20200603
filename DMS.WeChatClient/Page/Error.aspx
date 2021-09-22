<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="DMS.WeChatClient.Page.Error" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0, maximum-scale=1" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="page_msg">
            <div class="inner">
                <span class="msg_icon_wrp"><i class="icon80_smile"></i></span>
                <div class="msg_content">
                    <h4>
                        <asp:Label runat="server" ID="lblInfo"></asp:Label></h4>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<style type="text/css">
    body {
        line-height: 1.6;
        font-family: "Helvetica Neue",Helvetica, "Microsoft YaHei",Arial,Tahoma,sans-serif;
    }

    body, h1, h2, h3, h4 {
        margin: 0;
    }

    a img {
        border: 0;
    }

    body {
        background-color: #e1e0de;
    }

    .icon {
        display: inline-block;
        vertical-align: middle;
    }

    .icon80_smile {
        width:100px;
        height: 100px;
        display: inline-block;
        vertical-align: middle;
        background: transparent url(../Resource/images/iconError.png) no-repeat 0 0;
    }

    .page_msg {
        padding-left: 23px;
        padding-right: 23px;
        font-size: 16px;
        text-align: center;
    }

        .page_msg .inner {
            padding-top: 40px;
            padding-bottom: 40px;
        }

        .page_msg .msg_icon_wrp {
            display: block;
            padding-bottom: 22px;
        }

        .page_msg .msg_content h4 {
            font-weight: 400;
            color: #000000;
        }

        .page_msg .msg_content p {
            color: #90908E;
        }

    @media all and (-webkit-min-device-pixel-ratio: 2) {
        .icon80_smile {
            background-image: url(../Resource/images/iconError.png);
            background-size: 100px;
            -webkit-background-size: 100px;
        }
    }
</style>
