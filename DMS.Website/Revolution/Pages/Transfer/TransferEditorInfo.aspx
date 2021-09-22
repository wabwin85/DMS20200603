<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="TransferEditorInfo.aspx.cs"
    Inherits="DMS.Website.Revolution.Pages.Transfer.TransferEditorInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="DealerListType" class="FrameControl" />
    <input type="hidden" id="hidPriceType" class="" />
    <input type="hidden" id="hidOrderType" class="" />
    <input type="hidden" id="hidCorpType" class="" />
    <input type="hidden" id="hidDealerId" class="" />
    <input type="hidden" id="InstanceId" class="FrameControl" />
    <input type="hidden" id="ProductLineId" class="FrameControl" />
    <input type="hidden" id="QryTransferType" class="FrameControl" />
    <input type="hidden" id="QryInstanceId" class="FrameControl" />
    <input type="hidden" id="QryDealerFromId" class="FrameControl" />
    <input type="hidden" id="QryDealerToId" class="FrameControl" />
    <input type="hidden" id="IsNewApply" />
    <input type="hidden" id="hiddIsModifyStatus" />

    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;基本信息</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <%--                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div id="IptApplyBasic" class="FrameControl"></div>
                            </div>--%>
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDealerFromWin" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        移库单号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryOrderNO" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        状态
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryStatus" class="FrameControl"></div>
                                    </div>
                                </div>


                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>产品线
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryProductLineWin" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        出库时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDate" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        默认移入仓库
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryWarehouseWin" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <a id="BtnReason"></a>
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
                                    <a id="BtnAddProduct"></a>
                                    <div class="col-xs-2 col-label" style="float: right">
                                        产品总数量：<div id="ProductSumText" class="FrameControl" style="display: inline-block;"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstProductDetail" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div id="RstOperationLog" class="row">
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom" id="PnlButton">
        <a id="BtnSave"></a>
        <a id="BtnDelete"></a>
        <a id="BtnSubmit"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="/Revolution/Resources/js/Calculate.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript" src="Script/TransferEditorInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            TransferEditorInfo.Init();
        });
    </script>
</asp:Content>
