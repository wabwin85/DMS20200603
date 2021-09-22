<%@ Page Title="经销商非正式授权管理" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="TenderAuthorizationInfo.aspx.cs"
    Inherits="DMS.Website.Revolution.Pages.Contract.TenderAuthorizationInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="isNewApply" class="FrameControl" />
    <input type="hidden" id="InstanceId" class="FrameControl" />
    <input type="hidden" id="HospitalId" class="FrameControl" />
    <input type="hidden" id="PCTId" class="FrameControl" />
    <input type="hidden" id="ProductString" class="FrameControl" />
    <input type="hidden" id="Status" class="FrameControl" />
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;基本信息</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">

                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        授权编号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptAtuNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        申请人
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptAtuApplyUser" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        申请时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptAtuApplyDate" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        授权类型
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptAuthorizationInfo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        授权开始时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptAtuBeginDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        授权终止时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptAtuEndDate" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">    
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品线
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptProductLine" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        SubBU
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptSubBU" class="FrameControl"></div>
                                    </div>
                                </div>                              
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        是否三证合一
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptSAtulicenseType" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">                                                                   
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商名称
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptDealerName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商类型
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptDealerType" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div id="divSuperior" class="col-xs-12 col-sm-6 col-md-4 col-group" style="display:none;">
                                    <div class="col-xs-4 col-label">
                                        上级平台
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptSuperiorDealer" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">   
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        邮寄及联系方式
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="IptAtuMailAddress" class="FrameControl"></div>
                                    </div>
                                </div>
                                
                            </div>
                            <div class="row">
                                 <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        备注
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="IptAtuRemark" class="FrameControl"></div>
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
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;授权医院列表</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div class="col-buttom text-left">
                                    <a id="btnAddHospital"></a>
                                    <a id="btnDeleteHospital"></a>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstHospital" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

             <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;授权产品</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div class="col-buttom text-left">
                                    <a id="btnAddProduct"></a>
                                    <a id="btnDeleteProduct"></a>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstProduct" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;附件信息</h3>
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



        </div>
    </div>
    <div id="windowLayoutHospital" style="display: none;">
        <style>
            #windowLayout .row {
                margin: 0px;
            }

            .windowsfoot-btn {
                width: 100%;
                margin-top: 20px;
                text-align: center;
            }
        </style>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    医院编号:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddHospitalNo" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    医院名称:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddHospitalName" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    医院科室:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddHosDepartment" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="windowsfoot-btn">
            <a id="depSave"></a>
            <a id="depColse"></a>
        </div>
    </div>
    <div id="windowLayoutProduct" style="display: none;">
        <style>
            #windowLayout .row {
                margin: 0px;
            }

            .windowsfoot-btn {
                width: 100%;
                margin-top: 20px;
                text-align: center;
            }
        </style>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div id="RstProductAddList" class="k-grid-page-all"></div>
            </div>
        </div>
        <div class="windowsfoot-btn">
            <a id="proSave"></a>
            <a id="proColse"></a>
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
                                            <i class='fa fa-fw fa-require'></i>文件类型：
                                        </div>
                                        <div class="col-xs-8 col-field">
                                            <div id="fileType" class="FrameControl"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-12 col-group">
                                        <div class="col-xs-3 col-label">
                                            <i class='fa fa-fw fa-require'></i>文件：
                                        </div>
                                        <div class="col-xs-8 col-field WinFileUploadTender" id="divWinFileUploadTender_01">
                                            <input name="files" id="WinFileUploadTender_01" type="file" aria-label="files"/>
                                        </div>
                                        <div class="col-xs-8 col-field WinFileUploadTender" id="divWinFileUploadTender_02">
                                            <input name="files" id="WinFileUploadTender_02" type="file" aria-label="files"/>
                                        </div>
                                        <div class="col-xs-8 col-field WinFileUploadTender" id="divWinFileUploadTender_03">
                                            <input name="files" id="WinFileUploadTender_03" type="file" aria-label="files"/>
                                        </div>
                                        <div class="col-xs-8 col-field WinFileUploadTender" id="divWinFileUploadTender_04">
                                            <input name="files" id="WinFileUploadTender_04" type="file" aria-label="files"/>
                                        </div>
                                        <div class="col-xs-8 col-field WinFileUploadTender" id="divWinFileUploadTender_05">
                                            <input name="files" id="WinFileUploadTender_05" type="file" aria-label="files"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom" id="PnlButton">
        <a id="BtnReturn"></a>
        <a id="BtnSave"></a>
        <a id="BtnDelete"></a>
        <a id="BtnSubmit"></a>
        <a id="BtnExport"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/TenderAuthorizationInfo.js?v=<%=DateTime.Now %><%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            TenderAuthorizationInfo.Init();
        });
    </script>
</asp:Content>


