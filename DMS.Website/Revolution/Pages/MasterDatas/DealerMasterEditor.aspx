<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="DealerMasterEditor.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.DealerMasterEditor" %>
<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .DetailTab {
            width:95%;
            margin:0 auto;
            height:445px;
        }
    </style>
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="IptDmaID" class="FrameControl" />
    <input type="hidden" id="IptDealerType" class="FrameControl" />
    <div class="content-main">
        <div class="col-xs-12 content-row" style="padding: 0px;">
            <div id="DivBasicInfo" style="border: 0;">
                <ul>
                    <li class="k-state-active"><i class='fa fa-sitemap'></i>&nbsp;基本信息
                    </li>
                    <li><i class='fa fa-sitemap'></i>&nbsp;地址信息
                    </li>
                    <li><i class='fa fa-sitemap'></i>&nbsp;工商注册信息
                    </li>
                    <li><i class='fa fa-sitemap'></i>&nbsp;财务信息
                    </li>
                    <li><i class='fa fa-sitemap'></i>&nbsp;经销商附件
                    </li>
                    <li><i class='fa fa-sitemap'></i>&nbsp;授权-指标导出
                    </li>
                </ul>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class='fa fa-fw fa-require'></i>经销商中文名称：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaCName" class="FrameControl CellInput" data-for="DealerName" data-group="Dealer"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    经销商中文简称：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaCSName" class="FrameControl CellInput" data-for="DealerShortName" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    经销商英文名称：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaEName" class="FrameControl CellInput" data-for="EnglishName" data-group="Dealer"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    经销商英文简称：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaESName" class="FrameControl CellInput" data-for="EnglishShortName" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    经销商编号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaNo" class="FrameControl CellInput" data-for="DealerNo" data-group="Dealer"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class='fa fa-fw fa-require'></i>ERP账号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaSapNo" class="FrameControl CellInput" data-for="SAPCode" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class='fa fa-fw fa-require'></i>省份：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaProvince" class="FrameControl CellInput" data-for="Province" data-group="Dealer"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class='fa fa-fw fa-require'></i>地区：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaRegion" class="FrameControl CellInput" data-for="City" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class='fa fa-fw fa-require'></i>区/县：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaTown" class="FrameControl CellInput" data-for="Town" data-group="Dealer"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    公司类型：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptCorpType" class="FrameControl CellInput" data-for="CorpType" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class='fa fa-fw fa-require'></i>经销商类别：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="DrpDmaType" class="FrameControl CellInput" data-for="DealerType" data-group="Dealer"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    纳税人类型：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="DrpTaxType" class="FrameControl CellInput" data-for="Taxpayer" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class='fa fa-fw fa-require'></i>所属平台：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptSNDealer" class="FrameControl CellInput" data-for="SNDealer" data-group="Dealer"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    是否为BP驱动销售模式：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptSalesMode" class="FrameControl CellInput" data-for="SalesMode" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    <i class='fa fa-fw fa-require'></i>首次签约日：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptFirstSignDate" class="FrameControl CellInput" data-for="FirstSignDate" data-group="Dealer"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    经销商类型：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="DrpDealerAuthentication" class="FrameControl CellInput" data-for="DealerAuthentication" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    开账日：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptSystemStartDate" class="FrameControl CellInput" data-for="SystemStartDate" data-group="Dealer"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    承运商：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptCarrier" class="FrameControl CellInput" data-for="Carrier" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    经销商状态：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptActiveFlag" class="FrameControl CellInput" data-for="ctiveFlag" data-group="Dealer"></div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                </div>
                                <div class="col-xs-7 col-field">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    注册地址：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaRegisterAddress" class="FrameControl CellInput" data-for="RegisterAddress" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    地址：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaAddress" class="FrameControl CellInput" data-for="Address" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    仓库地址：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaShipToAddress" class="FrameControl CellInput" data-for="ShipToAddress" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    邮编：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaPostalCOD" class="FrameControl CellInput" data-for="PostalCOD" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    电话：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaPhone" class="FrameControl CellInput" data-for="Phone" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    传真：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaFax" class="FrameControl CellInput" data-for="Fax" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    联系人：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaContact" class="FrameControl CellInput" data-for="Contact" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    电子邮箱：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaEmail" class="FrameControl CellInput" data-for="Email" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    公司总经理：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaGeneralManager" class="FrameControl CellInput" data-for="GeneralManager" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    法人代表：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaLegalRep" class="FrameControl CellInput" data-for="LegalRep" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    注册资金：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaRegisteredCapital" class="FrameControl CellInput" data-for="RegisteredCapital" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    银行账号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaBankAccount" class="FrameControl CellInput" data-for="BankAccount" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    开户银行：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaBank" class="FrameControl CellInput" data-for="Bank" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    税号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaTaxNo" class="FrameControl CellInput" data-for="TaxNo" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    许可证号：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaLicense" class="FrameControl CellInput" data-for="License" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    许可年限：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaLicenseLimit" class="FrameControl CellInput" data-for="LicenseLimit" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    成立时间：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaEstablishDate" class="FrameControl CellInput" data-for="EstablishDate" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    财务联系人：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaFinance" class="FrameControl CellInput" data-for="Finance" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    财务电话：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaFinancePhone" class="FrameControl CellInput" data-for="FinancePhone" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    财务电子邮件：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaFinanceEmail" class="FrameControl CellInput" data-for="FinanceEmail" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    付款方式：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="DrpDmaPayment" class="FrameControl CellInput" data-for="Payment" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="row">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class='fa fa-fw fa-filter'></i>&nbsp;查询条件</h3>
                                </div>
                                <div class="box-body">
                                    <div class="col-xs-11">
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                                <div class="col-xs-4 col-label">
                                                    附件名称：
                                                </div>
                                                <div class="col-xs-7 col-field">
                                                    <div id="IptDmaAttachName" class="FrameControl"></div>
                                                </div>
                                            </div>
                                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                                <div class="col-xs-4 col-label">
                                                    附件类型：
                                                </div>
                                                <div class="col-xs-7 col-field">
                                                    <div id="IptDmaAttachType" class="FrameControl"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row"> 
                                            <div class="col-xs-12 col-buttom">
                                                <a id="BtnQuery"></a>
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
                                    <div class="col-xs-11" style="width:96%;">
                                        <div class="row">
                                            <div id="RstAttachList" class="k-grid-page-20"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px;">
                    <div class="col-xs-12 DetailTab">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    导出类型：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaExportType" class="FrameControl CellInput" data-for="ExportType" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="divProductLine">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    产品线：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaProductLine" class="FrameControl CellInput" data-for="ProductLine" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="divAllProductLine" style="display:none;">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    产品线：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaAllProductLine" class="FrameControl CellInput" data-for="AllProductLine" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="divYear" style="display:none;">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-4 col-label">
                                    指标年度：
                                </div>
                                <div class="col-xs-7 col-field">
                                    <div id="IptDmaYear" class="FrameControl CellInput" data-for="Year" data-group="Dealer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 col-buttom">
                            <div id="divAuthorize">
                                <a id="BtnExportAuthorize"></a>
                            </div>
                            <div id="divIndex" style="display:none;">
                                <a id="BtnExportAOPD"></a>
                                <a id="BtnExportAOPH"></a>
                                <a id="BtnExportAOPP"></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom">
        <a id="BtnExport"></a>
        <a id="BtnSave"></a>
        <a id="BtnCancel"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerMasterEditor.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            DealerMasterEditor.Init();
        });
    </script>
</asp:Content>
