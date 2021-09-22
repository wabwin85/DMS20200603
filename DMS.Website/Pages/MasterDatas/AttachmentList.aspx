<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AttachmentList.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.AttachmentList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>附件</title>
    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    
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
                    <ext:RecordField Name="IsCurrent" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hiddenInstanceId" runat="server"></ext:Hidden>
    <ext:Hidden ID="hiddenFolderName" runat="server"></ext:Hidden>
    <ext:Hidden ID="hiddenCanUploadFile" runat="server"></ext:Hidden>
    <ext:Hidden ID="hiddenCanDeleteFile" runat="server"></ext:Hidden>
    <ext:Hidden ID="hiddenFileName" runat="server"></ext:Hidden>
    <ext:Hidden ID="hidRtnVal" runat="server"></ext:Hidden>
    <ext:Hidden ID="hidRtnMsg" runat="server"></ext:Hidden>
    
    <ext:GridPanel ID="gpAttachment" runat="server" Title="附件列表" AutoScroll="true" Height="200" StoreID="AttachmentStore" AutoWidth="true" StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" Header="false" AutoExpandColumn="Name">
        <TopBar>
            <ext:Toolbar ID="Toolbar3" runat="server">
                <Items>
                    <ext:ToolbarFill ID="ToolbarFill3" runat="server" />
                    <ext:Button ID="btnAddAttach" runat="server" Text="添加附件" Icon="Add" StyleSpec="margin-right:15px">
                        <AjaxEvents>
                            <Click OnEvent="ShowAttachmentWindow">
                                <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{gpAttachment}.body}" />
                            </Click>
                        </AjaxEvents>
                    </ext:Button>
                </Items>
            </ext:Toolbar>
        </TopBar>
        <ColumnModel ID="ColumnModel5" runat="server">
            <Columns>
                <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                </ext:Column>
                <ext:Column ColumnID="MainId" DataIndex="MainId" Hidden="true">
                </ext:Column>
                <ext:Column ColumnID="Name" DataIndex="Name" Header="附件名称">
                </ext:Column>
                <ext:Column ColumnID="Url" DataIndex="Url" Header="路径" Hidden="true" Width="200">
                </ext:Column>
                <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="上传人" Width="200">
                </ext:Column>
                <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="上传时间" Width="100">
                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
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
            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
            </ext:RowSelectionModel>
        </SelectionModel>
        <BottomBar>
            <ext:PagingToolbar ID="PagingToolBarAttachement" runat="server" PageSize="100" StoreID="AttachmentStore" DisplayInfo="false" />
        </BottomBar>
        <SaveMask ShowMask="true" />
        <LoadMask ShowMask="true" Msg="处理中……" />
        <Listeners>
            <Command Handler="if (command == 'Delete'){
                                        if( record.data.IsCurrent == '1'){
                                            Ext.Msg.confirm('警告', '是否要删除该附件文件?',
                                                function(e) {
                                                    if (e == 'yes') {
                                                        Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                            success: function() {
                                                                Ext.Msg.alert('Message', '删除附件成功！');
                                                                #{gpAttachment}.reload();
                                                            },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                    }
                                                });
                                                
                                                }
                                                else
                                                {
                                                    Ext.Msg.alert('警告', '非当天上传文件，不允许删除');
                                                }
                                        }
                                        else if (command == 'DownLoad')
                                        {
                                            var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=ShipmentToHospital';
                                            downloadfile(url);                                                                                
                                        }
                                        
                                        " />
        </Listeners>
    </ext:GridPanel>

    <ext:Window ID="AttachmentWindow" runat="server" Icon="Group" Title="上传附件" Resizable="false" Header="false" Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
        <Body>
            <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Header="false" AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                <Defaults>
                    <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                    <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                    <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                </Defaults>
                <Body>
                    <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="50">
                        <ext:Anchor>
                            <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择上传附件" FieldLabel="文件" ButtonText="" Icon="ImageAdd">
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
                            <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{gpAttachment}.reload();#{FileUploadField1}.setValue('')">
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
            <Hide Handler="#{gpAttachment}.reload();" />
            <BeforeShow Handler="#{FileUploadField1}.setValue('');" />
        </Listeners>
    </ext:Window>
    </div>
    </form>
</body>
</html>
