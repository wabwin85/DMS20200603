<%@ Page Title="寄售申请" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ConsignmentApplyHeaderInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Consignment.ConsignmentApplyHeaderInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hiddIsModifyStatus" />
    <input type="hidden" id="IsNewApply" class="FrameControl" />
    <input type="hidden" id="InstanceId" class="FrameControl" />
    <input type="hidden" id="QryPriceType" class="FrameControl" />
    <input type="hidden" id="QryOrderType" class="FrameControl" />
    <input type="hidden" id="QrySpecialPrice" class="FrameControl" />
    <input type="hidden" id="hidCorpType" class="FrameControl" />
    <input type="hidden" id="hidDivisionCode" class="FrameControl" />
    <input type="hidden" id="QryDealerId" class="FrameControl" />
    <input type="hidden" id="hidChanConsignment" class="FrameControl" />
    <input type="hidden" id="hidProductLine" class="FrameControl" />
    <input type="hidden" id="HospId" class="FrameControl" />
    <input type="hidden" id="HiDmaId" class="FrameControl" />
    <input type="hidden" id="hidorderState" class="FrameControl" />
    <input type="hidden" id="hidConsignment" class="FrameControl" />
    <input type="hidden" id="hidUpdateDate" class="FrameControl" />

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
                                            申请单类型
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryApplyType" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>产品线
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="Qrycbproline" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>寄售合同
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryRule" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>寄售规则
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryConsignmentRule" class="FrameControl"></div>
                                        </div>
                                    </div>

                                </div>
                                <div class="col-xs-3">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            经销商名称
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryDealer" class="FrameControl"></div>
                                        </div>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>产品来源
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QrycbProductsource" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>医院
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QrycbHospital" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group" style="display: none;">
                                        <div class="col-xs-4 col-label">
                                            <i class="fa fa-fw fa-require"></i>医院
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryTextHospit" class="FrameControl"></div>
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
                                            <i class="fa fa-fw fa-require"></i>来源经销商
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QrycbSuorcePro" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div style="color: red; text-align: center;">
                                        注:小于等于15天的寄售必须选择医院。
                                    </div>
                                </div>
                                <div class="col-xs-3">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            申请单号
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryApplyNo" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-4 col-label">
                                            申请单状态
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="QryOrderState" class="FrameControl"></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                        <div class="col-xs-5 col-label">
                                            <i class="fa fa-fw fa-require"></i>延期申请状态
                                        </div>
                                        <div class="col-xs-7  col-field">
                                            <div id="QryDelayState" class="FrameControl"></div>
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
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;申请单主信息</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-4">
                            <div class="col-xs-12  col-group">
                                <div class="col-xs-4 col-label">
                                    申请数量汇总
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="Qrynumber" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12  col-group">
                                <div class="col-xs-4 col-label">
                                    申请总价格
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryTaoteprice" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12  col-group">
                                <div style="color: red; text-align: center;">
                                    注:小于等于15天的寄售必须填写原因<br>
                                    寄售原因中填写手术相关信息。
                                </div>
                                <div class="col-xs-4 col-label">
                                    寄售原因
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryConsignment" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12  col-group">
                                <div class="col-xs-4 col-label">
                                    备注说明
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryRemark" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-4">
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>销售
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QrySales" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>销售姓名
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QrySalesName" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>销售邮箱
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QrySalesEmail" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>销售电话
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QrySalesPhone" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-4">
                            <div class="col-xs-12  col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>收货人
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryConsignee" class="FrameControl"></div>
                                </div>
                            </div>

                            <div class="col-xs-12  col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>收货地址
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QrycbSAPWarehouseAddress" class="FrameControl"></div>
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
                            <div class="col-xs-12  col-group">
                                <div class="col-xs-4 col-label">
                                    医院地址
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryHospitalAddress" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12  col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>收货人电话
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryConsigneePhone" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12  col-group">
                                <div class="col-xs-4 col-label">
                                    <i class="fa fa-fw fa-require"></i>期望到货日期
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QrydfRDD" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;寄售规则明细</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    寄售天数
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryNumberDays" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    可延期次数
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryDelaytimes" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    时间期限-起始
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryBeginData" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    是否控制总金额
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryIsControlAmount" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    控制总数量
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryIsControlNumber" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    时间期限-截止
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryEndData" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    适用近效期规则
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryIsDiscount" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    自动补货
                                </div>
                                <div class="col-xs-8 col-field">
                                    <div id="QryIsKB" class="FrameControl"></div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;申请产品明细</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div class="col-buttom text-left" id="PnlDetailButton">
                                    <a id="BtnReturnOrder"></a>
                                    <a id="BtnAddProduct"></a>
                                    <a id="BtnAddComProduct"></a>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstDetailList" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="RstOperationLog" class="row">
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom" id="PnlButton">
        <a id="BtnApplyDelay"></a>
        <a id="BtnSave"></a>
        <a id="BtnDelete"></a>
        <a id="BtnSubmit"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/ConsignmentApplyHeaderInfo.js?v=<%=DateTime.Now %><%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ConsignmentApplyHeaderInfo.Init();
        });
    </script>
</asp:Content>
