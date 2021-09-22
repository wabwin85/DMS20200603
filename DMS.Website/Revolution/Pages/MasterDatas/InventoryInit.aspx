<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="InventoryInit.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.InventoryInit" %>
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
                        <h3 class="box-title">期初库存导入</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        文件：
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <input name="files" id="InvInitUpload" type="file" aria-label="files" />
                                    </div>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-xs-12 col-buttom">
                                    <a id="BtnDownTemplate"></a>
                                    <a id="BtnSearchData"></a>
                                    <a id="BtnImportData"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-exclamation-triangle'></i>&nbsp;出错信息</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstInitImportResult" class="k-grid-page-20"></div>
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
    <script type="text/javascript" src="Script/InventoryInit.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            InventoryInit.Init();
        });
    </script>
</asp:Content>
