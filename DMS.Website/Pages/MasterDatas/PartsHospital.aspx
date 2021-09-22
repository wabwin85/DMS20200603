<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PartsHospital.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.PartsHospital" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/HospitalSearchDialog.ascx" TagName="HospitalSearchDialog"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" >
    </ext:ScriptManager>

    <script type="text/javascript">

        var MsgList = {
			Store1:{
				LoadExceptionTitle:"<%=GetLocalResourceObject("Store1.LoadException.Alert.Title").ToString()%>",
				CommitFailedTitle:"<%=GetLocalResourceObject("Store1.CommitFailed.Alert.Title").ToString()%>",
				CommitFailedMsg:"<%=GetLocalResourceObject("Store1.CommitFailed.Alert.Body").ToString()%>",
				SaveExceptionTitle:"<%=GetLocalResourceObject("Store1.SaveException.Alert.Title").ToString()%>",
				CommitDoneTitle:"<%=GetLocalResourceObject("Store1.CommitDone.Alert.Title").ToString()%>",
				CommitDoneMsg:"<%=GetLocalResourceObject("Store1.CommitDone.Alert.Body").ToString()%>"
			},
			btnDelete:{
				confirm:"<%=GetLocalResourceObject("GridPanel1.btnDelete.Confirm").ToString()%>"
			}
        }

        var showHospistalSearchDlg = function() {
        
            var selvalue = Ext.getCmp("cbCatories").getValue();

            if (selvalue == "")
                Ext.Msg.alert('<%=GetLocalResourceObject("showHospistalSearchDlg.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("showHospistalSearchDlg.Alert.Body").ToString()%>');
            else {
                openHospitalSearchDlg();

                var btnsave = Ext.getCmp("btnSave");
                if (btnsave != null && btnsave.disabled)
                    btnsave.enable();
            }
        }
    </script>

    <ext:Store ID="Store1" runat="server" UseIdConfirmation="false" OnBeforeStoreChanged="Store1_BeforeStoreChanged"
        OnRefreshData="Store1_RefershData" AutoLoad="false">
        <Reader>
            <ext:JsonReader ReaderID="HosId">
                <Fields>
                    <ext:RecordField Name="HosId" />
                    <ext:RecordField Name="HosHospitalShortName" />
                    <ext:RecordField Name="HosHospitalName" />
                    <ext:RecordField Name="HosGrade" />
                    <ext:RecordField Name="HosKeyAccount" />
                    <ext:RecordField Name="HosProvince" />
                    <ext:RecordField Name="HosCity" />
                    <ext:RecordField Name="HosDistrict" />
                    <ext:RecordField Name="HosPhone" />
                    <ext:RecordField Name="HosPostalCode" />
                    <ext:RecordField Name="HosAddress" />
                    <ext:RecordField Name="HosPublicEmail" />
                    <ext:RecordField Name="HosWebsite" />
                    <ext:RecordField Name="HosChiefEquipment" />
                    <ext:RecordField Name="HosChiefEquipmentContact" />
                    <ext:RecordField Name="HosDirector" />
                    <ext:RecordField Name="HosDirectorContact" />
                    <ext:RecordField Name="HosDirectorContact" />
                    <ext:RecordField Name="HosLastModifiedDate" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.Store1.LoadExceptionTitle, e.message || e )" />
            <CommitFailed Handler="Ext.Msg.alert(MsgList.Store1.CommitFailedTitle, MsgList.Store1.CommitFailedMsg + msg)" />
            <SaveException Handler="Ext.Msg.alert(MsgList.Store1.SaveExceptionTitle, e.message || e)" />
            <CommitDone Handler="Ext.Msg.alert(MsgList.Store1.CommitDoneTitle, MsgList.Store1.CommitDoneMsg);" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="AttributeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Id" Direction="ASC" />
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout runat="server">
                <North Collapsible="True" Split="True">
                    <ext:Panel runat="server" ID="ctl701" Header="true" Title="<%$ Resources: ctl701.Title %>" Frame="true" AutoHeight="true"
                        Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".5">
                                    <ext:Panel ID="Panel1" runat="server" Border="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbCatories" runat="server" EmptyText="<%$ Resources: ctl701.FormLayout1.cbCatories.EmptyText %>" Width="200" Editable="false"
                                                        FieldLabel="<%$ Resources: ctl701.FormLayout1.cbCatories.FieldLabel %>" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                        DisplayField="AttributeName" ListWidth="300" Resizable="true">
                                                        <Listeners>
                                                            <Select Handler="#{GridPanel1}.clear(); " />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".5">
                                    <ext:Panel ID="Panel3" runat="server" Border="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server">
                                                <ext:Anchor>
                                                        <ext:TextField ID="txtSearchHospitalName" runat="server" FieldLabel="<%$ Resources: ctl701.FormLayout3.txtSearchHospitalName.FieldLabel %>" Width="200" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="Button1" Text="<%$ Resources: ctl701.Button1.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                    <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center>
                    <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" AutoExpandColumn="HosHospitalName"
                                    StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
                                    <Buttons>
                                        <ext:Button ID="btnAdd" runat="server" Text="<%$ Resources: GridPanel1.btnAdd.Text %>" Icon="Add" CommandArgument="" CommandName=""
                                            IDMode="Legacy">
                                            <Listeners>
                                                <Click fn="showHospistalSearchDlg" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnSave" runat="server" Text="<%$ Resources: GridPanel1.btnSave.Text %>" Icon="Disk" CommandArgument=""
                                            CommandName="" IDMode="Legacy" Enabled="false">
                                            <Listeners>
                                                <Click Handler="#{GridPanel1}.save();#{btnSave}.disable();" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: GridPanel1.btnDelete.Text %>" Icon="Delete" CommandArgument=""
                                            CommandName="" IDMode="Legacy" Enabled="false">
                                            <Listeners>
                                                <Click Handler="var result = confirm(MsgList.btnDelete.confirm); if ( (result) && #{GridPanel1}.hasSelection())  { #{GridPanel1}.deleteSelected(); #{btnSave}.enable();}" />
                                            </Listeners>
                                        </ext:Button>
                                    </Buttons>
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="<%$ Resources: GridPanel1.ColumnModel1.HosHospitalName.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosKeyAccount" Header="<%$ Resources: GridPanel1.ColumnModel1.HosKeyAccount.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosGrade" Header="<%$ Resources: GridPanel1.ColumnModel1.HosGrade.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosProvince" Header="<%$ Resources: GridPanel1.ColumnModel1.HosProvince.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosCity" Header="<%$ Resources: GridPanel1.ColumnModel1.HosCity.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosDistrict" Header="<%$ Resources: GridPanel1.ColumnModel1.HosDistrict.Header %>">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosAddress" Header="<%$ Resources: GridPanel1.ColumnModel1.HosAddress.Header %>">
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" runat="server">
                                            <Listeners>
                                                <RowSelect Handler="#{btnDelete}.enable();" />
                                            </Listeners>
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <uc1:HospitalSearchDialog ID="HospitalSearchDialog1" ExistsStatus="IsNotExists" runat="server" />
    </form>
</body>
</html>
