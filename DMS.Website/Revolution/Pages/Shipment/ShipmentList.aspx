<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ShipmentList.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Shipment.ShipmentList" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">

    <link href="/resources/swfupload/css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/resources/swfupload/swfupload.js"></script>
    <script type="text/javascript" src="/resources/swfupload/swfupload.queue.js"></script>
    <script type="text/javascript" src="/resources/swfupload/fileprogress.js"></script>
    <script type="text/javascript" src="/resources/swfupload/filegroupprogress.js"></script>
    <script type="text/javascript" src="/resources/swfupload/handlers.js"></script>

    <style type="text/css">
        .DetailTab {
            margin: 0 auto;
            width: 96%;
            height: 295px;
        }

        html, body {
            padding: 0px;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="DealerListType" class="FrameControl" />
    <input type="hidden" id="WinSLOrderId" class="FrameControl" />
    <input type="hidden" id="WinIsModified" class="FrameControl" />
    <input type="hidden" id="WinIsShipmentUpdate" class="FrameControl" />
    <input type="hidden" id="WinShipmentType" class="FrameControl" />
    <input type="hidden" id="WinIsAuth" class="FrameControl" />
    <input type="hidden" id="HidShipDate" class="FrameControl" />
    <input type="hidden" id="HidDealerType" />
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-filter'></i>&nbsp;查询条件</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品线：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryProductLine" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDealerName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        状态：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryOrderStatus" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        用量日期：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryStartDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        销售医院：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryHospital" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        销售单号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryOrderNumber" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品型号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryCFN" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        序列号/批号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryLotNumber" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        导入时间：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QrySubmitDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        销售单类型：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryShipmentOrderType" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        发票状态：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryInvoiceStatus" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        发票号码：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryInvoiceNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        发票上报状态：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryInvoiceState" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        发票日期：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryInvoiceDate" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row" id="divRemark">
                                <span style="color: red;">您有超期未上传发票的销量单据</span>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom">
                                    <div class="btn-group" id="divUpload">
                                        <button data-toggle="dropdown" class="btn-primary k-button dropdown-toggle">
                                            <i class="icon-file icon-on-right bigger-110"></i>&nbsp;批量上传
                                            <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu dropdown-default">
                                            <li><a class="fa fa-upload" href="#" id="BtnUploadFile">&nbsp;批量上传发票附件</a></li>
                                            <li><a class="fa fa-upload" href="#" id="BtnUploadInvoice">&nbsp;批量导入发票号</a></li>
                                        </ul>
                                    </div>
                                    <div class="btn-group" id="divInsert">
                                        <button data-toggle="dropdown" class="btn-primary k-button dropdown-toggle">
                                            <i class="icon-file icon-on-right bigger-110"></i>&nbsp;新增销售单
                                            <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu dropdown-default">
                                            <li id="liInsert"><a class="fa fa-plus" href="#" id="BtnInsert">&nbsp;新增普通销售单</a></li>
                                            <li id="liInsertConsignment"><a class="fa fa-plus" href="#" id="BtnInsertConsignment">&nbsp;新增寄售出库单</a></li>
                                            <li id="liInsertBorrow"><a class="fa fa-plus" href="#" id="BtnInsertBorrow">&nbsp;新增借货销售单</a></li>
                                            <li id="liUpdate"><a class="fa fa-plus" href="#" id="BtnUpdate">&nbsp;销量单二维码替换</a></li>
                                            <li id="liUpdateConsignment"><a class="fa fa-plus" href="#" id="BtnUpdateConsignment">&nbsp;补寄售销售单</a></li>
                                        </ul>
                                    </div>
                                    <div class="btn-group">
                                        <button data-toggle="dropdown" class="btn-primary k-button dropdown-toggle">
                                            <i class="icon-file icon-on-right bigger-110"></i>&nbsp;导出
                                            <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu dropdown-default">
                                            <li><a class="fa fa-file-excel-o" href="#" id="BtnExport">&nbsp;导出</a></li>
                                            <li><a class="fa fa-file-excel-o" href="#" id="BtnExportShipment">&nbsp;导出销售单发票</a></li>
                                        </ul>
                                    </div>
                                    <a id="BtnConfirm"></a>
                                    <a id="BtnSearch"></a>
                                </div>
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
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstShipmentList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winShipmentInvoiceUploadLayout" style="display: none; height: 280px;">
        <style>
            #winShipmentInvoiceUploadLayout .row {
                margin: 0px;
            }

            #winShipmentInvoiceUploadLayout table td {
                padding: 5px;
            }
        </style>

        <div class="row" style="width: 99%;">
            <table>
                <tr>
                    <td style="padding: 5px;"><span id="spanButtonPlaceHolder"></span></td>
                    <td style="padding: 5px;"><span class="btn_upload" onclick='shipmentInvoiceStartUpload();'>
                        <img src="/resources/swfupload/images/swfBnt_upload.png" /></span></td>
                    <td style="padding: 5px;"><span class="btn_upload" onclick='shipmentInvoideUploadReset();'>
                        <img src="/resources/swfupload/images/swfBnt_reset.png" /></span>
                    </td>
                    <td style="padding: 5px;"><span class="btn_upload" onclick='shipmentInvoideUploadHelp();'>
                        <img src="/resources/swfupload/images/swfBnt_help.png" /></span>
                    </td>
                    <td style="padding: 5px;">
                        <div id="nameTip" class="onShow">
                            最多上传<span style="color: red;"> 50</span> 个附件,单文件最大 <span style="color: red;">20MB （同时请确保附件文件名与发票号一致！）
                            请确保按照发票上传要求拍摄发票照片</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="5" style="padding: 5px;">支持 *.*格式。&nbsp;&nbsp;&nbsp;<span id="spanUploadListDesc">共计 <span id="spanUploadTotalDesc" style="color: red">0</span> 个，成功上传 <span id="spanUploadSuccessDesc" style="color: red">0</span> 个，未上传 <span id="spanUploadFailureDesc" style="color: red">0</span> 个。</span></td>
                </tr>
            </table>
            <div class="uploadbox" style="float: left;">
                <span class="uploadbox_t">上传列表</span>
                <div id="divprogresscontainer"></div>
                <div id="divprogressGroup"></div>
                <div id="piclist">
                    <%--<ul>
                    </ul>--%>
                </div>
            </div>
            <div class="uploaderrorbox" style="float: left; margin-left: 10px;">
                <span class="uploadbox_t">未成功上传列表</span>
                <div id="divUploadErrorlist"></div>
            </div>
        </div>
    </div>
    <div id="winInvoiceHelpLayout" style="display: none; height: 460px;">
        <style>
            #winInvoiceHelpLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width: 99%;">
            <div style="padding: 5px; font-size: 14px; font-family: 微软雅黑; color: #0D0D0D; line-height: 22px;">
                <p>
                    <span style="">对于请求识别的增值税发票图片，推荐尺寸为<b>最短边高于1200像素</b>，保证图像质量，可以有效提高识别率。</span>
                </p>
                <p>
                    <br />
                </p>
                <p>
                    <span>增值税发票识别拍摄技巧，说明如下：</span>
                </p>
                <p>
                    <span>1.请保证光线充足，增值税发票上不要有阴影和反光；</span>
                </p>
                <p>
                    <span>2.请让增值税发票图片区域尽量充满整个拍摄预览区域，最好不低于80%的面积；</span>
                </p>
                <p>
                    <span>3.请对焦清晰后再进行拍摄；</span>
                </p>
                <p>
                    <span>4.请横屏拍摄；</span>
                </p>
                <p>
                    <br />
                </p>
                <p>
                    <span>拍摄示例如下：</span>
                </p>
            </div>
            <div>
                <p>
                    <span style="font-family: 微软雅黑; color: #0D0D0D">
                        <img width="434" height="247" src="/resources/images/InvoiceHelp.png" alt="InvoiceHelp" /></span>
                </p>
            </div>
        </div>
    </div>
    <div id="winInvoiceNoUploadLayout" style="display: none; height: 380px;">
        <style>
            #winInvoiceNoUploadLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row">
            <div class="box box-primary">
                <div class="box-body">
                    <div class="row">
                        <div class="col-xs-12 col-group">
                            <div class="col-xs-4 col-label">
                                <i class="fa fa-fw fa-require"></i>文件：
                            </div>
                            <div class="col-xs-7 col-field">
                                <input name="files" id="WinUploadInvoiceNo" type="file" aria-label="files" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-buttom" style="text-align: center;">
                            <a id="BtnWinUploadInvoiceNo"></a>
                            <a id="BtnWinClearInvoiceNo"></a>
                            <a id="BtnWinImportInvoiceNo"></a>
                            <a id="BtnWinDownInvoiceTemp"></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title"><i class='fa fa-fw fa-exclamation-triangle'></i>&nbsp;销售单发票号导入</h3>
                </div>
                <div class="box-body" style="padding: 0px;">
                    <div class="row">
                        <div id="RstWinInvoiceNo" class="k-grid-page-20"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="winSLDetailLayout" style="display: none; height: 590px;">
        <style>
            #winSLDetailLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width: 97%; margin: 0 auto; display: inline-block;">
            <div class="box box-primary">
                <div class="box-body">
                    <div class="col-xs-12" style="padding: 0px;">
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
                            <div class="col-xs-7 col-field" style="padding-bottom: 5px;">
                                <a id="BtnSLReason"></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" style="width: 97%; margin: 0 auto; display: inline-block;">
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
                                <div style="float: right;"><a id="BtnSLAddProduct"></a></div>
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
                                    <div class="col-xs-12" style="padding-left: 0px;">
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
                                <div style="float: right;"><a id="BtnSLAddAttach"></a></div>
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
        <div class="row" style="width: 97%; margin: 0 auto; display: inline-block;">
            <div class="col-xs-12 col-buttom" style="padding: 0px 5px;">
                <a id="BtnWinDraft"></a>
                <a id="BtnWinDelete"></a>
                <a id="BtnWinNextMove"></a>
                <a id="BtnWinRevoke"></a>
                <a id="BtnWinPrice"></a>
            </div>
        </div>
    </div>
    <div id="winReasonLayout" style="display: none; height: 280px;">
        <style>
            #winReasonLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width: 99%;">
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
    <div id="winSLAttachmentLayout" style="display: none; height: 185px;">
        <style>
            #winSLAttachmentLayout .row {
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
                                    <input name="files" id="WinSLAttachUpload" type="file" aria-label="files" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width: 99%; text-align: center;">
            <a id="BtnSLUploadAttach"></a>
            <a id="BtnSLClearAttach"></a>
        </div>
    </div>
    <div id="winUpdateOrderPriceLayout" style="display: none; height: 280px;">
        <style>
            #winUpdateOrderPriceLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="row" style="width: 99%;">
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
        <div class="col-xs-10 col-buttom" style="width: 99%;">
            <a id="BtnWinSaveUpdatePrice"></a>
        </div>
    </div>
    <div id="winCheckSubmitResultLayout" style="display: none; height: 345px;">
        <style>
            #winCheckSubmitResultLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width: 99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div class="row" style="border-bottom: 1px solid lightgrey;">
                        <span id="spWrongCnt" style="color: red;"></span>
                        <br />
                        <span id="spCorrectCnt" style="color: green;"></span>
                        <br />
                        <span id="spSumQty"></span>
                        <br />
                        <span id="spSumPrice"></span>
                    </div>
                    <div class="row">
                        <div id="RstSLWinCheckResult" class="k-grid-page-20"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width: 99%;">
            <a id="BtnSLSubmitCorrect"></a>
            <a id="BtnSLExportError"></a>
            <a id="BtnSLLastStep"></a>
        </div>
    </div>
    <div id="winSLShipmentAdjustLayout" style="display: none; height: 550px;">
        <style>
            #winSLShipmentAdjustLayout .row {
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
            <div style="height: 395px; overflow-y: scroll;">
                <div class="row">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <div style="float: right;"><a id="BtnSAAddHistoryData"></a></div>
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
                            <div style="float: right;"><a id="BtnSAAddInventoryData"></a></div>
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
        <div class="col-xs-10 col-buttom" style="width: 99%;">
            <a id="BtnWinAddAdjust"></a>
            <a id="BtnWinCloseAdjust"></a>
        </div>
    </div>
    <div id="winSLShipmentChooseItemLayout" style="display: none; height: 550px;">
        <style>
            #winSLShipmentChooseItemLayout .row {
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
                                        <span style="color: red;">当产品记录大于200条，以下产品列表仅显示有效期最近的200条记录！</span>
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
        <div class="col-xs-10 col-buttom" style="width: 99%;">
            <a id="BtnWinSCAdd"></a>
            <a id="BtnWinSCClose"></a>
        </div>
    </div>
    <div id="winSLShipmentHistoryLayout" style="display: none; height: 550px;">
        <style>
            #winSLShipmentHistoryLayout .row {
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
        <div class="col-xs-10 col-buttom" style="width: 99%;">
            <a id="BtnWinSHAdd"></a>
            <a id="BtnWinSHClose"></a>
        </div>
    </div>
    <div id="winSLShipmentInventoryLayout" style="display: none; height: 550px;">
        <style>
            #winSLShipmentInventoryLayout .row {
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
        <div class="col-xs-10 col-buttom" style="width: 99%;">
            <a id="BtnWinSIAdd"></a>
            <a id="BtnWinSIClose"></a>
        </div>
    </div>
    <div id="winSLQRCodeImportLayout" style="display: none; height: 180px;">
        <style>
            #winSLQRCodeImportLayout .row {
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
                                    <input name="files" id="WinSLQrCodeImport" type="file" aria-label="files" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width: 99%; text-align: center;">
            <a id="BtnSLImportQrcode"></a>
            <a id="BtnSLClearQrCode"></a>
            <a id="BtnSLQrCodeTemplate"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/ShipmentList.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ShipmentList.Init();
        });
    </script>

    <script type="text/javascript">
        var swfu;
        var uploadTotalDesc;
        var uploadSuccessDesc;
        var uploadFailureDesc;
        var divUploadErrorlist;

        var successCount;
        var failureCount;

        window.onload = function () {
            swfu = swfu_upload_init("spanButtonPlaceHolder", "divprogresscontainer", "divprogressGroup", "ShipmentInvoice", uploadSuccess_forShipment);

            uploadTotalDesc = document.getElementById("spanUploadTotalDesc");
            uploadSuccessDesc = document.getElementById("spanUploadSuccessDesc");
            uploadFailureDesc = document.getElementById("spanUploadFailureDesc");
            divUploadErrorlist = document.getElementById("divUploadErrorlist");
        }

        function shipmentInvoideUploadHelp() {
            $("#winInvoiceHelpLayout").kendoWindow({
                title: "Title",
                width: 700,
                height: 480,
                actions: [
                    "Maximize",
                    "Close"
                ],
                resizable: false,
                //modal: true,
            }).data("kendoWindow").title("发票上传帮助").center().open();
        }

        function shipmentInvoideUploadReset() {
            swfu_upload_reset("divprogresscontainer", resetUploadFileMessage);
        }

        function shipmentInvoiceStartUpload() {
            swfu.startUpload();
            var totalCount = parseInt(uploadTotalDesc.innerHTML) == NaN ? 0 : parseInt(uploadTotalDesc.innerHTML);
            uploadTotalDesc.innerHTML = totalCount + swfu.getStats().files_queued;
        }

        function resetUploadFileMessage() {
            uploadTotalDesc.innerHTML = 0;
            uploadSuccessDesc.innerHTML = 0;
            uploadFailureDesc.innerHTML = 0;
            divUploadErrorlist.innerHTML = "";
        }

        function uploadSuccess_forShipment(file, serverData) {
            try {

                var progress = new FileProgress(file, swfu.settings.custom_settings.progressTarget);
                progress.setComplete(this.settings);
                fg_uploads += file.size;

                $.ajax({
                    type: "POST",
                    url: "/Revolution/Pages/Shipment/ShipmentList.aspx/UploadShipmentAttachment",
                    contentType: "application/json;charset=utf-8",
                    data: JSON.stringify({ index: file.index, fileName: file.name, fileUrl: serverData }),
                    dataType: "json",
                    success: function (d) {
                        if (d != null || d != undefined) {
                            var rtnVal = d.d;
                            var idx = rtnVal.split(",")[0];
                            var cn = rtnVal.split(",")[1];

                            if (parseInt(cn) == 0) {

                                failureCount = parseInt(uploadFailureDesc.innerHTML) == NaN ? 0 : parseInt(uploadFailureDesc.innerHTML);

                                uploadFailureDesc.innerHTML = failureCount + 1;

                                if (divUploadErrorlist.innerHTML == "") {
                                    divUploadErrorlist.innerHTML = file.name;
                                } else {
                                    divUploadErrorlist.innerHTML = divUploadErrorlist.innerHTML + '<br /><br />' + file.name;
                                }

                                progress.setMessage("<font style='color:red;'>在系统中没有此发票号的信息</red>");
                            }
                            else {
                                successCount = parseInt(uploadSuccessDesc.innerHTML) == NaN ? 0 : parseInt(uploadSuccessDesc.innerHTML);

                                uploadSuccessDesc.innerHTML = successCount + 1;
                                progress.setMessage("<font style='color:red;'>上传成功！</red>");
                            }
                        }
                    },
                    error: function (e) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: '访问异常',
                        });
                    }
                });

            } catch (ex) {
                this.debug(ex);
            }
        }

    </script>

</asp:Content>
