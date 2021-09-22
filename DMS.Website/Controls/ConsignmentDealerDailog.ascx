<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ConsignmentDealerDailog.ascx.cs"
    Inherits="DMS.Website.Controls.ConsignmentDealerDailog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

<style type="text/css">
    .list-item
    {
        font: normal 11px tahoma, arial, helvetica, sans-serif;
        padding: 3px 10px 3px 10px;
        border: 1px solid #fff;
        border-bottom: 1px solid #eeeeee;
        white-space: normal;
        color: #555;
    }
    .list-item h3
    {
        display: block;
        font: inherit;
        font-weight: bold;
        color: #222;
    }
    .ext-ie7 .onepx-shift
    {
        top: 1px;
        position: relative;
    }
</style>

<script type="text/javascript">   
    //添加选中的经销商
    
    var addItemsDealer = function(grid) {
    var hidtrtnVal=Ext.getCmp('<%=this.hidtrtnVal.ClientID%>');
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
            var param = '';
            for (var i = 0; i < selList.length; i++) {
                param += selList[i].id + ',';
            }
            Ext.Msg.confirm('消息', '确认要添加选中的经销商',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.ConsignmentDealerDailog.DoAddItems(param,
                        {
                            success: function() {
                               if(hidtrtnVal.getValue()=='True')
                               {
                               Ext.getCmp('<%=this.DealerSearchDlg.ClientID%>').hide();
                          
                               ReDelare();
                               }
                            },
                            failure: function(err) {
                                Ext.Msg.alert('错误', err);
                            }
                        }
                        );
                    } else {
                                        
                    }
                });
        } else {
            Ext.MessageBox.alert('消息', '确认要添加选中的经销商');
        }
    }
    
    var cancelDialog =function()
    { 
        <%= DealerSearchDlg.ClientID %>.hide(null);
    }       
    
    
</script>

<ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="DealerList_RefreshData"
    AutoLoad="true">
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
<ext:Hidden runat="server" ID="hidProductDivsion">
</ext:Hidden>
<ext:Hidden runat="server" ID="hidCmId">
</ext:Hidden>
<ext:Hidden runat="server" ID="hidtrtnVal">
</ext:Hidden>

<ext:Window ID="DealerSearchDlg" runat="server" Icon="Group" Title="明细" Width="780"
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
                                                <ext:TextField ID="txtFilterDealer" runat="server" FieldLabel="经销商中文名" Width="200" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtFilterSAPCode" runat="server" FieldLabel="SAP账号" Width="200" />
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
                                                <ext:ComboBox ID="cboFilterDealterType" runat="server" FieldLabel="经销商类别" StoreID="DealerTypeStore"
                                                    Editable="false" TypeAhead="true" Mode="Local" DisplayField="Value" ValueField="Key"
                                                    ListWidth="300" Resizable="true" ForceSelection="true" TriggerAction="All" EmptyText="经销商类别"
                                                    ItemSelector="div.list-item" SelectOnFocus="true" Width="200">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
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
                                            <ext:Anchor>
                                                <ext:TextField ID="TextProductLine" runat="server" FieldLabel="产品线" ReadOnly="true"
                                                    Width="200" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                    <Buttons>
                                        <ext:Button ID="SearchButton" Text="查找" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                            <Listeners>
                                                <Click Handler="#{PagingToolBar3}.changePage(1);" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="Savebutton" runat="server" Text="添加" Icon="Add"
                                            IDMode="Legacy" Enabled="true">
                                          <Listeners>
                                          <Click  Handler="addItemsDealer(#{DealerPanel});"/>
                                          </Listeners>
                                      </ext:Button>
                                        <ext:Button ID="Cancelbutton" Text="返回" runat="server" Icon="Cancel" IDMode="Legacy">
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
                            <ext:GridPanel ID="DealerPanel" runat="server" Title="经销商列表" StoreID="Store1" AutoScroll="true"
                                Border="false" Icon="Lorry" AutoWidth="true" AutoExpandColumn="Id" Header="false"
                                StripeRows="true">
                                <ColumnModel ID="ColumnModel3" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                        </ext:Column>
                                        <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="中文名" Width="200">
                                        </ext:Column>
                                      <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="SAP账号">
                                        </ext:Column>
                                     <ext:Column ColumnID="DealerType" DataIndex="DealerType" Header="经销商类别">
                                            <Renderer Handler="return getNameFromStoreById(DealerTypeMainStore,{Key:'Key',Value:'Value'},value);" />
                                        </ext:Column>
                                        <ext:Column ColumnID="Address" DataIndex="Address" Header="地址">
                                        </ext:Column>
                                        <ext:Column ColumnID="PostalCode" DataIndex="PostalCode" Header="邮编">
                                         </ext:Column>
                                        <ext:Column ColumnID="Phone"  DataIndex="Phone" Header="电话">
                                        </ext:Column>
                                        <ext:Column ColumnID="Fax"  DataIndex="Fax" Header="传真">
                                        </ext:Column>
                                        <ext:CheckColumn ColumnID="ActiveFlag" DataIndex="ActiveFlag" Header="有效" Width="50">
                                        </ext:CheckColumn>
                                    </Columns>
                                </ColumnModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="20" StoreID="Store1"
                                        DisplayInfo="true" />
                                </BottomBar>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                    </ext:CheckboxSelectionModel>
                                </SelectionModel>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
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
