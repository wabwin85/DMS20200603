<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HospitalEditor.ascx.cs"
    Inherits="DMS.Website.Controls.HospitalEditor" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    var employeeRecord;
    var grid =null ;
    
        var createHospitalDetails = function (record, mygrid, animTrg, flag) {
        <%= flag.ClientID %>.setValue(flag);
        employeeRecord = record;
        grid = mygrid;
        
        var window = <%= HospitalDetailsWindow.ClientID %>;
        //window.setTitle(String.format('Details: {0}',"Create New Hospital"));
     
        //<%= HosId1.ClientID %>.setValue(record.id);
        //alert(employeeRecord.data.HosLastModifiedDate);
        window.show(animTrg);
    }
    
    var SearchHospitalDetails = function(record, animTrg, flag, status)
    {
        <%=SaveButton.ClientID %>.hide();
        
        <%=HosHospitalName.ClientID %>.setReadOnly(true);
        <%=HosHospitalShortName.ClientID %>.setReadOnly(true);
        <%=cmbProvince.ClientID %>.setDisabled(true);
        <%=cmbDistrict.ClientID %>.setReadOnly(true);
        <%=HosAddress.ClientID %>.setReadOnly(true);
        <%=HosDirector.ClientID %>.setReadOnly(true);
        <%=HosChiefEquipment.ClientID %>.setReadOnly(true);
        <%=HosWebsite.ClientID %>.setReadOnly(true);
        
        <%=cmbHosGrade.ClientID %>.setDisabled(true);
        <%=HosKeyAccount.ClientID %>.setReadOnly(true);
        <%=cmbCity.ClientID %>.setReadOnly(true);
        <%=HosPhone.ClientID %>.setReadOnly(true);
        <%=HosPostalCode.ClientID %>.setReadOnly(true);
        <%=HosDirectorContact.ClientID %>.setReadOnly(true);
        <%=HosChiefEquipmentContact.ClientID %>.setReadOnly(true);        
        
        
        openHospitalDetails(record, animTrg, flag);
    }
    
    
    var openHospitalDetails = function (record, animTrg, flag) {
        <%= flag.ClientID %>.setValue(flag);
        employeeRecord = record;
        var window = <%= HospitalDetailsWindow.ClientID %>;
        //window.setTitle(String.format('Details: {0}',record.data['HosHospitalShortName']));
        //alert(record.data.HosId);
        <%= HosId1.ClientID %>.setValue(record.data.HosId);
     
        //Company        
        
        <%= HosHospitalName.ClientID %>.setValue(record.data['HosHospitalName']);
        <%= HosHospitalShortName.ClientID %>.setValue(record.data['HosHospitalShortName']);
        <%= cmbHosGrade.ClientID %>.setValue(record.data['HosGrade']);
        <%= HosKeyAccount.ClientID %>.setValue(record.data['HosKeyAccount']);

        <%= cmbProvince.ClientID %>.setValue(record.data['HosProvince']);
        <%= cmbCity.ClientID %>.setValue(record.data['HosCity']);
        <%= cmbDistrict.ClientID %>.setValue(record.data['HosDistrict']);
        <%= HosAddress.ClientID %>.setValue(record.data['HosAddress']);
        <%= HosPostalCode.ClientID %>.setValue(record.data['HosPostalCode']);
        <%= HosPhone.ClientID %>.setValue(record.data['HosPhone']);

        <%= HosWebsite.ClientID %>.setValue(record.data['HosWebsite']);
        <%= HosChiefEquipment.ClientID %>.setValue(record.data['HosChiefEquipment']);
        <%= HosChiefEquipmentContact.ClientID %>.setValue(record.data['HosChiefEquipmentContact']);
        <%= HosDirector.ClientID %>.setValue(record.data['HosDirector']);
        <%= HosDirectorContact.ClientID %>.setValue(record.data['HosDirectorContact']);

        window.show(animTrg);
    }
    
    var saveHospital = function () {
    
        if (<%= HosHospitalName.ClientID %>.getValue() =="" || <%= cmbProvince.ClientID %>.getValue()=="" || <%= cmbCity.ClientID %>.getValue()=="" || <%= cmbDistrict.ClientID %>.getValue()=="")
        {
            alert('<%=GetLocalResourceObject("saveHospital.alert").ToString()%>');
            return;
        }
        
        
        
        if( grid !=null)
            employeeRecord.set('HosId',<%= HosId1.ClientID %>.getValue());
     
        
        employeeRecord.set('HosHospitalName',<%= HosHospitalName.ClientID %>.getValue());
        employeeRecord.set('HosHospitalShortName',<%= HosHospitalShortName.ClientID %>.getValue());
        
        
        
        employeeRecord.set('HosKeyAccount',<%= HosKeyAccount.ClientID %>.getValue());
        
         var selText = <%= cmbProvince.ClientID %>.getText();
         if(selText !='<%=GetLocalResourceObject("cmbProvince.getText.selText").ToString()%>')
            employeeRecord.set('HosProvince',selText);
         
         selText = <%= cmbCity.ClientID %>.getText();
        if(selText !='<%=GetLocalResourceObject("cmbCity.getText.selText").ToString()%>') 
            employeeRecord.set('HosCity',selText);
            
          selText = <%= cmbDistrict.ClientID %>.getText();
          if(selText !='<%=GetLocalResourceObject("cmbDistrict.getText.selText").ToString()%>') 
            employeeRecord.set('HosDistrict',selText);
            
            
          selText = <%= cmbHosGrade.ClientID %>.getText();
           if(selText !='<%=GetLocalResourceObject("cmbHosGrade.getText.selText").ToString()%>') 
            employeeRecord.set('HosGrade',selText);

         employeeRecord.set('HosAddress',<%= HosAddress.ClientID %>.getValue());
         employeeRecord.set('HosPostalCode',<%= HosPostalCode.ClientID %>.getValue());
         employeeRecord.set('HosPhone',<%= HosPhone.ClientID %>.getValue());
        
         employeeRecord.set('HosWebsite',<%= HosWebsite.ClientID %>.getValue());
         employeeRecord.set('HosChiefEquipment',<%= HosChiefEquipment.ClientID %>.getValue());
         employeeRecord.set('HosChiefEquipmentContact',<%= HosChiefEquipmentContact.ClientID %>.getValue());
         employeeRecord.set('HosDirector',<%= HosDirector.ClientID %>.getValue());
         employeeRecord.set('HosDirectorContact',<%= HosDirectorContact.ClientID %>.getValue());
        
        <%= HospitalDetailsWindow.ClientID %>.hide(null);
                  
    }
    
    var cancelHospital =function()
    {
        if(grid != null )
        {
           var gd = Ext.getCmp(grid) ;
           if(gd != null && <%= flag.ClientID %>.value != "1")
              gd.deleteRecord(employeeRecord)
        }   
        <%= HospitalDetailsWindow.ClientID %>.hide(null);
        
        <%= HosHospitalName.ClientID %>.setValue(null);
        <%= HosHospitalShortName.ClientID %>.setValue(null);
        <%= cmbHosGrade.ClientID %>.setValue(null);
        <%= HosKeyAccount.ClientID %>.setValue(null);
        <%= HosPhone.ClientID %>.setValue(null);
        

        <%= cmbProvince.ClientID %>.setValue(null);
        <%= cmbCity.ClientID %>.setValue(null);
        <%= cmbDistrict.ClientID %>.setValue(null);
        <%= HosPostalCode.ClientID %>.setValue(null);
        <%= HosAddress.ClientID %>.setValue(null);

        <%= HosWebsite.ClientID %>.setValue(null);
        <%= HosChiefEquipment.ClientID %>.setValue(null);
        <%= HosChiefEquipmentContact.ClientID %>.setValue(null);
        <%= HosDirector.ClientID %>.setValue(null);
        <%= HosDirectorContact.ClientID %>.setValue(null);
    }
    
    var HosName = function()
    {
        alert(<%= HosHospitalName.ClientID %>.value);
    }
    
</script>

<ext:Store ID="HospitalsStore" runat="server" AutoLoad="true">
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
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
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
<ext:Window ID="HospitalDetailsWindow" runat="server" Icon="Group" Title="<%$ Resources: HospitalDetailsWindow.Title %>" Closable="false" Draggable="false"  Resizable="false" 
    Width="750" Height="350" AutoShow="false" Modal="true" ShowOnLoad="false"  BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout4" runat="server">
            <ext:Anchor>
                <ext:TextField ID="HosId1" Hidden="true" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosId1.FieldLabel %>" Width="250" Disabled="true" />
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="flag" Hidden="true"  runat="server"  />
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="Panel1" runat="server" FormGroup="true" AutoHeight="true"  BodyStyle="background-color: transparent;">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                            <ext:LayoutColumn ColumnWidth="0.5">
                                <ext:Panel ID="Panel2" runat="server" BodyBorder="false" Header="false"  BodyStyle="background-color: transparent;">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout11" runat="server">
                                            <ext:Anchor>
                                                <ext:TextField ID="HosHospitalName" AllowBlank="false" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosHospitalName.FieldLabel %>" Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="HosHospitalShortName" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosHospitalShortName.FieldLabel %>" Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cmbProvince" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.cmbProvince.FieldLabel %>" StoreID="ProvincesStore"
                                                    Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true"
                                                    Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: HospitalDetailsWindow.cmbProvince.EmptyText %>" SelectOnFocus="true"
                                                    Width="250" AllowBlank="false">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: HospitalDetailsWindow.cmbProvince.FieldTrigger.Qtip %>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <Select Handler="#{cmbCity}.clearValue(); #{CitiesStore}.reload(); #{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                        <TriggerClick Handler="this.clearValue(); #{cmbCity}.clearValue(); #{CitiesStore}.reload(); #{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cmbDistrict" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.cmbDistrict.FieldLabel %>" StoreID="DistrictStore"
                                                    Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true" 
                                                    Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: HospitalDetailsWindow.cmbDistrict.EmptyText %>" Width="250"
                                                    SelectOnFocus="true" AllowBlank="false">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: HospitalDetailsWindow.cmbDistrict.FieldTrigger.Qtip %>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="HosAddress" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosAddress.FieldLabel %>" Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="HosDirector" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosDirector.FieldLabel %>" Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="HosChiefEquipment" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosChiefEquipment.FieldLabel %>" Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="HosWebsite" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosWebsite.FieldLabel %>" Width="250" Vtype="" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth="0.5">
                                <ext:Panel ID="Panel4" runat="server" BodyBorder="false" Header="false"  BodyStyle="background-color: transparent;">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout21" runat="server">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cmbHosGrade" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.cmbHosGrade.FieldLabel %>" StoreID="Store2" Editable="false"
                                                    DisplayField="Value" ValueField="Key" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                    TriggerAction="All" EmptyText="<%$ Resources: HospitalDetailsWindow.cmbHosGrade.EmptyText %>" ItemSelector="div.list-item" SelectOnFocus="true"
                                                    Width="200">
                                                    <Template ID="Template2" runat="server">
                                                            <tpl for=".">
                                                                <div class="list-item">
                                                                     {Value}
                                                                </div>
                                                            </tpl>
                                                    </Template>
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: HospitalDetailsWindow.cmbHosGrade.FieldTrigger.Qtip %>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="HosKeyAccount" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosKeyAccount.FieldLabel %>" Width="200" Enabled="false" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cmbCity" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.cmbCity.FieldLabel %>" StoreID="CitiesStore" Editable="false"
                                                    DisplayField="Description" ValueField="TerId" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                    TriggerAction="All" EmptyText="<%$ Resources: HospitalDetailsWindow.cmbCity.EmptyText %>" SelectOnFocus="true" Width="200" AllowBlank="false">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: HospitalDetailsWindow.cmbCity.FieldTrigger.Qtip %>" />
                                                    </Triggers>                                                   
                                                    <Listeners>
                                                        <Select Handler="#{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                        <TriggerClick Handler="this.clearValue(); #{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="HosPhone" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosPhone.FieldLabel %>" Width="200" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="HosPostalCode" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosPostalCode.FieldLabel %>" Width="200" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="HosDirectorContact" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosDirectorContact.FieldLabel %>" Width="200" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="HosChiefEquipmentContact" runat="server" FieldLabel="<%$ Resources: HospitalDetailsWindow.HosChiefEquipmentContact.FieldLabel %>" Width="200" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                </ext:Panel>
            </ext:Anchor>
        </ext:FormLayout>
    </Body>
    <Buttons>
        <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: SaveButton.Text %>" Icon="Disk">
            <Listeners>
                <Click Handler="saveHospital();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources: CancelButton.Text %>" Icon="Cancel">
            <Listeners>
                <Click Handler="cancelHospital();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
