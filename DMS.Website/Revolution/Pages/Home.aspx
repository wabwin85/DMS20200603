<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Home" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <title>蓝威医疗经销商管理系统</title>

    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/styles/kendo.common.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/styles/kendo.bootstrap.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/styles/kendo.bootstrap.mobile.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/bootstrap-3.3.5/css/bootstrap.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/Font-Awesome-4.7.0/css/font-awesome.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/ace/css/ace.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/css/weui.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/css/main.css") %>?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/css/main.dms.css") %>?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>" />

    <style type="text/css">
        .slimScrollBar {
            border-radius: 7px !important;
        }

        .navbar-header {
            float: left;
        }

        .dropdown-navbar {
            width: 280px;
        }

            .dropdown-navbar > li:last-child > a {
                color: #555;
                font-size: 12px;
            }

        .sidebar-collapse {
            height: 33px;
            line-height: 33px;
        }

            .sidebar-collapse:before {
                top: 18px;
            }

        .nav-list > li > a {
            height: 30px;
            line-height: 30px;
        }

        .nav-list > li a > .arrow {
            top: 8px;
        }

        .nav-list > li .submenu > li > a {
            padding-right: 5px;
        }

        .menu-min .nav-list > li > .submenu li > a {
            padding-right: 5px;
        }

        /*标签*/
        .k-tabstrip-wrapper {
            height: 100%;
        }

        .Tabstrip {
            width: 100%;
            border: 0;
        }

        .k-tabstrip:focus {
            -webkit-box-shadow: none;
            box-shadow: none;
        }

        .k-tabstrip .k-content.k-state-active {
            background-color: #fff;
        }

        .k-tabstrip > .k-tabstrip-items {
            background-color: #f5f5f5;
            padding: 3px 3px 0 3px;
            height: 29px;
        }

        .k-tabstrip-items .k-item {
            margin-right: 2px;
        }

        .k-tabstrip > .k-tabstrip-items > .k-state-default {
            border-color: #e0e0e0;
            background-color: #ffffff;
        }

            .k-tabstrip > .k-tabstrip-items > .k-state-default:hover {
                opacity: .7;
            }

            .k-tabstrip > .k-tabstrip-items > .k-state-default > .k-link {
                color: #000000;
            }

        .k-tabstrip > .k-tabstrip-items > .k-state-active {
            border-color: #438eb9;
            background-color: #438eb9;
            /*
                border-color: #00136f;
                background-color: #00136f;
            */
        }

            .k-tabstrip > .k-tabstrip-items > .k-state-active:hover {
                opacity: 1;
            }

            .k-tabstrip > .k-tabstrip-items > .k-state-active > .k-link {
                color: #FFFFFF;
                cursor: default;
            }

        .tab-pane {
            overflow-x: hidden;
            overflow-y: hidden;
            height: 100%;
            width: 100%;
            border-top: 1px solid #e0e0e0;
            height: calc(100% - 1px);
        }

        .k-tabstrip > .k-content {
            margin: 0;
            padding: 0;
        }

        .k-tabstrip .k-content {
            width: 100%;
            height: 100%;
            border: 0;
        }

        .header-normal {
            display: block;
        }

        .header-mini {
            display: none;
        }

        @media all and (max-width:768px) {

            .header-normal {
                display: none;
            }

            .header-mini {
                display: block;
            }
        }

        /*其他*/
        .bootbox {
            z-index: 20000;
        }

        .modal-backdrop {
            z-index: 19999;
        }

        .bootbox-body {
            overflow: auto;
            max-height: 400px;
        }

        .menu-min .submenu {
            max-height: 400px !important;
        }

        .bootbox-input-text {
            border-top: 0px !important;
            border-left: 0px !important;
            border-right: 0px !important;
        }

            .bootbox-input-text:focus {
                border-color: #76abd9 !important;
            }

        .dropdown-menu.dropdown-close {
            top: 97%;
        }

            .dropdown-menu.dropdown-close.pull-right {
                right: 0px;
            }

        .user-profile {
            background-color: #438eb9 !important;
            padding: 10px;
        }

            .user-profile > p {
                text-align: center;
                margin: 0px;
                color: #FFF;
            }

        .user-footer {
            background-color: #f9f9f9 !important;
        }

        .dropdown-navbar > li > a:hover {
            background-color: #FFF;
            color: #4f99c6;
            text-decoration: underline;
            cursor: pointer;
        }
        .dropdown-navbar > li > a {
            cursor: pointer;
        }
    </style>


    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/jquery.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/kendo.web.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/kendo.all.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/messages/kendo.messages.zh-CN.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/cultures/kendo.culture.zh-CN.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/js/bootbox.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/js/jquery.slimscroll.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/FrameJs/Kendo/FrameJS.Kendo.min.js") %>?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>

    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/ace/js/ace.min.js") %>?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/ace/js/ace-extra.min.js") %>?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/ace/js/bootstrap.min.js") %>?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>

    <script type="text/javascript">
        Common.AppVirtualPath = "<%=DMS.Common.WebHelper.GetWebRoot() %>";
        Common.AppHandler = Common.AppVirtualPath + 'Revolution/Pages/Handler/ActionHandler.ashx';

        kendo.culture("zh-CN");

        $(document).ready(function () {
            bootbox.setLocale({
                locale: 'zh_CN'
            });
        })
    </script>
</head>

<body style="min-height: 600px">
    <!--<div class="navbar navbar-default" style="background-color:#00136f;" id="PnlNav">-->
    <div class="navbar navbar-default" id="PnlNav">
        <div class="navbar-container">
            <div class="navbar-header">
                <div class="header-normal">
                    <span style="line-height: 45px; height: 45px; font-size: 24px; color: #FFFFFF; padding-left: 5px;">蓝威医疗经销商管理系统</span>
                </div>
                <div class="header-mini">
                    <span style="line-height: 45px; height: 45px; font-size: 24px; color: #FFFFFF; padding-left: 5px;">DMS</span>
                </div>
            </div>
            <div class="navbar-header pull-right" role="navigation">
                <ul class="nav ace-nav">
                    <li class="red" id="PnlSubCompany">
                        <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                            <span class="user-info">
                                <small>分子公司</small>
                                <span id="IptSubCompanyName"></span>
                                <input type ="hidden" id="IptSubCompanyId"/>
                            </span>
                            <i class="fa fa-caret-down" id="BtnSubCompanyMore"></i>
                        </a>
                        <ul class="pull-right dropdown-navbar dropdown-menu dropdown-caret dropdown-close" id="LstSubCompanyList" style="width: auto;">
                        </ul>
                    </li>
                    <li class="red" id="PnlBrand">
                        <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                            <span class="user-info">
                                <small>品牌</small>
                                <span id="IptBrandName"></span>
                                <input type ="hidden" id="IptBrandId"/>
                            </span>
                            <i class="fa fa-caret-down" id="BtnBrandMore"></i>
                        </a>
                        <ul class="pull-right dropdown-navbar dropdown-menu dropdown-caret dropdown-close" id="LstBrandList" style="width: auto;">
                        </ul>
                    </li>
                    <li class="green" id="PnlDealer">
                        <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                            <span class="user-info">
                                <small>经销商/用户</small>
                                <span id="IptDealerName"></span>
                            </span>
                            <i class="fa fa-caret-down" id="BtnDealerMore"></i>
                        </a>
                        <ul class="pull-right dropdown-navbar dropdown-menu dropdown-caret dropdown-close" id="LstDealerList" style="width: auto;">
                        </ul>
                    </li>
                    <li class="light-blue">
                        <a data-toggle="dropdown" href="#" class="dropdown-toggle panel-username">
                            <span class="user-info">
                                <small>欢迎，</small>
                                <span id="IptUserName"></span>
                            </span>
                            <i class="fa fa-caret-down"></i>
                        </a>
                        <ul class="pull-right dropdown-navbar dropdown-menu dropdown-caret dropdown-close">
                            <li class="user-profile">
                                <p id="IptUserInfo"></p>
                                <p id="IptUserMobile"></p>
                            </li>
                            <!--<li>
                                <a href="#" id="BtnChangePwd">
                                    <div class="clearfix">
                                        <span class="pull-left">修改密码</span>
                                    </div>
                                </a>
                            </li>-->
                            <li class="user-footer">
                                <div class="pull-right">
                                    <button id="BtnAdmin" type="button" class="btn btn-default btn-sm"><i class="fa fa-fw fa-cogs"></i>&nbsp;&nbsp;系统管理</button>
                                    <button id="BtnUserProfile" type="button" class="btn btn-default btn-sm"><i class="fa fa-fw fa-user-circle"></i>&nbsp;&nbsp;个人信息</button>
                                    <button id="BtnLogout" type="button" class="btn btn-default btn-sm"><i class="fa fa-fw fa-sign-out"></i>&nbsp;&nbsp;退出</button>
                                </div>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div class="main-container">
        <div class="main-container-inner">
            <div class="sidebar" id="sidebar">
                <div class="sidebar-collapse" id="sidebar-collapse">
                    <i class="fa fa-angle-double-left" data-icon1="fa-angle-double-left" data-icon2="fa-angle-double-right" style="top: -2px;"></i>
                </div>
                <ul class="nav nav-list" id="LstMenuList">
                </ul>
            </div>
            <div class="main-content" id="PnlTab">
                <div id="PnlTabs" class="Tabstrip">
                </div>
            </div>
        </div>
    </div>
    <div id="PnlNearEffect" style="display: none; max-height: 497px; max-width: 700px; min-height: 497px; min-width: 700px; padding: 0px;">
        <div id="RstNearEffect" style="margin: 5px;"></div>
        <div class="col-buttom text-right" style="position: absolute; height: 30px; line-height: 30px; width: 690px; bottom: 0; border-top: 1px solid #CCC;">
            <a id="BtnCloseNearEffect"></a>
        </div>
    </div>

<%--    <div id="PnlAccount" style="display: none; max-height: 250px; max-width: 400px; min-height: 250px; min-width: 400px; padding: 0px;">
      
        <div class="col-xs-4 col-label" style="line-height: 40px; font-weight: bold">
            手机号码
        </div>
        <div class="col-xs-8 col-field">
            <div id="IptPhone" class="FrameControl"></div>
        </div>
        <div class="col-xs-4 col-label" style="line-height: 40px; font-weight: bold">
            邮箱地址
        </div>
        <div class="col-xs-8 col-field">
            <div id="IptEmail" class="FrameControl"></div>
        </div>
        <div   class="col-xs-4 col-label" style="line-height: 40px; width: 370px; color:#F00; font-weight: bold">
            手机号码会作为登录账号和接收验证码，请务必准确填写。
        </div>
        <div class="col-buttom text-right" style="position: absolute; height: 30px; line-height: 30px; width: 390px; bottom: 0; border-top: 1px solid #CCC;">
            <a id="BtnSave"></a>
            <a id="BtnCloseAccount"></a>
        </div>
    </div>--%>



    <%--实现整个页面的遮罩--%>
    <div id="loadingToast" class="weui_loading_toast">
        <div class="weui_mask_transparent">
        </div>
        <div class="weui_toast">
            <div class="weui_loading">
                <div class="weui_loading_leaf weui_loading_leaf_0">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_1">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_2">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_3">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_4">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_5">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_6">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_7">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_8">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_9">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_10">
                </div>
                <div class="weui_loading_leaf weui_loading_leaf_11">
                </div>
            </div>
            <p id="mscont" class="weui_toast_content">
                数据加载中
            </p>
        </div>
    </div>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Pages/Script/Home.js") %>?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
</body>
</html>
