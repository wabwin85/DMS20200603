<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TSRHospital.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.TSRHospital" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/HospitalSelectorDialog.ascx" TagName="HospitalSelectorDialog" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" >
    </ext:ScriptManager>

    <script type="text/javascript">
        var MsgList = {
			SalesOfHostapitalStore1:{
				LoadExceptionTitle:"<%=GetLocalResourceObject("SalesOfHostapitalStore1.LoadException.Alert").ToString()%>",
				CommitFailedTitle:"<%=GetLocalResourceObject("SalesOfHostapitalStore1.CommitFailed.Alert.Title").ToString()%>",
				CommitFailedMsg:"<%=GetLocalResourceObject("SalesOfHostapitalStore1.CommitFailed.Alert.Body").ToString()%>",
				SaveExceptionTitle:"<%=GetLocalResourceObject("SalesOfHostapitalStore1.SaveException.Alert").ToString()%>",
				CommitDoneTitle:"<%=GetLocalResourceObject("SalesOfHostapitalStore1.CommitDone.Alert.Title").ToString()%>",
				CommitDoneMsg:"<%=GetLocalResourceObject("SalesOfHostapitalStore1.CommitDone.Alert.Body").ToString()%>"
			},
			btnDelete:{
				confirm:"<%=GetLocalResourceObject("GridPanel1.btnDelete.Confirm").ToString()%>"
			}
        }

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


        function getSelectedSale(selNode) {

            if (selNode == null) return null;
            
            if (selNode.attributes.childType == "User") {
                return selNode.id;
            }
            else
                return null;
        }

        function getSelectedLine(selNode) {

            var node = selNode;

            if (node == null) return null;

            while (node != null) {
                if (node.attributes.childType == "Organization" &&
                    node.attributes.attributeType == "Product_Line")
                    return node.id;
                else {
                    if (node.parentNode != null)
                        node = node.parentNode;
                    else 
                        break;
                }
            }
        }

        var showHospistalSearchDlg = function() {

            var tree = Ext.getCmp("TreePanel1");

            var selNode = tree.getSelectionModel().getSelectedNode();

            var selSaleValue = getSelectedSale(selNode);
            var selProductLine = getSelectedLine(selNode);

            if (selSaleValue == null || selProductLine == null) {
                Ext.Msg.alert('<%=GetLocalResourceObject("showHospistalSearchDlg.Alert.Title").ToString()%>','<%=GetLocalResourceObject("showHospistalSearchDlg.Alert.Body").ToString()%>');
                return;
            }
            openHospitalSelectorDlg(selProductLine);

            //var btnsave = Ext.getCmp("btnSave");
            //if (btnsave != null && btnsave.disabled)
            //     btnsave.enable();

        }
        
    </script>

    <ext:Store ID="SalesOfHostapitalStore1" runat="server" UseIdConfirmation="false" OnBeforeStoreChanged="Store1_BeforeStoreChanged"
        OnRefreshData="Store1_RefershData" AutoLoad="false">
        <Reader>
            <ext:JsonReader ReaderID="HosId">
                <Fields>
                    <ext:RecordField Name="HosId" />
                    <ext:RecordField Name="HosHospitalShortName" />
                    <ext:RecordField Name="HosHospitalName" />
                    <ext:RecordField Name="HosGrade" />
                    <ext:RecordField Name="HosKeyAccount" />
                    <ext:RecordField Name="HosProvince" />
                    
                    <ext:RecordField Name="HosCity" />
                    <ext:RecordField Name="HosDistrict" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.SalesOfHostapitalStore1.LoadExceptionTitle, e.message || e )" />
            <CommitFailed Handler="Ext.Msg.alert(MsgList.SalesOfHostapitalStore1.CommitFailedTitle, MsgList.SalesOfHostapitalStore1.CommitFailedMsg + msg)" />
            <SaveException Handler="Ext.Msg.alert(MsgList.SalesOfHostapitalStore1.SaveExceptionTitle, e.message || e)" />
            <CommitDone Handler="Ext.Msg.alert(MsgList.SalesOfHostapitalStore1.CommitDoneTitle, MsgList.SalesOfHostapitalStore1.CommitDoneMsg);" />
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
                                                        <ext:ToolTip ID="ToolTip1" IDMode="Ignore" runat="server" Html="<%$ Resources: ctl701.TreePanel1.ToolTip1.Html %>" />
                                                    </ToolTips>
                                                </ext:ToolbarButton>
                                                <ext:ToolbarButton ID="ToolbarButton2" runat="server" IconCls="icon-collapse-all">
                                                    <Listeners>
                                                        <Click Handler="#{TreePanel1}.root.collapse(true);" />
                                                    </Listeners>
                                                    <ToolTips>
                                                        <ext:ToolTip ID="ToolTip2" IDMode="Ignore" runat="server" Html="<%$ Resources: ctl701.TreePanel1.ToolTip2.Html %>" />
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
                                        <Click OnEvent="SelectedNodeClick" Success="var selNode = node;   if (selNode.attributes.childType == 'User'){ clearHospitalSelectorDlg();#{GridPanel1}.reload(); }">
                                            <ExtraParams>
                                                <ext:Parameter Name="selectedLine" Value="getSelectedLine(node)"
                                                    Mode="Raw" />
                                                <ext:Parameter Name="selectedUser" Value="getSelectedSale(node)"
                                                    Mode="Raw" />
                                            </ExtraParams>
                                        </Click>
                                    </AjaxEvents>
                                </ext:TreePanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </West>
                <Center>
                    <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                        <Body>
                            <ext:FitLayout ID="FitLayout2" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" AutoExpandColumn="HosHospitalName"
                                    StoreID="SalesOfHostapitalStore1" Border="false" Icon="Lorry" StripeRows="true">
                                    <Buttons>
                                        <ext:Button ID="btnAdd" runat="server" Text="<%$ Resources: GridPanel1.btnAdd.Text %>" Icon="Add" CommandArgument=""
                                            CommandName="" IDMode="Legacy">
                                            <Listeners>
                                                <Click Fn="showHospistalSearchDlg" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnSave" runat="server" Text="<%$ Resources: GridPanel1.btnSave.Text %>" Icon="Disk" CommandArgument=""
                                            CommandName="" IDMode="Legacy" Enabled="false" Visible="false">
                                            <Listeners>
                                                <Click Handler="#{GridPanel1}.save();#{btnSave}.disable();" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: GridPanel1.btnDelete.Text %>" Icon="Delete" CommandArgument=""
                                            CommandName="" IDMode="Legacy" Enabled="false">
                                            <Listeners>
                                                <Click Handler="var result = confirm(MsgList.btnDelete.confirm); if ( (result) && #{GridPanel1}.hasSelection()) { #{GridPanel1}.deleteSelected(); #{GridPanel1}.save();}" />
                                            </Listeners>
                                        </ext:Button>
                                    </Buttons>
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="<%$ Resources: GridPanel1.ColumnModel1.HosHospitalName.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosKeyAccount" Header="<%$ Resources: GridPanel1.ColumnModel1.HosKeyAccount.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosGrade" Header="<%$ Resources: GridPanel1.ColumnModel1.HosGrade.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosProvince" Header="<%$ Resources: GridPanel1.ColumnModel1.HosProvince.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosCity" Header="<%$ Resources: GridPanel1.ColumnModel1.HosCity.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosDistrict" Header="<%$ Resources: GridPanel1.ColumnModel1.HosDistrict.Header %>">
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
                                     <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                     <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="SalesOfHostapitalStore1"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                   
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <uc1:HospitalSelectorDialog ID="HospitalSelectorDialog1" runat="server" />
    <ext:Hidden ID="hiddenSelectedLine" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenSelectedSale" runat="server">
    </ext:Hidden>
    </form>
</body>
</html>
