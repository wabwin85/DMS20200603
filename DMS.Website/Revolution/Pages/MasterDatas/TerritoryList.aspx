<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="TerritoryList.aspx.cs"
    Inherits="DMS.Website.Revolution.Pages.MasterDatas.UserList" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="HosID" class="FrameControl" />
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
                                        省份：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryProvinceName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        地区：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryCityName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        区/县：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryCountyName" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom">
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

    <div id="dlgEdit" style="display: none; height: 380px;">
        <style>
            #dlgEdit .row {
                margin: 0px;
            }
        </style>
        <div class="row">
            <div class="box box-primary">
                <div class="box-body">
                    <div class="row">
                        <div class="col-xs-12 col-group">
                            <div class="col-xs-1 col-label">
                                <i class="fa fa-fw fa-require"></i>文件：
                            </div>
                            <div class="col-xs-10 col-field">
                                <input name="files" id="fileUserInfo" type="file" aria-label="files" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-buttom" style="text-align: center;">
                            <a id="BtnImportUserInfo"></a>
                            <a id="BtnDownTmpUserInfo"></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title"><i class='fa fa-fw fa-exclamation-triangle' style="color: orangered"></i>&nbsp;导入信息</h3>
                </div>
                <div class="box-body" style="padding: 0px;">
                    <div class="row">
                        <div id="RstUploadUserInfo" class="k-grid-page-20"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/TerritoryList.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            TerritoryList.Init();
        });
    </script>
</asp:Content>
