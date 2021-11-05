<%@ Page Title="发票商品映射导入" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="InvGoodsCfgImport.aspx.cs"
    Inherits="DMS.Website.Revolution.Pages.MasterDatas.Extense.InvGoodsCfgImport" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style>
        .list_back {
            background: yellow;
        }
    </style>
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

                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-1 col-label">
                                        导入：
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <input name="files" id="files" type="file" />
                                    </div>
                                    <div class="col-xs-1 col-label">
                                        <a onclick="window.open('Extense/Upload/ExcelTemplate/Template_InvGoodsInit.xls')" style="padding-right: 20px; cursor: pointer;">下载模板</a>
                                        <%--                                        <div class="col-xs-11 col-buttom" id="PnlButton">
                                            <a id="BtnRemove"></a>
                                        </div>--%>
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
    <script type="text/javascript" src="../Script/Extense/InvGoodsCfgImport.js?v=<%=Guid.NewGuid() %>"></script>
    <script type="text/javascript">
        $(function () {
            InvGoodsCfgImport.Init();
        })
    </script>

</asp:Content>

