<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerMaintainList.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.DealerMaintainList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">

        <script type="text/javascript">
            var cancelDealerWindow =function()
            {
                <%= WindowDealer.ClientID %>.hide(null);
            }
        
            var afterDealerInfoDetails = function() {
                Ext.Msg.alert('提示', '保存成功');
                <%= WindowDealer.ClientID %>.hide(null);
                Ext.getCmp('<%=this.GridDealerInfor.ClientID%>').reload();
            }
        </script>

        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="ChineseShortName" />
                        <ext:RecordField Name="EnglishName" />
                        <ext:RecordField Name="EnglishShortName" />
                        <ext:RecordField Name="Nbr" />
                        <ext:RecordField Name="SapCode" />
                        <ext:RecordField Name="DealerType" />
                        <ext:RecordField Name="CompanyType" />
                        <ext:RecordField Name="CompanyGrade" />
                        <ext:RecordField Name="DealerAuthentication" />
                        <ext:RecordField Name="FirstContractDate" />
                        <ext:RecordField Name="RegisteredAddress" />
                        <ext:RecordField Name="Address" />
                        <ext:RecordField Name="ShipToAddress" />
                        <ext:RecordField Name="PostalCode" />
                        <ext:RecordField Name="Phone" />
                        <ext:RecordField Name="Fax" />
                        <ext:RecordField Name="ContactPerson" />
                        <ext:RecordField Name="Email" />
                        <ext:RecordField Name="GeneralManager" />
                        <ext:RecordField Name="LegalRep" />
                        <ext:RecordField Name="RegisteredCapital" />
                        <ext:RecordField Name="Bank" />
                        <ext:RecordField Name="BankAccount" />
                        <ext:RecordField Name="TaxNo" />
                        <ext:RecordField Name="License" />
                        <ext:RecordField Name="LicenseLimit" />
                        <ext:RecordField Name="Province" />
                        <ext:RecordField Name="City" />
                        <ext:RecordField Name="District" />
                        <ext:RecordField Name="SalesMode" />
                        <ext:RecordField Name="Taxpayer" />
                        <ext:RecordField Name="Finance" />
                        <ext:RecordField Name="FinancePhone" />
                        <ext:RecordField Name="FinanceEmail" />
                        <ext:RecordField Name="Payment" />
                        <ext:RecordField Name="EstablishDate" />
                        <ext:RecordField Name="SystemStartDate" />
                        <ext:RecordField Name="Certification" />
                        <ext:RecordField Name="HostCompanyFlag" />
                        <ext:RecordField Name="DealerOrderNbrName" />
                        <ext:RecordField Name="SapInvoiceToEmail" />
                        <ext:RecordField Name="LastUpdateDate" Type="Date" />
                        <ext:RecordField Name="LastUpdateUser" />
                        <ext:RecordField Name="LastUpdateUserName" />
                        <ext:RecordField Name="ActiveFlag" />
                        <ext:RecordField Name="DeletedFlag" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="ChineseShortName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{cbDealer}.setValue(#{hidInitDealerId}.getValue());" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="DealerTypeStore" runat="server" UseIdConfirmation="true" OnRefreshData="DealerTypeStore_RefreshData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Key" Direction="ASC" />
            <Listeners>
            </Listeners>
        </ext:Store>
        <ext:Store ID="ContractStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Distributorid" />
                        <ext:RecordField Name="DistributorName" />
                        <ext:RecordField Name="Position" />
                        <ext:RecordField Name="Contract" />
                        <ext:RecordField Name="Phone" />
                        <ext:RecordField Name="Mobile" />
                        <ext:RecordField Name="EMail" />
                        <ext:RecordField Name="Address" />
                        <ext:RecordField Name="Remark" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="hidInitDealerId" runat="server">
        </ext:Hidden>
        <div>
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="True">
                            <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                                Icon="Find">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择经销商..." Width="200" Editable="true"
                                                                TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                                Mode="Local" FieldLabel="经销商中文名称" ListWidth="300" Resizable="true">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="清除" />
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
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel2" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout2" runat="server">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDealerType" runat="server" EmptyText="请选择经销商类型..." Width="200"
                                                                Editable="true" TypeAhead="true" StoreID="DealerTypeStore" ValueField="Key" DisplayField="Value"
                                                                Mode="Local" FieldLabel="经销商类型" ListWidth="300" Resizable="true">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="清除" />
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
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel3" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout3" runat="server">
                                                        <ext:Anchor>
                                                            <ext:Hidden ID="hd" runat="server">
                                                            </ext:Hidden>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                                <Buttons>
                                    <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                        <Listeners>
                                            <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="BtnExport" runat="server" Text="导出" Icon="PageExcel" IDMode="Legacy"
                                        AutoPostBack="true" OnClick="ExportExcel">
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </North>
                        <Center>
                            <ext:Panel runat="server" ID="l46" Border="false" Frame="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                        <ext:GridPanel ID="GridDealerInfor" runat="server" Title="查询结果" StoreID="ResultStore"
                                            Border="false" Icon="Lorry" StripeRows="true">
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="Id" DataIndex="Id" Header="经销商ID" Width="250" Hidden="true">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="经销商中文名称" Width="250">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="经销商英文名称" Width="250"
                                                        Hidden="true">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DealerType" DataIndex="DealerType" Header="经销商类型">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Address" DataIndex="Address" Header="地址">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Province" Hidden="true" DataIndex="Province" Header="省份">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="City" Hidden="true" DataIndex="City" Header="城市">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PostalCode" DataIndex="PostalCode" Header="邮编">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Phone" DataIndex="Phone" Header="电话">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Fax" DataIndex="Fax" Header="传真">
                                                    </ext:Column>
                                                    <ext:CheckColumn ColumnID="ActiveFlag" DataIndex="ActiveFlag" Header="状态" Width="50">
                                                    </ext:CheckColumn>
                                                    <ext:CommandColumn Header="上传附件" Width="60" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="VcardEdit" CommandName="Modify" ToolTip-Text="上传">
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                    <ext:CommandColumn Header="维护" Width="60" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="VcardEdit" CommandName="Update" ToolTip-Text="维护">
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                    <ext:CommandColumn Header="经销商更名" Width="60" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="VcardEdit" CommandName="Updatedealername" ToolTip-Text="经销商更名">
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="if (command == 'Modify')
                                                                   {
                                                                    var id = record.data.Id;
                                                                    window.location.href = '/Pages/MasterDatas/DealerDeatil.aspx?DealerId=' + id;
                                                                   }
                                                                else if (command == 'Update')
                                                                {
                                                                    #{hdDealerId}.setValue(record.data.Id);
                                                                    Coolite.AjaxMethods.ShowDealerInfo(record.data.Id,{success: function(){#{WindowDealer}.show();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                }
                                                              else if(command == 'Updatedealername')
                                                              { 
                                                                   #{hidEnglish}.setValue(record.data.EnglishName);
                                                                   Coolite.AjaxMethods.ShowResellerRename(record.data.ChineseName,record.data.SapCode,record.data.DealerType,record.data.Id,{success: function(){#{ResellerRename}.show();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                     }
                                              " />
                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                    DisplayInfo="true" EmptyMsg="没有数据显示" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="处理中..." />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:ViewPort>
            <ext:Window ID="WindowDealer" runat="server" Icon="Group" Title="经销商联系人维护" Height="500"
                Width="600" AutoShow="false" Resizable="false" Modal="true" BodyStyle="padding:5px;"
                ShowOnLoad="false" AutoScroll="true">
                <Body>
                    <ext:BorderLayout ID="BorderLayout2" runat="server">
                        <Center MarginsSummary="0 5 0 5">
                            <ext:Panel ID="plForm3" runat="server" Header="false" Height="300">
                                <Body>
                                    <ext:GridPanel ID="GridContract" runat="server" Title="查询结果" StoreID="ContractStore"
                                        Border="false" Icon="Lorry" Height="450" StripeRows="true">
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="Distributorid" DataIndex="Distributorid" Header="经销商ID" Width="250" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="DistributorName" DataIndex="DistributorName" Header="经销商名称" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="Position" DataIndex="Position" Header="职位" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="Contract" DataIndex="Contract" Header="联系人姓名" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="Phone" DataIndex="Phone" Header="联系人电话">
                                                </ext:Column>
                                                <ext:Column ColumnID="Mobile" DataIndex="Mobile" Header="联系人手机">
                                                </ext:Column>
                                                <ext:Column ColumnID="EMail" DataIndex="EMail" Header="联系人邮箱">
                                                </ext:Column>
                                                <ext:Column ColumnID="Address" DataIndex="Address" Header="联系人地址">
                                                </ext:Column>
                                                <ext:Column ColumnID="Remark" DataIndex="Remark" Header="联系人备注">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="ContractStore"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
                <Buttons>
                    <ext:Button ID="Button4" runat="server" Text="关闭" Icon="Cancel">
                        <Listeners>
                            <Click Handler="cancelDealerWindow();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Window>


            <ext:Window ID="ResellerRename" runat="server" Icon="Group" Title="经销商更名" AutoHeight="true"
                Width="700" AutoShow="false" Resizable="false" Modal="true" BodyStyle="padding:5px;"
                ShowOnLoad="false" AutoScroll="true">
                <Body>
                    <ext:Panel ID="Panel29" runat="server" Header="true" Frame="true">
                        <Body>
                            <ext:Panel ID="Panel36" runat="server" Header="false" AutoHeight="true" Border="false" FormGroup="true">
                                <Body>
                                    <ext:FormLayout ID="FormLayout27" runat="server">
                                        <ext:Anchor>
                                            <ext:Panel ID="Panel77" runat="server" Header="false" AutoHeight="true">
                                                <Body>
                                                    <ext:ColumnLayout ID="ColumnLayout9" runat="server">
                                                        <ext:LayoutColumn ColumnWidth="0.5">
                                                            <ext:Panel ID="Panel34" runat="server" Header="false" AutoHeight="true" Border="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout22" runat="server">
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="dealername" runat="server" FieldLabel="原经销商名称" Enabled="false" Width="200">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth="0.5">
                                                            <ext:Panel ID="Panel35" runat="server" Header="false" AutoHeight="true" Border="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout25" runat="server">
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="NewDealerName" runat="server" FieldLabel="新经销商名称" Width="200">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                    </ext:ColumnLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>
                            <ext:Panel ID="newenglish" runat="server" Header="false" AutoHeight="true" Border="false" FormGroup="true">
                                <Body>
                                    <ext:FormLayout ID="FormLayout23" runat="server">
                                        <ext:Anchor>
                                            <ext:Panel ID="Panel30" runat="server" Header="false" AutoHeight="true">
                                                <Body>
                                                    <ext:ColumnLayout ID="ColumnLayout8" runat="server">
                                                        <ext:LayoutColumn ColumnWidth="0.5">
                                                            <ext:Panel ID="Panel31" runat="server" Header="false" AutoHeight="true">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout24" runat="server">
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="EnglishName" runat="server" FieldLabel="原英文名称" Enabled="false" Width="200">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth="0.5">
                                                            <ext:Panel ID="Panel32" runat="server" Header="false" AutoHeight="true">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout26" runat="server">
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="NewEnglishName" runat="server" FieldLabel="新英文名称" Width="200">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                    </ext:ColumnLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>

                        </Body>
                    </ext:Panel>
                </Body>
                <Buttons>
                    <ext:Button ID="Submit" runat="server" Text="提交" Icon="Disk">
                        <Listeners>
                            <Click Handler="
                             Ext.Msg.confirm('提示','请确认修改信息',
                                        function(e){
                                       if(e == 'yes'){
                            Coolite.AjaxMethods.UpdateResellerename({success: function(){},failure: function(err) {Ext.Msg.alert('Error', err);}}
                            
                            )}});" />




                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="Close" runat="server" Text="关闭" Icon="Cancel">
                        <Listeners>
                            <Click Handler="Ext.getCmp('ResellerRename').hide();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Window>

            <ext:Hidden ID="hdDealerId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hdSapcode" runat="server"></ext:Hidden>
            <ext:Hidden ID="hddealertype" runat="server"></ext:Hidden>
            <ext:Hidden ID="DealerID" runat="server"></ext:Hidden>
            <ext:Hidden ID="hidEnglish" runat="server"></ext:Hidden>
    </form>
</body>
</html>
