<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="DealerContractEditor.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.DealerContractEditor" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input id="hiddenCatagoryId" type="hidden" />
    <input id="hiddenProductLine" type="hidden" class="FrameControl" />
    <input id="hidDealerId" type="hidden" class="FrameControl" />
    <input id="ContractId" type="hidden" class="FrameControl" />
    <input id="hiddenId" type="hidden" class="FrameControl" />
    <input id="hidSelectProductLineId" type="hidden" class="FrameControl" />
    <input id="hidSelectNodeId" type="hidden" value="" />
    <input id="ClsNode" type="hidden" class="FrameControl" />
    <input id="hidOperatePartType" type="hidden" />

    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">&nbsp;授权列表(<label id="lbDealerName" class="box-title" style="font-weight: normal;"></label>)</h3>
                    </div>
                    <div class="box-header with-border">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品线：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="ProductLine" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        授权类型：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="AuthType" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        授权开始时间：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryAuthStartDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        授权截止时间：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryAuthStopDate" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom">
                                    <a id="BtnQuery"></a>
                                    <a id="BtnNew"></a>
                                    <a id="BtnDelete"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstAuthorizationList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-filter'></i>&nbsp;包含医院</h3>
                    </div>
                    <div class="box-header with-border" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        医院名称：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="HosHospitalName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        医院授权开始时间：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryHosStartDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        医院授权截止时间：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryHosStopDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        未设置医院授权时间：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="HosNoAuthDate" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom">
                                    <a id="BtnSearchHospital"></a>
                                    <a id="BtnAddHospital"></a>
                                    <a id="BtnCopyHospital"></a>
                                    <a id="BtnSelectedDel"></a>
                                    <a id="BtnDeleteHospital"></a>
                                    <a></a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstAuthHospitalList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--授权属性--%>
    <div id="winAuthorizationEditor" style="display: none;">
        <style>
            #winAuthorizationEditor .row {
                margin: 0px;
            }

            .windowsfoot-btn {
                width: 100%;
                margin-top: 20px;
                text-align: center;
            }
        </style>
        <div style="overflow-y: auto;">
            <div class="row">
                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                    <div class="col-xs-3 col-label">
                        产品线：
                    </div>
                    <div class="col-xs-8 col-field">
                        <div id="IptProductLine" class="FrameControl"></div>
                    </div>
                </div>
                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                    <div class="col-xs-3 col-label">
                        产品分类：
                    </div>
                    <div class="col-xs-8 col-field">
                        <div id="IptCatagoryName" class="FrameControl" style="float: left; width: 80% !important;"></div>
                        <a id="selectType"></a>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                    <div class="col-xs-3 col-label">
                        授权开始时间：
                    </div>
                    <div class="col-xs-8 col-field">
                        <div id="IptAuthStartDate" class="FrameControl"></div>
                    </div>
                </div>
                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                    <div class="col-xs-3 col-label">
                        授权结束时间：
                    </div>
                    <div class="col-xs-8 col-field">
                        <div id="IptAuthStopDate" class="FrameControl"></div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                    <div class="col-xs-3 col-label">
                        产品描述：
                    </div>
                    <div class="col-xs-8 col-field">
                        <div id="IptProductDesc" class="FrameControl"></div>
                    </div>
                </div>
                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                    <div class="col-xs-3 col-label">
                        授权类型：
                    </div>
                    <div class="col-xs-8 col-field">
                        <div id="IptAuthTypeForEdit" class="FrameControl"></div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                    <div class="col-xs-3 col-label">
                        区域描述：
                    </div>
                    <div class="col-xs-8 col-field">
                        <div id="IptNote" class="FrameControl"></div>
                    </div>
                </div>
            </div>
            <div class="row" style="width: 99%;">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <a id="BtnAddAttach" style="margin-right: 5px;"></a>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-11.5">
                            <div class="row">
                                <div id="RstAttachmentList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="windowsfoot-btn">
            <a id="BtnSaveAut"></a>
            <a id="BtnCancelAut"></a>
        </div>
    </div>
    <%--选择产品线树结构--%>
    <div id="winPartsSelectorLayout" style="display: none;">
        <style>
            .k-split-button {
                margin-top: 5px !important;
            }

            .dialogContent {
                padding: 10px 10px 0 10px;
            }

            #filterText {
                width: 100%;
                box-sizing: border-box;
                padding: 6px;
                border-radius: 3px;
                border: 1px solid #428bca;
            }

            #treeview {
                margin: 5px 0 0 0;
                height: 450px;
                overflow-y: auto;
                border: 1px solid #428bca;
            }

            .bottom {
                float: left;
                width: 100%;
                text-align: right;
                margin-top: 30px;
                margin-bottom: 5px;
            }

            .k-state-border-down {
                background: none !important;
                color: red;
            }

            .col-group .col-label {
                width: 30%;
                display: inline-block;
            }

            .col-group .col-field {
                width: 60%;
                display: inline-block;
            }
        </style>
        <div class="k-content">
            <div id="divSplit">
                <div class="panel-left" style="overflow-y: auto; height: 90%;">
                    <div id="dialog">
                        <div class="dialogContent">
                            <div>
                                <span>产品线：</span><div id="QryProductLine" class="FrameControl" style="display: inline-flex; min-width: 60%;"></div>
                            </div>
                            <input id="filterText" type="text" placeholder="搜索关键字" style="display: none;" />
                            <div id="treeview" style="height: 250px !important;"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal" id="popoverModal" aria-hidden="true" style="background-color: black; opacity: 0.5; display: none;">
            </div>
        </div>
        <div class="windowsfoot-btn">
            <a id="BtnPSSave"></a>
            <a id="BtnPSCancel"></a>
        </div>
    </div>
    <%--附件上传弹窗windows--%>
    <div id="winAttachmentLayout" style="display: none; height: 185px;">
        <style>
            #winAttachmentLayout .row {
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
                                    <input name="files" id="WinAttachUpload" type="file" aria-label="files" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--选择医院--%>
    <div id="winHospitalSelectorLayout" style="display: none;">
        <style>
            #winHospitalSelectorLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width: 99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div class="row">
                        <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                            <div class="col-xs-4 col-label">
                                省份：
                            </div>
                            <div class="col-xs-8 col-field">
                                <div id="WinHSProvince" class="FrameControl"></div>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                            <div class="col-xs-4 col-label">
                                地区：
                            </div>
                            <div class="col-xs-8 col-field">
                                <div id="WinHSCity" class="FrameControl"></div>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                            <div class="col-xs-4 col-label">
                                区/县：
                            </div>
                            <div class="col-xs-8 col-field">
                                <div id="WinHSDistrict" class="FrameControl"></div>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                            <div class="col-xs-4 col-label">
                                医院：
                            </div>
                            <div class="col-xs-8 col-field">
                                <div id="WinHSHospital" class="FrameControl"></div>
                            </div>
                        </div>
                    </div>
                    <div style="height: 300px; overflow-y: scroll;">
                        <div class="row">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;查询结果</h3>
                                </div>
                                <div class="box-body">
                                    <div>
                                        <div class="row">
                                            <div id="RstHospitalSelectorList" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="windowsfoot-btn">
            <a id="BtnHSSave"></a>
            <a id="BtnHSCancel"></a>
        </div>
    </div>
    <%--复制医院--%>
    <div id="winAuthorizationSelectorLayout" style="display: none;">
        <style>
            #winAuthorizationSelectorLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width: 99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div class="row">
                        <div id="RstAuthorizationSelectorList" class="k-grid-page-20"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="windowsfoot-btn">
            <a id="BtnASCopy"></a>
            <a id="BtnASCancel"></a>
        </div>
    </div>
    <%--删除医院--%>
    <div id="winHospitalSelectdDelLayout" style="display: none;">
        <style>
            #winHospitalSelectdDelLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width: 99%;">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    省份：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinHDProvince" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    地区：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinHDCity" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    区/县：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinHDDistrict" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    医院名称：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinHDHospital" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-11 col-buttom">
                                <a id="BtnHDQuery"></a>
                                <a id="BtnHDDelete"></a>
                                <a id="BtnHDCancel"></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div style="height: 300px; overflow-y: scroll;">
                <div class="row">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;查询结果</h3>
                        </div>
                        <div class="box-body">
                            <div>
                                <div class="row">
                                    <div id="RstHospitalSelectdDelList" class="k-grid-page-20"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- 包含医院修改授权时间--%>
    <div id="winHospitalUpdatelDateLayout" style="display: none;">
        <style>
            #winHospitalUpdatelDateLayout .row {
                margin: 0 auto;
            }

            .windowsfoot-btn {
                margin-top: 20px;
                text-align: center;
            }
        </style>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    授权开始时间:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="WinHosBeginDate" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    授权截止时间:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="WinHosEndDate" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="windowsfoot-btn">
                <a id="BtnHosUpdate"></a>
                <a id="BtnHosCancel"></a>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerContractEditor.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            DealerContractEditor.Init();
        });
    </script>
</asp:Content>
