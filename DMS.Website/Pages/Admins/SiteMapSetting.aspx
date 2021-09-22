<%@ Page Language="C#" AutoEventWireup="true" Inherits="Lafite.Web.SiteMapSetting"
    Title="SiteMap Setting" Codebehind="SiteMapSetting.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>SiteMap Setting</title>
    <link href="../../resources/css/inputStyle.css" rel="stylesheet" type="text/css" />
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    <link href="../../resources/css/pagestyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="dvMain" style="position: relative; overflow: auto; width: 100%; height: 100%">
         <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td>
                    <table border="0" cellpadding="0" cellspacing="0" class="pageTitle" width="100%">
                        <tr>
                            <td>
                                <img src="../../resources/images/page_bar_pic.gif" />&nbsp; Administration
                                -&gt; Application Maintain -&gt; SiteMap Setting
                            </td>
                            <td align="right" width="75">
                                <img src="../../resources/images/page_bar_right.gif" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

        <table id="tblMain" width="100%" border="0" cellpadding="0" rules="all">
            <tr>
                <td width="30%">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td height="20" class="title1">
                                SiteMap Tree：
                                <asp:LinkButton ID="LinkButton1" runat="server" OnClick="btnExport_Click">Export SiteMap</asp:LinkButton>
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </td>
                <td>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td height="20" class="title1">
                                SiteMap Detail：
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" height="3" align="left" valign="top">
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <div id="dvTree">
                        <asp:TreeView ID="treeView1" runat="server" OnSelectedNodeChanged="treeView_SelectedNodeChanged">
                            <Nodes>
                                <asp:TreeNode Text="New Node" Value="New Node">
                                    <asp:TreeNode Text="New Node" Value="New Node">
                                        <asp:TreeNode Text="New Node" Value="New Node"></asp:TreeNode>
                                        <asp:TreeNode Text="New Node" Value="New Node">
                                            <asp:TreeNode Text="New Node" Value="New Node"></asp:TreeNode>
                                        </asp:TreeNode>
                                    </asp:TreeNode>
                                </asp:TreeNode>
                            </Nodes>
                            <HoverNodeStyle CssClass="HoverNodeStyle" />
                            <SelectedNodeStyle CssClass="SelectedNodeStyle" />
                        </asp:TreeView>
                    </div>
                </td>
                <td valign="top">
                    <asp:DetailsView ID="detailsView1" runat="server" Width="100%" AutoGenerateRows="False"
                        FieldHeaderStyle-Width="80px" DataSourceID="SiteDataSource1" OnItemInserting="DetailsView_ItemInserting"
                        OnItemInserted="DetailsView_ItemInserted" OnItemDeleted="DetailsView_ItemDeleted"
                        OnItemUpdated="DetailsView_ItemUpdated" OnItemUpdating="DetailsView_ItemUpdating"
                        OnModeChanging="DetailsView_ModeChanging" CssClass="detailstable" FieldHeaderStyle-CssClass="bold"
                        OnItemCreated="detailsView1_ItemCreated" OnItemDeleting="detailsView1_ItemDeleting">
                        <Fields>
                            <asp:TemplateField HeaderText="Node Id">
                                <ItemTemplate>
                                    <asp:Label ID="Label7" runat="server" Text='<%# Bind("ItemId") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Node Type">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("ItemType") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="dpItemType" runat="server">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:DropDownList ID="dpItemType" runat="server">
                                    </asp:DropDownList>
                                </InsertItemTemplate>
                                <ItemStyle CssClass="common_field" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Level">
                                <ItemTemplate>
                                    <asp:Label ID="lblLevel" runat="server" Text='<%# Bind("Level") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Parent Id">
                                <ItemTemplate>
                                    <asp:Label ID="lblParentId" runat="server" Text='<%# Bind("ParentId") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Title">
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Title") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="middle_field" Text='<%# Bind("Title") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="titleValidator" ControlToValidate="txtTitle" runat="server"
                                        ErrorMessage="*" ValidationGroup="RuleSetA"></asp:RequiredFieldValidator>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="middle_field" Text='<%# Bind("Title") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="titleValidator" ControlToValidate="txtTitle" runat="server"
                                        ErrorMessage="*" ValidationGroup="RuleSetA"></asp:RequiredFieldValidator>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Url">
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Url") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server" CssClass="middle_field" Text='<%# Bind("Url") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server" CssClass="middle_field" Text='<%# Bind("Url") %>'></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="HelpLink">
                                <ItemTemplate>
                                    <asp:Label ID="Label6" runat="server" Text='<%# Bind("HelpLink") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox6" runat="server" CssClass="middle_field" Text='<%# Bind("HelpLink") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox ID="TextBox6" runat="server" CssClass="middle_field" Text='<%# Bind("HelpLink") %>'></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IsEnabled">
                                <ItemTemplate>
                                    <asp:CheckBox ID="ckIsEnabled" runat="server" Checked='<%# Bind("IsEnabled") %>'
                                        Enabled="false" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:CheckBox ID="ckIsEnabled" runat="server" Checked='<%# Bind("IsEnabled") %>' />
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:CheckBox ID="ckIsEnabled" runat="server" Checked='<%# Bind("IsEnabled") %>' />
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Description">
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox4" runat="server" CssClass="middle_field" Text='<%# Bind("Description") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox ID="TextBox4" runat="server" CssClass="middle_field" Text='<%# Bind("Description") %>'></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="OrderBy">
                                <ItemTemplate>
                                    <asp:Label ID="Label8" runat="server" Text='<%# Bind("OrderBy") %>'></asp:Label>
                                </ItemTemplate>
                                  <EditItemTemplate>
                                    <asp:TextBox ID="TextBox8" runat="server" CssClass="middle_field" Text='<%# Bind("OrderBy") %>'></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Resource Key">
                                <ItemTemplate>
                                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("ResourceKey") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox5" runat="server" CssClass="middle_field" Text='<%# Bind("ResourceKey") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox ID="TextBox5" runat="server" CssClass="middle_field" Text='<%# Bind("ResourceKey") %>'></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="LastUpdate">
                                <ItemTemplate>
                                    <asp:Label ID="Label11" runat="server" Text='<%# Bind("LastUpdate") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="LastUpdateDate">
                                <ItemTemplate>
                                    <asp:Label ID="Label10" runat="server" Text='<%# Bind("LastUpdateDate") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:Button ID="btnNew" runat="server" CausesValidation="False" CommandName="New"
                                        Text="Add Node" />
                                    <asp:Button ID="btnNewChildButton" runat="server" Text="Add Child Node" OnClick="btnNewChildButton_Click" />
                                    <asp:Button ID="btnEdit" runat="server" CausesValidation="False" CommandName="Edit"
                                        Text="Edit Node" />
                                    <asp:Button ID="btnDelete" runat="server" CausesValidation="False" CommandName="Delete"
                                        Text="Delete Node" OnClientClick="javascript:return confirm('Can you sure to delete ?');" />
                                </ItemTemplate>
                                <InsertItemTemplate>
                                    <asp:Button ID="btnInsert" runat="server" CausesValidation="True" CommandName="Insert"
                                        ValidationGroup="RuleSetA" Text="保存" />
                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="False" CommandName="Cancel"
                                        Text="取消" />
                                </InsertItemTemplate>
                                <EditItemTemplate>
                                    <asp:Button ID="btnUpdate" runat="server" CausesValidation="True" CommandName="Update"
                                        ValidationGroup="RuleSetA" Text="保存" />
                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="False" CommandName="Cancel"
                                        Text="取消" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                        </Fields>
                        <FieldHeaderStyle Width="80px"></FieldHeaderStyle>
                        <EmptyDataTemplate>
                            <asp:Button ID="btnNew" runat="server" CausesValidation="False" CommandName="New"
                                Text="New Node" />
                        </EmptyDataTemplate>
                    </asp:DetailsView>
                    <asp:ObjectDataSource ID="SiteDataSource1" runat="server" TypeName="Lafite.SiteMap.Provider.DbSiteProvider"
                        OldValuesParameterFormatString="original_{0}" SelectMethod="GetSiteItem" DeleteMethod="DeleteItem"
                        UpdateMethod="UpdateItem" InsertMethod="InsertItem" OnInserting="SiteDataSource1_Inserting"
                        OnInserted="SiteDataSource1_Inserted" OnUpdating="SiteDataSource1_Updating" OnDeleting="SiteDataSource1_Deleting">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="treeView1" Name="itemId" PropertyName="SelectedValue"
                                Type="Int32" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:ControlParameter ControlID="treeView1" Name="itemId" PropertyName="SelectedValue"
                                Type="Int32" />
                        </DeleteParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="itemId" Type="Int32" Direction="Input" />
                            <asp:Parameter Name="itemType" Type="String" Direction="Input" />
                            <asp:Parameter Name="title" Type="String" Direction="Input" />
                            <asp:Parameter Name="url" Type="String" Direction="Input" />
                            <asp:Parameter Name="description" Type="String" Direction="Input" />
                            <asp:Parameter Name="helpLink" Type="String" Direction="Input" />
                            <asp:Parameter Name="isEnabled" Type="Boolean" Direction="Input" />
                            <asp:Parameter Name="resourceKey" Type="String" Direction="Input" />
                            <asp:Parameter Name="orderBy" Type="Int32" Direction="Input" />
                        </UpdateParameters>
                        <InsertParameters>
                            <asp:Parameter Name="itemType" Type="String" Direction="Input" />
                            <asp:Parameter Name="parentId" Type="Int32" Direction="Input" />
                            <asp:Parameter Name="title" Type="String" Direction="Input" />
                            <asp:Parameter Name="url" Type="String" Direction="Input" />
                            <asp:Parameter Name="description" Type="String" Direction="Input" />
                            <asp:Parameter Name="helpLink" Type="String" Direction="Input" />
                            <asp:Parameter Name="isEnabled" Type="Boolean" Direction="Input" />
                            <asp:Parameter Name="level" Type="Int32" Direction="Input" />
                            <asp:Parameter Name="resourceKey" Type="String" Direction="Input" />
                            <asp:Parameter Name="orderBy" Type="Int32" Direction="Input" />
                        </InsertParameters>
                    </asp:ObjectDataSource>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
