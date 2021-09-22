<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ConsignmentTerminationInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Consign.ConsignmentTerminationInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="InstanceId" class="FrameControl" />
    <input type="hidden" id="QryStatus" class="FrameControl" />
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
                                        <i class="fa fa-fw fa-require"></i>经销商
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptDealer" class="FrameControl"></div>
                                    </div>
                                </div>
                                <%--<div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        合同名称
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptContractName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        合同开始时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptBeginDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        合同结束时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptEndDate" class="FrameControl"></div>
                                    </div>
                                </div>--%>
                                <%-- <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>终止编号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptTerminationNo" class="FrameControl"></div>
                                    </div>
                                </div>--%>
                                <div class="col-xs-12 col-group">
                                    <div class="col-xs-4 col-label col-3to1-4and8-label">
                                        <i class="fa fa-fw fa-require"></i>终止原因
                                    </div>
                                    <div class="col-xs-8 col-field col-3to1-4and8-field">
                                        <div id="IptReason" class="FrameControl"></div>
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
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;寄售合同信息</h3>
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
    <script type="text/javascript" src="Script/ConsignmentTerminationInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ConsignmentTerminationInfo.Init();
        });
    </script>
</asp:Content>
