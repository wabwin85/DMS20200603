<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="DealerPage.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Dashboard.DealerPage" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .box-todo .box-body {
            height: 176px;
            padding: 5px;
            position: relative;
        }

        .box-todo .item {
            padding: 5px 0;
            font-size: 14px;
        }

            .box-todo .item .product-img {
                font-size: 16px;
                line-height: 25px;
            }

            .box-todo .item .product-info {
                margin-left: 30px;
                line-height: 25px;
                cursor: pointer;
            }

        .box-shortcut .inner .fa {
            font-size: 20px;
        }

        .box-manual .box-body {
            height: 176px;
            padding: 5px;
            position: relative;
            font-size: 14px;
        }

        .box-manual .row {
            padding: 5px 0;
        }

        .box-summary {
            margin-bottom: 0px;
        }

            .box-summary .box-body {
                padding: 5px;
                position: relative;
            }

            .box-summary .item {
                padding: 5px 0;
                font-size: 14px;
            }

                .box-summary .item .product-img {
                    font-size: 16px;
                    line-height: 25px;
                }

                .box-summary .item .product-info {
                    margin-left: 30px;
                    line-height: 25px;
                    cursor: pointer;
                }

        .box-chart {
            margin-bottom: 0px;
        }

            .box-chart .box-body {
                padding: 5px 10px;
                position: relative;
            }

        .box-notice {
            margin-bottom: 0px;
        }

            .box-notice .box-body {
                padding: 5px;
                position: relative;
            }

            .box-notice .item {
                padding: 5px 0;
                font-size: 14px;
            }

                .box-notice .item .product-img {
                    font-size: 16px;
                    line-height: 25px;
                }

                .box-notice .item .product-info {
                    margin-left: 30px;
                    line-height: 25px;
                }

        .small-box {
            margin-bottom: 5px;
            border-radius: 0px;
            cursor: pointer;
        }

            .small-box:hover {
                z-index: 999;
            }

            .small-box > .inner {
                text-align: center;
                vertical-align: middle;
                font-size: 16px;
                height: 80px;
                line-height: 30px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

                .small-box > .inner > p {
                    margin: 0;
                }

            .small-box > .inner-out {
                display: none;
            }

        .carousel-control {
            color: #3c8dbc;
        }

            .carousel-control:hover {
                color: #3c8dbc;
            }

        .carousel-indicators {
            bottom: 0px !important;
        }

            .carousel-indicators li {
                border: 1px solid #3c8dbc;
            }

            .carousel-indicators .active {
                background-color: #3c8dbc;
            }

        .carousel-inner .item {
            min-height: 280px;
        }

        #PnlSummary {
            min-height: 280px;
        }

        #PnlChart {
            min-height: 280px;
        }

        #PnlNotice {
            min-height: 280px;
        }

        @media all and (min-width:768px) {
            .row-todo {
                margin-right: -10px;
            }

            .row-shortcut {
                margin-right: -10px;
            }

            .row-summary {
                margin-right: -10px;
            }

            .row-chart {
                margin-right: -10px;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row" id="PnlLine1">
                <div class="col-xs-12 col-sm-3">
                    <div class="row row-todo">
                        <div class="box box-primary box-todo">
                            <div class="box-header with-border">
                                <h3 class="box-title">公告</h3>
                            </div>
                            <div class="box-body panel-todo">
                                <ul class="products-list product-list-in-box" id="RstNotice">
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-6">
                    <div class="row row-shortcut">
                        <div class="box box-primary box-shortcut">
                            <div class="box-header with-border">
                                <h3 class="box-title">快捷菜单</h3>
                            </div>
                            <div class="box-body" id="PnlShortcut">
                                
                                <div class="col-xs-5" style="padding-right: 20px;">
                                    <div class="row">
                                        <div class="small-box bg-yellow" style="background-color: #39cccc !important;" id="BtnOrderFill">
                                            <div class="inner" style="height: 85px">
                                                <p><i class="fa fa-fw fa-shopping-cart"></i></p>
                                                <p>手工下单</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-6">
                                            <div class="row">
                                                <div class="small-box bg-yellow" style="background-color: #92e3e3 !important; margin-bottom: 0px;" id="BtnPriceQuery">
                                                    <div class="inner" style="height: 85px">
                                                        <p><i class="fa fa-fw fa-search"></i></p>
                                                        <p>价格查询</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-xs-6">
                                            <div class="row">
                                                <div class="small-box bg-yellow" style="background-color: #39cccc !important; margin-bottom: 0px;" id="BtnOrderImport">
                                                    <div class="inner" style="height: 85px">
                                                        <p><i class="fa fa-fw fa-folder-open"></i></p>
                                                        <p>订单导入</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-2" style="padding-right: 20px;">
                                    <div class="row">
                                        <div class="small-box bg-yellow" style="background-color: #00a65a !important; margin-bottom: 0px;" id="BtnDelivery">
                                            <div class="inner" style="height: 175px; line-height: 48.3333px;">
                                                <p><i class="fa fa-cubes"></i></p>
                                                <p>收</p>
                                                <p>货</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-5">
                                    <div class="row">
                                        <div class="col-xs-6">
                                            <div class="row">
                                                <div class="small-box bg-yellow" style="background-color: #f39c12 !important;" id="BtnSalesImport">
                                                    <div class="inner" style="height: 85px">
                                                        <p><i class="fa fa-fw fa-folder-open"></i></p>
                                                        <p>销量导入</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-xs-6">
                                            <div class="row">
                                                <div class="small-box bg-yellow" style="background-color: #f8c97d !important;" id="BtnSalesReport">
                                                    <div class="inner" style="height: 85px">
                                                        <p><i class="fa fa-fw fa-qrcode"></i></p>
                                                        <p>二维码上报</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <div class="small-box bg-yellow" style="background-color: #f8c97d !important; margin-bottom: 0px;" id="BtnSalesFill">
                                                    <div class="inner" style="height: 85px">
                                                        <p><i class="fa fa-fw fa-pencil-square-o"></i></p>
                                                        <p>填写上报</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <%--<div class="col-xs-6">
                                            <div class="row">
                                                <div class="small-box bg-yellow" style="background-color: #f39c12 !important; margin-bottom: 0px;" id="BtnInvoiceUpload">
                                                    <div class="inner" style="height: 85px">
                                                        <p><i class="fa fa-fw fa-cloud-upload"></i></p>
                                                        <p>上传发票</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>--%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-3">
                    <div class="row row-manual">
                        <div class="box box-primary box-todo">
                            <div class="box-header with-border">
                                <h3 class="box-title">待处理</h3>
                            </div>
                            <div class="box-body panel-todo">
                                <ul class="products-list product-list-in-box" id="RstTodo">
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12 col-sm-3">
                    <div class="row row-summary">
                        <div class="box box-primary box-summary">
                            <div class="box-header with-border">
                                <h3 class="box-title">汇总信息</h3>
                            </div>
                            <div class="box-body" id="PnlSummary">
                                <ul class="products-list product-list-in-box" id="RstSummary">
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-6">
                    <div class="row row-chart">
                        <div class="box box-primary box-chart">
                            <div class="box-header with-border">
                                <h3 class="box-title">业务趋势汇总</h3>
                                <div class="pull-right box-tools">
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown" style="padding: 2px 10px; font-size: 12px; margin-top: -3px;" id="IptQuarter">
                                        </button>
                                        <ul class="dropdown-menu pull-right" role="menu" id="LstQuarter">
                                        </ul>
                                    </div>
                                    &nbsp;
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown" style="padding: 2px 10px; font-size: 12px; margin-top: -3px;" id="IptBu">
                                        </button>
                                        <ul class="dropdown-menu pull-right" role="menu" id="LstBu">
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="box-body" id="PnlChart">
                                <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
                                    <ol class="carousel-indicators">
                                        <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                                        <li data-target="#carousel-example-generic" data-slide-to="1" class=""></li>
                                    </ol>
                                    <div class="carousel-inner">
                                        <div class="item active">
                                            <div id="RstDimension" style="height: 90%;"></div>
                                        </div>
                                        <div class="item">
                                            <div id="RstTrend"></div>
                                        </div>
                                    </div>
                                    <a class="left carousel-control" href="#carousel-example-generic" data-slide="prev">
                                        <span class="fa fa-angle-left"></span>
                                    </a>
                                    <a class="right carousel-control" href="#carousel-example-generic" data-slide="next">
                                        <span class="fa fa-angle-right"></span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-3">
                    <div class="row row-manual">
                        <div class="box box-primary box-manual">
                            <div class="box-header with-border">
                                <h3 class="box-title">DMS教程</h3>
                            </div>
                            <div class="box-body" id="PnlNotice">
                                <div class="products-list product-list-in-box" id="RstManual">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerPage.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            DealerPage.Init();
        });
    </script>
</asp:Content>
