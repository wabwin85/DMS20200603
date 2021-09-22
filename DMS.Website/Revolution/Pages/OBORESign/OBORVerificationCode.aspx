<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="OBORVerificationCode.aspx.cs" Inherits="DMS.Website.Revolution.Pages.OBORESign.OBORVerificationCode" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">

    <input type="hidden" id="ES_ID" class="FrameControl" />
    <input type="hidden" id="SignType" class="FrameControl" />

    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">

            <div class="row">
                <div class="box box-primary">
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-3 col-label">
                                    验证码
                                </div>
                                <div class="col-xs-5 col-field">
                                    <div id="IptVerificationCode" class="FrameControl"></div>
                                </div>
                                <div class="col-xs-4 col-label">
                                    <a id="BtnSend"></a>
                                </div>
                            </div>

                            <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                <div class="col-xs-9 col-label">
                                   <div id="Phone"></div>
                                </div>
                                

                              
                            </div>
                          
                            
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </div>

</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom">
        <a id="BtnConfirm"></a>
        <a id="BtnClose"></a>
    </div>
</asp:Content>

<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/OBORVerificationCode.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            OBORVerificationCode.Init();
        });
    </script>
</asp:Content>

