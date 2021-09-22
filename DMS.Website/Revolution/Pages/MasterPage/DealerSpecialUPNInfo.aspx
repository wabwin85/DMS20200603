<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="DealerSpecialUPNInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterPage.DealerSpecialUPNInfo" %>

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
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        编号/名称
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryFilter" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        产品线
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryBu" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom" >
                                   
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
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;产品明细</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row" style="border-bottom: solid 1px #c5d0dc;">
                                <div class="col-buttom text-left" id="PnlDetailButton">
                                    <a id="BtnAddUpn"></a>
                                </div>
                            </div>
                            <div class="row">
                                <div id="RstDetailList" class="k-grid-page-all"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
             <%--<div id="RstOperationLog" class="row">
            </div>--%>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom" id="PnlButton">
        <a id="BtnSave"></a>
        <a id="BtnDelete"></a>
        <a id="BtnClose"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerSpecialUPNInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            DealerSpecialUPNInfo.Init();
        });
    </script>
</asp:Content>
