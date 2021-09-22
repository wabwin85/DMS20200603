<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HospitalSelectorDialog.ascx.cs"
    Inherits="DMS.Website.Controls.HospitalSelectorDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">

    var openHospitalSelectorDlg = function (animTrg) {
        var window = <%= hospitalSelectorDlg.ClientID %>;
        <%=hiddenSelectedProductLine.ClientID %>.setValue(animTrg);
        window.show();
    }
    
    var clearHospitalSelectorDlg = function(){
        Ext.getCmp('<%=this.cmbProvince.ClientID%>').clearValue();
        Ext.getCmp('<%=this.cmbCity.ClientID%>').clearValue();
        Ext.getCmp('<%=this.cmbDistrict.ClientID%>').clearValue();
        Ext.getCmp('<%=this.txtHospital.ClientID%>').setValue("");
        Ext.getCmp('<%=this.gplHospitalSelector.ClientID%>').clear();
    }    
    
</script>

<ext:Store ID="HospitalSelectStore" runat="server" UseIdConfirmation="false" OnRefreshData="HospitalStore_RefershData"
    AutoLoad="false">
    <Reader>
        <ext:JsonReader ReaderID="Key">
            <Fields>
                <ext:RecordField Name="Key" />
                <ext:RecordField Name="Value" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <LoadException Handler="Ext.Msg.alert('<%$ Resources: Msg.LoadException %>', e.message || e )" />
    </Listeners>
</ext:Store>
<%--
<ext:Store ID="HospitalDisSelectStore" runat="server" UseIdConfirmation="false" OnRefreshData="HospitalStore_RefershData"
    AutoLoad="false">
    <Reader>
        <ext:JsonReader ReaderID="Key">
            <Fields>
                <ext:RecordField Name="Key" />
                <ext:RecordField Name="Value" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
    </Listeners>
</ext:Store>
 --%>
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
<ext:Window ID="hospitalSelectorDlg" runat="server" Icon="Group" Title="<%$ Resources: hospitalSelectorDlg.Title %>"
    Closable="true" Draggable="false" Resizable="true" Width="900" Height="490" AutoShow="false"
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
                                    <ext:FormLayout ID="FormLayout1" runat="server">
                                        <ext:Anchor Horizontal="98%">
                                            <ext:ComboBox ID="cmbProvince" runat="server" FieldLabel="<%$ Resources: hospitalSelectorDlg.cmbProvince.FieldLabel %>"
                                                StoreID="ProvincesStore" Editable="false" DisplayField="Description" ValueField="TerId"
                                                TypeAhead="true" Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: hospitalSelectorDlg.cmbProvince.EmptyText %>"
                                                SelectOnFocus="true">
                                                <Listeners>
                                                    <Select Handler="#{cmbCity}.clearValue();#{cmbDistrict}.clearValue(); #{CitiesStore}.reload(); #{gplHospitalSelector}.reload();" />
                                                    <TriggerClick Handler="this.clearValue();#{cmbCity}.clearValue();#{cmbDistrict}.clearValue();#{gplHospitalSelector}.reload();" />
                                                </Listeners>
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: hospitalSelectorDlg.cmbProvince.FieldTrigger.Qtip %>" />
                                                </Triggers>
                                            </ext:ComboBox>
                                        </ext:Anchor>
                                        <ext:Anchor Horizontal="98%">
                                            <ext:TextField ID="txtHospital" runat="server" FieldLabel="<%$ Resources: hospitalSelectorDlg.txtHospital.FieldLabel %>">
                                                <Listeners>
                                                    <Change Handler="#{gplHospitalSelector}.reload();" />
                                                </Listeners>
                                            </ext:TextField>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>
                        </ext:LayoutColumn>
                        <ext:LayoutColumn ColumnWidth=".33">
                            <ext:Panel ID="Panel2" runat="server" Border="false">
                                <Body>
                                    <ext:FormLayout ID="FormLayout2" runat="server">
                                        <ext:Anchor Horizontal="98%">
                                            <ext:ComboBox ID="cmbCity" runat="server" FieldLabel="<%$ Resources:hospitalSelectorDlg.cmbCity.FieldLabel %>"
                                                StoreID="CitiesStore" Editable="false" DisplayField="Description" ValueField="TerId"
                                                TypeAhead="true" Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources:hospitalSelectorDlg.cmbCity.EmptyText%>"
                                                SelectOnFocus="true">
                                                <Listeners>
                                                    <Select Handler="#{cmbDistrict}.clearValue(); #{DistrictStore}.reload(); #{gplHospitalSelector}.reload();" />
                                                    <TriggerClick Handler="this.clearValue();#{cmbDistrict}.clearValue();#{gplHospitalSelector}.reload();" />
                                                </Listeners>
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:hospitalSelectorDlg.cmbCity.FieldTrigger.Qtip%>" />
                                                </Triggers>
                                            </ext:ComboBox>
                                        </ext:Anchor>
                                       <%-- <ext:Anchor Horizontal="98%">
                                            <ext:TextField ID="txtDept" runat="server" FieldLabel="<%$ Resources:hospitalSelectorDlg.txtDept.FieldLabel%>" EmptyText="<%$ Resources:hospitalSelectorDlg.Empty.txtDept.FieldLabel%>">
                                            </ext:TextField>
                                        </ext:Anchor>--%>
                                        <ext:Anchor>
                                            <ext:Button ID="btnQuery" runat="server" Text="查询" Visible="false">
                                                <AjaxEvents>
                                                    <Click OnEvent="BtnQuery_Clicked">
                                                    </Click>
                                                </AjaxEvents>
                                            </ext:Button>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>
                        </ext:LayoutColumn>
                        <ext:LayoutColumn ColumnWidth=".33">
                            <ext:Panel ID="Panel3" runat="server" Border="false">
                                <Body>
                                    <ext:FormLayout ID="FormLayout3" runat="server">
                                        <ext:Anchor Horizontal="98%">
                                            <ext:ComboBox ID="cmbDistrict" runat="server" FieldLabel="<%$ Resources:hospitalSelectorDlg.cmbDistrict.FieldLabel%>"
                                                StoreID="DistrictStore" Editable="false" DisplayField="Description" ValueField="TerId"
                                                TypeAhead="true" Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources:hospitalSelectorDlg.cmbDistrict.EmptyText%>"
                                                SelectOnFocus="true">
                                                <Listeners>
                                                    <Select Handler=" #{gplHospitalSelector}.reload();" />
                                                    <TriggerClick Handler="this.clearValue(); #{gplHospitalSelector}.reload();" />
                                                </Listeners>
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:hospitalSelectorDlg.cmbDistrict.FieldTrigger.Qtip%>" />
                                                </Triggers>
                                            </ext:ComboBox>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>
                        </ext:LayoutColumn>
                    </ext:ColumnLayout>
                </Body>
            </ext:Panel>
            <ext:Panel runat="server" ID="ctl46" Frame="true" Height="360" Header="false">
                <Body>
                    <ext:ColumnLayout ID="ColumnLayout2" runat="server" FitHeight="true">
                        <ext:LayoutColumn ColumnWidth="1">
                            <ext:GridPanel ID="gplHospitalSelector" runat="server" Title="" AutoExpandColumn="Value"
                                Header="false" StoreID="HospitalSelectStore" Border="false" Icon="Lorry" StripeRows="true">
                                <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="Value" Header="<%$ Resources:gplHospitalSelector.ColumnID.Header%>"
                                            DataIndex="Value" Sortable="true">
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
                                <LoadMask ShowMask="true" Msg="<%$ Resources:gplHospitalSelector.LoadMask.Msg%>" />
                            </ext:GridPanel>
                        </ext:LayoutColumn>
                        <%-- 
                        <ext:LayoutColumn>
                            <ext:Panel ID="Panel4" runat="server" Width="35" BodyStyle="background-color: transparent;"
                                Border="false">
                                <Body>
                                </Body>
                            </ext:Panel>
                        </ext:LayoutColumn>
                        <ext:LayoutColumn ColumnWidth="0.5">
                            <ext:GridPanel runat="server" ID="gplHospitalDisSelector" EnableDragDrop="false" AutoExpandColumn="Value"
                                StoreID="HospitalDisSelectStore">
                                <Listeners>
                                </Listeners>
                                <ColumnModel ID="ColumnModel3" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="Value" Header="不包含" DataIndex="Value" Sortable="true">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server" HideCheckAll="true" />
                                </SelectionModel>
                            </ext:GridPanel>
                        </ext:LayoutColumn>
                        --%>
                    </ext:ColumnLayout>
                </Body>
            </ext:Panel>
        </ext:ContainerLayout>
    </Body>
    <Buttons>
        <ext:Button ID="btnOk" runat="server" Text="<%$ Resources:btnOk.Text %>" Icon="Disk"
            CommandArgument="" CommandName="" IDMode="Legacy" Enabled="false">
            <AjaxEvents>
                <Click OnEvent="SubmitSelection" Success="#{hospitalSelectorDlg}.hide(null);">
                    <ExtraParams>
                        <ext:Parameter Name="SelectValues" Value="Ext.encode(#{gplHospitalSelector}.getRowsValues())"
                            Mode="Raw" />
                        <%--<ext:Parameter Name="DisSelectValues" Value="Ext.encode(#{gplHospitalDisSelector}.getRowsValues())" Mode="Raw" /> --%>
                    </ExtraParams>
                </Click>
            </AjaxEvents>
        </ext:Button>
        <ext:Button ID="btnCancel" runat="server" Text="<%$ Resources:btnCancel.Text %>"
            Icon="Cancel" CommandArgument="" CommandName="" IDMode="Legacy" OnClientClick="">
            <Listeners>
                <Click Handler="#{hospitalSelectorDlg}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
<ext:Hidden ID="hiddenSelectedProductLine" runat="server" />
