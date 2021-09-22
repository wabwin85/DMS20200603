<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IssuesList.aspx.cs" Inherits="DMS.Website.Pages.DCM.IssuesList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext"  %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
    <script type="text/javascript">
        var MsgList = {
			btnSave:{
				Alert1Title:"<%=GetLocalResourceObject("DetailWindow.btnSave.Alert.Title").ToString()%>",
				Alert1Msg:"<%=GetLocalResourceObject("DetailWindow.btnSave.Alert.Body").ToString()%>",
				Alert2Title:"<%=GetLocalResourceObject("DetailWindow.btnSave.Alert.Title").ToString()%>",
				Alert2Msg:"<%=GetLocalResourceObject("DetailWindow.btnSave.taQuestion.Alert.Body").ToString()%>",
				Alert3Title:"<%=GetLocalResourceObject("DetailWindow.btnSave.Alert.Title").ToString()%>",
				Alert3Msg:"<%=GetLocalResourceObject("DetailWindow.btnSave.taAnswer.Alert.Body").ToString()%>"
			},
			btnDelete:{
				Confirm:"<%=GetLocalResourceObject("DetailWindow.btnDelete.Confirm").ToString()%>"
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
                 <ext:RecordField Name="Question" />
                 <ext:RecordField Name="Answer" />
                 <ext:RecordField Name="SortNo" />
                 <ext:RecordField Name="DeleteFlag" />
               </Fields></ext:JsonReader></Reader>
         </ext:Store>
         <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="false" OnRefreshData="AttachmentStore_Refresh">
            <Proxy><ext:DataSourceProxy /></Proxy> 
            <Reader><ext:JsonReader><Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Attachment" />
                <ext:RecordField Name="Name" />
                <ext:RecordField Name="Url" />
                <ext:RecordField Name="Type" />
                <ext:RecordField Name="UploadUser" />
                <ext:RecordField Name="Identity_Name" />
                <ext:RecordField Name="UploadDate" />
            </Fields></ext:JsonReader></Reader>
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
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfKeyWords" runat="server" Width="150" FieldLabel="<%$ Resources: plSearch.tfKeyWords.FieldLabel %>" />
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
                                        <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                         <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnImport" runat="server" Text="<%$ Resources: plSearch.btnImport.Text %>" Icon="Add" IDMode="Legacy" >
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.Show('00000000-0000-0000-0000-000000000000','New',{success:function(){#{PagingToolBar3}.changePage(1);#{DetailWindow}.show();}})" />
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
                                                <ext:Column ColumnID="SortNo" DataIndex="SortNo" Header="<%$ Resources: GridPanel1.ColumnModel1.SortNo.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Question" DataIndex="Question" Header="<%$ Resources: GridPanel1.ColumnModel1.Question.Header %>" Width="300">
                                                </ext:Column>
                                                <ext:Column ColumnID="Answer" DataIndex="Answer" Header="<%$ Resources: GridPanel1.ColumnModel1.Answer.Header %>" Width="300">
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.ToolTip.Text %>" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="Coolite.AjaxMethods.Show(record.data.Id,'Modify',{success:function(){#{DetailWindow}.show();#{PagingToolBar3}.changePage(1);}});" />
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
            Width="600" Height="380" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" >
            <Body>
                <ext:FitLayout ID="FitLayout2" runat="server">
                    <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Border="false" AutoScroll="true" >
                        <Tabs>
                            <ext:Tab ID="Tab1" runat="server" Title="政策内容" Icon="ChartOrganisation" Border="false" >
                                <Body>
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false" BodyStyle="padding:5px;" >
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="100">
                                                <ext:Anchor>
                                                    <ext:TextArea ID="taQuestion" runat="server" FieldLabel="<%$ Resources: GridPanel1.ColumnModel1.Question.Header %>" 
                                                        AllowBlank="false" Height="60" Width="300" >
                                                    </ext:TextArea>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextArea ID="taAnswer" runat="server" FieldLabel="<%$ Resources: GridPanel1.ColumnModel1.Answer.Header %>"
                                                        AllowBlank="false" Height="155" Width="390" >
                                                    </ext:TextArea>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:NumberField ID="nfSortNo" runat="server" FieldLabel="<%$ Resources: GridPanel1.ColumnModel1.SortNo.Header %>"
                                                         Width="70">
                                                    </ext:NumberField>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel> 
                                </body>
                            </ext:Tab>
                            <ext:Tab ID="Tab2" runat="server" Title="附件" Icon="BrickLink" >
                                <Body>
                                    <ext:FormLayout ID="FormLayout7" runat="server">
                                        <ext:Anchor>
                                            <ext:Panel ID="Panel9" runat="server" Border="false" Header="false" >
                                                <Body>
                                                    <ext:GridPanel ID="AttachmentPanel" runat="server" Title="附件列表" StoreID="AttachmentStore" 
                                                        Border="false" Icon="Lorry" Height="340" Width="576" AutoScroll="true" EnableHdMenu="false"  StripeRows="true" >
                                                        <TopBar>
                                                            <ext:Toolbar ID="Toolbar2" runat="server" >
                                                                <Items>
                                                                    <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                                    <ext:Button ID="btnAddAttach" runat="server" Text="添加附件" Icon="Add">
                                                                        <Listeners>
                                                                            <Click Handler="AttachmentWindow.show();"/>
                                                                        </Listeners>
                                                                    </ext:Button>
                                                                </Items>
                                                            </ext:Toolbar>
                                                        </TopBar>
                                                        <ColumnModel ID="ColumnModel3" runat="server" >
                                                            <Columns>
                                                                 <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true" >
                                                                 </ext:Column>
                                                                 <ext:Column ColumnID="MainId" DataIndex="MainId" Hidden="true" >
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
                                                                DisplayInfo="true" EmptyMsg="<%$ Resources: GridPanel1.PagingToolBar1.EmptyMsg %>" />
                                                        </BottomBar>
                                                        <SaveMask ShowMask="true" />
                                                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
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
                <ext:Button ID="btnSave" runat="server" Text="<%$ Resources: DetailWindow.btnSave.text %>" Icon="Disk" >
                    <Listeners>
                        <Click Handler="if(#{taQuestion}.getValue().trim()=='' || #{taAnswer}.getValue().trim()=='' ) {Ext.Msg.alert(MsgList.btnSave.Alert1Title,MsgList.btnSave.Alert1Msg);}
                            else if(#{taQuestion}.getValue().length &gt; 400 ) {Ext.Msg.alert(MsgList.btnSave.Alert2Title,MsgList.btnSave.Alert2Msg);}
                            else if(#{taAnswer}.getValue().length &gt; 2000 ) {Ext.Msg.alert(MsgList.btnSave.Alert3Title,MsgList.btnSave.Alert3Msg);}
                            else{Coolite.AjaxMethods.SaveItem({success:function(){#{GridPanel1}.reload();#{DetailWindow}.hide(null);}});}" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: DetailWindow.btnDelete.Text %>" Icon="Delete">
                    <Listeners>
                        <Click Handler="var result = confirm(MsgList.btnDelete.Confirm); 
                            if(result){Coolite.AjaxMethods.DeleteItem(#{hfId}.getValue(),{success:function(){#{GridPanel1}.reload();#{DetailWindow}.hide(null);}});}" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnCancel" runat="server" Text="<%$ Resources: DetailWindow.btnCancel.Text %>" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{DetailWindow}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Hidden ID="hfSortNo" runat="server" ></ext:Hidden>
        <ext:Hidden ID="hfId" runat="server" ></ext:Hidden>
        <ext:Hidden ID="hidIsDealer" runat="server" ></ext:Hidden>
        <ext:Hidden ID="hfStatus" runat="server" ></ext:Hidden>
        
        <ext:Hidden ID="hiddenFileName" runat="server"></ext:Hidden>
        <ext:Window ID="AttachmentWindow" runat="server" Icon="Group" Title="上传附件" Resizable="false" Header="false" 
            Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" >
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
                                    Success="#{AttachmentPanel}.reload();#{FileUploadField1}.setValue('')"
                                    >
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
            </body>
            <Listeners>
                <Hide Handler="#{AttachmentPanel}.reload();" />
                <BeforeShow Handler="#{FileUploadField1}.setValue('');" />
            </Listeners>
        </ext:Window>
    </div>
    </form>
</body>
</html>
