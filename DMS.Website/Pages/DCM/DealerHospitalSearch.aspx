<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerHospitalSearch.aspx.cs" Inherits="DMS.Website.Pages.DCM.DealerHospitalSearch" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>

<%@ Register Src="../../Controls/HospitalEditor.ascx" TagName="HospitalEditor" TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title></title>
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
    </style>

    <script type="text/javascript">
        var MsgList = {
			Store1:{
				LoadExceptionTitle:"<%=GetLocalResourceObject("Store1.LoadException.Alert.Title").ToString()%>",
				CommitFailedTitle:"<%=GetLocalResourceObject("Store1.CommitFailed.Alert.Title").ToString()%>",
				CommitFailedMsg:"<%=GetLocalResourceObject("Store1.CommitFailed.Alert.Body").ToString()%>",
				SaveExceptionTitle:"<%=GetLocalResourceObject("Store1.SaveException.Alert.Title").ToString()%>",
				CommitDoneTitle:"<%=GetLocalResourceObject("Store1.CommitDone.Alert.Title").ToString()%>",
				CommitDoneMsg:"<%=GetLocalResourceObject("Store1.CommitDone.Alert.Body").ToString()%>"
			}
        }

        var hospitalDetailsRender = function() {
            return '<img class="imgEdit" ext:qtip="Click to view/edit additional details" style="cursor:pointer;" src="../../resources/images/icons/vcard_edit.png" />';
        }

        var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

            if (t.className == 'imgEdit' && columnId == 'Details') {
                SearchHospitalDetails(record, t, test,"ReadOnly");

            }
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <ext:ScriptManager ID="ScriptManager1" runat="server">
            </ext:ScriptManager>
            <ext:JsonStore ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="Store1_RefershData"
              AutoLoad="false">
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
                <LoadException Handler="Ext.Msg.alert(MsgList.Store1.LoadExceptionTitle, e.message || e )" />
                <CommitFailed Handler="Ext.Msg.alert(MsgList.Store1.CommitFailedTitle, MsgList.Store1.CommitFailedMsg + msg)" />
                <SaveException Handler="Ext.Msg.alert(MsgList.Store1.SaveExceptionTitle, e.message || e)" />
                <CommitDone Handler="Ext.Msg.alert(MsgList.Store1.CommitDoneTitle, MsgList.Store1.CommitDoneMsg);" />
            </Listeners>
        </ext:JsonStore>
        <ext:Store ID="Store2" runat="server" UseIdConfirmation="true" OnRefreshData="Store_HospitalGrade">
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
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>" Frame="true" AutoHeight="true"
                        Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtSearchHospitalName" runat="server" FieldLabel="<%$ Resources: plSearch.Panel1.txtSearchHospitalName.FieldLabel %>" Width="150" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cmbProvince" runat="server" FieldLabel="<%$ Resources: plSearch.Panel1.cmbProvince.FieldLabel %>" StoreID="ProvincesStore"
                                                            Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true"
                                                            Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: plSearch.Panel1.cmbProvince.EmptyText %>" SelectOnFocus="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.Panel1.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();#{cmbCity}.clearValue(); #{CitiesStore}.reload();#{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                                <Select Handler="#{cmbCity}.clearValue(); #{CitiesStore}.reload();#{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cmbGrade" runat="server" FieldLabel="<%$ Resources: plSearch.Panel2.cmbGrade.FieldLabel %>" StoreID="Store2" Editable="false"
                                                            DisplayField="Value" ValueField="Key" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                            TriggerAction="All" EmptyText="<%$ Resources: plSearch.Panel2.cmbGrade.EmptyText %>" ItemSelector="div.list-item" SelectOnFocus="true">
                                                            <Template ID="Template1" runat="server">
                                                            <tpl for=".">
                                                                <div class="list-item">
                                                                     {Value}
                                                                </div>
                                                            </tpl>
                                                            </Template>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.Panel2.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cmbCity" runat="server" FieldLabel="<%$ Resources: plSearch.Panel2.cmbCity.FieldLabel %>" StoreID="CitiesStore" Editable="false"
                                                            DisplayField="Description" ValueField="TerId" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                            TriggerAction="All" EmptyText="<%$ Resources: plSearch.Panel2.cmbCity.EmptyText %>" SelectOnFocus="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.Panel2.cmbCity.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <Select Handler="#{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                                <TriggerClick Handler="this.clearValue();#{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtSearchDirector" runat="server" FieldLabel="<%$ Resources: plSearch.Panel3.txtSearchDirector.FieldLabel %>" Width="150" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cmbDistrict" runat="server" FieldLabel="<%$ Resources: plSearch.Panel3.cmbDistrict.FieldLabel %>" StoreID="DistrictStore"
                                                            Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true"
                                                            Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: plSearch.Panel3.cmbDistrict.EmptyText %>" SelectOnFocus="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.Panel3.FieldTrigger.Qtip %>" />
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
                                        <Click Handler="#{GridPanel1}.reload();" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" AutoExpandColumn="HosHospitalName"
                                        StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
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
                                                <ext:Column DataIndex="HosDirector" Header="<%$ Resources: GridPanel1.HosDirector.Header %>">
                                                </ext:Column>
                                                <ext:Column DataIndex="HosDirectorContact" Header="<%$ Resources: GridPanel1.HosDirectorContact.Header %>">
                                                </ext:Column>
                                                <ext:Column DataIndex="HosLastModifiedDate" Header="<%$ Resources: GridPanel1.HosLastModifiedDate.Header %>">
                                                    <Renderer  Fn="Ext.util.Format.dateRenderer('m/d/Y h:i')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Details" Header="<%$ Resources: GridPanel1.Details.Header %>" Width="50" Align="Center" Fixed="true"
                                                    MenuDisabled="true" Resizable="false">
                                                    <Renderer Fn="hospitalDetailsRender" />
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
        <uc1:HospitalEditor ID="HospitalEditor1" runat="server" />
        </div>
    </form>
</body>
</html>
