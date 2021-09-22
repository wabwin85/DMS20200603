<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HospitalSelectdDelDialog.ascx.cs" Inherits="DMS.Website.Controls.HospitalSelectdDelDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    //var employeeRecord;
   
    var openHospitalSelectdDelDlg = function (animTrg) {
        var window = <%= hospitalSelectedDlg.ClientID %>;
       
        <%=hiddenSelectedId.ClientID %>.setValue(animTrg);
        <%= GridPanel1.ClientID %>.clear();
        window.show(null);
    }

   var DelConfirm=function(){
        var result = confirm('<%=GetLocalResourceObject("btnOk.Click.Handler").ToString()%>'); 
        var grid = Ext.getCmp('<%= GridPanel1.ClientID %>');
        if ( result && grid.hasSelection()) 
        { 
            grid.deleteSelected(); 
            grid.save();
        }
   }
</script>

<ext:Store ID="HospitalSearchDlgStore" runat="server" UseIdConfirmation="false" OnRefreshData="HospitalStore_RefershData"
    OnBeforeStoreChanged="HospitalStore_BeforeStoreChanged" AutoLoad="false" >
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
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <LoadException Handler="Ext.Msg.alert('<%$ Resources: Msg.LoadException %>', e.message || e )" />
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
<ext:Window ID="hospitalSelectedDlg" runat="server" Icon="Group" Title="<%$ Resources: hospitalSelectedDlg.Title %>" Closable="true"
    Draggable="false" Resizable="true" Width="900" Height="480" AutoShow="false"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" >
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
                                            <ext:ComboBox ID="cmbProvince" runat="server" FieldLabel="<%$ Resources: hospitalSelectedDlg.cmbProvince.FieldLabel %>" StoreID="ProvincesStore"
                                                Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true"
                                                Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: hospitalSelectedDlg.cmbProvince.EmptyText %>" SelectOnFocus="true">
                                                <Listeners>
                                                    <Select Handler="#{cmbCity}.clearValue(); #{CitiesStore}.reload();" />
                                                    <TriggerClick Handler="this.clearValue();#{cmbCity}.clearValue();#{cmbDistrict}.clearValue();" />
                                                </Listeners>
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: hospitalSelectedDlg.cmbProvince.FieldTrigger.Qtip %>" />
                                                </Triggers>
                                            </ext:ComboBox>
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:TextField ID="txtSearchHospitalName" runat="server" FieldLabel="<%$ Resources: hospitalSelectedDlg.txtSearchHospitalName.FieldLabel %>" Width="150" />
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
                                            <ext:ComboBox ID="cmbCity" runat="server" FieldLabel="<%$ Resources: hospitalSelectedDlg.cmbCity.FieldLabel %>" StoreID="CitiesStore" Editable="false"
                                                DisplayField="Description" ValueField="TerId" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                TriggerAction="All" EmptyText="<%$ Resources: hospitalSelectedDlg.cmbCity.EmptyText %>" SelectOnFocus="true">
                                                <Listeners>
                                                    <Select Handler="#{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                    <TriggerClick Handler="this.clearValue();#{cmbDistrict}.clearValue();" />
                                                </Listeners>
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: hospitalSelectedDlg.cmbCity.FieldTrigger.Qtip %>" />
                                                </Triggers>
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
                                            <ext:ComboBox ID="cmbDistrict" runat="server" FieldLabel="<%$ Resources: hospitalSelectedDlg.cmbDistrict.FieldLabel %>" StoreID="DistrictStore"
                                                Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true"
                                                Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: hospitalSelectedDlg.cmbDistrict.EmptyText %>" SelectOnFocus="true">
                                                <Listeners>
                                                    <TriggerClick Handler="this.clearValue();" />
                                                </Listeners>
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: hospitalSelectedDlg.cmbDistrict.FieldTrigger.Qtip %>" />
                                                </Triggers>
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
                    <ext:Button ID="btnOk" runat="server" Text="<%$ Resources: btnOk.Text %>" Icon="Delete" CommandArgument="" CommandName=""
                        IDMode="Legacy" Enabled="false">
                        <Listeners>
                            <Click Fn="DelConfirm" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="btnCancel" runat="server" Text="<%$ Resources: btnCancel.Text %>" Icon="Cancel" CommandArgument=""
                        CommandName="" IDMode="Legacy" OnClientClick="">
                        <AjaxEvents>
                            <Click OnEvent="SubmitSelection" Success="#{hospitalSelectedDlg}.hide(null);">
                            </Click>
                        </AjaxEvents>
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
                                    <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="<%$ Resources: GridPanel1.HosHospitalName.Header %>">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosKeyAccount" Header="<%$ Resources: GridPanel1.HosKeyAccount.Header %>">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosGrade" Header="<%$ Resources: GridPanel1.HosGrade.Header %>">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosProvince" Header="<%$ Resources: GridPanel1.HosProvince.Header %>">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosCity" Header="<%$ Resources: GridPanel1.HosCity.Header %>">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosDistrict" Header="<%$ Resources: GridPanel1.HosDistrict.Header %>">
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
                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="HospitalSearchDlgStore" />
                            </BottomBar>
                            <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                        </ext:GridPanel>
                    </ext:FitLayout>
                </Body>
            </ext:Panel>
        </ext:ContainerLayout>
    </Body>
    <AjaxEvents>
        <Hide OnEvent="SubmitSelection"></Hide>
    </AjaxEvents>
</ext:Window>
<ext:Hidden ID="hiddenSelectedId" runat="server" />