<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductList.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.ProductList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext"  %><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/T.R/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<title>ProductList</title>
</head>

<body>
<form id="form1" runat="server">
<ext:ScriptManager ID="ScriptManager1" runat="server"></ext:ScriptManager>
<ext:Store ID="Store1" runat="server" UseIdConfirmation="false" >
     <Proxy><ext:DataSourceProxy /></Proxy> 
     <Reader><ext:JsonReader ><Fields>
         <ext:RecordField Name="Id" />
         <ext:RecordField Name="Upn" />
         <ext:RecordField Name="UnitOfMeasure" />
         <ext:RecordField Name="Name" />
         <ext:RecordField Name="ProductCategory" />
         <ext:RecordField Name="LotTrack" />
         <ext:RecordField Name="Version" />
         <ext:RecordField Name="DmaId" />
         <ext:RecordField Name="Cfn" />
         <ext:RecordField Name="SapUnitPrice" />
         <ext:RecordField Name="DescChinese" />
         <ext:RecordField Name="DescEnglish" />
         <ext:RecordField Name="Implant" />
         <ext:RecordField Name="ConvertFromPartPmaId" />
         <ext:RecordField Name="ConvertFactor" />
         <ext:RecordField Name="ProductCategoryPctId" />
         <ext:RecordField Name="LastUpdateDate" />
         <ext:RecordField Name="LastUpdateUser" />
         <ext:RecordField Name="DeletedFlag" />
         <ext:RecordField Name="Property8" />
         <ext:RecordField Name="Property7" />
         <ext:RecordField Name="Property6" />
         <ext:RecordField Name="Property5" />
         <ext:RecordField Name="Property4" />
         <ext:RecordField Name="Property3" />
         <ext:RecordField Name="Property2" />
         <ext:RecordField Name="Property1" />
         <ext:RecordField Name="ProductLineBumId" />
       </Fields></ext:JsonReader></Reader>
 </ext:Store>

<div id="gridPanel">
<ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
     <ColumnModel ID="ColumnModel1" runat="server">
         <Columns>
             <ext:Column ColumnID="Id" DataIndex="Id" Header="<%$ Resources: GridPanel1.ColumnModel1.Id.Header %>">
                <Editor>
                   <ext:TextField ID="txtId" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Upn" DataIndex="Upn" Header="<%$ Resources: GridPanel1.ColumnModel1.Upn.Header %>">
                <Editor>
                   <ext:TextField ID="txtUpn" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources: GridPanel1.ColumnModel1.UnitOfMeasure.Header %>">
                <Editor>
                   <ext:TextField ID="txtUnitOfMeasure" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources: GridPanel1.ColumnModel1.Name.Header %>">
                <Editor>
                   <ext:TextField ID="txtName" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="ProductCategory" DataIndex="ProductCategory" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductCategory.Header %>">
                <Editor>
                   <ext:TextField ID="txtProductCategory" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="LotTrack" DataIndex="LotTrack" Header="<%$ Resources: GridPanel1.ColumnModel1.LotTrack.Header %>。">
                <Editor>
                   <ext:TextField ID="txtLotTrack" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Version" DataIndex="Version" Header="<%$ Resources: GridPanel1.ColumnModel1.Version.Header %>。
">
                <Editor>
                   <ext:TextField ID="txtVersion" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="DmaId" DataIndex="DmaId" Header="<%$ Resources: GridPanel1.ColumnModel1.DmaId.Header %>">
                <Editor>
                   <ext:TextField ID="txtDmaId" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Cfn" DataIndex="Cfn" Header="<%$ Resources: GridPanel1.ColumnModel1.Cfn.Header %>">
                <Editor>
                   <ext:TextField ID="txtCfn" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="SapUnitPrice" DataIndex="SapUnitPrice" Header="<%$ Resources: GridPanel1.ColumnModel1.SapUnitPrice.Header %>
注意单位变换后，单价会发生变化。">
                <Editor>
                   <ext:TextField ID="txtSapUnitPrice" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="DescChinese" DataIndex="DescChinese" Header="<%$ Resources: GridPanel1.ColumnModel1.DescChinese.Header %>">
                <Editor>
                   <ext:TextField ID="txtDescChinese" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="DescEnglish" DataIndex="DescEnglish" Header="<%$ Resources: GridPanel1.ColumnModel1.DescEnglish.Header %>">
                <Editor>
                   <ext:TextField ID="txtDescEnglish" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Implant" DataIndex="Implant" Header="<%$ Resources: GridPanel1.ColumnModel1.Implant.Header %>">
                <Editor>
                   <ext:TextField ID="txtImplant" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="ConvertFromPartPmaId" DataIndex="ConvertFromPartPmaId" Header="<%$ Resources: GridPanel1.ColumnModel1.ConvertFromPartPmaId.Header %>">
                <Editor>
                   <ext:TextField ID="txtConvertFromPartPmaId" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="ConvertFactor" DataIndex="ConvertFactor" Header="<%$ Resources: GridPanel1.ColumnModel1.ConvertFactor.Header %>">
                <Editor>
                   <ext:TextField ID="txtConvertFactor" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="ProductCategoryPctId" DataIndex="ProductCategoryPctId" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductCategoryPctId.Header %>">
                <Editor>
                   <ext:TextField ID="txtProductCategoryPctId" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="LastUpdateDate" DataIndex="LastUpdateDate" Header="<%$ Resources: GridPanel1.ColumnModel1.LastUpdateDate.Header %>">
                <Editor>
                   <ext:TextField ID="txtLastUpdateDate" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="LastUpdateUser" DataIndex="LastUpdateUser" Header="<%$ Resources: GridPanel1.ColumnModel1.LastUpdateUser.Header %>">
                <Editor>
                   <ext:TextField ID="txtLastUpdateUser" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="DeletedFlag" DataIndex="DeletedFlag" Header="<%$ Resources: GridPanel1.ColumnModel1.DeletedFlag.Header %>">
                <Editor>
                   <ext:TextField ID="txtDeletedFlag" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Property8" DataIndex="Property8" Header="">
                <Editor>
                   <ext:TextField ID="txtProperty8" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Property7" DataIndex="Property7" Header="">
                <Editor>
                   <ext:TextField ID="txtProperty7" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Property6" DataIndex="Property6" Header="">
                <Editor>
                   <ext:TextField ID="txtProperty6" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Property5" DataIndex="Property5" Header="">
                <Editor>
                   <ext:TextField ID="txtProperty5" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Property4" DataIndex="Property4" Header="">
                <Editor>
                   <ext:TextField ID="txtProperty4" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Property3" DataIndex="Property3" Header="">
                <Editor>
                   <ext:TextField ID="txtProperty3" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Property2" DataIndex="Property2" Header="">
                <Editor>
                   <ext:TextField ID="txtProperty2" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="Property1" DataIndex="Property1" Header="">
                <Editor>
                   <ext:TextField ID="txtProperty1" runat="server" />
                </Editor>
             </ext:Column>
             <ext:Column ColumnID="ProductLineBumId" DataIndex="ProductLineBumId" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductLineBumId.Header %>">
                <Editor>
                   <ext:TextField ID="txtProductLineBumId" runat="server" />
                </Editor>
             </ext:Column>
          </Columns>
      </ColumnModel>
   <SelectionModel><ext:RowSelectionModel ID="RowSelectionModel1" runat="server" /></SelectionModel>
   <BottomBar>
       <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1" DisplayInfo="true" EmptyMsg="<%$ Resources: GridPanel1.PagingToolBar1.EmptyMsg %>" />
   </BottomBar>
   <SaveMask ShowMask="true" />
   <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
   <Listeners></Listeners>
</ext:GridPanel></div>

<div id="editPanel" >
<ext:Panel ID="Panel2" runat="server" BodyBorder="false" Header="false">
	<Body>
	   <ext:FormLayout ID="FormLayout2" runat="server">
	   		<ext:Anchor>
	   			<ext:TextField ID="Id" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.Id.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Upn" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.Upn.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="UnitOfMeasure" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.UnitOfMeasure.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Name" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.Name.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="ProductCategory" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.ProductCategory.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="LotTrack" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.LotTrack.Header %>。" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Version" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.Version.Header %>。
" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="DmaId" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.DmaId.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Cfn" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.Cfn.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="SapUnitPrice" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.SapUnitPrice.Header %>
注意单位变换后，单价会发生变化。" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="DescChinese" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.DescChinese.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="DescEnglish" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.DescEnglish.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Implant" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.Implant.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="ConvertFromPartPmaId" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.ConvertFromPartPmaId.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="ConvertFactor" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.ConvertFactor.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="ProductCategoryPctId" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.ProductCategoryPctId.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="LastUpdateDate" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.LastUpdateDate.Header %>" Width="250"  />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="LastUpdateUser" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.LastUpdateUser.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="DeletedFlag" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.DeletedFlag.Header %>" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Property8" runat="server" FieldLabel="" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Property7" runat="server" FieldLabel="" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Property6" runat="server" FieldLabel="" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Property5" runat="server" FieldLabel="" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Property4" runat="server" FieldLabel="" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Property3" runat="server" FieldLabel="" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Property2" runat="server" FieldLabel="" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="Property1" runat="server" FieldLabel="" Width="250" />
	   		</ext:Anchor>
	   		<ext:Anchor>
	   			<ext:TextField ID="ProductLineBumId" runat="server" FieldLabel="<%$ Resources: Panel2.FormLayout2.ProductLineBumId.Header %>" Width="250" />
	   		</ext:Anchor>
	   </ext:FormLayout>
	</Body>
</ext:Panel></div>

</form></body></html>