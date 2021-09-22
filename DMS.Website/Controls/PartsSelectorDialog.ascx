<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PartsSelectorDialog.ascx.cs"
    Inherits="DMS.Website.Controls.PartsSelectorDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    
    var sayErrorMessage = function(result)
    {
        //debugger;        
        if(result.success == false)
            alert(result.errorMessage);        
    }
    
    var checkSelected = function()
    {
        //var selvalue = Ext.getCmp("cbCatories").getValue();

        var selvalue = <%=cbCatories.ClientID %>.getValue();
        if (selvalue == "")
        {
            alert('<%=GetLocalResourceObject("checkSelected.alert").ToString()%>');
            return false;
        }
        return true;
    }
    
      var openPartsSelectorDlg = function (animTrg) {
        var window = <%= partsSelectorDlg.ClientID %>;
       
        window.show(animTrg);
    }
    
        
     function getSelectedCatagory(selNode) {

        if (selNode == null) return null;

        //if (selNode.childNodes != null && selNode.childNodes.length > 0) {
        if ( selNode.parentNode == null ) {
            return null;
        }
        else
            return selNode.id;
    }
    
    
</script>

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
<ext:Window ID="partsSelectorDlg" runat="server" Icon="Group" Title="<%$ Resources: partsSelectorDlg.Title %>" Closable="false"
    Draggable="false" Resizable="true" Width="600" Height="460" AutoShow="false"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:FitLayout ID="FitLayout1" runat="server">
            <ext:TreePanel ID="tplPartsSelector" runat="server" AutoScroll="true">
                <TopBar>
                    <ext:Toolbar ID="Toolbar1" runat="server">
                        <Items>
                            <ext:ToolbarTextItem ID="ToolbarTextItem1" runat="server" Text="<%$ Resources:partsSelectorDlg.ToolbarTextItem1.Text %> " Width="250" />
                            <ext:ComboBox ID="cbCatories" runat="server" EmptyText="<%$ Resources:partsSelectorDlg.cbCatories.EmptyText %>" Width="150" Editable="false"
                                TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName">
                                <Items>
                                </Items>
                                <Listeners>
                                    <Select Handler=" 
                                        #{AjaxMethods}.RefreshLines({success: function(result) {
                                                var tree = #{tplPartsSelector}; 
                                                var nodes = eval(result);
                                                if (tree.root != null) tree.root.ui.remove();
                                                tree.initChildren(nodes); 
                                                if (tree.root != null) tree.root.render();}});" />
                                </Listeners>
                            </ext:ComboBox>
                            <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                            <ext:ToolbarButton ID="ToolbarButton1" runat="server" IconCls="icon-expand-all">
                                <Listeners>
                                    <Click Handler="#{tplPartsSelector}.root.expand(true);" />
                                </Listeners>
                                <ToolTips>
                                    <ext:ToolTip ID="ToolTip1" IDMode="Ignore" runat="server" Html="Expand All" />
                                </ToolTips>
                            </ext:ToolbarButton>
                            <ext:ToolbarButton ID="ToolbarButton2" runat="server" IconCls="icon-collapse-all">
                                <Listeners>
                                    <Click Handler="#{tplPartsSelector}.root.collapse(true);" />
                                </Listeners>
                                <ToolTips>
                                    <ext:ToolTip ID="ToolTip2" IDMode="Ignore" runat="server" Html="Collapse All" />
                                </ToolTips>
                            </ext:ToolbarButton>
                        </Items>
                    </ext:Toolbar>
                </TopBar>
                <Root>
                    <ext:TreeNode Text="<%$ Resources:partsSelectorDlg.TreeNode.Text %>" Icon="FolderHome">
                    </ext:TreeNode>
                </Root>
                <AjaxEvents>
                    <Click OnEvent="SelectedNodeClick" Success="if (getSelectedCatagory(node) != null ){ }">
                        <ExtraParams>
                            <ext:Parameter Name="selectedCatagory" Value="getSelectedCatagory(node)" Mode="Raw" />
                            <ext:Parameter Name="selectedCatagoryName" Value="node.text" Mode="Raw" />
                        </ExtraParams>
                    </Click>
                </AjaxEvents>
            </ext:TreePanel>
        </ext:FitLayout>
    </Body>
    <Buttons>
        <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources:SaveButton %>" Icon="Disk"  OnClientClick="var result=checkSelected(); if(!result) return false;">
            <AjaxEvents>
                <Click OnEvent="SubmitSelection" Success="#{partsSelectorDlg}.hide(null);" Failure="sayErrorMessage(result);">
                </Click>
            </AjaxEvents>
        </ext:Button>
        <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources:CancelButton %>" Icon="Cancel">
            <Listeners>
                <Click Handler="#{partsSelectorDlg}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
<ext:Hidden ID="hiddenSelectedCatagory" runat="server" />
<ext:Hidden ID="hiddenSelectedCatagoryName" runat="server">
</ext:Hidden>
