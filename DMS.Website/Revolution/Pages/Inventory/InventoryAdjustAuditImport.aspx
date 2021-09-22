<%@ Page Title="其他出入库普通仓库-Excel导入" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true"
    CodeBehind="InventoryAdjustAuditImport.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Inventory.InventoryAdjustAuditImport" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="IsFirstLoad" value="true" class="FrameControl" />
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

                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-1 col-label">
                                        导入：
                                    </div>
                                    <div class="col-xs-9 col-field">
                                        <input name="files" id="files" type="file" aria-label="files" />
                                    </div>
                                    <div class="col-xs-2 col-label">
                                        <a onclick="window.open('/Upload/ExcelTemplate/Template_Adjust.xls')" style="padding-right: 20px; cursor: pointer;">下载模板</a>
                                        <div class="col-xs-11 col-buttom">
                                            <a id="BtnImportDB"></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;出错信息</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="ImportErrorGrid">
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
    <script type="text/javascript" src="Script/InventoryAdjustAuditImport.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            InventoryAdjustAuditImport.Init();
        });
    </script>
</asp:Content>




