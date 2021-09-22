<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CFNSearchDialog.ascx.cs"
    Inherits="DMS.Website.Controls.CFNSearchDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    //var employeeRecord;
   
    var openCfnSearchDlg = function (productline,animTrg) {
        var window = <%= cfnSearchDlg.ClientID %>;
       
        <%= cbCatories.ClientID %>.setValue(productline);
        <%= GridPanel1.ClientID %>.clear();
        window.show(animTrg);
    }
    
    var saveDialog = function () {
        
        <%= cfnSearchDlg.ClientID %>.hide(null);
                  
    }
    
    var cancelDialog =function()
    { 
        <%= cfnSearchDlg.ClientID %>.hide(null);
    }
    
</script>

<ext:Store ID="Store1" runat="server" OnRefreshData="Store1_RefershData" >
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
                <ext:RecordField Name="Description" />
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
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="CustomerFaceNbr" Direction="ASC" />
    <Listeners>
        <LoadException Handler="Ext.Msg.alert('<%$ Resources: MSG.LoadException %>', e )" />
    </Listeners>
</ext:Store>
<ext:Store ID="ProductCatoriesStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine">
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

<ext:Window ID="cfnSearchDlg" runat="server" Icon="Group" Title="<%$ Resources: cfnSearchDlg.Title %>" Closable="false"
    Draggable="false" Resizable="true" Width="800" Height="480" AutoShow="false" AutoScroll="true"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:ContainerLayout ID="ContainerLayout1" runat="server">
            <ext:Panel ID="plSearch" runat="server" Border="false" Frame="true" AutoHeight="true"
                ButtonAlign="Right">
                <Body>
                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                        <ext:LayoutColumn ColumnWidth=".25">
                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                <Body>
                                    <ext:FormLayout ID="FormLayout1" runat="server">
                                        <ext:Anchor>
                                            <ext:ComboBox ID="cbCatories" runat="server" EmptyText="<%$ Resources: cfnSearchDlg.cbCatories.EmptyText %>" Width="150" Editable="true"
                                                AllowBlank="false" TypeAhead="true" StoreID="ProductCatoriesStore" ValueField="Id"
                                                DisplayField="AttributeName" FieldLabel="<%$ Resources: cfnSearchDlg.cbCatories.FieldLabel %>">
                                            </ext:ComboBox>
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:TextField ID="txtCFN" runat="server" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" Width="150">
                                            </ext:TextField>
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:ComboBox ID="cbContain" runat="server" FieldLabel="<%$ Resources: cfnSearchDlg.cbContain.FieldLabel %>" Width="150" ListWidth="300" 
                                                 Editable="false" Resizable="true" EmptyText="<%$ Resources: cfnSearchDlg.cbContain.EmptyText %>">
                                                <Items>
                                                    <ext:ListItem Text="<%$ Resources: cfnSearchDlg.cbContain.ListItem.Text.Yes %>" Value="1" />
                                                    <ext:ListItem Text="<%$ Resources: cfnSearchDlg.cbContain.ListItem.Text.No %>" Value="0" />
                                                </Items>
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cfnSearchDlg.cbContain.FieldTrigger.Qtip %>" />
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
                    <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                        <Listeners>
                            <Click Handler="#{GridPanel1}.clear();#{GridPanel1}.reload();" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="btnOk" runat="server" Text="<%$ Resources: btnOk.Text %>" Icon="Disk" CommandArgument="" CommandName=""
                        IDMode="Legacy" Enabled="false">
                        <AjaxEvents>
                            <Click OnEvent="SubmitSelection" Success="cancelDialog();">
                                <ExtraParams>
                                    <ext:Parameter Name="Values" Value="Ext.encode(#{GridPanel1}.getRowsValues())" Mode="Raw" />
                                </ExtraParams>
                            </Click>
                        </AjaxEvents>
                    </ext:Button>
                    <ext:Button ID="btnCancel" runat="server" Text="<%$ Resources: btnCancel.Text %>" Icon="Cancel" CommandArgument=""
                        CommandName="" IDMode="Legacy" OnClientClick="">
                        <Listeners>
                            <Click Handler="cancelDialog();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Panel>
            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Height="300">
                <Body>
                    <ext:FitLayout ID="FitLayout1" runat="server">
                        <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" StoreID="Store1" 
                            EnableColumnMove="false"  AutoExpandColumn="EnglishName" AutoExpandMax="200" AutoExpandMin="100"
                            Border="false" Icon="Lorry" Header="false" StripeRows="true">
                            <ColumnModel ID="ColumnModel1" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                    </ext:Column>
                                    <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="<%$ Resources: GridPanel1.EnglishName.Header %>">
                                    </ext:Column>
                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel1.ChineseName.Header %>" Width="200">
                                    </ext:Column>
                                    <ext:Column ColumnID="Description" DataIndex="Description" Header="<%$ Resources: GridPanel1.Description.Header %>" Width="200">
                                    </ext:Column>
                                    <ext:Column ColumnID="PCTName" DataIndex="PCTName" Header="<%$ Resources: GridPanel1.PCTName.Header %>">
                                    </ext:Column>
                                    <ext:Column ColumnID="PCTEnglishName" DataIndex="PCTEnglishName" Header="<%$ Resources: GridPanel1.PCTEnglishName.Header %>">
                                    </ext:Column>
                                    <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="<%$ Resources: cfnSearchDlg.cbCatories.FieldLabel %>">
                                    </ext:Column>
                                    <ext:Column DataIndex="Implant" Header="<%$ Resources: GridPanel1.Implant.Header %>">
                                    </ext:Column>
                                    <ext:Column DataIndex="Tool" Header="<%$ Resources: GridPanel1.Tool.Header %>">
                                    </ext:Column>
                                    <ext:Column DataIndex="Share" Header="<%$ Resources: GridPanel1.Share.Header %>">
                                    </ext:Column>
                                </Columns>
                            </ColumnModel>
                           <SelectionModel>
                                <ext:CheckboxSelectionModel ID="RowSelectionModel1" runat="server">
                                    <Listeners>
                                        <RowSelect Handler="#{btnOk}.enable();" />
                                    </Listeners>
                                </ext:CheckboxSelectionModel>
                            </SelectionModel>
                            <BottomBar>
                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                    DisplayInfo="true" EmptyMsg="No data to display" />
                            </BottomBar>
                            <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.Msg.LOAD %>" />
                        </ext:GridPanel>
                    </ext:FitLayout>
                </Body>
            </ext:Panel>
        </ext:ContainerLayout>
    </Body>
</ext:Window>
