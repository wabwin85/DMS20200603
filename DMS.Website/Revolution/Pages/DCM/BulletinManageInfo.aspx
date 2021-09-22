<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="BulletinManageInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.DCM.BulletinManageInfo" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="BulletId" class="FrameControl" />
    <input type="hidden" id="WinIsPageNew" />
    <input type="hidden" id="WinIsSaved" />
    <%--<input type="hidden" id="WinIsEmptyId" />--%>
    <input type="hidden" id="WinHdStatus" class="FrameControl" />
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-filter'></i>&nbsp;公告内容</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>重要性：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinUrgentDegree" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>状态：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinStatus" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        有效期：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinExpirationDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        是否必须确认：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinIsRead" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-xs-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        <i class='fa fa-fw fa-require'></i>标题：
                                    </div>
                                    <div class="col-xs-9 col-field">
                                        <div id="WinTitle" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-xs-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        <i class='fa fa-fw fa-require'></i>公告内容：
                                    </div>
                                    <div class="col-xs-9 col-field">
                                        <div id="WinBody" class="FrameControl"></div>
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
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;经销商列表</h3>
                        <div style="float:right;"><a id="BtnWinAddItem"></a></div>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstDealerDetailList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;附件列表</h3>
                        <div style="float:right;"><a id="BtnWinAddAttach"></a></div>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstAttachmentList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winFilterDealerLayout" style="display:none;height:480px;">
        <style>
            #winFilterDealerLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    经销商中文名：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinFilterDealer" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    经销商类别：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinFilterDealerType" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    ERP账号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinFilterSAPCode" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-11 col-buttom">
                                <a id="BtnFilterSearch"></a>
                                <a id="BtnFilterSave"></a>
                                <a id="BtnFilterCancel"></a>
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
                                <div id="RstFilterDealerResult" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winAttachLayout" style="display:none;height:185px;">
        <style>
            #winAttachLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div>
                        <div class="row">
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-3 col-label">
                                    <i class='fa fa-fw fa-require'></i>文件：
                                </div>
                                <div class="col-xs-8 col-field">
                                    <input name="files" id="WinAttachUpload" type="file" aria-label="files" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom">
        <a id="BtnWinPublished"></a>
        <a id="BtnWinSaveDraft"></a>
        <a id="BtnWinCancelled"></a>
        <a id="BtnWinDelDraft"></a>
        <a id="BtnWinCancel"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/BulletinManageInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(function () {
            BulletinManageInfo.InitDetail();
        });
    </script>
</asp:Content>
