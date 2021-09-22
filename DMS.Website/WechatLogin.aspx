<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WechatLogin.aspx.cs" Inherits="DMS.Website.WechatLogin" %>

<%@ Register Assembly="Grapecity.Web.Controls" Namespace="Grapecity.Web.Controls"
    TagPrefix="grape" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <title>DMS系统登录</title>
    <meta name="HandheldFriendly" content="True" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=yes" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="format-detection" content="telephone=no" />
    <meta http-equiv="cleartype" content="on" />

    <script type="text/javascript" src="resources/login/common.js"></script>

    <script type="text/javascript" src="resources/login/jquery.min.js"></script>

    <script type="text/javascript">
        function resizeTitle() {

            var docWidth = document.body.clientWidth;
            $('#bg').width(docWidth);
            if (docWidth > 800) {
                $('#bg').height(100);
            } else {
                $('#bg').height('auto');
            }
        }

        $(function() {
            resizeTitle();

            $(window).resize(function() {
                resizeTitle();
            });
        })
    </script>

    <style type="text/css">
        body, td, th
        {
            font-family: verdana, Arial, Helvetica, "微软雅黑" , "宋体";
            font-size: 15px;
            color: #666666;
            padding: 0px;
            margin: 0px;
        }
        .red
        {
            color: #AB4540;
        }
        .login
        {
            height: 28px;
            width: 96px;
            color: #FFFFFF;
            font-weight: bold;
            text-align: center;
            line-height: 28px;
            display: block;
            background-position: center -28px;
            background-repeat: repeat-y;
            text-decoration: none;
        }
        .STYLE9
        {
            color: Red;
        }
        .bgcorol
        {
            background-color: #0070C0;
        }
        .STYLE3
        {
            color: Red;
        }
        .text
        {
            position: relative;
            border: 1px solid #ccc;
            margin-top: 5px;
            margin-bottom: 5px;
            float: left !important;
            border-radius: 5px;
            font-family: "微软雅黑" ,Arial, "Hiragino Sans GB" , "Microsoft YaHei" , "STHeiti" , "WenQuanYi Micro Hei" ,SimSun,sans-serif !important;
            font-size: 15px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" defaultbutton="btnLogin">
    <div id="wrap" class="container">
        <div style="border-bottom: 0px solid transparent; margin: 0px; padding: 0px; display: block;">
            <table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-collapse: collapse;">
                <tbody>
                    <tr>
                        <td id="bgtd">
                            <img src="<%=ResolveUrl("~/resources/images/banner0910.png")%>" border="0" id="bg"
                                style="display: block; text-align: center; width: 100%;" alt="" />
                        </td>
                    </tr>
                </tbody>
            </table>
            <div style="height: 10px; width: 100%;">
            </div>
        </div>
    </div>
    <asp:ScriptManager ID="ScriptManager1" AllowCustomErrorsRedirect="true" runat="server">
    </asp:ScriptManager>
    <div>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr style="height: 70px;">
                <td style="text-align: center; font-weight: bold; font-size: x-large; color: #0070C0;">
                    蓝威渠道数据管理系统
                    <div style="margin-top: 3px; text-align: center; font-weight: bold; font-size: 18px;
                        color: #0070C0;">
                        Distributor Management System
                    </div>
                </td>
            </tr>
            <tr>
                <td align="left" valign="top">
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="width: 40%; padding-left: 25px; color: #000000">
                                经销商DMS账号:
                            </td>
                            <td>
                                <input id="txtUserName" class="text" name="txtUserName" runat="server" style="width: 60%;">
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 25px; color: #000000">
                                密码:
                            </td>
                            <td>
                                <input id="txtPassword" class="text" type="password" name="txtPassword" runat="server"
                                    style="width: 60%;" />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 25px; color: #000000">
                                验证码:
                            </td>
                            <td>
                                <asp:TextBox ID="snvTxt1" runat="server" CssClass="text" Width="120px" autocomplete="off"
                                    Style="width: 60%;"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td onclick="document.getElementById('btnSerial').click();">
                                <asp:UpdatePanel ID="upSerial" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <grape:SerialNumber ID="SerialNumber1" runat="server" />
                                        <asp:Button ID="btnSerial" runat="server" OnClick="btnSerial_OnClick" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <span style="display: none; text-align: left;" id="spanUserName" class="STYLE3">(登录帐号不能为空)</span><br />
                                <span style="display: none; text-align: left;" id="spanPassword" class="STYLE3">(密码不能为空)</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <div class="STYLE9" align="left">
                                    <asp:Literal ID="ltLoginInfo" runat="server"></asp:Literal>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <div style="width: 80%; margin-left: 0px; float: left">
                                    <asp:Button ID="btnLogin" runat="server" Text="登录" BorderWidth="0" CssClass="login bgcorol"
                                        OnClientClick="return CheckLogin();" OnClick="btnLogin_Click" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="con" style="padding-left: 25px; font-size: 13px; font-family: 微软雅黑; color: #000000">
                        &nbsp;<br />
                        &nbsp;<br />
                        DMS支持热线:4006309930 &nbsp;</br> DMS支持邮箱:2976286693@qq.com &nbsp;</br> &nbsp;</br>
                        &nbsp;</br> Boston Scientific China
                    </div>
                    <p>
                        &nbsp;</p>
                </td>
            </tr>
        </table>

        <script language="javascript">
            window.load = function() {
                document.getElementById('txtPassword').value = '';
            };
        </script>

        <script language="javascript" type="text/javascript">
            function CheckLogin() {
                var UserName = document.getElementById('txtUserName');
                if (UserName.value == "") {
                    document.getElementById('spanUserName').style.display = 'block';
                    UserName.focus();
                    return false;
                }
                else {
                    document.getElementById('spanUserName').style.display = 'none';
                }
                var Password = document.getElementById('txtPassword');
                if (Password.value == "") {
                    document.getElementById('spanPassword').style.display = 'block';
                    Password.focus();
                    return false;
                }
                else {
                    document.getElementById('spanPassword').style.display = 'none';
                }
                return true;
            }
        </script>

    </div>
    </form>
</body>
</html>
