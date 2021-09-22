<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="InventoryShipmentInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Inventory.InventoryShipmentInfo" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .DetailTab {
            margin:0 auto;
            width:97%;
            height:400px;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="InvType" class="FrameControl"/>
    <input type="hidden" id="HidDealerId" class="FrameControl"/>
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>经销商：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinShipmentDealerName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>产品线：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinShipmentProductLine" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>用量日期：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinShipmentDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>销售医院：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinShipmentHospital" class="FrameControl"></div>
                                        <a id="BtnWinPrice"></a>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        发票号码：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinShipmentInvoiceNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        发票抬头：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinShipmentInvoiceTitle" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        发票日期：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinShipmentInvoiceDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        科室：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinShipmentDepartment" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        备注：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinShipmentRemark" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div id="DivBasicInfo" style="border: 0;">
                    <ul>
                        <li class="k-state-active">上报销量
                        </li>
                        <li>附件
                        </li>
                    </ul>
                    <div style="padding: 0px;">
                        <div class="col-xs-12 DetailTab">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-truck'></i>&nbsp;查询结果</h3>
                                    <div style="float:right;">
                                        <i class='fa fa-plus-square'></i>&nbsp;记录数：<span id="spShipmentRecordSum"></span>&nbsp;
                                        <i class='fa fa-plus-square'></i>&nbsp;数量合计：<span id="spShipmentQtySum"></span>&nbsp;
                                    </div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding: 0px;">
                                        <div class="row" style="margin:0 auto;">
                                            <div id="RstWinShipmentList" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div style="padding: 0px;">
                        <div class="col-xs-12 DetailTab">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <div style="float:right;">
                                        <a id="BtnWinAddAttach"></a>
                                    </div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding: 0px;">
                                        <div class="row" style="margin:0 auto;">
                                            <div id="RstWinAttachList" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winAttachmentLayout" style="display:none;height:185px;">
        <style>
            #winAttachmentLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div>
                        <div class="row">
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-3 col-label">
                                    <i class='fa fa-fw fa-require'></i>文件：
                                </div>
                                <div class="col-xs-8 col-field">
                                    <input name="files" id="WinAttachUpload" type="file" aria-label="files" />
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
    <div class="foot-bar col-buttom" id="PnlButton">
        <a id="BtnWinClearShipment"></a>
        <a id="BtnWinAddShipment"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="/Revolution/Resources/js/Calculate.js" type="text/javascript"></script>
    <script type="text/javascript" src="Script/InventoryShipmentInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(function () {
            InventoryShipmentInfo.InitShipmentWin();
        });
    </script>
</asp:Content>
