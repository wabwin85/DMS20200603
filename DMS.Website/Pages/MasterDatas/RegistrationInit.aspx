<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegistrationInit.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.RegistrationInit" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>

    <script language="javascript">
    var MsgList = {
		SaveButton:{
			BeforeTitle:"<%=GetLocalResourceObject("ViewPort1.SaveButton.Msg.Wait.Title").ToString()%>",
			BeforeMsg:"<%=GetLocalResourceObject("ViewPort1.SaveButton.Msg.Wait.Message").ToString()%>",
			FailureTitle:"<%=GetLocalResourceObject("ViewPort1.SaveButton.Msg.Show.Title").ToString()%>",
			FailureMsg:"<%=GetLocalResourceObject("ViewPort1.SaveButton.Msg.Show.Message").ToString()%>"
		},
		ImportButton:{
			BeforeTitle:"<%=GetLocalResourceObject("ViewPort1.ImportButton.Msg.Wait.Title").ToString()%>",
			BeforeMsg:"<%=GetLocalResourceObject("ViewPort1.ImportButton.Msg.Wait.Message").ToString()%>"
		}
    }
    </script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Store ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="RegistrationNbrcn" />
                        <ext:RecordField Name="RegistrationNbren" />
                        <ext:RecordField Name="RegistrationProductName" />
                        <ext:RecordField Name="OpeningDate" />
                        <ext:RecordField Name="ExpirationDate" />
                        <ext:RecordField Name="ArticleNumber" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="EnglishName" />
                        <ext:RecordField Name="Specification" />
                        <ext:RecordField Name="ManufacturerId" />
                        <ext:RecordField Name="ManufacturerName" />
                        <ext:RecordField Name="ManufacturerAddress" />
                        <ext:RecordField Name="ManufactoryAddress" />
                        <ext:RecordField Name="Scope" />
                        <ext:RecordField Name="RegisteredAgent" />
                        <ext:RecordField Name="Service" />
                        <ext:RecordField Name="Import" />
                        <ext:RecordField Name="Implant" />
                        <ext:RecordField Name="Lot" />
                        <ext:RecordField Name="Sn" />
                        <ext:RecordField Name="Pacemaker" />
                        <ext:RecordField Name="GuaranteePeriod" />
                        <ext:RecordField Name="MinUnit" />
                        <ext:RecordField Name="Barcode1" />
                        <ext:RecordField Name="Barcode2" />
                        <ext:RecordField Name="Barcode3" />
                        <ext:RecordField Name="Barcode4" />
                        <ext:RecordField Name="User" />
                        <ext:RecordField Name="LineNbr" />
                        <ext:RecordField Name="Error" />
                        <ext:RecordField Name="ErrorDesc" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="LineNbr" Direction="ASC" />
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Title="<%$ Resources: ViewPort1.BasicForm.Title %>"
                            AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                            <Defaults>
                                <ext:Parameter Name="anchor" Value="50%" Mode="Value" />
                                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                            </Defaults>
                            <Body>
                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="50">
                                    <ext:Anchor>
                                        <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="<%$ Resources: ViewPort1.FileUploadField1.EmptyText %>"
                                            FieldLabel="<%$ Resources: ViewPort1.FileUploadField1.FieldLabel %>" ButtonText=""
                                            Icon="ImageAdd">
                                        </ext:FileUploadField>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                            <Listeners>
                                <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                            </Listeners>
                            <Buttons>
                                <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: ViewPort1.SaveButton.Text %>">
                                    <AjaxEvents>
                                        <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                                    Ext.Msg.wait(MsgList.SaveButton.BeforeTitle, MsgList.SaveButton.BeforeMsg);"
                                            Failure="Ext.Msg.show({ 
                                                    title   : MsgList.SaveButton.FailureTitle, 
                                                    msg     : MsgList.SaveButton.FailureMsg, 
                                                    minWidth: 200, 
                                                    modal   : true, 
                                                    icon    : Ext.Msg.ERROR, 
                                                    buttons : Ext.Msg.OK 
                                                });" Success="#{ImportButton}.setDisabled(false);#{SaveButton}.setDisabled(true);">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="ResetButton" runat="server" Text="<%$ Resources: ViewPort1.ResetButton.Text %>">
                                    <Listeners>
                                        <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);#{ImportButton}.setDisabled(true);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="ImportButton" runat="server" Text="<%$ Resources: ViewPort1.ImportButton.Text %>"
                                    Disabled="true">
                                    <AjaxEvents>
                                        <Click OnEvent="ImportClick" Before="Ext.Msg.wait(MsgList.ImportButton.BeforeTitle, MsgList.ImportButton.BeforeMsg);">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="DownloadButton" runat="server" Text="<%$ Resources: ViewPort1.DownloadButton.Text %>">
                                    <Listeners>
                                        <Click Handler="window.open('../../Upload/ExcelTemplate/Template_Registration.xls')" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel9" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="GridPanel3" runat="server" Title="<%$ Resources: GridPanel3.Title %>"
                                        StoreID="Store1" Border="false" Icon="Error" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="LineNbr" DataIndex="LineNbr" Header="<%$ Resources: GridPanel3.ColumnModel3.LineNbr.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ErrorDesc" DataIndex="ErrorDesc" Header="<%$ Resources: GridPanel3.ColumnModel3.ErrorDesc.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="RegistrationNbrcn" DataIndex="RegistrationNbrcn" Header="<%$ Resources: GridPanel3.ColumnModel3.RegistrationNbrcn.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="RegistrationNbren" DataIndex="RegistrationNbren" Header="<%$ Resources: GridPanel3.ColumnModel3.RegistrationNbren.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="RegistrationProductName" DataIndex="RegistrationProductName"
                                                    Header="<%$ Resources: GridPanel3.ColumnModel3.RegistrationProductName.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="OpeningDate" DataIndex="OpeningDate" Header="<%$ Resources: GridPanel3.ColumnModel3.OpeningDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpirationDate" DataIndex="ExpirationDate" Header="<%$ Resources: GridPanel3.ColumnModel3.ExpirationDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArticleNumber" DataIndex="ArticleNumber" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel3.ColumnModel3.ChineseName.Header  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="<%$ Resources: GridPanel3.ColumnModel3.EnglishName.Header  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Specification" DataIndex="Specification" Header="<%$ Resources: GridPanel3.ColumnModel3.Specification.Header  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ManufacturerId" DataIndex="ManufacturerId" Header="<%$ Resources: GridPanel3.ColumnModel3.ManufacturerId.Header  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ManufacturerName" DataIndex="ManufacturerName" Header="<%$ Resources: GridPanel3.ColumnModel3.ManufacturerName.Header  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ManufacturerAddress" DataIndex="ManufacturerAddress" Header="<%$ Resources: GridPanel3.ColumnModel3.ManufacturerAddress.Header  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ManufactoryAddress" DataIndex="ManufactoryAddress" Header="<%$ Resources: GridPanel3.ColumnModel3.ManufactoryAddress.Header  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Scope" DataIndex="Scope" Header="<%$ Resources: GridPanel3.ColumnModel3.Scope.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="RegisteredAgent" DataIndex="RegisteredAgent" Header="<%$ Resources: GridPanel3.ColumnModel3.RegisteredAgent.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Service" DataIndex="Service" Header="<%$ Resources: GridPanel3.ColumnModel3.Service.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Import" DataIndex="Import" Header="<%$ Resources: GridPanel3.ColumnModel3.Import.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Implant" DataIndex="Implant" Header="<%$ Resources: GridPanel3.ColumnModel3.Implant.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Lot" DataIndex="Lot" Header="<%$ Resources: GridPanel3.ColumnModel3.Lot.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Sn" DataIndex="Sn" Header="<%$ Resources: GridPanel3.ColumnModel3.Sn.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Pacemaker" DataIndex="Pacemaker" Header="<%$ Resources: GridPanel3.ColumnModel3.Pacemaker.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="GuaranteePeriod" DataIndex="GuaranteePeriod" Header="<%$ Resources: GridPanel3.ColumnModel3.GuaranteePeriod.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="MinUnit" DataIndex="MinUnit" Header="<%$ Resources: GridPanel3.ColumnModel3.MinUnit.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Barcode1" DataIndex="Barcode1" Header="<%$ Resources:GridPanel3.ColumnModel3.Barcode1.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Barcode2" DataIndex="Barcode2" Header="<%$ Resources:GridPanel3.ColumnModel3.Barcode2.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Barcode3" DataIndex="Barcode3" Header="<%$ Resources:GridPanel3.ColumnModel3.Barcode3.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Barcode4" DataIndex="Barcode4" Header="<%$ Resources:GridPanel3.ColumnModel3.Barcode4.Header %>">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources:GridPanel3.PagingToolBar1.EmptyMsg %>" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel3.LoadMask.Msg %>" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Hidden ID="hiddenFileName" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidRMID" runat="server">
        </ext:Hidden>
    </div>
    </form>
</body>
</html>
