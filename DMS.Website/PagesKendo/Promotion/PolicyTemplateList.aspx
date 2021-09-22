<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="PolicyTemplateList.aspx.cs" Inherits="DMS.Website.PagesKendo.Promotion.PolicyTemplateList" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .ClassWrapper {
            height: 225px;
            overflow-y: auto;
        }

            .ClassWrapper .ClassItem {
                border-bottom: 1px dashed #ccc;
                height: 40px;
                line-height: 40px;
                vertical-align: middle;
                font-size: 14px;
                padding: 0px 10px 0px 30px;
                cursor: pointer;
            }

            .ClassWrapper .SelectItem {
                background-color: #337ab7;
                color: #fff;
            }
    </style>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="IptPolicyStyle" />
    <input type="hidden" id="IptPolicyStyleSub" />
    <input type="hidden" id="IptUserId" />
    <div class="content-main">
        <div class="col-xs-12 content-row" style="padding: 10px 10px 0px 10px;">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;查询条件</h3>
                </div>
                <div class="panel-body">
                    <table style="width: 100%;" class="KendoTable">
                        <tr>
                            <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;模板名称</td>
                            <td style="width: 23%;">
                                <div id="QryPolicyName" class="FrameControl"></div>
                            </td>
                            <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;产品线</td>
                            <td style="width: 23%;">
                                <div id="QryProductLine" class="FrameControl"></div>
                            </td>
                            <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;促销类型</td>
                            <td style="width: 24%;">
                                <div id="QryPromotionType" class="FrameControl"></div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" style="height: 40px; text-align: right;">
                                <button id="BtnNew" class="KendoButton"><i class='fa fa-file-o'></i>&nbsp;&nbsp;新增</button>
                                <button id="BtnQuery" class="KendoButton"><i class='fa fa-search'></i>&nbsp;&nbsp;查询</button>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="panel panel-primary" style="margin-top: 10px; margin-bottom: 10px;">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;模板列表</h3>
                </div>
                <div class="panel-body" style="padding: 0px;">
                    <div id="RstPolicyList" style="border-width: 0px;"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="PnlPolicyTypeWindow" style="padding: 0px;">
        <div id="PnlPolicyType" style="border: 0; background-color: #DFE8F6;">
            <ul>
                <li class="k-state-active">新增模板
                </li>
            </ul>
            <div style="height: 374px; padding: 0px; border-left: 0; border-right: 0; border-bottom: 0; margin: 0px;">
                <div class="col-xs-12" style="padding: 0px; height: 374px;">
                    <table style="height: 100%; width: 100%;">
                        <tr>
                            <td style="vertical-align: top; width: 40%; height: 374px;">
                                <div class="panel-group" id="accordion" style="padding: 5px; margin-bottom: 0px;">
                                    <div class="panel panel-success">
                                        <div class="panel-heading" style="cursor: pointer;" data-toggle="collapse" data-parent="#accordion"
                                            href="#collapse1">
                                            <h4 class="panel-title">赠品类（按时间段结算）
                                            </h4>
                                        </div>
                                        <div id="collapse1" class="panel-collapse collapse">
                                            <div class="panel-body" style="padding: 0px;">
                                                <ul class="ClassWrapper">
                                                    <li style="list-style: none;" class="ClassItem" data-policy-style="赠品" data-policy-style-sub="促销赠品">促销赠品</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel panel-info">
                                        <div class="panel-heading" style="cursor: pointer;" data-toggle="collapse" data-parent="#accordion"
                                            href="#collapse2">
                                            <h4 class="panel-title">积分类（按时间段结算）
                                            </h4>
                                        </div>
                                        <div id="collapse2" class="panel-collapse collapse">
                                            <div class="panel-body" style="padding: 0px;">
                                                <ul class="ClassWrapper">
                                                    <li style="list-style: none;" class="ClassItem" data-policy-style="积分" data-policy-style-sub="满额送固定积分">送固定值积分</li>
                                                    <li style="list-style: none;" class="ClassItem" data-policy-style="积分" data-policy-style-sub="金额百分比积分">按百分比赠送积分</li>
                                                    <li style="list-style: none;" class="ClassItem" data-policy-style="积分" data-policy-style-sub="促销赠品转积分">可变量积分</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel panel-warning">
                                        <div class="panel-heading" style="cursor: pointer;" data-toggle="collapse" data-parent="#accordion"
                                            href="#collapse3">
                                            <h4 class="panel-title">即买即赠（按单张订单计算）
                                            </h4>
                                        </div>
                                        <div id="collapse3" class="panel-collapse collapse">
                                            <div class="panel-body" style="padding: 0px;">
                                                <ul class="ClassWrapper">
                                                    <li style="list-style: none;" class="ClassItem" data-policy-style="即时买赠" data-policy-style-sub="满额送赠品">送赠品</li>
                                                    <li style="list-style: none;" class="ClassItem" data-policy-style="即时买赠" data-policy-style-sub="满额打折">送积分（价格折扣）</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td style="vertical-align: top; width: 60%; height: 374px;">
                                <div id="IptDesc" style="margin: 5px; padding: 10px; height: 342px; border-radius: 5px; background-color: #f5f5f5; border: 1px solid #ccc; overflow-y: auto;">&nbsp;</div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-xs-12" style="padding: 0px; height: 40px; line-height: 40px; bottom: 0px; text-align: right; background-color: #f5f5f5; border-top: solid 1px #ccc;">
            <button id="BtnAdd" class="KendoButton size-14" style="margin-right: 10px;"><i class='fa fa-plus-square'></i>&nbsp;&nbsp;新增</button>
            <button id="BtnClose" class="KendoButton size-14" style="margin-right: 10px;"><i class='fa fa-window-close-o'></i>&nbsp;&nbsp;关闭</button>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/PolicyTemplateList.js?v=1.22"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            PolicyTemplateList.InitPage();
        });
    </script>
</asp:Content>
