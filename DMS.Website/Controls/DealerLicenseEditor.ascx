<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DealerLicenseEditor.ascx.cs"
    Inherits="DMS.Website.Controls.DealerLicenseEditor" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
<style type="text/css">
    .x-form-empty-field {
        color: #bbbbbb;
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }

    .x-small-editor .x-form-field {
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }

    .x-small-editor .x-form-text {
        height: 20px;
        line-height: 16px;
        vertical-align: middle;
    }

    .editable-column {
        background: #FFFF99;
    }

    .nonEditable-column {
        background: #FFFFFF;
    }

    .yellow-row {
        background: #FFD700;
    }

    .lightyellow-row {
        background: #FFFFD8;
    }

    .x-panel-body {
        background-color: #dfe8f6;
    }

    .x-column-inner {
        height: auto !important;
        width: auto !important;
    }

    .list-item {
        font: normal 11px tahoma, arial, helvetica, sans-serif;
        padding: 3px 10px 3px 10px;
        border: 1px solid #fff;
        border-bottom: 1px solid #eeeeee;
        white-space: normal;
        color: #555;
    }
</style>

<script type="text/javascript">
    var SelectSecondLevelCatagory = function () {

        var hidDealerId = Ext.getCmp('<%=this.hidDealerId.ClientID%>');
        var catType = '二类';
        Coolite.AjaxMethods.DealerLicenseEditor.ShowDialog(hidDealerId.getValue(), catType,
        {
            success: function () {

            },
            failure: function (err) {
                Ext.Msg.alert('Error', err);
            }
        }
        );

    }

    var SelectThirdLevelCatagory = function () {

        var hidDealerId = Ext.getCmp('<%=this.hidDealerId.ClientID%>')
        var catType = '三类';
        Coolite.AjaxMethods.DealerLicenseEditor.ShowDialog(hidDealerId.getValue(), catType,
        {
            success: function () {

            },
            failure: function (err) {
                Ext.Msg.alert('Error', err);
            }
        }
        );

    }

    //添加选中的产品
    var addItems = function (grid) {

        var catagoryType = Ext.getCmp('<%=this.hiddenDialogCatagoryType.ClientID%>');
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
            var param = '';
            for (var i = 0; i < selList.length; i++) {
                param += selList[i].get('CatagoryID') + ',';
            }
            if (catagoryType.getValue() == "三类") {
                Coolite.AjaxMethods.DealerLicenseEditor.RefreshNewCatagoryGrid(param, '三类');
            } else {
                Coolite.AjaxMethods.DealerLicenseEditor.RefreshNewCatagoryGrid(param, '二类')
            }
        } else {
            Ext.MessageBox.alert('警告', '请选择要添加的产品分类代码');
        }
    }

    //触发函数
    function downloadfile(url) {
        var iframe = document.createElement("iframe");
        iframe.src = url;
        iframe.style.display = "none";
        document.body.appendChild(iframe);
    }
</script>

<ext:Hidden ID="hidDealerId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidCurSecondClassCatagory" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidNewSecondClassCatagory" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidCurThirdClassCatagory" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidNewThirdClassCatagory" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogDealerId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogCatagoryType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogCatagoryID" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDialogCatagoryName" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenNewApplyId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenFileName" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenLatestApptoveUpdate" runat="server">
</ext:Hidden>
<ext:Store ID="ShipToAddress" runat="server" UseIdConfirmation="false" OnRefreshData="ShipToAddress_RefershData"
    AutoLoad="false">
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="SWA_AddressType" />
                <ext:RecordField Name="SWA_WH_Address" />
                <ext:RecordField Name="SWA_IsSendAddress" />
                <ext:RecordField Name="SWA_WH_Code" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="SecondClass2002CatagoryStore" runat="server">
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="CatagoryID" />
                <ext:RecordField Name="CatagoryName" />
                <ext:RecordField Name="CatagoryType" />
                <ext:RecordField Name="CatagoryStatus" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="CatagoryID" Direction="ASC" />
</ext:Store>
<ext:Store ID="SecondClass2017CatagoryStore" runat="server">
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="CatagoryID" />
                <ext:RecordField Name="CatagoryName" />
                <ext:RecordField Name="CatagoryType" />
                <ext:RecordField Name="CatagoryStatus" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="CatagoryID" Direction="ASC" />
</ext:Store>
<ext:Store ID="ThirdClass2002CatagoryStore" runat="server">
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="CatagoryID" />
                <ext:RecordField Name="CatagoryName" />
                <ext:RecordField Name="CatagoryType" />
                <ext:RecordField Name="CatagoryStatus" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="CatagoryID" Direction="ASC" />
</ext:Store>
<ext:Store ID="ThirdClass2017CatagoryStore" runat="server">
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="CatagoryID" />
                <ext:RecordField Name="CatagoryName" />
                <ext:RecordField Name="CatagoryType" />
                <ext:RecordField Name="CatagoryStatus" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="CatagoryID" Direction="ASC" />
</ext:Store>
<ext:Store ID="LicenseCatagoryStore" runat="server" OnRefreshData="LicenseCatagoryStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="CatagoryID" />
                <ext:RecordField Name="CatagoryName" />
                <ext:RecordField Name="CatagoryType" />
                <ext:RecordField Name="CatagoryStatus" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="CatagoryID" Direction="ASC" />
</ext:Store>
<ext:Store ID="CurAttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="false"
    OnRefreshData="CurAttachmentStore_Refresh">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Attachment" />
                <ext:RecordField Name="Name" />
                <ext:RecordField Name="Url" />
                <ext:RecordField Name="Type" />
                <ext:RecordField Name="UploadUser" />
                <ext:RecordField Name="Identity_Name" />
                <ext:RecordField Name="UploadDate" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>

<ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="PohId" />
                <ext:RecordField Name="OperUser" />
                <ext:RecordField Name="OperUserId" />
                <ext:RecordField Name="OperUserName" />
                <ext:RecordField Name="OperType" />
                <ext:RecordField Name="OperTypeName" />
                <ext:RecordField Name="OperDate" Type="Date" />
                <ext:RecordField Name="OperNote" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="CFDA证照信息申请及审批" Width="900"
    Height="620" AutoShow="false" Modal="true" ShowOnLoad="false"
    Resizable="false" Header="false" CenterOnLoad="true" Y="5">
    <Body>
        <ext:BorderLayout ID="BorderLayout3" runat="server">
            <North Collapsible="true">
                <ext:Panel ID="Panel9" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:Panel ID="Panel23" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                    <ext:LayoutColumn ColumnWidth="0.5">
                                        <ext:Panel ID="Panel20" runat="server" Border="false" Header="false" BodyStyle="padding:5px 15px 5px">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="CurRespPerson" runat="server" FieldLabel="企业负责人" Width="180">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.5">
                                        <ext:Panel ID="Panel21" runat="server" Border="false" Header="false" BodyStyle="padding:5px 15px 5px">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="CurLegalPerson" runat="server" FieldLabel="法人代表" Width="180">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                        <ext:Panel ID="Panel19" runat="server">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel22" runat="server" Border="false" Header="false" Title="医疗器械经营许可证信息">
                                            <Body>
                                                <ext:FieldSet ID="FieldSetCurLicense" runat="server" Header="true" Frame="false"
                                                    BodyBorder="true" AutoHeight="true" AutoWidth="true" Title="医疗器械经营许可证信息">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="100">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="CurLicenseNo" runat="server" FieldLabel="证件编号" Width="250" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="CurLicenseNoValidFrom" runat="server" Width="250" FieldLabel="起始日期" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="CurLicenseNoValidTo" runat="server" Width="250" FieldLabel="结束日期" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:FieldSet>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel24" runat="server" Border="false" Header="false" Title="医疗器械备案凭证信息">
                                            <Body>
                                                <ext:FieldSet ID="FieldSetCurFiling" runat="server" Header="true" Frame="false" BodyBorder="true"
                                                    AutoHeight="true" AutoWidth="true" Title="医疗器械备案凭证信息">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="100">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="CurFilingNo" runat="server" FieldLabel="证件编号" Width="250" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="CurFilingNoValidFrom" runat="server" FieldLabel="起始日期" Width="250" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="CurFilingNoValidTo" runat="server" FieldLabel="结束日期" Width="250" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:FieldSet>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                    </Body>
                </ext:Panel>
            </North>
            <Center>
                <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0">
                    <Tabs>
                        <ext:Tab ID="Tab3" runat="server" Title="ShipTo地址" BodyStyle="padding:0px 5px 0px">
                            <Body>
                                <ext:FitLayout ID="FT2" runat="server">

                                    <ext:GridPanel ID="GridPanel1" runat="server" StoreID="ShipToAddress"
                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                        Icon="Lorry">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                    <ext:Label ID="Label4" runat="server" Text="ShipTo地址" Icon="Lorry" />
                                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="SWA_WH_Code" DataIndex="SWA_WH_Code" Header="仓库代码" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="SWA_AddressType" DataIndex="SWA_AddressType" Header="地址类型" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="SWA_WH_Address" DataIndex="SWA_WH_Address" Header="地址名称" Width="300">
                                                </ext:Column>
                                                <ext:Column ColumnID="SWA_IsSendAddress" DataIndex="SWA_IsSendAddress" Header="是否默认发货地址" Width="110">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <%--  <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="50" StoreID="CurSecondClassCatagoryStore" DisplayInfo="true" />
                                                    </BottomBar>--%>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>

                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="tab4" runat="server" Title="二类医疗器械产品分类代码" BodyStyle="padding:0px 5px 0px">
                            <Body>
                                <ext:FormLayout ID="FormLayout13" runat="server">
                                    <ext:Anchor>
                                        <ext:Panel ID="Panel2" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:GridPanel ID="gpCurSecondClassCatagory" runat="server" Title="2002版二类医疗器械分类代码" StoreID="SecondClass2002CatagoryStore"
                                                    AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                                    Icon="Lorry" Height="190" Width="874">
                                                    <TopBar>
                                                        <ext:Toolbar ID="Toolbar3" runat="server">
                                                            <Items>
                                                                <ext:Label ID="Label1" runat="server" Text="二类医疗器械产品分类代码" Icon="Lorry" />
                                                                <ext:ToolbarFill ID="ToolbarFill3" runat="server" />
                                                            </Items>
                                                        </ext:Toolbar>
                                                    </TopBar>
                                                    <ColumnModel ID="ColumnModel1" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="CurCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="200">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="CurCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="CurCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="140">
                                                            </ext:Column>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server"
                                                            MoveEditorOnEnter="true">
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <SaveMask ShowMask="false" />
                                                    <LoadMask ShowMask="true" />
                                                </ext:GridPanel>
                                            </Body>
                                        </ext:Panel>
                                    </ext:Anchor>
                                    <ext:Anchor>
                                        <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:GridPanel ID="GridPanel2" runat="server" Title="2017版二类医疗器械分类代码" StoreID="SecondClass2017CatagoryStore"
                                                    AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                                    Icon="Lorry" Height="190" Width="874">
                                                    <TopBar>
                                                        <ext:Toolbar ID="Toolbar2" runat="server">
                                                            <Items>
                                                                <ext:Label ID="Label5" runat="server" Text="2017版二类医疗器械产品分类代码" Icon="Lorry" />
                                                                <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                            </Items>
                                                        </ext:Toolbar>
                                                    </TopBar>
                                                    <ColumnModel ID="ColumnModel4" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="CurCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="200">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="CurCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="CurCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="140">
                                                            </ext:Column>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                                            MoveEditorOnEnter="true">
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <SaveMask ShowMask="false" />
                                                    <LoadMask ShowMask="true" />
                                                </ext:GridPanel>
                                            </Body>
                                        </ext:Panel>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="tab5" runat="server" Title="三类医疗器械产品分类代码" BodyStyle="padding:0px 5px 0px">
                            <Body>
                                <ext:FormLayout ID="FormLayout14" runat="server">
                                    <ext:Anchor>
                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:GridPanel ID="gpCurThirdClassCatagory" runat="server" Title="2002版三类医疗器械产品分类代码" StoreID="ThirdClass2002CatagoryStore"
                                                    AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                                    Icon="Lorry" Height="190" Width="874">
                                                    <TopBar>
                                                        <ext:Toolbar ID="Toolbar4" runat="server">
                                                            <Items>
                                                                <ext:Label ID="Label2" runat="server" Text="2002版三类医疗器械产品分类代码" Icon="Lorry" />
                                                                <ext:ToolbarFill ID="ToolbarFill4" runat="server" />
                                                            </Items>
                                                        </ext:Toolbar>
                                                    </TopBar>
                                                    <ColumnModel ID="ColumnModel12" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="CurCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="200">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="CurCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="CurCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="140">
                                                            </ext:Column>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                            MoveEditorOnEnter="true">
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <SaveMask ShowMask="false" />
                                                    <LoadMask ShowMask="true" />
                                                </ext:GridPanel>
                                            </Body>
                                        </ext:Panel>
                                    </ext:Anchor>
                                    <ext:Anchor>
                                        <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:GridPanel ID="GridPanel3" runat="server" Title="2017版三类医疗器械产品分类代码" StoreID="ThirdClass2017CatagoryStore"
                                                    AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                                    Icon="Lorry" Height="190" Width="874">
                                                    <TopBar>
                                                        <ext:Toolbar ID="Toolbar6" runat="server">
                                                            <Items>
                                                                <ext:Label ID="Label6" runat="server" Text="2002版三类医疗器械产品分类代码" Icon="Lorry" />
                                                                <ext:ToolbarFill ID="ToolbarFill6" runat="server" />
                                                            </Items>
                                                        </ext:Toolbar>
                                                    </TopBar>
                                                    <ColumnModel ID="ColumnModel7" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="CurCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="200">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="CurCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="CurCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="140">
                                                            </ext:Column>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel6" SingleSelect="true" runat="server"
                                                            MoveEditorOnEnter="true">
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <SaveMask ShowMask="false" />
                                                    <LoadMask ShowMask="true" />
                                                </ext:GridPanel>
                                            </Body>
                                        </ext:Panel>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="tab6" runat="server" Title="附件" BodyStyle="padding:0px 5px 0px">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="gpCurAttachmentDonwload" runat="server" Title="附件列表" StoreID="CurAttachmentStore"
                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                        Icon="Lorry">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar5" runat="server">
                                                <Items>
                                                    <ext:Label ID="Label3" runat="server" Text="附件列表" Icon="Lorry" />
                                                    <ext:ToolbarFill ID="ToolbarFill5" runat="server" />
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel6" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="Name" DataIndex="Name" Header="附件名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="Url" DataIndex="Url" Header="路径" Hidden="true" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="上传人" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="上传时间" Width="90">
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad" ToolTip-Text="下载" />
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel5" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBarCurAttachement" runat="server" PageSize="100"
                                                StoreID="CurAttachmentStore" DisplayInfo="false" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="true" />
                                        <Listeners>
                                            <Command Handler="if (command == 'DownLoad')
                                                                            {
                                                                                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=DealerLicense';
                                                                                downloadfile(url);                                                                                
                                                                            }" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                    </Tabs>
                </ext:TabPanel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Buttons>
        <ext:Button runat="server" ID="close" Text="关闭" Icon="Delete">
            <Listeners>
                <Click Handler="#{DetailWindow}.hide()" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
<ext:Window ID="DialogCatagoryWindow" runat="server" Icon="Group" Title="产品分类代码选择"
    Width="800" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false">
    <Body>
        <ext:BorderLayout ID="BorderLayout1" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:Panel ID="Panel11" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel12" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCFN" runat="server" Width="200" FieldLabel="产品分类代码" EmptyText=""
                                                    SelectOnFocus="true" EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".5">
                                <ext:Panel ID="Panel13" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtLotNumber" runat="server" FieldLabel="产品分类名称" EmptyText=""
                                                    Width="200" SelectOnFocus="true" EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>

                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel14" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout5" runat="server">
                            <ext:GridPanel ID="gpDialogCatagory" runat="server" StoreID="LicenseCatagoryStore"
                                Title="查询结果" Border="false" Icon="Lorry" StripeRows="true" AutoWidth="true">
                                <ColumnModel ID="ColumnModel5" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="NewCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="NewCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                        </ext:Column>
                                        <ext:Column ColumnID="NewCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="100">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                                    </ext:CheckboxSelectionModel>
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


</ext:Window>
<ext:Window ID="WindowLog" runat="server" Icon="Lorry" Title="操作日志" ShowOnLoad="false"
    AutoHeight="false" Width="700" Height="350" ButtonAlign="Center">
    <Body>
        <ext:Panel ID="Panel18" runat="server" Title="" BodyStyle="padding: 0px;" Frame="false"
            Header="true" BodyBorder="false" Height="280">
            <Body>
                <ext:FitLayout ID="ftLog" runat="server">
                    <ext:GridPanel ID="gpLog" runat="server" Title="操作日志" StoreID="OrderLogStore" AutoWidth="true"
                        Height="200" StripeRows="true" Collapsible="false" Border="false" Icon="Lorry"
                        Header="false" AutoExpandColumn="OperNote" AutoScroll="true">
                        <ColumnModel ID="ColumnModel8" runat="server">
                            <Columns>
                                <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="操作人账号" Width="60">
                                </ext:Column>
                                <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="操作人姓名" Width="90">
                                </ext:Column>
                                <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="操作类型" Width="80">
                                </ext:Column>
                                <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="操作时间" Width="110">
                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                </ext:Column>
                                <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="操作备注说明">
                                </ext:Column>
                            </Columns>
                        </ColumnModel>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel7" SingleSelect="true" runat="server"
                                MoveEditorOnEnter="true">
                            </ext:RowSelectionModel>
                        </SelectionModel>
                        <BottomBar>
                            <ext:PagingToolbar ID="PagingToolBarLog" runat="server" PageSize="30" StoreID="OrderLogStore"
                                DisplayInfo="false" />
                        </BottomBar>
                        <SaveMask ShowMask="false" />
                        <LoadMask ShowMask="true" />
                    </ext:GridPanel>
                </ext:FitLayout>
            </Body>
        </ext:Panel>
    </Body>

</ext:Window>
