<%@ Page Language="C#" AutoEventWireup="true" Inherits="DMS.Website.Login" CodeBehind="Login.aspx.cs" %>

<%@ Register Assembly="Grapecity.Web.Controls" Namespace="Grapecity.Web.Controls"
    TagPrefix="grape" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <title>
        <%=GetLocalResourceObject("Title").ToString()%></title>
    <%--<link rel="stylesheet" type="text/css" href="resources/login/style.css">--%>

    <script type="text/javascript" src="resources/login/common.js"></script>
    <%-- <script type="text/javascript" src="resources/login/Base64.js"></script>--%>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <link rel="stylesheet" type="text/css" href="resources/css/font-awesome.min.css" />
    <script type="text/javascript" src="resources/kendo/js/jquery.min.js"></script>
    <style type="text/css">
        body {
            background-image: url();
            background-color: #E6E7E9;
            background-repeat: repeat-x;
            margin: 0px;
            padding: 0px;
            font-family: verdana, Arial, Helvetica, "微软雅黑", "宋体";
        }

        body, td, th {
            font-family: verdana, Arial, Helvetica, "微软雅黑", "宋体";
            font-size: 12px;
            color: #666666;
            padding: 0px;
            margin: 0px;
        }

        #center {
            background-image: url(images/login_02.jpg);
            height: 768px;
            width: 998px;
            background-repeat: no-repeat;
            float: none;
            background-position: 0px;
            clear: none;
            margin-top: 0px;
            margin-right: auto;
            margin-left: auto;
            top: 0px;
            left: 100px;
            right: auto;
            bottom: 998px;
            position: absolute;
        }

        #join {
            height: 245px;
            width: 450px;
            margin-top: 175px;
            margin-left: 215px;
            color: #294076#294076;
            font-family: verdana, Arial, Helvetica, "微软雅黑", "宋体";
            line-height: 20px;
            float: none;
        }

        #con {
            height: 80px;
            width: 300px;
            margin-left: 200px;
            margin-top: 17px;
            line-height: 20px;
            position: relative;
            float: none;
            top: 0px;
            left: 0px;
        }

        .text {
            color: #666666;
            background-color: #294076#294076;
            border: 1px solid #999999;
        }

        .red {
            color: #AB4540;
        }

        html, body, #bgDiv, #form1 {
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
            border: 0;
            border-collapse: collapse;
        }

        #bgDiv {
            overflow: hidden;
            background: url(resources/images/login_bg.jpg?v=20191011) no-repeat center center fixed;
            background-size: cover;
            background-color: #294076;
        }

        #lbox {
            position: relative;
            top: 61%;
            margin: 0;
            z-index: 9;
            text-align: left;
            left: 9.5%;
            width: 970px;
        }

        #inputBoxForm {
            background-color: rgba(255,255,255,.5);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#7f000000,endColorstr=#7f000000); /*IE8支持*/
            padding: 0 10px 0 10px;
            -webkit-background-clip: padding-box; /* for Safari */
            background-clip: padding-box; /* for IE9+, Firefox 4+, Opera, Chrome */
            position: relative;
            display: inline-block;
            zoom: 1;
            font: 18px/normal 'Segoe UI',Arial,Helvetica,Sans-Serif;
            display: none;
            border-radius: 3px;
            width: 950px;
        }

        .inputIcon {
            color: rgb(23, 214, 181);
            background-color:  #BDCDDA;
            vertical-align: middle;
            border: 11px solid  #BDCDDA;
            margin-top: 10px;
        }

        #footContainer {
            text-align: left;
            font-size: 14px;
            padding: 2px 0;
        }

        #linkContainer {
            display: inline-block;
            text-align: right;
            vertical-align: top;
        }

        #msgContainer {
            display: inline-block;
            text-align: left;
            min-width: 95px;
            width: 368px;
        }

        #lblmsg {
            display: none;
            color: red;
            overflow: hidden;
        }

        .inputBox {
            background-color:  #BDCDDA;
            margin: 0 0 0 -5px;
            padding: 10px 0px;
            border: 0;
            height: 20px;
            outline: none;
            box-sizing: content-box;
            position: relative;
            -webkit-appearance: none;
            vertical-align: bottom;
            font-size: 18px;
        }

        #txtUserName, #txtPassword {
            width: 185px;
        }

        #snvTxt1 {
            width: 95px;
        }

        #inputBoxSubmit {
            height: 40px;
            width: 145px;
            border: 0;
            color: #294076;
            background-color: rgba(23, 214, 181, 0.8);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#C817D6B5,endColorstr=#C817D6B5); /*IE8支持*/
            overflow: hidden;
            vertical-align: middle;
            position: static;
            cursor: pointer;
            margin-top: 10px;
        }

        #inputBoxForm img {
            vertical-align: bottom;
            height: 40px;
            width: 105px;
        }

        .login {
            position: relative;
            top: 55%;
            text-align: left;
            display: none;
            left: 9.5%;
            font-family: verdana, Arial, Helvetica, "微软雅黑", "宋体";
        }

            .login input[type=button] {
                width: 180px;
                height: 50px;
                background: transparent;
                border: 1px solid #294076;
                border-radius: 2px;
                color: #294076;
                font-size: 16px;
                font-weight: 500;
                padding: 4px;
                margin: 0px 30px 0px 0px;
                font-family: verdana, Arial, Helvetica, "微软雅黑", "宋体";
            }

                .login input[type=button]:hover {
                    background-color: #B6C8D6;
                    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#C817D6B5,endColorstr=#C817D6B5); /*IE8支持*/
                    cursor: pointer;
                    font-family: verdana, Arial, Helvetica, "微软雅黑", "宋体";
                }


        #con a:hover {
            color: #FF0000;
            font-size: 12px;
        }

        #con a {
            color: #666666;
            font-size: 12px;
            text-decoration: none;
        }

            #con a:active {
                color: #AB4540;
                font-size: 12px;
            }

        .STYLE9 {
            color: Red;
        }

        .STYLE3 {
            color: Red;
            white-space: nowrap;
            display: inline-block;
            width: 120px; /*限制宽度*/
            line-height: 1; /*数字与之前的文字对齐*/
        }

        .EditText {
            border-top-width: 0px;
            border-left-width: 0px;
            border-right-width: 0px;
            border-bottom-width: 0px;
        }
    </style>
    <%--
    <script type="text/javascript">
        if (top != self) {
            top.location.href = window.location.href;
        }
    </script>
    --%>
</head>
<body>
    <div id="divLoadingMask" style="display: none" runat="server">
    </div>
    <div id="bgDiv">
        <form id="form1" runat="server">
            <div id="login" class="login">
                <asp:HiddenField ID="hidelogin" runat="server" />
                <input type="button" name="user" value="经销商用户" onclick="javascript: $('#login').hide(); $('#inputBoxForm').fadeIn(2000); $('#imgrobot').fadeIn(); $('#hidelogin').val('true');" />
                <%--<input type="button" name="user" value="经销商用户" onclick="javascript: window.location = AuthUrl;" />--%>
                <%--<input style="display: none;" type="button" name="password" value="内部用户" onclick="javascript: window.location = '/Pages/SSO/Login.aspx';" />--%>
                <input type="button" name="password" value="内部用户" onclick="javascript: $('#login').hide(); $('#inputBoxForm').fadeIn(2000); $('#imgrobot').fadeIn(); $('#hidelogin').val('true');" />
                <img alt="" src="resources/images/物联网.jpg" style="width: 80px; height: 80px; vertical-align: middle; display: none;" />
                <br />
                <br />
                <br />
                <div style="color: #294076; font-weight: bold; font-size: 13px; position: absolute;">友情提醒：为了更好的操作体验, 建议使用Chrome、Firefox、360、QQ 浏览器访问。<br />
                        经销商支持邮箱：<a href="mailto:dms@bpmedtech.com" style="color: #294076;">dms@bpmedtech.com</a>
						</div>
            </div>
            <div id="lbox">
                <div id="inputBoxForm" onkeydown="KeyLogin()">
                    <i class="fa fa-user inputIcon" aria-hidden="true"></i>
                    <input id="txtUserName" runat="server" type="text" class="inputBox" placeholder="登录帐号" />
                    <i class="fa fa-lock inputIcon" aria-hidden="true"></i>
                    <input id="txtPassword" runat="server" type="password" class="inputBox" placeholder="登录密码" />
                    <i class="fa fa-star inputIcon" aria-hidden="true"></i>
                    <asp:TextBox ID="snvTxt1" runat="server" CssClass="inputBox"
                        placeholder="验证码" autocomplete="off"></asp:TextBox>
                    <grape:SerialNumber ID="SerialNumber1" runat="server" />
                    <asp:Button ID="inputBoxSubmit" runat="server" OnClientClick="return CheckLogin();" OnClick="btnLogin_Click" ClientIDMode="Static" Font-Bold="true" Font-Size="14px" Text="登&nbsp;录"></asp:Button>
                    <a href="~/PasswordReback.aspx" id="hhh" target="_blank" style="color: red; text-decoration: none; margin-left: 10px;" runat="server">忘记密码？</a>
                    <asp:Label ID="lbBlank" runat="server" Text=" " Height="5px"></asp:Label>
                    
                    <div id="footContainer">
                        <span id="msgContainer">
                            <label id="lblmsg" runat="server"></label>
                        </span>
                    </div>
                    <div class="content" style="font-size: 13px; color: #294076; height: 10%; position: absolute; right: 0px;">
                        <br />
                        经销商支持邮箱：<a href="mailto:dms@bpmedtech.com" style="color: #294076;">dms@bpmedtech.com</a>
                        <br />
                    </div>
                    
                </div>
                <div id="imgrobot" style="float: right; margin-top: -70px; display: none;">
                    <img alt="" src="resources/images/物联网.jpg" style="width: 80px; height: 80px; vertical-align: middle; display: none;" />
                </div>
            </div>

            <div style="font-size: 13px; color: #294076; height: 3%; position: absolute; bottom: 0px; right: 20px;">
                Copyright © 2020 蓝威医疗科技（上海）有限公司 网站备案/许可证号：<a href="http://beian.miit.gov.cn/" style="color: #294076;" target="_blank">沪ICP备17051093号-3</a>
            </div>
            <%--<div>
        <table width="998" border="0" align="center" cellpadding="0" cellspacing="0" background="resources/login/login_03.jpg" >
            <tr>
                <td align="left" valign="top">
                    <div id="join">                       
                        <div style="margin-top: 2px;">
                            <%=GetLocalResourceObject("form1.table.tr.td").ToString()%>
                            <input style="width: 120px;" id="txtUserName" class="EditText" name="txtUserName" runat="server">
                            <span style="display: none" id="spanUserName" class="STYLE3">&nbsp;<%=GetLocalResourceObject("form1.table.tr.td1").ToString()%></span>
                        </div>
                        <div style="margin-top: 13px;">
                            <%=GetLocalResourceObject("form1.table.tr.td2").ToString()%>
                            <input style="width: 120px;" id="txtPassword" class="EditText" type="password" name="txtPassword" runat="server">
                            <span style="display: none" id="spanPassword" class="STYLE3">&nbsp;<%=GetLocalResourceObject("form1.table.tr.td3").ToString()%></span>
                        </div>
                        <div style="margin-top: 13px;">
                            <%=GetLocalResourceObject("form1.table.tr.td4").ToString()%>
                            <asp:TextBox ID="snvTxt1" runat="server" CssClass="EditText" Width="120px" autocomplete="off"></asp:TextBox>
                        </div>
                        <div style="margin-top: 5px;">
                            <table>
                                <tr>
                                    <td>
                                        <%=GetLocalResourceObject("form1.table.tr.blank").ToString()%>
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
                            </table>
                        </div>
                        <div style="margin-top: 20px; margin-bottom: 15px;">
                            <%=GetLocalResourceObject("form1.table.tr.td5").ToString()%>
                            <asp:DropDownList ID="ddlLang" runat="server" CssClass="EditText" Width="120px" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlLang_SelectedIndexChanged">
                                <asp:ListItem Text="<%$ Resources: form1.table.tr.td.ddlLang.ListItem.Text %>" Value="zh-CN"></asp:ListItem>
                                <asp:ListItem Text="<%$ Resources: form1.table.tr.td.ddlLang.ListItem.Text1 %>" Value="en-US"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="STYLE9" align="left">
                            <asp:Literal ID="ltLoginInfo" runat="server"></asp:Literal>
                        </div>
                        <div style="width: 780px; margin-left: 0px; float: left">
                            <asp:Button ID="btnLogin" runat="server" Text="<%$ Resources: form1.table.tr.td.btnLogin.text %>"
                                BorderWidth="0" CssClass="login" OnClientClick="return CheckLogin();" OnClick="btnLogin_Click" />
                            <asp:Button ID="btnLoginSSO" runat="server" Text="单点登录"
                                BorderWidth="0" CssClass="login" OnClick="btnLoginSSO_Click" />
                        </div>
                    </div>
                    <div id="con">
                       
                        经销商支持热线：400 630 9930    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 经销商支持邮箱：<a href=mailto:2976286693@qq.com'>2976286693@qq.com</a><br />
                        本系统版权所有：Boston Scientific China

                        </div>
                    
                    <div>
                        <p align="center">
                            <table width="100%">
                                <tr>
                                  <td style="width: 50%" align="right">
                                          
                                    </td>
                        <td align="left" valign="top">&nbsp;&nbsp;&nbsp;Powered by GrapeCity Inc.<br />
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;沪ICP备13033443号<br />
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ver 2.2.2.20170421
                                    </td>
                                </tr>
                            </table>
                    </div>
                </td>
            </tr>
        </table>
        </div>--%>
        </form>
    </div>

    <script language="javascript" type="text/javascript">
        var AuthUrl = '<%=AuthUrl%>';

        $(function () {
            if ($("#hidelogin").val() != "") {
                $("#login").hide();
                $("#inputBoxForm").show();
                $("#imgrobot").show();
            } else {
                $("#login").fadeIn(3000);
            }

            //预加载js和css
            $.get("/resources/kendo/js/kendo.web.min.js");
            $.get("/resources/kendo/js/messages/kendo.messages.zh-CN.min.js");
            $.get("/resources/kendo/js/cultures/kendo.culture.zh-CN.min.js");
            $.get("/resources/kendo/styles/kendo.common.min.css");
            $.get("/resources/kendo/styles/kendo.default.min.css");
        })
        function KeyLogin() {
            if (event.keyCode == 13)
                document.getElementById('inputBoxSubmit').click();
        }
        function CheckLogin() {
            var UserName = $('#txtUserName');
            if (UserName.val() == "" || UserName.val() == "登录帐号") {
                UserName.focus();
                $('#lblmsg').text("请先输入您的登录账号");
                $('#lblmsg').css("display", "block");
                return false;
            }
            else {
                $('#lblmsg').css("display", "none");
            }
            var Password = $('#txtPassword');
            if (Password.val() == "" || Password.val() == "登录密码") {
                Password.focus();

                $('#lblmsg').text("请先输入您的登录密码");
                $('#lblmsg').css("display", "block");
                return false;
            }
            else {
                $('#lblmsg').css("display", "none");
            }

            return true;
        }
    </script>

</body>
</html>
