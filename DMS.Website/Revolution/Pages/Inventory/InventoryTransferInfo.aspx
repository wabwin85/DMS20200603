<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="InventoryTransferInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Inventory.InventoryTransferInfo" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="InvType" class="FrameControl"/>
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>经销商：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinTransferDealerName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>移库类型：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinTransferType" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        默认移入仓库：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinTransferWarehouse" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>产品线：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="WinTransferProductLine" class="FrameControl"></div>
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
                        <h3 class="box-title"><i class='fa fa-fw fa-truck'></i>&nbsp;查询结果</h3>
                        <div style="float:right;">
                            <i class='fa fa-plus-square'></i>&nbsp;记录数：<span id="spTransferRecordSum"></span>&nbsp;
                            <i class='fa fa-plus-square'></i>&nbsp;数量合计：<span id="spTransferQtySum"></span>&nbsp;
                        </div>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstWinTransferList" class="k-grid-page-20"></div>
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
        <a id="BtnTransferClear"></a>
        <a id="BtnTransferSubmit"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="/Revolution/Resources/js/Calculate.js" type="text/javascript"></script>
    <script type="text/javascript" src="Script/InventoryTransferInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(function () {
            InventoryTransferInfo.InitTransferWin();
        });
    </script>
</asp:Content>
