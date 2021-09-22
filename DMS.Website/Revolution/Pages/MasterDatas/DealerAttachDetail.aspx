<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="DealerAttachDetail.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.DealerAttachDetail" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="HidDealerId" class="FrameControl" />
    <input type="hidden" id="SelectAttachId" class="FrameControl" />
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-paperclip'></i>&nbsp;附件信息</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12 col-buttom">
                            <a id="BtnReturn"></a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;附件</h3>
                    </div>
                    <div class="box-header with-border">
                        <div class="col-xs-12 col-buttom">
                            <a id="BtnShowUpload"></a>
                        </div>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstAttachList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winUploadAttachLayout" style="display: none;height:93%;">
        <style>
            #winUploadAttachLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div>
                        <div class="row">
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-3 col-label">
                                    <i class='fa fa-fw fa-require'></i>文件类型：
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="WinFileType" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-3 col-label">
                                    <i class='fa fa-fw fa-require'></i>文件：
                                </div>
                                <div class="col-xs-8 col-field">
                                    <input name="files" id="WinFileUpload" type="file" aria-label="files" />
                                    <%--<div id="WinFileUpload" class="FrameControl"></div>--%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;text-align:center;" id="OpButton">
            <a id="BtnUploadAttach"></a>
            <a id="BtnClearAttach"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerAttachDetail.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            DealerAttachDetail.Init();
        });
    </script>
</asp:Content>
