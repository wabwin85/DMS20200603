<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="TransferUnfreezeInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Transfer.TransferUnfreezeInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .DetailTab {
            margin: 0 auto;
            width: 97%;
            height: 470px;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hiddIsModifyStatus" />
    <input type="hidden" id="IsNewApply" />
    <input type="hidden" id="WinTransferId" class="FrameControl" />
    <input type="hidden" id="WinTransferType" class="FrameControl" />
    <input type="hidden" id="HidDealerFrom" />
    <input type="hidden" id="HidProductLine" />
    <div class="content-main">
        <div id="winDetailLayout" class="col-xs-12" style="padding: 5px;">
            <style>
                #winDetailLayout .row {
                    margin: 0px;
                }

                #RstWinOPLog .col-xs-12 {
                    padding: 0px;
                }
            </style>
            <div class="row" style="width: 100%; margin: 0 auto; display: inline-block;">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="col-xs-12" style="padding: 0px;">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinDealer" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        移库单号：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinTransferNumber" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        状态：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinTransferStatus" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>产品线：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinProductLine" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        出库时间：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        默认移入仓库：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinWarehouse" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-7 col-field" style="padding-bottom: 5px;">
                                    <a id="BtnReason"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" style="width: 100%; margin: 0 auto; display: inline-block;">
                <div id="DivBasicInfo" style="border: 0;">
                    <ul>
                        <li class="k-state-active">产品明细
                        </li>
                        <li>操作记录
                        </li>
                    </ul>
                    <div style="padding: 0px;">
                        <div class="col-xs-12 DetailTab">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <i class='fa fa-plus-square'></i>&nbsp;<span id="spProductSum"></span>&nbsp;
                                    <div style="float: right;"><a id="BtnAddProduct"></a></div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding: 0px;">
                                        <div class="row">
                                            <div id="RstWinProductList" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div style="padding: 0px;">
                        <%--<div class="col-xs-12 DetailTab">
                            <div class="row">
                                <div class="box box-primary">
                                    <div class="box-body" style="padding: 0px;">
                                        <div class="col-xs-12" style="padding-left:0px;">
                                            <div class="row">
                                                
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>--%>
                        <div id="RstWinOPLog" style="" class="k-grid-page-20"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winChooseItemLayout" style="display: none; height: 97%;">
        <style>
            #winChooseItemLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width: 99%; height: 90%; overflow-y: scroll;">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    冻结仓库：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinFreezeWarehouse" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    序列号/批号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinLotNumber" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    产品型号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinCFN" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    二维码：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinQrCode" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-11 col-buttom">
                                <a id="BtnImportQrCode"></a>
                                <a id="BtnSearch"></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div>
                <div class="row">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;查询结果</h3>
                        </div>
                        <div class="box-body">
                            <div>
                                <div class="row">
                                    <div id="RstProductItem" class="k-grid-page-20"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-10 col-buttom" style="width: 99%;">
            <a id="BtnWinAdd"></a>
            <a id="BtnWinClose"></a>
        </div>
    </div>
    <div id="winQRCodeImportLayout" style="display: none; height: 180px;">
        <style>
            #winQRCodeImportLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width: 99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div>
                        <div class="row">
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-3 col-label">
                                    <i class='fa fa-fw fa-require'></i>文件：
                                </div>
                                <div class="col-xs-8 col-field">
                                    <input name="files" id="WinQrCodeImport" type="file" aria-label="files" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width: 99%; text-align: center;">
            <a id="BtnQrCodeTemplate"></a>
        </div>
    </div>
    <div id="winReasonLayout" style="display: none; height: 280px;">
        <style>
            #winReasonLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width: 99%;">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;原因</h3>
                </div>
                <div class="box-body">
                    <div>
                        <div class="row">
                            <div id="RstWinReason" class="k-grid-page-20"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom">
        <a id="BtnWinSave"></a>
        <a id="BtnWinDelete"></a>
        <a id="BtnWinSubmit"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="/resources/Calculate.js" type="text/javascript"></script>
    <script type="text/javascript" src="Script/TransferUnfreezeInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            TransferUnfreezeInfo.Init();
        });
    </script>
</asp:Content>
