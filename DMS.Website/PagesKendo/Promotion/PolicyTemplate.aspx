<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="PolicyTemplate.aspx.cs" Inherits="DMS.Website.PagesKendo.Promotion.PolicyTemplate" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .PolicyTab {
            margin: 0 !important;
            border-left: 0px !important;
            border-right: 0px !important;
        }

        .Pointer {
            position: static;
            border-right-color: #d9edf7;
            border-width: 10px;
        }

        .PointerNone {
            border-right-color: #FFF !important;
        }

        .edit {
            cursor: pointer;
        }

            .edit .fa-pencil {
                color: #003b6f;
            }

        .general {
            display: inline-flex;
        }

        .filled {
            border: 1px dashed #003b6f;
            padding: 0px 2px;
        }

        .empty {
            border: 1px dashed red;
            width: 100px;
            height: 25px;
            background: red;
            position: relative;
            background-image: -webkit-linear-gradient(left, #F08C8C, #FFFFFF 25%, #F08C8C 50%, #FFFFFF 75%, #F08C8C);
            -webkit-background-clip: padding-box;
            -webkit-background-size: 200% 100%;
            -webkit-animation: empty-animation 4s infinite linear;
        }

        @-webkit-keyframes empty-animation {
            0% {
                background-position: 0 0;
            }

            100% {
                background-position: -100% 0;
            }
        }

        li {
            padding: 2px;
        }

        .editable {
            margin-top: 0px;
            margin-bottom: 0px;
            position: fixed;
            bottom: 50px;
            width: -moz-calc(100% - 20px);
            width: -webkit-calc(100% - 20px);
            width: calc(100% - 20px);
            padding: 0px;
            display: none;
        }

        .gridtable {
            font-size: 14px;
            border-width: 1px;
            border-color: #337ab7;
            width: 100%;
        }

            .gridtable th {
                border-width: 1px;
                padding: 2px 5px 2px 5px;
                border-style: solid;
                border-color: #337ab7;
                background-color: #d9ecf5;
                text-align: right;
                width: 30%;
            }

            .gridtable td {
                border-width: 1px;
                padding: 2px 5px 2px 5px;
                border-style: solid;
                border-color: #337ab7;
                background-color: #ffffff;
                text-align: left;
            }

        div.des {
            word-break: break-all;
            font-size: 11px;
            line-height: 22px;
            width: 100%;
            height: auto;
            border: solid 1px #337ab7;
            text-align: left;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="IptPolicyId" class="FrameControl" />
    <input type="hidden" id="IptPageType" class="FrameControl" />
    <input type="hidden" id="IptPolicyStyle" class="FrameControl" />
    <input type="hidden" id="IptPolicyStyleSub" class="FrameControl" />
    <input type="hidden" id="IptPromotionState" class="FrameControl" />
    <input type="hidden" id="IptProductLine" class="FrameControl" />
    <div class="content-main">
        <div class="col-xs-12 content-row" style="padding: 10px 10px 0px 10px;" id="PnlEdit">
            <div class="panel panel-primary" style="margin-bottom: 0px;">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;政策概要</h3>
                </div>
                <div class="panel-body" style="padding: 0px;">
                    <div id="PnlSummary" style="height: 100%; overflow-y: auto; padding: 10px;">
                    </div>
                </div>
            </div>
            <div class="panel panel-primary editable" style="height: 301px;" id="PnlBasic">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;基本信息</h3>
                </div>
                <div class="panel-body" id="PnlBasicEdit" style="padding: 10px; height: 261px;">
                    <table style="width: 100%;" class="table-info">
                        <tr>
                            <td style="width: 60%; vertical-align: top;">
                                <table style="width: 100%;" class="KendoTable">
                                    <tr>
                                        <td style="width: 30%; padding: 0px; height: 1px;"></td>
                                        <td style="padding: 0px; height: 1px;"></td>
                                        <td style="width: 10px; padding: 0px; height: 1px;"></td>
                                    </tr>
                                    <tr id="TrPolicyNo" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;">
                                        <td><i class='fa fa-fw fa-blank'></i>&nbsp;政策编号</td>
                                        <td>
                                            <div id="IptPolicyNo" class="FrameControl" data-for="PolicyNo" data-group="Basic"></div>
                                        </td>
                                        <td style="padding: 0px;">
                                            <div class="k-callout k-callout-w Pointer PointerNone" data-for="PolicyNo"></div>
                                        </td>
                                    </tr>
                                    <tr id="TrPolicyName" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;">
                                        <td><i class='fa fa-fw fa-require'></i>&nbsp;政策名称</td>
                                        <td>
                                            <div id="IptPolicyName" class="FrameControl CellInput" data-for="PolicyName" data-group="Basic"></div>
                                        </td>
                                        <td style="padding: 0px;">
                                            <div class="k-callout k-callout-w Pointer PointerNone" data-for="PolicyName"></div>
                                        </td>
                                    </tr>
                                    <tr id="TrPolicyGroupName" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;">
                                        <td><i class='fa fa-fw fa-blank'></i>&nbsp;归类名称</td>
                                        <td>
                                            <div id="IptPolicyGroupName" class="FrameControl CellInput" data-for="PolicyGroupName" data-group="Basic"></div>
                                        </td>
                                        <td style="padding: 0px;">
                                            <div class="k-callout k-callout-w Pointer PointerNone" data-for="PolicyGroupName"></div>
                                        </td>
                                    </tr>
                                    <tr id="TrBeginDate" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;">
                                        <td><i class='fa fa-fw fa-require'></i>&nbsp;开始时间</td>
                                        <td>
                                            <div id="IptBeginDate" class="FrameControl CellInput" data-for="BeginDate" data-group="Basic"></div>
                                        </td>
                                        <td style="padding: 0px;">
                                            <div class="k-callout k-callout-w Pointer PointerNone" data-for="BeginDate"></div>
                                        </td>
                                    </tr>
                                    <tr id="TrEndDate" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;">
                                        <td><i class='fa fa-fw fa-require'></i>&nbsp;结束时间</td>
                                        <td>
                                            <div id="IptEndDate" class="FrameControl CellInput" data-for="EndDate" data-group="Basic"></div>
                                        </td>
                                        <td style="padding: 0px;">
                                            <div class="k-callout k-callout-w Pointer PointerNone" data-for="EndDate"></div>
                                        </td>
                                    </tr>
                                    <tr id="TrPeriod" class="CXZP GDJF BFBJF BCJF" style="display: none;">
                                        <td><i class='fa fa-fw fa-require'></i>&nbsp;结算周期</td>
                                        <td>
                                            <div id="IptPeriod" class="FrameControl CellInput" data-for="Period" data-group="Basic"></div>
                                        </td>
                                        <td style="padding: 0px;">
                                            <div class="k-callout k-callout-w Pointer PointerNone" data-for="Period"></div>
                                        </td>
                                    </tr>
                                    <tr id="TrAcquisition" class="CXZP GDJF BFBJF BCJF" style="display: none;">
                                        <td><i class='fa fa-fw fa-require'></i>&nbsp;计入返利与达成</td>
                                        <td>
                                            <div id="IptAcquisition" class="FrameControl CellInput" data-for="Acquisition" data-group="Basic"></div>
                                        </td>
                                        <td style="padding: 0px;">
                                            <div class="k-callout k-callout-w Pointer PointerNone" data-for="Acquisition"></div>
                                        </td>
                                    </tr>
                                    <tr id="TrPointValidDateType" class="GDJF BFBJF BCJF" style="display: none;">
                                        <td><i class='fa fa-fw fa-require'></i>&nbsp;经销商积分效期</td>
                                        <td>
                                            <div id="IptPointValidDateType" class="FrameControl CellInput" data-for="PointValidDateType" data-group="Basic"></div>
                                        </td>
                                        <td style="padding: 0px;">
                                            <div class="k-callout k-callout-w Pointer PointerNone" data-for="PointValidDateType"></div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="width: 40%; background-color: #d9edf7; padding: 10px; vertical-align: top; border-radius: 5px;">
                                <div id="IptDescBasic"></div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="panel panel-primary editable" style="height: 151px;" id="PnlDealer">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;适用经销商</h3>
                </div>
                <div class="panel-body" id="PnlDealerEdit" style="padding: 10px; height: 111px;">
                    <table style="width: 100%;" class="table-info">
                        <tr>
                            <td style="width: 60%; vertical-align: top;">
                                <table style="width: 100%;" class="KendoTable">
                                    <tr>
                                        <td style="width: 30%; padding: 0px; height: 1px;"></td>
                                        <td style="padding: 0px; height: 1px;"></td>
                                        <td style="width: 10px; padding: 0px; height: 1px;"></td>
                                    </tr>
                                    <tr id="TrProTo" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;">
                                        <td><i class='fa fa-fw fa-require'></i>&nbsp;结算对象</td>
                                        <td>
                                            <div id="IptProTo" class="FrameControl CellInput" data-for="ProTo" data-group="Dealer"></div>
                                        </td>
                                        <td style="padding: 0px;">
                                            <div class="k-callout k-callout-w Pointer PointerNone" data-for="ProTo"></div>
                                        </td>
                                    </tr>
                                    <tr id="TrProToType" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;">
                                        <td><i class='fa fa-fw fa-require'></i>&nbsp;结算经销商维护</td>
                                        <td>
                                            <div id="IptProToType" class="FrameControl CellInput" data-for="ProToType" data-group="Dealer"></div>
                                        </td>
                                        <td style="padding: 0px;">
                                            <div class="k-callout k-callout-w Pointer PointerNone" data-for="ProToType"></div>
                                        </td>
                                    </tr>
                                    <tr id="TrBtnProToType" style="display: none;">
                                        <td></td>
                                        <td>
                                            <button style="width: 100%;" id="BtnProToType" class="KendoButton"><i class='fa fa-wrench'></i>&nbsp;&nbsp;维护</button>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="width: 40%; background-color: #d9edf7; padding: 10px; vertical-align: top; border-radius: 5px;">
                                <div id="IptDescDealer" style="overflow-y: auto; height: 71px;"></div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="panel panel-primary editable" style="height: 205px;" id="PnlFactor">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;参数列表</h3>
                </div>
                <div class="panel-body" id="PnlFactorEdit" style="padding: 0px; height: 165px;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="text-align: right; vertical-align: middle; float: right; width: 100%; height: 45px; line-height: 45px; border: 0px; border-bottom: solid 1px #a3d0e4;">
                                <button id="BtnAddFactor" class="KendoButton size-14" style="margin-right: 5px;"><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</button>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="RstFactorList" style="border-width: 0px;"></div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="panel panel-primary editable" style="height: 245px;" id="PnlRule">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;规则列表</h3>
                </div>
                <div class="panel-body" id="PnlRuleEdit" style="padding: 0px; height: 205px;">
                    <div style="background-color: #F2DEDE; color: #A94442; padding: 0; margin: 0; height: 40px; line-height: 40px; text-align: left;">
                        &nbsp;&nbsp;&nbsp;&nbsp; <b>备注</b>：如果促销包含多个不同的赠送力度，请在以下步骤中通过点击【<b>新增规则</b>】逐一维护每一条赠送规则
                    </div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="text-align: right; vertical-align: middle; float: right; width: 100%; height: 45px; line-height: 45px; border: 0px; border-bottom: solid 1px #a3d0e4;">
                                <button id="BtnAddRule" class="KendoButton size-14" style="margin-right: 5px;"><i class='fa fa-plus'></i>&nbsp;&nbsp;新增规则</button>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="RstRuleList" style="border-width: 0px;"></div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="panel panel-primary editable" style="height: 205px;" id="PnlAttachment">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;附件列表</h3>
                </div>
                <div class="panel-body" id="PnlAttachmentEdit" style="padding: 0px; height: 165px;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="text-align: right; vertical-align: middle; float: right; width: 100%; height: 45px; line-height: 45px; border: 0px; border-bottom: solid 1px #a3d0e4;">
                                <button id="BtnAddAttachment" class="KendoButton size-14" style="margin-right: 5px;"><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</button>
                                <div style="display: none;">
                                    <input type="file" id="BtnOpenAttachment" style="display: none;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="RstAttachmentList" style="border-width: 0px;"></div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-xs-12 content-row" style="padding: 10px; width: 100%; height: 100%; display: none; overflow-y:auto;" id="PnlPreview">
            <div id="PnlPreviewContent" style="overflow-y: auto; padding: 10px;">
            </div>
        </div>
    </div>
    <div class="col-xs-12" style="height: 40px; line-height: 40px; text-align: right; position: fixed; bottom: 0px; background-color: #f5f5f5; border-top: solid 1px #ccc;" id="PnlButton">
        <button id="BtnAdvance" class="KendoButton size-14 policyButton policySummary"><i class='fa fa-exchange'></i>&nbsp;&nbsp;高级模式</button>
        <button id="BtnPreview" class="KendoButton size-14 policyButton policySummary"><i class='fa fa-file-code-o'></i>&nbsp;&nbsp;预览</button>
        <button id="BtnSave" class="KendoButton size-14 policyButton policyBasic policyDealer"><i class='fa fa-save'></i>&nbsp;&nbsp;保存</button>
        <button id="BtnReturn" class="KendoButton size-14 policyButton policyBasic policyDealer policyFactor policyRule policyAttachment"><i class='fa fa-reply'></i>&nbsp;&nbsp;返回</button>
        <button id="BtnSubmit" class="KendoButton size-14 policyButton policyPreview"><i class='fa fa-external-link-square'></i>&nbsp;&nbsp;提交</button>
        <button id="BtnBack" class="KendoButton size-14 policyButton policyPreview"><i class='fa fa-pencil'></i>&nbsp;&nbsp;返回</button>
        <button id="BtnClose" class="KendoButton size-14"><i class='fa fa-window-close-o'></i>&nbsp;&nbsp;关闭</button>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/PolicyTemplate.js?v=1.27"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            PolicyTemplate.InitPage();
        });
    </script>
</asp:Content>
