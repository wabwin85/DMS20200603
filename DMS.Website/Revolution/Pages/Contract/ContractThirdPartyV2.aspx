<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ContractThirdPartyV2.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Contract.ContractThirdPartyV2" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .DetailTab {
            margin:0 auto;
            width:94%;
            height:95%;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="HidDealerId" class="FrameControl" />
    <input type="hidden" id="DisclosureId" class="FrameControl" />
    <input type="hidden" id="HospitalId" class="FrameControl" />
    <input type="hidden" id="HidType" class="FrameControl" />
    <input type="hidden" id="HidApproveStatus" class="FrameControl" />
    <input type="hidden" id="HidDealerType" />
    <input type="hidden" id="HidApplicationNote" />
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <div class="col-xs-12 col-buttom" id="PnlMainButton">
                            <a id="BtnCreatePdf"></a>
                            <a id="BtnCancel"></a>
                            <a id="BtnHelp"></a>
                            <a id="BtnHelpTemplate"></a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;第三方披露表</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12">
                                        <div class="row">
                                            <div><p style="color:red;">提示：第三方公司披露的详细要求以及需签署的文件模板请从右上角“使用帮助及模板”中获得</p></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="box box-primary">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">&nbsp;公司信息</h3>
                                    </div>
                                    <div class="box-body" style="padding: 0px;">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                                    <div class="col-xs-6 col-label">
                                                        公司名称（本表简称“公司”)：
                                                    </div>
                                                    <div class="col-xs-6 col-field">
                                                        <div id="QryDealerName" class="FrameControl"></div>
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
                                        <h3 class="box-title">&nbsp;第三方医院信息</h3>
                                    </div>
                                    <div class="box-body" style="padding: 0px;">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                                    <div class="col-xs-4 col-label">
                                                        医院名称：
                                                    </div>
                                                    <div class="col-xs-8 col-field">
                                                        <div id="QryHospitalName" class="FrameControl"></div>
                                                    </div>
                                                </div>
                                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                                    <div class="col-xs-4 col-label">
                                                        状态：
                                                    </div>
                                                    <div class="col-xs-8 col-field">
                                                        <div id="QryType" class="FrameControl"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-12 col-buttom" id="PnlButton">
                                                    <a id="BtnQuery"></a>
                                                    <a id="BtnExport"></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="box box-primary">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">&nbsp;授权医院信息</h3>
                                    </div>
                                    <div class="box-body" style="padding: 0px;">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <div id="RstAutHospList" class="k-grid-page-20"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="box box-primary">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">&nbsp;披露医院信息</h3>
                                    </div>
                                    <div class="box-body" style="padding: 0px;">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <div id="RstPubHospList" class="k-grid-page-20"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="box box-primary">
                                    <div class="box-body" style="padding: 0px;">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <div><p>兹通知，在贵司披露第三方公司时，蓝威或其代理公司可能会购买尽职调查验证报告及/或调查性的尽职调查报告，以获取有关各种事项的信息，包括但不限于公司结构、所有权、商务实践、银行记录、资信状况、破产程序、犯罪记录、民事记录、一般声誉及个人品质（包括前述任何项目，以及个人的教育程度、从业历史等），并有权根据报告结果拒绝与该第三方公司合作。若贵司未主动披露第三方公司，蓝威或其代理公司发现后，蓝威或其代理公司保留扣减贵司返利，直至解除合同取消授权等措施的权利。</p></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winThirdPartyLayout" style="display:none;height:97%;">
        <style>
            #winThirdPartyLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:100%;height:92%;overflow-y:scroll;">
            <div id="DivBasicInfo" style="border: 0;">
                <ul>
                    <li class="k-state-active">政策概要
                    </li>
                    <li>附件
                    </li>
                </ul>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="box box-primary">
                            <div class="box-body" style="padding: 0px;">
                                <div class="col-xs-12" style="padding: 0px;">
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                医院名称：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinHospitalName" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row" id="divBeginDate" style="display:none;">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                披露开始日期：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinBeginDate" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row" id="divEndDate" style="display:none;">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                披露结束日期：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinEndDate" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row" id="divTermDate" style="display:none;">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                终止披露日期：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinTerminationDate" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                合作产品线：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinProductLine" class="FrameControl"></div>
                                                <a id="BtnAddLine"></a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row" id="divTip">
                                        <label style="color:red;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;提示：请选择该第三方公司在该医院销售的所有产品线</label>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                第三方公司：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinCompanyName" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                与贵司或医院关系：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinRsm" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <label id="lbWinRsmRemark"></label>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                提交人姓名/职务：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinSubmitName" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                提交人手机：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinPhone" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                披露备注：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinApplicationNote" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row" id="divApproveRemark" style="display:none;">
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                            <div class="col-xs-4 col-label">
                                                审批备注：
                                            </div>
                                            <div class="col-xs-7 col-field">
                                                <div id="WinApprovalRemark" class="FrameControl"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <div style="float:right;"><a id="BtnAddAttach"></a></div>
                            </div>
                            <div class="box-body" style="padding: 0px;">
                                <div class="col-xs-12" style="padding: 0px;">
                                    <div class="row">
                                        <div id="RstWinAttachList" class="k-grid-page-20"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-10 col-buttom" style="width:99%;">
            <a id="BtnWinEndThirdParty"></a>
            <a id="BtnWinSubmit"></a>
            <a id="BtnWinRenew"></a>
            <a id="BtnWinApproveEnd"></a>
            <a id="BtnWinRefuseEnd"></a>
            <a id="BtnWinThirdPartyApproval"></a>
            <a id="BtnWinThirdPartyReject"></a>
            <a id="BtnWinThirdPartySubmit"></a>
            <a id="BtnWinCancel"></a>
        </div>
    </div>
    <div id="winAttachmentLayout" style="display:none;height:185px;">
        <style>
            #winAttachmentLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div>
                        <div class="row">
                            <div class="col-xs-12 col-group">
                                <div class="col-xs-3 col-label">
                                    <i class='fa fa-fw fa-require'></i>文件：
                                </div>
                                <div class="col-xs-8 col-field">
                                    <input name="files" id="WinAttachUpload" type="file" aria-label="files" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winAddLineLayout" style="display:none;height:330px;">
        <style>
            #winAddLineLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div>
                            <div class="row">
                                <div id="RstWinProductLine" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-10 col-buttom" style="width:99%;">
            <a id="BtnWinAddItems"></a>
            <a id="BtnWinClose"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/ContractThirdPartyV2.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(function () {
            ContractThirdPartyV2.Init();
        });
    </script>
</asp:Content>
