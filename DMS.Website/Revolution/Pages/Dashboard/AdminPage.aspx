<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="AdminPage.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Dashboard.AdminPage" %>


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
            min-height: 560px;
        }


        #PnlSummary {
            min-height: 280px;
        }

        #PnlChart {
            min-height: 560px;
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
                                        <button type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown" style="padding: 2px 10px; font-size: 12px; margin-top: -3px;" id="IptYear">
                                        </button>
                                        <ul class="dropdown-menu pull-right" role="menu" id="LstYear">
                                        </ul>
                                    </div>
                                    &nbsp;
                                </div>
                            </div>
                            <div id="PnlChart" class="box-body">
                                <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
                                    <ol class="carousel-indicators">
                                        <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                                        <li data-target="#carousel-example-generic" data-slide-to="1" class=""></li>
                                    </ol>
                                    <div class="carousel-inner">
                                        <div class="item active">
                                            <div id="RstOrder" style="height: 45%;"></div>
                                            <br />
                                            <div id="RstShipment" style="height: 45%;"></div>
                                        </div>
                                        <div class="item">
                                            <div id="RstInterface"></div>
                                            <div id="RstMenu"></div>
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
    <script type="text/javascript" src="Script/AdminPage.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            AdminPage.Init();
        });
    </script>
</asp:Content>