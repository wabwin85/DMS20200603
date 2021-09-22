
<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ConsignUpnPicker.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Consign.ConsignUpnPicker" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="QryDealer" class="FrameControl" />
    <input type="hidden" id="QryBu" class="FrameControl" />
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
                                <div class="col-xs-12 col-group" style="font-size: 1.2em; background-color: #f6f9fe; border-bottom: solid 1px #c5d0dc;">
                                    <div class="col-xs-4 col-label col-3to1-4and8-label">类型</div>
                                    <div class="col-xs-8 col-field col-3to1-4and8-field">
                                        <div id="QryQueryType" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group condition condition-upn">
                                    <div class="col-xs-4 col-label">
                                        编号/名称
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryFilter" class="FrameControl"></div>
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
            <div class="row">
                <div class="box box-primary" style="margin-bottom: 0px;">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;查询结果</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row list list-M1">
                                <div id="RstResultList" class="k-grid-page-with-lock frame-grid-fit"></div>
                            </div>
                            <div class="row list list-M1Fix">
                                <div id="RstResultListSet" class="k-grid-page-all"></div>
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
    <script type="text/javascript" src="Script/ConsignUpnPicker.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ConsignUpnPicker.Init();
        });
    </script>
</asp:Content>
