<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CfnList.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.CfnList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/CFNEditor.ascx" TagName="CFNEditor" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    
        <script type="text/javascript"> 

        var CFNDetailsRender = function() {
            return '<img class="imgEdit" ext:qtip="<%=GetLocalResourceObject("CFNDetailsRender.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/vcard_edit.png" />';
        }

        var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

            if (t.className == 'imgEdit' && columnId == 'Details') {
                openCFNDetails(record, t, test);

                //the ajax event allowed
                //return true;

            }
        }
        
        
        var createCFN = function() {
            var flag = "0";
            var record = Ext.getCmp("GridPanel1").insertRecord(0, {});

            record.set('LastUpdateDate', Ext.util.Format.date(Date(), "Y-m-d\\TH:i:s"));

            Ext.getCmp("GridPanel1").getView().focusRow(0);
            Coolite.AjaxMethods.CreateCFNs();

            createCFNDetails(record, "GridPanel1", null, flag);
            //Ext.getCmp("GridPanel1").startEditing(0, 0);

        }

        var DoDelete = function() {
            var result = confirm('<%=GetLocalResourceObject("plSearch.btnDelete.Confirm").ToString()%>');
            if (result && Ext.getCmp('<%=GridPanel1.ClientID%>').hasSelection()) 
                Ext.getCmp('<%=GridPanel1.ClientID%>').deleteSelected();
        }

        var DoInsert = function() {
            if (Ext.getCmp('<%=cbCatories.ClientID%>').getValue() == '') {
                Ext.Msg.alert('<%=GetLocalResourceObject("SearchData.Title").ToString()%>', '<%=GetLocalResourceObject("SearchData.Message").ToString()%>');
            }
            else {
                createCFN();
            }
        }
        
        var CfnListMsg = {
            CommitDoneTitle:"<%=GetLocalResourceObject("Store1.CommitDone.Msg.Alert").ToString()%>",
            CommitDoneMsg:"<%=GetLocalResourceObject("Store1.CommitDone.Msg.Body").ToString()%>"
        }
</Script>
    
    
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Debug">
        </ext:ScriptManager>
        
        <ext:Store ID="Store1" runat="server"  OnRefreshData="Store1_RefershData"
            OnBeforeStoreChanged="Store1_BeforeStoreChanged" AutoLoad="false">
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={15}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                     <ext:RecordField Name="Id" />
                     <ext:RecordField Name="EnglishName" />
                     <ext:RecordField Name="ChineseName" />
                     <ext:RecordField Name="Implant" />
                     <ext:RecordField Name="Tool" />
                     <ext:RecordField Name="Share" />
                     <ext:RecordField Name="CustomerFaceNbr" />
                     <ext:RecordField Name="ProductCatagoryPctId" />
                     <ext:RecordField Name="Property1" />
                     <ext:RecordField Name="Property2" />
                     <ext:RecordField Name="Property3" />
                     <ext:RecordField Name="Property4" />
                     <ext:RecordField Name="Property5" />
                     <ext:RecordField Name="Property6" />
                     <ext:RecordField Name="Property7" />
                     <ext:RecordField Name="Property8" />
                     <ext:RecordField Name="LastUpdateDate" />
                     <ext:RecordField Name="DeletedFlag" />
                     <ext:RecordField Name="ProductLineBumId" />
                     <ext:RecordField Name="PCTName" />
                     <ext:RecordField Name="PCTEnglishName" />
                     <ext:RecordField Name="ProductLineName" />
                     <ext:RecordField Name="Description" />
                    </Fields>
                </ext:JsonReader>
            </Reader>

            <SortInfo Field="ProductLineBumId" Direction="DESC" />
                        <SortInfo Field="CustomerFaceNbr" Direction="DESC" />
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('<%$ Resources: Store1.LoadException.Msg.Alert %>', e.message || e )" />
                <CommitFailed Handler="Ext.Msg.alert('<%$ Resources: Store1.CommitFailed.Msg.Alert %>', 'Reason: ' + msg)" />
                <SaveException Handler="Ext.Msg.alert('<%$ Resources: Store1.SaveException.Msg.Alert %>', e.message || e)" />
                <CommitDone Handler="Ext.Msg.alert(CfnListMsg.CommitDoneTitle, CfnListMsg.CommitDoneMsg);" />
            </Listeners>
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
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>" Frame="true" AutoHeight="true"
                        Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".25">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbCatories" runat="server" EmptyText="<%$ Resources: plSearch.FormLayout1.cbCatories.EmptyText %>" Width="150" Editable="true" AllowBlank="false"
                                                            TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName" ListWidth="300" Resizable="true"
                                                            FieldLabel="<%$ Resources: plSearch.FormLayout1.cbCatories.FieldLabel %>">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.FormLayout1.cbCatories.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>

                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtCFN" runat="server" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>"  Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbContain" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout1.cbContain.FieldLabel %>" Width="150" ListWidth="300" 
                                                             Editable="false" Resizable="true" EmptyText="<%$ Resources: plSearch.FormLayout1.cbContain.EmptyText %>">
                                                            <Items>
                                                                <ext:ListItem Text="<%$ Resources: plSearch.FormLayout1.cbContain.Items.Text %>" Value="1" />
                                                                <ext:ListItem Text="<%$ Resources: plSearch.FormLayout1.cbContain.Items.Text1 %>" Value="0" />
                                                            </Items>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.FormLayout1.cbContain.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
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
                                        <Click Handler="Coolite.AjaxMethods.SearchData();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: plSearch.btnInsert.Text %>" Icon="Add" CommandArgument=""
                                    CommandName="" IDMode="Legacy" OnClientClick="">
                                    <Listeners>
                                        <Click Handler="DoInsert()" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnSave" runat="server" Text="<%$ Resources: plSearch.btnSave.Text %>" Icon="Disk" CommandArgument=""
                                    CommandName="" IDMode="Legacy" OnClientClick="">
                                    <Listeners>
                                        <Click Handler="#{GridPanel1}.save();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: plSearch.btnDelete.Text %>" Icon="Delete" CommandArgument=""
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
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                        StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtCustomerFaceNbr" runat="server" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="<%$ Resources: GridPanel1.ColumnModel1.EnglishName.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtEnglishName" runat="server" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel1.ColumnModel1.ChineseName.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtChineseName" runat="server" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="PCTName" DataIndex="PCTName" Header="<%$ Resources: GridPanel1.ColumnModel1.PCTName.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="PCTEnglishName" DataIndex="PCTEnglishName" Header="<%$ Resources: GridPanel1.ColumnModel1.PCTEnglishName.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductLineName.Header %>">
                                                </ext:Column>
                                                <ext:Column DataIndex="Implant" Header="<%$ Resources: GridPanel1.ColumnModel1.Implant.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtImplant" runat="server" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column DataIndex="Tool" Header="<%$ Resources: GridPanel1.ColumnModel1.Tool.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtTool" runat="server" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column DataIndex="Share" Header="<%$ Resources: GridPanel1.ColumnModel1.Share.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="TextField1" runat="server" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="Description" DataIndex="Description" Header="<%$ Resources: GridPanel1.ColumnModel1.Description.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtDescription" runat="server"  />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="Details" Header="<%$ Resources: GridPanel1.ColumnModel1.Details.Header %>" Width="50" Align="Center" Fixed="true"
                                                    MenuDisabled="true" Resizable="false">
                                                    <Renderer Fn="CFNDetailsRender" />
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
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                        <Listeners>
                                            <CellClick Fn="cellClick" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                    
                    
                    
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
         <uc1:CFNEditor ID="CFNEditor1" runat="server" />
    </div>
    </form>
</body>
</html>
