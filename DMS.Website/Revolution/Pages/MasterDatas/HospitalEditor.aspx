<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="HospitalEditor.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.HospitalEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="IptHosID" class="FrameControl" />
    <input type="hidden" id="ChangeType" class="FrameControl" />
    <div class="content-main">
        <div class="col-xs-12 content-row" style="padding: 10px 10px 0px 10px;" id="PnlEdit">
            <div class="panel panel-primary editable" id="PnlAddressInfo">
                <div class="panel-body" id="PnlAddressInfoEdit" style="padding: 10px;">
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>医院名称：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLName" class="FrameControl CellInput" data-for="HospitalName" data-group="Hospital"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        等级：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLGrade" class="FrameControl CellInput" data-for="Grade" data-group="Hospital"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        医院简称：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLSName" class="FrameControl CellInput" data-for="ShortName" data-group="Hospital"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        医院编码：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLCode" class="FrameControl CellInput" data-for="KeyCode" data-group="Hospital"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>省份：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLProvince" class="FrameControl CellInput" data-for="Province" data-group="Hospital"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>地区：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLRegion" class="FrameControl CellInput" data-for="City" data-group="Hospital"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>区/县：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLTown" class="FrameControl CellInput" data-for="Town" data-group="Hospital"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        电话：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLPhone" class="FrameControl CellInput" data-for="Phone" data-group="Hospital"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        地址：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLAddress" class="FrameControl CellInput" data-for="Address" data-group="Hospital"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        邮编：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLPostalCOD" class="FrameControl CellInput" data-for="PostalCOD" data-group="Hospital"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        院长：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLDean" class="FrameControl CellInput" data-for="Dean" data-group="Hospital"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        联系方式：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLDeanContact" class="FrameControl CellInput" data-for="DeanContact" data-group="Hospital"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        设备科主任：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLHead" class="FrameControl CellInput" data-for="Head" data-group="Hospital"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        联系方式：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLHeadContact" class="FrameControl CellInput" data-for="HeadContact" data-group="Hospital"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        医院网站：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLWeb" class="FrameControl CellInput" data-for="Web" data-group="Hospital"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        波科医院编码：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptHPLBSCode" class="FrameControl CellInput" data-for="BSCode" data-group="Hospital"></div>
                                    </div>
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
    <script type="text/javascript" src="Script/HospitalEditor.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            HospitalEditor.Init();
        });
    </script>
</asp:Content>
