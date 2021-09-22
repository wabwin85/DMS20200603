<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true"
    CodeBehind="OrderT2CfnSetDialogPicker.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Order.OrderT2CfnSetDialogPicker" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="QryProductLine" class="FrameControl" />
    <input type="hidden" id="QryDealer" class="FrameControl" />
    <input type="hidden" id="InstanceId" class="FrameControl" />
    <input type="hidden" id="hidOrderTypeId" class="FrameControl" />
    <input type="hidden" id="hidPriceTypeId" class="FrameControl" />

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
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        成套产品名称
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryProtectName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        UPN
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryUpn" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom">
                                    <a id="BtnQuery"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;成套产品</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="box-body" style="padding: 0px;">
                                <div class="col-xs-12">
                                    <div class="row">
                                        <div id="RstResultList" class="k-grid-page-all"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom" id="PnlButton">
                                    <a id="BtnAdd"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary" style="margin-bottom: 0px;">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;产品明细</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstResultDetailList" class="k-grid-page-all"></div>
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
    <script type="text/javascript" src="Script/OrderT2CfnSetDialogPicker.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            OrderT2CfnSetDialogPicker.Init();
        });
    </script>
</asp:Content>

