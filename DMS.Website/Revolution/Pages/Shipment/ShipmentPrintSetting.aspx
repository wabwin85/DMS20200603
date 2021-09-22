<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ShipmentPrintSetting.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Shipment.ShipmentPrintSetting" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="HidIsNew" class="FrameControl" />
    <input type="hidden" id="HidInstanceId" class="FrameControl" />
    <div class="content-main" style="padding: 5px;width:30%;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">销售单打印设定</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                    </div>
                                    <div class="col-xs-8 col-field" style="font-weight:bold;">
                                        是否打印
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        注册证名称：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwCertificateName" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品规格：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwEnglishName" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品型号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwProductType" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        序列号/批号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwLot" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        有效期：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwExpiryDate" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        销售数量：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwShipmentQty" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        单位：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwUnit" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        单价：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwUnitPrice" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        注册证号：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwCertificateNo" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        产品描述：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwCertificateENNo" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        注册证开始时间：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwStartDate" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-4 col-label">
                                        注册证过期时间：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SwExpireDate" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-xs-12 col-buttom">
                                    <a id="BtnSave"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/ShipmentPrintSetting.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ShipmentPrintSetting.Init();
        });
    </script>
</asp:Content>
