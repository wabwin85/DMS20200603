<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="LPApply.aspx.cs" Inherits="DMS.Website.Pages.ContractKendo.LPApply" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
    <link href="../style/MyComon.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="ContractId" class="FrameControl" />
    <input type="hidden" id="ContractType" class="FrameControl" />
    <input type="hidden" id="DeptId" class="FrameControl" />
    <input type="hidden" id="SubDepId" class="FrameControl" />
    <input type="hidden" id="DealerType" class="FrameControl" />
    <input type="hidden" id="NewFileNameGoods" class="FrameControl" />
    <input type="hidden" id="NewFileNameProxy" class="FrameControl" />
    <input type="hidden" id="ExportId" class="FrameControl" />
    <input type="hidden" id="SubProductName" class="FrameControl" />
    <input type="hidden" id="SubProductEName" class="FrameControl" />
    <input type="hidden" id="DealerId" class="FrameControl" />

    <div class="content-main">
        <table style="width: 100%; height: 100%;">
            <tr>
                <td style="width: 35%;">
                    <div class="content-row" id="PnlContractBase" style="padding: 10px 10px 0px 10px;">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;基本信息</h3>
                            </div>
                            <div class="panel-body" id="PnlInfo">
                                <table style="width: 100%" class="KendoTable">
                                    <tr id="trHideVer">
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 合同版本</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="ContractVer"></div>
                                        </td>
                                    </tr>
                                    <tr id="trHideStatus">
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 版本状态</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="ContractStatus"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 合同编号</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="ContractNo" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 产品线</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="DivBU" class="FrameControl"></div>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 合同分类</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="DivContractType" class="FrameControl"></div>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 合同类型</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="DivContractClass" class="FrameControl"></div>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 经销商类型</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="DivDealerType" class="FrameControl"></div>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 经销商</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="DivDealer" class="FrameControl"></div>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </td>
                <td rowspan="2" style="width: 65%; height: 100%;">
                    <div class="content-row" id="PnlContractInfo" style="padding: 10px 10px 0px 10px;">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;合同信息</h3>
                            </div>
                            <div class="panel-body" id="PnlContractContent" style="overflow: auto;">
                                <table style="width: 100%;" class="KendoTable">
                                    <tr>

                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;经销商中文名</td>
                                        <td style="width: 15%;">
                                            <div id="DealerName" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;经销商英文名</td>
                                        <td style="width: 15%;">
                                            <div id="DealerNameEn" class="FrameControl"></div>
                                        </td>


                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;经销商中文地址</td>
                                        <td style="width: 15%;">
                                            <div id="DealerAddress" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;经销商英文地址</td>
                                        <td style="width: 15%;">
                                            <div id="DealerAddressEn" class="FrameControl invalid"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;经销商联系电话</td>
                                        <td style="width: 15%;">
                                            <div id="DealerPhone" class="FrameControl invalid"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;经销商传真</td>
                                        <td style="width: 15%;">
                                            <div id="DealerFax" class="FrameControl invalid"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;联系人中文名</td>
                                        <td style="width: 15%;">
                                            <div id="DealerManager" class="FrameControl invalid"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;联系人英文名</td>
                                        <td style="width: 15%;">
                                            <div id="DealerManagerEn" class="FrameControl invalid"></div>
                                        </td>
                                    </tr>
                                    <tr>

                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;BU中文全名</td>
                                        <td style="width: 15%;">
                                            <div id="DeptName" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;BU英文全名</td>
                                        <td style="width: 15%;">
                                            <div id="DeptNameEn" class="FrameControl"></div>
                                        </td>


                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;协议起始日期</td>
                                        <td style="width: 15%;">
                                            <div id="AgreementStartDate" class="FrameControl invalid"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;协议终止日期</td>
                                        <td style="width: 15%;">
                                            <div id="AgreementEndDate" class="FrameControl invalid"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;经销商邮箱</td>
                                        <td style="width: 15%;">
                                            <div id="DealerMail" class="FrameControl invalid"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;季度采购总额比例</td>
                                        <td style="width: 15%;">
                                            <div id="DivQuarterRatio" class="FrameControl invalid"></div>
                                        </td>

                                    </tr>
                                    <tr>

                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;付款方式</td>
                                        <td style="width: 15%;">
                                            <div id="PaymentType" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;协议类型</td>
                                        <td style="width: 15%;">
                                            <div id="ExclusiveType" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <tr id="hideDivPayType1">
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;账期</td>
                                        <td style="width: 15%;">
                                            <div id="PaymentDays" class="FrameControl invalid"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;银行保函</td>
                                        <td style="width: 15%;">
                                            <div id="BankGuarantee" class="FrameControl invalid"></div>
                                        </td>

                                    </tr>
                                    <tr id="hideDivPayType2">
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;母公司保函</td>
                                        <td style="width: 15%;">
                                            <div id="CompanyGuarantee" class="FrameControl invalid"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;信用限额</td>
                                        <td style="width: 15%;">
                                            <div id="CreditLimit" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <tr style="height: 36px; display: none;" class="ProxyTemplate">
                                        <td><i class='fa fa-blank'></i>其它附件</td>
                                        <td colspan="3">
                                            <div style="display: inline-block">
                                                <button id="BtnDownLoadProxyTemplate" class="" style="margin-right: 30px;"><i class='fa fa-cloud-download'></i>&nbsp;&nbsp;下载模板</button>
                                                <button id="BtnUploadProxy" class="" style="margin-right: 30px;"><i class='fa fa-cloud-upload'></i>&nbsp;&nbsp;上传文件</button>

                                            </div>
                                            <div style="display: none;">
                                                <input type="file" id="UploadProxyfiles" name="files" style="display: none;" />
                                            </div>
                                            <div style="display: inline-block" id="DivUploadProxy" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <%--      <tr style="height: 36px; display:none;" class="GoodsTemplate">
                                        <td><i class='fa fa-blank'></i>提货授权委托书</td>
                                        <td colspan="3">
                                            <div style="display: inline-block">
                                                <button id="BtnDownLoadGoodsTemplate" class="" style="margin-right: 30px;"><i class='fa fa-cloud-download'></i>&nbsp;&nbsp;下载模板</button>
                                                <button id="BtnUploadGoods" class="" style="margin-right: 30px;"><i class='fa fa-cloud-upload'></i>&nbsp;&nbsp;上传文件</button>
                                            </div>
                                            <div style="display: none;">
                                                <input type="file" id="UploadGoodsfiles" name="files" style="display: none;" />
                                            </div>
                                            <div style="display: inline-block" id="DivUploadGoods" class="FrameControl"></div>
                                        </td>
                                    </tr>--%>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;返利比例</td>
                                        <td style="width: 15%;">
                                            <div id="DivRebateRatio" class="FrameControl invalid"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;业绩评分返利折扣</td>
                                        <td style="width: 15%;">
                                            <div id="DivPerformanceRebateDiscount" class="FrameControl invalid"></div>
                                        </td>
                                    </tr>
                                    <tr style="display:none">
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;物流公司</td>
                                        <td style="width: 15%;">
                                            <div id="LogisticsCompany" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;</td>
                                        <td style="width: 15%;">
                                        </td>
                                    </tr>
                                    <tr style="display:none">
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;授权开始日期</td>
                                        <td style="width: 15%;">
                                            <div id="StartDate" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;授权结束日期</td>
                                        <td style="width: 15%;">
                                            <div id="EndDate" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <div id="DiscountList" style="margin: 10px 0px 10px 0px;">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                           <div id="ReadTemplateList"></div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <div style="text-align: right; height: 40px; margin-right: 30px;">
                                                <button id="BtnSubmit" class="size-14"><i class="fa fa-hand-pointer-o"></i>&nbsp;&nbsp;提交&nbsp;</button>
                                                <button id="BtnPDFExport" class="size-14"><i class='fa fa-download'></i>&nbsp;&nbsp;导出&nbsp;</button>
                                                <button id="BtnPreview" class="size-14"><i class='fa fa-file-code-o'></i>&nbsp;&nbsp;预览&nbsp;</button>
                                                <button id="BtnPDFCache" class="size-14"><i class='fa fa-bookmark-o'></i>&nbsp;&nbsp;暂存&nbsp;</button>
                                                <button id="BtnGiveupCache" style="display: none;" class="size-14"><i class='fa fa-paper-plane-o'></i>&nbsp;&nbsp;放弃暂存&nbsp;</button>
                                                <button id="BtnContractRevoke" style="display: none;" class="size-14"><i class='fa fa-paper-plane-o'></i>&nbsp;&nbsp;撤销&nbsp;</button>
                                            </div>
                                        </td>
                                    </tr>
                                </table>

                            </div>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="width: 35%;">
                    <div class="content-row" style="padding: 0px 10px 0px 10px;">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;项目选择</h3>
                            </div>
                            <div class="panel-body" style="padding: 0px; overflow: auto;" id="PnlContractSelect">
                                <div style="height: 32px;">
                                    <button id="BtnSelectAll" class="btn btn-primary btn-sm" style="margin: 5px 5px 5px 15px; box-shadow: 1px 1px 3px #FFFF00; border: none; outline: none;">全选</button>
                                </div>
                                <div id="example">
                                    <div id="sortable-handlers">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="../script/MyCommon.js"></script>
    <script type="text/javascript" src="../script/LPApply.js?v=3.91"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            Page.InitPage();
        })
    </script>
</asp:Content>
