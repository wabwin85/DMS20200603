<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true"
    CodeBehind="MyInfo.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MyInfo" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row" id="plPerson">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;个人信息</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        登录ID
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="LoginID" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        姓名
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="UserName" class="FrameControl"></div>
                                    </div>
                                </div>

                                
                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        电子邮箱
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="Email1" class="FrameControl"></div>
                                    </div>
                                </div>
                               

                                
                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        电子邮箱1
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="Email2" class="FrameControl"></div>
                                    </div>
                                </div>
                                
                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        电话
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="Phone" class="FrameControl"></div>
                                    </div>
                                </div>
                               
                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        地址
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="Address" class="FrameControl"></div>
                                    </div>
                                </div>

                            </div>                           
                        </div>
                        <div class="col-xs-12" id="plOrder" style="display:none;">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        联系人
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="ORContactPerson" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        联系方式
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="ORContact" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        手机号码
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="ORContactMobile" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        收货人
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="ORConsignee" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        收货人电话
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="ORConsigneePhone" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        电子邮件
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="OROrderEmail" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        销售单显示经销商名称
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="ORShipmentDealer" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        是否接收短信
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="ORReceiveSMS" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        是否接收电子邮件
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="ORReceiveEmail" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        是否接收订单信息
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="ORReceiveOrder" class="FrameControl"></div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>           
            <div class="row" id="plCorporation" style="display:none;">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;公司信息</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商标识ID
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="CPDealerID" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商中文名称
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="CPDealerChineseName" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        英文名称
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="CPDealerEnglishName" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        承运商
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="CPDealerCertification" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        地址
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="CPDealerAddress" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        邮编
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="CPDealerPostalCode" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        电话
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="CPDealerPhone" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-6 col-md-6 col-group">
                                    <div class="col-xs-4 col-label">
                                        电话
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="CPDealerFax" class="FrameControl"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12 col-buttom" id="PnlButton">
                    <a id="BtnSave"></a>
                </div>
            </div>
        </div>
    </div>
    <div style="display:none;">
        <input type="hidden" id="HasCompany" />
        <input type="hidden" id="IsNewOrder" />
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/MyInfo.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            MyInfo.Init();
        });
    </script>
</asp:Content>
