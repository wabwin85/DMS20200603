<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true"
    CodeBehind="MyInfo.aspx.cs" Inherits="DMS.Website.Pages.MyInfo" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script language="javascript">
        var MsgList = {
			btnSavePerson:{
				SuccessTitle:"<%=GetLocalResourceObject("Panel1.btnSavePerson.Alert.Title").ToString()%>",
				SuccessMsg:"<%=GetLocalResourceObject("Panel1.btnSavePerson.Alert.Body").ToString()%>"
			}
        }
        
        var CheckInfo=function()
        {
        
          var fullname = Ext.getCmp('<%= txtFullName.ClientID %>').getValue();
          var email=Ext.getCmp('<%= txtEmail.ClientID %>').getValue();
          var phone=Ext.getCmp('<%= txtPhone.ClientID %>').getValue();
          var address=Ext.getCmp('<%= txtAddress.ClientID %>').getValue();
          if(fullname!=''&&email!==''&&phone!=''&&address!='')
          {
             Coolite.AjaxMethods.SavePerson(
             {
             
                  success: function() {
                    Ext.Msg.alert('<%=GetLocalResourceObject("Panel1.btnSavePerson.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("Panel1.btnSavePerson.Alert.Body").ToString()%>');
                                        },
                                        failure: function() {
                                            Ext.Msg.alert('<%=GetLocalResourceObject("SaveFailure").ToString()%>', '<%=GetLocalResourceObject("SaveFailure").ToString()%>');
                                        }
                                    }
             
             );
          }
          else
          {
                Ext.Msg.alert('<%=GetLocalResourceObject("SaveFailure").ToString()%>', '<%=GetLocalResourceObject("SaveFailure").ToString()%>');
          }
          
        }
    </script>

    <ext:Panel runat="server">
        <Body>
            <ext:ContainerLayout ID="ContainerLayout1" runat="server">
                <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true"
                    FormGroup="true" ButtonAlign="Left" BodyStyle="padding: 10px;">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout runat="server">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtLoginId" runat="server" ReadOnly="true" FieldLabel="<%$ Resources: Panel1.txtLoginId.FieldLabel %>"
                                                    Width="260" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtFullName" runat="server" FieldLabel="<%$ Resources: Panel1.txtFullName.FieldLabel %>"
                                                    Width="260" AllowBlank="false" EmptyText="请输入登录姓名"/>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtEmail" runat="server" FieldLabel="<%$ Resources: Panel1.txtEmail.FieldLabel %>"
                                                    Width="260" AllowBlank="false" Vtype="email" EmptyText="请输入电子邮箱" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtEmail1" runat="server" FieldLabel="<%$ Resources: Panel1.txtEmail1.FieldLabel %>"
                                                    Width="260" Vtype="email" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ReadOnly="true" ID="txtPhone" runat="server" FieldLabel="<%$ Resources: Panel1.txtPhone.FieldLabel %>"
                                                    Width="260" AllowBlank="false" EmptyText="请输入电话"/>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtAddress" runat="server" FieldLabel="<%$ Resources: Panel1.txtAddress.FieldLabel %>"
                                                    Width="260" AllowBlank="false" EmptyText="请输入地址" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCustomField1" runat="server" FieldLabel="<%$ Resources: Panel1.txtCustomField1.FieldLabel %>"
                                                    Width="260" Hidden="true" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCustomField2" runat="server" FieldLabel="<%$ Resources: Panel1.txtCustomField2.FieldLabel %>"
                                                    Width="260" Hidden="true" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCustomField3" runat="server" FieldLabel="<%$ Resources: Panel1.txtCustomField3.FieldLabel %>"
                                                    Width="260" Hidden="true" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="plOrder" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="130">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtContactPerson" runat="server" FieldLabel="<%$ Resources: FormLayout2.txtContactPerson.FieldLabel %>"
                                                    Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtContact" runat="server" FieldLabel="<%$ Resources: FormLayout2.txtContact.FieldLabel %>"
                                                    Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtContactMobile" runat="server" FieldLabel="<%$ Resources: FormLayout2.txtContactMobile.FieldLabel %>"
                                                    Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtConsignee" runat="server" FieldLabel="<%$ Resources: FormLayout2.txtConsignee.FieldLabel %>"
                                                    Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtConsigneePhone" runat="server" FieldLabel="<%$ Resources: FormLayout2.txtConsigneePhone.FieldLabel %>"
                                                    Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderEmail" runat="server" FieldLabel="<%$ Resources: FormLayout2.txtOrderEmail.FieldLabel %>"
                                                    Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtShipmentDealer" runat="server" FieldLabel="<%$ Resources: FormLayout2.txtShipmentDealer.FieldLabel %>"
                                                    Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Checkbox ID="chkReceiveSMS" runat="server" FieldLabel="<%$ Resources: FormLayout2.chkReceiveSMS.FieldLabel %>"
                                                    Checked="true">
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Checkbox ID="chkReceiveEmail" runat="server" FieldLabel="<%$ Resources: FormLayout2.chkReceiveEmail.FieldLabel %>"
                                                    Checked="true">
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Checkbox ID="chkReceiveOrder" runat="server" FieldLabel="<%$ Resources: FormLayout2.chkReceiveOrder.FieldLabel %>"
                                                    Checked="true">
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Hidden ID="hidIsNew" runat="server">
                                                </ext:Hidden>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnSavePerson" runat="server" Text="<%$ Resources: Panel1.btnSavePerson.Text %>"
                            Icon="Disk">
                            <Listeners>
                             <Click Handler="CheckInfo()" />
                            </Listeners>
                          <%--  <AjaxEvents>
                                <Click OnEvent="SavePerson" Success="Ext.Msg.alert(MsgList.btnSavePerson.SuccessTitle,MsgList.btnSavePerson.SuccessMsg);" />
                            </AjaxEvents>--%>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
                <ext:Panel ID="plCorporation" runat="server" Title="<%$ Resources: plCorporation.Title %>"
                    AutoHeight="true" FormGroup="true" ButtonAlign="Left" BodyStyle="padding: 10px;">
                    <Body>
                        <ext:FormLayout ID="FormLayout11" runat="server">
                            <ext:Anchor>
                                <ext:TextField ID="txtDealerId" Hidden="true" runat="server" FieldLabel="<%$ Resources: FormLayout11.txtDealerId.FieldLabel %>"
                                    Width="250" />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField ID="txtDealerChineseName" runat="server" ReadOnly="true" FieldLabel="<%$ Resources: FormLayout11.txtDealerChineseName.FieldLabel %>"
                                    Width="250" AllowBlank="false" />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField ID="txtDealerEnglishName" runat="server" ReadOnly="true" FieldLabel="<%$ Resources: FormLayout11.txtDealerEnglishName.FieldLabel %>"
                                    Width="250" />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField ID="txtDealerCertification" runat="server" ReadOnly="true" FieldLabel="<%$ Resources: FormLayout11.txtDealerCertification.FieldLabel %>"
                                    Width="250" />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField ID="txtDealerAddress" runat="server" ReadOnly="true" FieldLabel="<%$ Resources: FormLayout11.txtDealerAddress.FieldLabel %>"
                                    Width="250" />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField ID="txtDealerPostalCode" runat="server" ReadOnly="true" FieldLabel="<%$ Resources: FormLayout11.txtDealerPostalCode.FieldLabel %>"
                                    Width="250" />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField ID="txtDealerPhone" runat="server" ReadOnly="true" FieldLabel="<%$ Resources: FormLayout11.txtDealerPhone.FieldLabel %>"
                                    Width="250" />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField ID="txtDealerFax" runat="server" ReadOnly="true" FieldLabel="<%$ Resources: FormLayout11.txtDealerFax.FieldLabel %>"
                                    Width="250" />
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                </ext:Panel>
            </ext:ContainerLayout>
        </Body>
    </ext:Panel>
</asp:Content>
