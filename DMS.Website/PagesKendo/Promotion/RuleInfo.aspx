<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="RuleInfo.aspx.cs" Inherits="DMS.Website.PagesKendo.Promotion.RuleInfo" %>

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
    <input type="hidden" id="IptPolicyRuleId" class="FrameControl" />
    <input type="hidden" id="IptPolicyStyle" class="FrameControl" />
    <input type="hidden" id="IptPolicyStyleSub" class="FrameControl" />
    <input type="hidden" id="IptPageType" class="FrameControl" />
    <input type="hidden" id="IptPromotionState" class="FrameControl" />
    <input type="hidden" id="IptConditionId" class="FrameControl" />
    <div class="content-main">
        <div id="PnlRuleMain" style="position: absolute; width: 100%;">
            <div class="col-xs-12 content-row" style="padding: 10px 10px 0px 10px;">
                <div class="panel panel-primary" id="PnlBasic">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;赠送规则</h3>
                    </div>
                    <div class="panel-body">
                        <table style="width: 100%;" class="table-info">
                            <tr>
                                <td style="width: 65%; vertical-align: top;">
                                    <table style="width: 100%;" class="KendoTable">
                                        <tr>
                                            <td style="width: 35%; padding: 0px; height: 1px;"></td>
                                            <td style="padding: 0px; height: 1px;"></td>
                                            <td style="width: 10px; padding: 0px; height: 1px;"></td>
                                        </tr>

                                        <tr id="TrPolicyFactorX">
                                            <td rowspan="2"><i class='fa fa-fw fa-require'></i>&nbsp;赠品/积分计算基数类型</td>
                                            <td>
                                                <div id="IptPolicyFactorX" class="FrameControl CellInput" for="PolicyFactorX" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="PolicyFactorX"></div>
                                            </td>
                                        </tr>
                                        <tr id="TrFactorRemarkX">
                                            <td>
                                                <div id="IptFactorRemarkX" class="FrameControl CellInput" for="FactorRemarkX" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="FactorRemarkX"></div>
                                            </td>
                                        </tr>
                                        <tr id="TrPolicyFactorY" class="CXZP BCJF SZP" style="display: none;" visible="false">
                                            <td rowspan="2"><i class='fa fa-fw fa-require'></i>&nbsp;赠品/积分可订产品</td>
                                            <td>
                                                <div id="IptPolicyFactorY" class="FrameControl CellInput" for="PolicyFactorY" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="PolicyFactorY"></div>
                                            </td>
                                        </tr>
                                        <tr id="TrFactorRemarkY" class="CXZP BCJF SZP" style="display: none;" visible="false">
                                            <td>
                                                <div id="IptFactorRemarkY" class="FrameControl CellInput" for="FactorRemarkY" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="FactorRemarkY"></div>
                                            </td>
                                        </tr>
                                        <tr id="TrFactorValueX" class="CXZP GDJF BCJF SZP" style="display: none;" visible="false">
                                            <td><i class='fa fa-fw fa-require'></i>&nbsp;赠品/积分计算系数1</td>
                                            <td>
                                                <div id="IptFactorValueX" class="FrameControl CellInput" for="FactorValueX" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="FactorValueX"></div>
                                            </td>
                                        </tr>
                                        <tr id="TrFactorValueY" class="CXZP BFBJF BCJF SZP DZ" style="display: none;" visible="false">
                                            <td><i class='fa fa-fw fa-require'></i>&nbsp;赠品/积分计算系数2</td>
                                            <td>
                                                <div id="IptFactorValueY" class="FrameControl CellInput" for="FactorValueY" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="FactorValueY"></div>
                                            </td>
                                        </tr>
                                        <tr id="TrPointValue" class="GDJF" style="display: none;" visible="false">
                                            <td><i class='fa fa-fw fa-require'></i>&nbsp;固定积分</td>
                                            <td>
                                                <div id="IptPointValue" class="FrameControl CellInput" for="PointValue" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="PointValue"></div>
                                            </td>
                                        </tr>
                                        <tr id="TrPointType" class="BCJF" style="display: none;" visible="false">
                                            <td><i class='fa fa-fw fa-require'></i>&nbsp;赠品转积分的换算方式</td>
                                            <td>
                                                <div id="IptPointType" class="FrameControl CellInput" for="PointType" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="PointType"></div>
                                            </td>
                                        </tr>
                                        <tr id="TdProToType" style="display: none;">
                                            <td></td>
                                            <td>
                                                <button style="width: 100%;" id="BtnProToType" class="KendoButton"><i class='fa fa-upload'></i>&nbsp;&nbsp;上传固定积分转换率</button>
                                            </td>
                                        </tr>
                                        <tr id="TrDesc">
                                            <td><i class='fa fa-fw fa-require'></i>&nbsp;规则描述</td>
                                            <td>
                                                <div id="IptDesc" class="FrameControl CellInput" for="Desc" group="Basic"></div>
                                            </td>
                                            <td style="padding: 0px;">
                                                <div class="k-callout k-callout-w Pointer PointerNone" for="Desc"></div>
                                            </td>
                                        </tr>
                                        <%-- <tr id="TrPointTypeDownLoad" style="display:none;" visible="false">
                                            <td></td>
                                            <td>
                                                <button id="btnModel" class="KendoButton descDetail" for="PointTypeDownLoad" group="Basic" style="width: 100%"><i class='fa fa-plus'></i>上传积分转换率</button>
                                            </td>
                                        </tr>--%>
                                    </table>
                                </td>
                                <td style="width: 35%; /*height: 241px; */ background-color: #d9edf7; padding: 10px; vertical-align: top; border-radius: 5px;">
                                    <div id="IptDescBasic" style="overflow-y: auto;"></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="panel panel-primary" id="PnlDetail" style="margin-top: 10px; margin-bottom: 10px;">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;门槛</h3>
                    </div>
                    <div class="panel-body" style="padding: 0px;" id="PnlCondition">
                        <div id="PnlConditionInfo" style="padding: 5px; display: none;">
                            <div style="margin: 15px;">
                                <button id="BtnDemoInfo" style="background-color: #003b6f; border-color: #003b6f; color: #FFFFFF; margin-right: 5px;">显示示例</button>
                            </div>
                            <div id="DemoInfo" style="position: relative; display: none; border: 1px  double  #337AB7; margin-bottom: 10px;">
                                <div style="height: 40px; line-height: 40px; background-color: #5BC0DE; margin: 10px;">
                                    <p style="text-align: left; font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>例如1</b>：产品线商业采购/医院植入完成80% 或 采购/植入量 >=50 并<100 执行当前赠送规则</p>
                                </div>
                                <div style="margin: 10px;">
                                    <table class="table table-bordered">
                                        <caption>填写如下：</caption>
                                        <thead>
                                            <tr class="info">
                                                <th style="width: 30%;">条件参数</th>
                                                <th style="width: 20%;">判断符号</th>
                                                <th style="width: 20%;">值类型</th>
                                                <th style="width: 15%;">判断值1</th>
                                                <th style="width: 15%;">判断值2</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>产品线商业采购/医院植入</td>
                                                <td>>= 判断值1</td>
                                                <td>与固定数值比较</td>
                                                <td>0.8</td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td>指定产品商业采购/植入量</td>
                                                <td>>= 判断值1 < 判断值2</td>
                                                <td>与固定数值比较</td>
                                                <td>50</td>
                                                <td>100</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div style="height: 40px; line-height: 40px; background-color: #5BC0DE; margin: 10px;">
                                    <p style="text-align: left; font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>例如2</b>：指定产品商业采购/医院植入达标 执行当前赠送（多目标 或 单目标）</p>
                                </div>
                                <div style="margin: 10px;">
                                    <table class="table table-bordered">
                                        <caption>填写如下：</caption>
                                        <thead>
                                            <tr class="info">
                                                <th style="width: 30%;">条件参数</th>
                                                <th style="width: 20%;">判断符号</th>
                                                <th style="width: 20%;">值类型</th>
                                                <th style="width: 15%;">引用值1</th>
                                                <th style="width: 15%;">引用值2</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>指定产品商业采购/医院植入达标</td>
                                                <td>>= 判断值1 < 判断值2</td>
                                                <td>与上传目标比较</td>
                                                <td>目标1</td>
                                                <td>目标2</td>
                                            </tr>
                                            <tr>
                                                <td>指定产品商业采购/医院植入达标</td>
                                                <td>>= 判断值1</td>
                                                <td>与上传目标比较</td>
                                                <td>目标2</td>
                                                <td></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div style="height: 40px; line-height: 40px; background-color: #5BC0DE; margin: 10px;">
                                    <p style="text-align: left; font-size: 14px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>例如3</b>：两种参数比较，指定产品植入量大于指定产品采购量的80%</p>
                                </div>
                                <div style="margin: 10px;">
                                    <table class="table table-bordered">
                                        <caption>填写如下：</caption>
                                        <thead>
                                            <tr class="info">
                                                <th style="width: 30%;">条件参数</th>
                                                <th style="width: 20%;">判断符号</th>
                                                <th style="width: 20%;">值类型</th>
                                                <th style="width: 15%;">比较参数</th>
                                                <th style="width: 15%;">系数</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>指定产品商业采购量</td>
                                                <td>>= 判断值1</td>
                                                <td>与其它参数判断</td>
                                                <td>指定产品植入量</td>
                                                <td>0.8</td>
                                            </tr>

                                        </tbody>
                                    </table>
                                </div>

                            </div>
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
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;条件参数</td>
                                                <td>
                                                    <div id="IptPolicyConditionFacter" class="FrameControl CellInput" for="PolicyConditionFacter" group="Detail"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="PolicyConditionFacter"></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;判断符号</td>
                                                <td>
                                                    <div id="IptSymbol" class="FrameControl CellInput" for="Symbol" group="Detail"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="Symbol"></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;值类型</td>
                                                <td>
                                                    <div id="IptValueType" class="FrameControl CellInput" for="ValueType" group="Detail"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="ValueType"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrRefValue1" style="display: none;">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;引用值1</td>
                                                <td>
                                                    <div id="IptRefValue1" class="FrameControl CellInput" for="RefValue1" group="Detail"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="RefValue1"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrRefValue2" style="display: none;">
                                                <td><i class='fa fa-fw fa-blank'></i>&nbsp;引用值2</td>
                                                <td>
                                                    <div id="IptRefValue2" class="FrameControl CellInput" for="RefValue2" group="Detail"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="RefValue2"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrValue1" style="display: none;">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;判断值1</td>
                                                <td>
                                                    <div id="IptValue1" class="FrameControl CellInput" for="Value1" group="Detail"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="Value1"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrValue2" style="display: none;">
                                                <td><i class='fa fa-fw fa-blank'></i>&nbsp;判断值2</td>
                                                <td>
                                                    <div id="IptValue2" class="FrameControl CellInput" for="Value2" group="Detail"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="Value2"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrCompareFacter" style="display: none;">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;比较因素</td>
                                                <td>
                                                    <div id="IptCompareFacter" class="FrameControl CellInput" for="CompareFacter" group="Detail"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="CompareFacter"></div>
                                                </td>
                                            </tr>
                                            <tr id="TrCompareFacterRatio" style="display: none;">
                                                <td><i class='fa fa-fw fa-require'></i>&nbsp;系数</td>
                                                <td>
                                                    <div id="IptCompareFacterRatio" class="FrameControl CellInput" for="CompareFacterRatio" group="Detail"></div>
                                                </td>
                                                <td style="padding: 0px;">
                                                    <div class="k-callout k-callout-w Pointer PointerNone" for="CompareFacterRatio"></div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 40%; height: 150px; background-color: #d9edf7; padding: 10px; vertical-align: top; border-radius: 5px;">
                                        <div id="IptDescDetail" style="overflow-y: auto;"></div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="PnlConditionList">
                            <div style="background-color: #F2DEDE; color: #A94442; padding: 0; margin: 0; height: 40px; line-height: 40px; text-align: left;">
                                &nbsp;&nbsp;&nbsp;&nbsp; <b>备注</b>：此处请维护经销商须满足以下条件才可享受以上的“赠送规则”
                            </div>
                            <table style="width: 100%;">
                                <tr>
                                    <td style="text-align: right; vertical-align: middle; float: right; width: 100%; height: 40px; line-height: 40px; border: 0px; border-bottom: solid 1px #a3d0e4;">
                                        <button id="BtnAddCondition" class="KendoButton" style="margin-right: 5px;"><i class='fa fa-plus'></i>&nbsp;&nbsp;添加</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div id="RstRuleDetail" style="border-width: 0px;"></div>
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
            <div class="col-xs-12 FooterBar" id="PnlRuleButton">
                <button id="BtnSave" class="KendoButton size-14"><i class='fa fa-save'></i>&nbsp;&nbsp;保存</button>
                <button id="BtnClose" class="KendoButton size-14"><i class='fa fa-window-close-o'></i>&nbsp;&nbsp;关闭</button>
            </div>
            <div class="col-xs-12 FooterBar" style="display: none;" id="PnlDetailButton">
                <button id="BtnConditionSave" class="KendoButton size-14"><i class='fa fa-check'></i>&nbsp;&nbsp;确定</button>
                <button id="BtnConditionBack" class="KendoButton size-14"><i class='fa fa-mail-reply'></i>&nbsp;&nbsp;返回</button>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/RuleInfo.js?v=1.24"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            RuleInfo.InitPage();
        });
    </script>
</asp:Content>
