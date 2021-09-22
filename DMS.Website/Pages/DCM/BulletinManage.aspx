<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BulletinManage.aspx.cs" Inherits="DMS.Website.Pages.DCM.BulletinManage" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/DealerSearchDialog.ascx" TagName="DealerSearchDialog"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">


        var CheckMod = function() {  
           var IsModified = Ext.getCmp('<%=this.isModified.ClientID%>').getValue()== "True" ? true : false;
           var isPageNew = Ext.getCmp('<%=this.isPageNew.ClientID%>').getValue() == "True" ? true : false;
           var isSaved = Ext.getCmp('<%=this.isSaved.ClientID%>').getValue()== "True" ? true : false;
           if (!isSaved) { 
               if(isModified)
               {                  
                   Ext.Msg.confirm('Warning', '是否保存草稿?', function (e) {
                       if (e == 'yes') {
                           <%= hfStatus.ClientID %>.setValue('Draft');      
                            var MainID = Ext.getCmp('<%= hfMainID.ClientID %>').getValue();
                            Coolite.AjaxMethods.SaveBulletin(MainID,
                           {success: function () 
                           {                          
                               Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                            Ext.getCmp('GridPanel1').reload();
                        },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }           
                                );                                                     
                }
                else {
                    if (isPageNew) {
                        var MainID = Ext.getCmp('<%= hfMainID.ClientID %>').getValue();
        Coolite.AjaxMethods.DeleteDraft(MainID,
      {success: function () 
      {
         
          Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
          Ext.getCmp('GridPanel1').reload();
      },
          failure: function (err) {
              Ext.Msg.alert('Error', err);
          }
      }           
                                );
} else {
    Ext.getCmp('<%=this.isSaved.ClientID%>').setValue("True");
        Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
    }
}
                        
                    });
    return false;

}
else if (isPageNew) {
    var MainID = Ext.getCmp('<%= hfMainID.ClientID %>').getValue();
    Coolite.AjaxMethods.DeleteDraft(MainID,
      {success: function () 
      {
         
          Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
          Ext.getCmp('GridPanel1').reload();
      },
          failure: function (err) {
              Ext.Msg.alert('Error', err);
          }
      }           
                                );
    return false;
}
        
            
}        
       }
var RefreshDetail = function(){
    Ext.getCmp('<%=this.DetailPanel.ClientID%>').reload();
        }
        
        var MsgList = {
            btnCancelled:{
                confirm:"<%=GetLocalResourceObject("DetailWindow.btnCancelled.confirm").ToString()%>",
			    failureTitle:"<%=GetLocalResourceObject("DetailWindow.btnCancelled.confirm.Listeners.Alert").ToString()%>"
			},
            btnDelDraft:{
                confirm:"<%=GetLocalResourceObject("DetailWindow.btnDelDraft.conifrm").ToString()%>",
			    failureTitle:"<%=GetLocalResourceObject("DetailWindow.btnDelDraft.confirm.Listeners.Alert").ToString()%>"
			}
        }

        var SetStatusDraft = function(){
            <%= hfStatus.ClientID %>.setValue('Draft');      
           var MainID = Ext.getCmp('<%= hfMainID.ClientID %>').getValue();
           if (Ext.getCmp('<%=this.Title.ClientID%>').getValue().length > 400) 
           {
               Ext.Msg.alert('<%=GetLocalResourceObject("SetStatusPublished.title.alert.title").ToString()%>', '<%=GetLocalResourceObject("SetStatusPublished.title.alert.body").ToString()%>');
                return;
            }
            else if (Ext.getCmp('<%=this.Body.ClientID%>').getValue().length > 2000) 
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("SetStatusPublished.body.alert.title").ToString()%>', '<%=GetLocalResourceObject("SetStatusPublished.body.alert.body").ToString()%>');
                return;
            }
            else{
           
                Coolite.AjaxMethods.SaveBulletin(MainID,
                          {success: function () 
                          {                          
                              Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                            Ext.getCmp('GridPanel1').reload();
                        },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }           
                                );
                }
       }
       
        var SetStatusPublished = function(){
      
            var MainID = Ext.getCmp('<%= hfMainID.ClientID %>').getValue();
            <%= hfStatus.ClientID %>.setValue('Published');
			
            if(<%= this.UrgentDegree.ClientID %>.getValue() == "" || <%= this.Title.ClientID %>.getValue() == "" || <%= this.Body.ClientID %>.getValue() == "" )
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("SetStatusPublished.alert.title").ToString()%>', '<%=GetLocalResourceObject("SetStatusPublished.alert.body").ToString()%>');
                return;
            }
            else if (Ext.getCmp('<%=this.Title.ClientID%>').getValue().length > 400) 
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("SetStatusPublished.title.alert.title").ToString()%>', '<%=GetLocalResourceObject("SetStatusPublished.title.alert.body").ToString()%>');
                return;
            }
            if (Ext.getCmp('<%=this.Title.ClientID%>').getValue().length > 400) 
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("SaveDetailPanelData.title.alert.title").ToString()%>', '<%=GetLocalResourceObject("SaveDetailPanelData.title.alert.body").ToString()%>');
                return;
            }
            if (Ext.getCmp('<%=this.Body.ClientID%>').getValue().length > 2000) 
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("SaveDetailPanelData.body.alert.title").ToString()%>', '<%=GetLocalResourceObject("SaveDetailPanelData.body.alert.body").ToString()%>');
                return;
            }
            if(Ext.getCmp('<%=this.DetailPanel.ClientID%>').store.getCount() == 0 
                && Ext.getCmp('<%=this.hfStatus.ClientID%>').getValue() == 'Published')
            {             
                Ext.Msg.alert('<%=GetLocalResourceObject("SaveDetailPanelData.dealer.alert.title").ToString()%>', '<%=GetLocalResourceObject("SaveDetailPanelData.dealer.alert.body").ToString()%>');
            } 
                      
            else
            {
                Coolite.AjaxMethods.SaveBulletin(MainID,
                        {success: function () 
                        {                          
                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                            Ext.getCmp('GridPanel1').reload();
                        },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }           
                                );
            }
                              
        }
       
            function isForever(d) {
            
                if(d == '9999-12-31'){
                    return '<%=GetLocalResourceObject("isForever.Forever").ToString()%>';
            }
            return d;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <ext:ScriptManager ID="ScriptManager1" runat="server"></ext:ScriptManager>
            <ext:Store ID="ResultStore" runat="server" AutoLoad="false" OnRefreshData="ResultStore_RefreshData">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="Id">
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="Title" />
                            <ext:RecordField Name="Body" />
                            <ext:RecordField Name="UrgentDegree" />
                            <ext:RecordField Name="ReadFlag" />
                            <ext:RecordField Name="Status" />
                            <ext:RecordField Name="ExpirationDate" />
                            <ext:RecordField Name="PublishedUser" />
                            <ext:RecordField Name="IdentityName" />
                            <ext:RecordField Name="PublishedDate" />
                            <ext:RecordField Name="CreateUser" />
                            <ext:RecordField Name="CreateDate" />
                            <ext:RecordField Name="UpdateUser" />
                            <ext:RecordField Name="UpdateDate" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="DetailStore" runat="server" UseIdConfirmation="false" OnRefreshData="DetailStore_RefreshData" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="BumId" />
                            <ext:RecordField Name="DealerDmaId" />
                            <ext:RecordField Name="IsRead" />
                            <ext:RecordField Name="ReadUser" />
                            <ext:RecordField Name="ReadDate" />
                            <ext:RecordField Name="IsConfirm" />
                            <ext:RecordField Name="ConfirmUser" />
                            <ext:RecordField Name="ConfirmDate" />
                            <ext:RecordField Name="ChineseName" />
                            <ext:RecordField Name="SapCode" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="BulletinStatusStore" runat="server" UseIdConfirmation="true" AutoLoad="true" OnRefreshData="Store_RefreshDictionary">
                <BaseParams>
                    <ext:Parameter Name="Type" Value="CONST_Bulletin_Status" Mode="Value"></ext:Parameter>
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
            <ext:Store ID="BulletinImportantStore" runat="server" UseIdConfirmation="true" AutoLoad="true" OnRefreshData="Store_RefreshDictionary">
                <BaseParams>
                    <ext:Parameter Name="Type" Value="CONST_Bulletin_Important" Mode="Value"></ext:Parameter>
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
                <SortInfo Field="Key" Direction="DESC" />
            </ext:Store>
            <ext:Store ID="DealerTypeMainStore" runat="server" UseIdConfirmation="true" OnRefreshData="DealerTypeStore_RefreshData">
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
            <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="false" OnRefreshData="AttachmentStore_Refresh">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="Attachment" />
                            <ext:RecordField Name="Name" />
                            <ext:RecordField Name="Url" />
                            <ext:RecordField Name="Type" />
                            <ext:RecordField Name="UploadUser" />
                            <ext:RecordField Name="Identity_Name" />
                            <ext:RecordField Name="UploadDate" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Hidden ID="isSaved" runat="server"></ext:Hidden>
            <ext:Hidden ID="isModified" runat="server"></ext:Hidden>
            <ext:Hidden ID="isPageNew" runat="server"></ext:Hidden>
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="True">
                            <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>" Frame="true" AutoHeight="true"
                                Icon="Find">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtTitle" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.txtTitle.FieldLabel %>">
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtPublishedUser" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.txtPublishedUser.FieldLabel %>">
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel2" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout2" runat="server">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbUrgentDegree" runat="server" EmptyText="<%$ Resources: plSearch.cbUrgentDegree.EmptyText %>" Width="150" Editable="true"
                                                                TypeAhead="true" Resizable="true" StoreID="BulletinImportantStore" ValueField="Key"
                                                                DisplayField="Value" FieldLabel="<%$ Resources: plSearch.cbUrgentDegree.FieldLabel %>">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.cbUrgentDegree.FieldTrigger.Qtip %>" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:DateField ID="dfPublishedBeginDate" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.dfPublishedBeginDate.FieldLabel %>" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:DateField ID="dfExpirationBeginDate" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.dfExpirationBeginDate.FieldLabel %>" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel3" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout3" runat="server">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbStatus" runat="server" EmptyText="<%$ Resources: plSearch.cbStatus.EmptyText %>" Width="150" Editable="true"
                                                                TypeAhead="true" Resizable="true" StoreID="BulletinStatusStore" ValueField="Key"
                                                                DisplayField="Value" FieldLabel="<%$ Resources: plSearch.cbStatus.FieldLabel %>">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.cbStatus.FieldTrigger.Qtip %>" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:DateField ID="dfPublishedEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.dfPublishedEndDate.FieldLabel %>">
                                                            </ext:DateField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:DateField ID="dfExpirationEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.dfExpirationEndDate.FieldLabel %>">
                                                            </ext:DateField>
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
                                            <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnImport" runat="server" Text="<%$ Resources: plSearch.btnImport.Text %>" Icon="Add" IDMode="Legacy">
                                        <Listeners>
                                            <Click Handler="Coolite.AjaxMethods.Show('00000000-0000-0000-0000-000000000000',{success:function(){#{DetailPanel}.reload();#{PagingToolBar3}.changePage(1);#{DetailWindow}.show();}})" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </North>
                        <Center>
                            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                        <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                            StoreID="ResultStore" Border="false" Icon="Lorry" StripeRows="true">
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="Title" DataIndex="Title" Header="<%$ Resources: GridPanel1.Title.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="IdentityName" DataIndex="IdentityName" Header="<%$ Resources: GridPanel1.IdentityName.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Status" DataIndex="Status" Header="<%$ Resources: GridPanel1.Status.Header %>">
                                                        <Renderer Handler="return getNameFromStoreById(BulletinStatusStore,{Key:'Key',Value:'Value'},value);" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PublishedDate" DataIndex="PublishedDate" Header="<%$ Resources: GridPanel1.PublishedDate.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ExpirationDate" DataIndex="ExpirationDate" Header="<%$ Resources: GridPanel1.ExpirationDate.Header %>">
                                                        <Renderer Handler="return isForever(value);" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UrgentDegree" DataIndex="UrgentDegree" Header="<%$ Resources: GridPanel1.UrgentDegree.Header %>">
                                                        <Renderer Handler="return getNameFromStoreById(BulletinImportantStore,{Key:'Key',Value:'Value'},value);" />
                                                    </ext:Column>
                                                    <ext:CheckColumn ColumnID="ReadFlag" DataIndex="ReadFlag" Header="<%$ Resources: GridPanel1.ReadFlag.Header %>">
                                                    </ext:CheckColumn>
                                                    <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.CommandColumn.Header %>" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                                <ToolTip Text="<%$ Resources: GridPanel1.CommandColumn.ToolTip.Text %>" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                            </SelectionModel>
                                            <Listeners>

                                                <Command Handler="Coolite.AjaxMethods.Show(record.data.Id,{success:function(){#{DetailPanel}.reload();#{PagingToolBar3}.changePage(1);#{DetailWindow}.show();}});" />
                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                    DisplayInfo="true" EmptyMsg="<%$ Resources: GridPanel1.PagingToolBar1.EmptyMsg %>" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:ViewPort>

            <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>" Resizable="false" Header="false"
                Width="780" Height="450" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
                <Body>
                    <ext:FitLayout ID="FitLayout2" runat="server">
                        <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Border="false" AutoScroll="true">
                            <Tabs>
                                <ext:Tab ID="Tab1" runat="server" Title="<%$ Resources: DetailWindow.Tab1.Title %>" Icon="ChartOrganisation"
                                    BodyStyle="padding:5px;">
                                    <Body>
                                        <ext:FormLayout ID="FormLayoutHeader" runat="server">
                                            <ext:Anchor>
                                                <ext:Panel ID="Panel4" runat="server" BodyBorder="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout11" runat="server">
                                                            <ext:Anchor>
                                                                <ext:Panel ID="Panel5" runat="server" BodyBorder="false" Header="false">
                                                                    <Body>
                                                                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                                <ext:Panel ID="Panel6" runat="server" Border="false">
                                                                                    <Body>
                                                                                        <ext:FormLayout ID="FormLayout4" runat="server">
                                                                                            <ext:Anchor>
                                                                                                <ext:ComboBox ID="UrgentDegree" runat="server" EmptyText="<%$ Resources: DetailWindow.Tab1.UrgentDegree.EmptyText %>" Width="150" Editable="true" AllowBlank="false"
                                                                                                    TypeAhead="true" Resizable="true" StoreID="BulletinImportantStore" ValueField="Key"
                                                                                                    DisplayField="Value" FieldLabel="<%$ Resources: DetailWindow.Tab1.UrgentDegree.FieldLabel %>">
                                                                                                    <Triggers>
                                                                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.Tab1.UrgentDegree.FieldTrigger.Qtip %>" />
                                                                                                    </Triggers>
                                                                                                    <Listeners>
                                                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                                                    </Listeners>
                                                                                                </ext:ComboBox>
                                                                                            </ext:Anchor>
                                                                                            <ext:Anchor>
                                                                                                <ext:DateField ID="ExpirationDate" runat="server" Width="150" FieldLabel="<%$ Resources: DetailWindow.Tab1.ExpirationDate.FieldLabel %>">
                                                                                                </ext:DateField>
                                                                                            </ext:Anchor>
                                                                                        </ext:FormLayout>
                                                                                    </Body>
                                                                                </ext:Panel>
                                                                            </ext:LayoutColumn>
                                                                            <ext:LayoutColumn ColumnWidth=".5">
                                                                                <ext:Panel ID="Panel7" runat="server" Border="false">
                                                                                    <Body>
                                                                                        <ext:FormLayout ID="FormLayout5" runat="server">
                                                                                            <ext:Anchor>
                                                                                                <ext:Hidden ID="hidden1" runat="server"></ext:Hidden>
                                                                                            </ext:Anchor>
                                                                                            <ext:Anchor>
                                                                                                <ext:ComboBox ID="Status" runat="server" EmptyText="<%$ Resources: DetailWindow.Tab1.Status.EmptyText %>" Width="150" Editable="true" AllowBlank="false"
                                                                                                    TypeAhead="true" Resizable="true" StoreID="BulletinStatusStore" ValueField="Key" Disabled="true"
                                                                                                    DisplayField="Value" FieldLabel="<%$ Resources: DetailWindow.Tab1.Status.FieldLabel %>">
                                                                                                </ext:ComboBox>
                                                                                            </ext:Anchor>
                                                                                            <ext:Anchor>
                                                                                                <ext:Checkbox ID="IsRead" runat="server" FieldLabel="<%$ Resources: DetailWindow.Tab1.Status.FieldTrigger.Qtip %>">
                                                                                                </ext:Checkbox>
                                                                                            </ext:Anchor>
                                                                                        </ext:FormLayout>
                                                                                    </Body>
                                                                                </ext:Panel>
                                                                            </ext:LayoutColumn>
                                                                        </ext:ColumnLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="Title" runat="server" FieldLabel="<%$ Resources: DetailWindow.Tab1.Title.FieldLabel %>" Width="390" AllowBlank="false" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextArea ID="Body" runat="server" FieldLabel="<%$ Resources: DetailWindow.Tab1.Body.FieldLabel %>" AllowBlank="false" Width="500" Height="200">
                                                                </ext:TextArea>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Tab>
                                <ext:Tab ID="Tab2" runat="server" Title="<%$ Resources: DetailWindow.Tab2.Title %>" Icon="ChartOrganisation">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout6" runat="server">
                                            <ext:Anchor>
                                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:GridPanel ID="DetailPanel" runat="server" Title="<%$ Resources: DetailWindow.Tab2.DetailPanel.Title %>" StoreID="DetailStore"
                                                            Border="false" Icon="Lorry" Height="340" Width="755" AutoScroll="true" EnableHdMenu="false" StripeRows="true">
                                                            <TopBar>
                                                                <ext:Toolbar ID="Toolbar1" runat="server" Height="20">
                                                                    <Items>
                                                                        <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                                        <ext:Button ID="btnAddItem" runat="server" Text="<%$ Resources: DetailWindow.Tab2.DetailPanel.btnAddItem %>" Icon="Add">
                                                                            <Listeners>
                                                                                <Click Handler="Coolite.AjaxMethods.DealerSearchDialog.Show(#{hfMainID}.getValue());" />
                                                                            </Listeners>
                                                                        </ext:Button>
                                                                    </Items>
                                                                </ext:Toolbar>
                                                            </TopBar>
                                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="DealerDmaId" DataIndex="DealerDmaId" Hidden="true">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: DetailWindow.Tab2.DetailPanel.ColumnModel2.ChineseName %>" Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="<%$ Resources: DetailWindow.Tab2.DetailPanel.ColumnModel2.SapCode %>">
                                                                    </ext:Column>
                                                                    <ext:CheckColumn ColumnID="IsConfirm" DataIndex="IsConfirm" Header="<%$ Resources: DetailWindow.Tab2.DetailPanel.ColumnModel2.IsConfirm %>">
                                                                    </ext:CheckColumn>
                                                                    <ext:Column ColumnID="ConfirmDate" DataIndex="ConfirmDate" Header="<%$ Resources: DetailWindow.Tab2.DetailPanel.ColumnModel2.ConfirmDate %>">
                                                                    </ext:Column>
                                                                    <ext:CheckColumn ColumnID="IsRead" DataIndex="IsRead" Header="<%$ Resources: DetailWindow.Tab2.DetailPanel.ColumnModel2.IsRead %>">
                                                                    </ext:CheckColumn>
                                                                    <ext:Column ColumnID="ReadDate" DataIndex="ReadDate" Header="<%$ Resources: DetailWindow.Tab2.DetailPanel.ColumnModel2.ReadDate %>">
                                                                    </ext:Column>
                                                                    <ext:CommandColumn Width="50" Header="<%$ Resources: DetailWindow.Tab2.DetailPanel.ColumnModel2.CommandColumn.Header %>" Align="Center">
                                                                        <Commands>
                                                                            <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources: DetailWindow.Tab2.DetailPanel.ColumnModel2.ToolTip-Text %>" />
                                                                        </Commands>
                                                                    </ext:CommandColumn>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                                                </ext:RowSelectionModel>
                                                            </SelectionModel>
                                                            <BottomBar>
                                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="100" StoreID="DetailStore"
                                                                    DisplayInfo="true" EmptyMsg="<%$ Resources: DetailWindow.Tab2.PagingToolBar2.EmptyMsg %>" />
                                                            </BottomBar>
                                                            <SaveMask ShowMask="true" />
                                                            <LoadMask ShowMask="true" Msg="<%$ Resources: DetailWindow.Tab2.DetailPanel.LoadMask.Msg %>" />
                                                            <Listeners>
                                                                <Command Handler="if (command == 'Delete'){
                                                                Coolite.AjaxMethods.DeleteItem(record.data.DealerDmaId,{success:function(){RefreshDetail();}});}" />
                                                            </Listeners>
                                                        </ext:GridPanel>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Tab>
                                <ext:Tab ID="Tab3" runat="server" Title="附件" Icon="BrickLink">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout7" runat="server">
                                            <ext:Anchor>
                                                <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:GridPanel ID="AttachmentPanel" runat="server" Title="附件列表" StoreID="AttachmentStore"
                                                            Border="false" Icon="Lorry" Height="340" Width="755" AutoScroll="true" EnableHdMenu="false" StripeRows="true">
                                                            <TopBar>
                                                                <ext:Toolbar ID="Toolbar2" runat="server" Height="20">
                                                                    <Items>
                                                                        <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                                        <ext:Button ID="btnAddAttach" runat="server" Text="添加附件" Icon="Add">
                                                                            <Listeners>
                                                                                <Click Handler="AttachmentWindow.show();" />
                                                                            </Listeners>
                                                                        </ext:Button>
                                                                    </Items>
                                                                </ext:Toolbar>
                                                            </TopBar>
                                                            <ColumnModel ID="ColumnModel3" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="MainId" DataIndex="MainId" Hidden="true">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Name" DataIndex="Name" Header="附件名称" Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Url" DataIndex="Url" Header="路径" Hidden="true">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="上传人">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="上传时间">
                                                                    </ext:Column>
                                                                    <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                                        <Commands>
                                                                            <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad" ToolTip-Text="下载" />
                                                                        </Commands>
                                                                    </ext:CommandColumn>
                                                                    <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                                        <Commands>
                                                                            <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                                                        </Commands>
                                                                    </ext:CommandColumn>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                                                </ext:RowSelectionModel>
                                                            </SelectionModel>
                                                            <BottomBar>
                                                                <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="100" StoreID="AttachmentStore"
                                                                    DisplayInfo="true" EmptyMsg="<%$ Resources: DetailWindow.Tab2.PagingToolBar2.EmptyMsg %>" />
                                                            </BottomBar>
                                                            <SaveMask ShowMask="true" />
                                                            <LoadMask ShowMask="true" Msg="<%$ Resources: DetailWindow.Tab2.DetailPanel.LoadMask.Msg %>" />
                                                            <Listeners>
                                                                <Command Handler="if (command == 'Delete'){
                                                                                Ext.Msg.confirm('警告', '是否要删除该下载文件?',
                                                                                    function(e) {
                                                                                        if (e == 'yes') {
                                                                                            Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                                success: function() {
                                                                                                    Ext.Msg.alert('Message', '删除成功！');
                                                                                                    #{AttachmentPanel}.reload();
                                                                                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                        }
                                                                                    });
                                                                            }
                                                                            else if (command == 'DownLoad')
                                                                            {
                                                                                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url);
                                                                                open(url, 'Download');
                                                                            }" />
                                                            </Listeners>
                                                        </ext:GridPanel>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Tab>
                            </Tabs>
                        </ext:TabPanel>
                    </ext:FitLayout>
                </Body>
                <Buttons>
                    <ext:Button ID="btnPublished" runat="server" Text="<%$ Resources: DetailWindow.btnPublished.Text %>" Icon="Disk">
                        <Listeners>
                            <Click Handler="SetStatusPublished();" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="btnSaveDraft" runat="server" Text="<%$ Resources: DetailWindow.btnSaveDraft.Text %>" Icon="Disk">
                        <Listeners>
                            <Click Handler="SetStatusDraft();" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="btnCancelled" runat="server" Text="<%$ Resources: DetailWindow.btnCancelled.Text %>" Icon="Cancel">
                        <Listeners>
                            <Click Handler="var result = confirm(MsgList.btnCancelled.confirm); if(result){
                            Coolite.AjaxMethods.CancelledItem(#{hfMainID}.getValue(),{success:function(){#{GridPanel1}.reload();#{DetailWindow}.hide(null);}},{failure: function(err) {Ext.Msg.alert(MsgList.btnCancelled.failureTitle, err);}})}" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="btnDelDraft" runat="server" Text="<%$ Resources: DetailWindow.btnDelDraft.Text %>" Icon="Cancel">
                        <Listeners>
                            <Click Handler="
                            Coolite.AjaxMethods.DeleteDraft(#{hfMainID}.getValue(),{success:function(){#{GridPanel1}.reload();#{DetailWindow}.hide(null);}},{failure: function(err) {Ext.Msg.alert(MsgList.btnDelDraft.failureTitle, err);}})" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="btnCancel" runat="server" Text="<%$ Resources: DetailWindow.btnCancel.Text %>" Icon="Cancel">
                        <Listeners>
                            <Click Handler=" Ext.Msg.confirm('Warning', '是否保存草稿?', function (e) {
                        if (e == 'yes') {
                               #{hfStatus}.setValue('Draft');      
                             var MainID = #{hfMainID}.getValue();
                         Coolite.AjaxMethods.SaveBulletin(MainID,
                        {success: function () 
                        {                          
                            #{DetailWindow}.hide();
                            #{GridPanel1}.reload();
        },
            failure: function (err) {
            Ext.Msg.alert('Error', err);
            }
        }           
                                );
								}
								else 
								{var MainID = #{hfMainID}.getValue(); 
                                Coolite.AjaxMethods.DeleteDraft(MainID,
      {success: function () 
      {
          #{DetailWindow}.hide();
          #{GridPanel1}.reload();
      },
          failure: function (err) {
              Ext.Msg.alert('Error', err);
          }
      }           );
                              
								}
								});" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
                <Listeners>
                    <BeforeHide Handler="return CheckMod();" />
                </Listeners>
            </ext:Window>
            <ext:Hidden ID="hfMainID" runat="server"></ext:Hidden>
            <ext:Hidden ID="hfStatus" runat="server"></ext:Hidden>
            <uc2:DealerSearchDialog ID="DealerSearchDialog1" runat="server" />

            <ext:Hidden ID="hiddenFileName" runat="server"></ext:Hidden>
            <ext:Window ID="AttachmentWindow" runat="server" Icon="Group" Title="上传附件" Resizable="false" Header="false"
                Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
                <Body>
                    <ext:FormPanel
                        ID="BasicForm"
                        runat="server"
                        Width="500"
                        Frame="true"
                        Header="false"
                        AutoHeight="true"
                        MonitorValid="true"
                        BodyStyle="padding: 10px 10px 0 10px;">
                        <Defaults>
                            <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                            <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                            <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                        </Defaults>
                        <Body>
                            <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="50">

                                <ext:Anchor>
                                    <ext:FileUploadField
                                        ID="FileUploadField1"
                                        runat="server"
                                        EmptyText="选择上传附件"
                                        FieldLabel="文件"
                                        ButtonText=""
                                        Icon="ImageAdd">
                                    </ext:FileUploadField>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                        <Listeners>
                            <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                        </Listeners>
                        <Buttons>
                            <ext:Button ID="SaveButton" runat="server" Text="上传附件">
                                <AjaxEvents>
                                    <Click
                                        OnEvent="UploadClick"
                                        Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');"
                                        Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });"
                                        Success="#{AttachmentPanel}.reload();#{FileUploadField1}.setValue('')">
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                            <ext:Button ID="ResetButton" runat="server" Text="清除">
                                <Listeners>
                                    <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:FormPanel>
                </Body>
                <Listeners>
                    <Hide Handler="#{AttachmentPanel}.reload();" />
                    <BeforeShow Handler="#{FileUploadField1}.setValue('');" />
                </Listeners>
            </ext:Window>
        </div>
    </form>
    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>
</body>
</html>
