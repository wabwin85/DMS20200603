<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ReturnPositionSearch.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Inventory.ReturnPositionSearch" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="WinIDCode" class="FrameControl" />
    <input type="hidden" id="WinProductline" class="FrameControl" />
    <input type="hidden" id="Winamount" class="FrameControl" />
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-filter'></i>&nbsp;退货额度查询</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDealer" class="FrameControl CellInput"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品线：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryProductLine" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom" id="PnlButton">
                                    <a id="BtnNew"></a>
                                    <a id="BtnQuery"></a>
                                    <a id="BtnExport"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;查询结果</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstResultList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winDetailLayout" style="display:none;height:460px;">
        <style>
            #winDetailLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div>
                        <div class="row">
                            <div id="RstWinDetail" class="k-grid-page-20"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winPromotionType" style="display:none;height:280px;">
        <style>
            #winPromotionType .row {
                margin: 0 auto;
            }
        </style>
        <div class="box box-primary">
            <div class="box-body">
                <div class="col-xs-12" style="padding:0px;">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                            <div class="col-xs-4 col-label">
                                经销商：
                            </div>
                            <div class="col-xs-7 col-field">
                                <div id="WinDealer" class="FrameControl CellInput"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                            <div class="col-xs-4 col-label">
                                产品线：
                            </div>
                            <div class="col-xs-7 col-field">
                                <div id="WinProductLine" class="FrameControl"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                            <div class="col-xs-4 col-label">
                                年份：
                            </div>
                            <div class="col-xs-7 col-field">
                                <div id="WinYears" class="FrameControl"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                            <div class="col-xs-4 col-label">
                                季度：
                            </div>
                            <div class="col-xs-7 col-field">
                                <div id="WinQuarter" class="FrameControl"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                            <div class="col-xs-4 col-label">
                                额度：
                            </div>
                            <div class="col-xs-7 col-field">
                                <div id="WinAmount" class="FrameControl"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                            <div class="col-xs-4 col-label">
                                备注：
                            </div>
                            <div class="col-xs-7 col-field">
                                <div id="WinRemark" class="FrameControl"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-11 col-buttom" id="WinButton">
                            <a id="BtnSubmit"></a>
                            <a id="BtnClose"></a>
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
    <script type="text/javascript" src="Script/ReturnPositionSearch.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ReturnPositionSearch.Init();
        });
    </script>
</asp:Content>
