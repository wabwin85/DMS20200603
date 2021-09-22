<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractDeatil.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractDeatil" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        </style>
</head>
<body style="background-color: #dfe8f6;">
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Hidden ID="hidCmStatus" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidCmid" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidParmetType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDealerId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDealerName" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDealerType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidContractId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidContStatus" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidContractType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDealerLv" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidEffectiveDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidExpirationDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDivision" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidConfirm" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidSuBU" runat="server">
        </ext:Hidden>

        <script type="text/javascript" language="javascript">
            var MsgList = {
                MsgItem:{
                    ConfirmMsg1:"<%=GetLocalResourceObject("Deatil.Mag.IsSaveDraft").ToString()%>",
            ConfirmMsg2:"<%=GetLocalResourceObject("Deatil.Mag.SaveSuccess").ToString()%>",
            ConfirmMsg3:"<%=GetLocalResourceObject("Deatil.Mag.ReturnSuccess").ToString()%>"
        }
       }
        
    function CheckAuthorization()
    {
        var Author = <%=tfAuthorizationCode.ClientID%>.getValue();
           if (Author == "")
           {
               alert('<%=GetLocalResourceObject("Deatil.AuthorizationCode.Alert").ToString()%>');
                return false;
            }

            return true;
        }
        </script>

        <div>
            <ext:ViewPort ID="ViewPortDeatil" runat="server">
                <Body>
                    <ext:FitLayout ID="FitLayout1" runat="server">
                        <ext:TabPanel ID="TabPanelDeatil" runat="server" ActiveTabIndex="0" Plain="true">
                            <TopBar>
                                <ext:Toolbar Hidden="True" ID="Toolbar1" runat="server">
                                    <Items>
                                        <ext:ToolbarFill />
                                        <ext:Button ID="btnLPConfirm" runat="server" Text="<%$ Resources:Deatil.Btn.Termination%>"
                                            Icon="Tick" Hidden="true">
                                            <Listeners>
                                                <Click Handler="Coolite.AjaxMethods.SaveLPConfirm()" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnConfirm" runat="server" Text="<%$ Resources:Deatil.Btn.Confirm%>"
                                            Icon="Tick" Hidden="true">
                                            <Listeners>
                                                <Click Handler="Coolite.AjaxMethods.SaveConfirm()" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnSubmit" runat="server" Text="<%$ Resources:Deatil.Btn.Submint%>"
                                            Icon="Tick">
                                            <Listeners>
                                                <Click Handler=" Ext.Msg.confirm('Message', MsgList.MsgItem.ConfirmMsg1,
                                                                                        function(e) { if (e == 'yes') { Coolite.AjaxMethods.SaveSubmit({success:function(result){ if(result=='') { Ext.Msg.alert('Success', MsgList.MsgItem.ConfirmMsg2,function() {location.reload();});} else { Ext.Msg.alert('Error', result);} },failure:function(err){Ext.Msg.alert('Error', err);}}); } });" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnIAFReturn" runat="server" Text="<%$ Resources:Deatil.Btn.IAFReturn%>"
                                            Icon="Tick" Hidden="true">
                                            <Listeners>
                                                <Click Handler="Coolite.AjaxMethods.ShowReturnIAFWindow();" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnAuthorization" runat="server" Text="<%$ Resources:Deatil.Btn.Authorization%>"
                                            Icon="PageExcel" Hidden="true">
                                            <Listeners>
                                                <Click Handler="Coolite.AjaxMethods.ShowAuthorizationWindow();" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnCancel" runat="server" Text="<%$ Resources:Deatil.Btn.Cancel%>"
                                            Icon="Delete">
                                            <Listeners>
                                                <Click Handler="window.location.href('ContractMaster.aspx');" />
                                            </Listeners>
                                        </ext:Button>
                                    </Items>
                                </ext:Toolbar>
                            </TopBar>
                            <Tabs>
                                <ext:Tab ID="tabForm1" runat="server" Title="<%$ Resources:Deatil.Tab1%>" Icon="ApplicationEdit"
                                    AutoShow="true" Hidden="true">
                                    <AutoLoad Mode="IFrame" MaskMsg="<%$ Resources:Deatil.Processing%>" ShowMask="true"
                                        Scripts="true" />
                                </ext:Tab>
                                <ext:Tab ID="tabForm2" runat="server" Title="<%$ Resources:Deatil.Tab2%>" Icon="ApplicationEdit"
                                    AutoShow="false" Hidden="true">
                                    <AutoLoad Mode="IFrame" MaskMsg="<%$ Resources:Deatil.Processing%>" ShowMask="true"
                                        Scripts="true" />
                                </ext:Tab>
                                <ext:Tab ID="tabForm3" runat="server" Title="<%$ Resources:Deatil.Tab3%>" Icon="ApplicationEdit"
                                    AutoShow="false" Hidden="true">
                                    <AutoLoad Mode="IFrame" MaskMsg="<%$ Resources:Deatil.Processing%>" ShowMask="true"
                                        Scripts="true" />
                                </ext:Tab>
                                <ext:Tab ID="tabForm3_Equipment" runat="server" Title="<%$ Resources:Deatil.Tab3%>"
                                    Icon="ApplicationEdit" AutoShow="false" Hidden="true">
                                    <AutoLoad Mode="IFrame" MaskMsg="<%$ Resources:Deatil.Processing%>" ShowMask="true"
                                        Scripts="true" />
                                </ext:Tab>
                                <ext:Tab ID="tabForm4" runat="server" Title="<%$ Resources:Deatil.Tab4%>" Icon="ApplicationEdit"
                                    AutoShow="false" Hidden="true">
                                    <AutoLoad Mode="IFrame" MaskMsg="<%$ Resources:Deatil.Processing%>" ShowMask="true"
                                        Scripts="true" />
                                </ext:Tab>
                                <ext:Tab ID="tabForm5" runat="server" Title="<%$ Resources:Deatil.Tab5%>" Icon="ApplicationEdit"
                                    AutoShow="false" Hidden="true">
                                    <AutoLoad Mode="IFrame" MaskMsg="<%$ Resources:Deatil.Processing%>" ShowMask="true"
                                        Scripts="true" />
                                </ext:Tab>
                                <ext:Tab ID="tabForm6" runat="server" Title="<%$ Resources:Deatil.Tab6%>" Icon="ApplicationEdit"
                                    AutoShow="false" Hidden="true">
                                    <AutoLoad Mode="IFrame" MaskMsg="<%$ Resources:Deatil.Processing%>" ShowMask="true"
                                        Scripts="true" />
                                </ext:Tab>
                                <ext:Tab ID="tabForm7" runat="server" Title="<%$ Resources:Deatil.Tab7%>" Icon="ApplicationEdit"
                                    AutoShow="false" Hidden="true">
                                    <AutoLoad Mode="IFrame" MaskMsg="<%$ Resources:Deatil.Processing%>" ShowMask="true"
                                        Scripts="true" />
                                </ext:Tab>
                                <ext:Tab ID="tabContract" runat="server" Title="<%$ Resources:Deatil.Tab.Contract%>"
                                    Icon="ApplicationEdit" AutoShow="false" Hidden="true">
                                    <AutoLoad Mode="IFrame" MaskMsg="<%$ Resources:Deatil.Processing%>" ShowMask="true"
                                        Scripts="true" />
                                </ext:Tab>
                                <ext:Tab ID="tabAnnex" Hidden="True" runat="server" Title="<%$ Resources:Deatil.Tab.Annex%>" Icon="ApplicationEdit"
                                    AutoShow="false">
                                    <AutoLoad Mode="IFrame" MaskMsg="<%$ Resources:Deatil.Processing%>" ShowMask="true"
                                        Scripts="true" />
                                </ext:Tab>
                                <ext:Tab ID="tabIAFOperation" runat="server" Title="IAF操作记录" Icon="ApplicationEdit"
                                    AutoShow="false">
                                    <AutoLoad Mode="IFrame" MaskMsg="<%$ Resources:Deatil.Processing%>" ShowMask="true"
                                        Scripts="true" />
                                </ext:Tab>
                            </Tabs>
                        </ext:TabPanel>
                    </ext:FitLayout>
                </Body>
            </ext:ViewPort>
        </div>
        <div>
            <ext:Window ID="windowReturnIAF" runat="server" Icon="Group" Title="" Resizable="false"
                Header="false" Width="390" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
                BodyStyle="padding:5px;">
                <Body>
                    <ext:FormLayout ID="FormLayout9" runat="server">
                        <ext:Anchor>
                            <ext:Panel ID="Panel27" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".5">
                                            <ext:Panel ID="Panel28" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="100">
                                                        <ext:Anchor>
                                                            <ext:TextArea ID="taRemark" runat="server" FieldLabel="<%$ Resources:Deatil.IAFReasons%>"
                                                                Width="220">
                                                            </ext:TextArea>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                            </ext:Panel>
                        </ext:Anchor>
                    </ext:FormLayout>
                </Body>
                <Buttons>
                    <ext:Button ID="btnReturnIAFSubmit" runat="server" Text="<%$ Resources:Deatil.Btn.IAFReturnReasons%>"
                        Icon="Tick">
                        <Listeners>
                            <Click Handler="Coolite.AjaxMethods.SubmintReturnIAF({success:function(result)
                                                                                {if(result=='')
                                                                                     { Ext.Msg.alert('Success', MsgList.MsgItem.ConfirmMsg3,function() 
                                                                                                                                            {
                                                                                                                                                window.location.href('ContractMaster.aspx');
                                                                                                                                            })
                                                                                     ;}
                                                                                     else { Ext.Msg.alert('Error', result);} ;},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="btnReturnIAFCancel" runat="server" Text="<%$ Resources:Deatil.Btn.IAFCancel%>"
                        Icon="Delete">
                        <Listeners>
                            <Click Handler="#{windowReturnIAF}.hide();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Window>
            <ext:Window ID="windowAuthorization" runat="server" Icon="Group" Title="<%$ Resources:Deatil.window.PDFTitle%>"
                Resizable="false" Header="false" Width="390" AutoHeight="true" AutoShow="false"
                Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
                <Body>
                    <ext:FormLayout ID="FormLayout1" runat="server">
                        <ext:Anchor>
                            <ext:Panel ID="Panel1" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".5">
                                            <ext:Panel ID="Panel2" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="100">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="tfAuthorizationCode" runat="server" EmptyText="<%$ Resources:Deatil.Window.AuthorizationNumber.Empty%>"
                                                                Width="200" AllowBlank="false" FieldLabel="<%$ Resources:Deatil.Btn.AuthorizationNumber%>">
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="tfAuthorizationContacts" runat="server" EmptyText="<%$ Resources:Deatil.Window.AuthorizationContacts.Empty%>"
                                                                Width="200" Hidden="true" FieldLabel="<%$ Resources:Deatil.Txt.AuthorizationContacts%>">
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="tfAuthorizationPhone" runat="server" EmptyText="<%$ Resources:Deatil.Window.AuthorizationPhone.Empty%>"
                                                                Width="200" Hidden="true" FieldLabel="<%$ Resources:Deatil.Txt.AuthorizationPhone%>">
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                            </ext:Panel>
                        </ext:Anchor>
                    </ext:FormLayout>
                </Body>
                <Buttons>
                    <ext:Button Hidden ="True" ID="btnAuthorizationPDF" runat="server" Text="<%$ Resources:Deatil.Btn.Authorization%>"
                        Icon="PageExcel">
                        <Listeners>
                            <Click Handler="if(#{tfAuthorizationCode}.getValue() == ''){alert('请填写授权编号！');} else{window.open('PrintPage.aspx?ExportType=Authorization'
                        +'&contractId='+#{hidContractId}.getValue()
                        +'&dealerId='+#{hidDealerId}.getValue()
                        +'&dealerName='+#{hidDealerName}.getValue()
                        +'&dealerType='+#{hidDealerType}.getValue()
                        +'&parmetType='+#{hidParmetType}.getValue()
                        +'&Identifier='+#{tfAuthorizationCode}.getValue()
                        +'&conUser='+#{tfAuthorizationContacts}.getValue()
                        +'&conTel='+#{tfAuthorizationPhone}.getValue()
                        +'&begindate='+#{hidEffectiveDate}.getValue()
                        +'&SuBu='+#{hidSuBU}.getValue()
                        +'&enddate='+#{hidExpirationDate}.getValue());}" />
                        </Listeners>
                    </ext:Button>

                    <%--     <ext:Button ID="btnAuthorizationPDF" runat="server" Text="<%$ Resources:Deatil.Btn.Authorization%>"
                    AutoPostBack="true" OnClick="CreatLetterAuthorizationpdf" Icon="PageWhiteAcrobat"
                    OnClientClick="var result = CheckAuthorization();  return result;">
                </ext:Button>--%>
                    <ext:Button ID="Button2" runat="server" Text="<%$ Resources:Deatil.Btn.AuthorizationCancel%>"
                        Icon="Delete">
                        <Listeners>
                            <Click Handler="#{windowAuthorization}.hide();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Window>
        </div>
    </form>
</body>
</html>
