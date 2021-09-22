<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PolicyAttachment.aspx.cs"
    Inherits="DMS.Website.Pages.Promotion.PolicyAttachment" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>政策附件上传</title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript" language="javascript">
      function prepareCommandDelete(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            if(record.data.UploadUser=='cbc11bd3-c91d-4e5f-840e-a5e700eed84a')
            {
                firstButton.setVisible(true);
            }else
            {
                firstButton.setVisible(false);
            }
        }
      var ClosePage=function()
        {
            window.open('','_self');
            window.close();
        }
    </script>

    <form id="form1" runat="server">
    <ext:Hidden ID="hidInstanceId" runat="server">
    </ext:Hidden>
     <ext:Hidden ID="hidType" runat="server">
    </ext:Hidden>
    <ext:Store ID="AttachmentStore" runat="server" OnRefreshData="AttachmentStore_RefreshData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Attachment" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Url" />
                    <ext:RecordField Name="Type" />
                    <ext:RecordField Name="UploadUser" />
                    <ext:RecordField Name="Identity_Name" />
                    <ext:RecordField Name="UploadDate" />
                    <ext:RecordField Name="TypeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:FormPanel ID="BasicForm" runat="server" Frame="true" Header="false" AutoHeight="true"
                        MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;" ButtonAlign="Left">
                        <Defaults>
                            <ext:Parameter Name="anchor" Value="50%" Mode="Value" />
                            <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                            <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                        </Defaults>
                        <Body>
                            <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="50">
                                <ext:Anchor>
                                    <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择文件" FieldLabel="文件"
                                        Width="500" ButtonText="" Icon="ImageAdd">
                                    </ext:FileUploadField>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                        <Listeners>
                            <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                        </Listeners>
                        <Buttons>
                            <ext:Button ID="SaveButton" runat="server" Text="上传文件">
                                <AjaxEvents>
                                    <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传文件...', '文件上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{PagingToolBar3}.changePage(1);#{FileUploadField1}.setValue(''); Ext.Msg.show({ 
                                        title   : '成功', 
                                        msg     : '上传成功', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        buttons : Ext.Msg.OK 
                                    })">
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                            <ext:Button ID="ResetButton" runat="server" Text="清除">
                                <Listeners>
                                    <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnPolicyAttachmentCancel" runat="server" Text="关闭" Icon="LorryAdd">
                                <Listeners>
                                    <Click Fn="ClosePage" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:FormPanel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="PanelAttachment" runat="server" BodyBorder="false" Header="false"
                        FormGroup="true">
                        <Body>
                            <ext:FitLayout ID="FitLayout4" runat="server">
                                <ext:GridPanel ID="GridAttachmentl" runat="server" StoreID="AttachmentStore" Border="false"
                                    Title="政策附件" Icon="Lorry" StripeRows="true" AutoScroll="true">
                                    <ColumnModel ID="ColumnModel3" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="Name" DataIndex="Name" Width="250" Header="附件名称">
                                            </ext:Column>
                                            <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Width="150" Header="上传人">
                                            </ext:Column>
                                            <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Width="90" Header="上传时间">
                                            </ext:Column>
                                            <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                        <ToolTip Text="下载" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                            <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                        <ToolTip Text="删除" />
                                                    </ext:GridCommand>
                                                </Commands>
                                                <PrepareToolbar Fn="prepareCommandDelete" />
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            #{GridAttachmentl}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });
                                                                         }if (command == 'DownLoad'){
                                                                                    var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=Promotion';
                                                                                    open(url, 'Download');
                                                                                  }  " />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="15" StoreID="AttachmentStore"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>
</body>
</html>
