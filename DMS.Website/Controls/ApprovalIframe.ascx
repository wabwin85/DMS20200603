<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ApprovalIframe.ascx.cs" Inherits="DMS.Website.Controls.ApprovalIframe" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<iframe id="historyIrfame" runat="server" width="100%" scrolling="auto" frameborder="0" style="min-height: 300px;"></iframe>
<asp:HiddenField ID="hiddenFormInstanceId" runat="server" />
<asp:HiddenField ID="hidden_handler_pass" runat="server" />
<asp:HiddenField ID="hidden_handler_refuse" runat="server" />
<asp:HiddenField ID="hidden_drafter_press" runat="server" />
<asp:HiddenField ID="hidden_drafter_abandon" runat="server" />
<asp:HiddenField ID="hidden_can_read" runat="server" />
<asp:HiddenField ID="hiddenIsEkpAccess" runat="server" />
<asp:HiddenField ID="hiddenEkpNodeId" runat="server" />
<br/><br/>
<ext:Panel ID="panelEkpApproveRemark" runat="server" Header="false" Frame="false" BodyBorder="false" BodyStyle="margin-top:10px;"
    AutoHeight="true" Hidden="true" >
    <Body>
        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
            <ext:LayoutColumn ColumnWidth=".58">
                <ext:Panel ID="Panel11" runat="server" Border="false" Header="false">
                    <Body>
                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="90">
                            <ext:Anchor>
                                <ext:TextArea ID="ekpApproveRemark" runat="server" FieldLabel="审批备注" Width="500" ></ext:TextArea>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                </ext:Panel>
            </ext:LayoutColumn>
        </ext:ColumnLayout>
    </Body>
</ext:Panel>
<script>
    var iframe = document.getElementById('<%=this.historyIrfame.ClientID%>');
    if (iframe != null && typeof(iframe) != "undefined") {
        window.onmessage = function (e) {
            e = e || event;
            iframe.style.cssText = e.data + 'px';
        }
    }

    var getIsEkpAccess = function () {
        var hiddenIsEkpAccess = document.getElementById('<%=this.hiddenIsEkpAccess.ClientID%>');

        if (hiddenIsEkpAccess != null && typeof (hiddenIsEkpAccess) != "undefined") {
            return hiddenIsEkpAccess.value.toUpperCase();
        }
    }

    var getEkpNodeId = function () {
        var hiddenEkpNodeId = document.getElementById('<%=this.hiddenEkpNodeId.ClientID%>');

        if (hiddenEkpNodeId != null && typeof (hiddenEkpNodeId) != "undefined") {
            return hiddenEkpNodeId.value;
        }
    }

    var getEkpApproveRemark = function () {
        var ekpApproveRemark = document.getElementById('<%=this.ekpApproveRemark.ClientID%>');

        if (ekpApproveRemark != null && typeof (ekpApproveRemark) != "undefined") {
            return ekpApproveRemark.value;
        }
    }
</script>