<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CFNHospitalPrice.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.CFNHospitalPrice" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext"  %>
<%@ Register Src="../../Controls/HospitalSelectorDialog.ascx" TagName="HospitalSelectorDialog"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
     <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
    
        <script type="text/javascript">

        //Dialog:医院
        var showHospitalSelectorDlg = function() {
            
            var ProductLineId = <%=hiddenProductLine.ClientID %>.getValue();
            var CFNId = <%=hiddenCFNId.ClientID %>.getValue();
            
            if(CFNId != "" && CFNId != null){
                
                openHospitalSelectorDlg(ProductLineId);
            }
            
        }
        //设置是否需要保存
        var SetModified = function(isModified) {
            Ext.getCmp('<%=this.hidIsModified.ClientID%>').setValue(isModified ? "True" : "False");
        }
        
        var NeedSave = function() {
            var isModified = Ext.getCmp('<%= this.hidIsModified.ClientID %>').getValue() == "True" ? true : false;
                return true;
        }
        
        var DoSearch = function(){
            if (Ext.getCmp('<%=cbProduct.ClientID%>').getValue()=='')
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("plSearch.btnSearch.Msg.alert.Title").ToString()%>', '<%=GetLocalResourceObject("plSearch.btnSearch.Msg.alert.Body").ToString()%>');
            }
            else
            {
                Ext.getCmp('<%=GridPanel1.ClientID%>').reload();
            }
        }
        
        var DoDelete = function(){
            var result = confirm('<%=GetLocalResourceObject("plSearch.btnDelete.confirm").ToString()%>');             
            if ( result && Ext.getCmp('<%=GridPanel1.ClientID%>').hasSelection()) 
            {
                Ext.getCmp('<%=GridPanel1.ClientID%>').deleteSelected();
            }
        }
        
        var DoWinSearch = function(){
            if (Ext.getCmp('<%=txtProduct.ClientID%>').getValue()=='' || Ext.getCmp('<%=txtArticleNumber.ClientID%>').getValue()=='')
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("DetailWindow.SearchButton.Msg.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("DetailWindow.SearchButton.Msg.Alert").ToString()%>')
            }
            else
            {
                Ext.getCmp('<%=DetailPanel.ClientID%>').reload();
            }
        }
        </script>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server"></ext:ScriptManager>
        <ext:Store ID="Store1" runat="server"  OnRefreshData="Store1_RefershData"
            OnBeforeStoreChanged="Store1_BeforeStoreChanged" AutoLoad="false" >
             <Proxy><ext:DataSourceProxy /></Proxy> 
             <Reader><ext:JsonReader ><Fields>
                 <ext:RecordField Name="Id" />
                 <ext:RecordField Name="HosId" />
                 <ext:RecordField Name="HospitalName" />
                 <ext:RecordField Name="Province" />
                 <ext:RecordField Name="City" />
                 <ext:RecordField Name="District" />
                 <ext:RecordField Name="Grade" />
                 <ext:RecordField Name="CfnId" />
                 <ext:RecordField Name="ProductLineBumId" />
                 <ext:RecordField Name="CustomerFaceNbr" />
                 <ext:RecordField Name="ChineseName" />
                 <ext:RecordField Name="EnglishName" />
                 <ext:RecordField Name="Description" />
                 <ext:RecordField Name="Price" />
                 <ext:RecordField Name="CreateUser" />
                 <ext:RecordField Name="CreateDate" />
                 <ext:RecordField Name="UpdateUser" />
                 <ext:RecordField Name="UpdateDate" />
                 <ext:RecordField Name="DeletedFlag" />
               </Fields></ext:JsonReader></Reader>
         </ext:Store>
         <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine" >
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="AttributeName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Id" Direction="ASC" />
        </ext:Store>
         <ext:Store ID="Store2" runat="server" AutoLoad="false" OnRefreshData="DetailStore_RefershData"
            OnBeforeStoreChanged="DetailStore_BeforeStoreChanged">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="HosId" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="Grade" />
                        <ext:RecordField Name="Province" />
                        <ext:RecordField Name="City" />
                        <ext:RecordField Name="District" />
                        <ext:RecordField Name="Price" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('<%$ Resources: Store2.LoadException.Msg.alert %>', e.message || e )" />
            </Listeners>
        </ext:Store>
         
         <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources:plSearch.Title %>" Frame="true" AutoHeight="true"
                        Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".25">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProduct" runat="server" EmptyText="<%$ Resources:plSearch.FormLayout1.cbProduct.EmptyText %>" Width="150" Editable="true" AllowBlank="false"
                                                            TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName" ListWidth="300" Resizable="true"
                                                            FieldLabel="<%$ Resources:plSearch.FormLayout1.cbProduct.FieldLabel %>">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:plSearch.FormLayout1.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>

                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtArtNum" runat="server" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>"  Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtHospitalName" runat="server" FieldLabel="<%$ Resources:plSearch.FormLayout1.txtHospitalName.FieldLabel %>"  Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="<%$ Resources: plSearch.btnSearch.Text  %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="DoSearch()" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: plSearch.btnInsert.Text  %>" Icon="Add" CommandArgument=""
                                    CommandName="" IDMode="Legacy" OnClientClick="">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.Show({success:function(){#{DetailPanel}.clear();#{DetailWindow}.show();}});" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnSave" runat="server" Text="<%$ Resources: plSearch.btnSave.Text  %>" Icon="Disk" CommandArgument=""
                                    CommandName="" IDMode="Legacy" OnClientClick="">
                                    <Listeners>
                                        <Click Handler="#{GridPanel1}.save();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: plSearch.btnDelete.Text  %>" Icon="Delete" CommandArgument=""
                                    CommandName="" IDMode="Legacy" OnClientClick="">
                                    <Listeners>
                                        <Click Handler="DoDelete()" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                            
                        </ext:Panel>
                    </North>
                    
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.QueryResultID.Title %>"
                                        StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                 <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel1.ColumnModel1.ChineseName.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="<%$ Resources: GridPanel1.ColumnModel1.EnglishName.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="Description" DataIndex="Description" Header="<%$ Resources: GridPanel1.ColumnModel1.Description.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="<%$ Resources: GridPanel1.ColumnModel1.HospitalName.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="Province" DataIndex="Province" Header="<%$ Resources: GridPanel1.ColumnModel1.Province.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="City" DataIndex="City" Header="<%$ Resources: GridPanel1.ColumnModel1.City.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="District" DataIndex="District" Header="<%$ Resources: GridPanel1.ColumnModel1.District.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="Grade" DataIndex="Grade" Header="<%$ Resources: GridPanel1.ColumnModel1.Grade.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="Price" DataIndex="Price" Header="<%$ Resources: GridPanel1.ColumnModel1.Price.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtEditPrice" Width="90" runat="server" >
                                                        </ext:TextField>
                                                    </Editor>
                                                 </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources: GridPanel1.PagingToolBar1.EmptyMsg %>" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg%>" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title%>" Width="780"
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
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="txtProduct" runat="server" EmptyText="<%$ Resources: DetailWindow.FormLayout2.txtProduct.EmptyText%>" Width="150" Editable="true" AllowBlank="false"
                                                            TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName" ListWidth="300" Resizable="true"
                                                            FieldLabel="<%$ Resources: DetailWindow.FormLayout2.txtProduct.FieldLabel%>" >
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout2.FieldTrigger.Qtip%>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();#{AjaxMethods}.ChangeProductLine('True',{success:function(){#{DetailPanel}.clear();}});" />
                                                                <Change Handler="#{AjaxMethods}.ChangeProductLine('False',{success:function(){#{DetailPanel}.clear();}});" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtChineseName" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout2.txtChineseName.FieldLabel%>" ReadOnly="true" >
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtDescription" runat="server" Width="200" FieldLabel="<%$ Resources: DetailWindow.FormLayout2.txtDescription.FieldLabel%>" ReadOnly="true"  >
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtArticleNumber" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtEnglishName" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.FormLayout3.txtEnglishName.FieldLabel%>" ReadOnly="true" >
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                            <Buttons>
                                                <ext:Button ID="SearchButton" Text="<%$ Resources:DetailWindow.SearchButton.Text  %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="DoWinSearch()" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="Savebutton" runat="server" Text="<%$ Resources:DetailWindow.Savebutton.Text  %>" Icon="Disk" CommandArgument=""
                                                    CommandName="" IDMode="Legacy" OnClientClick="">
                                                    <Listeners>
                                                        <Click Handler="#{DetailPanel}.save();" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="Cancelbutton" Text="<%$ Resources:DetailWindow.Cancelbutton.Text  %>" runat="server" Icon="Cancel" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="#{DetailWindow}.hide(null);" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Buttons>
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
                                    <ext:GridPanel ID="DetailPanel" runat="server" Title="<%$ Resources:DetailPanel.Title  %>" StoreID="Store2"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                    <ext:Button ID="btnAddItem" runat="server" Text="<%$ Resources:DetailPanel.btnAddItem.Text %>" Icon="Add">
                                                        <Listeners>
                                                            <Click Fn="showHospitalSelectorDlg"/>
                                                        </Listeners>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                 <ext:Column ColumnID="HosId" DataIndex="HospitalName" Header="<%$ Resources:DetailPanel.ColumnModel2.HosId.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="<%$ Resources:DetailPanel.ColumnModel2.HospitalName.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="Province" DataIndex="Province" Header="<%$ Resources:DetailPanel.ColumnModel2.Province.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="City" DataIndex="City" Header="<%$ Resources:DetailPanel.ColumnModel2.City.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="District" DataIndex="District" Header="<%$ Resources:DetailPanel.ColumnModel2.District.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="Grade" DataIndex="Grade" Header="<%$ Resources:DetailPanel.ColumnModel2.Grade.Header %>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="Price" DataIndex="Price" Header="<%$ Resources:DetailPanel.ColumnModel2.Price.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtPrice" runat="server" Width="60">
                                                        </ext:TextField>
                                                    </Editor>
                                                 </ext:Column>
                                                 <ext:CommandColumn Width="50" Header="<%$ Resources:DetailPanel.ColumnModel2.CommandColumn.Header %>" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources:DetailPanel.ColumnModel2.CommandColumn.GridCommand.ToolTip-Text %>" />
                                                        <%--  <ext:GridCommand Icon="NoteEdit" CommandName="Edit" ToolTip-Text="Edit" />--%>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="Store2"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources:DetailWindow.PagingToolBar2.EmptyMsg%>" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources:DetailWindow.LoadMask.Msg%>" />
                                        <Listeners>
                                            <Command Handler="if (command == 'Delete'){ 
                                                    Coolite.AjaxMethods.DeleteItem(this.getSelectionModel().getSelected().data.HosId,{failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                    }" />
                                            <BeforeEdit Handler="" />
                                            <AfterEdit Handler="" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Listeners>
                <Hide Handler="#{DetailPanel}.clear();" />
                <BeforeHide Handler="return NeedSave();" />
            </Listeners>
        </ext:Window>
        
        <uc1:HospitalSelectorDialog ID="HospitalSelectorDialog1" runat="server" />
        <ext:Hidden ID="hiddenProductLine" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenCFNId" runat="server"></ext:Hidden>
        <ext:Hidden ID="hidIsPageNew" runat="server"></ext:Hidden>
        <ext:Hidden ID="hidIsModified" runat="server"></ext:Hidden>
    </form>
</body>
</html>
