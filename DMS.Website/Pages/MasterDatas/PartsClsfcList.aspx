<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PartsClsfcList.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.PartsClsfcList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/PartsClsfcEditor.ascx" TagName="PartsClsfcEditor"
    TagPrefix="uc1" %>
<%@ Register Src="../../Controls/CFNSearchDialog.ascx" TagName="CFNSearchDialog"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" >
    </ext:ScriptManager>

    <script type="text/javascript">

        var MsgList = {
			Store1:{
				LoadExceptionTitle:"<%=GetLocalResourceObject("Store1.LoadException.Alert.Title").ToString()%>",
				CommitFailedTitle:"<%=GetLocalResourceObject("Store1.CommitFailed.Alert.Title").ToString()%>",
				CommitFailedMsg:"<%=GetLocalResourceObject("Store1.CommitFailed.Alert.Body").ToString()%>",
				SaveExceptionTitle:"<%=GetLocalResourceObject("Store1.SaveException.Alert.Title").ToString()%>",
				CommitDoneTitle:"<%=GetLocalResourceObject("Store1.CommitDone.Alert.Title").ToString()%>",
				CommitDoneMsg:"<%=GetLocalResourceObject("Store1.CommitDone.Alert.Body").ToString()%>"
			},
			menuEdit:{
				failure:"<%=GetLocalResourceObject("contextMenu1.menuEdit.Alert").ToString()%>"
			},
			menuDelete:{
				Confirm:"<%=GetLocalResourceObject("contextMenu1.menuDelete.Confirm").ToString()%>",
				FailureTitle:"<%=GetLocalResourceObject("contextMenu1.menuDelete.Alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("contextMenu1.menuDelete.Alert.Body").ToString()%>"
			},
			btnDelete:{
				confirm:"<%=GetLocalResourceObject("GridPanel1.btnDelete.Confirm").ToString()%>"
			}
        }

        function refreshTree(tree) {
            Coolite.AjaxMethods.RefreshLines({
                success: function(result) {
                    var nodes = eval(result);
                    if (tree.root != null)
                        tree.root.ui.remove();
                    tree.initChildren(nodes);

                    if (tree.root != null)
                        tree.root.render();
                    tree.getSelectionModel().clearSelections();
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


        //Delete the node you selected
        function afterDeleteHandler() {

            var tree = Ext.getCmp("TreePanel1"); //#{TreePanel1}
            var node = tree.getSelectionModel().getSelectedNode();
            node.remove();
            Ext.Msg.alert("Information", "Deleted successfully.");
        }

        function getSelectedCatagory(selNode) {
            //modified by bozhenfei 去掉只能叶子分类维护的限制
//            if (selNode == null) return null;
//            
//            if (selNode.childNodes!=null && selNode.childNodes.length > 0) {
//                return null;
//            }
//            else
                //alert(selNode);
                if (selNode == null) return null;
                var tree = Ext.getCmp("TreePanel1");
                //alert(tree.root.id + " " + selNode.id);
                if (tree.root == selNode){                    
                    return null;
                }
                return selNode.id;
        }

        var showCfnSearchDlg = function() {
           
            var tree = Ext.getCmp("TreePanel1");

            var selNode = tree.getSelectionModel().getSelectedNode();

            if (Ext.getCmp("cbCatories").getValue() == null) {
                Ext.Msg.alert('<%=GetLocalResourceObject("showCfnSearchDlg.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("showCfnSearchDlg.Alert.Body").ToString()%>');
                return;
            }
            
            var selCatagoryValue = getSelectedCatagory(selNode);

            if (selCatagoryValue == null) {
                //Ext.Msg.alert("提醒", "分类的叶子节点才能添加产品，请重新选择!");
                Ext.Msg.alert('<%=GetLocalResourceObject("showCfnSearchDlg.selCatagoryValue.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("showCfnSearchDlg.selCatagoryValue.Alert.Body").ToString()%>');
                return;
            }

            openCfnSearchDlg(<%=cbCatories.ClientID %>.getValue(),null);

            var btnsave = Ext.getCmp("btnSave");
            if (btnsave != null && btnsave.disabled)
                btnsave.enable();

        }
        
    </script>

    <ext:Store ID="Store1" runat="server" OnRefreshData="Store1_RefershData" OnBeforeStoreChanged="Store1_BeforeStoreChanged">
        <AutoLoadParams>
            <ext:Parameter Name="start" Value="={0}" />
            <ext:Parameter Name="limit" Value="={15}" />
        </AutoLoadParams>
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="EnglishName" />
                    <ext:RecordField Name="ChineseName" />
                    <ext:RecordField Name="Implant" />
                    <ext:RecordField Name="CustomerFaceNbr" />
                    <ext:RecordField Name="ProductCatagoryPctId" />
                    <ext:RecordField Name="Property1" />
                    <ext:RecordField Name="Property2" />
                    <ext:RecordField Name="Property3" />
                    <ext:RecordField Name="Property4" />
                    <ext:RecordField Name="Property5" />
                    <ext:RecordField Name="Property6" />
                    <ext:RecordField Name="Property7" />
                    <ext:RecordField Name="Property8" />
                    <ext:RecordField Name="LastUpdateDate" />
                    <ext:RecordField Name="DeletedFlag" />
                    <ext:RecordField Name="ProductLineBumId" />
                    <ext:RecordField Name="PCTName" />
                    <ext:RecordField Name="PCTEnglishName" />
                    <ext:RecordField Name="ProductLineName" />
                    <ext:RecordField Name="Description" />
                    <ext:RecordField Name="Tool" />
                    <ext:RecordField Name="Share" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="CustomerFaceNbr" Direction="ASC" />
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.Store1.LoadExceptionTitle, e.message || e )" />
            <CommitFailed Handler="Ext.Msg.alert(MsgList.Store1.CommitFailedTitle, MsgList.Store1.CommitFailedMsg + msg)" />
            <SaveException Handler="Ext.Msg.alert(MsgList.Store1.SaveExceptionTitle, e.message || e)" />
            <CommitDone Handler="Ext.Msg.alert(MsgList.Store1.CommitDoneTitle, MsgList.Store1.CommitDoneMsg);" />
        </Listeners>
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
    </ext:Store>
    <ext:Menu ID="contextMenu1" runat="server">
        <Items>
            <ext:MenuItem ID="menuAdd" runat="server" Icon="NoteAdd" Text="<%$ Resources: contextMenu1.menuAdd.Text %>">
                <Listeners>
                    <Click Handler="createPartsWindow();" />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem ID="menuEdit" runat="server" Icon="NoteEdit" Text="<%$ Resources: contextMenu1.menuEdit.Text %>">
                <Listeners>
                    <Click Handler="openPartsWindow();Coolite.AjaxMethods.PartsClsfcEditor.PartsInit(#{TreePanel1}.getSelectionModel().getSelectedNode().id,#{TreePanel1}.getSelectionModel().getSelectedNode().parentNode.id,#{TreePanel1}.getSelectionModel().getSelectedNode().parentNode.text,{success:function(){#{PartsDetailsWindow}.show();},failure:function(err){Ext.Msg.alert(MsgList.menuEdit.failure, err);}});"/>
                </Listeners>
            </ext:MenuItem>
            <ext:MenuSeparator />
            <ext:MenuItem ID="menuDelete" runat="server" Icon="NoteDelete" Text="<%$ Resources: contextMenu1.menuDelete.Text %>">
                <AjaxEvents>
                    <Click Before="var result =confirm(MsgList.menuDelete.Confirm); if (! result) return false;"
                        OnEvent="DeleteNode_Click" Success='afterDeleteHandler();' Failure="Ext.Msg.alert(MsgList.menuDelete.FailureTitle, MsgList.menuDelete.FailureMsg);">
                        <ExtraParams>
                            <ext:Parameter Name="id" Value="#{TreePanel1}.getSelectionModel().getSelectedNode().id"
                                Mode="Raw">
                            </ext:Parameter>
                        </ExtraParams>
                    </Click>
                </AjaxEvents>
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
                                                <ext:ToolbarTextItem ID="ToolbarTextItem1" runat="server" Text="<%$ Resources: ctl701.TreePanel1.ToolbarTextItem1.Text %>" Width="250" />
                                                <ext:ComboBox ID="cbCatories" runat="server" EmptyText="<%$ Resources: ctl701.TreePanel1.cbCatories.EmptyText %>" Width="150" Editable="false" ListWidth="300" Resizable="true"
                                                    TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName">
                                                    <Items>
                                                    </Items>
                                                    <Listeners>
                                                        <Select Handler="refreshTree(#{TreePanel1})" />
                                                    </Listeners>
                                                </ext:ComboBox>
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
                                        <ext:TreeNode Text="<%$ Resources: ctl701.TreePanel1.TreeNode.Text %>" Icon="FolderHome">
                                        </ext:TreeNode>
                                    </Root>
                                    <Listeners>
                                        <ContextMenu Handler="node.select(); #{contextMenu1}.show(node.ui.getAnchor());" />
                                    </Listeners>
                                    <AjaxEvents>
                                        <Click OnEvent="SelectedNodeClick" Success="if (getSelectedCatagory(node) != null ){ #{GridPanel1}.reload(); }else{ #{GridPanel1}.clear();}">
                                            <ExtraParams>
                                                <ext:Parameter Name="selectedCatagory" Value="getSelectedCatagory(node)" Mode="Raw" />
                                            </ExtraParams>
                                        </Click>
                                    </AjaxEvents>
                                </ext:TreePanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </West>
                <Center>
                    <ext:Panel runat="server"  ID="ctl703" Border="false" Frame="true">
                        <Body>
                            <ext:FitLayout ID="FitLayout2" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"  AutoExpandMax="200"
                                    AutoExpandMin="150" AutoExpandColumn="EnglishName" StoreID="Store1" Border="false"
                                    Icon="Lorry" StripeRows="true">
                                    <Buttons>
                                        <ext:Button ID="btnAdd" runat="server" Text="<%$ Resources: GridPanel1.btnAdd.Text %>" Icon="Add" CommandArgument=""
                                            CommandName="" IDMode="Legacy" OnClientClick="">
                                            <Listeners>
                                                <Click Fn="showCfnSearchDlg" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnSave" runat="server" Text="<%$ Resources: GridPanel1.btnSave.Text %>" Icon="Disk" CommandArgument=""
                                            CommandName="" IDMode="Legacy" OnClientClick="" Disabled="true">
                                            <Listeners>
                                                <Click Handler="#{GridPanel1}.save();#{btnSave}.disable();" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: GridPanel1.btnDelete.Text %>" Icon="Delete" CommandArgument=""
                                            CommandName="" IDMode="Legacy" OnClientClick="" Disabled="true">
                                            <Listeners>
                                                <Click Handler="var result = confirm(MsgList.btnDelete.confirm); if ( (result) && #{GridPanel1}.hasSelection())  { #{GridPanel1}.deleteSelected(); #{btnSave}.enable();}" />
                                            </Listeners>
                                        </ext:Button>
                                    </Buttons>
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="<%$ Resources: GridPanel1.ColumnModel1.EnglishName.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel1.ColumnModel1.ChineseName.Header %>" Width="200">
                                            </ext:Column>
                                            <ext:Column ColumnID="Description" DataIndex="Description" Header="<%$ Resources: GridPanel1.ColumnModel1.Description.Header %>" Width="200">
                                            </ext:Column>
                                            <ext:Column ColumnID="PCTName" DataIndex="PCTName" Header="<%$ Resources: GridPanel1.ColumnModel1.PCTName.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="PCTEnglishName" DataIndex="PCTEnglishName" Header="<%$ Resources: GridPanel1.ColumnModel1.PCTEnglishName.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductLineName.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="Implant" Header="<%$ Resources: GridPanel1.ColumnModel1.Implant.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="Tool" Header="<%$ Resources: GridPanel1.ColumnModel1.Tool.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="Share" Header="<%$ Resources: GridPanel1.ColumnModel1.Share.Header %>">
                                            </ext:Column>
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
                                            DisplayInfo="true" EmptyMsg="<%$ Resources: GridPanel1.PagingToolBar1.EmptyMsg %>" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                    <Listeners>
                                    </Listeners>
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <uc1:PartsClsfcEditor ID="PartsClsfcEditor1" runat="server" />
    <uc2:CFNSearchDialog ID="CFNSearchDialog1" runat="server" />
    <ext:Hidden ID="hiddenSelectedCatagory" runat="server">
    </ext:Hidden>
    </form>
</body>
</html>
