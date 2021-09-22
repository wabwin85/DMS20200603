<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="FactorInfo.aspx.cs" Inherits="DMS.Website.PagesKendo.Promotion.FactorInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .Pointer {
            position: static;
            border-right-color: #d9edf7;
            border-width: 10px;
        }

        .PointerNone {
            border-right-color: #FFF !important;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="IsPageNew" class="FrameControl" />
    <input type="hidden" id="IsTemplate" class="FrameControl" />
    <input type="hidden" id="IptPolicyId" class="FrameControl" />
    <input type="hidden" id="IptPolicyFactorId" class="FrameControl" />
    <input type="hidden" id="IptIsPoint" class="FrameControl" />
    <input type="hidden" id="IptIsPointSub" class="FrameControl" />
    <input type="hidden" id="IptPageType" class="FrameControl" />
    <input type="hidden" id="IptPromotionState" class="FrameControl" />
    <input type="hidden" id="IptFactorClass" class="FrameControl" />
    <input type="hidden" id="IptConditionId" class="FrameControl" />
    <div class="content-main">
        <div id="PnlFactorMain" style="position: absolute; width: 100%;">
            <div class="col-xs-12 content-row" style="padding: 10px 10px 0px 10px;">
                <div class="panel panel-primary" id="PnlBasic">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;政策参数基本信息</h3>
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
                                        <tr id="TrFactor">
                                            <td><i class='fa fa-fw fa-require'></i>&nbsp;政策参数类型</td>
                                            <td>
                                                <div id="IptFactor" class="FrameControl CellInput CellInputDropdownList" for="Factor" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="Factor"></div>
                                            </td>
                                        </tr>
                                        <tr id="TrRemark">
                                            <td><i class='fa fa-fw fa-blank'></i>&nbsp;参数描述</td>
                                            <td>
                                                <div id="IptRemark" class="FrameControl CellInput" for="Remark" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="Remark"></div>
                                            </td>
                                        </tr>
                                        <tr id="TrIsGift" style="display: none;">
                                            <td><i class='fa fa-fw fa-require'></i>&nbsp;促销赠品</td>
                                            <td>
                                                <div id="IptIsGift" class="FrameControl CellInput" for="IsGift" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="IsGift"></div>
                                            </td>
                                        </tr>
                                        <tr id="TrPointsValue" style="display: none;">
                                            <td><i class='fa fa-fw fa-require'></i>&nbsp;积分可订购产品</td>
                                            <td>
                                                <div id="IptPointsValue" class="FrameControl CellInput" for="PointsValue" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="PointsValue"></div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="width: 40%; height: 139px; background-color: #d9edf7; padding: 10px; vertical-align: top; border-radius: 5px;">
                                    <div id="IptDescBasic" style="overflow-y: auto; height: 100%;"></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div id="PnlDetail" class="panel panel-primary" style="margin-top: 10px; margin-bottom: 10px; display: none;">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;政策参数添加成功，请给该参数设置限定条件！</h3>
                    </div>
                    <div class="panel-body" style="padding: 0px;">
                        <div id="PnlConditionRuleInfo" style="padding: 5px; display: none;">
                            <table style="width: 100%;" class="table-info">
                                <tr>
                                    <td style="width: 60%; vertical-align: top;">
                                        <table style="width: 100%;" class="KendoTable">
                                            <tr>
                                                <td style="width: 30%; padding: 0px; height: 1px;"></td>
                                                <td style="padding: 0px; height: 1px;"></td>
                                                <td style="width: 10px; padding: 0px; height: 1px;"></td>
                                            </tr>
                                            <tr id="Condition">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;条件</td>
                                                <td>
                                                    <div id="IptRuleCondition" class="FrameControl CellInput CellInputDropdownList " for="RuleCondition" group="ConditionRuleInfo"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="RuleCondition"></div>
                                                </td>
                                            </tr>
                                           <%-- <tr style="display:none;" id="ConditonH">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;条件</td>
                                                <td>
                                                    <div id="IptRuleConditionH" class="FrameControl CellInput CellInputDropdownList" for="RuleConditionH" group="ConditionRuleInfo"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="RuleCondition"></div>
                                                </td>
                                            </tr>--%>
                                            <tr>
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;类型</td>
                                                <td>
                                                    <div id="IptRuleConditionType" class="FrameControl CellInput" for="RuleConditionType" group="ConditionRuleInfo"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="RuleConditionType"></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;数值</td>
                                                <td>
                                                    <div id="IptRuleConditionValues" class="FrameControl CellInput" for="RuleConditionValues" group="ConditionRuleInfo"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="RuleConditionValues"></div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 40%; background-color: #d9edf7; padding: 10px; vertical-align: top; border-radius: 5px;">
                                        <div id="IptDescConditionRuleInfo" style="overflow-y: auto;"></div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="PnlConditionRelationInfo" style="padding: 5px; display: none;">
                            <table style="width: 100%;" class="table-info">
                                <tr>
                                    <td style="width: 60%; vertical-align: top;">
                                        <table style="width: 100%;" class="KendoTable">
                                            <tr>
                                                <td style="width: 30%; padding: 0px; height: 1px;"></td>
                                                <td style="padding: 0px; height: 1px;"></td>
                                                <td style="width: 10px; padding: 0px; height: 1px;"></td>
                                            </tr>
                                            <tr>
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;关联政策参数</td>
                                                <td>
                                                    <div id="IptRelationCondition" class="FrameControl CellInput" for="RelationCondition" group="ConditionRelationInfo"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="RelationCondition"></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><i class='fa fa-fw fa-blank'></i>&nbsp;描述</td>
                                                <td>
                                                    <div id="IptRelationConditionRemark" class="FrameControl CellInput" for="RelationConditionRemark" group="ConditionRelationInfo"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="RelationConditionRemark"></div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 40%; background-color: #d9edf7; padding: 10px; vertical-align: top; border-radius: 5px;">
                                        <div id="IptDescConditionRelationInfo" style="overflow-y: auto;"></div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="PnlConditionList">
                            <table style="width: 100%;">
                                <tr>
                                    <td style="text-align: right; vertical-align: middle; float: right; width: 100%; height: 40px; line-height: 40px; border: 0px; border-bottom: solid 1px #a3d0e4;">
                                        <button id="BtnUploadTopType" class="KendoButton" style="margin-right: 5px;"><i class='fa fa-upload'></i>&nbsp;&nbsp;上传/更改指定产品指标</button>
                                        <button id="BtnConditionAdd" class="KendoButton" style="margin-right: 5px;"><i class='fa fa-plus'></i>&nbsp;&nbsp;添加</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div id="RstFactorRule" style="border-width: 0px;"></div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xs-12 content-row" style="height: 41px;">
                &nbsp;
            </div>
            <div class="col-xs-12 FooterBar" id="PnlFactorButton">
                <button id="BtnSave" class="KendoButton size-14"><i class='fa fa-save'></i>&nbsp;&nbsp;保存</button>
                <button id="BtnClose" class="KendoButton size-14"><i class='fa fa-window-close-o'></i>&nbsp;&nbsp;关闭</button>
            </div>
            <div class="col-xs-12 FooterBar" style="display: none;" id="PnlConditionButton">
                <button id="BtnConditionSave" class="KendoButton size-14"><i class='fa fa-check'></i>&nbsp;&nbsp;确定</button>
                <button id="BtnConditionBack" class="KendoButton size-14"><i class='fa fa-mail-reply'></i>&nbsp;&nbsp;返回</button>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/FactorInfo.js?v=1.36"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            FactorInfo.InitPage();
        });
    </script>
</asp:Content>
