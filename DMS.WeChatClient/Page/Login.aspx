<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Empty.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="DMS.WeChatClient.Page.Login" %>

<%@ Import Namespace="DMS.WeChatClient.Common" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHeader" runat="server">
    <link href="<%=ResolveUrl("~/Resource/css/Custom/login.css?v=2020021102") %>" rel="stylesheet">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCondent" runat="server">
    <div class="loginInfoContainer">
        <div class="row headerlogo">
            <img src="../Resource/images/Login/logo_login.png">
        </div>
        <div class="row">
            <div class="logindiv">
                <div class="logincontrol">
                    <div class="logininput user">
                        <input id="txtUserName" type="text" placeholder="帐号" />
                    </div>
                    <div class="logininput password">
                        <input id="txtPassword" type="password" placeholder="密码" />
                    </div>
                </div>
            </div>
        </div>
        <div class="row" style="margin-top: 30px; font-size: 13px; color: #BBBBBB;">
            <div style="text-align: center; margin-bottom: 5px; color: #008BCE;">
                <span>请输入蓝威DMS帐号和密码进行登录</span>
            </div>
        </div>
        <div class="row">
            <div class="buttonlogin">
                <div id="btnLogin">登录</div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphBottom" runat="server">
    <script>
        $(function () {
            $(".loginInfoContainer").css("height", $(window).height());
        });

        $(function () {
            var mainPageUrl = '<%=Common.GetUrlNavPage()%>';

            $("#btnLogin").unbind(config.EventName.click).bind(config.EventName.click, function () {
                var checkResult = { success: true, msg: [] };
                if ('' == $("#txtUserName").val()) {
                    checkResult.success = false;
                    checkResult.msg.push("请输入帐号");
                }
                if ('' == $("#txtPassword").val()) {
                    checkResult.success = false;
                    checkResult.msg.push("请输入密码");
                }

                if (!checkResult.success) {
                    $.alert(checkResult.msg.join("<br/>"));
                    return false;
                } else {
                    var parm = { OpenId: $("#hdfOpenID").val(), UserName: $("#txtUserName").val(), Password: $("#txtPassword").val() };
                    utility.CallService(config.ActionMethod.Account.Action, config.ActionMethod.Account.Method.LoginIn, parm, function (data) {
                        if (data.success) {
                            window.location.href = mainPageUrl;
                        } else {
                            $.alert(data.msg);
                        }
                    });
                }
            });
        });

    </script>
</asp:Content>
