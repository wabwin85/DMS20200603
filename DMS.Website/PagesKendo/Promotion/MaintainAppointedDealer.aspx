<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="MaintainAppointedDealer.aspx.cs" Inherits="DMS.Website.PagesKendo.Promotion.MaintainAppointedDealer" %>

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
    <input type="hidden" id="IptPolicyId" class="FrameControl" />
    <input type="hidden" id="IptPageType" class="FrameControl" />
    <input type="hidden" id="IptProductLine" class="FrameControl" />
    <input type="hidden" id="IptSubBu" class="FrameControl" />
    <input type="hidden" id="IptPromotionState" class="FrameControl" />
    <div style="margin: 15px;" class="content-main">
        <div class="panel panel-primary" id="PnlBasic">
            <div class="panel-heading">
                <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;适用经销商</h3>
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
                                <tr>
                                    <td><i class='fa fa-fw fa-require'></i>&nbsp;经销商Code</td>
                                    <td>
                                        <div id="IptDealerCode" class="FrameControl CellInput" for="DealerCode" group="Basic"></div>
                                    </td>
                                    <td style="padding: 0px;">
                                        <div class="k-callout k-callout-w Pointer PointerNone" for="DealerCode"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td rowspan="2"><i class='fa fa-fw fa-require'></i>&nbsp;类型</td>
                                    <td>
                                        <div id="IptOperType" class="FrameControl CellInput" for="OperType" group="Basic"></div>
                                    </td>
                                    <td style="padding: 0px;">
                                        <div class="k-callout k-callout-w Pointer PointerNone" for="OperType"></div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 40%; background-color: #d9edf7; padding: 10px; vertical-align: top; border-radius: 5px;">
                            <div id="IptDescBasic" style="overflow-y: auto;"></div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: right; height: 40px; line-height: 40px;">
                            <button id="BtnSave" class="KendoButton size-14"><i class='fa fa-save'></i>&nbsp;&nbsp;保存</button>
                            <button id="BtnClose" class="KendoButton size-14"><i class='fa fa-window-close-o'></i>&nbsp;&nbsp;关闭</button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="panel panel-primary" style="margin-top: 10px; margin-bottom: 10px;">
            <div class="panel-heading">
                <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;已选经销商</h3>
            </div>
            <div class="panel-body" style="padding: 0px;">
                <div id="RstPolicyDealer" style="border-width: 0px;"></div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/MaintainAppointedDealer.js?v=1.05"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            MaintainAppointedDealer.InitPage();
        });
    </script>
</asp:Content>
