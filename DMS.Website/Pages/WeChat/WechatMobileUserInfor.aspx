<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WechatMobileUserInfor.aspx.cs"
    Inherits="DMS.Website.Pages.WeChat.WechatMobileUserInfor" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <title>微信登陆人员维护</title>
    <meta name="HandheldFriendly" content="True" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=yes" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="format-detection" content="telephone=no" />
    <meta http-equiv="cleartype" content="on" />

    <script type="text/javascript" src="../../resources/login/common.js"></script>

    <script type="text/javascript" src="../../resources/login/jquery.min.js"></script>

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
        .bgcorol
        {
            background-color: #0070C0;
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
            width: 70%;
        }
        .dll
        {
            position: relative;
            border: 1px solid #ccc;
            margin-top: 5px;
            margin-bottom: 5px;
            float: left !important;
            border-radius: 5px;
            font-family: "微软雅黑" ,Arial, "Hiragino Sans GB" , "Microsoft YaHei" , "STHeiti" , "WenQuanYi Micro Hei" ,SimSun,sans-serif !important;
            font-size: 15px;
            width: 70%;
        }
        .STYLE9
        {
            color: Red;
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
                <td style="text-align: center; font-weight: bold; font-size: 18px; color: #0070C0;">
                    【蓝威服务入微】微信账号注册
                </td>
                <td>
                    <asp:HiddenField ID="hfDealerId" runat="server" />
                    <asp:HiddenField ID="hfDealerType" runat="server" />
                </td>
            </tr>
            <tr>
                <td align="left" valign="top">
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td colspan="2" style="text-align: center; color: #000000; font-size: 18px;">
                                <asp:Label ID="lbDealerName" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr style="height: 10px;">
                            <td colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 20px; font-size: 10px; font-weight: bold; color: #000000;
                                font-family: 微软雅黑; width: 40px;">
                                第一步:
                            </td>
                            <td style="font-size: 10px; font-weight: bold; color: #000000; font-family: 微软雅黑;
                                float: left;">
                                输入信息后点击"获取邀请码"
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 20px; font-size: 10px; font-weight: bold; color: #000000;
                                font-family: 微软雅黑;">
                                第二步:
                            </td>
                            <td style="font-size: 10px; font-weight: bold; color: #000000; font-family: 微软雅黑;">
                                收到邀请码
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 20px; font-size: 10px; font-weight: bold; color: #000000;
                                font-family: 微软雅黑; vertical-align: top;">
                                第三步:
                            </td>
                            <td style="font-size: 10px; font-weight: bold; color: #000000; font-family: 微软雅黑;">
                                输入手机号与邀请码绑定</br> <span>列如:手机号(空格)邀请码</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 20px; font-size: 10px; font-weight: bold; font-weight: bold;
                                color: #000000; font-family: 微软雅黑; vertical-align: top;">
                                第四步:
                            </td>
                            <td style="font-size: 10px; font-weight: bold; color: #000000; font-family: 微软雅黑;">
                                成功绑定。</br>
                            </td>
                        </tr>
                        <tr>
                            <td style="font-size: 10px; font-weight: bold; color: #000000; font-family: 微软雅黑;
                                padding-left: 20px;" colspan="2">
                                通过【服务入微】开启移动办公的专属服务
                            </td>
                        </tr>
                        <tr style="height: 15px;">
                            <td colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 20px; color: #000000; font-family: 微软雅黑;">
                                姓名:
                            </td>
                            <td>
                                <asp:TextBox ID="tfTextName" runat="server" CssClass="text"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 20px; color: #000000; font-family: 微软雅黑;">
                                手机号:
                            </td>
                            <td>
                                <asp:TextBox ID="nfTextPhone" runat="server" CssClass="text" MaxLength="11"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 20px; color: #000000; font-family: 微软雅黑;">
                                职位:
                            </td>
                            <td>
                                <asp:DropDownList ID="cbTextPosition" runat="server" DataTextField="PositName" DataValueField="PositKey"
                                    CssClass="dll">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 20px; color: #000000; font-family: 微软雅黑;">
                                性别:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlGender" runat="server" CssClass="dll">
                                    <asp:ListItem Text="男" Value="radioSexB" Selected="True"> </asp:ListItem>
                                    <asp:ListItem Text="女" Value="radioSexG"> </asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 20px; color: #000000; font-family: 微软雅黑;">
                                邮箱:
                            </td>
                            <td>
                                <asp:TextBox ID="tfTextMail" runat="server" CssClass="text"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 20px;">
                            </td>
                            <td>
                                <div class="STYLE9" align="left">
                                    <asp:Literal ID="ltMassage" runat="server"></asp:Literal>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="height: 10px;">
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <div style="width: 80%; margin-left: 40px; maring: 0 auto;">
                                    <asp:Button ID="btnLogin" runat="server" Text="获取邀请码" BorderWidth="0" CssClass="login bgcorol"
                                        OnClick="btnSubmintUser_Click" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
