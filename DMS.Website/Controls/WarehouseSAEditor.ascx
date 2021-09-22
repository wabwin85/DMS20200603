<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WarehouseSAEditor.ascx.cs" Inherits="DMS.Website.Controls.WarehouseSAEditor" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="HospitalSearchDialog.ascx" TagName="HospitalSearchDialog" TagPrefix="uc1" %>
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
   .txtRed {
            color: Red;
            font-weight: bold;
        }
</style>

<script type="text/javascript">
    var storeRecord;
    var grid =null ;
    var isNew = false;

    var createNewObjectDetails = function (record, mygrid, animTrg) {
        isNew = true;  
        storeRecord = record;
        grid = mygrid;
        var window = <%= WarehouseDetailsWindow.ClientID %>;
        window.setTitle(String.format('<%=GetLocalResourceObject("createNewObjectDetails.setTitle1").ToString()%>','<%=GetLocalResourceObject("createNewObjectDetails.setTitle2").ToString()%>'));
     
        <%= Id1.ClientID %>.setValue(record.id);
       
        <%= RadioTrue.ClientID %>.setValue(true);
        <%= RadioFalse.ClientID %>.setValue(false);
    
        <%= Code.ClientID %>.setValue("");
        <%= Name.ClientID %>.setValue("");
        <%= Type.ClientID %>.setValue("");
        <%= ConId.ClientID %>.setValue(null);
        <%= Radio1.ClientID %>.setValue(false);
        <%= Radio2.ClientID %>.setValue(true);
        
        
        Ext.getCmp('<%= hiddenType.ClientID %>').setValue("Add");  
            document.all.<%= Name.ClientID %>.readOnly=false;
           Ext.getCmp('<%= Type.ClientID %>').setDisabled(false);
           Ext.getCmp('<%= RadioFalse.ClientID %>').setDisabled(false);
           Ext.getCmp('<%= RadioTrue.ClientID %>').setDisabled(false);
           
           document.all.<%= SaveButton.ClientID %>.style.display="";
        window.show(animTrg);
    }

    var openDetails = function (record, animTrg,test) {
        isNew = false;
        storeRecord = record;
        var window = <%= WarehouseDetailsWindow.ClientID %>;
        window.setTitle(String.format('<%=GetLocalResourceObject("openDetails.setTitle").ToString()%>',record.data['Name']));
        
        <%= Id1.ClientID %>.setValue(record.id);
        if (record.data['ActiveFlag']==true)
        {
            <%= RadioTrue.ClientID %>.setValue(true);
            <%= RadioFalse.ClientID %>.setValue(false);
        }
        else
        {
            <%= RadioTrue.ClientID %>.setValue(false);
            <%= RadioFalse.ClientID %>.setValue(true);
        }
     
        <%= DmaId.ClientID %>.setValue(record.data['DmaId']);
         <%= Code.ClientID %>.setValue(record.data['Code']);
        <%= Name.ClientID %>.setValue(record.data['Name']);
        <%= Type.ClientID %>.setValue(record.data['Type']);
        <%= ConId.ClientID %>.setValue(record.data['ConId']);
        if (record.data['HoldWarehouse']==true)
        {
            <%= Radio1.ClientID %>.setValue(true);
            <%= Radio2.ClientID %>.setValue(false);
        }
        else
        {
            <%= Radio2.ClientID %>.setValue(true);
            <%= Radio1.ClientID %>.setValue(false);
        }
  
        
        if(record.data['Type']!="Normal")
        {
           
           if(record.data['Type']=="Borrow")
           {
              Ext.getCmp('<%= Type.ClientID %>').setValue("波科借货库");
           }
           if(record.data['Type']=="Consignment")
           {
              Ext.getCmp('<%= Type.ClientID %>').setValue("波科寄售库");
           }
          
           
         if(record.data['Type']=="DefaultWH")
           {
           <%= Type.ClientID %>.setValue("缺省仓库");
             //Ext.getCmp('<%= Type.ClientID %>').setValue("DefaultWH");
             document.all.<%= SaveButton.ClientID %>.style.display="";
           }
           else
           {
           document.all.<%= SaveButton.ClientID %>.style.display="none";
           }
           Ext.getCmp('<%= Type.ClientID %>').setDisabled(true);
           Ext.getCmp('<%= RadioFalse.ClientID %>').setDisabled(true);
           Ext.getCmp('<%= RadioTrue.ClientID %>').setDisabled(true);
        }
        else
        {
           document.all.<%= Name.ClientID %>.readOnly=false;
           Ext.getCmp('<%= Type.ClientID %>').setDisabled(false);
           Ext.getCmp('<%= RadioFalse.ClientID %>').setDisabled(false);
           Ext.getCmp('<%= RadioTrue.ClientID %>').setDisabled(false);
           
           document.all.<%= SaveButton.ClientID %>.style.display="";
        }
        
       Ext.getCmp('<%= hiddenType.ClientID %>').setValue("Update");  
       window.show(animTrg);   
      
     
    }
    
    
        var saveDetail = function () {
        
        if (<%= Name.ClientID %>.getValue() ==""  || <%= Type.ClientID %>.getValue() =="")
        {
            //alert('<%=GetLocalResourceObject("saveDetail.alert").ToString()%>');
            return;
        }
        
        
        storeRecord.set('ActiveFlag',<%= RadioTrue.ClientID %>.getValue()==true ? true : false);
        storeRecord.set('Id',<%= Id1.ClientID %>.getValue());
        storeRecord.set('DmaId',<%= DmaId.ClientID %>.getValue()=="" ? null : <%= DmaId.ClientID %>.getValue());
        storeRecord.set('Code',<%= Code.ClientID %>.getValue());
        storeRecord.set('Name',<%= Name.ClientID %>.getValue());
        if(<%= Type.ClientID %>.getValue()!="缺省仓库")
        {  
           storeRecord.set('Type',<%= Type.ClientID %>.getValue());
        }
        storeRecord.set('HospitalHosId', null);
        storeRecord.set('ConId',<%= ConId.ClientID %>.getValue()=="" ? null : <%= ConId.ClientID %>.getValue());
        storeRecord.set('HoldWarehouse',<%= Radio1.ClientID %>.getValue()==true ? true : false);
        
        
        <%= WarehouseDetailsWindow.ClientID %>.hide(null);
    }
    
    var cancelDetailEdit =function()
    {
        if(grid != null )
        {
           var gd = Ext.getCmp(grid) ;
           if(gd != null && isNew)
              gd.deleteRecord(storeRecord)
        }   
        <%= WarehouseDetailsWindow.ClientID %>.hide(null);
    }
    
    
    var invalidFields = function(result) {
    
  
        if (result.success == false)
        {
            Ext.Msg.alert('<%=GetLocalResourceObject("invalidFields.false.alert.title").ToString()%>','<%=GetLocalResourceObject("invalidFields.false.alert.body").ToString()%>');
        }
        else
        {
            Ext.Msg.alert('<%=GetLocalResourceObject("invalidFields.true.alert.title").ToString()%>','<%=GetLocalResourceObject("invalidFields.true.alert.body").ToString()%>');
        }
    }

  function warningMsg(result)
  {
        if(result.success == false)
            Ext.Msg.alert('<%=GetLocalResourceObject("warningMsg.alert").ToString()%>',result.errorMessage);        
  }
</script>

<ext:window id="WarehouseDetailsWindow" runat="server" icon="Group" title="<%$ Resources: WarehouseDetailsWindow.Title %>"
    width="900" height="400" autoshow="false" modal="true" showonload="false" bodystyle="padding:5px;" Closable="false">
    <Body>
        <ext:Store ID="WarehouseTypeStoreOnControl" runat="server" UseIdConfirmation="false">
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Key" Direction="ASC" />
            <Listeners>
            </Listeners>
        </ext:Store>
        <%-- OnRefreshData="DealerWarehousesStore_RefreshData" --%>
        <ext:Store ID="DealerWarehousesStore" runat="server" AutoLoad="true" SerializationMode="Simple">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="Type" />
                        <ext:RecordField Name="Code" />
                        <ext:RecordField Name="ActiveFlag" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Name" Direction="ASC" />
            <BaseParams>
                <ext:Parameter Name="DealerId" Value="#{DmaId}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{DmaId}.getValue()"
                    Mode="Raw" />
            </BaseParams>
            <Listeners>
            </Listeners>
        </ext:Store>
        <ext:Hidden ID="hiddenFieldValidFlag" runat="server" Text="ABC">
        </ext:Hidden>
        <ext:Hidden ID="hiddenType" runat="server">
        </ext:Hidden>
        <ext:FormLayout ID="FormLayoutHeader" runat="server">
            <ext:Anchor>
                <ext:TextField ID="DmaId" runat="server" FieldLabel="<%$ Resources: WarehouseDetailsWindow.DmaId.FieldLabel %>"
                    Width="250" Hidden="true" />
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="Id1" runat="server" FieldLabel="<%$ Resources: WarehouseDetailsWindow.Id1.FieldLabel %>"
                    Width="250" Hidden="true" />
            </ext:Anchor>
             <ext:Anchor>
                <ext:Label ID="LabRemark" runat="server" LabelSeparator="" CtCls="txtRed" HideLabel="true" Text="仓库代码填写规则：【LS库位识别编号+医院编号+SA编号】，编码之间不要加空格，用“-”隔开"></ext:Label>
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="Code" runat="server" FieldLabel="仓库代码" Width="250">
                </ext:TextField>
            </ext:Anchor>
              <ext:Anchor>
                <ext:Label ID="Label1" runat="server" LabelSeparator="" CtCls="txtRed" HideLabel="true" Text="仓库名称填写规则：医院名称+服务商名称"></ext:Label>
            </ext:Anchor>
            <ext:Anchor>
                <ext:TextField ID="Name" runat="server" FieldLabel="<%$ Resources: WarehouseDetailsWindow.Name.FieldLabel %>"
                    Width="250" AllowBlank="false" BlankText="<%$ Resources: WarehouseDetailsWindow.Name.EmptyText %>" />
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelBody" runat="server" FormGroup="true" AutoHeight="true" BodyStyle="background-color: transparent;">
                    <Body>
                        <ext:ColumnLayout ID="LeftColumn" runat="server">
                            <ext:LayoutColumn ColumnWidth="0.5">
                                <ext:Panel ID="Panel2" runat="server" BodyBorder="false" Header="false" Shadow="Frame"
                                    BodyStyle="background-color: transparent;" ShadowOffset="5">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout11" runat="server">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="Type" runat="server" FieldLabel="<%$ Resources: WarehouseDetailsWindow.Type.FieldLabel %>"
                                                    StoreID="WarehouseTypeStoreOnControl" AllowBlank="false" Editable="false" TypeAhead="true"
                                                    Mode="Local" DisplayField="Value" ValueField="Key" ForceSelection="true" TriggerAction="All"
                                                    EmptyText="<%$ Resources: WarehouseDetailsWindow.Type.EmptyText%>" ItemSelector="div.list-item"
                                                    SelectOnFocus="true">
                                                    <Template ID="Template2" runat="server">
                                                    <tpl for=".">
                                                        <div class="list-item">
                                                             {Value}
                                                        </div>
                                                    </tpl>
                                                    </Template>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="ConId" runat="server" FieldLabel="<%$ Resources: WarehouseDetailsWindow.ConId.FieldLabel %>"
                                                    Width="250" Hidden="true" />
                                            </ext:Anchor>
                                            <ext:Anchor Horizontal="70%">
                                                <ext:RadioGroup ID="HoldWarehouse" Hidden="true" runat="server" FieldLabel="<%$ Resources: WarehouseDetailsWindow.HoldWarehouse.FieldLabel %>"
                                                    ColumnsNumber="2">
                                                    <Items>
                                                        <ext:Radio ID="Radio1" runat="server" BoxLabel="<%$ Resources: WarehouseDetailsWindow.Radio1.FieldLabel%>"
                                                            Checked="true" />
                                                        <ext:Radio ID="Radio2" runat="server" BoxLabel="<%$ Resources: WarehouseDetailsWindow.Radio2.FieldLabel%>"
                                                            Checked="false" />
                                                    </Items>
                                                </ext:RadioGroup>
                                            </ext:Anchor>
                                            <ext:Anchor Horizontal="70%">
                                                <ext:RadioGroup ID="ActiveFlag" runat="server" FieldLabel="<%$ Resources: WarehouseDetailsWindow.ActiveFlag.FieldLabel%>"
                                                    ColumnsNumber="2">
                                                    <Items>
                                                        <ext:Radio ID="RadioTrue" runat="server" BoxLabel="<%$ Resources: WarehouseDetailsWindow.RadioTrue.FieldLabel%>"
                                                            Checked="true">
                                                            <Listeners>
                                                                <Blur Handler="" />
                                                            </Listeners>
                                                        </ext:Radio>
                                                        <ext:Radio ID="RadioFalse" runat="server" BoxLabel="<%$ Resources: WarehouseDetailsWindow.RadioFalse.FieldLabel%>"
                                                            Checked="false" />
                                                    </Items>
                                                </ext:RadioGroup>
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
        <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: SaveButton.Text%>"
            Icon="Disk">
            <AjaxEvents>
                <Click OnEvent="AjaxEvents_CheckIfEmptyWarehouse" Success="saveDetail();" Failure="warningMsg(result);">
                    <EventMask ShowMask="true" MinDelay="10" Msg="<%$ Resources: SaveButton.EventMask.Msg%>" />
                    <ExtraParams>
                        <ext:Parameter Name="WhichField" Value="A">
                        </ext:Parameter>
                    </ExtraParams>
                </Click>
            </AjaxEvents>
        </ext:Button>
        <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources: CancelButton.Text%>"
            Icon="Cancel">
            <Listeners>
                <Click Handler="cancelDetailEdit();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:window>
<uc1:HospitalSearchDialog id="HospitalSearchDialog1" runat="server" />
