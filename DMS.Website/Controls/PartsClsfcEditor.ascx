<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PartsClsfcEditor.ascx.cs"
    Inherits="DMS.Website.Controls.PartsClsfcEditor" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    var dataRecord;
    var isCreated = false;
    
        var createPartsDetails = function (record,animTrg) {
          
          isCreated = true;
          dataRecord = record;
                  
          var window = <%= PartsDetailsWindow.ClientID %>;
             
              //window.setTitle(String.format('Details: {0}',"Create New Hospital"));
              <%= txtNodeName.ClientID %>.setValue(dataRecord.text);
              <%= txtNodeEngName.ClientID %>.setValue("");
              <%= txtNodeDesc.ClientID %>.setValue("");
              <%= txtNodeId.ClientID %>.setValue("");
              <%= txtNodeParent.ClientID %>.setValue(dataRecord.parentNode.text);
              <%= txtNodeParentId.ClientID %>.setValue(dataRecord.parentNode.id);
              <%= txtNodeLineId.ClientID %>.setValue(animTrg);
                
           window.show(null);
    }
    
    var openPartsDetails = function (record,animTrg) {
        dataRecord = record;
        isCreated = false;
        /**
        var window = <%= PartsDetailsWindow.ClientID %>;
        
          //window.setTitle(String.format('Details: {0}',record.data['HosHospitalShortName']));
          if (dataRecord.parentNode != null) {
               
                
                <%= txtNodeId.ClientID %>.setValue(dataRecord.id);
                <%= txtNodeName.ClientID %>.setValue(dataRecord.text);
                //<%= txtNodeEngName.ClientID %>.setValue(namearray[1]);
                
                if (dataRecord.attributes.qtip) <%= txtNodeDesc.ClientID %>.setValue(dataRecord.attributes.qtip);
                <%= txtNodeParent.ClientID %>.setValue(dataRecord.parentNode.text);
                
                <%= txtNodeParentId.ClientID %>.setValue(dataRecord.parentNode.id);
                
                <%= txtNodeLineId.ClientID %>.setValue(animTrg);
            }

        window.show(null);
        */
    }

    
    function afterSavePartsDetails() {
        
        if(isCreated )
        {
            dataRecord.beginUpdate();
            dataRecord.setText(<%= txtNodeName.ClientID %>.getValue());
            dataRecord.attributes.qtip = <%= txtNodeDesc.ClientID %>.getValue();   
            id = <%= txtNodeId.ClientID %>.getValue();
            dataRecord.id = id;
            dataRecord.endUpdate();
            
            isCreated = false;        
        }
        else 
        {
            dataRecord.beginUpdate();
            dataRecord.setText(<%= txtNodeName.ClientID %>.getValue()) ;
            dataRecord.attributes.qtip = <%= txtNodeDesc.ClientID %>.getValue();   
            dataRecord.endUpdate();
        }
        
        <%= PartsDetailsWindow.ClientID %>.hide(null);
        
        Ext.Msg.alert('<%=GetLocalResourceObject("afterSavePartsDetails.alert.title").ToString()%>', '<%=GetLocalResourceObject("afterSavePartsDetails.alert.body").ToString()%>');
        
    }
    
    var cancelWindow =function()
    {
         if(isCreated)
         {
             if( dataRecord != null)
               dataRecord.remove();
             isCreated = false;
         }
         <%= PartsDetailsWindow.ClientID %>.hide(null);
    }
    
</script>

<ext:Window ID="PartsDetailsWindow" runat="server" Icon="Group" Title="<%$ Resources: PartsDetailsWindow.Title %>" Closable="false"
    AutoShow="false" ShowOnLoad="false" Resizable="false" Height="200" Draggable="false"
    Width="400" Modal="true" BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout3" runat="server" LabelPad="20">
            <ext:Anchor Horizontal="100%">
                <ext:TextField ID="txtNodeId" runat="server" FieldLabel="<%$ Resources: PartsDetailsWindow.txtNodeId.FieldLabel %>" Width="200" Disabled="true" />
            </ext:Anchor>
            <ext:Anchor Horizontal="100%">
                <ext:TextField ID="txtNodeName" runat="server" FieldLabel="<%$ Resources: PartsDetailsWindow.txtNodeName.FieldLabel %>" Width="200" />
            </ext:Anchor>
            <ext:Anchor Horizontal="100%">
                <ext:TextField ID="txtNodeEngName" runat="server" FieldLabel="<%$ Resources: PartsDetailsWindow.txtNodeEngName.FieldLabel %>" Width="200" />
            </ext:Anchor>
            <ext:Anchor Horizontal="100%">
                <ext:TextField ID="txtNodeDesc" runat="server" FieldLabel="<%$ Resources: PartsDetailsWindow.txtNodeDesc.FieldLabel %>" Width="200" />
            </ext:Anchor>
            <ext:Anchor Horizontal="100%">
                <ext:TextField ID="txtNodeParent" runat="server" FieldLabel="<%$ Resources: PartsDetailsWindow.txtNodeParent.FieldLabel %>" Width="200" Disabled="true" />
            </ext:Anchor>
            <ext:Anchor>
                <ext:Hidden ID="txtNodeParentId" runat="server"></ext:Hidden>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Hidden ID="txtNodeLineId" runat="server"></ext:Hidden>
            </ext:Anchor>
        </ext:FormLayout>
    </Body>
    <Buttons>
        <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: SaveButton.Text %>" Icon="Disk">
            <AjaxEvents>
                <Click OnEvent="SaveNode_Click" Success="afterSavePartsDetails();">
                </Click>
            </AjaxEvents>
        </ext:Button>
        <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources: CancelButton.Text %>" Icon="Cancel">
            <Listeners>
                <Click Handler="cancelWindow();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
