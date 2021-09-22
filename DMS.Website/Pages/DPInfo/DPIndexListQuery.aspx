<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DPIndexListQuery.aspx.cs"
    Inherits="DMS.Website.Pages.DPInfo.DPIndexListQuery" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/DealerMasterEditor.ascx" TagName="DealerMasterEditor"
    TagPrefix="uc1" %>
<%@ Register Src="../../Controls/DealerLicenseEditor.ascx" TagName="DealerLicenseEditor"
    TagPrefix="uc2" %>
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
                var b = getBrowser();
                if (b == 'ie' || b == 'unknow') {
                    window.open('/Pages/DPInfo/DPIndexMaintain/DPIndexQueryMast.aspx?DealerId=' + record.data["Id"], record.data["ChineseName"]);
                } else {
                    top.createTab('dp' + record.data["Id"], '经销商综合信息查询 - ' + record.data["ChineseName"], '/Pages/DPInfo/DPIndexMaintain/DPIndexQueryMast.aspx?DealerId=' + record.data["Id"]);
                }
            }
        }

        var openExport = function () {
            var b = getBrowser();
            if (b == 'ie' || b == 'unknow') {
                window.open('/BSCDp/Pages/DPInfo/DPIndexExport.aspx');
            } else {
                top.createTab('DP_M_EXPORT', '经销商综合信息导出', '/BSCDp/Pages/DPInfo/DPIndexExport.aspx');
            }
        }

        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

        //返回浏览器的类型: "ie", "firefox", "chrome", "opera", "safari", "unknow"
        function getBrowser(getVersion) {
            //注意关键字大小写
            var ua_str = navigator.userAgent.toLowerCase(), ie_Tridents, trident, match_str, ie_aer_rv, browser_chi_Type;

            //判断IE 浏览器, 
            if ("ActiveXObject" in self) {
                // ie_aer_rv:  指示IE 的版本.
                // It can be affected by the current document mode of IE.
                ie_aer_rv = (match_str = ua_str.match(/msie ([\d.]+)/)) ? match_str[1] :
                      (match_str = ua_str.match(/rv:([\d.]+)/)) ? match_str[1] : 0;

                // ie: Indicate the really version of current IE browser.
                ie_Tridents = { "trident/7.0": 11, "trident/6.0": 10, "trident/5.0": 9, "trident/4.0": 8 };
                //匹配 ie8, ie11, edge
                trident = (match_str = ua_str.match(/(trident\/[\d.]+|edge\/[\d.]+)/)) ? match_str[1] : undefined;
                browser_chi_Type = (ie_Tridents[trident] || ie_aer_rv) > 0 ? "ie" : undefined;
            } else {
                //判断 windows edge 浏览器
                // match_str[1]: 返回浏览器及版本号,如: "edge/13.10586"
                // match_str[1]: 返回版本号,如: "edge" 
                //若要返回 "edge" 请把下行的 "ie" 换成 "edge"。 注意引号及冒号是英文状态下输入的
                browser_chi_Type = (match_str = ua_str.match(/edge\/([\d.]+)/)) ? "ie" :
                //判断firefox 浏览器
                    (match_str = ua_str.match(/firefox\/([\d.]+)/)) ? "firefox" :
                //判断chrome 浏览器
                    (match_str = ua_str.match(/chrome\/([\d.]+)/)) ? "chrome" :
                //判断opera 浏览器
                    (match_str = ua_str.match(/opera.([\d.]+)/)) ? "opera" :
                //判断safari 浏览器
                    (match_str = ua_str.match(/version\/([\d.]+).*safari/)) ? "safari" : undefined;
            }

            //返回浏览器类型和版本号
            var verNum, verStr;
            verNum = trident && ie_Tridents[trident] ? ie_Tridents[trident] : match_str[1];
            verStr = (getVersion != undefined) ? browser_chi_Type + "/" + verNum : browser_chi_Type;
            return verStr;
        }
    </script>

    <form id="form1" runat="server">
        <div>
            <ext:ScriptManager ID="ScriptManager1" runat="server">
            </ext:ScriptManager>
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
            <ext:Store ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="Store1_RefershData"
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
            <ext:Hidden ID="hidRtnVal" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidCorpType" runat="server">
            </ext:Hidden>
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="True">
                            <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>"
                                Frame="true" AutoHeight="true" Icon="Find">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtFilterDealerName" runat="server" FieldLabel="经销商"
                                                                Width="150" />
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
                                                            <ext:TextField ID="txtFilterSAPCode" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout2.txtFilterSAPCode.FieldLabel %>"
                                                                Width="150" />
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
                                                            <ext:ComboBox ID="cboFilterDealterType" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout3.cboFilterDealterType.FieldLabel %>"
                                                                StoreID="DealerTypeStore" Editable="true" TypeAhead="true" Mode="Local" DisplayField="Value"
                                                                ValueField="Key" ListWidth="300" Resizable="true" ForceSelection="true" TriggerAction="All"
                                                                EmptyText="<%$ Resources: plSearch.FormLayout3.cboFilterDealterType.EmptyText %>"
                                                                ItemSelector="div.list-item" SelectOnFocus="true" Width="130">
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
                                    <ext:Button ID="btnSearch" Text="<%$ Resources: plSearch.btnSearch.Text %>" runat="server"
                                        Icon="ArrowRefresh" IDMode="Legacy">
                                        <Listeners>
                                            <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                            <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnExport" Text="导出" runat="server"
                                        Icon="Disk" IDMode="Legacy">
                                        <Listeners>
                                            <Click Handler="openExport();" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </North>
                        <Center>
                            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                        <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                            StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel1.ColumnModel1.ChineseName.Header %>"
                                                        Width="250">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="<%$ Resources: GridPanel1.ColumnModel1.SapCode.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DealerType" DataIndex="DealerType" Header="<%$ Resources: GridPanel1.ColumnModel1.DealerType.Header %>">
                                                        <Renderer Handler="return getNameFromStoreById(DealerTypeStore,{Key:'Key',Value:'Value'},value);" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ActiveFlag" DataIndex="ActiveFlag" Header="当前合作状态"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="LastUpdateDate" Hidden="false" DataIndex="LastUpdateDate" Width="120"
                                                        Header="<%$ Resources: GridPanel1.ColumnModel1.LastUpdateDate.Header %>">
                                                        <%--     <PrepareCommand Handler="" Args="grid,command,record,row,col,value" FormatHandler="False">
                                                    </PrepareCommand>--%>
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="LastUpdateUserName" Hidden="false" DataIndex="LastUpdateUserName"
                                                        Header="<%$ Resources: GridPanel1.ColumnModel1.LastUpdateUserName.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Details" Header="<%$ Resources: GridPanel1.ColumnModel1.Details.Header %>"
                                                        Width="50" Align="Center" Fixed="true" MenuDisabled="true" Resizable="false">
                                                        <Renderer Fn="dealerDetailsRender" />
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                                    DisplayInfo="true" DisplayMsg="<%$ Resources: GridPanel1.PagingToolBar1.DisplayMsg %>"
                                                    EmptyMsg="<%$ Resources: GridPanel1.PagingToolBar1.EmptyMsg %>" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                            <Listeners>
                                                <CellClick Fn="cellClick" />
                                            </Listeners>
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
