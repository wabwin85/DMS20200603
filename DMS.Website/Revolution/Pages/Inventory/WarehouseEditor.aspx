<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="WarehouseEditor.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Inventory.WarehouseEditor" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="IptDmaID" class="FrameControl" />
    <input type="hidden" id="IptID" class="FrameControl" />
    <input type="hidden" id="ChangeType" class="FrameControl" />
    <input type="hidden" id="IptConID" class="FrameControl" />
    <input type="hidden" id="IptHoldWarehouse" class="FrameControl" />
    <div class="content-main" style="height:95%;">
        <div class="col-xs-12 content-row" style="padding: 10px 10px 0px 10px;" id="PnlEdit">
            <div class="panel panel-primary editable" id="PnlAddressInfo">
                <div class="panel-body" id="PnlAddressInfoEdit" style="padding: 10px;">
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        仓库代码：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptWHCode" class="FrameControl CellInput" data-for="Code" data-group="Warehouse"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>省份：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptWHProvince" class="FrameControl CellInput" data-for="Province" data-group="Warehouse"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>仓库名称：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptWHName" class="FrameControl CellInput" data-for="Name" data-group="Warehouse"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        城市：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptWHCity" class="FrameControl CellInput" data-for="City" data-group="Warehouse"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        <i class='fa fa-fw fa-require'></i>仓库的类型：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptWHType" class="FrameControl CellInput" data-for="Type" data-group="Warehouse"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        区或乡：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptWHTown" class="FrameControl CellInput" data-for="Type" data-group="Warehouse"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        仓库状态：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptWHActiveFlag" class="FrameControl CellInput" data-for="ActiveFlag" data-group="Warehouse"></div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        地址：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                            <div id="IptWHAddress" class="FrameControl CellInput" data-for="Address" data-group="Warehouse"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        复制医院信息：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptCopy" class="FrameControl CellInput" data-for="Copy" data-group="Warehouse">
                                            <input type="checkbox" id="cbxCopyHosp"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        邮编：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptPostalCOD" class="FrameControl CellInput" data-for="PostalCOD" data-group="Warehouse"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        仓库所在医院：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptWHHospName" class="FrameControl CellInput" data-for="Hosp_ID" data-group="Warehouse"></div>
                                        <input type="hidden" id="IptHosp" class="FrameControl" />
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        电话：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptWHPhone" class="FrameControl CellInput" data-for="Phone" data-group="Warehouse"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <a id="BtnSearchHosp"></a>
                                        <%--<button id="BtnSearchHosp" class="KendoButton size-10 k-button" style="margin-right: 5px;margin-top:5px;"><i class='fa fa-search'></i>&nbsp;查找医院</button>--%>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        传真：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="IptWHFax" class="FrameControl CellInput" data-for="Fax" data-group="Warehouse"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xs-12" style="height: 40px; line-height: 40px; text-align: right; position: fixed; bottom: 0px; background-color: #f5f5f5; border-top: solid 1px #ccc;" id="PnlButton">
        <a id="BtnSave"></a>
        <a id="BtnClose"></a>
        <%--<button id="BtnSave" class="KendoButton size-14 k-button"><i class='fa fa-save'></i>&nbsp;保存</button>
        <button id="BtnClose" class="KendoButton size-14 k-button"><i class='fa fa-window-close-o'></i>&nbsp;取消</button>--%>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/WarehouseEditor.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            WarehouseEditor.Init();
        });
    </script>
</asp:Content>
