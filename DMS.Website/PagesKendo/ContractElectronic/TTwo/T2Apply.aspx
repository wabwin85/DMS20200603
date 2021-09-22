<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="T2Apply.aspx.cs" Inherits="DMS.Website.Pages.ContractKendo.TTwo.T2Apply" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">

    <link href="../style/MyComon.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="ContractId" class="FrameControl" />
    <input type="hidden" id="ContractType" class="FrameControl" />
    <input type="hidden" id="DeptId" class="FrameControl" />
    <input type="hidden" id="SubDepId" class="FrameControl" />
    <input type="hidden" id="DealerType" class="FrameControl" />
    <input type="hidden" id="ExportId" class="FrameControl" />
    <input type="hidden" id="DealerId" class="FrameControl" />
    <input type="hidden" id="PlatformId" class="FrameControl" />
    <input type="hidden" id="Phone" class="FrameControl" />

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
                            <div class="panel-body" id="PnlContractContent">
                                <table style="width: 100%;" class="KendoTable">
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;平台名称</td>
                                        <td style="width: 15%;">
                                            <div id="PlatformName" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;平台地址</td>
                                        <td style="width: 15%;">
                                            <div id="PlatformAddress" class="FrameControl"></div>
                                        </td>

                                    </tr>
                                    <tr>
                                       <%-- <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;平台邮编</td>
                                        <td style="width: 15%;">
                                            <div id="PlatformPostCode" class="FrameControl invalid"></div>
                                        </td>--%>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;平台开户行</td>
                                        <td style="width: 15%;">
                                            <div id="PlatformBank" class="FrameControl invalid"></div>
                                        </td>
                                        <td style="width: 10%;display:none"><i class='fa fa-blank'></i>&nbsp;平台联系人</td>
                                        <td style="width: 15%;display:none">
                                            <div id="PlatformContact" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <%--<tr>
                                       <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;平台传真</td>
                                        <td style="width: 15%;">
                                            <div id="PlatformFax" class="FrameControl invalid"></div>
                                        </td>
                                        
                                    </tr>--%>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;二级经销商名称</td>
                                        <td style="width: 15%;">
                                            <div id="DealerName" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;二级经销商地址</td>
                                        <td style="width: 15%;">
                                            <div id="DealerAddress" class="FrameControl"></div>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;二级经销商开户行</td>
                                        <td style="width: 15%;">
                                            <div id="DealerBank" class="FrameControl invalid"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;二级经销商联系人</td>
                                        <td style="width: 15%;">
                                            <div id="DealerContact" class="FrameControl invalid"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <%--<td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;二级经销商邮编</td>
                                        <td style="width: 15%;">
                                            <div id="DealerPostCode" class="FrameControl invalid"></div>
                                        </td>--%>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;二级经销商联系人电话</td>
                                        <td style="width: 15%;">
                                            <div id="DealerPhone" class="FrameControl invalid"></div>
                                        </td>
                                    </tr>
                                   
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;协议起始日期</td>
                                        <td style="width: 15%;">
                                            <div id="AgreementStartDate" class="FrameControl"></div>
                                        </td>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;协议终止日期</td>
                                        <td style="width: 15%;">
                                            <div id="AgreementEndDate" class="FrameControl"></div>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;合同保证金(万)</td>
                                        <td style="width: 15%;">
                                            <div id="Guarantee" class="FrameControl invalid"></div>
                                        </td>
                                    </tr>

                                    <tr style="height: 36px;" class="ProxyTemplate">
                                        <td><i class='fa fa-blank'></i>其它附件</td>
                                        <td colspan="3">
                                            <div >
                                                <button hidden id="BtnDownLoadProxyTemplate" class="" style="margin-right: 30px;"><i class='fa fa-cloud-download'></i>&nbsp;&nbsp;下载模板</button>
                                                <button hidden id="BtnUploadProxy" class="" style="margin-right: 30px;"><i class='fa fa-cloud-upload'></i>&nbsp;&nbsp;上传文件</button>
                                            </div>
                                            <div style="display: none;">
                                                <input type="file" id="UploadProxyfiles" name="files" style="display: none;" />
                                            </div>
                                            <div style="display: none;" id="DivUploadProxy" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <%--<tr style="height: 36px;">
                                        <td><i class='fa fa-blank'></i>质量自评检查表</td>
                                        <td colspan="3">
                                            <div style="display: inline-block;">
                                                <button id="BtnUploadQualityChecklist" class="" style="margin-right: 30px;"><i class='fa fa-cloud-upload'></i>&nbsp;&nbsp;上传文件</button>
                                            </div>
                                            <div style="display: none;">
                                                <input type="file" id="FileQualityChecklist" name="files" style="display: none;" />
                                            </div>
                                            <div style="display: inline-block;" id="DivQualityChecklist" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <tr style="height: 36px;">
                                        <td><i class='fa fa-blank'></i>法人代表授权委托书</td>
                                        <td colspan="3">
                                            <div style="display: inline-block;">
                                                <button id="BtnUploadAuthorization" class="" style="margin-right: 30px;"><i class='fa fa-cloud-upload'></i>&nbsp;&nbsp;上传文件</button>
                                            </div>
                                            <div style="display: none;">
                                                <input type="file" id="FileAuthorization" name="files" style="display: none;" />
                                            </div>
                                            <div style="display: inline-block;" id="DivAuthorization" class="FrameControl"></div>
                                        </td>
                                    </tr>
                                    <tr style="height: 36px;">
                                        <td><i class='fa fa-blank'></i>培训签到表</td>
                                        <td colspan="3">
                                            <div style="display: inline-block;">
                                                <button id="BtnUploadTrainRegist" class="" style="margin-right: 30px;"><i class='fa fa-cloud-upload'></i>&nbsp;&nbsp;上传文件</button>
                                            </div>
                                            <div style="display: none;">
                                                <input type="file" id="FileTrainRegist" name="files" style="display: none;" />
                                            </div>
                                            <div style="display: inline-block;" id="DivTrainRegist" class="FrameControl"></div>
                                        </td>
                                    </tr>--%>
                                    <tr>
                                        <td></td>
                                    </tr>
                                    <tr style="display:none;">
                                        <td colspan="4">
                                           <div id="ReadTemplateList"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td colspan="2">
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
    <script type="text/javascript" src="../script/T2Apply.js?1212"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            Page.InitPage();
        })
    </script>
</asp:Content>
