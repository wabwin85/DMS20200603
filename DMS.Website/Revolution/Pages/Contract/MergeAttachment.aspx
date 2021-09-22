<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="MergeAttachment.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Contract.MergeAttachment" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="HidContractId" class="FrameControl" />
    <input type="hidden" id="SelectAttachId" class="FrameControl" />
    <input type="hidden" id="HidContractType" class="FrameControl" />
    <input type="hidden" id="HidDealerType" class="FrameControl" />
    <input type="hidden" id="HidFileType" class="FrameControl" />
    <input type="hidden" id="HidFileExt" class="FrameControl" />
    <input type="hidden" id="HidOldType" class="FrameControl" />
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;附件上传</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstResultList" class="k-grid-page-20">
                                    <script type="text/x-kendo-template" id="templateOp"> 
                                        <!--<a id="btnConvertPdf" class="btn btn-primary pull-right fa fa-file-pdf-o" href="javascript:void(0);" onclick="MergeAttachment.ConvertPdf();">&nbsp;&nbsp;转换为PDF</a>-->                                   
                                        <a id="btnAddAttachment" class="btn btn-primary pull-right fa fa-upload" href="javascript:void(0);" onclick="MergeAttachment.InitUploadAttach();">&nbsp;&nbsp;上传附件</a>
                                        <a id="btnRefer" class="btn btn-primary pull-right fa fa-refresh" href="javascript:void(0);" onclick="MergeAttachment.Query();">&nbsp;&nbsp;刷新</a>                                     
                                    </script>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winAttachmentLayout" style="display:none;height:185px;">
        <style>
            #winAttachmentLayout .row {
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
                                    <input name="files" id="WinAttachmentUpload" type="file" aria-label="files" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winAttachInfoLayout" style="display:none;height:185px;">
        <style>
            #winAttachInfoLayout .row {
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
                                    附件名称：
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="WinAttachName" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-3 col-label">
                                    文件类型：
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="WinAttachType" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-3 col-label">
                                    上传时间：
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="WinUploadDate" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;text-align:center;" id="OpButton">
            <a id="BtnWinSave"></a>
            <a id="BtnWinCancel"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/MergeAttachment.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            MergeAttachment.Init();
        });
    </script>
</asp:Content>
