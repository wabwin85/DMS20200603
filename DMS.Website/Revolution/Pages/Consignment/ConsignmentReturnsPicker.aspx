<%@ Page Title="退货单产品" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true"
    CodeBehind="ConsignmentReturnsPicker.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Consignment.ConsignmentReturnsPicker" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hidCmId" class="FrameControl" />
    <input type="hidden" id="hidIahDmaId" class="FrameControl" />
    <input type="hidden" id="hidDealerId" class="FrameControl" />
    <input type="hidden" id="hidProductLine" class="FrameControl" />
    <input type="hidden" id="HeaderId" class="FrameControl" />
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
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
    <script type="text/javascript" src="Script/ConsignmentReturnsPicker.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ConsignmentReturnsPicker.Init();
        });
    </script>
</asp:Content>


