<%@ Page Title="报量对账规则设置" Language="C#" AutoEventWireup="true" MasterPageFile="~/Revolution/MasterPage/Site.Master"
    CodeBehind="ReconcileRule.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Shipment.Extense.ReconcileRule" %>

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
                                 <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        分子公司
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="SubCompany" class="FrameControl"></div>
                                    </div>
                                </div>
                             </div>
                             <div class="row">
                                 <div class="col-xs-12 col-buttom" id="PnlButton">
                                     <a id="BtnQuery"></a>
                                     <a id="BtnExpDetail"></a>
                                 </div>
                             </div>
                         </div>
                     </div>
                 </div>
             </div>
             <div class="row">
                 <div class="box box-primary">
                     <div class="box-header with-border">
                         <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;报量对账规则</h3>
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
    <div id="divRulePop" style="display:none;">
        <style>
            divRulePop .row {
                margin: 0px;
            }

            .windowsfoot-btn {
                width: 100%;
                margin-top: 20px;
                text-align: center;
            }
        </style>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <input type="hidden" id="hidSubCompanyId" />
                <div class="col-xs-3 col-label">
                    <i class="fa fa-fw fa-require"></i>产品型号:
                </div>
                <div class="col-xs-8 col-field">
                    <%--<div id="ProductType" class="FrameControl"></div>--%>
                    <input type="checkbox" id="ProductType" />
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    <i class="fa fa-fw"></i>发票日期:
                </div>
                <div class="col-xs-8 col-field">
                    <%--<div id="InvoiceDate" class="FrameControl"></div>--%>
                    <input type="checkbox" id="InvoiceDate" />
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    <i class="fa fa-fw"></i>销售医院:
                </div>
                <div class="col-xs-8 col-field">
                    <%--<div id="SalesHospital" class="FrameControl"></div>--%>
                     <input type="checkbox" id="SalesHospital" />
                </div>
            </div>
        </div>
        <div class="windowsfoot-btn">
            <a id="saveDetail"></a>
            <a id="colseDetail"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">

</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="../Script/Extense/ReconcileRule.js?v=<%=Guid.NewGuid() %>"></script>
    <script type="text/javascript">
        $(function () {
            ReconcileRule.Init();
        })
    </script>
</asp:Content>