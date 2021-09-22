<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CFNEditor.ascx.cs" Inherits="DMS.Website.Controls.CFNEditor" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    var employeeRecord;
    var grid =null ;
            
        var createCFNDetails = function (record, mygrid, animTrg, flag) {
          
        employeeRecord = record;
        grid = mygrid;
        
        var window = <%= CFNDetailsWindow.ClientID %>;
        //window.setTitle(String.format('Details: {0}',"Create New Hospital"));
        
        <%= Id1.ClientID %>.setValue('');
        <%= flag.ClientID %>.setValue('');
        <%= ProductCatagoryPctId.ClientID %>.setValue('');
        <%= ProductLineBumId.ClientID %>.setValue('');
        //Company        
        
        <%= CustomerFaceNbr.ClientID %>.setValue('');
        <%= EnglishName.ClientID %>.setValue('');
        <%= ChineseName.ClientID %>.setValue('');
        <%= Description.ClientID %>.setValue('');
        
        <%= rbImplantTrue.ClientID %>.setValue(false);
        <%= rbImplantFalse.ClientID %>.setValue(true);

        <%= rbToolTrue.ClientID %>.setValue(false);
        <%= rbToolFalse.ClientID %>.setValue(true);

        <%= rbShareTrue.ClientID %>.setValue(false);
        <%= rbShareFalse.ClientID %>.setValue(true);
    
        <%= PCTName.ClientID %>.setValue('');
        <%= PCTEnglishName.ClientID %>.setValue('');
        <%= ProductLineName.ClientID %>.setValue('');
        
        //产品属性
        <%= Property1.ClientID %>.setValue('');
        <%= Property2.ClientID %>.setValue('');
        <%= Property3.ClientID %>.setValue('');
        <%= Property4.ClientID %>.setValue('');
        <%= Property5.ClientID %>.setValue('');
        <%= Property6.ClientID %>.setValue('');
        <%= Property7.ClientID %>.setValue('');
        <%= Property8.ClientID %>.setValue(''); 
        
        //alert(record.data.Id);
        <%= Id1.ClientID %>.setValue(record.id);
        <%= flag.ClientID %>.setValue(flag);
        window.show(animTrg);
    }
    
    var SearchCFNDetails = function(record, animTrg, flag, status)
    {
        <%=SaveButton.ClientID %>.hide();
        
        <%=CustomerFaceNbr.ClientID %>.setReadOnly(true);
        <%=EnglishName.ClientID %>.setReadOnly(true);
        <%=ChineseName.ClientID %>.setReadOnly(true);
        <%=rbImplant.ClientID %>.setDisabled(true);
        <%=rbTool.ClientID %>.setDisabled(true);
        <%=rbShare.ClientID %>.setDisabled(true);
        <%=Description.ClientID %>.setReadOnly(true);
        
        <%=Property1.ClientID %>.setReadOnly(true);
        <%=Property2.ClientID %>.setReadOnly(true);
        <%=Property3.ClientID %>.setReadOnly(true);
        <%=Property4.ClientID %>.setReadOnly(true);
        <%=Property5.ClientID %>.setReadOnly(true);
        <%=Property6.ClientID %>.setReadOnly(true);
        <%=Property7.ClientID %>.setReadOnly(true);  
        <%=Property8.ClientID %>.setReadOnly(true);  
        
        openCFNDetails(record, animTrg, flag);
    }
    
    var openCFNDetails = function (record, animTrg, flag) {
        <%= flag.ClientID %>.setValue(flag);
        employeeRecord = record;
        var window = <%= CFNDetailsWindow.ClientID %>;
        //window.setTitle(String.format('Details: {0}',record.data['HosHospitalShortName']));
        //alert(record.data.Id);
        <%= Id1.ClientID %>.setValue(record.data.Id);
        <%= ProductCatagoryPctId.ClientID %>.setValue(record.data['ProductCatagoryPctId']);
        <%= ProductLineBumId.ClientID %>.setValue(record.data['ProductLineBumId']);
        //Company        
        
        <%= CustomerFaceNbr.ClientID %>.setValue(record.data['CustomerFaceNbr']);
        <%= EnglishName.ClientID %>.setValue(record.data['EnglishName']);
        <%= ChineseName.ClientID %>.setValue(record.data['ChineseName']);
        <%= Description.ClientID %>.setValue(record.data['Description']);
        
         if (record.data['Implant']==true)
                {
                    <%= rbImplantTrue.ClientID %>.setValue(true);
                    <%= rbImplantFalse.ClientID %>.setValue(false);
                }
                else
                {
                    <%= rbImplantTrue.ClientID %>.setValue(false);
                    <%= rbImplantFalse.ClientID %>.setValue(true);
                }
         if (record.data['Tool']==true)
                {
                    <%= rbToolTrue.ClientID %>.setValue(true);
                    <%= rbToolFalse.ClientID %>.setValue(false);
                }
                else
                {
                    <%= rbToolTrue.ClientID %>.setValue(false);
                    <%= rbToolFalse.ClientID %>.setValue(true);
                }
        if (record.data['Share']==true)
                {
                    <%= rbShareTrue.ClientID %>.setValue(true);
                    <%= rbShareFalse.ClientID %>.setValue(false);
                }
                else
                {
                    <%= rbShareTrue.ClientID %>.setValue(false);
                    <%= rbShareFalse.ClientID %>.setValue(true);
                }
                
        <%= PCTName.ClientID %>.setValue(record.data['PCTName']);
        <%= PCTEnglishName.ClientID %>.setValue(record.data['PCTEnglishName']);
        <%= ProductLineName.ClientID %>.setValue(record.data['ProductLineName']);
        
        //产品属性
        <%= Property1.ClientID %>.setValue(record.data['Property1']);
        <%= Property2.ClientID %>.setValue(record.data['Property2']);
        <%= Property3.ClientID %>.setValue(record.data['Property3']);
        <%= Property4.ClientID %>.setValue(record.data['Property4']);
        <%= Property5.ClientID %>.setValue(record.data['Property5']);
        <%= Property6.ClientID %>.setValue(record.data['Property6']);
        <%= Property7.ClientID %>.setValue(record.data['Property7']);
        <%= Property8.ClientID %>.setValue(record.data['Property8']);        
        window.show(animTrg);
    }
    
        var saveCFN = function () {
        
        if (<%= CustomerFaceNbr.ClientID %>.getValue() =="" )
        {
            alert('<%=GetLocalResourceObject("saveCFN.alert").ToString()%>');
            return;
        }
        
        if( grid !=null)
            employeeRecord.set('Id',<%= Id1.ClientID %>.getValue());
     
        
        employeeRecord.set('EnglishName',<%= EnglishName.ClientID %>.getValue());
        employeeRecord.set('ChineseName',<%= ChineseName.ClientID %>.getValue());
        employeeRecord.set('CustomerFaceNbr',<%= CustomerFaceNbr.ClientID %>.getValue());
        employeeRecord.set('Description',<%= Description.ClientID %>.getValue());


        //if (<%= rbImplant.ClientID %>.getValue() == "" )
            //employeeRecord.set('Implant',1);
        //else
            //employeeRecord.set('Implant',<%= rbImplantTrue.ClientID %>.getValue()=="true" ? "true" : "false");
         
         
         if (<%= rbImplantTrue.ClientID %>.getValue() == true)
         {
            employeeRecord.set('Implant',true);
         }else
         {
            employeeRecord.set('Implant',false);
         }
         
         if (<%= rbToolTrue.ClientID %>.getValue() == true)
         {
            employeeRecord.set('Tool',true);
         }else
         {
            employeeRecord.set('Tool',false);
         }
         
         if (<%= rbShareTrue.ClientID %>.getValue() == true)
         {
            employeeRecord.set('Share',true);
         }else
         {
            employeeRecord.set('Share',false);
         }
            
        if (<%= ProductCatagoryPctId.ClientID %>.getValue() == "" )
        {
            employeeRecord.set('ProductCatagoryPctId',null);
        }
        if (<%= ProductLineBumId.ClientID %>.getValue() == "" )
        {
            employeeRecord.set('ProductLineBumId',null);
        }
        
            employeeRecord.set('DeletedFlag',false);
            
        //产品属性
        employeeRecord.set('Property1',<%= Property1.ClientID %>.getValue());
        employeeRecord.set('Property2',<%= Property2.ClientID %>.getValue());
        employeeRecord.set('Property3',<%= Property3.ClientID %>.getValue());
        employeeRecord.set('Property4',<%= Property4.ClientID %>.getValue());
        employeeRecord.set('Property5',<%= Property5.ClientID %>.getValue());
        employeeRecord.set('Property6',<%= Property6.ClientID %>.getValue());
        employeeRecord.set('Property7',<%= Property7.ClientID %>.getValue());
        employeeRecord.set('Property8',<%= Property8.ClientID %>.getValue());
            
        <%= CFNDetailsWindow.ClientID %>.hide(null);
        employeeRecord.set('CustomerFaceNbr',<%= CustomerFaceNbr.ClientID %>.getValue());          
    }
    
    var cancelCFN =function()
    {
        if(grid != null )
        {
           var gd = Ext.getCmp(grid) ;
           if(gd != null && <%= flag.ClientID %>.value != "1")
              gd.deleteRecord(employeeRecord)
        }   
        <%= CFNDetailsWindow.ClientID %>.hide(null);
        
        <%= CustomerFaceNbr.ClientID %>.setValue(null);
        <%= EnglishName.ClientID %>.setValue(null);
        <%= ChineseName.ClientID %>.setValue(null);
        <%= PCTName.ClientID %>.setValue(null);
        <%= PCTEnglishName.ClientID %>.setValue(null);
        <%= ProductLineName.ClientID %>.setValue(null);
        <%= Description.ClientID %>.setValue(null);
        //#{HospitalDetailsWindow}.hide(null);
    }
    
</script>

<ext:Store ID="CFNsStore" runat="server" AutoLoad="true">
    <Reader>
        <ext:JsonReader ReaderID="HosId">
            <Fields>
                     <ext:RecordField Name="Id" />
                     <ext:RecordField Name="EnglishName" />
                     <ext:RecordField Name="ChineseName" />
                     <ext:RecordField Name="Implant" />
                     <ext:RecordField Name="Tool" />
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
</ext:Store>

<ext:Window ID="CFNDetailsWindow" runat="server" Icon="Group" Title="<%$ Resources: CFNDetailsWindow.Title %>"  
    Width="550" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false"  BodyStyle="padding:5px;" Closable="false">
    <Body>
    
    <ext:FitLayout ID="FitLayout1" runat="server">
        <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Border="false">
             <Tabs>
                <ext:Tab 
                        ID="CompanyInfoTab" 
                        runat="server" 
                        Title="<%$ Resources: CompanyInfoTab.Title %>" 
                        Icon="ChartOrganisation"
                        BodyStyle="padding:5px;">
                      <Body>


        <ext:FormLayout ID="FormLayout4" runat="server">
            <ext:Anchor>
                <ext:TextField ID="Id1" Hidden="false" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.PmaId.FieldLabel %>" Width="250" Disabled="true" />
            </ext:Anchor>
            <ext:Anchor>
            <ext:TextField ID="flag" Hidden="true"  runat="server"  />
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="ProductCatagoryPctId" Hidden="true" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.ProductCatagoryPctId.FieldLabel %>" Width="250" Disabled="true" />
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="ProductLineBumId" Hidden="true" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.ProductLineBumId.FieldLabel %>" Width="250" Disabled="true" />
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
                                                <ext:TextField ID="ProductLineName" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.ProductLineName.FieldLabel %>" Width="250"  Disabled=true/>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="PCTName" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.PCTName.FieldLabel %>" Width="250" Disabled=true />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="PCTEnglishName" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.PCTEnglishName.FieldLabel%>" Width="250" Disabled=true />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="CustomerFaceNbr" runat="server" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" Width="250" AllowBlank="false" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="EnglishName" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.EnglishName.FieldLabel  %>" Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="ChineseName" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.ChineseName.FieldLabel  %>" Width="250" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:RadioGroup ID="rbImplant" runat="server" FieldLabel="<%$ Resources: CompanyInfoTab.rbImplant.FieldLabel %>" ColumnsNumber="2" >
                                                    <Items>
                                                        <ext:Radio ID="rbImplantTrue" runat="server" BoxLabel="<%$ Resources: CompanyInfoTab.rbImplantTrue.BoxLabel %>" Checked="false" />
                                                        <ext:Radio ID="rbImplantFalse" runat="server" BoxLabel="<%$ Resources:CompanyInfoTab.rbImplantFalse.BoxLabel %>" Checked="true" />
                                                    </Items>
                                                </ext:RadioGroup>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:RadioGroup ID="rbTool" runat="server" FieldLabel="<%$ Resources:CompanyInfoTab.rbTool.FieldLabel %>" ColumnsNumber="2">
                                                    <Items>
                                                        <ext:Radio ID="rbToolTrue" runat="server" BoxLabel="<%$ Resources:CompanyInfoTab.rbToolTrue.BoxLabel %>" Checked="false" />
                                                        <ext:Radio ID="rbToolFalse" runat="server" BoxLabel="<%$ Resources:CompanyInfoTab.rbToolFalse.BoxLabel %>" Checked="true" />
                                                    </Items>
                                                </ext:RadioGroup>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:RadioGroup ID="rbShare" runat="server" FieldLabel="<%$ Resources:CompanyInfoTab.rbShare.FieldLabel %>" ColumnsNumber="2">
                                                    <Items>
                                                        <ext:Radio ID="rbShareTrue" runat="server" BoxLabel="<%$ Resources:CompanyInfoTab.rbShareTrue.BoxLabel %>" Checked="false" />
                                                        <ext:Radio ID="rbShareFalse" runat="server" BoxLabel="<%$ Resources:CompanyInfoTab.rbShareFalse.BoxLabel %>" Checked="true" />
                                                    </Items>
                                                </ext:RadioGroup>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="Description" runat="server" FieldLabel="<%$ Resources:CompanyInfoTab.Description.FieldLabel%>" Width="250" />
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
        </ext:Tab>
        
                <ext:Tab 
                        ID="Tab1" 
                        runat="server" 
                        Title="<%$ Resources:CompanyInfoTab.Description.FieldLabel%>" 
                        Icon="ChartOrganisation"
                        BodyStyle="padding:5px;">
                      <Body>


        <ext:FormLayout ID="FormLayout1" runat="server">
            <ext:Anchor>
                <ext:TextField ID="Property1" runat="server" FieldLabel="<%$ Resources:Tab1.Property1.FieldLabel%>" Width="250" />
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="Property2" runat="server" FieldLabel="<%$ Resources:Tab1.Property2.FieldLabel%>" Width="250" />
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="Property3" runat="server" FieldLabel="<%$ Resources:Tab1.Property3.FieldLabel%>" Width="250" />
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="Property4" runat="server" FieldLabel="<%$ Resources:Tab1.Property4.FieldLabel%>" Width="250" />
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="Property5" runat="server" FieldLabel="<%$ Resources:Tab1.Property5.FieldLabel%>" Width="250"/>
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="Property6" runat="server" FieldLabel="<%$ Resources:Tab1.Property6.FieldLabel%>" Width="250" />
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="Property7" runat="server" FieldLabel="<%$ Resources:Tab1.Property7.FieldLabel%>" Width="250" />
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="Property8" runat="server" FieldLabel="<%$ Resources:Tab1.Property8.FieldLabel%>" Width="250" />
            </ext:Anchor>

        </ext:FormLayout>
        </Body>
        </ext:Tab>
        </Tabs>
        </ext:TabPanel>
 </ext:FitLayout>
     </Body>
    <Buttons>
        <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources:SaveButton.Text%>" Icon="Disk">
            <Listeners>
                <Click Handler="saveCFN();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources:CancelButton.Text%>" Icon="Cancel">
            <Listeners>
                <Click Handler="cancelCFN();" />
            </Listeners>
        </ext:Button>
    </Buttons>

</ext:Window>
