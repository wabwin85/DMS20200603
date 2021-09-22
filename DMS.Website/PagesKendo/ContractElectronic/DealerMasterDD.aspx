<%@ Page Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="DealerMasterDD.aspx.cs" Inherits="DMS.Website.PagesKendo.InventoryReturn.InventoryReturnBsc" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
    </style>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="ContractID" class="FrameControl" />
    <input type="hidden" id="DeleteAttachmentID" class="FrameControl" />
    <input type="hidden" id="LastUpdateTime" class="FrameControl" />
    <input type="hidden" id="ForwardUrl" class="FrameControl" />
    <div class="content-main">
        <div id="PnlInventoryReturnBsc" style="position: absolute; width: 100%;">
            <div class="col-xs-12 content-row" style="padding: 10px 10px 0px 10px;">
                <div class="panel panel-primary" id="PnlBasic">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;DD信息</h3>
                    </div>
                    <div class="panel-body">
                        <table style="width: 100%;" class="KendoTable">
                            <tr>
                                <td style="width: 20%; padding: 0px; height: 1px;"></td>
                                <td style="padding: 0px; height: 1px;"></td>
                            </tr>
                            <tr id="TrDDReportName">
                                <td>DD报告名称</td>
                                <td>
                                    <div id="DDReportName" class="FrameControl CellInput" for="DDReportName" ></div>
                                </td>
                            </tr>
                            <tr id="TrDDStartDate">
                                <td> DD有效期</td>
                                <td>
                                    <div id="DDStartDate" class="FrameControl CellInput" for="DDStartDate" style="width:300px;"></div>
                                </td>
                            </tr>
                            <tr id="TrDDEndDate">
                                <td>DD有效结束日期</td>
                                <td>
                                    <div id="DDEndDate" class="FrameControl CellInput" for="DDEndDate" style="width:300px;"></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="panel panel-primary" id="PnlAttach">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;附件</h3>
                    </div>
                    <div class="panel-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div class="col-buttom text-left">
                                    <%--<a id="BtnAddAttachment"></a>--%>
                                    <button id="BtnAddAttachment" class="KendoButton size-14" style="margin:5px;display:none;background-color: #337ab7;"><i class='fa fa-upload'></i>&nbsp;&nbsp;添加附件</button>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstAttachmentDetail" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel panel-primary" id="PnlInfo">
                    <div class="panel-heading" >
                        <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;表单信息</h3>
                    </div>
                    <div class="panel-body" id="divReturnHtml">

                    </div>
                </div>
                <div class="col-xs-12 content-row" style="height: 41px;">
                    &nbsp;
                </div>
                <div class="col-xs-12 FooterBar" id="PnlRuleButton" >
                    <button id="BtnSave" class="KendoButton size-14" style="padding:0 10px;display:none;"><i class='fa fa-save'></i>&nbsp;&nbsp;保存</button>
                    <button id="BtnClose" class="KendoButton size-14" style="padding:0 10px;"><i class='fa fa-window-close-o'></i>&nbsp;&nbsp;返回</button>
                </div>
            </div>
            <div id="winUploadAttachLayout" style="display: none; border: 1px solid #ccc;">
                <style>
                    #winUploadAttachLayout .row {
                        margin: 0px;
                    }
                </style>
                <div class="row" style="width: 99%;">
                    <div class="box box-primary">
                        <div class="box-body">
                            <div>
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
                    <%--                    <div class="col-xs-12 col-buttom" style="width: 99%; text-align: center;" id="OpButton">
                        <a id="BtnUploadAttach"></a>
                        <a id="BtnClearAttach"></a>
                    </div>--%>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerMasterDDBsc.js?v=1.398"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            DealerMasterDDBsc.InitPage();
        });

    </script>
</asp:Content>
