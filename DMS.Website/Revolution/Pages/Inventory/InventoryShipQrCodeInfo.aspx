<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="InventoryShipQrCodeInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Inventory.InventoryShipQrCodeInfo" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="ChooseParam" class="FrameControl"/>
    <input type="hidden" id="HidDealerId" class="FrameControl"/>
    <input type="hidden" id="HidHeadId" class="FrameControl" />
    <input type="hidden" id="HidShipHeadId" class="FrameControl" />
    <input type="hidden" id="HidPmaId" class="FrameControl" />
    <input type="hidden" id="InvType" class="FrameControl"/>
    <input type="hidden" id="HidLotId" class="FrameControl" />
    <input type="hidden" id="HidWhmId" class="FrameControl" />
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
                                        <div id="WinQrCodeConvertDealerName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>产品线：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinQrCodeConvertProductLine" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>产品型号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinQrCodeConvertUpn" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>批次号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinQrCodeConvertLotNumber" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>被替换的二维码：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinQrCodeConvertUsedQrCode" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>新二维码：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinQrCodeConvertNewQrCode" class="FrameControl"></div>
                                        <a id="BtnNewCfn"></a>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>调整原因：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinQrCodeConvert" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-truck'></i>&nbsp;查询结果</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstWinQrCodeConvertList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winQrCodeCfnLayout" style="display:none;height:480px;">
        <style>
            #winQrCodeCfnLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="col-xs-12" style="padding: 0px;">
                <div class="row">
                    <div class="box box-primary">
                        <div class="box-body">
                            <div class="col-xs-12" style="padding: 0px;">
                                <div class="row">
                                    <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                        <div class="col-xs-4 col-label">
                                            仓库：
                                        </div>
                                        <div class="col-xs-7 col-field">
                                            <div id="WinQrCodeWarehouse" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                        <div class="col-xs-4 col-label">
                                            二维码：
                                        </div>
                                        <div class="col-xs-7 col-field">
                                            <div id="WinQrCode" class="FrameControl"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-11 col-buttom" id="PnlSearch">
                                        <a id="BtnQrSearch"></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="box box-primary">
                        <div class="box-body" style="padding: 0px;">
                            <div class="col-xs-12" style="padding: 0px;">
                                <div class="row" style="margin: 0 auto;">
                                    <div id="RstWinQrCodeCfnList" class="k-grid-page-20"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-10 col-buttom" style="width:99%;">
            <a id="BtnWinQrAdd"></a>
            <a id="BtnWinQrClose"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom" id="PnlButton">
        <a id="BtnShipmentQRCodeSubmit"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="/resources/Calculate.js" type="text/javascript"></script>
    <script type="text/javascript" src="Script/InventoryShipQrCodeInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(function () {
            InventoryShipQrCodeInfo.InitQrCodeConvertWin();
        });
    </script>
</asp:Content>
