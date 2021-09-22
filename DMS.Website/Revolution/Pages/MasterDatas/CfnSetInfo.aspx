<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="CfnSetInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.CfnSetInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">

    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        产品线
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptBu" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        成套产品UPN
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCFNSetUPN" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        成套产品中文名
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCFNSetChineseName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        成套产品英文名
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCFNSetEnglishName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        成套产品UOM
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCFNSetUOM" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        是否可订购
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCFNSetCanOrder" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        是否植入
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCFNSetImpant" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        是否工具
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCFNSetTool" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        是否共享
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCFNSetShare" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        注册证编号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCFNSetCINO" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        属性七
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCFNSetPT7" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        属性八
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCFNSetPT8" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group condition condition-upn">
                                    <div class="col-xs-2 col-label">
                                        产品描述
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="IptCFNSetDescription" class="FrameControl"></div>
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
                                <div class="col-buttom text-right" id="PnlDetailButton">
                                    <a id="BtnAddUpn"></a>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstDetailList" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
             <%--<div id="RstOperationLog" class="row">
            </div>--%>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom" id="PnlButton">
        <a id="BtnSave"></a>
        <a id="BtnClose"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/CfnSetInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            CfnSetInfo.Init();
        });
    </script>
</asp:Content>
