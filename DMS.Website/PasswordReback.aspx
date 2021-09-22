<%@ Page Language="C#" AutoEventWireup="true" Inherits="DMS.Website.PasswordReback"
    CodeBehind="PasswordReback.aspx.cs" %>

<%@ Register Assembly="Grapecity.Web.Controls" Namespace="Grapecity.Web.Controls"
    TagPrefix="grape" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <title>蓝威医疗经销商管理系统</title>
    <ext:ScriptContainer ID="ScriptContainer1" runat="server" />
    <link href="../../resources/css/style.css" rel="stylesheet" />
    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript" src="../../resources/login/common.js"></script>


    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

</head>
<body>
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <form id="form" name="form" runat="server">
        <div>
            <%--        <p>
            &nbsp;
        </p>--%>
            <div id="divLoadingMask" style="display: none">
            </div>
            <div id="divExtend">
                <div id="PwRebackMain">
                    <div class="top wrap">
                        <div class="subwrap">
                            <div class="content"  style="display:none;">
                                支持电话：4006-352-588<br />
                                支持邮箱：<a href="mailto:support@ocd-dms.com">support@ocd-dms.com</a>
                            </div>
                        </div>
                    </div>
                    <div id="denglu">
                        <table border="0" cellspacing="0" cellpadding="0" align="center">
                            <tbody>
                                <tr>
                                    <td valign="top">
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tbody>
                                                <tr>
                                                    <td height="15">&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="111" valign="top" align="center">
                                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                            <tbody>
                                                                <tr>

                                                                    <td class="EditTitle" style="background: url('../../resources/images/admin_2.png'); background-repeat: no-repeat; background-position: right;"></td>
                                                                    <td align="left" colspan="2" valign="middle" style="padding-top: 5px; padding-bottom: 5px;">
                                                                        <input style="height: 37px; width: 235px;" id="txtUserName" class="EditText" name="txtUserName"
                                                                            placeholder="登录帐号" runat="server" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="EditTitle" align="right" style="background: url('../../resources/images/email_2.png'); background-repeat: no-repeat; background-position: right;"></td>
                                                                    <td colspan="2" style="padding-top: 5px; padding-bottom: 5px;">
                                                                        <input style="height: 37px; width: 235px;" id="txtEmail" placeholder="备案邮箱" class="EditText"
                                                                            runat="server" />
                                                                    </td>
                                                                </tr>
                                                                <tr style="display:none;">
                                                                    <td colspan="3" align="right" valign="middle" style="height: 25px">
                                                                        <a class="red2" style="text-decoration: none; vertical-align: top;" onmouseover=""
                                                                            onclick="forgetemail();">忘记邮箱?</a>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="EditTitle" style="background: url('resources/images/yanzheng_2.png'); background-repeat: no-repeat; background-position: right;"></td>
                                                                    <td align="left">
                                                                        <asp:TextBox ID="snvTxt1" Style="height: 37px; width: 90px;" runat="server" CssClass="EditText"
                                                                            placeholder="验证码" autocomplete="off"></asp:TextBox>
                                                                    </td>
                                                                    <td align="right" valign="middle" style="width: 115px;">
                                                                        <grape:SerialNumber ID="SerialNumber1" runat="server" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td height="10" valign="middle" colspan="3" align="center">
                                                                        <div class="red2" align="center">
                                                                            <label id="lblmsg" runat="server" style="display: none; text-align: center">
                                                                            </label>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="center" colspan="3" style="height: 80px" valign="middle">
                                                                        <asp:Button ID="btnSubmit" runat="server" class="btnSubmit" OnClientClick="return CheckLogin();"
                                                                            OnClick="btnSubmit_Click" />
                                                                    </td>
                                                                </tr>
                                                                <tr style="display: none">
                                                                    <td>
                                                                        <asp:HiddenField ID="hidname" runat="server" />
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div id="divForgetPassword" class="divMsg" style="display: none;">
                        <p style="height: 52px; padding-top: 0px;">
                            &nbsp;
                        </p>
                        <p style="height: 72px; padding-top: 0px; font-style: normal; font-family: @方正兰亭黑; font-size: 27pt; vertical-align: top; color: #004a8a;">
                            忘记备案邮箱如何处理？
                        </p>
                        <br />
                        <p style="height: 20px; font-family: @方正兰亭黑; font-size: 13pt; color: #676767;">
                            请发送邮件至：support@ocd-dms.com<br />
                            或拨打热线电话：4006-352-588
                        </p>
                        <br />
                        <p style="height: 20px; font-family: @方正兰亭黑; font-size: 13pt; color: #676767;">
                            要求：需要提供证明，证明当前用户是此经销商用户或者是蓝威用户
                        </p>
                        <br />
                        <p style="text-align: right; margin-right: 50px;">
                            <input type="button" style="width: 111px; height: 45px; border: 0px; cursor: pointer; background: url('../../resources/images/btn_4.png'); background-repeat: no-repeat; background-position: right; vertical-align: middle;"
                                onclick="document.getElementById('divForgetPassword').style.display = 'none'; document.getElementById('divLoadingMask').style.display = 'none';" />
                        </p>
                    </div>
                    <div id="foot" style="height: 30px; vertical-align: middle;">
                        <div>
                            <div class="bottom" style="float: left; color: #DF6F53;">
                                <%--请注意：系统每天0点-6点（北京时间）网站停止，进行维护--%>
                            </div>
                            <div class="bottom" style="float: right;">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script language="javascript" type="text/javascript">
                function forgetemail() {
                    document.getElementById('divForgetPassword').style.left = (document.documentElement.clientWidth - 650) / 2 + 'px';     //将div居中，650为div的width
                    document.getElementById('divForgetPassword').style.display = 'inline';
                    document.getElementById('divLoadingMask').style.display = 'block';
                }

                function CheckLogin() {
                    var UserName = document.getElementById('txtUserName');
                    if (UserName.value == "") {
                        UserName.focus();
                        document.getElementById('lblmsg').innerHTML = "请先输入您的登录账号";
                        document.getElementById('lblmsg').style.display = "block";

                        return false;
                    }
                    else {
                        document.getElementById('lblmsg').style.display = "none";
                    }
                    var Password = document.getElementById('txtEmail');
                    if (Password.value == "") {
                        Password.focus();

                        document.getElementById('lblmsg').innerHTML = "请先输入您的备案邮箱";
                        document.getElementById('lblmsg').style.display = "block";

                        return false;
                    }
                    else {
                        document.getElementById('lblmsg').style.display = "none";
                    }
                    return true;
                }

                function OpenDownLoadWindow() {
                    var filepath = "resources\\login\\AuthCertificate.pdf";
                    if (filepath == "" || filepath == null) {
                        Ext.Msg.alert('Error', '下载失败');
                    }
                    else {
                        url = "../Download.aspx?filepath=" + filepath;
                        open(url, "Download");
                    }
                }
            </script>
        </div>
    </form>
</body>
</html>
