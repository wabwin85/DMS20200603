<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="PolicyTemplateInfo.aspx.cs" Inherits="DMS.Website.PagesKendo.Promotion.PolicyTemplateInfo" %>

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
    <div class="content-main">
        <div class="col-xs-12 content-row" style="padding: 0px;">
            <div id="PnlPolicy" style="border: 0; background-color: #DFE8F6;">
                <ul>
                    <li class="TabStep" data-step="0">政策概要
                    </li>
                    <li class="TabStep" data-step="1">政策参数
                    </li>
                    <li class="TabStep" data-step="2">促销规则
                    </li>
                    <li class="TabStep" data-step="3">预览
                    </li>
                </ul>
                <div class="PolicyTab" style="padding: 0px;">
                    <div class="panel panel-primary" style="margin: 10px;" id="PnlBasic">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;政策基本参数</h3>
                        </div>
                        <div class="panel-body">
                            <table style="width: 100%;" class="table-info">
                                <tr>
                                    <td style="width: 60%; vertical-align: top;">
                                        <table style="width: 100%;" class="KendoTable">
                                            <tr>
                                                <td style="width: 30%; padding: 0px; height: 1px;"></td>
                                                <td style="padding: 0px; height: 1px;"></td>
                                                <td style="width: 10px; padding: 0px; height: 1px;"></td>
                                            </tr>
                                            <tr id="TrProductLine" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;产品线</td>
                                                <td>
                                                    <div id="IptProductLine" class="FrameControl CellInput" data-for="ProductLine" data-group="Basic"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="ProductLine"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrTemplateName" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;模板名称</td>
                                                <td>
                                                    <div id="IptTemplateName" class="FrameControl CellInput" data-for="TemplateName" data-group="Basic"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="TemplateName"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrPolicyDesc" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;模板描述</td>
                                                <td>
                                                    <div id="IptPolicyDesc" class="FrameControl CellInput" data-for="PolicyDesc" data-group="Basic"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="PolicyDesc"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrProTo" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;结算对象</td>
                                                <td>
                                                    <div id="IptProTo" class="FrameControl CellInput" data-for="ProTo" data-group="Basic"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="ProTo"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrProToType" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;结算经销商维护</td>
                                                <td>
                                                    <div id="IptProToType" class="FrameControl CellInput" data-for="ProToType" data-group="Basic"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="ProToType"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrPeriod" class="CXZP GDJF BFBJF BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;结算周期</td>
                                                <td>
                                                    <div id="IptPeriod" class="FrameControl CellInput" data-for="Period" data-group="Basic"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="Period"></div>
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
                    <div class="panel panel-primary" style="margin: 10px;" id="PnlCalc">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;计算方式参数</h3>
                        </div>
                        <div class="panel-body">
                            <table style="width: 100%;" class="table-info">
                                <tr>
                                    <td style="width: 60%; vertical-align: top;">
                                        <table style="width: 100%;" class="KendoTable">
                                            <tr>
                                                <td style="width: 30%; padding: 0px; height: 1px;"></td>
                                                <td style="padding: 0px; height: 1px;"></td>
                                                <td style="width: 10px; padding: 0px; height: 1px;"></td>
                                            </tr>
                                            <tr id="TrPolicyType" class="CXZP GDJF BFBJF BCJF SZP DZ" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;促销计算基数</td>
                                                <td>
                                                    <div id="IptPolicyType" class="FrameControl CellInput" data-for="PolicyType" data-group="Calc"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="PolicyType"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrMinusLastGift" class="CXZP GDJF BFBJF BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;扣除上期赠品</td>
                                                <td>
                                                    <div id="IptMinusLastGift" class="FrameControl CellInput" data-for="MinusLastGift" data-group="Calc"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="MinusLastGift"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrIncrement" class="CXZP GDJF BFBJF BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;增量计算</td>
                                                <td>
                                                    <div id="IptIncrement" class="FrameControl CellInput" data-for="Increment" data-group="Calc"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="Increment"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrMjRatio" class="BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;特殊折价率</td>
                                                <td>
                                                    <div id="IptMjRatio" class="FrameControl CellInput" data-for="MjRatio" data-group="Calc"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="MjRatio"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrAddLastLeft" class="CXZP" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;累计上期余量</td>
                                                <td>
                                                    <div id="IptAddLastLeft" class="FrameControl CellInput" data-for="AddLastLeft" data-group="Calc"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="AddLastLeft"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrYtdOption" class="CXZP GDJF BFBJF BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-blank'></i>&nbsp;年度 /YTD完成追溯</td>
                                                <td>
                                                    <div id="IptYtdOption" class="FrameControl CellInput" data-for="YtdOption" data-group="Calc"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="YtdOption"></div>
                                                </td>
                                            </tr>

                                        </table>
                                    </td>
                                    <td style="width: 40%; background-color: #d9edf7; padding: 10px; vertical-align: top; border-radius: 5px;">
                                        <div id="IptDescCalc"></div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="panel panel-primary" style="margin: 10px;" id="PnlGift">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;赠送结果判断与使用</h3>
                        </div>
                        <div class="panel-body">
                            <table style="width: 100%;" class="table-info">
                                <tr>
                                    <td style="width: 60%; vertical-align: top;">
                                        <table style="width: 100%;" class="KendoTable">
                                            <tr>
                                                <td style="width: 30%; padding: 0px; height: 1px;"></td>
                                                <td style="padding: 0px; height: 1px;"></td>
                                                <td style="width: 10px; padding: 0px; height: 1px;"></td>
                                            </tr>
                                            <tr id="TrTopType" class="CXZP GDJF BFBJF BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-blank'></i>&nbsp;封顶类型</td>
                                                <td>
                                                    <div id="IptTopType" class="FrameControl CellInput" data-for="TopType" data-group="Gift"></div>
                                                </td>
                                                <td style="padding:0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="TopType"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrTopValue" class="CXZP GDJF BFBJF BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;封顶值</td>
                                                <td>
                                                    <div id="IptTopValue" class="FrameControl CellInput" data-for="TopValue" data-group="Gift"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="TopValue"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrCarryType" class="CXZP GDJF BFBJF BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;进位方式</td>
                                                <td>
                                                    <div id="IptCarryType" class="FrameControl CellInput" data-for="CarryType" data-group="Gift"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="CarryType"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrAcquisition" class="CXZP GDJF BFBJF BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;计入返利与达成</td>
                                                <td>
                                                    <div id="IptAcquisition" class="FrameControl CellInput" data-for="Acquisition" data-group="Gift"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="Acquisition"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrUseProductForLp" class="GDJF BFBJF BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-blank'></i>&nbsp;平台积分可用于全产品</td>
                                                <td>
                                                    <div id="IptUseProductForLp" class="FrameControl CellInput" data-for="UseProductForLp" data-group="Gift"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="UseProductForLp"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrPointValidDateTypeForLp" class="GDJF BFBJF BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;平台积分有效期</td>
                                                <td>
                                                    <div id="IptPointValidDateTypeForLp" class="FrameControl CellInput" data-for="PointValidDateTypeForLp" data-group="Gift"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="PointValidDateTypeForLp"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrPointValidDateType" class="GDJF BFBJF BCJF" style="display: none;" visible="false">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;经销商积分效期</td>
                                                <td>
                                                    <div id="IptPointValidDateType" class="FrameControl CellInput" data-for="PointValidDateType" data-group="Gift"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" data-for="PointValidDateType"></div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 40%; background-color: #d9edf7; padding: 10px; vertical-align: top; border-radius: 5px;">
                                        <div id="IptDescGift"></div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="PolicyTab" style="padding: 0px;">
                    <div class="panel panel-primary" style="margin: 10px;">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;参数列表</h3>
                        </div>
                        <div class="panel-body" style="padding: 0px;">
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
                </div>
                <div class="PolicyTab" style="padding: 0px;">
                    <div class="panel panel-primary" style="margin: 10px;">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;规则列表</h3>
                        </div>
                        <div class="panel-body" style="padding: 0px;">
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
                </div>
                <div class="PolicyTab" style="padding: 0px;">
                    <div id="PnlPreview" style="overflow-y: auto; padding: 10px;">
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 content-row" style="height: 41px;">
            &nbsp;
        </div>
    </div>
    <div class="col-xs-12" style="height: 40px; line-height: 40px; text-align: right; position: fixed; bottom: 0px; background-color: #f5f5f5; border-top: solid 1px #ccc;" id="PnlButton">
        <button id="BtnBack" class="KendoButton size-14 Step Step1 Step2 Step3"><i class='fa fa-arrow-left'></i>&nbsp;&nbsp;上一步</button>
        <button id="BtnNext" class="KendoButton size-14 Step Step0 Step1"><i class='fa fa-arrow-right'></i>&nbsp;&nbsp;下一步</button>
        <button id="BtnPreview" class="KendoButton size-14 Step Step2"><i class='fa fa-file-code-o'></i>&nbsp;&nbsp;预览</button>
        <button id="BtnSave" class="KendoButton size-14 Step Step0 Step1 Step2"><i class='fa fa-save'></i>&nbsp;&nbsp;保存</button>
        <button id="BtnClose" class="KendoButton size-14"><i class='fa fa-window-close-o'></i>&nbsp;&nbsp;关闭</button>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/PolicyTemplateInfo.js?v=1.40"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            PolicyTemplateInfo.InitPage();
        });
    </script>
</asp:Content>
