<%@ Page Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="DealerComplainBsc.aspx.cs" Inherits="DMS.Website.PagesKendo.InventoryReturn.DealerComplainBsc" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
    </style>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="ComplainId" class="FrameControl" />
    <input type="hidden" id="LastUpdateTime" class="FrameControl" />
    <input type="hidden" id="ForwardUrl" class="FrameControl" />
    <input type="hidden" id="ComplainType" class="FrameControl" />
    <div class="content-main">
        <div id="PnlInventoryReturnBsc" style="position: absolute; width: 100%;">
            <div class="col-xs-12 content-row" style="padding: 10px 10px 0px 10px;">
                <div class="panel panel-primary" id="PnlBasic">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;客户服务部填写信息</h3>
                    </div>
                    <div class="panel-body">
                        <table style="width: 100%;" class="KendoTable">
                            <tr>
                                <td style="width: 20%; padding: 0px; height: 1px;"></td>
                                <td style="padding: 0px; height: 1px;"></td>
                            </tr>
                            <tr id="TrCOMPLAINTID" class="CNF">
                                <td>投诉号码</td>
                                <td>
                                    <div id="COMPLAINTID" class="FrameControl CellInput" for="COMPLAINTID" ></div>
                                </td>
                            </tr>
                            <tr id="TrTW" class="CNF">
                                <td>TW</td>
                                <td>
                                    <div id="TW" class="FrameControl CellInput" for="TW" ></div>
                                </td>
                            </tr>
                            <tr id="TrPI" class="CRM">
                                <td>投诉号码(PI)</td>
                                <td>
                                    <div id="PI" class="FrameControl CellInput" for="PI" ></div>
                                </td>
                            </tr>
                            <tr id="TrBL" class="CRM">
                                <td>退换货码（IAN）</td>
                                <td>
                                    <div id="IAN" class="FrameControl CellInput" for="IAN" ></div>
                                </td>
                            </tr>
                            <tr id="TrRN" class="Both">
                                <td>收到返回产品登记号</td>
                                <td>
                                    <div id="RN" class="FrameControl CellInput" for="RN" ></div>
                                </td>
                            </tr>
                            <tr id="TrReturnFactoryTrackingNo" class="CNF">
                                <td>返回原厂运单号</td>
                                <td>
                                    <div id="ReturnFactoryTrackingNo" class="FrameControl CellInput" for="ReturnFactoryTrackingNo" ></div>
                                </td>
                            </tr>
                            <tr id="TrReceiveReturnedGoods" class="CNF">
                                <td>是否收到实物退货</td>
                                <td>
                                    <div id="ReceiveReturnedGoods" class="FrameControl CellInput" for="ReceiveReturnedGoods" ></div>
                                </td>
                            </tr>
                            <tr id="TrReceiveReturnedGoodsDate" class="CNF">
                                <td>收到日期</td>
                                <td>
                                    <div id="ReceiveReturnedGoodsDate" class="FrameControl CellInput" for="ReceiveReturnedGoodsDate" ></div>
                                </td>
                            </tr>
                            <tr id="TrConfirmReturnOrRefundCNF" class="CNF">
                                <td>波科确认产品换货或退款</td>
                                <td>
                                    <div id="ConfirmReturnOrRefundCNF" class="FrameControl CellInput" for="ConfirmReturnOrRefundCNF" ></div>
                                </td>
                            </tr>
                            <tr id="TrConfirmReturnOrRefundCRM" class="CRM">
                                <td>波科确认产品换货或退款</td>
                                <td>
                                    <div id="ConfirmReturnOrRefundCRM" class="FrameControl CellInput" for="ConfirmReturnOrRefundCRM" ></div>
                                </td>
                            </tr>
                            <tr id="TrRGA" class="Both">
                                <td>RGA</td>
                                <td>
                                    <div id="RGA" class="FrameControl CellInput" for="RGA" ></div>
                                </td>
                            </tr>
                            <tr id="TrInvoice" class="Both">
                                <td>Invoice</td>
                                <td>
                                    <div id="Invoice" class="FrameControl CellInput" for="Invoice" ></div>
                                </td>
                            </tr>
                            <tr id="TrDN" class="Both">
                                <td>DN</td>
                                <td>
                                    <div id="DN" class="FrameControl CellInput" for="DN" ></div>
                                </td>
                            </tr>
                        </table>
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
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerComplainBsc.js?v=1.33"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            DealerComplainBsc.InitPage();
        });

    </script>
</asp:Content>
