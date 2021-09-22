<%@ Page Title="二级经销商订单申请" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="OrderApplyInfo.aspx.cs"
    Inherits="DMS.Website.Revolution.Pages.Order.OrderApplyInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hiddIsModifyStatus" />
    <input type="hidden" id="IsNewApply" class="FrameControl" />
    <input type="hidden" id="InstanceId" class="FrameControl" />
    <input type="hidden" id="hidProductLine" class="FrameControl" />
    <input type="hidden" id="hidDealerId" class="FrameControl" />
    <input type="hidden" id="hidPriceType" class="FrameControl" />
    <input type="hidden" id="hidOrderType" class="FrameControl" />
    <input type="hidden" id="hidWareHouseType" class="FrameControl" />
    <input type="hidden" id="hidWarehouse" class="FrameControl" />
    <input type="hidden" id="hidPointType" class="FrameControl" />
    <input type="hidden" id="hidOrderStatus" class="FrameControl" />
    <input type="hidden" id="hidTerritoryCode" class="FrameControl" />
    <input type="hidden" id="hidpaymentType" class="FrameControl" />
    <input type="hidden" id="hidVenderId" class="FrameControl" />

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
                                            <i class="fa fa-fw fa-require"></i>订单类型
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryOrderType" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            订单号
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryOrderNO" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group" style="display: none;">
                                        <div class="col-xs-4 col-label">
                                            积分类型
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryPointType" class="FrameControl"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-3">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>产品线
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryProductLine" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            订单状态
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryOrderStatus" class="FrameControl"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-3">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            经销商
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryDealer" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            订单对象
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryOrderTo" class="FrameControl"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-3">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            提交日期
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QrySubmitDate" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i id="IsShowpaymentType" class="fa fa-fw fa-require" style="display: none;"></i>
                                            付款方式
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryPaymentTpype" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <%--                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            RSM
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QrySales" class="FrameControl"></div>
                                        </div>
                                    </div>--%>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;表头信息</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div class="col-xs-4">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            金额汇总
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryTotalAmount" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            订单总数量
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryTotalQty" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            已发总数量
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryTotalReceiptQty" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            订单备注
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryRemark" class="FrameControl"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-4">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            订单联系人
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryContactPerson" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            联系方式
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryContact" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            手机号码
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryContactMobile" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <%--                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            拒绝理由
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryRejectReason" class="FrameControl"></div>
                                        </div>
                                    </div>--%>
                                </div>
                                <div class="col-xs-4">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            收货仓库
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryWarehouse" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            收货地址
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryShipToAddress" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            收货人
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryConsignee" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            收货人电话
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryConsigneePhone" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            期望到货日期
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryRDD" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            承运商
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryCarrier" class="FrameControl"></div>
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
                                <div class="col-buttom text-left">
                                    <a id="btnUserPoint"></a>
                                    <a id="btnAddCfnSet"></a>
                                    <a id="btnAddCfn"></a>
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
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;发货明细</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                            </div>
                            <div class="row">
                                <div id="RstShipDetail" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <%--            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;操作记录</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div id="RstOperationLog" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>--%>
            <div id="RstOperationLog" class="row">
            </div>


            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;附件</h3>
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

        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom" id="PnlButton">
        <a id="BtnSave"></a>
        <a id="BtnDelete"></a>
        <a id="BtnSubmit"></a>
        <a id="BtnCopy"></a>
        <a id="BtnRevoke"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/OrderApplyInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            OrderApplyInfo.Init();
        });
    </script>
</asp:Content>


