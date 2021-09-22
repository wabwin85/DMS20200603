<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="InventoryQROperation.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Inventory.InventoryQROperation" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
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
                                        经销商：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDealer" class="FrameControl"></div>
                                    </div>
                                </div>
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
                                        二维码：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryQrCode" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品名称：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryCfnChineseName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        仓库：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryWarehouse" class="FrameControl"></div>
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
                                        有效期日期范围：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryExpiredDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        类型：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryScanType" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        批次号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryLotNumber" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        数据日期范围：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryRemarkDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        库存状态：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryQtyIsZero" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        备注：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryRemark" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        扫描日期范围：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryCreateDate" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        上报状态：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryShipmentState" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row" id="divRemark">
                                <span style="color:red;">您有超期未上传发票的销量单据，具体未上传信息请到销售出库单页面查询</span>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom" id="PnlButton">
                                    <a id="BtnSearch"></a>
                                    <a id="BtnExport"></a>
                                    <a id="BtnDelete"></a>
                                    <a id="BtnCreateShipment"></a>
                                    <a id="BtnCreateTransfer"></a>
                                    <a id="BtnCreateQrCodeConvent"></a>
                                    <a id="BtnCreateInventoryQrcodeConvent"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-truck'></i>&nbsp;查询结果</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstResultList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="/Revolution/Resources/js/Calculate.js" type="text/javascript"></script>
    <script type="text/javascript" src="Script/InventoryQROperation.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(function () {
            InventoryQROperation.Init();
        });
    </script>
</asp:Content>
