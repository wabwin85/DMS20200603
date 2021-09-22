<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true"
    CodeBehind="InventoryReturnInfoPicker.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Inventory.InventoryReturnInfoPicker" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="QryReturnType" class="FrameControl" />
    <input type="hidden" id="QryInstanceId" class="FrameControl" />
    <input type="hidden" id="QryDealerId" class="FrameControl" />
    <input type="hidden" id="ReturnTypeWin" class="FrameControl" />
    <input type="hidden" id="QryProductLineWin" class="FrameControl" />
    <input type="hidden" id="QryReturnApplyType" class="FrameControl" />
    <input type="hidden" id="IsCFN" class="FrameControl" />
    <input type="hidden" id="QryIsShareCFN" value="false" class="FrameControl" />

    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row" id="DialogWindow">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-filter'></i>&nbsp;查询条件</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        分仓库
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryWorehourse" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        序列号/批号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryLotNumber" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        产品型号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryCFN" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        二维码
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryQrCode" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom" id="PnlButton">
                                    <a id="BtnQuery"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" id="DialogWindow_CFN" style="display: none;">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-filter'></i>&nbsp;查询条件</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        产品型号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryCFN_CFN" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn" style="display: none;">
                                    <div class="col-xs-4 col-label">
                                        是否共享产品
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryIsShareCFN_Hidden" class=""></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn" style="display: none;">
                                    <div class="col-xs-4 col-label">
                                        条形码
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryUPN_CFN" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        分仓库
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryWarehouse2" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom">
                                    <a id="BtnQuery_CFN"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="box box-primary" style="margin-bottom: 0px;">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;查询结果</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstResultList" class="k-grid-page-all"></div>
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
        <a id="BtnOk"></a>
        <a id="BtnClose"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/InventoryReturnInfoPicker.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            InventoryReturnInfoPicker.Init();
        });
    </script>
</asp:Content>

