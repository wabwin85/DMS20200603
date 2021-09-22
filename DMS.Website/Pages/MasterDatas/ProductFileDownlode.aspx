<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductFileDownlode.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.ProductFileDownlode" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript">

        function refreshTree(tree) {
            Coolite.AjaxMethods.RefreshTrees({
                success: function(result) {
                    var nodes = eval(result);
                    if (tree.root != null)
                        tree.root.ui.remove();
                    tree.initChildren(nodes);

                    if (tree.root != null)
                        tree.root.render();
                }
            });
        }
        
        function getSelectedlevelID(selNode) {

            if (selNode == null) return null;
            
            return selNode.id;
        }
        
    </script>

    <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="false"
        OnRefreshData="AttachmentStore_Refresh">
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
    <ext:Store ID="UseManualStore" runat="server" UseIdConfirmation="false" AutoLoad="false"
        OnRefreshData="UseManualStore_Refresh">
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
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <West Collapsible="True" Split="True">
                    <ext:Panel runat="server" Title="<%$ Resources: ctl701.Title %>" Width="250px" BodyBorder="False" ID="ctl701"
                        IDMode="Legacy">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:TreePanel ID="TreePanel1" runat="server" AutoScroll="true" BodyStyle="padding-left:10px">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar1" runat="server">
                                            <Items>
                                                <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                <ext:ToolbarButton ID="ToolbarRefresh" runat="server" Icon="ArrowRefreshSmall">
                                                    <Listeners>
                                                        <Click Handler="refreshTree(#{TreePanel1})" />
                                                    </Listeners>
                                                    <ToolTips>
                                                        <ext:ToolTip ID="ToolTip3" IDMode="Ignore" runat="server" Html="<%$ Resources: ctl701.TreePanel1.ToolTip3.Html %>" />
                                                    </ToolTips>
                                                </ext:ToolbarButton>
                                                <ext:ToolbarButton ID="ToolbarButton1" runat="server" IconCls="icon-expand-all">
                                                    <Listeners>
                                                        <Click Handler="#{TreePanel1}.root.expand(true);" />
                                                    </Listeners>
                                                    <ToolTips>
                                                        <ext:ToolTip ID="ToolTip1" IDMode="Ignore" runat="server" Html="<%$ Resources: ctl701.TreePanel1.ToolTip2.Html %>" />
                                                    </ToolTips>
                                                </ext:ToolbarButton>
                                                <ext:ToolbarButton ID="ToolbarButton2" runat="server" IconCls="icon-collapse-all">
                                                    <Listeners>
                                                        <Click Handler="#{TreePanel1}.root.collapse(true);" />
                                                    </Listeners>
                                                    <ToolTips>
                                                        <ext:ToolTip ID="ToolTip2" IDMode="Ignore" runat="server" Html="<%$ Resources: ctl701.TreePanel1.ToolTip1.Html %>" />
                                                    </ToolTips>
                                                </ext:ToolbarButton>
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                    <Root>
                                        <ext:TreeNode Text="Synthes" Icon="FolderHome">
                                        </ext:TreeNode>
                                    </Root>
                                    <AjaxEvents>
                                        <Click OnEvent="SelectedNodeClick" Success="var selNode = node;  #{AttachmentPanel}.reload(); #{UseManualPanel}.reload(); ">
                                            <ExtraParams>
                                                <ext:Parameter Name="selectedlevelID" Value="getSelectedlevelID(node)" Mode="Raw" />
                                            </ExtraParams>
                                        </Click>
                                    </AjaxEvents>
                                </ext:TreePanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </West>
                <Center>
                    <ext:Panel ID="Panel2" runat="server" Title="" Frame="true" Header="false" Icon="Information">
                        <Body>
                            <ext:BorderLayout ID="BorderLayout2" runat="server">
                                <North MarginsSummary="0 0 0 0">
                                    <ext:Panel ID="Panel5" runat="server" Title="<%$ Resources: Panel.Grid %>" Icon="Information" Collapsible="true"
                                        Height="260">
                                        <Body>
                                            <ext:FitLayout ID="FitLayout2" runat="server">
                                                <ext:GridPanel ID="AttachmentPanel" runat="server" StoreID="AttachmentStore" Border="false"
                                                    Icon="Lorry" AutoScroll="true" EnableHdMenu="false" Header="false" StripeRows="true">
                                                    <ColumnModel ID="ColumnModel3" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="MainId" DataIndex="MainId" Hidden="true">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources: AttachmentPanel.Head.AnnexName %>" Width="200">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Url" DataIndex="Url" Header="<%$ Resources: AttachmentPanel.Head.URL %>" Hidden="true">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="<%$ Resources: AttachmentPanel.Head.User %>">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="<%$ Resources: AttachmentPanel.Head.Time %>">
                                                            </ext:Column>
                                                            <ext:CommandColumn Width="50" Header="<%$ Resources: AttachmentPanel.Head.DownLoad %>" Align="Center">
                                                                <Commands>
                                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad" ToolTip-Text="<%$ Resources: AttachmentPanel.Head.DownLoad %>" />
                                                                </Commands>
                                                            </ext:CommandColumn>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="10" StoreID="AttachmentStore"
                                                            DisplayInfo="true" EmptyMsg="<%$ Resources: Grid.Page.NoData %>" />
                                                    </BottomBar>
                                                    <SaveMask ShowMask="true" />
                                                    <LoadMask ShowMask="true" Msg="<%$ Resources: Grid.Processing %>" />
                                                    <Listeners>
                                                        <Command Handler="if (command == 'DownLoad')
                                                                        {
                                                                            var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url);
                                                                            open(url, 'Download');
                                                                        }" />
                                                    </Listeners>
                                                </ext:GridPanel>
                                            </ext:FitLayout>
                                        </Body>
                                    </ext:Panel>
                                </North>
                                <Center MarginsSummary="0 0 0 0">
                                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel.UseManualPanel.Grid %>" Icon="Information" Collapsible="true"
                                        Height="260">
                                        <Body>
                                            <ext:FitLayout ID="FitLayout3" runat="server">
                                                <ext:GridPanel ID="UseManualPanel" runat="server" StoreID="UseManualStore" Header="false"
                                                    Border="false" Icon="Lorry" AutoScroll="true" EnableHdMenu="false" StripeRows="true">
                                                    <ColumnModel ID="ColumnModel1" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="MainId" DataIndex="MainId" Hidden="true">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources: UseManualPanel.Head.AnnexName %>" Width="200">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Url" DataIndex="Url" Header="<%$ Resources: UseManualPanel.Head.URL %>" Hidden="true">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="<%$ Resources: UseManualPanel.Head.User %>">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="<%$ Resources: UseManualPanel.Head.Time %>">
                                                            </ext:Column>
                                                            <ext:CommandColumn Width="50" Header="<%$ Resources: UseManualPanel.Head.DownLoad %>" Align="Center">
                                                                <Commands>
                                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad" ToolTip-Text="<%$ Resources: UseManualPanel.Head.DownLoad %>" />
                                                                </Commands>
                                                            </ext:CommandColumn>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="UseManualStore"
                                                            DisplayInfo="true" EmptyMsg="<%$ Resources: Grid.Page.NoData %>" />
                                                    </BottomBar>
                                                    <SaveMask ShowMask="true" />
                                                    <LoadMask ShowMask="true" Msg="<%$ Resources: Grid.Processing %>" />
                                                    <Listeners>
                                                        <Command Handler="if (command == 'DownLoad')
                                                                        {
                                                                            var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url);
                                                                            open(url, 'Download');
                                                                        }" />
                                                    </Listeners>
                                                </ext:GridPanel>
                                            </ext:FitLayout>
                                        </Body>
                                    </ext:Panel>
                                </Center>
                            </ext:BorderLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Hidden ID="hiddenSelectedlevelID" runat="server">
    </ext:Hidden>
    </form>
</body>
</html>
