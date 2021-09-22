<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegistrationList.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.RegistrationList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        var MsgList = {
			btnImport:"<%=GetLocalResourceObject("btnImport.Tabname").ToString()%>"
        }

        function getValue()
        {
            
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server"></ext:ScriptManager>
        <ext:Store ID="RegistrationMainStore" runat="server" OnRefreshData="RegistrationMainStore_RefershData" AutoLoad="false" >
            <Proxy><ext:DataSourceProxy /></Proxy> 
            <Reader><ext:JsonReader ><Fields>
            <ext:RecordField Name="Id" />
            <ext:RecordField Name="RegistrationNbrcn" />
            <ext:RecordField Name="RegistrationNbren" />
            <ext:RecordField Name="OpeningDate" />
            <ext:RecordField Name="ExpirationDate" />
            <ext:RecordField Name="RegistrationProductName" />
            </Fields></ext:JsonReader></Reader>
        </ext:Store>
        <ext:Store ID="RegistrationDetailStore" runat="server" OnRefreshData="RegistrationDetailStore_RefershData" AutoLoad="false" >
            <Proxy><ext:DataSourceProxy /></Proxy> 
            <Reader><ext:JsonReader ><Fields>
            <ext:RecordField Name="Id" />
            <ext:RecordField Name="RmId" />
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
            </Fields></ext:JsonReader></Reader>
        </ext:Store>

        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>" Frame="true" AutoHeight="true"
                        Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtArticleNumber" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" >
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="txtOpeningDateStart" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.FormLayout1.txtOpeningDateStart.FieldLabel %>"/>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="txtExpirationDateStart" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.FormLayout1.txtExpirationDateStart.FieldLabel %>"/>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtRegistrationNbr" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.FormLayout2.txtRegistrationNbr.FieldLabel %>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="txtOpeningDateEnd" runat="server" Width="150" LabelSeparator="~"/>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="txtExpirationDateEnd" runat="server" Width="150" LabelSeparator="~"/>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout5" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtRegistrationProductName" runat="server" Width="150" FieldLabel="<%$ Resources: GridPanel1.ColumnModel1.RegistrationProductName.Header %>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="<%$ Resources: plSearch.btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{GridPanel1}.reload();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnImport" runat="server" Text="<%$ Resources: plSearch.btnImport.Text %>" Icon="Add" IDMode="Legacy" >
                                    <Listeners>
                                        <%--<Click Handler="window.parent.loadExample('/Pages/MasterDatas/RegistrationInit.aspx','subMenu133',MsgList.btnImport);" />--%>
                                        <Click Handler="top.createTab({id: 'subMenu133',title: '导入',url: 'Pages/MasterDatas/RegistrationInit.aspx'});" />

                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                        StoreID="RegistrationMainStore" Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="RegistrationNbrcn" DataIndex="RegistrationNbrcn" Header="<%$ Resources: GridPanel1.ColumnModel1.RegistrationNbrcn.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="RegistrationNbren" DataIndex="RegistrationNbren" Header="<%$ Resources: GridPanel1.ColumnModel1.RegistrationNbren.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="RegistrationProductName" DataIndex="RegistrationProductName" Header="<%$ Resources: GridPanel1.ColumnModel1.RegistrationProductName.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="OpeningDate" DataIndex="OpeningDate" Header="<%$ Resources: GridPanel1.ColumnModel1.OpeningDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpirationDate" DataIndex="ExpirationDate" Header="<%$ Resources: GridPanel1.ColumnModel1.ExpirationDate.Header %>">
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.ToolTip.Text %>" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="Coolite.AjaxMethods.Show(record.data.Id,{success:function(){#{GridPanel2}.reload();#{DetailWindow}.show();},failure:function(err){Ext.Msg.alert('Error', err);}})" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="RegistrationMainStore"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources: GridPanel1.PagingToolBar1.EmptyMsg %>"/>
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>" Width="1000"
            Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="RegistrationNbrcn" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout3.RegistrationNbrcn.FieldLabel %>" ReadOnly="true" >
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="RegistrationNbren" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout3.RegistrationNbren.FieldLabel %>" ReadOnly="true" >
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="RegistrationProductName" runat="server" Width="150" FieldLabel="注册证产品名称" ReadOnly="true" >
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="OpeningDate" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.OpeningDate.FieldLabel %>" ReadOnly="true" Disabled="true"   >
                                                        </ext:DateField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="ExpirationDate" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.ExpirationDate.FieldLabel %>" ReadOnly="true" Disabled="true" >
                                                        </ext:DateField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel10" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout2" runat="server">
                                    <ext:GridPanel ID="GridPanel2" runat="server" Title="<%$ Resources: GridPanel2.Title %>" StoreID="RegistrationDetailStore"
                                        Border="false" Icon="Lorry" AutoWidth="true"  StripeRows="true">
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ArticleNumber" DataIndex="ArticleNumber" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel2.ColumnModel2.ChineseName.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="<%$ Resources: GridPanel2.ColumnModel2.EnglishName.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Specification" DataIndex="Specification" Header="<%$ Resources: GridPanel2.ColumnModel2.Specification.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ManufacturerId" DataIndex="ManufacturerId" Header="<%$ Resources: GridPanel2.ColumnModel2.ManufacturerId.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ManufacturerName" DataIndex="ManufacturerName" Header="<%$ Resources: GridPanel2.ColumnModel2.ManufacturerName.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ManufacturerAddress" DataIndex="ManufacturerAddress" Header="<%$ Resources: GridPanel2.ColumnModel2.ManufacturerAddress.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ManufactoryAddress" DataIndex="ManufactoryAddress" Header="<%$ Resources: GridPanel2.ColumnModel2.ManufactoryAddress.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Scope" DataIndex="Scope" Header="<%$ Resources: GridPanel2.ColumnModel2.Scope.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="RegisteredAgent" DataIndex="RegisteredAgent" Header="<%$ Resources: GridPanel2.ColumnModel2.RegisteredAgent.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Service" DataIndex="Service" Header="<%$ Resources: GridPanel2.ColumnModel2.Service.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Import" DataIndex="Import" Header="<%$ Resources: GridPanel2.ColumnModel2.Import.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Implant" DataIndex="Implant" Header="<%$ Resources: GridPanel2.ColumnModel2.Implant.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Lot" DataIndex="Lot" Header="<%$ Resources: GridPanel2.ColumnModel2.Lot.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Sn" DataIndex="Sn" Header="<%$ Resources: GridPanel2.ColumnModel2.Sn.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Pacemaker" DataIndex="Pacemaker" Header="<%$ Resources: GridPanel2.ColumnModel2.Pacemaker.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="GuaranteePeriod" DataIndex="GuaranteePeriod" Header="<%$ Resources: GridPanel2.ColumnModel2.GuaranteePeriod.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="MinUnit" DataIndex="MinUnit" Header="<%$ Resources: GridPanel2.ColumnModel2.MinUnit.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Barcode1" DataIndex="Barcode1" Header="<%$ Resources: GridPanel2.ColumnModel2.Barcode1.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Barcode2" DataIndex="Barcode2" Header="<%$ Resources: GridPanel2.ColumnModel2.Barcode2.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Barcode3" DataIndex="Barcode3" Header="<%$ Resources: GridPanel2.ColumnModel2.Barcode3.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Barcode4" DataIndex="Barcode4" Header="<%$ Resources: GridPanel2.ColumnModel2.Barcode4.Header %>">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="RegistrationDetailStore"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources: GridPanel2.PagingToolBar2.EmptyMsg %>" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Listeners>
                <Hide Handler="#{GridPanel2}.clear();" />
            </Listeners>
        </ext:Window>
        <ext:Hidden ID="hidRMID" runat="server" ></ext:Hidden>
    </div>
    </form>
</body>
</html>
