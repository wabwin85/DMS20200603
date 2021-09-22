<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ShipmentInitList.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Shipment.ShipmentInitList" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="WinSelectNo" class="FrameControl" />
    <input type="hidden" id="WinSelectStatus" class="FrameControl" />
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-filter'></i>&nbsp;查询条件</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDealer" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        导入编号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryShipmentInitNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        导入日期：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QrySubmitDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        处理状态：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryShipmentInitStatus" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-xs-12 col-buttom">
                                    <a id="BtnImport"></a>
                                    <a id="BtnSearch"></a>
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
                                <div id="RstImportResult" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winDetailImportResultLayout" style="display:none;height:95%;">
        <style>
            #winDetailImportResultLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-exclamation-triangle'></i>&nbsp;查询结果</h3>
                    </div>
                <div class="box-body">
                    <div class="row" style="border-bottom: 1px solid lightgrey;">
                        <div style="float:left;">
                            <i class="fa fa-times" style="color:red;"></i>&nbsp;<span id="spWrongCnt" style="color:red;"></span>&nbsp;
                            <i class="fa fa-check" style="color:green;"></i>&nbsp;<span id="spCorrectCnt" style="color:green;"></span>&nbsp;
                            <i class="fa fa-arrow-right" style="color:green;"></i>&nbsp;<span id="spInProcessCnt" style="color:green;"></span>&nbsp;
                        </div>
                        <div style="float:right;">
                            <i class="fa fa-plus-square"></i>&nbsp;<span id="spSumPrice"></span>&nbsp;
                            <i class="fa fa-plus-square"></i>&nbsp;<span id="spSumQty"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div id="RstWinDetailResult" class="k-grid-page-20"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;">
            <a id="BtnExportError"></a>
            <a id="BtnClose"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/ShipmentInitList.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ShipmentInitList.Init();
        });
    </script>
</asp:Content>
