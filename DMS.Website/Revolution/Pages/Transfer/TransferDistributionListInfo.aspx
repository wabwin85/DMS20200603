<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="TransferDistributionListInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Transfer.TransferDistributionListInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="InstanceId" class="FrameControl" />
    <input type="hidden" id="hidDealerFromId" class="FrameControl" />
    <input type="hidden" id="hidDealerToDefaultWarehouseId" class="FrameControl" />
    <input type="hidden" id="hidOrderType" class="" />
    <input type="hidden" id="hidCorpType" class="" />
    <input type="hidden" id="hidDealerId" class="" />
    <input type="hidden" id="hiddIsModifyStatus" />
    <input type="hidden" id="IsNewApply" />
    <input type="hidden" id="ProductLineId" class="FrameControl" />
    <input type="hidden" id="QryTransferType" class="FrameControl" />
    <input type="hidden" id="QryInstanceId" class="FrameControl" />
    <input type="hidden" id="QryDealerToId" class="FrameControl" />

    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;分销出库明细</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品线：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryWinProductLine" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        一级经销商：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryWinDealerFrom" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        分销出库单号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryWinNumber" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        出库时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryWinDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        二级经销商：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryWinDealerTo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        状态：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryWinStatus" class="FrameControl"></div>
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
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;产品明细</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div class="col-buttom text-left" id="PnlDetailButton">
                                    <a id="BtnWinAddProduct"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstWinProductDetail" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row col-buttom" id="PnlButton">
                <a id="BtnSave"></a>
                <a id="BtnDelete"></a>
                <a id="BtnSubmit"></a>
                <a id="BtnClose"></a>
            </div>
        </div>
    </div>

    <div id="winTDLProductLayout" style="display: none; height: 480px;">
        <style>
            #winTDLProductLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width: 99%;">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    分仓库：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinTDLWarehouse" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    序列号/批号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinTDLLotNumber" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    产品型号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinTDLCFN" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    二维码：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinTDLQrCode" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-11 col-buttom">
                                <a id="BtnTDLSearch"></a>
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
                    <div class="box-body">
                        <div>
                            <div class="row">
                                <div id="RstTDLProductItem" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-buttom" style="width: 99%;">
            <a id="BtnWinAdd"></a>
            <a id="BtnWinClose"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/TransferDistributionListInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            TransferDistributionListInfo.Init();
        });
    </script>
</asp:Content>
