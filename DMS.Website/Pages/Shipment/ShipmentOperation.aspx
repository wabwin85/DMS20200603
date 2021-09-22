<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShipmentOperation.aspx.cs"
    Inherits="DMS.Website.Pages.Shipment.ShipmentOperation" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
    <script language="javascript">
        var MsgList = {
			DetailStore:{
				LoadExceptionTitle:"<%=GetLocalResourceObject("DetailStore.LoadException.Alert").ToString()%>"
			},
			btnSave:{
				FailureTitle:"<%=GetLocalResourceObject("Panel6.btnSave.failure.Alert").ToString()%>"
			}
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CFN" />
                    <ext:RecordField Name="UPN" />
                    <ext:RecordField Name="LotNumber" />
                    <ext:RecordField Name="ExpiredDate" />
                    <ext:RecordField Name="UnitOfMeasure" />
                    <ext:RecordField Name="UnitPrice" />
                    <ext:RecordField Name="ShipmentQty" />
                    <ext:RecordField Name="TotalQty" />
                    <ext:RecordField Name="WarehouseName" />
                    <ext:RecordField Name="WarehouseId" />
                    <ext:RecordField Name="Implant" />
                    <ext:RecordField Name="IsConsumableItem" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.DetailStore.LoadExceptionTitle, e.message || response.statusText);" />
        </Listeners>
    </ext:Store>
    <ext:Hidden ID="hiddenSOID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenSPHID" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="Information">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtDealerName" runat="server" FieldLabel="<%$ Resources: Panel1.Panel3.FormLayout1.txtDealerName.FieldLabel %>" ReadOnly="true"  Width="200"/>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtShipmentDate" runat="server" FieldLabel="<%$ Resources: Panel1.Panel3.FormLayout1.txtShipmentDate.FieldLabel %>" ReadOnly="true" Width="200"/>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtHospitalName" runat="server" FieldLabel="<%$ Resources: Panel1.Panel4.FormLayout2.txtHospitalName.FieldLabel %>" ReadOnly="true" Width="200"/>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtTotalAmount" runat="server" FieldLabel="<%$ Resources: Panel1.Panel4.FormLayout2.txtTotalAmount.FieldLabel %>" ReadOnly="true" Width="200" Hidden="true"/>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtOrderNumber" runat="server" FieldLabel="<%$ Resources: Panel1.Panel5.FormLayout3.txtOrderNumber.FieldLabel %>" ReadOnly="true" Width="200"/>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtInvoice" runat="server" FieldLabel="<%$ Resources: Panel1.Panel5.FormLayout3.txtInvoice.FieldLabel %>" ReadOnly="true" Width="200"/>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="5 5 5 5"  Collapsible="true">
                    <ext:Panel ID="Panel2" runat="server" Height="250" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" StoreID="DetailStore"
                                    Border="false" Icon="Information" AutoWidth="true" StripeRows="true">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="<%$ Resources: GridPanel1.ColumnModel1.WarehouseName.Header %>" Width="180">
                                            </ext:Column>
                                            <ext:Column ColumnID="CFN" DataIndex="CFN" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.LotNumber.Header %>" Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="ShipmentQty" DataIndex="ShipmentQty" Header="<%$ Resources: GridPanel1.ColumnModel1.ShipmentQty.Header %>" Width="60"
                                                Align="Right">
                                            </ext:Column>
                                            <ext:Column ColumnID="UnitPrice" DataIndex="UnitPrice" Header="<%$ Resources: GridPanel1.ColumnModel1.UnitPrice.Header %>" Width="60" Align="Right" Hidden="true">
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="DetailStore"
                                            DisplayInfo="false" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
                <South MarginsSummary="5 5 5 5">
                    <ext:Panel ID="Panel6" runat="server" Title="<%$ Resources: Panel6.Title %>" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="ApplicationFormAdd">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtOfficeName" runat="server" FieldLabel="<%$ Resources: Panel6.Panel7.FormLayout4.txtOfficeName.FieldLabel %>" ReadOnly="false"
                                                        MaxLength="100" Width="200"/>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbPatientGender" runat="server" Width="80" Editable="false" TypeAhead="true"
                                                        FieldLabel="<%$ Resources: Panel6.Panel7.FormLayout4.cbPatientGender.FieldLabel %>" ListWidth="300" Resizable="true" AllowBlank="false" BlankText="<%$ Resources: Panel6.Panel7.FormLayout4.cbPatientGender.BlankText %>"
                                                        EmptyText="<%$ Resources: Panel6.Panel7.FormLayout4.cbPatientGender.EmptyText %>">
                                                        <Items>
                                                            <ext:ListItem Text="<%$ Resources: Panel6.Panel7.FormLayout4.cbPatientGender.ListItem.Text %>" Value="男" />
                                                            <ext:ListItem Text="<%$ Resources: Panel6.Panel7.FormLayout4.cbPatientGender.ListItem.Text1 %>" Value="女" />
                                                        </Items>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtDoctorName" runat="server" FieldLabel="<%$ Resources: Panel6.Panel8.FormLayout5.txtDoctorName.FieldLabel %>" ReadOnly="false"
                                                        MaxLength="100" Width="200"/>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtPatientPIN" runat="server" FieldLabel="<%$ Resources: Panel6.Panel8.FormLayout5.txtPatientPIN.FieldLabel %>" ReadOnly="false"
                                                        MaxLength="20" Width="200"/>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtPatientName" runat="server" FieldLabel="<%$ Resources: Panel6.Panel9.FormLayout6.txtPatientName.FieldLabel %>" ReadOnly="false"
                                                        MaxLength="100" Width="200"/>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtHospitalNo" runat="server" FieldLabel="<%$ Resources: Panel6.Panel9.FormLayout6.txtHospitalNo.FieldLabel %>" ReadOnly="false"
                                                        MaxLength="30" Width="200"/>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSave" Text="<%$ Resources: Panel6.btnSave.Text %>" runat="server" Icon="Add" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="Coolite.AjaxMethods.Save({
                                                    success: function() {
                                                        window.parent.closeTab('subMenu' + #{hiddenSPHID}.getValue());
                                                    },
                                                    failure: function(err) {
                                                        Ext.Msg.alert(MsgList.btnSave.FailureTitle, err);
                                                    }
                                                });" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnCanel" Text="<%$ Resources: Panel6.btnCanel.Text %>" runat="server" Icon="Cancel" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="window.parent.closeTab('subMenu' + #{hiddenSPHID}.getValue())" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </South>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>
</body>
</html>
