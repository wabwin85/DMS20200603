<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AuthorizationDialog.ascx.cs" Inherits="DMS.Website.Controls.AuthorizationDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<style type="text/css">
    .list-item {
        font: normal 11px tahoma, arial, helvetica, sans-serif;
        padding: 3px 10px 3px 10px;
        border: 1px solid #fff;
        border-bottom: 1px solid #eeeeee;
        white-space: normal;
        color: #555;
    }

        .list-item h3 {
            display: block;
            font: inherit;
            font-weight: bold;
            color: #222;
        }

    .form-toolbar {
        top: 1px;
        position: relative;
    }
</style>

<%--授权情况查询--%>
<ext:Store ID="AuthorStore" runat="server" OnRefreshData="AuthorStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="row_number">
            <Fields>
                <ext:RecordField Name="row_number" />
                <ext:RecordField Name="UPN" />
                <ext:RecordField Name="ProductName" />
                <ext:RecordField Name="HospitalName" />
                <ext:RecordField Name="HospitalCode" />
                <ext:RecordField Name="AuthorType" />
                <ext:RecordField Name="StartDate" Type="Date" />
                <ext:RecordField Name="EndDate" Type="Date" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Window ID="AuthorizationWindow" runat="server" Icon="Group" Title="授权查询" Width="800" Height="460" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:1px;" Resizable="false" Header="false" CenterOnLoad="true">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:Panel ID="Panel6" runat="server" Title="促销政策查询" AutoHeight="true" BodyStyle="padding: 5px;"
                    Frame="true" Icon="Find">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtAtuUPN" runat="server" Width="180" FieldLabel="产品编号" Enabled="false" ReadOnly="true" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtAutHospital" runat="server" Width="180" FieldLabel="医院" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:DateField ID="dfAutDate" runat="server" Width="160" FieldLabel="用量日期" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="Button2" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                            <Listeners>
                                <Click Handler="#{PagingToolBar3}.changePage(1);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel10" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout3" runat="server">
                            <ext:GridPanel ID="GridPanelAut" runat="server" Title="查询结果" StoreID="AuthorStore"
                                Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="row_number" DataIndex="row_number" Header="序号" Width="50">
                                        </ext:Column>
                                        <ext:Column ColumnID="ProductName" DataIndex="ProductName" Header="授权产品分类" Width="150">
                                        </ext:Column>
                                        <ext:Column ColumnID="AuthorType" DataIndex="AuthorType" Align="Left" Header="授权类型" Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="HospitalName" Width="200" Align="Left" DataIndex="HospitalName" Header="授权医院">
                                        </ext:Column>
                                        <ext:Column ColumnID="StartDate" Width="100" Align="Right" DataIndex="StartDate"
                                            Header="起始时间">
                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                        </ext:Column>
                                        <ext:Column ColumnID="EndDate" Width="100" Align="Right" DataIndex="EndDate" Header="终止时间">
                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="10" StoreID="AuthorStore"
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
    <Listeners>
        <Hide Handler="#{GridPanelAut}.clear();" />
    </Listeners>
</ext:Window>
<ext:Hidden ID="hiddenDealerId" runat="server" />
<ext:Hidden ID="hiddenUpn" runat="server" />
