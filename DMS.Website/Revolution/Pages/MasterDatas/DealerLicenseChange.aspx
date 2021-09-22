<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="DealerLicenseChange.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.DealerLicenseChange" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .DetailTab {
            margin:0 auto;
            width:97%;
            height:312px;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hidDealerId" class="FrameControl" />
    <input type="hidden" id="hidApplyStatus" class="FrameControl" />
    <input type="hidden" id="WinHidAppNo" class="FrameControl" />
    <input type="hidden" id="WinDMLID" class="FrameControl" />
    <input type="hidden" id="WinDefaultAddress" class="FrameControl" />
    <input type="hidden" id="WinProductCat" class="FrameControl" />
    <div class="content-main" style="padding: 2px 5px;">
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
                                        经销商中文名称：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryLCDealerName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        CFDA流程编号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryLCFlowNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        申请审批状态：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryLCApplyStatus" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-xs-12 col-buttom">
                                    <a id="BtnLCQuery"></a>
                                    <a id="BtnLCNew"></a>
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
                                <div id="RstLCResultList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="winLCDetailLayout" style="display:none;height:97%;">
        <style>
            #winLCDetailLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:99%;display:inline-block;">
            <div class="box box-primary">
                <div class="box-body">
                    <div class="col-xs-11">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    蓝威销售：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinLCSales" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    企业负责人：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinLCHeadOfCorp" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    法人代表：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinLCLegalRep" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group" style="border:1px #d5d5d5 solid;">
                                <div class="row">
                                    <h5 class="box-title">医疗器械经营许可证信息</h5>
                                </div>
                                <div class="row">
                                    <div class="col-xs-4 col-label">
                                        证件编号：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCLicenseNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-4 col-label">
                                        起始日期：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCLicenseStart" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-4 col-label">
                                        结束日期：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCLicenseEnd" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group" style="border:1px #d5d5d5 solid;">
                                 <div class="row">
                                     <h5 class="box-title">医疗器械备案凭证信息</h5>
                                 </div>
                                 <div class="row">
                                    <div class="col-xs-4 col-label">
                                        证件编号：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCRecordNo" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-4 col-label">
                                        起始日期：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCRecordStart" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-4 col-label">
                                        结束日期：
                                    </div>
                                    <div class="col-xs-7 col-field">
                                        <div id="WinLCRecordEnd" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" style="width:99%;display:inline-block;">
            <div id="DivLCBasicInfo" style="border: 0;">
                <ul>
                    <li class="k-state-active">ShipTo地址
                    </li>
                    <li>二类医疗器械产品分类
                    </li>
                    <li>三类医疗器械产品分类
                    </li>
                    <li>附件
                    </li>
                </ul>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="row">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-truck'></i>&nbsp;ShipTo地址</h3>
                                    <div style="float:right;"><a id="BtnLCSelectAddr"></a></div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCAddressList" class="k-grid-page-20"></div>
                                        </div>
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
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;2002版二类医疗器械产品分类</h3>
                                    <div style="float:right;"><a id="BtnLCSelectProd202"></a></div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCProductList202" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;2017版二类医疗器械产品分类</h3>
                                    <div style="float:right;"><a id="BtnLCSelectProd217"></a></div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCProductList217" class="k-grid-page-20"></div>
                                        </div>
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
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;2002版三类医疗器械产品分类</h3>
                                    <div style="float:right;"><a id="BtnLCSelectProd302"></a></div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCProductList302" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;2017版三类医疗器械产品分类</h3>
                                    <div style="float:right;"><a id="BtnLCSelectProd317"></a></div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCProductList317" class="k-grid-page-20"></div>
                                        </div>
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
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-paperclip'></i>&nbsp;附件列表</h3>
                                    <div style="float:right;"><a id="BtnLCAddAttach"></a></div>
                                </div>
                                <div class="box-body" style="padding: 0px;">
                                    <div class="col-xs-12" style="padding-left:0px;">
                                        <div class="row">
                                            <div id="RstLCAttachList" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" style="width:99%;display:inline-block;">
            <div class="col-xs-12 col-buttom" style="padding:0px 5px;">
                <a id="BtnWinSubmit"></a>
                <a id="BtnWinDelDraft"></a>
                <a id="BtnWinSaveDraft"></a>
                <a id="BtnWinClose"></a>
            </div>
        </div>
    </div>
    <div id="winLCProductCatagoryLayout" style="display:none;height:95%;">
        <style>
            #winLCProductCatagoryLayout .row {
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
                                    产品分类代码：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinLCProductCode" class="FrameControl"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                <div class="col-xs-4 col-label">
                                    产品分类名称：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="WinLCProductName" class="FrameControl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-11 col-buttom">
                                <a id="BtnLCWinQuery"></a>
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
                                <div id="RstLCWinProductList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-10 col-buttom" style="width:99%;">
            <a id="BtnWinAddProduct"></a>
            <a id="BtnCloseProductWin"></a>
        </div>
    </div>
    <div id="winLCAttachmentLayout" style="display:none;height:93%;">
        <style>
            #winLCAttachmentLayout .row {
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
                                    <input name="files" id="WinLCFileUpload" type="file" aria-label="files" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;text-align:center;">
            <a id="BtnLCUploadAttach"></a>
            <a id="BtnLCClearAttach"></a>
        </div>
    </div>
    <div id="winLCAddressLayout" style="display:none;height:95%;">
        <style>
            #winLCAddressLayout .row {
                margin: 0px;
            }
        </style>
        <div class="row" style="width:99%;">
            <div class="box box-primary">
                <div class="box-body">
                    <div class="row">
                        <span style="color:red;">提示：同一经销商有且只能包含一个默认发货地址</span>
                    </div>
                    <div class="row">
                        <div class="col-xs-12 col-group">
                            <div class="col-xs-4 col-label">
                                是否默认发货地址：
                            </div>
                            <div class="col-xs-7 col-field">
                                <input type="checkbox" id="cbxIsDefaultShipTo"/>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12 col-group">
                            <div class="col-xs-4 col-label">
                                地址类型：
                            </div>
                            <div class="col-xs-7 col-field">
                                <div id="WinLCAddressType" class="FrameControl"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12 col-group">
                            <div class="col-xs-4 col-label">
                                地址信息：
                            </div>
                            <div class="col-xs-7 col-field">
                                <div id="WinLCAddressInfo" class="FrameControl"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-buttom" style="width:99%;">
            <a id="BtnLCSaveAddr"></a>
            <a id="BtnLCCancelAddr"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerLicenseChange.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            DealerLicenseChange.Init();
        });
    </script>
</asp:Content>
