<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ConsignTransferInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Consign.ConsignTransferInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input id="InstanceId" type="hidden" class="FrameControl" />
    <input id="IsNewApply" type="hidden" class="FrameControl" />
    <div class="content-main" style="padding: 5px 5px 0px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;基本信息</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div id="IptApplyBasic" class="FrameControl"></div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>产品线
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptBu" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>移出经销商
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptDealerOut" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>移入经销商
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptDealerIn" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="clearfix hidden-xs hidden-sm"></div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-blank"></i>医院
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHospital" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>销售
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptSales" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-group">
                                    <div class="col-xs-4 col-label col-3to1-4and8-label">
                                        <i class="fa fa-fw fa-require"></i>转移原因	
                                    </div>
                                    <div class="col-xs-8 col-field col-3to1-4and8-field">
                                        <div id="IptRemark" class="FrameControl"></div>
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
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;寄售合同信息（移入经销商）</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="IptConsignContract" class="FrameControl"></div>
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
                            <div id="PnlAddDetailButton" class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div class="col-buttom text-left">
                                    <a id="BtnAddDetail"></a>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstDetailList" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row panel-confirm-grid">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;确认产品</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row panel-confirmed-row" style="border-left: solid 1px #c5d0dc;">
                                <div id="RstConfirmList" class="k-grid-page-all"></div>
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
    <div class="foot-bar col-buttom">
        <a id="BtnDelete"></a>
        <a id="BtnSave"></a>
        <a id="BtnSubmit"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/ConsignTransferInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ConsignTransferInfo.Init();
        });
    </script>
</asp:Content>
