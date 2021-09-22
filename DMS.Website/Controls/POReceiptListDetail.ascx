<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="POReceiptListDetail.ascx.cs" Inherits="DMS.Website.Controls.POReceiptListDetail" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<ext:Store ID="DetailStore" runat="server" 
    OnRefreshData="DetailStore_RefershData" AutoLoad="true">
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
             <ext:RecordField Name="CFN" />
             <ext:RecordField Name="UPN" />
             <ext:RecordField Name="LotNumber" />
             <ext:RecordField Name="ExpiredDate" />
             <ext:RecordField Name="UnitOfMeasure" />
             <ext:RecordField Name="ReceiptQty" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="CFN" Direction="ASC" />
</ext:Store>

<ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>" Width="800" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Resizable="false" Header="false">
    <Body>
        <ext:BorderLayout ID="BorderLayout1" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">   
                <ext:Panel ID="Panel5" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>           
                        <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                            <ext:LayoutColumn ColumnWidth=".4">
                                <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="50">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtDealer" runat="server" Width="200" FieldLabel="<%$ Resources: DetailWindow.txtDealer.FieldLabel %>" ReadOnly="true"/>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtVendor" runat="server" Width="200" FieldLabel="<%$ Resources: DetailWindow.txtVendor.FieldLabel %>" ReadOnly="true"/>
                                            </ext:Anchor>                                              
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".3">
                                <ext:Panel ID="Panel1" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtSapNumber" runat="server" FieldLabel="<%$ Resources: DetailWindow.txtSapNumber.FieldLabel %>" ReadOnly="true"/>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtDate" runat="server" FieldLabel="<%$ Resources: DetailWindow.txtDate.FieldLabel %>" ReadOnly="true"/>
                                            </ext:Anchor>                                              
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".3">
                                <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtPoNumber" runat="server" FieldLabel="<%$ Resources: DetailWindow.txtPoNumber.FieldLabel %>" ReadOnly="true"/>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtStatus" runat="server" FieldLabel="<%$ Resources: DetailWindow.txtStatus.FieldLabel %>" ReadOnly="true"/>
                                            </ext:Anchor>                                              
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 0 5">
                <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout1" runat="server">
                            <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" StoreID="DetailStore" Border="false" Icon="Lorry" StripeRows="true" AutoWidth="true">
                                <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="CFN" DataIndex="CFN" Header="<%$ Resources: GridPanel1.CFN.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="UPN" DataIndex="UPN" Header="<%$ Resources: GridPanel1.UPN.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel1.LotNumber.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources: GridPanel1.ExpiredDate.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources: GridPanel1.UnitOfMeasure.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="ReceiptQty" DataIndex="ReceiptQty" Header="<%$ Resources: GridPanel1.ReceiptQty.Header %>">
                                            </ext:Column>
                                        </Columns>
                                </ColumnModel>                                    
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolBar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="DetailStore" DisplayInfo="false" />
                                </BottomBar>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </Center>             
        </ext:BorderLayout>
    </Body>
</ext:Window>