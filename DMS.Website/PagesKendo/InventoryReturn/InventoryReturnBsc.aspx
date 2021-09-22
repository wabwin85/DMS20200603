<%@ Page Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="InventoryReturnBsc.aspx.cs" Inherits="DMS.Website.PagesKendo.InventoryReturn.InventoryReturnBsc" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
    </style>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="AdjId" class="FrameControl" />
    <input type="hidden" id="LastUpdateTime" class="FrameControl" />
    <input type="hidden" id="ForwardUrl" class="FrameControl" />
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
                            <tr id="TrInvoiceNo">
                                <td>发票号</td>
                                <td>
                                    <div id="InvoiceNo" class="FrameControl CellInput" for="InvoiceNo" ></div>
                                </td>
                            </tr>
                            <tr id="TrRgaNo">
                                <td>RGA号</td>
                                <td>
                                    <div id="RgaNo" class="FrameControl CellInput" for="RgaNo" ></div>
                                </td>
                            </tr>
                            <tr id="TrDeliveryNo">
                                <td>出货号</td>
                                <td>
                                    <div id="DeliveryNo" class="FrameControl CellInput" for="DeliveryNo" ></div>
                                </td>
                            </tr>
                            <tr id="TrReasonCode">
                                <td>原因</td>
                                <td>
                                    <div id="ReasonCode" class="FrameControl CellInput" for="ReasonCode" ></div>
                                </td>
                            </tr>
                            <tr id="TrRevokeRemark">
                                <td>反对原因</td>
                                <td>
                                    <div id="RevokeRemark" class="FrameControl CellInput" for="RevokeRemark" ></div>
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
    <script type="text/javascript" src="Script/InventoryReturnBsc.js?v=1.398"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            InventoryReturnBsc.InitPage();
        });

    </script>
</asp:Content>
