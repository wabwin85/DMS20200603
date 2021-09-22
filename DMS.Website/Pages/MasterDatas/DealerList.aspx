<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerList.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.DealerList" ValidateRequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/DealerMasterEditor.ascx" TagName="DealerMasterEditor" TagPrefix="uc1" %>
<%@ Register Src="../../Controls/DealerLicenseEditor.ascx" TagName="DealerLicenseEditor" TagPrefix="uc2" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
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
    </style>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
        //刷新父窗口查询结果
        function RefreshMainPage() {
            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
        }
        var MsgList = {
            Store1: {
                LoadExceptionTitle: "<%=GetLocalResourceObject("Store1.LoadException.Alert.Title").ToString()%>",
                CommitFailedTitle: "<%=GetLocalResourceObject("Store1.CommitFailed.Alert.Title").ToString()%>",
                CommitFailedMsg: "<%=GetLocalResourceObject("Store1.CommitFailed.Alert.Body").ToString()%>",
                SaveExceptionTitle: "<%=GetLocalResourceObject("Store1.SaveException.Alert.Title").ToString()%>",
                CommitDoneTitle: "<%=GetLocalResourceObject("Store1.CommitDone.Alert.Title").ToString()%>",
                CommitDoneMsg: "<%=GetLocalResourceObject("Store1.CommitDone.Alert.Body").ToString()%>"
            },
            btnDelete: {
                confirm: "<%=GetLocalResourceObject("plSearch.btnDelete.Confirm").ToString()%>"
            }
        }

        var dealerDetailsRender = function (para) {
            return '<img class="imgEdit" ext:qtip="<%=GetLocalResourceObject("dealerDetailsRender.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/vcard_edit.png" />';
        }


        function SelectValue(e) {
            var filterField = 'ChineseShortName';  //需进行模糊查询的字段
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var value = e.query;
                if (value != null && value != '') {
                    combo.store.filterBy(function (record, id) {
                        var text = record.get(filterField);
                        if (text != null && text != "") {
                            // 用自己的过滤规则,如写正则式
                            return (text.indexOf(value) != -1);
                        }
                        else {
                            return false;
                        }
                    });
                } else {
                    combo.store.clearFilter();
                }
                combo.onLoad(); //不加第一次会显示不出来  
                combo.expand();
                return false;
            }
        }
        var cellClick = function (grid, rowIndex, columnIndex, e) {  //gradpanel events
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record

            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

            if (t.className == 'imgEdit' && columnId == 'Details') {
                openDealerDetails(record, t, test); //this functon allocate at Editor control

            }
            else if (t.className == 'imgDetails' && columnId == 'CFDADetails') {
                var dealerrId = record.data['Id'];
                Coolite.AjaxMethods.Show(dealerrId,
                                {
                                    success: function () {
                                    },
                                    failure: function (err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                                );

            }   //the ajax event allowed
            else if (t.className == 'imgEdit' && columnId == 'ChangeLicense') {

                //window.parent.loadExample('/Pages/MasterDatas/DealerLicenseChange.aspx?ct=' + record.data["Id"] + "&dr=" + record.data["Id"], 'subMenu' + record.data["Id"], '证照信息修改');
                window.open('DealerLicenseChange.aspx?ct=' + record.data["Id"] + "&dr=" + record.data["Id"], '_blank');
            }
        }

        var createDealerMaster = function () {    //create new dealer
            var flag = "0";
            var record = Ext.getCmp("GridPanel1").insertRecord(0, {});  //add a new empty line on gridpanel

            //record.set('LastModifiedDate', Ext.util.Format.date(Date(), "Y-m-d\\TH:i:s"));
            record.set('LastUpdateDate', Ext.util.Format.date(Date(), "Y-m-d\\TH:i:s"));

            Ext.getCmp("GridPanel1").getView().focusRow(0);
            Coolite.AjaxMethods.CreateDealerMasters();  //call a function at background which call the function in editor control and set a guid for the record id.

            createDealerMasterDetails(record, "GridPanel1", null, flag); //call initial function for the record.
        }


        var refreshDealerCache = function () {
            var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
            Coolite.AjaxMethods.RefreshDealerCache(
            {
                success: function () {
                    if (rtnVal.getValue() == "Success") {
                        Ext.Msg.alert('Message', '<%=GetLocalResourceObject("RefreshDealerCache.alert.Success").ToString()%>');
                    }
                },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                    }
           });
        }

        var CFDADetails = function () {
            return '<img class="imgDetails" ext:qtip="点击进入CFDA证照信息明细查看界面" style="cursor:pointer;" src="../../resources/images/icons/vcard_edit.png" />';
        }
        var changeLicenseRender = function () {
            return '<img class="imgEdit" ext:qtip="点击进入CFDA证照信息修改界面" style="cursor:pointer;" src="../../resources/images/icons/vcard_edit.png" />';
        }

        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

    <form id="form1" runat="server">
        <div>
            <ext:ScriptManager ID="ScriptManager1" runat="server">
            </ext:ScriptManager>
            <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_DealerList" AutoLoad="true">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="Id">
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="ChineseName" />
                            <ext:RecordField Name="ChineseShortName" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
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
            <ext:Store ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="Store1_RefershData" AutoLoad="false">
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
                            <ext:RecordField Name="LicenseStatus" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <SortInfo Field="ChineseName" Direction="DESC" />
                <Listeners>
                    <LoadException Handler="Ext.Msg.alert(MsgList.Store1.LoadExceptionTitle, e.message || e )" />
                    <CommitFailed Handler="Ext.Msg.alert(MsgList.Store1.CommitFailedTitle, MsgList.Store1.CommitFailedMsg + msg)" />
                    <SaveException Handler="Ext.Msg.alert(MsgList.Store1.SaveExceptionTitle, e.message || e)" />
                    <CommitDone Handler="Ext.Msg.alert(MsgList.Store1.CommitDoneTitle, MsgList.Store1.CommitDoneMsg);" />
                </Listeners>
            </ext:Store>
            <!-- <ext:Store ID="Store2" runat="server" UseIdConfirmation="true" OnRefreshData="Store_HospitalGrade">
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
        -->
            <ext:Hidden ID="hidRtnVal" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidCorpType" runat="server">
            </ext:Hidden>
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="True">
                            <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>" Frame="true" AutoHeight="true" Icon="Find">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: plSearch.FormLayout1.cbDealer.EmptyText %>" Width="220" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName" FieldLabel="<%$ Resources: plSearch.FormLayout1.cbDealer.FieldLabel %>"
                                                                ListWidth="300" Resizable="true" Mode="Local">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.FormLayout1.cbDealer.FieldTrigger.Qtip %>" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                    <BeforeQuery Fn="SelectValue" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtFilterAddress" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout1.txtFilterAddress.FieldLabel %>" Width="220" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel2" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtFilterSAPCode" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout2.txtFilterSAPCode.FieldLabel %>" Width="150" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel3" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cboFilterDealterType" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout3.cboFilterDealterType.FieldLabel %>" StoreID="DealerTypeStore" Editable="true" TypeAhead="true" Mode="Local" DisplayField="Value" ValueField="Key" ListWidth="300"
                                                                Resizable="true" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: plSearch.FormLayout3.cboFilterDealterType.EmptyText %>" ItemSelector="div.list-item" SelectOnFocus="true" Width="130">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.FormLayout3.cboFilterDealterType.FieldTrigger.Qtip %>" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                </Listeners>
                                                                <Template ID="Template1" runat="server">
                                                            <tpl for=".">
                                                                <div class="list-item">
                                                                     {Value}
                                                                </div>
                                                            </tpl>
                                                                </Template>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                                <Buttons>
                                    <ext:Button ID="Button1" Text="导出经销商授权产品信息" runat="server" Icon="PageExcel" IDMode="Legacy" OnClick="ExportLicenseCfnToExcel" AutoPostBack="true">
                                    </ext:Button>
                                    <ext:Button ID="btnExportLicense" Text="导出CFDA证照信息" runat="server" Icon="PageExcel" IDMode="Legacy" OnClick="ExportLicenseToExcel" AutoPostBack="true">
                                    </ext:Button>
                                    <ext:Button ID="btnRefreshDealerCache" Text="<%$ Resources: btnRefreshDealerCache.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                        <Listeners>
                                            <Click Handler="refreshDealerCache();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnSearch" Text="<%$ Resources: plSearch.btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                        <Listeners>
                                            <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                            <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: plSearch.btnInsert.Text %>" Icon="Add" CommandArgument="" CommandName="" IDMode="Legacy" OnClientClick="">
                                        <Listeners>
                                            <Click Handler="createDealerMaster();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnSave" runat="server" Text="<%$ Resources: plSearch.btnSave.Text %>" Icon="Disk" CommandArgument="" CommandName="" IDMode="Legacy" OnClientClick="">
                                        <Listeners>
                                            <Click Handler="#{GridPanel1}.save();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: plSearch.btnDelete.Text %>" Icon="Delete" CommandArgument="" CommandName="" IDMode="Legacy" OnClientClick="">
                                        <Listeners>
                                            <Click Handler="var result = confirm( MsgList.btnDelete.confirm); if ( (result) && #{GridPanel1}.hasSelection()) #{GridPanel1}.deleteSelected();" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </North>
                        <Center>
                            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                        <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel1.ColumnModel1.ChineseName.Header %>" Width="200">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="<%$ Resources: GridPanel1.ColumnModel1.SapCode.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DealerType" DataIndex="DealerType" Header="<%$ Resources: GridPanel1.ColumnModel1.DealerType.Header %>">
                                                        <Renderer Handler="return getNameFromStoreById(DealerTypeStore,{Key:'Key',Value:'Value'},value);" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Address" DataIndex="Address" Header="<%$ Resources: GridPanel1.ColumnModel1.Address.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Province" Hidden="true" DataIndex="Province" Header="<%$ Resources: GridPanel1.ColumnModel1.Province.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="City" Hidden="true" DataIndex="City" Header="<%$ Resources: GridPanel1.ColumnModel1.City.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="District" Hidden="true" DataIndex="District" Header="<%$ Resources: GridPanel1.ColumnModel1.District.Header %>">
                                                    </ext:Column>
                                                    <%--<ext:Column ColumnID="PostalCode" DataIndex="PostalCode" Header="<%$ Resources: GridPanel1.ColumnModel1.PostalCode.Header %>">
                                                </ext:Column>--%>
                                                    <%--<ext:Column ColumnID="Phone" DataIndex="Phone" Header="<%$ Resources: GridPanel1.ColumnModel1.Phone.Header %>">
                                                </ext:Column>--%>
                                                    <%-- <ext:Column ColumnID="Fax" DataIndex="Fax" Header="<%$ Resources: GridPanel1.ColumnModel1.Fax.Header %>">
                                                </ext:Column>--%>
                                                    <ext:CheckColumn ColumnID="ActiveFlag" DataIndex="ActiveFlag" Header="<%$ Resources: GridPanel1.ColumnModel1.ActiveFlag.Header %>" Width="50">
                                                    </ext:CheckColumn>
                                                    <%--<ext:Column ColumnID="RegisteredCapital" Hidden="true" DataIndex="RegisteredCapital" Header="<%$ Resources: GridPanel1.ColumnModel1.RegisteredCapital.Header %>" Fixed="true">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('￥0,000.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="EstablishDate" Hidden="true" DataIndex="EstablishDate" Header="<%$ Resources: GridPanel1.ColumnModel1.EstablishDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="EnglishName" Hidden="true" DataIndex="EnglishName" Header="<%$ Resources: GridPanel1.ColumnModel1.EnglishName.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="GeneralManager" Hidden="true" DataIndex="GeneralManager" Header="<%$ Resources: GridPanel1.ColumnModel1.GeneralManager.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="SystemStartDate" Hidden="true" DataIndex="SystemStartDate" Header="<%$ Resources: GridPanel1.ColumnModel1.SystemStartDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="LegalRep" Hidden="true" DataIndex="LegalRep" Header="<%$ Resources: GridPanel1.ColumnModel1.LegalRep.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="BankAccount" Hidden="true" DataIndex="BankAccount" Header="<%$ Resources: GridPanel1.ColumnModel1.BankAccount.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Bank" Hidden="true" DataIndex="Bank" Header="<%$ Resources: GridPanel1.ColumnModel1.Bank.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="TaxNo" Hidden="true" DataIndex="TaxNo" Header="<%$ Resources: GridPanel1.ColumnModel1.TaxNo.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Certification" Hidden="true" DataIndex="Certification" Header="<%$ Resources: GridPanel1.ColumnModel1.Certification.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="CompanyGrade" Hidden="true" DataIndex="CompanyGrade" Header="<%$ Resources: GridPanel1.ColumnModel1.CompanyGrade.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="CompanyType" Hidden="true" DataIndex="CompanyType" Header="<%$ Resources: GridPanel1.ColumnModel1.CompanyType.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="FirstContractDate" Hidden="true" DataIndex="FirstContractDate" Header="<%$ Resources: GridPanel1.ColumnModel1.FirstContractDate.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="HostCompanyFlag" Hidden="true" DataIndex="HostCompanyFlag" Header="<%$ Resources: GridPanel1.ColumnModel1.HostCompanyFlag.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="DeletedFlag" Hidden="true" DataIndex="DeletedFlag" Header="<%$ Resources: GridPanel1.ColumnModel1.DeletedFlag.Header %>">
                                                </ext:Column>--%>

                                                    <ext:Column ColumnID="Details" Header="<%$ Resources: GridPanel1.ColumnModel1.Details.Header %>" Width="50" Align="Center" Fixed="true" MenuDisabled="true" Resizable="false">
                                                        <Renderer Fn="dealerDetailsRender" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CFDADetails" Header="CFDA信息查看" Width="150" Align="Center">
                                                        <Renderer Fn="CFDADetails" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ChangeLicense" Header="CFDA信息变更" Width="150" Align="Center">
                                                        <Renderer Fn="changeLicenseRender" />
                                                    </ext:Column>
                                                    <%-- <ext:Column ColumnID="Details2" Header="<%$ Resources: GridPanel1.ColumnModel1.DP.Header %>"
                                                    Width="50" Align="Center" Fixed="true" MenuDisabled="true" Resizable="false">
                                                    <Renderer Fn="dealerDetailsRender" />
                                                </ext:Column>--%>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1" DisplayInfo="true" DisplayMsg="<%$ Resources: GridPanel1.PagingToolBar1.DisplayMsg %>" EmptyMsg="<%$ Resources: GridPanel1.PagingToolBar1.EmptyMsg %>" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                            <Listeners>
                                                <CellClick Fn="cellClick" />
                                                <BeforeEdit Handler="if(e.field == 'RegisteredCapital') {}" />
                                                <ValidateEdit Handler="if(e.field == 'RegisteredCapital'){e.value = e.value.replace(/[￥,]/g, '');}" />
                                            </Listeners>
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:ViewPort>
            <uc1:DealerMasterEditor ID="DealerMasterEditor1" runat="server" />
            <uc2:DealerLicenseEditor ID="DealerLicenseEditor1" runat="server" />
        </div>
    </form>
</body>
</html>
