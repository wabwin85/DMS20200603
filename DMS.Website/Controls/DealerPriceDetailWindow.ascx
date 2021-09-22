<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DealerPriceDetailWindow.ascx.cs"
    Inherits="DMS.Website.Controls.DealerPriceDetailWindow" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
<style type="text/css">
    .x-form-empty-field
    {
        color: #bbbbbb;
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }
    .x-small-editor .x-form-field
    {
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }
    .x-small-editor .x-form-text
    {
        height: 20px;
        line-height: 16px;
        vertical-align: middle;
    }
    .editable-column
    {
        background: #FFFF99;
    }
    .nonEditable-column
    {
        background: #FFFFFF;
    }
    .yellow-row
    {
        background: #FFD700;
    }
</style>

<script type="text/javascript" language="javascript">
    //初次载入详细信息窗口时读取数据
    function RefreshDetailWindow() {
        Ext.getCmp('<%=this.gpLog.ClientID%>').reload();
    }
</script>
<ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="DPD_ID" />
                <ext:RecordField Name="DPD_LineNbr" />
                <ext:RecordField Name="DPD_FileName" />
                <ext:RecordField Name="DPD_ArticleNumber" />
                <ext:RecordField Name="DPD_Dealer" />
                <ext:RecordField Name="DPD_Price" />
                <ext:RecordField Name="DPD_PriceTypeName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Hidden ID="hidInstanceId" runat="server">
</ext:Hidden>
<ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
    Width="980" Height="490" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <Center MarginsSummary="0 5 5 5">
                <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore"
                    AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                    Icon="Lorry" AutoExpandColumn="DPD_PriceTypeName">
                    <ColumnModel ID="ColumnModel1" runat="server">
                        <Columns>
                            <ext:Column ColumnID="DPD_LineNbr" DataIndex="DPD_LineNbr" Header="<%$ Resources: gpLog.LineNbr %>"
                                Width="100">
                            </ext:Column>
                            <ext:Column ColumnID="DPD_ArticleNumber" DataIndex="DPD_ArticleNumber" Header="<%$ Resources: gpLog.ArticleNumber %>"
                                Width="200">
                            </ext:Column>
                            <ext:Column ColumnID="DPD_Dealer" DataIndex="DPD_Dealer" Header="<%$ Resources: gpLog.Dealer %>"
                                Width="200">
                            </ext:Column>
                            <ext:Column ColumnID="DPD_Price" DataIndex="DPD_Price" Header="<%$ Resources: gpLog.Price %>"
                                Width="150">
                            </ext:Column>
                            <ext:Column ColumnID="DPD_PriceTypeName" DataIndex="DPD_PriceTypeName" Header="<%$ Resources: gpLog.PriceTypeName %>">
                            </ext:Column>
                        </Columns>
                    </ColumnModel>
                    <BottomBar>
                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="50" StoreID="OrderLogStore"
                            DisplayInfo="true" />
                    </BottomBar>
                </ext:GridPanel>
            </Center>
        </ext:BorderLayout>
    </Body>
</ext:Window>
