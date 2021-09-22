<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TerritoryList.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.TerritoryList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../../Controls/TerritoryEditor.ascx" TagName="TerritoryEditor"
    TagPrefix="uc1" %>
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
        var tlMsgList = {
            msg1:"<%=GetLocalResourceObject("contextMenu1.menuDelete.confirm").ToString()%>"
        }
        //刷新父窗口查询结果
        function RefreshMainPage() {
            Ext.getCmp('<%=this.TreePanel1.ClientID%>').reload();
        }

        //页面打开时加载树
        function refreshTree(tree) {

            Coolite.AjaxMethods.RefreshLines({
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

        var selectNode = null;

        var selectTreeNode = function(node, e) {
            //debugger;
            if (node.parentNode != null) {
                e.stopEvent();
                selectNode = node;
            }
            else {
                selectNode = null;
            }
        }


        function createPartsWindow() {

            var tree = Ext.getCmp("TreePanel1");
            var parentNode = tree.getSelectionModel().getSelectedNode();

            var nodeconfig = new Ext.tree.TreeNode({ text: "新建分类" });
            var node = tree.createNode(nodeconfig);
            parentNode.appendChild(node);

            var lineid = tree.root.id;
            createPartsDetails(node, lineid);
        }

        function openPartsWindow() {
            var tree = Ext.getCmp("TreePanel1");
            var node = tree.getSelectionModel().getSelectedNode();

            var lineid = tree.root.id;

            if (node.parentNode != null)
                openPartsDetails(node, lineid);
        }


        function getSelectedCatagory(selNode) {
            //modified by bozhenfei 去掉只能叶子分类维护的限制
            if (selNode == null) return null;

            if (selNode.childNodes != null && selNode.childNodes.length > 0) {
                return null;
            }
            else
                var tree = Ext.getCmp("TreePanel1");
            if (tree.root == selNode) {
                return null;
            }


            return selNode.id;
        }




        var showTerritorySearchDlg = function() {

            Ext.getCmp("txtWinCode").setValue("");
            Ext.getCmp("txtWinName").setValue("");
            Ext.getCmp("cbWinDistribution").clearValue();
            Ext.getCmp("GridTerritoryEditor").clear();
            Ext.getCmp("TerritoryEditorWindow").show();

        }

        var AddTerritory = function(grid) {
        var result = confirm('<%=GetLocalResourceObject("Add.result.confirm").ToString()%>');
            if (result) {
                if (grid.hasSelection()) {
                    var selList = grid.selModel.getSelections();
                    var param = '';
                    for (var i = 0; i < selList.length; i++) {
                        param += selList[i].id + ',';
                    }
                    Coolite.AjaxMethods.AddTerritoryItem(param, { success: function(result1) {
                        if (result1) {
                            Ext.getCmp("TerritoryEditorWindow").hide(null);
                            Ext.getCmp("GridPanel1").reload()
                        } else {
                        Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("Add.hasSelection.alert.Message").ToString()%>');
                        }
                    }
                    });
                } else {
                Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("Add.alert.Message").ToString()%>');
                }
            }
        }

        var AddDealer = function(grid) {
        var result = confirm('<%=GetLocalResourceObject("Add.result.confirm").ToString()%>');
            if (result) {
                if (grid.hasSelection()) {
                    var selList = grid.selModel.getSelections();
                    var param = '';
                    for (var i = 0; i < selList.length; i++) {
                        param += selList[i].id + ',';
                    }
                    Coolite.AjaxMethods.Adddealer(param, { success: function(result1) {
                        if (result1) {
                            Ext.getCmp("WinSelectDealer").hide(null);
                            Ext.getCmp("GridDealer").reload()
                        } else {
                        Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("Add.hasSelection.alert.Message").ToString()%>');
                        }
                    }
                    });
                } else {
                Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("Add.alert.Message").ToString()%>');
                }
            }
        }

        var deleteTerritory = function(grid) {
        var result = confirm('<%=GetLocalResourceObject("deleteTerritory.result.confirm").ToString()%>');
            if (result) {
                if (grid.hasSelection()) {
                    var selList = grid.selModel.getSelections();
                    var param = '';
                    for (var i = 0; i < selList.length; i++) {
                        param += selList[i].id + ',';
                    }
                    Coolite.AjaxMethods.DeleteTerritory(param, { success: function(result1) { if (result1) { Ext.getCmp("GridPanel1").reload(); } else { Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("afterDeleteHandler.result2.alert.Message").ToString()%>'); } } });
                } else {
                Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("deleteTerritory.hasSelection.alert.Message").ToString()%>');
                }
            }
        }


        function afterDeleteHandler(result) {
            if (result == "0") {
                var tree = Ext.getCmp("TreePanel1"); //#{TreePanel1}
                var node = tree.getSelectionModel().getSelectedNode();
                node.remove();
                Ext.Msg.alert("Message", "<%=GetLocalResourceObject("afterDeleteHandler.result0.alert.Message").ToString()%>");
            } else if (result == "1") {
            Ext.Msg.alert("Message", "<%=GetLocalResourceObject("afterDeleteHandler.result1.alert.Message").ToString()%>");
            } else if (result == "2") {
            Ext.Msg.alert("Message", "<%=GetLocalResourceObject("afterDeleteHandler.result2.alert.Message").ToString()%>");
            } else if (result == "4") {
            Ext.Msg.alert("Message", "<%=GetLocalResourceObject("afterDeleteHandler.result4.alert.Message").ToString()%>");
            }
        }

        var GetParentNodeId = function() {
            var tree = Ext.getCmp("TreePanel1");
            var Node = tree.getSelectionModel().getSelectedNode();
            var nodeid = Node.id;
            var ParentNodeId;
            if (nodeid != "Synthes") {
                ParentNodeId = Node.parentNode.id;
            } else {
                ParentNodeId = 0;
            }
            return ParentNodeId;
        }
    </script>

    <ext:Store ID="Store1" runat="server" OnRefreshData="Store1_RefershData">
        <AutoLoadParams>
            <ext:Parameter Name="start" Value="={0}" />
            <ext:Parameter Name="limit" Value="={15}" />
        </AutoLoadParams>
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="TemId">
                <Fields>
                    <ext:RecordField Name="TemId" />
                    <ext:RecordField Name="TemCode" />
                    <ext:RecordField Name="TemName" />
                    <ext:RecordField Name="TemDescription" />
                    <ext:RecordField Name="TemParentId" />
                    <ext:RecordField Name="lEVEL" />
                    <ext:RecordField Name="AttributeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="TemId" Direction="ASC" />
    </ext:Store>
    
    <ext:Store ID="WinTerritoryStore" runat="server" OnRefreshData="WinTerritoryStore_RefershData">
        <AutoLoadParams>
            <ext:Parameter Name="start" Value="={0}" />
            <ext:Parameter Name="limit" Value="={15}" />
        </AutoLoadParams>
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="TemId">
                <Fields>
                    <ext:RecordField Name="TemId" />
                    <ext:RecordField Name="TemCode" />
                    <ext:RecordField Name="TemName" />
                    <ext:RecordField Name="TemDescription" />
                    <ext:RecordField Name="TemParentId" />
                    <ext:RecordField Name="lEVEL" />
                    <ext:RecordField Name="AttributeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="TemId" Direction="ASC" />
    </ext:Store>
    
    <ext:Store ID="WinDealerStore" runat="server" OnRefreshData="WinDealerStore_RefershData">
        <AutoLoadParams>
            <ext:Parameter Name="start" Value="={0}" />
            <ext:Parameter Name="limit" Value="={10}" />
        </AutoLoadParams>
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="id">
                <Fields>
                    <ext:RecordField Name="id" />
                    <ext:RecordField Name="CName" />
                    <ext:RecordField Name="SpaCode" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="id" Direction="ASC" />
    </ext:Store>
    
    <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="AttributeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Id" Direction="ASC" />
        <Listeners>
        </Listeners>
    </ext:Store>
    
    <ext:Store ID="WinSelectDealerStore" runat="server" OnRefreshData="WinSelectDealerStore_RefreshData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ChineseName" />
                    <ext:RecordField Name="SapCode" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Id" Direction="DESC" />
    </ext:Store>
    
    <ext:Menu ID="contextMenu1" runat="server">
        <Items>
            <ext:MenuItem ID="menuAdd" runat="server" Icon="NoteAdd" Text="<%$ Resources: contextMenu1.menuAdd.text %>">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.TerritoryEditor.Show('0',#{TreePanel1}.getSelectionModel().getSelectedNode().id,GetParentNodeId(),{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem ID="menuEdit" runat="server" Icon="NoteEdit" Text="<%$ Resources: contextMenu1.menuEdit.text %>">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.TerritoryEditor.Show('1',#{TreePanel1}.getSelectionModel().getSelectedNode().id,GetParentNodeId(),{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuSeparator />
            <ext:MenuItem ID="menuDelete" runat="server" Icon="NoteDelete" Text="<%$ Resources: contextMenu1.menuDelete.text %>">
                <Listeners>
                    <Click Handler="var result = confirm(tlMsgList.msg1); if (result)  {Coolite.AjaxMethods.TerritoryEditor.DeleteTerritoryHierarchy(#{TreePanel1}.getSelectionModel().getSelectedNode().id,{success:function(result1){RefreshDetailWindow();afterDeleteHandler(result1)},failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                </Listeners>
            </ext:MenuItem>
        </Items>
    </ext:Menu>
    
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <West Collapsible="True" Split="True">
                    <ext:Panel runat="server" Title="<%$ Resources: ctl701.Title %>" Width="250px" BodyBorder="False" ID="ctl701"
                        IDMode="Legacy">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:TreePanel ID="TreePanel1" runat="server" AutoScroll="true">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar1" runat="server">
                                            <Items>
                                                <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                <ext:ToolbarButton ID="ToolbarButton1" runat="server" IconCls="icon-expand-all">
                                                    <Listeners>
                                                        <Click Handler="#{TreePanel1}.root.expand(true);" />
                                                    </Listeners>
                                                    <ToolTips>
                                                        <ext:ToolTip ID="ToolTip1" IDMode="Ignore" runat="server" Html="Expand All" />
                                                    </ToolTips>
                                                </ext:ToolbarButton>
                                                <ext:ToolbarButton ID="ToolbarButton2" runat="server" IconCls="icon-collapse-all">
                                                    <Listeners>
                                                        <Click Handler="#{TreePanel1}.root.collapse(true);" />
                                                    </Listeners>
                                                    <ToolTips>
                                                        <ext:ToolTip ID="ToolTip2" IDMode="Ignore" runat="server" Html="Collapse All" />
                                                    </ToolTips>
                                                </ext:ToolbarButton>
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                    <Root>
                                        <ext:TreeNode Text="<%$ Resources: ctl701.Title %>" Icon="FolderHome">
                                        </ext:TreeNode>
                                    </Root>
                                    <Listeners>
                                        <ContextMenu Handler="node.select(); #{contextMenu1}.show(node.ui.getAnchor());" />
                                    </Listeners>
                                    <AjaxEvents>
                                        <Click OnEvent="SelectedNodeClick" Success="if (Ext.getCmp('hiddenlEVEL').getValue() == 'Province' ){ #{GridPanel1}.reload(); Ext.getCmp('btnAdd').setDisabled(false);}else{ #{GridPanel1}.clear();Ext.getCmp('btnAdd').setDisabled(true);}">
                                            <ExtraParams>
                                                <ext:Parameter Name="selectedCatagory" Value="getSelectedCatagory(node)" Mode="Raw" />
                                            </ExtraParams>
                                        </Click>
                                    </AjaxEvents>
                                </ext:TreePanel>
                            </ext:FitLayout>
                        </Body>
                        <Listeners>
                            <BeforeRender Handler="refreshTree(#{TreePanel1})" />
                        </Listeners>
                    </ext:Panel>
                </West>
                <Center>
                    <ext:Panel runat="server" ID="ctl703" Border="false" Frame="true">
                        <Body>
                            <ext:FitLayout ID="FitLayout2" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: ctl701.Title %>" AutoExpandMax="200" AutoExpandMin="150"
                                    StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
                                    <Buttons>
                                        <ext:Button ID="btnAdd" runat="server" Text="<%$ Resources: btnAdd.Text %>" Icon="Add" CommandArgument=""
                                            CommandName="" IDMode="Legacy" OnClientClick="" Disabled="true">
                                            <Listeners>
                                                <Click Handler="showTerritorySearchDlg(#{GridPanel1})" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: btnDelete.Text %>" Icon="Delete" CommandArgument=""
                                            CommandName="" IDMode="Legacy" OnClientClick="" Disabled="true">
                                            <Listeners>
                                                <Click Handler="deleteTerritory(#{GridPanel1})" />
                                            </Listeners>
                                        </ext:Button>
                                    </Buttons>
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="TemId" DataIndex="TemId" Header="ID" Hidden="true">
                                            </ext:Column>
                                            <ext:Column ColumnID="TemCode" DataIndex="TemCode" Header="<%$ Resources: ColumnModel1.TemCode.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="TemName" DataIndex="TemName" Header="<%$ Resources: ColumnModel1.TemName.Header %>" Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="TemDescription" DataIndex="TemDescription" Header="<%$ Resources: ColumnModel1.TemDescription.Header %>"
                                                Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="AttributeName" DataIndex="AttributeName" Header="<%$ Resources: ColumnModel1.AttributeName.Header %>" Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="lEVEL" DataIndex="lEVEL" Header="<%$ Resources: ColumnModel1.lEVEL.Header %>">
                                            </ext:Column>
                                            <ext:CommandColumn Width="100" Header="<%$ Resources: ColumnModel1.CommandColumn.Header %>" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="<%$ Resources: ColumnModel1.GridCommand.Text %>" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" runat="server">
                                            <Listeners>
                                                <RowSelect Handler="#{btnDelete}.enable();" />
                                            </Listeners>
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                            DisplayInfo="true" EmptyMsg="No data to display" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" Msg="Processing..." />
                                    <Listeners>
                                        <Command Handler="if (command == 'Edit'){
                                     #{hiddenTemId}.setValue(record.data.TemId);
                                     #{GridDealer}.reload();
                                     #{WinDealer}.show();
                                                              }" />
                                    </Listeners>
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Window ID="TerritoryEditorWindow" runat="server" Icon="Group" Title="<%$ Resources: TerritoryEditorWindow.Title %>"
        Closable="true" Draggable="false" Resizable="true" Width="600" Height="450" AutoShow="false"
        Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
        <Body>
            <ext:ContainerLayout ID="ContainerLayout1" runat="server">
                <ext:Panel ID="plSearch" runat="server" Border="false" Frame="true" Header="false"
                    ButtonAlign="Right">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                            <ext:LayoutColumn ColumnWidth=".49">
                                <ext:Panel ID="Panel1" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor Horizontal="100%">
                                                <ext:TextField ID="txtWinCode" runat="server" FieldLabel="<%$ Resources: txtWinCode.FieldLabel %>" Width="200" />
                                            </ext:Anchor>
                                            <ext:Anchor Horizontal="100%">
                                                <ext:TextField ID="txtWinName" runat="server" FieldLabel="<%$ Resources: txtWinName.FieldLabel %>" Width="200" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".49">
                                <ext:Panel ID="Panel2" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbWinDistribution" runat="server" FieldLabel="<%$ Resources: cbWinDistribution.FieldLabel %>" Editable="false"
                                                    TypeAhead="false" Mode="Local" ForceSelection="false" TriggerAction="All" EmptyText="<%$ Resources: cbWinDistribution.EmptyText %>"
                                                    Width="200" SelectOnFocus="false" AllowBlank="false">
                                                    <Items>
                                                        <ext:ListItem Text="<%$ Resources: cbWinDistribution.ListItem1 %>" Value="1" />
                                                        <ext:ListItem Text="<%$ Resources: cbWinDistribution.ListItem0 %>" Value="0" />
                                                    </Items>
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbWinDistribution.Qtip %>" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Panel ID="Panel4" runat="server" Height="25">
                                                </ext:Panel>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                            <Listeners>
                                <Click Handler="#{GridTerritoryEditor}.clear();#{GridTerritoryEditor}.reload();" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="btnOk" runat="server" Text="<%$ Resources: btnOk.Text %>" Icon="Disk" CommandArgument="" CommandName=""
                            IDMode="Legacy" Enabled="false">
                            <Listeners>
                                <Click Handler="AddTerritory(#{GridTerritoryEditor})" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="btnCancel" runat="server" Text="<%$ Resources: btnCancel.Text %>" Icon="Cancel" CommandArgument=""
                            CommandName="" IDMode="Legacy" OnClientClick="">
                            <Listeners>
                                <Click Handler="#{TerritoryEditorWindow}.hide(null);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
                <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout3" runat="server">
                            <ext:GridPanel ID="GridTerritoryEditor" runat="server" Title="" AutoExpandColumn="TemId"
                                Header="false" StoreID="WinTerritoryStore" Border="false" Icon="Lorry" StripeRows="true">
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="TemId" DataIndex="TemId" Header="ID" Hidden="true">
                                        </ext:Column>
                                        <ext:Column ColumnID="TemCode" DataIndex="TemCode" Header="<%$ Resources: ColumnModel1.TemCode.Header %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="TemName" DataIndex="TemName" Header="<%$ Resources: ColumnModel1.TemName.Header %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="TemDescription" DataIndex="TemDescription" Header="<%$ Resources: ColumnModel1.TemDescription.Header %>">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                        <Listeners>
                                            <RowSelect Handler="#{btnOk}.enable();" />
                                        </Listeners>
                                    </ext:CheckboxSelectionModel>
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="WinTerritoryStore" />
                                </BottomBar>
                                <LoadMask ShowMask="true" Msg="Processing..." />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </ext:ContainerLayout>
        </Body>
    </ext:Window>
    <ext:Window ID="WinDealer" runat="server" Icon="Group" Title="<%$ Resources: ColumnModel1.CommandColumn.Header %>" Closable="true"
        Draggable="false" Resizable="true" Width="380" Height="400" AutoShow="false"
        Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
        <Body>
            <ext:ContainerLayout ID="ContainerLayout2" runat="server">
                <ext:Panel runat="server" ID="Panel8" Border="false" Frame="true" Height="350" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout4" runat="server">
                            <ext:GridPanel ID="GridDealer" runat="server" Title="" AutoExpandColumn="id" Header="false"
                                StoreID="WinDealerStore" Border="false" Icon="Lorry" StripeRows="true">
                                <ColumnModel ID="ColumnModel3" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="id" DataIndex="id" Header="ID" Hidden="true">
                                        </ext:Column>
                                        <ext:Column ColumnID="SpaCode" DataIndex="SpaCode" Header="<%$ Resources: GridDealer.SpaCode.Header %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="CName" DataIndex="CName" Header="<%$ Resources: GridDealer.CName.Header %>" Width="170">
                                        </ext:Column>
                                        <ext:CommandColumn Width="50" Header="<%$ Resources: GridDealer.CommandColumn.Header %>" Align="Center">
                                            <Commands>
                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources: GridDealer.CommandColumn.Header %>" />
                                            </Commands>
                                        </ext:CommandColumn>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel2" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="10" StoreID="WinDealerStore" />
                                </BottomBar>
                                <LoadMask ShowMask="true" Msg="Processing..." />
                                <Listeners>
                                    <Command Handler="if (command == 'Delete'){if(confirm(tlMsgList.msg1)){
                                     Coolite.AjaxMethods.deleteDealerTerritory(record.data.id); #{GridDealer}.reload();}}" />
                                </Listeners>
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnAddDealer" runat="server" Text="<%$ Resources: btnAddDealer.Text %>" Icon="Disk">
                            <Listeners>
                                <Click Handler="#{WinSelectDealer}.show();" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="btnDealerCancel" runat="server" Text="<%$ Resources: btnDealerCancel.Text %>" Icon="Disk">
                            <Listeners>
                                <Click Handler="#{WinDealer}.hide(null);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </ext:ContainerLayout>
        </Body>
    </ext:Window>
    <ext:Window ID="WinSelectDealer" runat="server" Icon="Group" Title="<%$ Resources: btnAddDealer.Text %>" Width="780"
        Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false">
        <Body>
            <ext:BorderLayout ID="BorderLayout2" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel3" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                <ext:LayoutColumn ColumnWidth=".5">
                                    <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="100">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtWinSelectDealer" runat="server" FieldLabel="<%$ Resources: txtWinSelectDealer.FieldLabel %>" Width="200" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtWinSelectSAPCode" runat="server" FieldLabel="<%$ Resources: GridDealer.SpaCode.Header %>" Width="200" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".5">
                                    <ext:Panel ID="Panel10" runat="server" Border="false" Header="false">
                                        <Buttons>
                                            <ext:Button ID="SearchButton" Text="<%$ Resources: btnSearch.Text %>" runat="server" Icon="ArrowRefresh">
                                                <Listeners>
                                                    <Click Handler="#{WinGridSelectDealer}.reload();" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="Savebutton" runat="server" Text="<%$ Resources: btnOk.Text %>" Icon="Disk" CommandArgument=""
                                                CommandName="" IDMode="Legacy" OnClientClick="" Enabled="true">
                                                <Listeners>
                                                    <Click Handler="AddDealer(#{WinGridSelectDealer})" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="Cancelbutton" Text="<%$ Resources: btnCancel.Text %>" runat="server" Icon="Cancel" IDMode="Legacy">
                                                <Listeners>
                                                    <Click Handler="#{WinSelectDealer}.hide(null);" />
                                                </Listeners>
                                            </ext:Button>
                                        </Buttons>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="DealerPanel1" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout5" runat="server">
                                <ext:GridPanel ID="WinGridSelectDealer" runat="server" Title="<%$ Resources: btnAddDealer.Text %>" StoreID="WinSelectDealerStore"
                                    Border="false" Icon="Lorry" AutoWidth="true" AutoExpandColumn="Id" Header="false" StripeRows="true">
                                    <ColumnModel ID="ColumnModel4" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                            </ext:Column>
                                            <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridDealer.CName.Header %>" Width="200">
                                            </ext:Column>
                                            <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="<%$ Resources: GridDealer.SpaCode.Header %>">
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                                        </ext:CheckboxSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="15" StoreID="WinSelectDealerStore" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" Msg="Processing..." />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
        <Listeners>
            <Show Handler="#{txtWinSelectDealer}.setValue('');#{txtWinSelectSAPCode}.setValue('');#{WinGridSelectDealer}.clear(); #{WinGridSelectDealer}.reload();" />
        </Listeners>
    </ext:Window>
    <uc1:TerritoryEditor ID="TerritoryEditor1" runat="server" />
    <ext:Hidden ID="hiddenSelectedCatagory" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenlEVEL" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenTemId" runat="server">
    </ext:Hidden>
    </form>
</body>
</html>
