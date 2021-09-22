<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VersionComparisonConfirm.aspx.cs"
    Inherits="DMS.Website.Pages.DP.VersionComparisonConfirm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>版本比较</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Store ID="VersionStore" runat="server" UseIdConfirmation="true" OnRefreshData="Version_RefreshData"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Version">
                    <Fields>
                        <ext:RecordField Name="Version" />
                        <ext:RecordField Name="Version" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="VersionCompStore" runat="server" UseIdConfirmation="true" OnRefreshData="VersionComp_RefreshData"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Version">
                    <Fields>
                        <ext:RecordField Name="Version" />
                        <ext:RecordField Name="Version" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="ComparisonListStore" runat="server" UseIdConfirmation="true" OnRefreshData="ComparisonList_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="ID">
                    <Fields>
                        <ext:RecordField Name="MainGrpModleName" />
                        <ext:RecordField Name="MinorGrpModleName" />
                        <ext:RecordField Name="ControlName" />
                        <ext:RecordField Name="VerSrcValue" />
                        <ext:RecordField Name="VerTagValue" />
                        <ext:RecordField Name="DiffType" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="MinorGrpModleName" Direction="ASC" />
        </ext:Store>
        <ext:Hidden runat="server" ID="hfUser_Code">
        </ext:Hidden>
        <ext:Hidden runat="server" ID="hfModleID">
        </ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="版本比较" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="ddlVersion" runat="server" EmptyText="版本" Width="220" Editable="true"
                                                            TypeAhead="true" StoreID="VersionStore" ValueField="Version" DisplayField="Version"
                                                            FieldLabel="版本" ListWidth="300" Resizable="true" Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除选择" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="ddlVersionComp" runat="server" EmptyText="比较版本" Width="220" Editable="true"
                                                            TypeAhead="true" StoreID="VersionCompStore" ValueField="Version" DisplayField="Version"
                                                            FieldLabel="比较版本" ListWidth="300" Resizable="true" Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除选择" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                               
                                <ext:Button ID="btnComparison" runat="server" Text="比较" Icon="PageGo" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{GridPanel_Comparison}.reload();" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel_Comparison" runat="server" Title="比较结果" StoreID="ComparisonListStore"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="MainGrpModleName" DataIndex="MainGrpModleName" Header="大类名称" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="MinorGrpModleName" DataIndex="MinorGrpModleName" Header="小类名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="ControlName" DataIndex="ControlName" Header="控件名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="VerSrcValue" DataIndex="VerSrcValue" Header="版本值">
                                                </ext:Column>
                                                <ext:Column ColumnID="VerTagValue" DataIndex="VerTagValue" Header="比较版本值">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiffType" DataIndex="DiffType" Header="小类名称">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
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
    </div>
    </form>
</body>
</html>
