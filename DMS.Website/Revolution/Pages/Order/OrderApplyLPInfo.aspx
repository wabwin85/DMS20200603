<%@ Page Title="平台及一级经销商订单申请" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="OrderApplyLPInfo.aspx.cs"
    Inherits="DMS.Website.Revolution.Pages.Order.OrderApplyLPInfo" %>

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
    <input type="hidden" id="hidVenderId" class="FrameControl" />
    <input type="hidden" id="hidDealerType" class="FrameControl" />
    <input type="hidden" id="hidCreateType" class="FrameControl" />
    <input type="hidden" id="hidIsUsePro" class="FrameControl" />
    <input type="hidden" id="hidUpdateDate" class="FrameControl" />
    <input type="hidden" id="hidSpecialPrice" class="FrameControl" />
    <input type="hidden" id="hidSAPWarehouseAddress" class="FrameControl" />
    <input type="hidden" id="hidPohId" class="FrameControl" />
    <input type="hidden" id="hidDealerTaxpayer" class="FrameControl" />
    <input type="hidden" id="QryPickUp" class="FrameControl" />
    <input type="hidden" id="QryDeliver" class="FrameControl" />

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
                                        <div class="col-xs-5 col-label">
                                            提交日期
                                        </div>
                                        <div class="col-xs-7 col-field">
                                            <div id="QrySubmitDate" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-5 col-label">
                                            <i id="IsShowpaymentType" class="fa fa-fw fa-require" style="display: none;"></i>
                                            CrossDock编号
                                        </div>
                                        <div class="col-xs-7 col-field">
                                            <div id="QryCrossDock" class="FrameControl"></div>
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
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;表头信息</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div class="col-xs-3">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            订单币种
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryCurrency" class="FrameControl"></div>
                                        </div>
                                    </div>
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
                                            配送中心
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryVirtualDC" class="FrameControl"></div>
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
                                    <%--<div style="color: red; text-align: center;">如订单有问题，请联系ChinaShareService@bsci.com</div>--%>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            促销政策名称
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QrySpecialPrice" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            促销政策编号
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QrySpecialPriceCode" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <%--促销政策内容--%>
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryPolicyContent" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>订单联系人
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryContactPerson" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>邮箱地址
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryContact" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>手机号码
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryContactMobile" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <span id="lbRejectReason" style="display: none;">拒绝理由</span>
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryRejectReason" class="FrameControl"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-5">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">

                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-8 col-field  col-3to1-4and8-field" style="text-align: center; word-spacing: 3px;">
                                                <div id="QryPickUpOrDeliver" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            收货仓库
                                        </div>
                                        <div class="col-xs-7 col-field">
                                            <div id="QryWarehouse" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            收货地址
                                        </div>
                                        <div class="col-xs-7 col-field">
                                            <div id="QryShipToAddress" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12  col-group">
                                        <div class="col-xs-4 col-label">
                                            医院名称
                                        </div>
                                        <div class="col-xs-4 col-field">
                                            <div id="QryTexthospitalname" class="FrameControl"></div>
                                        </div>
                                        <div class="col-xs-4">
                                            <a id="BtnChoiceHopital"></a>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            医院地址
                                        </div>
                                        <div class="col-xs-6 col-field">
                                            <div id="QryHospitalAddress" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>收货人
                                        </div>
                                        <div class="col-xs-6 col-field">
                                            <div id="QryConsignee" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>收货人电话
                                        </div>
                                        <div class="col-xs-6 col-field">
                                            <div id="QryConsigneePhone" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div style="color: red; text-align: center;">此为随货同行单的联系信息，请务必维护准确</div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            期望到货日期
                                        </div>
                                        <div class="col-xs-6 col-field">
                                            <div id="QryRDD" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            承运商
                                        </div>
                                        <div class="col-xs-6 col-field">
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

            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;发票信息</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                            </div>
                            <div class="row">
                                <div id="RstInvoiceDetail" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%--操作记录--%>
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
        <a id="BtnUsePro"></a>
        <a id="BtnSave"></a>
        <a id="BtnDelete"></a>
        <a id="BtnDiscardModify"></a>
        <a id="BtnSubmit"></a>
        <a id="BtnCopy"></a>
        <a id="BtnRevoke"></a>
        <a id="BtnClose"></a>
        <a id="BtnPushToERP"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/OrderApplyLPInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            OrderApplyLPInfo.Init();
        });
    </script>
</asp:Content>


