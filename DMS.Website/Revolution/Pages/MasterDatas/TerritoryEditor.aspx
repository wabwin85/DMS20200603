<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="TerritoryEditor.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.HospitalEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="IptTerId" class="FrameControl" />
    <input type="hidden" id="ChangeType" class="FrameControl" />
    <div class="content-main">
        <div class="col-xs-12 content-row" style="padding: 10px 10px 0px 10px;" id="PnlEdit">
            <div class="panel panel-primary editable" id="PnlInfo">
                <div class="panel-body" id="PnlInfoEdit" style="padding: 10px;">
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        <i class='fa fa-fw fa-require'></i>区域类型：
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="IptTerType" class="FrameControl CellInput" data-for="" data-group="Territory"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        <i class='fa fa-fw fa-require'></i>区域名称：
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="IptTerName" class="FrameControl CellInput" data-for="" data-group="Territory"></div>
                                    </div>
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        区域编码：
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="IptTerCode" class="FrameControl CellInput" data-for="" data-group="Territory"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        <i class='fa fa-fw fa-require'></i>所属省份：
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="IptProvince" class="FrameControl CellInput" data-for="" data-group="Territory"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        <i class='fa fa-fw fa-require'></i>所属地区：
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="IptCity" class="FrameControl CellInput" data-for="" data-group="Territory"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FootContent" runat="server">
    <%--<div class="col-xs-12" style="height: 40px; line-height: 40px; text-align: right; position: fixed; bottom: 0px; background-color: #f5f5f5; border-top: solid 1px #ccc;" id="PnlButton">
        <button id="BtnSave" class="KendoButton size-14 k-button"><i class='fa fa-save'></i>&nbsp;保存</button>
        <button id="BtnClose" class="KendoButton size-14 k-button"><i class='fa fa-window-close-o'></i>&nbsp;取消</button>--%>
    <div class="foot-bar col-buttom" id="PnlButton">
        <a id="BtnSave"></a>
        <a id="BtnClose"></a>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/TerritoryEditor.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            TerritoryEditor.Init();
        });
    </script>
</asp:Content>
