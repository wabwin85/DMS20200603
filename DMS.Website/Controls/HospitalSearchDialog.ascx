<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HospitalSearchDialog.ascx.cs"
    Inherits="DMS.Website.Controls.HospitalSearchDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

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
    .form-toolbar
    {
        top: 1px;
        position: relative;
    }
</style>

<script type="text/javascript">
    //var employeeRecord;
   
    var openHospitalSearchDlg = function (animTrg) {
        var window = <%= hospitalSearchDlg.ClientID %>;
       
        <%=hiddenSelectedProductLine.ClientID %>.setValue(animTrg);
        <%= GridPanel1.ClientID %>.clear();
        window.show(null);
    }

   
</script>

<ext:Store ID="HospitalSearchDlgStore" runat="server" UseIdConfirmation="false" OnRefreshData="HospitalStore_RefershData"
    AutoLoad="false" >
    <AutoLoadParams>
        <ext:Parameter Name="start" Value="={0}" />
        <ext:Parameter Name="limit" Value="={15}" />
    </AutoLoadParams>
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="HosId">
            <Fields>
                <ext:RecordField Name="HosId" />
                <ext:RecordField Name="HosHospitalShortName" />
                <ext:RecordField Name="HosHospitalName" />
                <ext:RecordField Name="HosGrade" />
                <ext:RecordField Name="HosKeyAccount" />
                <ext:RecordField Name="HosProvince" />
                <ext:RecordField Name="HosCity" />
                <ext:RecordField Name="HosDistrict" />
                <ext:RecordField Name="HosPhone" />
                <ext:RecordField Name="HosPostalCode" />
                <ext:RecordField Name="HosAddress" />
                <ext:RecordField Name="HosPublicEmail" />
                <ext:RecordField Name="HosWebsite" />
                <ext:RecordField Name="HosChiefEquipment" />
                <ext:RecordField Name="HosChiefEquipmentContact" />
                <ext:RecordField Name="HosDirector" />
                <ext:RecordField Name="HosDirectorContact" />
                <ext:RecordField Name="HosDirectorContact" />
                <ext:RecordField Name="HosLastModifiedDate" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <LoadException Handler="Ext.Msg.alert('<%$ Resources:Msg.LoadException %>', e.message || e )" />
    </Listeners>
</ext:Store>
<ext:Store ID="HospitalGradeStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_HospitalGrade">
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
    <Listeners>
    </Listeners>
</ext:Store>
<ext:Store ID="ProvincesStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProvinces">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="TerId">
            <Fields>
                <ext:RecordField Name="TerId" />
                <ext:RecordField Name="Description" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
    </Listeners>
</ext:Store>
<ext:Store ID="CitiesStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshCities">
    <AutoLoadParams>
        <ext:Parameter Name="parentId" Value="={0}" />
    </AutoLoadParams>
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="TerId">
            <Fields>
                <ext:RecordField Name="TerId" />
                <ext:RecordField Name="Description" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
    </Listeners>
</ext:Store>
<ext:Store ID="DistrictStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshDistricts">
    <AutoLoadParams>
        <ext:Parameter Name="parentId" Value="={0}" />
    </AutoLoadParams>
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="TerId">
            <Fields>
                <ext:RecordField Name="TerId" />
                <ext:RecordField Name="Description" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
    </Listeners>
</ext:Store>
<ext:Window ID="hospitalSearchDlg" runat="server" Icon="Group" Title="<%$ Resources: hospitalSearchDlg.Title %>" Closable="true"
    Draggable="false" Resizable="true" Width="800" Height="480" AutoShow="false"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:ContainerLayout ID="ContainerLayout1" runat="server">
            <ext:Panel ID="plSearch" runat="server" Border="false" Frame="true" Header="false"
                ButtonAlign="Right">
                <Body>
                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                        <ext:LayoutColumn ColumnWidth=".33">
                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                <Body>
                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                        <ext:Anchor>
                                            <ext:TextField ID="txtSearchHospitalName" runat="server" FieldLabel="<%$ Resources:hospitalSearchDlg.txtSearchHospitalName.FieldLabel %>" Width="150" />
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:ComboBox ID="cmbProvince" runat="server" FieldLabel="<%$ Resources:hospitalSearchDlg.cmbProvince.FieldLabel %>" StoreID="ProvincesStore"
                                                Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true" Width="150"
                                                Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources:hospitalSearchDlg.cmbProvince.EmptyText %>" SelectOnFocus="true">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:hospitalSearchDlg.cmbProvince.FieldTrigger.Qtip %>" />
                                                </Triggers>
                                                <Listeners>
                                                    <Select Handler="#{cmbCity}.clearValue(); #{CitiesStore}.reload(); #{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                    <TriggerClick Handler="this.clearValue(); #{cmbCity}.clearValue(); #{CitiesStore}.reload(); #{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                </Listeners>
                                            </ext:ComboBox>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>
                        </ext:LayoutColumn>
                        <ext:LayoutColumn ColumnWidth=".33">
                            <ext:Panel ID="Panel2" runat="server" Border="false">
                                <Body>
                                    <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                        <ext:Anchor>
                                            <ext:ComboBox ID="cmbGrade" runat="server" FieldLabel="<%$ Resources:hospitalSearchDlg.cmbGrade.FieldLabel%>" StoreID="HospitalGradeStore"
                                                Editable="false" DisplayField="Value" ValueField="Key" TypeAhead="true" Mode="Local" Width="150"
                                                ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources:hospitalSearchDlg.cmbGrade.EmptyText%>" ItemSelector="div.list-item"
                                                SelectOnFocus="true">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:hospitalSearchDlg.cmbGrade.FieldTrigger.Qtip%>" />
                                                </Triggers>
                                                <Template ID="Template1" runat="server">
                                                            <tpl for=".">
                                                                <div class="list-item">
                                                                     {Value}
                                                                </div>
                                                            </tpl>
                                                </Template>
                                                <Listeners>
                                                    <TriggerClick Handler="this.clearValue();" />
                                                </Listeners>
                                            </ext:ComboBox>
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:ComboBox ID="cmbCity" runat="server" FieldLabel="<%$ Resources:hospitalSearchDlg.cmbCity.FieldLabel%>" StoreID="CitiesStore" Editable="false"
                                                DisplayField="Description" ValueField="TerId" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                TriggerAction="All" EmptyText="<%$ Resources:hospitalSearchDlg.cmbCity.EmptyText%>" SelectOnFocus="true" Width="150" >
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:hospitalSearchDlg.cmbCity.FieldTrigger.Qtip%>" />
                                                </Triggers>
                                                <Listeners>
                                                    <Select Handler="#{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                    <TriggerClick Handler="this.clearValue(); #{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                </Listeners>
                                            </ext:ComboBox>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>
                        </ext:LayoutColumn>
                        <ext:LayoutColumn ColumnWidth=".33">
                            <ext:Panel ID="Panel3" runat="server" Border="false">
                                <Body>
                                    <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                        <ext:Anchor>
                                            <ext:Panel ID="Panel4" runat="server" Height="25">
                                            </ext:Panel>
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:ComboBox ID="cmbDistrict" runat="server" FieldLabel="<%$ Resources:hospitalSearchDlg.cmbDistrict.FieldLabel%>" StoreID="DistrictStore"
                                                Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true" Width="150"
                                                Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources:hospitalSearchDlg.cmbDistrict.EmptyText%>" SelectOnFocus="true">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:hospitalSearchDlg.cmbDistrict.FieldTrigger.Qtip%>" />
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
                    <ext:Button ID="btnSearch" Text="<%$ Resources:btnSearch.Text%>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                        <Listeners>
                            <Click Handler="#{GridPanel1}.clear();#{GridPanel1}.reload();" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="btnOk" runat="server" Text="<%$ Resources:btnOk.Text%>" Icon="Disk" CommandArgument="" CommandName=""
                        IDMode="Legacy" Enabled="false">
                        <AjaxEvents>
                            <Click OnEvent="SubmitSelection" Success="#{hospitalSearchDlg}.hide(null);">
                                <ExtraParams>
                                    <ext:Parameter Name="Values" Value="Ext.encode(#{GridPanel1}.getRowsValues())" Mode="Raw" />
                                </ExtraParams>
                            </Click>
                        </AjaxEvents>
                    </ext:Button>
                    <ext:Button ID="btnCancel" runat="server" Text="<%$ Resources:btnCancel.Text%>" Icon="Cancel" CommandArgument=""
                        CommandName="" IDMode="Legacy" OnClientClick="">
                        <Listeners>
                            <Click Handler="#{hospitalSearchDlg}.hide(null);" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Panel>
            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Height="300" Header="false">
                <Body>
                    <ext:FitLayout ID="FitLayout1" runat="server">
                        <ext:GridPanel ID="GridPanel1" runat="server" Title="" AutoExpandColumn="HosHospitalName"
                            Header="false" StoreID="HospitalSearchDlgStore" Border="false" Icon="Lorry" StripeRows="true">
                            <ColumnModel ID="ColumnModel1" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="<%$ Resources:GridPanel1.HosHospitalName.Header%>">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosKeyAccount" Header="<%$ Resources:GridPanel1.HosKeyAccount.Header%>">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosGrade" Header="<%$ Resources:GridPanel1.HosGrade.Header%>">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosProvince" Header="<%$ Resources:GridPanel1.HosProvince.Header%>">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosCity" Header="<%$ Resources:GridPanel1.HosCity.Header%>">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosDistrict" Header="<%$ Resources:GridPanel1.HosDistrict.Header%>">
                                    </ext:Column>
                                </Columns>
                            </ColumnModel>
                            <Plugins>
                                <ext:GridFilters runat="server" ID="GridFilters1" Local="true">
                                    <Filters>
                                        <ext:StringFilter DataIndex="HosHospitalName" />
                                        <ext:StringFilter DataIndex="HosKeyAccount" />
                                        <ext:StringFilter DataIndex="HosGrade" />
                                        <ext:StringFilter DataIndex="HosProvince" />
                                        <ext:StringFilter DataIndex="HosCity" />
                                        <ext:StringFilter DataIndex="HosDistrict" />
                                    </Filters>
                                </ext:GridFilters>
                            </Plugins>
                            <SelectionModel>
                                <ext:CheckboxSelectionModel ID="RowSelectionModel1" runat="server">
                                    <Listeners>
                                        <RowSelect Handler="#{btnOk}.enable();" />
                                    </Listeners>
                                </ext:CheckboxSelectionModel>
                            </SelectionModel>
                            <BottomBar>
                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="HospitalSearchDlgStore" />
                            </BottomBar>
                            <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel1.LoadMask.Msg%>" />
                        </ext:GridPanel>
                    </ext:FitLayout>
                </Body>
            </ext:Panel>
        </ext:ContainerLayout>
    </Body>
    
</ext:Window>
<ext:Hidden ID="hiddenSelectedProductLine" runat="server" />