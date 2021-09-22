﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ConsignContractInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Consign.ConsignContractInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="QryStatus" class="FrameControl" />
    <input type="hidden" id="InstanceId" class="FrameControl" />
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
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div id="IptApplyBasic" class="FrameControl"></div>
                            </div>
                            <div class="row">
                                <%--<div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-blank"></i>寄售合同编号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                         <i class="fa fa-fw fa-blank"></i>申请人
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptApplyPeople" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                         <i class="fa fa-fw fa-blank"></i>申请时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCreateDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-blank"></i>当前状态
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptStatus" class="FrameControl"></div>
                                    </div>
                                </div>--%>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                         <i class="fa fa-fw fa-require"></i>产品线
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptProductLine" class="FrameControl"></div>
                                    </div>
                                </div>
                                
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                         <i class="fa fa-fw fa-require"></i>经销商
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptDealer" class="FrameControl"></div>
                                    </div>
                                </div>
                                
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>合同名称
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptContractName" class="FrameControl"></div>
                                    </div>
                                </div>
                                
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>寄售天数
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptConsignmentDay" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>是否控制总金额
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptIsFixedMoney" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>可延迟次数
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptDelayNumber" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>控制总数量
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptIsFixedQty" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>自动补货
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptIsKB" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>合同时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptContractDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>有效期折扣规则
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptIsUseDiscount" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-group">
                                    <div class="col-xs-4 col-label col-3to1-4and8-label">
                                        <i class="fa fa-fw fa-blank"></i>备注	
                                    </div>
                                    <div class="col-xs-8 col-field col-3to1-4and8-field">
                                        <div id="IptRemark" class="FrameControl"></div>
                                    </div>
                                </div>
                                <%--<div class="col-xs-12 col-group">
                                    <div class="col-xs-4 col-label col-3to1-4and8-label">
                                        <i class="fa fa-fw fa-require"></i>附件	
                                    </div>
                                    <div class="col-xs-8 col-field col-3to1-4and8-field">
                                        <div id="IptRemark" class="FrameControl"></div>
                                    </div>
                                </div>--%>
                                
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
                                    <a id="BtnAddUpn"></a>
                                    <a id="BtnAddSet"></a>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstDetailList" class="k-grid-page-all"></div>
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
    <script type="text/javascript" src="Script/ConsignContractInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ConsignContractInfo.Init();
        });
    </script>
</asp:Content>
