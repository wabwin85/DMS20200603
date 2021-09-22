<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.Test" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>



<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>GridPanel with Form Details - Coolite Toolkit Examples</title>
    <link href="../../../../resources/css/examples.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        
        <ext:Store ID="Store1" runat="server" UseIdConfirmation="true" OnRefreshData="Store1_RefershData"
            >
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={15}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="DmaId">
                    <Fields>
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="DmaChineseName" />
                        <ext:RecordField Name="DmaDealerType" />
                        <ext:RecordField Name="DmaSapCode" />
                        <ext:RecordField Name="DmaRegisteredCapital" />
                        <ext:RecordField Name="DmaGeneralManager" />
                        <ext:RecordField Name="DmaAddress" />
                        
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="DmaChineseName" Direction="DESC" />
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('Suppliers - Load failed', e.message || e )" />
                <CommitFailed Handler="Ext.Msg.alert('Suppliers - Commit failed', 'Reason: ' + msg)" />
                <SaveException Handler="Ext.Msg.alert('Suppliers - Save failed', e.message || e)" />
                <CommitDone Handler="Ext.Msg.alert('Suppliers - Commit', 'The data successfully saved');" />
            </Listeners>
        </ext:Store>
        
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5">
                        <ext:Panel 
                            ID="Panel1" 
                            runat="server" 
                            Title="Description" 
                            Height="100" 
                            BodyStyle="padding: 5px;"
                            Frame="true" 
                            Icon="Information">
                            <Body>
                                <h1>GridPanel with Form Details</h1>
                                <p>Click on any record with the GridPanel and the record details will be loaded into the Details Form.</p>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 0 5 5">
                        <ext:Panel ID="Panel12" 
                            runat="server" 
                            Frame="true" 
                            Title="test" 
                            Icon="UserSuit">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel 
                                        ID="GridPanel1" 
                                        runat="server" 

                                        StoreID="Store1"
                                        Border="false" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DmaId" DataIndex="DmaId" Header="DmaId" />
                                                <ext:Column DataIndex="DmaChineseName" Header="DmaChineseName" Width="150" />
                                                <ext:Column ColumnID="DmaDealerType" DataIndex="DmaDealerType" Header="DmaDealerType" />
                                                <ext:Column DataIndex="DmaSapCode" Header="DmaSapCode" Width="150" />
                                            </Columns>
                                        </ColumnModel>

                                        <BottomBar>
                                            <ext:PagingToolBar 
                                                ID="PagingToolBar1" 
                                                runat="server" 
                                                PageSize="10" 
                                                StoreID="Store1" 
                                                />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                    <East MarginsSummary="0 5 5 5">
                        <ext:Panel 
                            ID="Details" 
                            runat="server" 
                            Frame="true" 
                            Title="test Details" 
                            Width="280"
                            Icon="User">
                            <Body>
                                <ext:FormLayout ID="FormLayout1" runat="server">
                                    <ext:Anchor>
                                        <ext:TextField 
                                            ID="DmaId" 
                                            runat="server" 
                                            FieldLabel="DmaId" 
                                            Width="150"
                                            ReadOnly="true" 
                                            />
                                    </ext:Anchor>
                                    <ext:Anchor>
                                        <ext:TextField 
                                            ID="DmaChineseName" 
                                            runat="server" 
                                            FieldLabel="DmaChineseName" 
                                            Width="150"
                                            ReadOnly="true" 
                                            />
                                    </ext:Anchor>
                                    
                                 
                                </ext:FormLayout>
                            </Body>
                        </ext:Panel>
                    </East>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </form>
</body>
</html>
