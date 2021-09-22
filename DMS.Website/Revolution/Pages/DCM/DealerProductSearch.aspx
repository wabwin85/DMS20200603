<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="DealerProductSearch.aspx.cs" Inherits="DMS.Website.Revolution.Pages.DCM.DealerProductSearch" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .DetailTab {
            margin:0 auto;
            width:94%;
            height:395px;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hidCfnId" class="FrameControl" />
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-filter'></i>&nbsp;查询条件</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品线：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryProductLine" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品型号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryCFN" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
<%--                            <div class="row" style="display:none;">
                                <label style="color:#FF0000;">
                                    如您在查询信息过程中有任何疑问或问题，可以通过以下几个途径进行反馈，我们将尽快予以回复。感谢您一直以来的支持。<br/> 1 网页链接：<a href='http://bsci.udesk.cn/im_client/?web_plugin_id=37827' target='_blank'>http://bsci.udesk.cn/im_client/?web_plugin_id=37827</a> <br/>2 物联网：左下角菜单“智能客服” <br/>3 服务入微：中间菜单“渠道工具-智能客服”<br/>4 企业质量与运营公众号：右下角菜单“客户支持-智能客服”<br/><br/>注：以上4种入口进入后，可先尝试通过自主查询的方式，输入问题/关键字获取帮助，省去等待时间。如无法从常用问题中找寻到答案，可通过转人工方式留言反馈您的问题和需求，我们将尽快核实并予以回复。谢谢！
                                </label>
                            </div>--%>
                            <div class="row">
                                <div class="col-xs-12 col-buttom" id="PnlButton">
                                    <a id="BtnQuery"></a>
                                    <a id="BtnExportProduct"></a>
                                    <%--<a id="BtnDownload"></a>--%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;查询结果</h3>
                        <%--<div style="float:right;"><a id="BtnHelp"></a></div>--%>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstResultList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winHelpLayout" style="display:none;height:155px;">
        <style>
            #winHelpLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div>
                        <div class="row">
                            <label>如无法下载注册证，请确认一下设置并重试：</label><br />
                            <label>1. 建议使用IE 或者 Chrome（谷歌）浏览器打开本网站。</label><br />
                            <label>2. 查看IE设置，确认IE没有设定“阻止弹出窗口”。</label><br />
                            <label>3. 确认IE没有安装恶意拦截插件。</label><br />
                            <label>4. 升级IE到9.0以上版本。</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;text-align:center;">
            <a id="BtnWinCloseHelp"></a>
        </div>
    </div>
    <div id="winRegistrationLayout" style="display:none;height:470px;">
        <style>
            #winRegistrationLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:100%;margin:0 auto;display:inline-block;">
            <div id="DivRgstBasicInfo" style="border: 0;">
                <ul>
                    <li class="k-state-active">注册证
                    </li>
                    <li>报关单
                    </li>
                    <li>注册证（新）
                    </li>
                    <li>报关单（新）
                    </li>
                </ul>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="box box-primary">
                            <div class="box-body" style="padding: 0px;">
                                <div class="col-xs-12" style="padding: 0px;">
                                    <div class="row">
                                        <div id="RstWinRegistration" class="k-grid-page-20"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="row">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                        <div class="col-xs-4 col-label">
                                            产品批号：
                                        </div>
                                        <div class="col-xs-7 col-field">
                                            <div id="WinProductLot" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                        <a id="BtnWinSearch"></a>
                                    </div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstWinRegistrationBylot" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="box box-primary">
                            <div class="box-body" style="padding: 0px;">
                                <div class="col-xs-12" style="padding: 0px;">
                                    <div class="row">
                                        <div id="RstWinRegistrationNew" class="k-grid-page-20"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品批号：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinProductLotNew" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <a id="BtnWinSearchNew"></a>
                                </div>
                            </div>
                            <div class="box-body" style="padding: 0px;">
                                <div class="col-xs-12" style="padding: 0px;">
                                    <div class="row">
                                        <div id="RstWinRegistrationBylotNew" class="k-grid-page-20"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" style="width:98%;margin:0 auto;display:inline-block;">
            <div class="col-xs-12 col-buttom" style="padding:0px 5px;">
                <a id="BtnWinCloseRegistration"></a>
            </div>
        </div>
    </div>
    <div id="winCFNDetailLayout" style="display:none;height:470px;">
        <style>
            #winCFNDetailLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:100%;margin:0 auto;display:inline-block;">
            <div id="DivDtlBasicInfo" style="border: 0;">
                <ul>
                    <li class="k-state-active">产品信息
                    </li>
                    <li>描述
                    </li>
                </ul>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="box box-primary">
                            <div class="box-body" style="padding: 0px;">
                                <div class="col-xs-12" style="padding: 0px;">
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                产品ID：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinDetailID" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                产品线：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinProductLineName" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                产品分类：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinPCTName" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                产品分类英文名：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinPCTEnglishName" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                产品型号：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinCustomerFaceNbr" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                英文说明：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinEnglishName" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                中文说明：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinChineseName" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                是否植入：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinImplant" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                是否工具：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinTool" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                是否共享：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinShare" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                描述：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinDescription" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="row">
                            <div class="box box-primary">
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                                <div class="col-xs-4 col-label">
                                                    安全库存所需分类：
                                                </div>
                                                <div class="col-xs-7 col-field">
                                                    <div id="WinProperty1" class="FrameControl"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                                <div class="col-xs-4 col-label">
                                                    是否寄售产品：
                                                </div>
                                                <div class="col-xs-7 col-field">
                                                    <div id="WinProperty2" class="FrameControl"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                                <div class="col-xs-4 col-label">
                                                    包装单位：
                                                </div>
                                                <div class="col-xs-7 col-field">
                                                    <div id="WinProperty3" class="FrameControl"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                                <div class="col-xs-4 col-label">
                                                    是否可下定单：
                                                </div>
                                                <div class="col-xs-7 col-field">
                                                    <div id="WinProperty4" class="FrameControl"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                                <div class="col-xs-4 col-label">
                                                    注册证编号：
                                                </div>
                                                <div class="col-xs-7 col-field">
                                                    <div id="WinProperty5" class="FrameControl"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                                <div class="col-xs-4 col-label">
                                                    是否CRM产品：
                                                </div>
                                                <div class="col-xs-7 col-field">
                                                    <div id="WinProperty6" class="FrameControl"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                                <div class="col-xs-4 col-label">
                                                    属性七：
                                                </div>
                                                <div class="col-xs-7 col-field">
                                                    <div id="WinProperty7" class="FrameControl"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                                <div class="col-xs-4 col-label">
                                                    属性八：
                                                </div>
                                                <div class="col-xs-7 col-field">
                                                    <div id="WinProperty8" class="FrameControl"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" style="width:98%;margin:0 auto;display:inline-block;">
            <div class="col-xs-12 col-buttom" style="padding:0px 5px;">
                <a id="BtnWinCloseDetail"></a>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerProductSearch.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(function () {
            DealerProductSearch.Init();
        });
    </script>
</asp:Content>
