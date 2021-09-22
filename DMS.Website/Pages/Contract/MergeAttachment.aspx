<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MergeAttachment.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.MergeAttachment" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .x-form-group .x-form-group-header-text
        {
            background-color: #dfe8f6;
            color: Black;
        }
        .x-form-group .x-form-group-header
        {
            padding: 10px;
            border-bottom: 2px solid #99bbe8;
        }
    </style>

    <script type="text/javascript">
        var CountrySelector = {
            add: function(source, destination) {
                source = source || gpAttachment;
                destination = destination || gpMergeFile;
                if (source.hasSelection()) {
                    destination.store.add(source.selModel.getSelections());
                    //source.deleteSelected();
                    source.getSelectionModel().clearSelections();
                }
            },
            addAll: function(source, destination) {
                source = source || gpAttachment;
                destination = destination || gpMergeFile;
                destination.store.add(source.store.getRange());
                //source.store.removeAll();
                source.getSelectionModel().clearSelections();
            },
            remove: function(source, destination) {
                //this.add(destination, source);
                gpMergeFile.deleteSelected();
            },
            removeAll: function(source, destination) {
                //this.addAll(destination, source);
                gpMergeFile.store.removeAll();
            },
            up: function(grid) {
                var record = grid.getSelectionModel().getSelected();
                if (record) {
                    var index = grid.store.indexOf(record);
                    if (index > 0) {
                        grid.store.removeAt(index);
                        grid.store.insert(index - 1, record);
                        grid.getView().refresh(); // refesh the row number
                        grid.getSelectionModel().selectRow(index - 1);
                    }
                }
            },
            down: function(grid) {
                var record = grid.getSelectionModel().getSelected();
                if (record) {
                    var index = grid.store.indexOf(record);
                    if (index < grid.store.getCount() - 1) {
                        grid.store.removeAt(index);
                        grid.store.insert(index + 1, record);
                        grid.getView().refresh(); // refesh the row number
                        grid.getSelectionModel().selectRow(index + 1);
                    }
                }
            }
        };

        function GetStoreAllRecord(grid) {
            var store = grid.getStore();
            var currenIds = "";
            var fileName = "";
            var fileType = "";
            var gpAttachment = Ext.getCmp('<%=this.gpAttachment.ClientID%>');
            var record;
            for (var i = 0; i < store.getCount(); i++) {
                record = store.getAt(i);
                currenIds = currenIds + record.id + ";";
                fileName = record.data.Name;
                fileType = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                if (fileType != "pdf") {
                    Ext.Msg.alert("Error", "要合并的文件必须都为pdf文件!");
                    return;
                }
            }
            if (currenIds.length > 0) {
                currenIds = currenIds.substring(0, currenIds.length - 1);
                Coolite.AjaxMethods.MergePdf(currenIds, { success: function() { gpAttachment.reload(); gpAttachment.getSelectionModel().clearSelections(); }, failure: function(err) { Ext.Msg.alert('Error', err); } });
            } else {
                Ext.Msg.alert("Error", "PDF合并区域中没有任何记录!");
            }
        }

        function prepareCommand(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            var contextUserId = Ext.getCmp('<%=this.hdContextUserId.ClientID%>');
            var loginRole = Ext.getCmp('<%=this.hdLoginRole.ClientID%>');
            var operationStates = Ext.getCmp('<%=this.hdOperationStates.ClientID%>');

            if ((contextUserId.getValue().toLowerCase() == record.data.UploadUser.toLowerCase() || loginRole.getValue() == '渠道管理员') && operationStates.getValue() != 'readonly') {
                firstButton.setVisible(true);
            } else {
                firstButton.setVisible(false);
            }
        }
        
    </script>

</head>
<body>
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <ext:Hidden ID="hdCmId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdContractId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdParmetType" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdDealerType" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdContractStatus" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdSystemCreateAttachment" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdLoginRole" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdOperationStates" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdContextUserId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidEditItemId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidAttachmentName" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidProductLimeId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidMarketType" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hdContractType" runat="server">
    </ext:Hidden>
    <form id="form1" runat="server">
    <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshAttachment">
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
    <ext:Store ID="MergeFileStore" runat="server" AutoLoad="false">
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
    <ext:Store ID="FileTypeStore" runat="server" OnRefreshData="FileTypeStore_RefreshData"
        AutoLoad="true">
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
    </ext:Store>
    <div>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <Center>
                        <ext:Panel ID="plAttachment" runat="server" Title="附件上传" Frame="True" Icon="Application"
                            AutoHeight="True" AutoScroll="True" IDMode="Legacy">
                            <Body>
                                <ext:GridPanel ID="gpAttachment" runat="server" StoreID="AttachmentStore" Header="false"
                                    Border="true" Icon="Lorry" StripeRows="true" Height="400">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar7" runat="server">
                                            <Items>
                                                <ext:ToolbarFill />
                                                <ext:Button ID="btnRefer" runat="server" Text="刷新" Icon="Add">
                                                    <Listeners>
                                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="btnAddAttachment" runat="server" Text="上传附件" Icon="Add">
                                                    <Listeners>
                                                        <Click Handler="#{windowAttachment}.show();" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="btnConvertPdf" runat="server" Text="转换为PDF" Icon="PageWhiteAcrobat">
                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.ConvertPdf({success: function(){#{gpAttachment}.reload();#{gpAttachment}.getSelectionModel().clearSelections();},failure: function(err){alert(err);}});" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                    <ColumnModel ID="ColumnModel8" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="Name" DataIndex="Name" Width="200" Header="附件名称">
                                            </ext:Column>
                                            <ext:Column ColumnID="TypeName" DataIndex="TypeName" Header="附件类型" Width="125">
                                            </ext:Column>
                                            <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Width="90" Header="上传人">
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
                                            <ext:CommandColumn Width="50" Header="修改" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="修改" />
                                                    </ext:GridCommand>
                                                </Commands>
                                                <PrepareToolbar Fn="prepareCommand" />
                                            </ext:CommandColumn>
                                            <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                        <ToolTip Text="删除" />
                                                    </ext:GridCommand>
                                                </Commands>
                                                <PrepareToolbar Fn="prepareCommand" />
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="AttachmentStore"
                                            DisplayInfo="true" EmptyMsg="没有数据显示" />
                                    </BottomBar>
                                    <Listeners>
                                        <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该下载文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            #{gpAttachment}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });
                                                                    }
                                                                    else if (command == 'Edit')
                                                                    {
                                                                        #{tfWinAttachId}.setValue(record.data.Id);
                                                                        Coolite.AjaxMethods.ShowAttachInfo({success: function(){#{winAttachInfo}.show();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                    }
                                                                    else if (command == 'DownLoad')
                                                                    {
                                                                        var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=dcms';
                                                                        open(url, 'Download');
                                                                    }
                                                                    " />
                                    </Listeners>
                                    <LoadMask ShowMask="true" Msg="处理中..." />
                                </ext:GridPanel>
                            </Body>
                            <LoadMask ShowMask="True" Msg="处理中..." />
                        </ext:Panel>
                    </Center>
                    <East Collapsible="True" Split="True" MinWidth="570px" MaxWidth="570px">
                        <ext:Panel ID="pnlEast" runat="server" Title="PDF合并操作区域" Frame="True" Icon="Application"
                            AutoHeight="True" AutoScroll="True" Width="550px" IDMode="Legacy">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn>
                                        <ext:Panel ID="Panel3" runat="server" Width="35" Height="400" BodyStyle="background-color: transparent;"
                                            Border="false">
                                            <Body>
                                                <ext:AnchorLayout ID="AnchorLayout1" runat="server">
                                                    <ext:Anchor Vertical="40%">
                                                        <ext:Panel ID="Panel1" runat="server" Border="false" BodyStyle="background-color: transparent;" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel2" runat="server" Border="false" BodyStyle="padding:5px;background-color: transparent;">
                                                            <Body>
                                                                <ext:Button ID="Button1" runat="server" Icon="ArrowUp" StyleSpec="margin-bottom:2px;">
                                                                    <Listeners>
                                                                        <Click Handler="CountrySelector.up(gpMergeFile);" />
                                                                    </Listeners>
                                                                    <ToolTips>
                                                                        <ext:ToolTip ID="ToolTip5" runat="server" Title="Remove all" Html="Remove All Rows" />
                                                                    </ToolTips>
                                                                </ext:Button>
                                                                <ext:Button ID="Button2" runat="server" Icon="ArrowDown" StyleSpec="margin-bottom:2px;">
                                                                    <Listeners>
                                                                        <Click Handler="CountrySelector.down(gpMergeFile);" />
                                                                    </Listeners>
                                                                    <ToolTips>
                                                                        <ext:ToolTip ID="ToolTip6" runat="server" Title="Remove all" Html="Remove All Rows" />
                                                                    </ToolTips>
                                                                </ext:Button>
                                                                <ext:Panel ID="Panel4" runat="server" Border="false" Height="20" BodyStyle="background-color: transparent;" />
                                                                <ext:Button ID="btnResultAdd" runat="server" Icon="ResultsetNext" StyleSpec="margin-bottom:2px;">
                                                                    <Listeners>
                                                                        <Click Handler="CountrySelector.add();" />
                                                                    </Listeners>
                                                                    <ToolTips>
                                                                        <ext:ToolTip ID="ToolTip1" runat="server" Title="Add" Html="Add Selected Rows" />
                                                                    </ToolTips>
                                                                </ext:Button>
                                                                <ext:Button ID="btnResultAddAll" runat="server" Icon="ResultsetLast" StyleSpec="margin-bottom:2px;">
                                                                    <Listeners>
                                                                        <Click Handler="CountrySelector.addAll();" />
                                                                    </Listeners>
                                                                    <ToolTips>
                                                                        <ext:ToolTip ID="ToolTip2" runat="server" Title="Add all" Html="Add All Rows" />
                                                                    </ToolTips>
                                                                </ext:Button>
                                                                <ext:Button ID="btnResultRemove" runat="server" Icon="ResultsetPrevious" StyleSpec="margin-bottom:2px;">
                                                                    <Listeners>
                                                                        <Click Handler="CountrySelector.remove(gpAttachment, gpMergeFile);" />
                                                                    </Listeners>
                                                                    <ToolTips>
                                                                        <ext:ToolTip ID="ToolTip3" runat="server" Title="Remove" Html="Remove Selected Rows" />
                                                                    </ToolTips>
                                                                </ext:Button>
                                                                <ext:Button ID="btnResultRemoveAll" runat="server" Icon="ResultsetFirst" StyleSpec="margin-bottom:2px;">
                                                                    <Listeners>
                                                                        <Click Handler="CountrySelector.removeAll(gpAttachment, gpMergeFile);" />
                                                                    </Listeners>
                                                                    <ToolTips>
                                                                        <ext:ToolTip ID="ToolTip4" runat="server" Title="Remove all" Html="Remove All Rows" />
                                                                    </ToolTips>
                                                                </ext:Button>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:Anchor>
                                                </ext:AnchorLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn>
                                        <ext:GridPanel ID="gpMergeFile" runat="server" StoreID="MergeFileStore" Header="false"
                                            EnableHdMenu="false" Border="false" Icon="Lorry" StripeRows="true" Height="400"
                                            EnableDragDrop="true" HideParent="true">
                                            <TopBar>
                                                <ext:Toolbar ID="Toolbar1" runat="server">
                                                    <Items>
                                                        <ext:ToolbarFill />
                                                        <ext:Button ID="btnMergePdf" runat="server" Text="合并PDF" Icon="PageWhiteAcrobat">
                                                            <Listeners>
                                                                <Click Handler="GetStoreAllRecord(#{gpMergeFile});" />
                                                            </Listeners>
                                                        </ext:Button>
                                                    </Items>
                                                </ext:Toolbar>
                                            </TopBar>
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="150" Header="附件名称" Sortable="false">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TypeName" DataIndex="TypeName" Header="附件类型" Width="150" Sortable="false">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Width="90" Header="上传人"
                                                        Sortable="false">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Width="90" Header="上传时间"
                                                        Sortable="false">
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <LoadMask ShowMask="true" Msg="处理中..." />
                                        </ext:GridPanel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                    </East>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <%-- 附件 --%>
        <ext:Hidden ID="hiddenWinFileName" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowAttachment" runat="server" Icon="Group" Title="上传附件" Resizable="false"
            Header="false" Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="AttachmentForm" runat="server" Width="500" Frame="true" Header="false"
                    AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="120">
                            <ext:Anchor>
                                <ext:ComboBox ID="cbFileType" runat="server" EmptyText="请选择上传文件类型" Editable="false"
                                    TypeAhead="true" StoreID="FileTypeStore" ValueField="Key" Mode="Local" DisplayField="Value"
                                    FieldLabel="文件类型" Resizable="true">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择上传附件" FieldLabel="文件"
                                    ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{btnWinAttachmentSubmit}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="btnWinAttachmentSubmit" runat="server" Text="上传附件">
                            <AjaxEvents>
                                <Click OnEvent="UploadClick" Before="if(!#{AttachmentForm}.getForm().isValid()) { return false; } 
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
                                <Click Handler="#{AttachmentForm}.getForm().reset();#{btnWinAttachmentSubmit}.setDisabled(true);" />
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
        <ext:Window ID="winAttachInfo" runat="server" Icon="Group" Title="附件信息" Resizable="false"
            Header="false" Width="500" Height="175" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout22" runat="server">
                    <ext:Anchor>
                        <ext:Panel ID="Panel40" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout13" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel41" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout23" runat="server" LabelWidth="120">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinAttachId" runat="server" FieldLabel="Id" Hidden="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinAttachFileType" runat="server" FieldLabel="FileType" Hidden="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinAttachType" runat="server" FieldLabel="AttachType" Hidden="true">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfWinAttachName" runat="server" FieldLabel="附件名称" Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbWinAttachType" runat="server" EmptyText="请选择上传文件类型" TypeAhead="true"
                                                            StoreID="FileTypeStore" ValueField="Key" DisplayField="Value" FieldLabel="文件类型"
                                                            Resizable="true" Width="220">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="dfWinUploadDate" runat="server" FieldLabel="上传时间" Disabled="true">
                                                        </ext:DateField>
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
                <ext:Button ID="btnWinSave" runat="server" Icon="Disk" Text="保存">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.UpdateAttachmentName({success:function(){#{gpAttachment}.reload();#{winAttachInfo}.hide();},failure:function(err){Ext.Msg.alert('Error',err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnWinCancel" runat="server" Icon="Delete" Text="取消">
                    <Listeners>
                        <Click Handler="#{winAttachInfo}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <Hide Handler="#{gpAttachment}.reload();" />
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
