<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ShipmentListInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Shipment.ShipmentListInfo" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .DetailTab {
            margin:0 auto;
            width:97%;
            height:320px;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hiddIsModifyStatus" />
    <input type="hidden" id="IsNewApply" />
    <input type="hidden" id="WinSLOrderId" class="FrameControl" />
    <input type="hidden" id="WinSPOId" class="FrameControl" />
    <input type="hidden" id="WinIsShipmentUpdate" class="FrameControl" />
    <input type="hidden" id="WinShipmentType" class="FrameControl" />
    <input type="hidden" id="WinIsAuth" class="FrameControl" />
    <input type="hidden" id="HidShipDate" class="FrameControl"/>
    <input type="hidden" id="WinAutDealer" class="FrameControl"/>
    <input type="hidden" id="WinIsModified"/>
    <input type="hidden" id="HidDealerType" />
    <input type="hidden" id="HidChooseProduct" />
    <input type="hidden" id="HidChooseHospital" />
    <div class="content-main">
        <div id="winSLDetailLayout" class="col-xs-12" style="padding:5px;">
            <style>
                #winSLDetailLayout .row {
                    margin: 0px;
                }
            </style>
            <div class="row" style="width:100%;margin:0 auto;display:inline-block;">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="col-xs-12" style="padding:0px;">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinSLDealer" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        单据类型：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinSLOrderType" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>产品线：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinSLProductLine" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        发票号码：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinSLInvoiceNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        销售单号：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinSLOrderNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>用量日期：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinSLShipmentDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        发票日期：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinSLInvoiceDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        单据状态：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinSLOrderStatus" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>销售医院：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinSLHospital" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        发票抬头：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinSLInvoiceHead" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        单据备注：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinSLOrderRemark" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-7 col-field" style="padding-bottom:5px;">
                                    <a id="BtnSLReason"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" style="width:100%;margin:0 auto;display:inline-block;">
                <div id="DivSLBasicInfo" style="border: 0;">
                    <ul>
                        <li class="k-state-active">产品明细
                        </li>
                        <li>操作记录
                        </li>
                        <li>附件
                        </li>
                    </ul>
                    <div style="padding: 0px;">
                        <div class="col-xs-12 DetailTab">
                            <%--<div class="row">
                                <div class="box box-primary">
                                    <div class="box-header with-border">
                                        <i class='fa fa-plus-square'></i>&nbsp;<span id="spGP2SumQty"></span>&nbsp;
                                        <i class='fa fa-plus-square'></i>&nbsp;<span id="spGP2SumPrice"></span>
                                        <div style="float:right;"><a id="BtnSLAddProduct"></a></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="box box-primary">
                                    <div class="box-body" style="padding: 0px;">
                                        <div class="col-xs-12" style="padding-left:0px;">
                                            <div class="row">
                                                <div id="RstWinSLProductList" class="k-grid-page-20"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>--%>
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <i class='fa fa-plus-square'></i>&nbsp;<span id="spGP2SumQty"></span>&nbsp;
                                    <i class='fa fa-plus-square'></i>&nbsp;<span id="spGP2SumPrice"></span>
                                    <div style="float:right;"><a id="BtnSLAddProduct"></a></div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding: 0px;">
                                        <div class="row">
                                            <div id="RstWinSLProductList" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div style="padding: 0px;">
                        <div class="col-xs-12 DetailTab">
                            <div class="row">
                                <div class="box box-primary">
                                    <div class="box-body" style="padding: 0px;">
                                        <div class="col-xs-12" style="padding-left:0px;">
                                            <div class="row">
                                                <div id="RstWinSLOPLog" class="k-grid-page-20"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div style="padding: 0px;">
                        <div class="col-xs-12 DetailTab">
                            <%--<div class="row">
                                <div class="box box-primary">
                                    <div class="box-header with-border">
                                        <div style="float:right;"><a id="BtnSLAddAttach"></a></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="box box-primary">
                                    <div class="box-body" style="padding: 0px;">
                                        <div class="col-xs-12" style="padding-left:0px;">
                                            <div class="row">
                                                <div id="RstWinSLAttachList" class="k-grid-page-20"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>--%>
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <div style="float:right;"><a id="BtnSLAddAttach"></a></div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding: 0px;">
                                        <div class="row">
                                            <div id="RstWinSLAttachList" class="k-grid-page-20"></div>
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
    <div id="winShipmentOperationLayout" style="display:none;height:280px;">
        <style>
            #winShipmentOperationLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;报台信息</h3>
                </div>
                <div class="box-body">
                    <div class="col-xs-12" style="padding:0px;">
                        <div class="row"> 
                            <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    科室名称：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSOOfficeName" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    病人性别：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSOPatientGender" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    医生姓名：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSODoctorName" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    病人身份证号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSOPatientPIN" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    病人姓名：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSOPatientName" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    住院号码：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSOHospitalNo" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="box-footer">
                    <div class="col-xs-12 col-buttom" style="padding:0px 5px;">
                        <a id="BtnSaveOperation"></a>
                        <a id="BtnCancelOperation"></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winReasonLayout" style="display:none;height:280px;">
        <style>
            #winReasonLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;未上传附件单据</h3>
                </div>
                <div class="box-body">
                    <div>
                        <div class="row">
                            <div id="RstWinSLReason" class="k-grid-page-20"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winSLAttachmentLayout" style="display:none;height:185px;">
        <style>
            #winSLAttachmentLayout .row {
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
                                    <input name="files" id="WinSLAttachUpload" type="file" aria-label="files" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;text-align:center;">
            <a id="BtnSLUploadAttach"></a>
            <a id="BtnSLClearAttach"></a>
        </div>
    </div>
    <div id="winUpdateOrderPriceLayout" style="display:none;height:280px;">
        <style>
            #winUpdateOrderPriceLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div>
                            <div class="row">
                                <div id="RstSLWinOrderPrice" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-10 col-buttom" style="width:99%;">
            <a id="BtnWinSaveUpdatePrice"></a>
        </div>
    </div>
     <div id="winCheckSubmitResultLayout" style="display:none;height:345px;">
        <style>
            #winCheckSubmitResultLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div class="row" style="border-bottom: 1px solid lightgrey;">
                        <span id="spWrongCnt" style="color:red;"></span><br />
                        <span id="spCorrectCnt" style="color:green;"></span><br />
                        <span id="spSumQty"></span><br />
                        <span id="spSumPrice"></span>
                    </div>
                    <div class="row">
                        <div id="RstSLWinCheckResult" class="k-grid-page-20"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;">
            <a id="BtnSLSubmitCorrect"></a>
            <a id="BtnSLExportError"></a>
            <a id="BtnSLLastStep"></a>
        </div>
    </div>
     <div id="winSLShipmentAdjustLayout" style="display:none;height:480px;">
        <style>
            #winSLShipmentAdjustLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    经销商：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSADealer" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    产品线：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSAProductLine" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    用量日期：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSAUseDate" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    销售医院：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSAHospital" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    调整原因：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSAAdjustReason" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    实际用量日期：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSAShipDate" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div style="height:325px;overflow-y:scroll;">
                <div class="row">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <div style="float:right;"><a id="BtnSAAddHistoryData"></a></div>
                        </div>
                        <div class="box-body">
                            <div>
                                <div class="row">
                                    <div id="RstSAHistoryOrderData" class="k-grid-page-20"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <div style="float:right;"><a id="BtnSAAddInventoryData"></a></div>
                        </div>
                        <div class="box-body">
                            <div>
                                <div class="row">
                                    <div id="RstSAInventoryData" class="k-grid-page-20"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-10 col-buttom" style="width:99%;">
            <a id="BtnWinAddAdjust"></a>
            <a id="BtnWinCloseAdjust"></a>
        </div>
    </div>
    <div id="winSLShipmentChooseItemLayout" style="display:none;height:480px;">
        <style>
            #winSLShipmentChooseItemLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    分仓库：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSCWarehouse" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    序列号/批号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSCLotNumber" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    产品型号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSCCFN" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    有效期：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSCExpired" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    二维码：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSCQrCode" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    查询结果说明：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSCResultInfo" class="FrameControl">
                                        <span style="color:red;">当产品记录大于200条，以下产品列表仅显示有效期最近的200条记录！</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-11 col-buttom">
                                <a id="BtnSCImportQrCode"></a>
                                <a id="BtnSCSearch"></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div style="height:263px;overflow-y:scroll;">
                <div class="row">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;查询结果</h3>
                        </div>
                        <div class="box-body">
                            <div>
                                <div class="row">
                                    <div id="RstSCInventoryItem" class="k-grid-page-20"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-10 col-buttom" style="width:99%;">
            <a id="BtnWinSCAdd"></a>
            <a id="BtnWinSCClose"></a>
        </div>
    </div>
    <div id="winSLShipmentHistoryLayout" style="display:none;height:480px;">
        <style>
            #winSLShipmentHistoryLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    仓库：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSHWarehouse" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    销售医院：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSHHospital" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    销售单号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSHShipmentNo" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    产品型号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSHCFN" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    序列号/批号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSHLotNumber" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    二维码：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSHQrCode" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-11 col-buttom">
                                <a id="BtnSHSearch"></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div style="height:293px;overflow-y:scroll;">
                <div class="row">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;历史销售记录</h3>
                        </div>
                        <div class="box-body">
                            <div>
                                <div class="row">
                                    <div id="RstSHHistoryItem" class="k-grid-page-20"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-10 col-buttom" style="width:99%;">
            <a id="BtnWinSHAdd"></a>
            <a id="BtnWinSHClose"></a>
        </div>
    </div>
    <div id="winSLShipmentInventoryLayout" style="display:none;height:480px;">
        <style>
            #winSLShipmentInventoryLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    仓库：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSIWarehouse" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    序列号/批号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSILotNumber" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    产品型号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSICFN" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    有效期：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSIExpired" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    二维码：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinSIQrCode" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-11 col-buttom">
                                <a id="BtnSIImportQrCode"></a>
                                <a id="BtnSISearch"></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div style="height:293px;overflow-y:scroll;">
                <div class="row">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;当前库存记录</h3>
                        </div>
                        <div class="box-body">
                            <div>
                                <div class="row">
                                    <div id="RstSIInventoryItem" class="k-grid-page-20"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-10 col-buttom" style="width:99%;">
            <a id="BtnWinSIAdd"></a>
            <a id="BtnWinSIClose"></a>
        </div>
    </div>
    <div id="winSCQRCodeImportLayout" style="display:none;height:180px;">
        <style>
            #winSCQRCodeImportLayout .row {
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
                                    <input name="files" id="WinSCQrCodeImport" type="file" aria-label="files" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;text-align:center;">
            <a id="BtnSCQrCodeTemplate"></a>
        </div>
    </div>
    <div id="winSIQRCodeImportLayout" style="display:none;height:180px;">
        <style>
            #winSIQRCodeImportLayout .row {
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
                                    <input name="files" id="WinSIQrCodeImport" type="file" aria-label="files" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;text-align:center;">
            <a id="BtnSIQrCodeTemplate"></a>
        </div>
    </div>
    <div id="winSLShipmentAuthorLayout" style="display:none;height:480px;">
        <style>
            #winSLShipmentAuthorLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    产品编号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinAutUPN" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    医院：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinAutHospital" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    用量日期：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinAutDate" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-11 col-buttom">
                                <a id="BtnAutSearch"></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;查询结果</h3>
                    </div>
                    <div class="box-body">
                        <div>
                            <div class="row">
                                <div id="RstAutResult" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom">
        <a id="BtnWinDraft"></a>
        <a id="BtnWinDelete"></a>
        <a id="BtnWinNextMove"></a>
        <a id="BtnWinRevoke"></a>
        <a id="BtnWinPrice"></a>
        <a id="BtnWinOperation"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="/Revolution/Resources/js/Calculate.js" type="text/javascript"></script>
    <script type="text/javascript" src="Script/ShipmentListInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ShipmentListInfo.Init();
        });
    </script>
</asp:Content>
