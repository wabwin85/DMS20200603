<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Empty.Master" AutoEventWireup="true" CodeBehind="Navigation.aspx.cs" Inherits="DMS.WeChatClient.Page.Navigation" %>

<%@ Import Namespace="DMS.WeChatClient.Common" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHeader" runat="server">
    <script type="text/javascript" src="<%=ResolveUrl("~/Resource/Scripts/Library/swiper.min.js") %>"></script>
    <style type="text/css">
        .weui_input {
            text-overflow: ellipsis;
        }

        .swiper-container img {
            width: 100%;
        }

        .blue {
            color: #3577BA !important;
        }

            .blue:after {
                border-color: #3577BA !important;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCondent" runat="server">
    <div class="weui_tab" id="divContainer" style="display: none;">
        <div class="weui_tab_bd">
            <div id="divHome" class="weui_tab_bd_item">
               <div class="swiper-container" data-space-between='10' data-pagination='.swiper-pagination' data-autoplay="1000">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide">
                            <img src="<%=ResolveUrl("~/Resource/images/Swiper/12.jpg")%>" alt="">
                        </div>
                        <div class="swiper-slide">
                            <img src="<%=ResolveUrl("~/Resource/images/Swiper/11.jpg")%>" alt="">
                        </div>
                    </div>
                    <div class="swiper-pagination"></div>
                </div>
                <div class="weui_cells weui_cells_access">
                    <a class="weui_cell blue" id="btnScanQRCode">
                        <div class="weui_cell_bd weui_cell_primary">
                            <p>二维码上报DMS</p>
                        </div>
                        <div class="weui_cell_ft blue"></div>
                    </a>
                    <a class="weui_cell">
                        <div class="weui_cell_hd">
                            <label for="txtUserName" class="weui_label">用户</label>
                        </div>
                        <div class="weui_cell_bd weui_cell_select weui_cell_primary select weui_cell_content">
                            <input class="weui_input" id="txtUserName" type="text" value="" placeholder="请选择用户">
                        </div>
                    </a>
                </div>
            </div>
            <div id="divMy" class="weui_tab_bd_item">
                <div class="personalInfo">
                    <div class="personalInfo_Head">
                        <img runat="server" id="imgAvator" src="../Resource/images/NavMenu/DefaultAvatar.png" />
                        <div>
                            欢迎您<br/><span id="spUserName"></span>
                        </div>
                    </div>
                    <div class="weui-col-50" style="margin-top: 80px;">
                        <a id="btnLogout" class="weui_btn gui_btn gui_btn_primary">退出</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui_tabbar">
            <a id="Home" href="#divHome" class="weui_tabbar_item">
                <div class="weui_tabbar_icon">
                    <img class="normal" src="<%=ResolveUrl("~/Resource/images/BottomMenu/Home.png")%>" alt="">
                    <img class="active" style="display: none;" src="<%=ResolveUrl("~/Resource/images/BottomMenu/Home_Active.png")%>" alt="">
                </div>
                <p class="weui_tabbar_label">主页</p>
            </a>
            <a id="My" href="#divMy" class="weui_tabbar_item">
                <div class="weui_tabbar_icon">
                    <img class="normal" src="<%=ResolveUrl("~/Resource/images/BottomMenu/My.png")%>" alt="">
                    <img class="active" style="display: none;" src="<%=ResolveUrl("~/Resource/images/BottomMenu/My_Active.png")%>" alt="">
                </div>
                <p class="weui_tabbar_label">我的</p>
            </a>
        </div>
    </div>
    <input type="hidden" id="hidTab" runat="server" clientidmode="Static" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphBottom" runat="server">
    <script>
        var Users = [];
        var SetUserInfo = function (UserInfo) {
            localStorage.setItem(config.LocalStrogeName.UserId, UserInfo.UserId);
            localStorage.setItem(config.LocalStrogeName.UserName, UserInfo.UserName);
            localStorage.setItem(config.LocalStrogeName.DealerId, UserInfo.DealerId);
            localStorage.setItem(config.LocalStrogeName.DealerName, UserInfo.DealerName);
            $("#spUserName").html(UserInfo.UserName);
            $("#txtUserName").attr('data-values', UserInfo.UserId);
            $("#txtUserName").val(UserInfo.DealerName);
            if (!UserInfo.DealerId) {
                $("#btnScanQRCode").hide();
            } else {
                $("#btnScanQRCode").show();
            }
        };
        $(function () {
            localStorage.setItem(config.LocalStrogeName.OpenId, $("#hdfOpenID").val());
            $(".personalInfo_Head").css("height", $(window).height() / 2);
            $("a", ".weui_tabbar").unbind(config.EventName.click).bind(config.EventName.click, function () {
                $("img[class='active']").hide();
                $("img[class='normal']").show();
                $("img[class='active']", $(this)).show();
                $("img[class='normal']", $(this)).hide();
            });
            //var mySwiper = new Swiper('.swiper-container',
            //    {
            //        speed: 1000, //播放速度
            //        autoHeight: true,
            //        loop: true, //是否循环播放
            //        setWrapperSize: true,
            //        autoplay:
            //        {
            //            delay: 2000,
            //            disableOnInteraction: false,
            //        },
            //        pagination: '.swiper-pagination', //分页
            //        effect: 'slide', //动画效果
            //    }
            //);
            //$(".swiper-container").swiper({
            //    loop: true,
            //    autoplay: 2000
            //});
            $("#btnScanQRCode").unbind(config.EventName.click).bind(config.EventName.click, function () {
                localStorage.setItem(config.LocalStrogeName.QRHeaderNo, '');
                window.location.href = '<%=Common.JointBaseUrl("/Page/QRCode/UploadQRCode.aspx")%>';
            });

            $("#btnLogout").unbind(config.EventName.click).bind(config.EventName.click, function () {
                $.confirm("您确认要退出吗?", function () {
                    var parm = { OpenId: $("#hdfOpenID").val() };
                    utility.CallService(config.ActionMethod.Account.Action, config.ActionMethod.Account.Method.LoginOut, parm, function (data) {
                        if (data.success) {
                            localStorage.clear();
                            window.location.href = '<%=Common.GetUrlLoginPage()%>';
                        } else {
                            $.alert(data.msg);
                        }
                    });
                });
            });

            var currentTab = $("#hidTab").val();
            if (undefined == currentTab || "" == currentTab) {
                currentTab = "Home";
            }
            $("#" + currentTab).click();

            utility.CallService(config.ActionMethod.Navigation.Action, config.ActionMethod.Navigation.Method.Init, { openId: $("#hdfOpenID").val() }, function (data) {
                if (data.success) {
                    Users = data.data;
                    if (Users.length > 0) {
                        var CurrentUserId = localStorage.getItem(config.LocalStrogeName.UserId);
                        var selects = [];
                        var DefaultItem = null;
                        for (var i in Users) {
                            if (Users.hasOwnProperty(i)) {
                                var item = Users[i];
                                selects.push({ title: item.DealerName, value: item.UserId });
                                if (CurrentUserId && CurrentUserId.toLowerCase() === item.UserId.toLowerCase()) {
                                    DefaultItem = item;
                                }
                            }
                        }
                        if (!DefaultItem) {
                            DefaultItem = Users[0];
                        }
                        //设置默认值
                        SetUserInfo(DefaultItem);
                        $("#txtUserName").select({
                            title: $("label[for=txtUserName]").html(),
                            items: selects,
                            onChange: function () {
                                var UserId = undefined == $("#txtUserName").attr("data-values") ? '' : $("#txtUserName").attr("data-values");
                                var UserInfo = Users.find(function (value, index, arr) {
                                    return Users[index].UserId.toLowerCase() === UserId.toLowerCase();
                                });
                                SetUserInfo(UserInfo);
                            }
                        });
                        $("#divContainer").show();
                    } else {
                        localStorage.clear();
                        $.toptip('用户信息无效，请重新登录', 'error');
                        setTimeout(function () {
                            window.location.href = '<%=Common.GetUrlLoginPage()%>';
                        }, 1000);
                        }
                    } else {
                        window.location.href = '<%=Common.GetUrlLoginPage()%>';
                }
            });
        });
    </script>
</asp:Content>
