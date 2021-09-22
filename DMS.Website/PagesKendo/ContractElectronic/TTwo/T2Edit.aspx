<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="T2Edit.aspx.cs" Inherits="DMS.Website.Pages.ContractKendo.TTwo.T2Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
    <link href="../style/MyComon.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="ContractId" class="FrameControl" />
    <input type="hidden" id="ContractType" class="FrameControl" />
    <input type="hidden" id="DeptId" class="FrameControl" />
    <input type="hidden" id="SubDepId" class="FrameControl" />
    <input type="hidden" id="DealerType" class="FrameControl" />
    <input type="hidden" id="SubDeptId" class="FrameControl" />
    <input type="hidden" id="ExportId" class="FrameControl" />
    <input type="hidden" id="DealerId" class="FrameControl" />
    <input type="hidden" id="PlatformId" class="FrameControl" />
    <div class="content-main">
        <table style="width: 100%; height: 100%;">
            <tr>
                <td style="width: 35%;">
                    <div class="content-row" id="PnlContractBase" style="padding: 10px 10px 0px 10px;">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;基本信息</h3>
                            </div>
                            <div class="panel-body">
                                <table style="width: 100%" class="KendoTable">
                                    <tr id="trHideVer" <%--style="display:none;"--%>>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 合同版本</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="ContractVer"></div>
                                        </td>
                                    </tr>
                                    <tr id="trHideStatus" <%--style="display:none;"--%>>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 合同状态</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="ContractStatus"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 合同编号</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="DivContractNo" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 产品线</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="DeptName" class="FrameControl"></div>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp; 合同分类</td>
                                        <td style="width: 18%; padding-right: 30px;">
                                            <div id="DeptNameEn" class="FrameControl"></div>
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
                            <div class="panel-body" id="PnlContractContent">
                                <table style="width: 100%;" class="KendoTable">
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;协议编号</td>
                                        <td style="width: 15%;">
                                            <div id="ContractNo" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%; display:none" ><i class='fa fa-blank'></i>&nbsp;是否增加产品线</td>
                                        <td style="width: 15%;  display:none">
                                            <div id="IsAddNew" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;平台商名称</td>
                                        <td style="width: 15%;">
                                            <div id="PlatformName" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;二级经销商名称</td>
                                        <td style="width: 15%;">
                                            <div id="DealerName" class="FrameControl"></div>
                                        </td>

                                    </tr>

                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;协议生效日期</td>
                                        <td style="width: 15%;">
                                            <div id="AgreementStartDate" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;协议到期日期</td>
                                        <td style="width: 15%;">
                                            <div id="AgreementEndDate" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <tr>

                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;平台商务组</td>
                                        <td style="width: 15%;">
                                            <div id="PlatformBusinessContact" class="FrameControl invalid"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;平台商务组电话</td>
                                        <td style="width: 15%;">
                                            <div id="PlatformBusinessPhone" class="FrameControl invalid"></div>
                                        </td>
                                    </tr>
                                      <tr >
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;SUB BU中文名</td>
                                        <td style="width: 15%;">
                                            <div id="SubBuName" class="FrameControl invalid"></div>
                                        </td>
                                        <%--<td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;SUB BU英文名</td>
                                        <td style="width: 15%;">
                                            <div id="SubBuNameEn" class="FrameControl invalid"></div>
                                        </td>--%>
                                    </tr>
                                    <tr style="display: none" id="SubTr">
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;SUB BU中文名</td>
                                        <td style="width: 15%;">
                                            <div id="SubDeptName" class="FrameControl invalid"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;SUB BU英文名文名</td>
                                        <td style="width: 15%;">
                                            <div id="SubDeptNameEn" class="FrameControl invalid"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td colspan="2"></td>
                                    </tr>
                                </table>
                            </div>
                            <div style="text-align: right; height: 40px; margin-right: 30px;margin-top: -40px">
                                <button id="BtnSubmit" class="size-14"><i class="fa fa-hand-pointer-o"></i>&nbsp;&nbsp;提交&nbsp;</button>
                                <button id="BtnPDFExport" class="size-14"><i class='fa fa-download'></i>&nbsp;&nbsp;导出&nbsp;</button>
                                <button id="BtnPreview" class="size-14"><i class='fa fa-file-code-o'></i>&nbsp;&nbsp;预览&nbsp;</button>
                                <button id="BtnPDFCache" class="size-14"><i class='fa fa-bookmark-o'></i>&nbsp;&nbsp;暂存&nbsp;</button>
                                <button id="BtnGiveupCache" style="display: none;" class="size-14"><i class='fa fa-paper-plane-o'></i>&nbsp;&nbsp;放弃暂存&nbsp;</button>
                                <button id="BtnContractRevoke" style="display: none;" class="size-14"><i class='fa fa-paper-plane-o'></i>&nbsp;&nbsp;撤销&nbsp;</button>
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
    <script type="text/javascript" src="../script/T2Edit.js?v=3212"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            Page.InitPage();
        })
    </script>

</asp:Content>
