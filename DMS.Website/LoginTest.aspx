<%@ Page Language="C#" AutoEventWireup="true" Inherits="DMS.Website.LoginTest" CodeBehind="LoginTest.aspx.cs" %>

<%@ Register Assembly="Grapecity.Web.Controls" Namespace="Grapecity.Web.Controls"
    TagPrefix="grape" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <title><%=GetLocalResourceObject("Title").ToString()%></title>
    <link rel="stylesheet" type="text/css" href="resources/login/style.css">

    <script type="text/javascript" src="resources/login/common.js"></script>

    <style type="text/css">
        .STYLE9
        {
            color:  Red;
        }
        .STYLE10
        {
            font-family: "????";
            font-size: 14px;
            font-weight: bold;
        }
        .STYLE12
        {
            color: #006DAD;
            font-size: 11px;
        }
        .STYLE13
        {
            color: #999999;
        }
        .box
        {
            font-size: 12px;
            margin: 0px auto;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;</p>
        <table border="0" cellspacing="0" cellpadding="0" width="484" align="center" height="450">
            <tbody>
                <tr>
                    <td valign="top" background="resources/login/Login.jpg" align="left">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tbody>
                                <tr>
                                    <td height="186">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td height="111" valign="top" align="middle">
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tbody>
                                                <tr>
                                                    <td class="smallblack" height="30" valign="center" width="39%" align="right">
                                                        <%=GetLocalResourceObject("form1.table.tr.td").ToString()%>&nbsp;
                                                    </td>
                                                    <td width="25%">
                                                        <input style="width: 120px" id="txtUserName" class="EditText" name="txtUserName"
                                                            runat="server">
                                                    </td>
                                                    <td width="36%" align="left">
                                                        <span style="display: none" id="spanUserName" class="STYLE3">&nbsp;<%=GetLocalResourceObject("form1.table.tr.td1").ToString()%></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="smallblack" valign="center" align="right">
                                                        <%=GetLocalResourceObject("form1.table.tr.td2").ToString()%>&nbsp;
                                                    </td>
                                                    <td>
                                                        <input style="width: 120px" id="txtPassword" class="EditText" type="password" name="txtPassword"
                                                            runat="server">
                                                    </td>
                                                    <td align="left">
                                                        <span style="display: none" id="spanPassword" class="STYLE3">&nbsp;<%=GetLocalResourceObject("form1.table.tr.td3").ToString()%></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;</br>&nbsp;
                                                    </td>
                                                </tr>
                                                <tr hidden = "true">
                                                    <td class="smallblack" valign="center" align="right">
                                                        <%=GetLocalResourceObject("form1.table.tr.td4").ToString()%>&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="snvTxt1" runat="server" CssClass="EditText" Width="120px" autocomplete="off" ></asp:TextBox>
                                                    </td>
                                                    <td align="left" hidden = "True">
                                                        &nbsp;&nbsp;<grape:SerialNumber ID="SerialNumber1"   runat="server" />
                                                    </td>
                                                </tr>
                                                <tr style="display">
                                                    <td class="smallblack" valign="center" align="right">
                                                        <%=GetLocalResourceObject("form1.table.tr.td5").ToString()%>&nbsp;
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlLang" runat="server" CssClass="EditText"  Width="120px" AutoPostBack="true"
                                                         onselectedindexchanged="ddlLang_SelectedIndexChanged">
                                                            <asp:ListItem Text="<%$ Resources: form1.table.tr.td.ddlLang.ListItem.Text %>" Value="zh-CN"></asp:ListItem>
                                                            <asp:ListItem Text="<%$ Resources: form1.table.tr.td.ddlLang.ListItem.Text1 %>" Value="en-US"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td align="left">
                                                        &nbsp;&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="23" valign="center" colspan="3" align="right">
                                                        <div class="STYLE9" align="center">
                                                            <asp:Literal ID="ltLoginInfo" runat="server" ></asp:Literal> 
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="23" valign="center" align="right">
                                                        &nbsp;
                                                    </td>
                                                    <td valign="bottom" align="left">
                                                        &nbsp;
                                                        <asp:Button ID="btnLogin" runat="server" Text="<%$ Resources: form1.table.tr.td.btnLogin.text %>" CssClass="button_nor" OnClientClick="return CheckLogin();"
                                                            OnClick="btnLogin_Click" />
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3" align="middle">
                                                        <div align="center" class="STYLE13">&nbsp;</div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3" align="middle">
                                                        <div align="center">
                                                            Distributor support hot line/经销商支持热线：400-630-9930<br/>
                                                            Distributor support email/经销商支持邮箱：2976286693@qq.com<br/>
                                                            <br/>
                                                            <span class="STYLE12">Copyright Boston Scientific China<br/>版权所有 蓝威</span></div>
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
                /**
                var Password = document.getElementById('txtPassword');
                if (Password.value == "") {
                    document.getElementById('spanPassword').style.display = 'block';
                    Password.focus();
                    return false;
                }
                else {
                    document.getElementById('spanPassword').style.display = 'none';
                }
                */
                return true;
            }
        </script>

    </div>
    </form>
</body>
</html>
