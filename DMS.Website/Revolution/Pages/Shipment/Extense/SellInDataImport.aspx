<%@ Page Title="商采数据导入" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="SellInDataImport.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Shipment.Extense.SellInDataImport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
    <style>
        .list_back {
            background: yellow;
        }
    </style>
</asp:Content>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
      
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
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
                                    <div class="col-xs-10 col-field">
                                        <input name="files" id="files" type="file" />
                                    </div>
                                    <div class="col-xs-1 col-label"> 
                                        <a onclick='window.open("~/Upload/ExcelTemplate/Template_SellInDataInit.xls")' style="padding-right: 20px; cursor: pointer;">下载模板</a>
                                        <%--                                        <div class="col-xs-11 col-buttom" id="PnlButton">
                                            <a id="BtnRemove"></a>
                                        </div>--%>
                                        <br />
                                        <a id="BtnExport" style="padding-right: 20px; cursor: pointer;">下载数据</a>
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
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;导入信息</h3>
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
<asp:Content ID="Content4" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="../Script/Extense/SellInDataImport.js?v=<%=Guid.NewGuid() %>"></script>
    <script type="text/javascript">
        $(function () {
            SellInDataImport.Init();
        })
    </script>
</asp:Content>
