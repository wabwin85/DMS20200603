<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerQAList.aspx.cs" Inherits="DMS.Website.Pages.DCM.DealerQAList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext"  %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
    <script type="text/javascript">
        var MsgList = {
			btnDelete:{
				AlertTitle:"<%=GetLocalResourceObject("DetailWindow.btnDelete.Alert.Title").ToString()%>",
				AlertMsg:"<%=GetLocalResourceObject("DetailWindow.btnDelete.Alert.Body").ToString()%>",
				FailureTitle:"<%=GetLocalResourceObject("VerifyAnswerForm.SaveItem.Failed.Alert.Title").ToString()%>",
				Confirm:"<%=GetLocalResourceObject("DetailWindow.btnDelete.Confirm").ToString()%>"
			}
        }

       var VerifyQuestionForm = function(status){
            
            if((Ext.getCmp('<%=this.cbTypeWin.ClientID%>').getValue() == "" || Ext.getCmp('<%=this.tfTitleWin.ClientID%>').getValue() == "" 
                || Ext.getCmp('<%=this.taBodyWin.ClientID%>').getValue() == "") && status == 'Submitted')
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("VerifyQuestionForm.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("VerifyQuestionForm.Alert.Body").ToString()%>');
                return;
            }
            else if(Ext.getCmp('<%=this.tfTitleWin.ClientID%>').getValue().length > 400)
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("VerifyQuestionForm.Alert.Title2").ToString()%>', '<%=GetLocalResourceObject("VerifyQuestionForm.Alert.Body2").ToString()%>');
                return;
            }
            else if(Ext.getCmp('<%=this.taBodyWin.ClientID%>').getValue().length > 2000)
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("VerifyQuestionForm.Alert.Title3").ToString()%>', '<%=GetLocalResourceObject("VerifyQuestionForm.Alert.Body3").ToString()%>');
                return;
            }
            else{
            Coolite.AjaxMethods.SaveItem(status,{success: function() {
                                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide(null);
                                            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
                                            Ext.Msg.alert('<%=GetLocalResourceObject("VerifyQuestionForm.SaveItem.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("VerifyQuestionForm.SaveItem.Alert.Body").ToString()%>');
                                        },failure: function(err) {
                                        Ext.Msg.alert('<%=GetLocalResourceObject("VerifyQuestionForm.SaveItem.Failed.Alert.Title").ToString()%>', err);
                                        }
                                        });
           }
       }
       
       var VerifyAnswerForm = function(status){
            
            if(Ext.getCmp('<%=this.taAnswerWin.ClientID%>').getValue() == "" )
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("VerifyAnswerForm.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("VerifyAnswerForm.Alert.Body").ToString()%>');
                return;
            }
            else if(Ext.getCmp('<%=this.taAnswerWin.ClientID%>').getValue().length > 2000)
            {
                Ext.Msg.alert('<%=GetLocalResourceObject("VerifyAnswerForm.Alert.Title2").ToString()%>', '<%=GetLocalResourceObject("VerifyAnswerForm.Alert.Body2").ToString()%>');
                return;
            }
            else{
            Coolite.AjaxMethods.SaveItem(status,{success: function() {
                                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide(null);
                                            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
                                            Ext.Msg.alert('<%=GetLocalResourceObject("VerifyAnswerForm.SaveItem.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("VerifyAnswerForm.SaveItem.Alert.Body").ToString()%>');
                                        },failure: function(err) {
                                        Ext.Msg.alert('<%=GetLocalResourceObject("VerifyAnswerForm.SaveItem.Failed.Alert.Title").ToString()%>', err);
                                        }
                                        });
           }
       }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server"></ext:ScriptManager>
        <ext:Store ID="ResultStore" runat="server" AutoLoad="false" OnRefreshData="ResultStore_RefreshData">
             <Proxy><ext:DataSourceProxy /></Proxy> 
             <Reader><ext:JsonReader ReaderID="Id" ><Fields>
                 <ext:RecordField Name="Id" />
                 <ext:RecordField Name="DealerId" />
                 <ext:RecordField Name="Type" />
                 <ext:RecordField Name="Status" />
                 <ext:RecordField Name="QuestionDate" />
                 <ext:RecordField Name="QuestionUserId" />
                 <ext:RecordField Name="QusetionUserName" />
                 <ext:RecordField Name="AnswerDate" />
                 <ext:RecordField Name="AnswerUserId" />
                 <ext:RecordField Name="AnswerUserName" />
                 <ext:RecordField Name="Title" />
                 <ext:RecordField Name="Body" />
                 <ext:RecordField Name="Answer" />
               </Fields></ext:JsonReader></Reader>
         </ext:Store>
         <ext:Store ID="DealerQAStatusStore" runat="server" UseIdConfirmation="true" >
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
         <ext:Store ID="DealerQATypeStore" runat="server" >
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
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" >
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
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel2" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="100">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: plSearch.Panel2.cbDealer.EmptyText %>" Width="220" Editable="true"
                                                            TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName" ListWidth="300" Resizable="true"
                                                            FieldLabel="<%$ Resources: plSearch.Panel2.cbDealer.FieldLabel %>" Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.Panel2.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfTitle" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.Panel2.tfTitle.FieldLabel %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="100">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbType" runat="server" EmptyText="<%$ Resources: plSearch.Panel4.cbType.EmptyText %>" Width="150" Editable="false" 
                                                        TypeAhead="true" Resizable="true" StoreID="DealerQATypeStore" ValueField="Key" 
                                                        DisplayField="Value"  FieldLabel="<%$ Resources: plSearch.Panel4.cbType.FieldLabel %>" >
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.Panel2.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="dfQuestionBeginDate" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.Panel4.dfQuestionBeginDate.FieldLabel %>">
                                                    </ext:DateField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="dfAnswerBeginDate" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.Panel4.dfAnswerBeginDate.FieldLabel %>">
                                                    </ext:DateField>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="100">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbStatus" runat="server" EmptyText="<%$ Resources: plSearch.Panel5.cbStatus.EmptyText %>" Width="150" Editable="false" 
                                                        TypeAhead="true" Resizable="true" StoreID="DealerQAStatusStore" ValueField="Key" 
                                                        DisplayField="Value"  FieldLabel="<%$ Resources: plSearch.Panel5.cbStatus.FieldLabel %>" >
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.Panel2.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="dfQuestionEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.Panel5.dfQuestionBeginDate.FieldLabel %>">
                                                    </ext:DateField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="dfAnswerEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.Panel5.dfAnswerBeginDate.FieldLabel %>">
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
                                        <Click Handler="#{GridPanel1}.reload();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: plSearch.btnInsert.Text %>" Icon="Add" IDMode="Legacy" >
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.Show('00000000-0000-0000-0000-000000000000',{success:function(){#{DetailWindow}.show();}});" />
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
                                        StoreID="ResultStore" Border="false" Icon="Lorry" EnableHdMenu="false" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerId" DataIndex="DealerId" Header="<%$ Resources: GridPanel1.DealerId.Header %>" Width="300">
                                                    <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Title" DataIndex="Title" Header="<%$ Resources: GridPanel1.Title.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Type" DataIndex="Type" Header="<%$ Resources: GridPanel1.Type.Header %>">
                                                    <Renderer Handler="return getNameFromStoreById(DealerQATypeStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="QusetionUserName" DataIndex="QusetionUserName" Header="<%$ Resources: GridPanel1.QusetionUserName.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Status" DataIndex="Status" Header="<%$ Resources: GridPanel1.Status.Header %>">
                                                    <Renderer Handler="return getNameFromStoreById(DealerQAStatusStore,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="QuestionDate" DataIndex="QuestionDate" Header="<%$ Resources: GridPanel1.QuestionDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="AnswerUserName" DataIndex="AnswerUserName" Header="<%$ Resources:GridPanel1.AnswerUserName.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="AnswerDate" DataIndex="AnswerDate" Header="<%$ Resources: GridPanel1.AnswerDate.Header %>">
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.CommandColumn.Header %>" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="<%$ Resources: GridPanel1.CommandColumn.ToolTip.Header %>" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="Coolite.AjaxMethods.Show(record.data.Id,{success:function(){#{DetailWindow}.show();}});" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources: GridPanel1.PagingToolBar1.EmptyMsg %>"/>
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
            Width="700" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" >
            <Body>
                <ext:FormLayout ID="FormLayout11" runat="server">
                    <ext:Anchor>
                        <ext:Panel ID="Panel6" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel7" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealerWin" runat="server" Width="200" Editable="false" TypeAhead="true"
                                                            StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName" FieldLabel="<%$ Resources: DetailWindow.Panel7.cbDealerWin.FieldLabel %>" Disabled="true"
                                                            ListWidth="300" Resizable="true" AllowBlank="false" BlankText="<%$ Resources: DetailWindow.Panel7.cbDealerWin.BlankText %>" EmptyText="<%$ Resources: DetailWindow.Panel7.cbDealerWin.EmptyText %>">
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbTypeWin" runat="server" EmptyText="<%$ Resources: DetailWindow.Panel7.cbTypeWin.EmptyText %>" Width="150" Editable="false" 
                                                            TypeAhead="true" Resizable="true" StoreID="DealerQATypeStore" ValueField="Key" 
                                                            DisplayField="Value"  FieldLabel="<%$ Resources: DetailWindow.Panel7.cbTypeWin.FieldLabel %>" AllowBlank="false" >
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.Panel2.FieldTrigger.Qtip %>" />
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
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel8" runat="server" Border="false" >
                                            <Body>
                                                <ext:FormLayout ID="FormLayout5" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfQuestionDateWin" runat="server" Width="150"  FieldLabel="<%$ Resources: DetailWindow.Panel8.tfQuestionDateWin.FieldLabel%>" Disabled="true" >
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfStatusWin" runat="server" Width="150"  FieldLabel="<%$ Resources: DetailWindow.Panel8.tfStatusWin.FieldLabel %>" Disabled="true" >
                                                        </ext:TextField>
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
                        <ext:Panel ID="Panel9" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                    <ext:LayoutColumn>
                                        <ext:Panel ID="Panel10" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfTitleWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.Panel10.tfTitleWin.FieldLabel %>" Width="390" AllowBlank="false" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextArea ID="taBodyWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.Panel10.taBodyWin.FieldLabel %>" AllowBlank="false"
                                                            Width="390" Height="120" >
                                                        </ext:TextArea>
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
                        <ext:Panel ID="Panel11" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;" >
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                    <ext:LayoutColumn>
                                        <ext:Panel ID="AnswerPanel" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: DetailWindow.Panel11.AnswerPanel.Title %>" BodyStyle="padding:5px;" >
                                            <Body>
                                                <ext:FormLayout ID="FormLayout7" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextArea ID="taAnswerWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.Panel11.AnswerPanel.Title %>" AllowBlank="false"
                                                            Width="390" Height="120" >
                                                        </ext:TextArea>
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
                <ext:Button ID="btnReplied" runat="server" Text="<%$ Resources: DetailWindow.btnReplied.Text %>" Icon="Disk" >
                    <Listeners>
                        <Click Handler="VerifyAnswerForm('Replied');" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnSubmit" runat="server" Text="<%$ Resources: DetailWindow.btnSubmit.Text %>" Icon="Disk" >
                    <Listeners>
                        <Click Handler="VerifyQuestionForm('Submitted');" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnSave" runat="server" Text="<%$ Resources: DetailWindow.btnSave.Text %>" Icon="Disk" >
                    <Listeners>
                        <Click Handler="VerifyQuestionForm('Draft');" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: DetailWindow.btnDelete.Text %>" Icon="Delete">
                    <Listeners>
                        <Click Handler="var result = confirm(MsgList.btnDelete.Confirm); 
                            if(result){Coolite.AjaxMethods.DeleteItem({success:function(){#{DetailWindow}.hide(null);#{GridPanel1}.reload();Ext.Msg.alert(MsgList.btnDelete.AlertTitle,MsgList.btnDelete.AlertMsg);}},
                            {failure: function(err) {Ext.Msg.alert(MsgList.btnDelete.FailureTitle, err);}})}" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnCancel" runat="server" Text="<%$ Resources: DetailWindow.btnCancel.Text %>" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{DetailWindow}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Hidden ID="hidId" runat="server"></ext:Hidden>
    </div>
    </form>
</body>
</html>
