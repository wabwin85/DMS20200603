<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="DealerMaintainList.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.DealerMaintainList" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .DetailTab {
            margin:0 auto;
            width:96%;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="HosID" class="FrameControl" />
    <input type="hidden" id="SelectDealerId" class="FrameControl" />
    <input type="hidden" id="SelectSAPNo" class="FrameControl" />
    <input type="hidden" id="SelectDealerType" class="FrameControl" />
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
                                        经销商中文名称：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDealerName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商类型：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDealerType" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        ERP账号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QrySAPNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        地址：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDealerAddress" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-xs-12 col-buttom">
                                    <a id="BtnQuery"></a>
                                    <a id="BtnExport"></a>
                                    <a id="BtnExportAuthorize"></a>
                                    <a id="BtnExportAuthorizeHos"></a>
                                    <a id="BtnExportLicense"></a>
                                    <a id="BtnRefreshDealerCache"></a>
                                    <a id="BtnNew"></a>
                                    <a id="BtnDelete"></a>
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
    <div id="winDealerChangeNameLayout" style="display: none;">
        <style>
            #winDealerChangeNameLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div>
                        <div class="row">
                            <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-md-4 col-label">
                                    原经销商名称：
                                </div>
                                <div class="col-xs-8 col-md-6 col-field">
                                    <div id="WinOldCName" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-md-4 col-label">
                                    新经销商名称：
                                </div>
                                <div class="col-xs-8 col-md-6 col-field">
                                    <div id="WinNewCName" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="divEName">
                            <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-md-4 col-label">
                                    原英文名称：
                                </div>
                                <div class="col-xs-8 col-md-6 col-field">
                                    <div id="WinOldEName" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-md-4 col-label">
                                    新英文名称：
                                </div>
                                <div class="col-xs-8 col-md-6 col-field">
                                    <div id="WinNewEName" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;" id="OpButton">
            <a id="BtnSaveDealerChangeName"></a>
            <a id="BtnCloseDealerChangeName"></a>
        </div>
    </div>
    <div id="winDealerInfoLayout" style="display: none;">
        <style>
            #winDealerInfoLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;查询结果</h3>
                </div>
                <div class="box-body">
                    <div>
                        <div class="row">
                            <div id="MaintainDealerInfoList" class="k-grid-page-20"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;" id="PnlButton">
            <a id="BtnCloseDealerInfo"></a>
        </div>
    </div>
    <div id="winLCDetailLayout" style="display:none;height:95%">
        <style>
            #winLCDetailLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:99%;display:inline-block;">
            <div class="box box-primary">
                <div class="box-body">
                    <div class="col-xs-11">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    企业负责人：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinLCHeadOfCorp" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    法人代表：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinLCLegalRep" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group" style="border:1px #d5d5d5 solid;">
                                <div class="row">
                                    <h5 class="box-title">医疗器械经营许可证信息</h5>
                                </div>
                                <div class="row">
                                    <div class="col-xs-4 col-label">
                                        证件编号：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCLicenseNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-4 col-label">
                                        起始日期：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCLicenseStart" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-4 col-label">
                                        结束日期：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCLicenseEnd" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group" style="border:1px #d5d5d5 solid;">
                                 <div class="row">
                                     <h5 class="box-title">医疗器械备案凭证信息</h5>
                                 </div>
                                 <div class="row">
                                    <div class="col-xs-4 col-label">
                                        证件编号：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCRecordNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-4 col-label">
                                        起始日期：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCRecordStart" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-4 col-label">
                                        结束日期：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCRecordEnd" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" style="width:99%;display:inline-block;">
            <div id="DivLCBasicInfo" style="border: 0;">
                <ul>
                    <li class="k-state-active">ShipTo地址
                    </li>
                    <li>二类医疗器械产品分类
                    </li>
                    <li>三类医疗器械产品分类
                    </li>
                    <li>附件
                    </li>
                </ul>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="row">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-truck'></i>&nbsp;ShipTo地址</h3>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCAddressList" class="k-grid-page-20"></div>
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
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;2002版二类医疗器械产品分类</h3>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCProductList202" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;2017版二类医疗器械产品分类</h3>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCProductList217" class="k-grid-page-20"></div>
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
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;2002版三类医疗器械产品分类</h3>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCProductList302" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;2017版三类医疗器械产品分类</h3>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCProductList317" class="k-grid-page-20"></div>
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
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-paperclip'></i>&nbsp;附件列表</h3>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCAttachList" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" style="width:99%;display:inline-block;">
            <div class="col-xs-12 col-buttom" style="padding:0px 5px;">
                <a id="BtnWinClose"></a>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerMaintainList.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            DealerMaintainList.Init();
        });
    </script>
</asp:Content>
