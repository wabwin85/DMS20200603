<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderSetting.aspx.cs" Inherits="DMS.Website.Pages.Order.OrderSetting" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />

    <script language="javascript">
        //当勾选自动订单时改变其余项的状态
        var ChangeItems = function() {
            var disabled = !Ext.getCmp('<%=this.cbIsOpen.ClientID%>').checked;
            Ext.getCmp('<%=txtMaxAmount.ClientID %>').setDisabled(disabled);
            Ext.getCmp('<%=cbExecuteDay1.ClientID %>').setDisabled(disabled);
            Ext.getCmp('<%=cbExecuteDay2.ClientID %>').setDisabled(disabled);
            Ext.getCmp('<%=cbExecuteDay3.ClientID %>').setDisabled(disabled);
            Ext.getCmp('<%=cbExecuteDay4.ClientID %>').setDisabled(disabled);
            Ext.getCmp('<%=cbExecuteDay5.ClientID %>').setDisabled(disabled);
            Ext.getCmp('<%=cbExecuteDay6.ClientID %>').setDisabled(disabled);
            Ext.getCmp('<%=cbExecuteDay7.ClientID %>').setDisabled(disabled);
        }

        var MsgList = {
            btnSave: {
                SuccessTitle: "Message",
                SuccessMsg: "<%=GetLocalResourceObject("Function.MsgList.alert.Message").ToString()%>"
            }
        }

        var CheckExecuteDay = function() {
            var ischeck = Ext.getCmp('<%=this.cbIsOpen.ClientID%>').checked;
            if (ischeck) {
                if (Ext.getCmp('<%=txtMaxAmount.ClientID %>').getValue() == "0") {
                    Ext.Msg.alert("Message", "<%=GetLocalResourceObject("CheckExecuteDay.message1").ToString()%>");
                    return false;
                }
                else if (Ext.getCmp('<%=txtMaxAmount.ClientID %>').getValue() == "") {
                    
                    Ext.Msg.alert("Message", "<%=GetLocalResourceObject("CheckExecuteDay.message2").ToString()%>");
                    return false;
                }
                if (Ext.getCmp('<%=cbExecuteDay1.ClientID %>').checked == false
                & Ext.getCmp('<%=cbExecuteDay2.ClientID %>').checked == false
                & Ext.getCmp('<%=cbExecuteDay3.ClientID %>').checked == false
                & Ext.getCmp('<%=cbExecuteDay4.ClientID %>').checked == false
                & Ext.getCmp('<%=cbExecuteDay5.ClientID %>').checked == false
                & Ext.getCmp('<%=cbExecuteDay6.ClientID %>').checked == false
                & Ext.getCmp('<%=cbExecuteDay7.ClientID %>').checked == false) {
                    Ext.Msg.alert("Message", "<%=GetLocalResourceObject("CheckExecuteDay.message3").ToString()%>");
                    return false;
                }
                return true;
            }
        }
    </script>
    <ext:Hidden ID="hidIsNew" runat="server"></ext:Hidden>
    <ext:Hidden ID="hidInstanceId" runat="server"></ext:Hidden>
    <ext:Panel ID="Panel3" runat="server" Border="false" Frame="true" Title="<%$ Resources: Panel3.Title %>"
        Width="300" Height="320">
        <Body>
            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="60">
                <ext:Anchor>
                    <ext:Checkbox ID="cbIsOpen" runat="server" BoxLabel="<%$ Resources: cbIsOpen.BoxLabel %>" HideLabel="true">
                        <Listeners>
                            <Check Handler="ChangeItems();" />
                        </Listeners>
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:NumberField ID="txtMaxAmount" runat="server" FieldLabel="<%$ Resources: txtMaxAmount.FieldLabel %>" AllowDecimals="true" AllowNegative="false" DecimalPrecision="2"></ext:NumberField>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbExecuteDay1" runat="server" BoxLabel="<%$ Resources: cbExecuteDay1.BoxLabel %>" HideLabel="true">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbExecuteDay2" runat="server" BoxLabel="<%$ Resources: cbExecuteDay2.BoxLabel %>" HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbExecuteDay3" runat="server" BoxLabel="<%$ Resources: cbExecuteDay3.BoxLabel %>" HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbExecuteDay4" runat="server" BoxLabel="<%$ Resources: cbExecuteDay4.BoxLabel %>" HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbExecuteDay5" runat="server" BoxLabel="<%$ Resources: cbExecuteDay5.BoxLabel %>" HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbExecuteDay6" runat="server" BoxLabel="<%$ Resources: cbExecuteDay6.BoxLabel %>" HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbExecuteDay7" runat="server" BoxLabel="<%$ Resources: cbExecuteDay7.BoxLabel %>" HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
            </ext:FormLayout>
        </Body>
        <Buttons>
            <ext:Button ID="btnSave" Text="<%$ Resources: btnSave.Text %>" runat="server" Icon="Disk">
                <AjaxEvents>
                    <Click OnEvent="btnSave_OnClick" Success="Ext.Msg.alert(MsgList.btnSave.SuccessTitle,MsgList.btnSave.SuccessMsg);"
                     Before="return CheckExecuteDay();"/>
                </AjaxEvents>
            </ext:Button>
        </Buttons>
    </ext:Panel>
    </form>
</body>
</html>
