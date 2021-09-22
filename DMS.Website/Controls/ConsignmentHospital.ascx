<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ConsignmentHospital.ascx.cs" Inherits="DMS.Website.Controls.ConsignmentHospital" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    var openHospitalSearchDlg2 = function (animTrg) {
        var window = <%= hospitalSelectedDlg.ClientID %>;
         <%= cmbProvince.ClientID %>.setValue('');
         <%= txtSearchHospitalName.ClientID %>.setValue('');
         <%= cmbCity.ClientID %>.setValue('');
         <%= cmbDistrict.ClientID %>.setValue('');
         <%=hiddenSelectedProductLine.ClientID %>.setValue(animTrg);
        <%= GridPanel1.ClientID %>.clear();
    window.show(null);
  }
    

        var addItems3 = function (grid) {

            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();

                if (selList.length == 1) {
                    var param1 = selList[0].data.HOS_HospitalName;
                    var param2 = selList[0].data.HOS_Address;
                    //alert(param1);
                    //alert(param2);
                    Coolite.AjaxMethods.DoAddItem(param1, param2,
                        {
                            success: function () {
                                Ext.getCmp('<%=this.hospitalSelectedDlg.ClientID%>').hide();
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    );
                }
                if (selList.length > 1) {

                    Ext.MessageBox.alert('Message', '医院选择必须唯一');
                }

            }
        }

</script>
<ext:Store ID="HospitalSearchDlgStore" runat="server" UseIdConfirmation="false" OnRefreshData="HospitalStore_RefershData"
    AutoLoad="false">
    <AutoLoadParams>
        <ext:Parameter Name="start" Value="={0}" />
        <ext:Parameter Name="limit" Value="={15}" />
    </AutoLoadParams>
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="HosId">
            <Fields>
                <ext:RecordField Name="HosId" />
                <ext:RecordField Name="HOS_District" />
                <ext:RecordField Name="HOS_City" />
                <ext:RecordField Name="HOS_Province" />
                <ext:RecordField Name="HOS_Address" />
                <ext:RecordField Name="HOS_HospitalName" />
                <ext:RecordField Name="HOS_Key_Account" />

            </Fields>
        </ext:JsonReader>
    </Reader>

</ext:Store>
<ext:Store ID="HospitalGradeStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_HospitalGrade" AutoLoad="false">
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
    <Listeners>
    </Listeners>
</ext:Store>
<ext:Store ID="ProvincesStore" runat="server" UseIdConfirmation="true" OnRefreshData="RefreshProvinces">
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
<ext:Store ID="CitiesStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshCities" AutoLoad="false">
    <AutoLoadParams>
        <ext:Parameter Name="parentId" Value="={0}" />
    </AutoLoadParams>
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
<ext:Store ID="DistrictStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshDistricts">
    <AutoLoadParams>
        <ext:Parameter Name="parentId" Value="={0}" />
    </AutoLoadParams>
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
<ext:Window ID="hospitalSelectedDlg" runat="server" Icon="Group" Title="医院选择"
    Closable="true" Draggable="false" Resizable="true" Width="720" Height="475" AutoShow="false"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" CenterOnLoad="true" Y="5" Maximizable="true">
    <Body>
        <ext:BorderLayout ID="BorderLayout1" runat="server">
            <North MarginsSummary="5 5 5" Collapsible="true">
                <ext:Panel ID="Panel1" runat="server" AutoHeight="true"
                    BodyStyle="padding: 5px;" Frame="true" Icon="Find">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                            <ext:LayoutColumn ColumnWidth=".3">
                                <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="70">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cmbProvince" runat="server" FieldLabel="省份" StoreID="ProvincesStore"
                                                    Editable="false" DisplayField="Description" ValueField="TerId"
                                                    EmptyText="选择...." Width="120">
                                                    <Listeners>
                                                        <Select Handler="#{cmbCity}.clearValue(); #{CitiesStore}.reload();" />
                                                        <TriggerClick Handler="this.clearValue();#{cmbCity}.clearValue();#{cmbDistrict}.clearValue();" />
                                                    </Listeners>
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                    </Triggers>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtSearchHospitalName" runat="server" FieldLabel="医院名称" Width="120" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".35">
                                <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="70">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cmbCity" runat="server" FieldLabel="地区" StoreID="CitiesStore" Editable="false"
                                                    DisplayField="Description" ValueField="TerId"
                                                    EmptyText="选择...." Width="120">
                                                    <Listeners>
                                                        <Select Handler="#{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                        <TriggerClick Handler="this.clearValue();#{cmbDistrict}.clearValue();" />
                                                    </Listeners>
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                    </Triggers>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".33">
                                <ext:Panel ID="Panel2" runat="server" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="70">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cmbDistrict" runat="server" FieldLabel="区/县" StoreID="DistrictStore"
                                                    Editable="false" DisplayField="Description" ValueField="TerId" EmptyText="选择..." Width="120">
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                    </Triggers>
                                                </ext:ComboBox>
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
                                <Click Handler="#{GridPanel1}.clear();#{GridPanel1}.reload();" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="btnOk" runat="server" Text="确认" Icon="Disk"
                            IDMode="Legacy" Enabled="false">
                            <Listeners>
                                <Click Handler="addItems3(#{GridPanel1});" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="btnCancel" runat="server" Text="取消" Icon="Cancel" CommandArgument=""
                            CommandName="" IDMode="Legacy">
                            <Listeners>
                                <Click Handler="#{hospitalSelectedDlg}.hide(null);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center>
                <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Height="420" Header="false"
                    ButtonAlign="Left">
                    <Body>
                        <ext:FitLayout ID="FitLayout1" runat="server">
                            <ext:GridPanel ID="GridPanel1" runat="server" Title="" AutoExpandColumn="HOS_HospitalName"
                                Header="false" StoreID="HospitalSearchDlgStore" Border="false" Icon="Lorry" StripeRows="true">
                                <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="HOS_HospitalName" DataIndex="HOS_HospitalName" Header="医院名称" Width="130">
                                        </ext:Column>
                                        <ext:Column ColumnID="HOS_Key_Account" DataIndex="HOS_Key_Account" Header="医院代码">
                                        </ext:Column>
                                        <ext:Column ColumnID="HOS_Address" DataIndex="HOS_Address" Header="地址" Width="220">
                                        </ext:Column>
                                        <ext:Column ColumnID="HOS_Province" DataIndex="HOS_Province" Header="省" Width="50">
                                        </ext:Column>
                                        <ext:Column ColumnID="HOS_City" DataIndex="HOS_City" Header="市" Width="50">
                                        </ext:Column>
                                        <ext:Column ColumnID="HOS_District" DataIndex="HOS_District" Header="区/县" Width="50">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <Plugins>
                                    <ext:GridFilters runat="server" ID="GridFilters1" Local="true">
                                        <Filters>
                                            <ext:StringFilter DataIndex="HOS_HospitalName" />
                                            <ext:StringFilter DataIndex="HOS_Key_Account" />
                                            <ext:StringFilter DataIndex="HOS_Address" />
                                            <ext:StringFilter DataIndex="HOS_Province" />
                                            <ext:StringFilter DataIndex="HOS_City" />
                                            <ext:StringFilter DataIndex="HOS_District" />
                                        </Filters>
                                    </ext:GridFilters>
                                </Plugins>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="RowSelectionModel1" runat="server">
                                        <Listeners>
                                            <RowSelect Handler="#{btnOk}.enable();" />
                                        </Listeners>
                                    </ext:CheckboxSelectionModel>
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="HospitalSearchDlgStore" />
                                </BottomBar>
                                <LoadMask ShowMask="true" Msg="加载中...." />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </Center>
        </ext:BorderLayout>


    </Body>

</ext:Window>
<ext:Hidden ID="hiddenSelectedProductLine" runat="server" />
