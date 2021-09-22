<%@ Page Title="退换货申请" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="InventoryReturnInfo.aspx.cs"
    Inherits="DMS.Website.Revolution.Pages.Inventory.InventoryReturnInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hiddIsModifyStatus" />
    <input type="hidden" id="IsNewApply" class="FrameControl" />
    <input type="hidden" id="hiddenReturnType" class="FrameControl" />
    <input type="hidden" id="QryAdjustType" class="FrameControl" />
    <input type="hidden" id="hiddenDealerId" class="FrameControl" />
    <input type="hidden" id="hiddenDealerType" class="FrameControl" />
    <input type="hidden" id="hiddenAdjustTypeId" class="FrameControl" />
    <input type="hidden" id="hiddenIsRsm" class="FrameControl" />
    <input type="hidden" id="hiddApplyType" class="FrameControl" />
    <input type="hidden" id="hiddenProductLineId" class="FrameControl" />
    <input type="hidden" id="hidSalesAccount" class="FrameControl" />
    <input type="hidden" id="hiddenReason" class="FrameControl" />
    <input type="hidden" id="hiddenWhmType" class="FrameControl" />
    <input type="hidden" id="InstanceId" class="FrameControl" />

    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;基本信息</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <%--                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div id="IptApplyBasic" class="FrameControl"></div>
                            </div>--%>
                            <div class="row">
                                <div class="col-xs-3">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            经销商
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryDealerWin" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>产品线
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryProductLineWin" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>备注
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryAdjustReasonWin" class="FrameControl"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-3">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            退换货单号
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryAdjustNumberWin" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            状态
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QrytAdjustStatusWin" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            审批意见
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryAduitNoteWin" class="FrameControl"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-3">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            退换货日期
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryAdjustDateWin" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            销售
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryRsm" class="FrameControl"></div>
                                        </div>
                                    </div>

<%--                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            销售
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QrySales" class="FrameControl"></div>
                                        </div>
                                    </div>--%>
                                </div>
                                <div class="col-xs-3">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-5 col-label">
                                            <i class="fa fa-fw fa-require"></i>
                                            退货类型
                                        </div>
                                        <div class="col-xs-7 col-field">
                                            <div id="QryApplyType" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-5 col-label">
                                            <i class="fa fa-fw fa-require"></i>
                                            请选择原因
                                        </div>
                                        <div class="col-xs-7 col-field">
                                            <div id="QryReturnReason" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-5 col-label">
                                            <i class="fa fa-fw fa-require"></i>
                                            退/换货要求
                                        </div>
                                        <div class="col-xs-7 col-field">
                                            <div id="QryReturnTypeWin" class="FrameControl"></div>
                                        </div>
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
                                <div class="col-buttom text-left" id="PnlDetailButton">
                                    <a id="BtnAddProduct"></a>
                                    <div class="col-xs-8 col-label" style="float: right; text-align: right;">
                                        <div id="ProductInstructions" class="FrameControl" style="display: inline-block;"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstProductDetail" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;附件</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div class="col-buttom text-left">
                                    <a id="BtnAddAttachment"></a>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstAttachmentDetail" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
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
        <a id="BtnRevoke"></a>
        <a id="BtnPushERP"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="/Revolution/Resources/js/Calculate.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript" src="Script/InventoryReturnInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            InventoryReturnInfo.Init();
        });
    </script>
</asp:Content>

