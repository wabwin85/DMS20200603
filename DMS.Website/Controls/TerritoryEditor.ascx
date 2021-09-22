<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TerritoryEditor.ascx.cs"
    Inherits="DMS.Website.Controls.TerritoryEditor" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    var TerritoryEditorMsgList = {
        msg1:"<%=GetLocalResourceObject("SaveButton.Ext.Msg.alert.Message1").ToString()%>",
        msg2:"<%=GetLocalResourceObject("SaveButton.Ext.Msg.alert.Message2").ToString()%>"
    }

   function RefreshDetailWindow() {
   
        Ext.getCmp('<%=this.cbLevel.ClientID%>').store.reload();
        Ext.getCmp('<%=this.cbProductLine.ClientID%>').store.reload();
      
    }
    
    var dataRecord;
    var isCreated = false;
             
       //新增,修改后改变左边的树     
         function afterInsertHandler() {
            var tree = Ext.getCmp("TreePanel1");
            var parentNode = tree.getSelectionModel().getSelectedNode();
            
            if(<%= HiddenIsPageNew.ClientID %>.getValue()=="0") //新增
            {
            var nodeconfig = new Ext.tree.TreeNode({ text: "新建区域" });
            var node = tree.createNode(nodeconfig);
            parentNode.appendChild(node);     
            node.beginUpdate();
            node.setText(<%= txtName.ClientID %>.getValue());           
            id = <%= HiddenNewAddId.ClientID %>.getValue();
            node.id = id;
            node.endUpdate();
            }else    //修改
            {
            parentNode.beginUpdate();
            parentNode.setText(<%= txtName.ClientID %>.getValue());      
            id = <%= HiddenNodeId.ClientID %>.getValue();
            parentNode.id = id;
            parentNode.endUpdate();
            }
            Ext.Msg.alert("Message", "<%=GetLocalResourceObject("Ext.Msg.alert.Message").ToString()%>");
            
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

<ext:Store ID="TerritoryLevelStore" runat="server" UseIdConfirmation="true" AutoLoad="true"
    OnRefreshData="Store_RefreshDictionary">
    <BaseParams>
        <ext:Parameter Name="Type" Value="CONST_Territory_Level" Mode="Value">
        </ext:Parameter>
    </BaseParams>
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



<ext:Store ID="ProductLineSelectStore" runat="server" UseIdConfirmation="true" AutoLoad="true"
    OnRefreshData="ProductLineStore_RefershData">
      <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="AttributeID">
            <Fields>
                <ext:RecordField Name="AttributeID" />
                <ext:RecordField Name="AttributeName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
     <Listeners>
     <Load Handler="if(#{HiddenLevel}.getValue()=='BU'){#{cbProductLine}.setValue(#{cbProductLine}.store.getTotalCount()>0?#{cbProductLine}.store.getAt(0).get('AttributeID'):'');}"  />
    </Listeners>
     <SortInfo Field="AttributeID" Direction="ASC" />
</ext:Store>
<ext:Window ID="PartsDetailsWindow" runat="server" Icon="Group" Title="<%$ Resources: PartsDetailsWindow.Title %>" Closable="false"
    AutoShow="false" ShowOnLoad="false" Resizable="false" Height="200" Draggable="false"
    Width="400" Modal="true" BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout3" runat="server" LabelPad="20">
            <ext:Anchor Horizontal="100%">
                <ext:TextField ID="txtCode" runat="server" FieldLabel="<%$ Resources: txtCode.FieldLabel %>" Width="200"  MaxLength="80"  AllowBlank="false"/>
            </ext:Anchor>
            <ext:Anchor Horizontal="100%">
                <ext:TextField ID="txtName" runat="server" FieldLabel="<%$ Resources: txtName.FieldLabel %>" Width="200" MaxLength="80"  AllowBlank="false"/>
            </ext:Anchor>
            <ext:Anchor Horizontal="100%">
                <ext:TextField ID="txtDescription" runat="server" FieldLabel="<%$ Resources: txtDescription.FieldLabel %>" Width="200" MaxLength="80"/>
            </ext:Anchor>
            <ext:Anchor Horizontal="100%">
                <ext:ComboBox ID="cbLevel" runat="server" FieldLabel="<%$ Resources: cbLevel.FieldLabel %>" Width="150" ListWidth="200"
                    StoreID="TerritoryLevelStore" Editable="false" Resizable="true" EmptyText="<%$ Resources: ComboBox.EmptyText %>"
                    ValueField="Key" DisplayField="Value">
                    <Triggers>
                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: FieldTrigger.Qtip %>" />
                    </Triggers>
                    <Listeners>
                        <TriggerClick Handler="this.clearValue();" />
                    </Listeners>
                </ext:ComboBox>
            </ext:Anchor>
            <ext:Anchor Horizontal="100%">
                <ext:ComboBox ID="cbProductLine" runat="server" FieldLabel="<%$ Resources: cbProductLine.FieldLabel %>" Width="150" ListWidth="200"
                    StoreID="ProductLineSelectStore" Editable="false" Resizable="true" EmptyText="<%$ Resources: ComboBox.EmptyText %>"
                    ValueField="AttributeID" DisplayField="AttributeName" TypeAhead="true"  AllowBlank="false">
                    <Triggers>
                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: FieldTrigger.Qtip %>" />
                    </Triggers>
                    <Listeners>
                        <TriggerClick Handler="this.clearValue();" />
                    </Listeners>
                </ext:ComboBox>
                                                
                                                
            </ext:Anchor>
               <ext:Anchor Horizontal="100%">
                <ext:TextField ID="txtProductLine" runat="server" FieldLabel="<%$ Resources: cbProductLine.FieldLabel %>" Width="200" Hidden="true" />
            </ext:Anchor>
            
            <ext:Anchor>
                <ext:Hidden ID="HiddenNodeParentId" runat="server">
                </ext:Hidden>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Hidden ID="HiddenNodeLineId" runat="server">
                </ext:Hidden>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Hidden ID="HiddenNodeId" runat="server">
                </ext:Hidden>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Hidden ID="HiddenLevel" runat="server">
                </ext:Hidden>
            </ext:Anchor>
              <ext:Anchor>
                <ext:Hidden ID="HiddenProductLineId" runat="server">
                </ext:Hidden>
            </ext:Anchor>
               <ext:Anchor>
                <ext:Hidden ID="HiddenIsPageNew" runat="server">
                </ext:Hidden>
            </ext:Anchor>
                <ext:Anchor>
                <ext:Hidden ID="HiddenNewAddId" runat="server">
                </ext:Hidden>
            </ext:Anchor>
                   <ext:Anchor>
                <ext:Hidden ID="HiddenCode" runat="server">
                </ext:Hidden>
            </ext:Anchor>
        </ext:FormLayout>
    </Body>
    <Buttons>
        <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: SaveButton.Text %>" Icon="Disk">
         
             <Listeners>
                <Click Handler="if(!#{txtCode}.validate() || !#{txtName}.validate())
                                    {
                                         Ext.Msg.alert('Error', TerritoryEditorMsgList.msg1);
                                    }
                                    else{
                                          if(#{cbLevel}.getValue()=='SubBU' && #{HiddenIsPageNew}.getValue()=='0')
                                          {
                                            
                                             if(!#{cbProductLine}.validate())
                                             {
                                                Ext.Msg.alert('Error', TerritoryEditorMsgList.msg1);
                                             }else
                                             {
                                             Coolite.AjaxMethods.TerritoryEditor.SaveNodeData({success:function(result){if(result !='0'){Ext.Msg.alert('Error',TerritoryEditorMsgList.msg2);}else{#{PartsDetailsWindow}.hide();afterInsertHandler();}},failure:function(err){Ext.Msg.alert('Error', err);}})
                                             }
                                                
                                          }else
                                          {
                                            Coolite.AjaxMethods.TerritoryEditor.SaveNodeData({success:function(result){if(result !='0'){Ext.Msg.alert('Error',TerritoryEditorMsgList.msg2);}else{#{PartsDetailsWindow}.hide();afterInsertHandler();}},failure:function(err){Ext.Msg.alert('Error', err);}})
                                           }
                                    };"/>
            </Listeners>
         
        </ext:Button>
        <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources: CancelButton.Text %>" Icon="Cancel">
            <Listeners>
                <Click Handler="cancelWindow();" />
            </Listeners>
        </ext:Button>
    </Buttons>
   
</ext:Window>
