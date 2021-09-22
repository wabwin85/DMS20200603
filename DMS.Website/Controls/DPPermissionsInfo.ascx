<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DPPermissionsInfo.ascx.cs"
    Inherits="DMS.Website.Controls.DPPermissionsInfo" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<style type="text/css">
    .list-item
    {
        font: normal 11px tahoma, arial, helvetica, sans-serif;
        padding: 3px 10px 3px 10px;
        border: 1px solid #fff;
        border-bottom: 1px solid #eeeeee;
        white-space: normal;
        color: #555;
    }
    .list-item h3
    {
        display: block;
        font: inherit;
        font-weight: bold;
        color: #222;
    }
</style>

<script type="text/javascript">
    var employeeRecord;
    
    var openRoleSetDetails = function (record, animTrg) {
        employeeRecord = record;
        var window = <%= EmployeeDetailsWindow.ClientID %>;
        window.show(animTrg);
        
        <%= hdRoleID.ClientID %>.setValue(record.id);
        <%= tfRoleName.ClientID %>.setValue(record.data['RoleName']);
       
        window.show(animTrg);
        
        Coolite.AjaxMethods.BindTree();
    }
  
</script>

<asp:PlaceHolder ID="storeHolder" runat="server">
    <ext:Store ID="ProvincesStore" runat="server" UseIdConfirmation="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="TerId">
                <Fields>
                    <ext:RecordField Name="TerId" />
                    <ext:RecordField Name="Description" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
        </Listeners>
    </ext:Store>
</asp:PlaceHolder>
<ext:Window ID="EmployeeDetailsWindow" runat="server" Icon="Group" Title="经销商信息查询权限设定"
    Width="630" Height="450" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Closable="false">
    <Body>
        <ext:FitLayout ID="FitLayout1" runat="server">
            <ext:Panel runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="True">
                            <ext:Panel ID="plSearch" runat="server" Header="true" Frame="true" AutoHeight="true"
                                Icon="Find">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="tfRoleName" runat="server" FieldLabel="角色名称" Width="180" ReadOnly="true" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="hdRoleID" runat="server" Hidden="true" FieldLabel="角色ID" Width="180"
                                                                ReadOnly="true" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="tfLastUpdateUser" Hidden="true" runat="server" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                            </ext:Panel>
                        </North>
                        <Center>
                            <ext:TreePanel ID="TreePanel1" runat="server" Icon="Anchor" Title="经销商信息模块" AutoScroll="true"
                                Width="250" Collapsed="False" CollapseFirst="True" HideParent="False" RootVisible="False"
                                BodyStyle="padding-left:10px">
                            </ext:TreePanel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:Panel>
        </ext:FitLayout>
    </Body>
    <Buttons>
        <ext:Button ID="SaveButton" runat="server" Text="Save" Icon="Disk">
            <AjaxEvents>
                <Click OnEvent="SaveButton_Click" />
            </AjaxEvents>
        </ext:Button>
        <ext:Button ID="CancelButton" runat="server" Text="Cancel" Icon="Cancel">
            <Listeners>
                <Click Handler="#{EmployeeDetailsWindow}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
