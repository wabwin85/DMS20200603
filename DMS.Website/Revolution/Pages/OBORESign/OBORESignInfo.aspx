<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="OBORESignInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.OBORESign.OBORESignInfo" %>

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
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;主要信息</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div id="IptApplyBasic" class="FrameControl"></div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-blank"></i>协议编号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptAgreementNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>Bu
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptBu" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>Sub-Bu
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptSubBu" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-blank"></i>物流平台
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptSignA" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-require"></i>经销商
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptSignB" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-blank"></i>申请人
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCreateUser" class="FrameControl"></div>
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

                                <div class="col-xs-12 col-sm-6 col-md-4 col-group" id="Upload">
                                    <div class="col-xs-4 col-label">
                                        <i class="fa fa-fw fa-blank"></i>附件上传
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="PnlDealerImport" class="FrameControl"></div>
                                    </div>
                                </div>

                                <%--  <div class="col-xs-8 col-field col-3to1-4and8-field">
                                        <div id="PnlDealerImport"></div>
                                </div>--%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;签章协议附件</h3>

                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">

                            <div class="row">
                                <div id="RstDetailList" class="k-grid-page-all"></div>
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
        <a id="BtnSign"></a>
        <a id="BtnSave"></a>
        <a id="BtnSubmit"></a>
        <a id="BtnDelete"></a>
        <a id="BtnDownload"></a>
        <a id="BtnRevoke"></a>
        <a id="BtnReturn"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/OBORESignInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            OBORESignInfo.Init();
        });
    </script>
</asp:Content>
