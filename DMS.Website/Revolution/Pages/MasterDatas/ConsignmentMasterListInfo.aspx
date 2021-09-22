<%@ Page Title="寄售申请" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ConsignmentMasterListInfo.aspx.cs"
    Inherits="DMS.Website.Revolution.Pages.MasterDatas.ConsignmentMasterListInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hidOrderType" class="FrameControl" />
    <input type="hidden" id="hidLatestAuditDate" class="FrameControl" />
    <input type="hidden" id="hidDealerId" class="FrameControl" />
    <input type="hidden" id="QryStatus" class="FrameControl" />
    <input type="hidden" id="InstanceId" class="FrameControl" />
    <input type="hidden" id="ProductLineId" class="FrameControl" />
    <input type="hidden" id="IsNewApply" class="FrameControl" />
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
                                        近效期规则
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryApplyType" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>产品线
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryBu" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        提交时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QrySubmitDate" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        规则单据号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryOrderNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        单据状态
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryOrderStatus" class="FrameControl"></div>
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
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;申请单主信息</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-6">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>寄售规则名称
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryRuleName" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>选择寄售天数
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryRuleDays" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-12 col-group" style="display: none">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>寄售天数
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryCustomRuleDays" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                <div class="col-xs-4 col-label">
                                    备注
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryRemark" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-6">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>时间
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryBeginDate" class="FrameControl"></div>
                                </div>
                            </div>
                            <%--                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>结束时间
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryEndDate" class="FrameControl"></div>
                                </div>
                            </div>--%>
                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>可延期次数
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryDelayTimes" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;经销商列表</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div class="col-buttom text-left">
                                    <a id="BtnDealerAdd"></a>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstDealerList" class="k-grid-page-all"></div>
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
                                    <a id="BtnAddComProduct"></a>
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
        <a id="BtnRevoke"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/ConsignmentMasterListInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ConsignmentMasterListInfo.Init();
        });
    </script>
</asp:Content>
