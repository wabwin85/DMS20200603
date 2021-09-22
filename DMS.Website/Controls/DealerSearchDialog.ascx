<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DealerSearchDialog.ascx.cs" Inherits="DMS.Website.Controls.DealerSearchDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
<style type="text/css">
    .list-item {
        font: normal 11px tahoma, arial, helvetica, sans-serif;
        padding: 3px 10px 3px 10px;
        border: 1px solid #fff;
        border-bottom: 1px solid #eeeeee;
        white-space: normal;
        color: #555;
    }

        .list-item h3 {
            display: block;
            font: inherit;
            font-weight: bold;
            color: #222;
        }

    .ext-ie7 .onepx-shift {
        top: 1px;
        position: relative;
    }
</style>

<script type="text/javascript">   
    //添加选中的经销商
    
    var addItems = function(grid) {
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
            var param = '';
            for (var i = 0; i < selList.length; i++) {
                param += selList[i].id + ',';
            }
            Ext.Msg.confirm('<%=GetLocalResourceObject("addItems.confirm.Title").ToString()%>', '<%=GetLocalResourceObject("addItems.confirm.Body").ToString()%>',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.DealerSearchDialog.DoAddItems(param,
                        {
                            success: function() {
                                cancelDialog;
                            },
                            failure: function(err) {
                                Ext.Msg.alert('<%=GetLocalResourceObject("addItems.alert.Title").ToString()%>', err);
                            }
                        }
                        );
                        } else {
                                        
                        }
                });
                } else {
                    alert('111');
                    Ext.MessageBox.alert('<%=GetLocalResourceObject("addItems.PleaseSelectDealer.Title").ToString()%>', '<%=GetLocalResourceObject("addItems.PleaseSelectDealer.Body").ToString()%>');
        }
    }
    
    var cancelDialog =function()
    { 
        <%= DealerSearchDlg.ClientID %>.hide(null);
    }       
    
    
</script>
<ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="DealerList_RefreshData" AutoLoad="true">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="ChineseName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
</ext:Store>
<ext:Store ID="DealerTypeStore" runat="server" UseIdConfirmation="true" OnRefreshData="DealerTypeStore_RefreshData">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Key">
            <Fields>
                <ext:RecordField Name="Key" />
                <ext:RecordField Name="Value" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="Key" Direction="ASC" />
</ext:Store>
<ext:Hidden ID="hidbumid" runat="server"></ext:Hidden>
<ext:Store ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="Store1_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="ChineseName" />
                <ext:RecordField Name="ChineseShortName" />
                <ext:RecordField Name="EnglishName" />
                <ext:RecordField Name="EnglishShortName" />
                <ext:RecordField Name="Nbr" />
                <ext:RecordField Name="SapCode" />
                <ext:RecordField Name="DealerType" />
                <ext:RecordField Name="CompanyType" />
                <ext:RecordField Name="CompanyGrade" />
                <ext:RecordField Name="FirstContractDate" />
                <ext:RecordField Name="RegisteredAddress" />
                <ext:RecordField Name="Address" />
                <ext:RecordField Name="ShipToAddress" />
                <ext:RecordField Name="PostalCode" />
                <ext:RecordField Name="Phone" />
                <ext:RecordField Name="Fax" />
                <ext:RecordField Name="ContactPerson" />
                <ext:RecordField Name="Email" />
                <ext:RecordField Name="GeneralManager" />
                <ext:RecordField Name="LegalRep" />
                <ext:RecordField Name="RegisteredCapital" />
                <ext:RecordField Name="Bank" />
                <ext:RecordField Name="BankAccount" />
                <ext:RecordField Name="TaxNo" />
                <ext:RecordField Name="License" />
                <ext:RecordField Name="LicenseLimit" />
                <ext:RecordField Name="Province" />
                <ext:RecordField Name="City" />
                <ext:RecordField Name="District" />
                <ext:RecordField Name="SalesMode" />
                <ext:RecordField Name="Taxpayer" />
                <ext:RecordField Name="Finance" />
                <ext:RecordField Name="FinancePhone" />
                <ext:RecordField Name="FinanceEmail" />
                <ext:RecordField Name="Payment" />
                <ext:RecordField Name="EstablishDate" />
                <ext:RecordField Name="SystemStartDate" />
                <ext:RecordField Name="Certification" />
                <ext:RecordField Name="HostCompanyFlag" />
                <ext:RecordField Name="DealerOrderNbrName" />
                <ext:RecordField Name="SapInvoiceToEmail" />
                <ext:RecordField Name="LastUpdateDate" />
                <ext:RecordField Name="LastUpdateUser" />
                <ext:RecordField Name="ActiveFlag" />
                <ext:RecordField Name="DeletedFlag" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="ChineseName" Direction="DESC" />
    
    <Listeners>
        <LoadException Handler="Ext.Msg.alert('<%$ Resources: MSG.LoadException %>', e.message || e )" />
        <CommitFailed Handler="Ext.Msg.alert('<%$ Resources: MSG.CommitFailed %>', '<%$ Resources: MSG.CommitFailed1 %>' + msg)" />
        <SaveException Handler="Ext.Msg.alert('<%$ Resources: MSG.Save %>', e.message || e)" />
        <CommitDone Handler="Ext.Msg.alert('<%$ Resources: MSG.CommitDone %>', '<%$ Resources: MSG.CommitDone1 %>');" />
    </Listeners>
</ext:Store>

<ext:Window ID="DealerSearchDlg" runat="server" Icon="Group" Title="<%$ Resources: DealerSearchDlg.Title %>" Width="780"
    Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:Panel ID="Panel8" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="100">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtFilterDealer" runat="server" FieldLabel="<%$ Resources: DealerSearchDlg.cbDealer.FieldLabel%>"
                                                    Width="200" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtFilterSAPCode" runat="server" FieldLabel="<%$ Resources: DealerSearchDlg.txtFilterSAPCode.FieldLabel%>"
                                                    Width="200" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel10" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="100">

                                            <ext:Anchor>
                                                <ext:ComboBox ID="cboFilterDealterType" runat="server" FieldLabel="<%$ Resources: DealerSearchDlg.cboFilterDealterType.FieldLabel%>" StoreID="DealerTypeStore"
                                                    Editable="false" TypeAhead="true" Mode="Local" DisplayField="Value" ValueField="Key" ListWidth="300" Resizable="true"
                                                    ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: DealerSearchDlg.cboFilterDealterType.EmptyText%>" ItemSelector="div.list-item"
                                                    SelectOnFocus="true" Width="200">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DealerSearchDlg.cboFilterDealterType.FieldTrigger.Qtip%>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                    <Template ID="Template1" runat="server">
                                                    <tpl for=".">
                                                        <div class="list-item">
                                                             {Value}
                                                        </div>
                                                    </tpl>
                                                    </Template>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                    <Buttons>
                                        <ext:Button ID="SearchButton" Text="<%$ Resources: SearchButton.Text%>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                            <Listeners>
                                                <Click Handler="#{DealerPanel}.reload();" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="Savebutton" runat="server" Text="<%$ Resources:Savebutton.Text%>" Icon="Disk" CommandArgument=""
                                            CommandName="" IDMode="Legacy" OnClientClick="" Enabled="true">
                                            <AjaxEvents>
                                                <Click OnEvent="SubmitSelection" Success="RefreshDetail();cancelDialog();">
                                                    <ExtraParams>
                                                        <ext:Parameter Name="Values" Value="Ext.encode(#{DealerPanel}.getRowsValues())" Mode="Raw" />
                                                    </ExtraParams>
                                                </Click>
                                            </AjaxEvents>
                                        </ext:Button>
                                        <ext:Button ID="Cancelbutton" Text="<%$ Resources:Cancelbutton.Text%>" runat="server" Icon="Cancel" IDMode="Legacy">
                                            <Listeners>
                                                <Click Handler="cancelDialog();" />
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
                <ext:Panel ID="DealerPanel1" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout3" runat="server">
                            <ext:GridPanel ID="DealerPanel" runat="server" Title="<%$ Resources:DealerPanel.Title%>" StoreID="Store1" AutoScroll="true"
                                Border="false" Icon="Lorry" AutoWidth="true" AutoExpandColumn="Id" Header="false" StripeRows="true">
                                <ColumnModel ID="ColumnModel3" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                        </ext:Column>
                                        <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources:DealerPanel.ChineseName.Header%>" Width="200">
                                        </ext:Column>
                                        <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="<%$ Resources:DealerPanel.SapCode.Header%>">
                                        </ext:Column>
                                        <ext:Column ColumnID="DealerType" DataIndex="DealerType" Header="<%$ Resources:DealerPanel.DealerType.Header%>">
                                            <Renderer Handler="return getNameFromStoreById(DealerTypeMainStore,{Key:'Key',Value:'Value'},value);" />
                                        </ext:Column>
                                        <ext:Column ColumnID="Address" DataIndex="Address" Header="<%$ Resources:DealerPanel.Address.Header%>">
                                        </ext:Column>
                                        <ext:Column ColumnID="Province" Hidden="true" DataIndex="Province" Header="<%$ Resources:DealerPanel.Province.Header%>">
                                        </ext:Column>
                                        <ext:Column ColumnID="City" Hidden="true" DataIndex="City" Header="<%$ Resources:DealerPanel.City.Header%>">
                                        </ext:Column>
                                        <ext:Column ColumnID="District" Hidden="true" DataIndex="District" Header="<%$ Resources:DealerPanel.District.Header%>">
                                        </ext:Column>
                                        <ext:Column ColumnID="PostalCode" DataIndex="PostalCode" Header="<%$ Resources:DealerPanel.PostalCode.Header%>">
                                        </ext:Column>
                                        <ext:Column ColumnID="Phone" DataIndex="Phone" Header="<%$ Resources:DealerPanel.Phone.Header%>">
                                        </ext:Column>
                                        <ext:Column ColumnID="Fax" DataIndex="Fax" Header="<%$ Resources:DealerPanel.Fax.Header%>">
                                        </ext:Column>
                                        <ext:CheckColumn ColumnID="ActiveFlag" DataIndex="ActiveFlag" Header="<%$ Resources:DealerPanel.ActiveFlag.Header%>" Width="50">
                                        </ext:CheckColumn>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                    </ext:CheckboxSelectionModel>
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="500" StoreID="Store1"
                                        DisplayInfo="true" EmptyMsg="没有数据显示" />
                                </BottomBar>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" Msg="<%$ Resources:DealerPanel.LoadMask.Msg%>" />
                                <Listeners>
                                    <Command Handler="" />
                                </Listeners>
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Listeners>
        <Hide Handler="#{DealerPanel}.clear();" />
    </Listeners>
</ext:Window>
