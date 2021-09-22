<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home2.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Home2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>蓝威渠道数据管理系统</title>

    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/styles/kendo.common.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/styles/kendo.bootstrap.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/styles/kendo.bootstrap.mobile.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/bootstrap-3.3.5/css/bootstrap.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/Font-Awesome-4.7.0/css/font-awesome.min.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/css/weui.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/css/kendo.css") %>?v=" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/css/main.css") %>?v=" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/css/main.dms.css") %>?v=" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/LTE/css/AdminLTE.css") %>" />
    <link rel="stylesheet" href="<%=Page.ResolveUrl("~/Revolution/Resources/LTE/css/skins/_all-skins.min.css") %>" />
    <style type="text/css">
        html, body {
            height: 100%;
            font-family: 微软雅黑;
            margin: 0px;
            padding: 0px;
        }

        html {
            overflow-x: hidden;
            overflow-y:auto;
        }

        .skin-blue-light .sidebar-menu > li {
            border-bottom: 1px solid #e5e5e5;
        }

            .skin-blue-light .sidebar-menu > li > a {
                padding: 8px 5px 7px 15px;
            }

            .skin-blue-light .sidebar-menu > li > ul {
                border-top: 1px solid #e5e5e5;
                background-color: #FFF !important;
                padding: 0px;
            }

                .skin-blue-light .sidebar-menu > li > ul > li {
                    border-bottom: 1px dotted #e5e5e5;
                }

                    .skin-blue-light .sidebar-menu > li > ul > li:last-child {
                        border-bottom: 0px;
                    }

        .control-sidebar-menu {
            margin: 0px !important;
        }

            .control-sidebar-menu .menu-info {
                margin-left: 3px;
            }

        .control-sidebar > .tab-content {
            padding: 0px;
        }

        .control-sidebar > .nav > li > a {
            padding: 8px 15px 7px;
        }

        /*标签*/
        .k-tabstrip-wrapper {
            height: 100%;
        }

        .Tabstrip {
            width: 100%;
            border: 0;
        }

        .k-tabstrip-top .k-tabstrip-items .k-state-active {
            border-bottom: 0px;
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
            border-bottom: 1px solid #e0e0e0;
        }

        .k-tabstrip-items .k-item {
            margin-right: 2px;
            border-top-width: 2px;
            font-size: 13px;
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
            border-top-color: #438eb9;
        }

            .k-tabstrip > .k-tabstrip-items > .k-state-active:hover {
                opacity: 1;
            }

            .k-tabstrip > .k-tabstrip-items > .k-state-active > .k-link {
                cursor: default;
            }

        .tab-pane {
            overflow: hidden;
            height: 100%;
            width: 100%;
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

        .btn:active {
            -webkit-box-shadow: none;
            box-shadow: none;
        }

            .btn:active:focus {
                outline: none;
            }

        @media (max-width: 767px) {
            .main-header .logo {
                display: none;
            }

            .fixed .content-wrapper, .fixed .right-side {
                padding-top: 50px;
            }

            .main-sidebar, .control-sidebar {
                padding-top: 50px;
            }
        }
    </style>

    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/jquery.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/kendo.web.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/kendo.all.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/jszip.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/messages/kendo.messages.zh-CN.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/kendo/js/cultures/kendo.culture.zh-CN.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/bootstrap-3.3.5/js/bootstrap.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/js/bootbox.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/LTE/js/adminlte.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/js/jquery.slimscroll.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/FrameJs/common.js") %>?v="></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/Revolution/Resources/FrameJs/Kendo/FrameJS.Kendo.min.js") %>?v="></script>
</head>
<body class="hold-transition skin-blue-light sidebar-mini fixed">
    <div class="wrapper">
        <header class="main-header">
            <a href="#" class="logo">
                <span class="logo-mini"><b>BSC</b></span>
                <span class="logo-lg"><b>BSC渠道数据管理系统</b></span>
            </a>
            <nav class="navbar navbar-static-top">
                <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button"></a>
                <div class="navbar-custom-menu">
                    <ul class="nav navbar-nav">
                        <li class="dropdown">
                            <div style="padding: 12px 15px;">
                                <div class="input-group" style="width: 200px;">
                                    <input type="text" name="q" class="form-control" placeholder="检索..." style="height: 25px; border: 0px; border-top-left-radius: 3px; border-bottom-left-radius: 3px;">
                                    <span class="input-group-btn">
                                        <button type="submit" name="search" id="search-btn" class="btn btn-flat" style="height: 25px; padding: 0px 5px; background-color: #FFF; color: #000; border-top-right-radius: 3px; border-bottom-right-radius: 3px;">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </span>
                                </div>
                            </div>
                        </li>
                        <li class="dropdown user user-menu">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <span class="hidden-xs">lium4</span>
                            </a>
                            <ul class="dropdown-menu">
                                <li class="user-header">
                                    <p>
                                        刘梦迪 - IT
                                    </p>
                                </li>
                                <li class="user-footer">
                                    <div class="pull-left">
                                        <a href="#" class="btn btn-default btn-flat">个人设置</a>
                                    </div>
                                    <div class="pull-right">
                                        <a href="#" class="btn btn-default btn-flat">退出</a>
                                    </div>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>
        <aside class="main-sidebar">
            <section class="sidebar" style="position: relative;" id="scroll">
                <ul class="sidebar-menu" data-widget="tree">
                    <li class="treeview">
                        <a href="#">
                            <i class="fa fa-dashboard"></i><span>订单管理</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li><a href="#"><i class="fa fa-circle-o"></i>二级经销商订单申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>单据信息修改</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>平台及一级经销商订单申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>平台及一级经销商订单审核</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>二级经销商订单价格导入</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>经销商订单价格查询</a></li>
                        </ul>
                    </li>
                    <li class="treeview">
                        <a href="#">
                            <i class="fa fa-files-o"></i>
                            <span>库存管理</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-寄售仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>其他出入库-普通仓库</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货审批</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>退换货申请</a></li>
                            <li><a href="#"><i class="fa fa-circle-o"></i>借货出库</a></li>
                        </ul>
                    </li>
                </ul>
            </section>
        </aside>
        <div class="content-wrapper">
            <div id="PnlTabs" class="Tabstrip">
            </div>
        </div>
        <aside class="control-sidebar control-sidebar-light" style="overflow: hidden;">
            <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
                <li class="active"><a href="#control-sidebar-home-tab" data-toggle="tab">收藏夹</a></li>
                <li><a href="#control-sidebar-settings-tab" data-toggle="tab">历史</a></li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="control-sidebar-home-tab">
                    <ul class="control-sidebar-menu" id="fave-panel" style="position: relative;">
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">其他出入库-寄售仓库</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">退换货申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">平台及一级经销商订单申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">经销商订单价格查询</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">其他出入库-寄售仓库</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">退换货申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">平台及一级经销商订单申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">经销商订单价格查询</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">其他出入库-寄售仓库</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">退换货申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">平台及一级经销商订单申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">经销商订单价格查询</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">其他出入库-寄售仓库</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">退换货申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">平台及一级经销商订单申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">经销商订单价格查询</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">其他出入库-寄售仓库</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">退换货申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">平台及一级经销商订单申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">经销商订单价格查询</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">其他出入库-寄售仓库</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">退换货申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">平台及一级经销商订单申请</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">经销商订单价格查询</h4>
                                </div>
                            </a>
                        </li>
                    </ul>
                </div>
                <div class="tab-pane" id="control-sidebar-settings-tab">
                    <ul class="control-sidebar-menu" id="his-panel">
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">订单AAA</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">促销政策BBB</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">经销商CCC</h4>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="menu-info">
                                    <h4 class="control-sidebar-subheading">退货单DDD</h4>
                                </div>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </aside>
    </div>
</body>
<script>
    $(document).ready(function () {
        $('.sidebar-menu').tree();

        kendo.culture("zh-CN");

        $("#PnlTabs").kendoTabStrip({
            animation: {
                open:
                {
                    duration: 0
                },
                close: {
                    duration: 0
                }
            },
            select: function () {
                setLayout();
            }
        })

        createTab('M_1', '首页', "/Revolution/Pages/Dashboard/DealerPage.aspx", false);
        createTab('M_2', '寄售合同', "/Revolution/Pages/Consign/ConsignContractList.aspx", true);

        $('#fave-panel').height($(window).height() - 87);
        $('#fave-panel').slimScroll({
            height: ($(window).height() - 87) + 'px'
        });
        $('#his-panel').height($(window).height() - 87);
        $('#his-panel').slimScroll({
            height: ($(window).height() - 87) + 'px'
        });

        $(window).resize(function () {
            setLayout();
        })
        setLayout();
    })


    var createTab = function (id, title, url, enableClose, refresh) {
        id = id.toUpperCase();
        if (title == null) title = "Overview";
        if (url == null) {
            url = "/Pages/FileNotFound.htm";
        }
        var tabsText = '';
        if (typeof (enableClose) == 'undefined' || enableClose == true) {
            tabsText = "<span>" + title + "<span class=\"fa fa-remove\" style=\"text-indent: .5em; z-index: 1111; cursor: pointer;\" onclick='deleteTabs(this);'></span></span>";
        } else {
            tabsText = "<span>" + title + "</span>";
        }

        var tabstrip = $("#PnlTabs").data("kendoTabStrip");

        if ($("#PnlTabs").find("#" + id + "").length > 0) {
            $("#PnlTabs").data("kendoTabStrip").select($("#PnlTabs").find("#" + id + "").parents("div.k-content").index() - 1);
            if (typeof (refresh) != 'undefined' && refresh == true) {
                $('#frame_' + id).attr('src', url);
            }
        } else {
            tabstrip.append(
                [{
                    text: tabsText,
                    content: getMenuPane(id, url),
                    encoded: false
                }]
            );

            var i = $("#PnlTabs").find("#" + id + "").parents("div.k-content").index() - 1;

            $("#PnlTabs").data("kendoTabStrip").select("li:last");
        }
    }

    var getMenuPane = function (id, url) {
        return "<div role=\"tabpane\" class=\"tab-pane\" id=\"" + id + "\" ><iframe id=\"frame_" + id + "\" src=\"" + url + "\" style=\"height:100%;width:100%;border:0;margin:0;padding:0;\" frameborder=\"no\" scrolling=\"no\" allowtransparency=\"yes\"></iframe></div>";
    }

    var deleteTabs = function (ImgObj) {
        $("#PnlTabs").data("kendoTabStrip").select($(ImgObj).closest("li").index() - 1);
        $("#PnlTabs").data("kendoTabStrip").remove($(ImgObj).closest("li").index());
    }

    var deleteTabsCurrent = function () {
        var index = $("#PnlTabs").find(".k-state-active").index();
        $("#PnlTabs").data("kendoTabStrip").select(index - 1);
        $("#PnlTabs").data("kendoTabStrip").remove(index);
    }

    var changeTabsName = function (oldframeId, newId, name) {
        var newFrameId = oldframeId.substring(0, oldframeId.length - 3) + newId.toUpperCase();
        var oldTabPaneId = oldframeId.substring(6);
        var newTabPaneId = oldTabPaneId.substring(0, oldTabPaneId.length - 3) + newId.toUpperCase();
        $('#' + oldframeId).attr("id", newFrameId);
        $('#' + oldTabPaneId).attr("id", newTabPaneId);
        $('.k-state-active').find('.k-link').html("<span>" + name + "<span class=\"fa fa-remove\" style=\"text-indent: .5em; z-index: 1111; cursor: pointer;\" onclick='deleteTabs(this);'></span></span>");
    }

    var setLayout = function () {
        var hWindow = $(document).height();
        var hNav = $('.main-header').outerHeight(true);
        var hTabItems = $('.k-tabstrip-items').outerHeight(true);

        $('#PnlTabs').find('.k-content').height(hWindow - hNav - hTabItems);
    }
</script>
</html>
