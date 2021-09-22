<%@ Page Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ConsignCountManage.aspx.cs"
    Inherits="DMS.Website.Revolution.Pages.Consign.ConsignCountManage" %>

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
                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDealer" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        Upn
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryUpn" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom" id="PnlButton">
                                    <a id="BtnQuery"></a>
                                    <a id="BtnNew"></a>
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
                                <div id="RstResultList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div style="display: none">
        <div id="AddCQID" class="FrameControl"></div>
        <div id="DeleteCQID" class="FrameControl"></div>
    </div>
    <div id="windowLayout" style="display: none;">
        <style>
            #windowLayout .row {
                margin: 0px;
            }

            .windowsfoot-btn {
                width: 100%;
                margin-top: 20px;
                text-align: center;
            }
            #AddValidity .col-xs-5 {
                padding:0;
            }
            #AddValidity .col-xs-12 {
                padding:0;
            }
        </style>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    经销商:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddDealer" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    UPN:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddUpn" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    有效期:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddValidity" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    总金额:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddAmount" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    总数量:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddTotal" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="windowsfoot-btn">
            <a id="save"></a>
            <a id="delete"></a>
            <a id="colse"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/ConsignCountManage.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ConsignCountManage.Init();
        });
    </script>
</asp:Content>
