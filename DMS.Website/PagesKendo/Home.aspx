<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="DMS.Website.PagesKendo.Home" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>蓝威合同管理系统</title>
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/kendo-2017.2.504/styles/kendo.common.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/kendo-2017.2.504/styles/kendo.default.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/bootstrap-3.3.5/css/bootstrap.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/Font-Awesome-4.7.0/css/font-awesome.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/ace/css/ace.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/css/common_bootstrap.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/css/common_kendo.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Resources/css/weui.css") %>" />

    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/kendo-2017.2.504/js/jquery.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/kendo-2017.2.504/js/kendo.web.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/kendo-2017.2.504/js/kendo.all.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/kendo-2017.2.504/js/messages/kendo.messages.zh-CN.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/kendo-2017.2.504/js/cultures/kendo.culture.zh-CN.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/bootstrap-3.3.5/js/bootstrap.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/js/bootbox.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/FrameJs/common.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/FrameJs/Kendo/util.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/FrameJs/Kendo/control.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Resources/FrameJs/Kendo/window.js") %>"></script>

    <style type="text/css">
        .yahei {
            font-family: 微软雅黑 !important;
        }

        /*导航*/
        .container {
            padding-right: 0;
            padding-left: 0;
            margin-right: auto;
            margin-left: auto;
            width: 100%;
        }

        .headerTable {
            margin-right: auto;
            margin-left: auto;
            margin-bottom: 0;
            margin-top: 0;
            border: 0;
            background-color: #fff;
            background-image: url("../Resources/images/top_banner5.jpg");
            background-repeat: no-repeat;
            background-position: left;
            height: 48px;
            width: 100%;
        }

        /*页签*/
        .settingsWrapper {
            background-color: #fff;
            width: 100%;
        }

        .setting {
            padding: 2px;
            padding-right: 1em;
            font-size: 14px;
        }

            .setting ul li {
                display: inline;
                color: #000000;
                /*margin-right: 8px;*/
                line-height: 24px;
                padding: 2px;
                padding-bottom: 0px;
            }

                .setting ul li a, .setting ul li a:link {
                    color: #000000;
                    text-decoration: none;
                }

                    .setting ul li a:hover {
                        text-decoration: underline;
                    }

        .k-tabstrip .k-content.k-state-active {
            background-color: #fff;
        }

        .k-tabstrip > .k-tabstrip-items {
            background-color: #8BA9C5;
            height: 29px;
        }

            .k-tabstrip > .k-tabstrip-items > .k-state-active {
                border-color: #003b6f;
                border-bottom-color: #fff;
            }

        .tab-pane {
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
            top: 0;
            overflow-x: hidden;
            overflow-y: hidden;
            height: 100%;
            width: auto;
        }

        .Tabstrip { /* tabstrip element */
            position: absolute;
            top: 78px;
            bottom: 0;
            left: auto;
            right: auto;
            width: 100%;
            height: auto;
            border-width: 0px;
            background-color: transparent !important;
        }

        .k-tabstrip > .k-content {
            margin: 0;
            padding: .3em 0em;
        }

        .k-tabstrip .k-content {
            position: absolute;
            top: 32px;
            bottom: 0px;
            left: 0;
            right: 0;
            width: auto;
            height: auto;
            border: 0;
            border-top: solid 2px #003b6f;
        }

        /*菜单 */
        .k-menu.k-header {
            border-color: #003b6f;
            background-image: none;
            padding-left: 1em;
            padding-right: 1em;
        }

        .k-header {
            background-color: #337ab7;
        }

        .k-widget.k-menu-horizontal > .k-item {
            border-width: 0;
        }

        .k-menu > .k-item > .k-link {
            color: #FFFFFF;
        }

        .k-menu > .k-state-hover > .k-link {
            color: #000000;
        }

        .k-menu > .k-item > .k-state-border-down {
            color: #000000;
        }

        .k-menu > .k-state-hover {
            background-color: #FFFFFF;
        }

        .k-window-titlebar {
            color: #000000 !important;
            border-bottom: solid 1px #ccc;
        }

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
    </style>
    <script type="text/javascript">
        kendo.culture("zh-CN");

        $(document).ready(function () {
            bootbox.setLocale({
                locale: 'zh_CN'
            });
        })

        Common.AppVirtualPath = "<%=HttpRuntime.AppDomainAppVirtualPath %>";
    </script>
</head>
<body style="margin: 0px; height: 100%; padding: 0px;">
    <div class="container">
        <div style="background-color: transparent;">
            <div class="settingsWrapper">
                <table class="headerTable">
                    <tr style="background-color: #003b6f; filter: progid:DXImageTransform.Microsoft.Gradient(startColorStr='#003b6f',endColorStr='#8BA9C5',gradientType='1'); background: -moz-linear-gradient(left, #003b6f, #8BA9C5); background: -o-linear-gradient(left,#003b6f, #8BA9C5); background: -webkit-gradient(linear, 0% 0%, 100% 0%, from(#003b6f), to(#8BA9C5));">
                        <td style="width: 60%; height: 48px;">
                            <%--<img class="logo" src="<%=ResolveUrl("~/resources/images/logo-chinese-W.png") %>" style="height: 40px; margin-left: 40px;" />--%>
                            <span style="font-size: 20px; color: #FFFFFF; margin-top: 10px; vertical-align: middle;">&nbsp;&nbsp;蓝威合同管理系统</span>
                        </td>
                        <td style="text-align: right; float: right; vertical-align: middle;">
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
                                    <li class="green">
                                        <label style="margin-right: 8px; color: #FFFFFF; font-weight: normal; padding-top: 5px;" id="IptUserName"></label>
                                    </li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <div>
                <ul id="RstMenuList" style="border-color: #337ab7; padding: 1px 10px 1px 10px;">
                </ul>
            </div>
        </div>
        <div id="PnlTabs" class="Tabstrip" data-toggle="context">
        </div>
    </div>
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
    <script type="text/javascript" src="Script/Home.js?v=1.009"></script>
</body>
</html>
