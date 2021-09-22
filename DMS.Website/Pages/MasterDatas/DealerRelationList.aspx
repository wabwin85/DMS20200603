<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerRelationList.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.DealerRelationList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext"  %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
    
        <script type="text/javascript">
        var MsgList = {
			btnInsert:{
				FailureTitle:"<%=GetLocalResourceObject("plSearch.btnInsert.Alert").ToString()%>"
			},
			btnDelete:{
				confirm:"<%=GetLocalResourceObject("plSearch.btnDelete.Confirm").ToString()%>",
				SuccessTitle:"<%=GetLocalResourceObject("plSearch.btnDelete.success.Alert.Title").ToString()%>",
				SuccessMsg:"<%=GetLocalResourceObject("plSearch.btnDelete.success.Alert.Body").ToString()%>",
				FailureTitle:"<%=GetLocalResourceObject("plSearch.btnDelete.failure.Alert.Title").ToString()%>"
			},
			GridPanel1:{
				FailureTitle:"<%=GetLocalResourceObject("GridPanel1.Listeners.Alert.Title").ToString()%>"
			},
			Button1:{
				FailureTitle:"<%=GetLocalResourceObject("DetailWindow.Button1.Alert.Title").ToString()%>"
			}
        }

        function saveValidate()
        {
            var dmsId = <%=this.trRemark.ClientID%>.getValue();
            
            var remark = <%=this.trRemark.ClientID%>.getValue();
            if(remark == '')
                Ext.Msg.alert('<%=GetLocalResourceObject("saveValidate.Alert.Title").ToString()%>','<%=GetLocalResourceObject("saveValidate.Alert.Body").ToString()%>');
        }
        
        function RefreshMainPage() {
            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
        }
        
        function verifyForm()
        {
            var dealerName = <%=this.DealerName.ClientID%>.getValue();
            var relationId = <%=this.cbRelationName.ClientID%>.getValue();
            var relationName = <%=this.txtRelationName.ClientID%>.getValue();
            var remark = <%=this.trRemark.ClientID%>.getValue();
            var check = <%=this.IsDmsDealer.ClientID%>;
            
            if(check.checked)
            {
                if(dealerName == '' || relationId =='' || remark =='' )
                {
                    Ext.Msg.alert('<%=GetLocalResourceObject("verifyForm.checked.Alert.Title").ToString()%>','<%=GetLocalResourceObject("verifyForm.checked.Alert.Body").ToString()%>');
                    return false;
                }
                else if(dealerName == relationId)
                {
                    Ext.Msg.alert('<%=GetLocalResourceObject("verifyForm.checked.Alert.Title1").ToString()%>','<%=GetLocalResourceObject("verifyForm.checked.Alert.Body1").ToString()%>');
                    return false;
                }
            }
            else
            {
                if(dealerName == '' || relationName =='' || remark =='' )
                {
                    Ext.Msg.alert('<%=GetLocalResourceObject("verifyForm.Alert.Title").ToString()%>','<%=GetLocalResourceObject("verifyForm.Alert.Body").ToString()%>');
                    return false;
                }
                else if(dealerName == relationId)
                {
                    Ext.Msg.alert('<%=GetLocalResourceObject("verifyForm.Alert.Title1").ToString()%>','<%=GetLocalResourceObject("verifyForm.Alert.Body1").ToString()%>');
                    return false;
                }
            }
            return true;
        }
        </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server"></ext:ScriptManager>
        <ext:Store ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="Store1_RefershData" AutoLoad="false">
             <Proxy><ext:DataSourceProxy /></Proxy> 
             <Reader><ext:JsonReader ReaderID="Id"><Fields>
                 <ext:RecordField Name="Id" />
                 <ext:RecordField Name="DmaId" />
                 <ext:RecordField Name="DmaName" />
                 <ext:RecordField Name="DmaRelationid" />
                 <ext:RecordField Name="DmaRelationName" />
                 <ext:RecordField Name="Remark" />
                 <ext:RecordField Name="CreateUser" />
                 <ext:RecordField Name="CreateDate" />
                 <ext:RecordField Name="UpdateUser" />
                 <ext:RecordField Name="UpdateDate" />
                 <ext:RecordField Name="IsDMSDealer" />
               </Fields></ext:JsonReader></Reader>
         </ext:Store>
         <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_DealerList" AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
        </ext:Store>
         
         <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>" Frame="true" AutoHeight="true"
                        Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".25">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealerName" runat="server" EmptyText="<%$ Resources: plSearch.FormLayout1.cbDealerName.EmptyText %>" Width="150" Editable="true" TypeAhead="true"
                                                            ListWidth="300" Resizable="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName" Mode="Local"
                                                            FieldLabel="<%$ Resources:plSearch.FormLayout1.cbDealerName.FieldLabel %>">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:plSearch.FormLayout1.cbDealerName.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>

                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtDealerRelation" runat="server" FieldLabel="<%$ Resources:plSearch.FormLayout1.txtDealerRelation.FieldLabel %>"  Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="<%$ Resources:plSearch.btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{GridPanel1}.reload();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources:plSearch.btnInsert.Text %>" Icon="Add" CommandArgument=""
                                    CommandName="" IDMode="Legacy" OnClientClick="">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.Show('',{success:function(){#{DetailWindow}.show();},failure:function(err){Ext.Msg.alert(MsgList.btnInsert.FailureTitle, err);}})" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources:plSearch.btnDelete.Text %>" Icon="Delete" CommandArgument=""
                                    CommandName="" IDMode="Legacy" OnClientClick="">
                                    <Listeners>
                                        <Click Handler="var result = confirm(MsgList.btnDelete.confirm); 
                                            if ( (result) && #{GridPanel1}.hasSelection()) {
                                                Coolite.AjaxMethods.DeleteItem(
                                                    #{GridPanel1}.getSelectionModel().getSelected().id,{success:function(){RefreshMainPage();Ext.Msg.alert(MsgList.btnDelete.SuccessTitle,MsgList.btnDelete.SuccessMsg);},failure:function(err){Ext.Msg.alert(MsgList.btnDelete.FailureTitle, err);}});}" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                            
                        </ext:Panel>
                    </North>
                    
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources:GridPanel1.Title%>"
                                        StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                 <ext:Column ColumnID="DmaName" DataIndex="DmaName" Header="<%$ Resources:GridPanel1.ColumnModel1.DmaName.Header%>">
                                                 </ext:Column>
                                                 <ext:Column ColumnID="DmaRelationName" DataIndex="DmaRelationName" Header="<%$ Resources:GridPanel1.ColumnModel1.DmaRelationName.Header%>">
                                                 </ext:Column>
                                                 <ext:CheckColumn ColumnID="IsDMSDealer" DataIndex="IsDMSDealer" Header="<%$ Resources:GridPanel1.ColumnModel1.IsDMSDealer.Header%>">
                                                 </ext:CheckColumn>
                                                 <ext:Column ColumnID="Remark" DataIndex="Remark" Header="<%$ Resources:GridPanel1.ColumnModel1.Remark.Header%>">
                                                 </ext:Column>
                                                 <ext:CommandColumn Width="60" Header="<%$ Resources:GridPanel1.ColumnModel1.CommandColumn.Header%>" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="<%$ Resources:GridPanel1.ColumnModel1.GridCommand.ToolTip.Text%>" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources:GridPanel1.PagingToolBar1.EmptyMsg%>" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel1.LoadMask.Msg%>" />
                                        <Listeners>
                                            <Command Handler="Coolite.AjaxMethods.Show(record.data.Id,{success:function(){#{DetailWindow}.show();},failure:function(err){Ext.Msg.alert(MsgList.GridPanel1.FailureTitle, err);}})" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources:DetailWindow.Title%>" Width="450"
            Height="315" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false">
            <Body>
                <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn >
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="120">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtId" runat="server" FieldLabel="<%$ Resources:DetailWindow.FormLayout2.txtId.FieldLabel%>" Width="250" Hidden="true"></ext:TextField>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="DealerName" runat="server" EmptyText="<%$ Resources:DetailWindow.FormLayout2.DealerName.EmptyText%>" Width="250" Editable="true" TypeAhead="true"
                                                    ListWidth="300" Resizable="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName" Mode="Local"
                                                    FieldLabel="<%$ Resources:DetailWindow.FormLayout2.DealerName.FieldLabel%>">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:DetailWindow.FormLayout2.DealerName.FieldTrigger.Qtip%>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Checkbox ID="IsDmsDealer" runat="server" FieldLabel="<%$ Resources:DetailWindow.FormLayout2.IsDmsDealer.FieldLabel%>" >
                                                    <Listeners>
                                                        <Check Handler="Coolite.AjaxMethods.HiddenRelation();" />
                                                    </Listeners>
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbRelationName" runat="server" EmptyText="<%$ Resources:DetailWindow.FormLayout2.cbRelationName.EmptyText%>" Width="250" Editable="false" TypeAhead="true"
                                                    ListWidth="300" Resizable="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName"
                                                    FieldLabel="<%$ Resources:DetailWindow.FormLayout2.cbRelationName.FieldLabel%>">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:DetailWindow.FormLayout2.cbRelationName.FieldTrigger.Qtip%>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtRelationName" runat="server" FieldLabel="<%$ Resources:DetailWindow.FormLayout2.txtRelationName.FieldLabel%>" Width="250" >
                                                </ext:TextField>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextArea ID="trRemark" runat="server" Width="250" Height="70" FieldLabel="<%$ Resources:DetailWindow.FormLayout2.trRemark.FieldLabel%>" AllowBlank="false">
                                                </ext:TextArea>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                    
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                </ext:Panel>
            </Body>
            <Buttons>
                <ext:Button ID="Button1" runat="server" Text="<%$ Resources:DetailWindow.Button1.Text%>" Icon="Disk" IDMode="Legacy">
                    <Listeners>
                        <Click Handler="var reslut = verifyForm();if(reslut){ Coolite.AjaxMethods.SaveItem(
                            {success:function(){#{DetailWindow}.hide();RefreshMainPage();},failure:function(err){Ext.Msg.alert(MsgList.Button1.FailureTitle, err);}});}" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="butCancel" runat="server" Text="<%$ Resources:DetailWindow.butCancel.Text%>" Icon="Cancel" IDMode="Legacy" >
                    <Listeners>
                        <Click Handler="#{DetailWindow}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Hidden ID="hidDealerId" runat="server" ></ext:Hidden>
        <ext:Hidden ID="hidRelationId" runat="server" ></ext:Hidden>
        <ext:Hidden ID="hidRelationName" runat="server" ></ext:Hidden>
    </div>
    </form>
</body>
</html>
