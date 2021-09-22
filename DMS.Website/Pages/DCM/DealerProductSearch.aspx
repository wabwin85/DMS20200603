<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerProductSearch.aspx.cs" Inherits="DMS.Website.Pages.DCM.DealerProductSearch" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/CFNEditor.ascx" TagName="CFNEditor" TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        a {
            color: Red;
        }

    </style>
    <script type="text/javascript">
        var MsgList = {
            btnSearch: {
                AlertTitle: "<%=GetLocalResourceObject("plSearch.btnSearch.Listeners.Alert.Title").ToString()%>",
                AlertMsg: "<%=GetLocalResourceObject("plSearch.btnSearch.Listeners.Alert.Body").ToString()%>"
            }
        }

        var CFNDetailsRender = function (Id) {
            if (Id != '-1') {
                return '<img class="imgEdit" ext:qtip="Click to view/edit additional details" style="cursor:pointer;" src="../../resources/images/icons/vcard_edit.png" />';
            }
        }

        var cellClick = function (grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";
            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

            if (t.className == 'imgEdit' && columnId == 'Details' && record.data.Property4 != '-1') {
                SearchCFNDetails(record, t, test, "ReadlyOnly");

                //the ajax event allowed
                //return true;

            }
        }


        var createCFN = function () {
            var flag = "0";
            var record = Ext.getCmp("GridPanel1").insertRecord(0, {});

            record.set('LastUpdateDate', Ext.util.Format.date(Date(), "Y-m-d\\TH:i:s"));

            Ext.getCmp("GridPanel1").getView().focusRow(0);
            Coolite.AjaxMethods.CreateCFNs();

            createCFNDetails(record, "GridPanel1", null, flag);
            //Ext.getCmp("GridPanel1").startEditing(0, 0);

        }

        function prepareCommand(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            var attachname = record.data.AttachName;

            if (attachname == null || attachname == '' || attachname == '.pdf') {
                firstButton.setVisible(false);
            } else {
                firstButton.setVisible(true);
            }
        }

        function prepareCommandShow(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            var property = record.data.Property4;

            if (property == '-1') {
                firstButton.setVisible(false);
            } else {
                firstButton.setVisible(true);
            }
        }

        if (typeof (Sys) != 'undefined') {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_initializeRequest(downloadfile);

        }

        //触发函数
        function downloadfile(url) {
            var iframe = document.createElement("iframe");
            iframe.src = url;
            iframe.style.display = "none";
            document.body.appendChild(iframe);
        }
        //判断资质类型 lijie add
        var rendType = function () {
            alert('a');
            //            if (record.get(meta.AttachName) != null){
            //            
            //                  alert(record.get(meta.AttachName));
            //                }
            //            return value;
        }

        function SetPageActivate() {
            var gpPanel = Ext.getCmp('<%=this.GridPanel3.ClientID%>');
            gpPanel.store.reload();
        }
        function SetPageRegNewActivate() {
            var gpPanel = Ext.getCmp('<%=this.GridPanel4.ClientID%>');
            gpPanel.store.reload();
        }
        function SetPageRegLotNewActivate() {
            var gpPanel = Ext.getCmp('<%=this.GridPanel5.ClientID%>');
            gpPanel.store.reload();
        }
    </script>

</head>
<body>
    <iframe id="ifile" style="display: none"></iframe>
    <form id="form1" runat="server">
        <div>
            <ext:ScriptManager ID="ScriptManager1" runat="server">
            </ext:ScriptManager>
            <ext:Store ID="Store1" runat="server" OnRefreshData="Store1_RefershData" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="EnglishName" />
                            <ext:RecordField Name="ChineseName" />
                            <ext:RecordField Name="Implant" />
                            <ext:RecordField Name="Tool" />
                            <ext:RecordField Name="Share" />
                            <ext:RecordField Name="CustomerFaceNbr" />
                            <ext:RecordField Name="ProductCatagoryPctId" />
                            <ext:RecordField Name="Property1" />
                            <ext:RecordField Name="Property2" />
                            <ext:RecordField Name="Property3" />
                            <ext:RecordField Name="Property4" />
                            <ext:RecordField Name="Property5" />
                            <ext:RecordField Name="Property6" />
                            <ext:RecordField Name="Property7" />
                            <ext:RecordField Name="Property8" />
                            <ext:RecordField Name="LastUpdateDate" />
                            <ext:RecordField Name="DeletedFlag" />
                            <ext:RecordField Name="ProductLineBumId" />
                            <ext:RecordField Name="PCTName" />
                            <ext:RecordField Name="PCTEnglishName" />
                            <ext:RecordField Name="ProductLineName" />
                            <ext:RecordField Name="Description" />
                            <ext:RecordField Name="AttachName" />
                            <ext:RecordField Name="AttachURL" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <SortInfo Field="ProductLineBumId" Direction="DESC" />
                <SortInfo Field="CustomerFaceNbr" Direction="DESC" />
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
            <ext:Store ID="StoreRegistration" runat="server" OnRefreshData="StoreRegistration_RefreshData" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="row_number">
                        <Fields>
                            <ext:RecordField Name="REG_NO" />
                            <ext:RecordField Name="PRODUCT_NAME" />
                            <ext:RecordField Name="VALID_DATE_FROM" />
                            <ext:RecordField Name="VALID_DATE_TO" />
                            <ext:RecordField Name="MANU_NAME" />
                            <ext:RecordField Name="AttachName" />
                            <ext:RecordField Name="AttachURL" />
                            <ext:RecordField Name="Type" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="StoreRegistrationBylot" runat="server" OnRefreshData="StoreRegistrationBylot_RefreshData" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="AT_Url" />
                            <ext:RecordField Name="AT_Name" />
                            <ext:RecordField Name="AT_Type" />
                            <ext:RecordField Name="AT_UPN" />
                            <ext:RecordField Name="AT_LotNumber" />
                            <ext:RecordField Name="AT_UploadDate" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>


            <ext:Store ID="StoreRegistrationNew" runat="server" OnRefreshData="StoreRegistrationNew_RefreshData" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="UPN" />
                            <ext:RecordField Name="Lot" />
                            <ext:RecordField Name="DocNum" />
                            <ext:RecordField Name="ValidDateFrom" />
                            <ext:RecordField Name="ValidDateTo" />
                            <ext:RecordField Name="SourceFileName" />
                            <ext:RecordField Name="LinkUrl" />
                            <ext:RecordField Name="FileExt" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="StoreRegistrationBylotNew" runat="server" OnRefreshData="StoreRegistrationBylotNew_RefreshData" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="UPN" />
                            <ext:RecordField Name="Lot" />
                            <ext:RecordField Name="DocNum" />
                            <ext:RecordField Name="SourceFileName" />
                            <ext:RecordField Name="LinkUrl" />
                            <ext:RecordField Name="FileExt" />
                            <ext:RecordField Name="Category" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="True">
                            <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>" Frame="true" AutoHeight="true" Icon="Find">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".25">
                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbCatories" runat="server" EmptyText="<%$ Resources: plSearch.Panel1.cbCatories.EmptyText %>" Width="150" Editable="true" AllowBlank="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName" ListWidth="300"
                                                                Resizable="true" FieldLabel="<%$ Resources: plSearch.Panel1.cbCatories.FieldLabel %>">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.panel1.FieldTrigger.Qtip %>" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtCFN" runat="server" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" Width="150">
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:Checkbox ID="cbIsShare" runat="server" FieldLabel="<%$ Resources: plSearch.panel1.cbIsShare.FieldLabel %>" Hidden="true">
                                                            </ext:Checkbox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:Panel ID="Panel3" runat="server" Border="false" BodyBorder="true">
                                                                <Body>
                                                                    <asp:Label ID="lbRemark" runat="server" Text="<font color='#FF0000' size='2' >如您在查询信息过程中有任何疑问或问题，可以通过以下几个途径进行反馈，我们将尽快予以回复。感谢您一直以来的支持。<br/> 1 网页链接：<a href='http://bsci.udesk.cn/im_client/?web_plugin_id=37827' target='_blank'>http://bsci.udesk.cn/im_client/?web_plugin_id=37827</a> <br/>2 物联网：左下角菜单“智能客服” <br/>3 服务入微：中间菜单“渠道工具-智能客服”<br/>4 企业质量与运营公众号：右下角菜单“客户支持-智能客服”<br/><br/>注：以上4种入口进入后，可先尝试通过自主查询的方式，输入问题/关键字获取帮助，省去等待时间。如无法从常用问题中找寻到答案，可通过转人工方式留言反馈您的问题和需求，我们将尽快核实并予以回复。谢谢！</font>"></asp:Label>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>

                                    </ext:ColumnLayout>
                                </Body>
                                <Buttons>
                                    <ext:Button ID="btnSearch" Text="<%$ Resources: plSearch.btnSearch.text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                        <Listeners>
                                            <Click Handler="if(#{cbCatories}.getValue() == ''&& !#{cbIsShare}.checked ){Ext.Msg.alert(MsgList.btnSearch.AlertTitle,MsgList.btnSearch.AlertMsg);} else {#{PagingToolBar1}.changePage(1);}" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnDownload" Text="波科证照下载" runat="server" Icon="DiskDownload" IDMode="Legacy" AutoPostBack="false">
                                        <Listeners>
                                            <Click Handler="window.open('../Download.aspx?downloadname=波科三证.zip&filename=波科三证.zip','Download');" />
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
                                            <TopBar>
                                                <ext:Toolbar ID="Toolbar1" runat="server">
                                                    <Items>
                                                        <ext:ToolbarFill />
                                                        <ext:Button ID="btnHelp" runat="server" Icon="Help" Text="<%$ Resources: plSearch.btnHelp.text %>">
                                                            <Listeners>
                                                                <Click Handler="#{windowsHelp}.show()" />
                                                            </Listeners>
                                                        </ext:Button>
                                                    </Items>
                                                </ext:Toolbar>
                                            </TopBar>
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="<%$ Resources: GridPanel1.EnglishName.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel1.ChineseName.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PCTName" DataIndex="PCTName" Header="<%$ Resources: GridPanel1.PCTName.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PCTEnglishName" DataIndex="PCTEnglishName" Header="<%$ Resources: GridPanel1.PCTEnglishName.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="<%$ Resources: GridPanel1.ProductLineName.Header %>">
                                                    </ext:Column>
                                                    <ext:CheckColumn DataIndex="Implant" Header="<%$ Resources: GridPanel1.Implant.Header %>" Hidden="true">
                                                    </ext:CheckColumn>
                                                    <ext:CheckColumn DataIndex="Tool" Header="<%$ Resources: GridPanel1.Tool.Header %>" Hidden="true">
                                                    </ext:CheckColumn>
                                                    <ext:CheckColumn DataIndex="Share" Header="<%$ Resources: GridPanel1.Share.Header %>" Hidden="true">
                                                    </ext:CheckColumn>
                                                    <ext:Column ColumnID="Description" DataIndex="Description" Header="<%$ Resources: GridPanel1.Description.Header %>">
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="50" Header="<%$ Resources: GridPanel1.DownLoad.Header %>" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                <ToolTip Text="<%$ Resources: GridPanel1.DownLoad.Header %>" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                        <PrepareToolbar Fn="prepareCommandShow" />
                                                    </ext:CommandColumn>
                                                    <ext:Column ColumnID="Details" Header="<%$ Resources: GridPanel1.Details.Header %>" Width="50" Align="Center" Fixed="true" MenuDisabled="true" Resizable="false">
                                                        <Renderer Fn="CFNDetailsRender" />
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1" DisplayInfo="true" EmptyMsg="<%$ Resources: GridPanel1.PagingToolBar1.EmptyMsg %>" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                            <Listeners>
                                                <CellClick Fn="cellClick" />
                                                <Command Handler="   if (command == 'DownLoad') {
                                                    Coolite.AjaxMethods.ShowRegistration(
                                                        record.data.CustomerFaceNbr,
                                                        {
                                                            success: function() {#{GridPanel2}.reload();},
                                                            failure: function(err) {Ext.Msg.alert('Error', err);}
                                                        }
                                                    );
                                                }" />
                                            </Listeners>
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:ViewPort>
            <uc1:CFNEditor ID="CFNEditor1" runat="server" />
            <ext:Window ID="windowsHelp" runat="server" Icon="Group" Title="<%$ Resources:windows.Help.Title%>" Resizable="false" Header="false" Width="400" AutoHeight="true" AutoShow="false" ButtonAlign="Center" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
                <Body>
                    <ext:FormLayout ID="FormLayout22" runat="server">
                        <ext:Anchor>
                            <ext:Panel ID="Panel40" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout13" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".5">
                                            <ext:Panel ID="Panel41" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout23" runat="server">
                                                        <ext:Anchor>
                                                            <ext:Label ID="Label1" runat="server" HideLabel="true" LabelSeparator="" Text="如无法下载注册证，请确认一下设置并重试：">
                                                            </ext:Label>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:Label ID="lb1" runat="server" HideLabel="true" LabelSeparator="" Text="1. 建议使用IE 或者 Chrome（谷歌）浏览器打开本网站。">
                                                            </ext:Label>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:Label ID="lb2" runat="server" HideLabel="true" LabelSeparator="" Text="2. 查看IE设置，确认IE没有设定“阻止弹出窗口”。">
                                                            </ext:Label>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:Label ID="Label2" runat="server" HideLabel="true" LabelSeparator="" Text="3. 确认IE没有安装恶意拦截插件。">
                                                            </ext:Label>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:Label ID="lb3" runat="server" HideLabel="true" LabelSeparator="" Text="4. 升级IE到9.0以上版本。">
                                                            </ext:Label>
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
                <Buttons>
                    <ext:Button ID="btnWinChancel" runat="server" Text="<%$ Resources:windows.Help.btnChancel%>" Icon="Delete">
                        <Listeners>
                            <Click Handler="#{windowsHelp}.hide();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Window>
            <ext:Hidden runat="server" ID="hidCfnId">
            </ext:Hidden>
            <ext:Window ID="windowRegistration" runat="server" Icon="Group" Title="<%$ Resources:windows.Registration.Title%>" Resizable="false" Header="false" Width="900" Height="450"
                AutoShow="false" CenterOnLoad="true" Y="10" ButtonAlign="Right" Modal="true" ShowOnLoad="false">
                <Body>
                    <ext:TabPanel ID="TabPanel1" runat="server" Border="false" AutoScroll="true" ActiveTabIndex="0">
                        <Tabs>
                            <ext:Tab ID="TabSearch" runat="server" BodyStyle="padding: 0px;" AutoHeight="true" Title="注册证" AutoShow="true" AutoScroll="true">
                                <Body>
                                    <ext:Panel ID="Panel2" runat="server" Header="false" AutoHeight="true" Border="false">
                                        <Body>
                                            <ext:FitLayout ID="FitLayout2" runat="server">
                                                <ext:GridPanel ID="GridPanel2" runat="server"
                                                    StoreID="StoreRegistration" StripeRows="true" Collapsible="false" Border="false" Header="false" Height="355px" Width="900px"
                                                    Icon="Lorry">
                                                    <ColumnModel ID="ColumnModel2" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="REG_NO" DataIndex="REG_NO" Header="注册证编号" Width="170">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="AttachName" DataIndex="AttachName" Header="资质名称" Width="270">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Type" DataIndex="Type" Header="资质类型" Width="70">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="VALID_DATE_FROM" DataIndex="VALID_DATE_FROM" Header="有效期-起始" Width="80">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="VALID_DATE_TO" DataIndex="VALID_DATE_TO" Header="有效期-终止" Width="80">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="MANU_NAME" DataIndex="MANU_NAME" Header="生产企业" Width="140">
                                                            </ext:Column>
                                                            <ext:CommandColumn Header="下载" Align="Center" Width="50">
                                                                <Commands>
                                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                        <ToolTip Text="下载" />
                                                                    </ext:GridCommand>
                                                                </Commands>
                                                                <PrepareToolbar Fn="prepareCommand" />
                                                            </ext:CommandColumn>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="StoreRegistration" DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                                    </BottomBar>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" />
                                                    </SelectionModel>
                                                    <SaveMask ShowMask="true" />
                                                    <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                                    <Listeners>
                                                        <Command Handler=" if (command == 'DownLoad')
                                                                    {
                                                                        var url = '../Download.aspx?downloadname=' + escape(record.data.AttachName) + '&filename=' + escape(record.data.AttachURL) + '&downtype=cfn';
                                                                        
                                                                        Ext.Msg.confirm('Message', '注意：DMS下载的产品注册证仅供蓝威代理商经营范围资质存档或产品使用单位验收备案使用，产品注册证的解释权归蓝威所有。\r\n  请即时下载打印产品注册证，以确为最新版本注册证。有任何疑问， 请联系 Chinacustomersupport@bsci.com 。 ',
                                                                                        function(e) { if (e == 'yes') { downloadfile(url);}})
                                                                    }" />
                                                    </Listeners>
                                                </ext:GridPanel>
                                            </ext:FitLayout>
                                        </Body>
                                    </ext:Panel>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="tab2" runat="server" AutoScroll="false" AutoWidth="true" AutoHeight="true" Title="报关单" AutoShow="false">
                                <Body>
                                    <ext:Panel ID="Panel4" runat="server" Header="false" AutoWidth="true" Border="false" AutoHeight="true">
                                        <Body>
                                            <ext:FitLayout ID="FitLayout3" runat="server">
                                                <ext:GridPanel ID="GridPanel3" runat="server" StoreID="StoreRegistrationBylot" Border="false" Icon="Lorry" StripeRows="true" Height="355px" Width="890px">
                                                    <TopBar>
                                                        <ext:Toolbar ID="Toolbar3" runat="server" Height="30px">
                                                            <Items>
                                                                <ext:Label ID="lblProductSum" runat="server" Text="产品批号:" />
                                                                <ext:TextField ID="ProductLot" runat="server" Width="200" Text="产品批号" />
                                                                <ext:Label runat="server" Width="100"></ext:Label>
                                                                <ext:Button ID="Button2" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy" Pressed="true">
                                                                    <Listeners>
                                                                        <Click Handler="#{PagingToolBar3}.changePage(1);" />
                                                                    </Listeners>
                                                                </ext:Button>
                                                                <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                            </Items>
                                                        </ext:Toolbar>
                                                    </TopBar>
                                                    <ColumnModel ID="ColumnModel3" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="AT_Name" DataIndex="AT_Name" Header="报关单名称" Width="170">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="AT_Type" DataIndex="AT_Type" Header="类型" Width="120">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="AT_UPN" DataIndex="AT_UPN" Header="报关单UPN" Width="150">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="AT_LotNumber" DataIndex="AT_LotNumber" Header="产品批号" Width="130">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="AT_UploadDate" DataIndex="AT_UploadDate" Header="上传日期" Width="130">
                                                            </ext:Column>
                                                            <ext:CommandColumn Header="下载" Align="Center" Width="100">
                                                                <Commands>
                                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                        <ToolTip Text="下载" />
                                                                    </ext:GridCommand>
                                                                </Commands>
                                                            </ext:CommandColumn>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="30" StoreID="StoreRegistrationBylot" DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                                    </BottomBar>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" />
                                                    </SelectionModel>
                                                    <SaveMask ShowMask="true" />
                                                    <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                                    <Listeners>
                                                        <Command Handler=" if (command == 'DownLoad')
                                                                    {
                                                                        var url = record.data.AT_Url;
                                                                        window.open(url);
                                                                    }" />
                                                    </Listeners>
                                                </ext:GridPanel>
                                            </ext:FitLayout>
                                        </Body>
                                    </ext:Panel>
                                </Body>
                                <Listeners>
                                    <Activate Handler="SetPageActivate();" />
                                </Listeners>
                            </ext:Tab>

                            <%-- 新注册证查询--%>
                            <ext:Tab ID="TabRegNew" runat="server" AutoScroll="false" AutoWidth="true" AutoHeight="true" Title="注册证（新）" AutoShow="false">
                                <Body>
                                    <ext:Panel ID="Panel5" runat="server" Header="false" AutoHeight="true" Border="false">
                                        <Body>
                                            <ext:FitLayout ID="FitLayout4" runat="server">
                                                <ext:GridPanel ID="GridPanel4" runat="server"
                                                    StoreID="StoreRegistrationNew" StripeRows="true" Collapsible="false" Border="false" Header="false" Height="355px" Width="900px"
                                                    Icon="Lorry">
                                                    <ColumnModel ID="ColumnModel4" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="REG_NO" DataIndex="DocNum" Header="注册证编号" Width="170">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="SourceFileName" DataIndex="SourceFileName" Header="资质名称" Width="270">
                                                            </ext:Column>
                                                            <%--   <ext:Column ColumnID="Type" DataIndex="Type" Header="资质类型" Width="70">
                                                            </ext:Column>--%>
                                                            <ext:Column ColumnID="ValidDateFrom" DataIndex="ValidDateFrom" Header="有效期-起始" Width="80">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="ValidDateTo" DataIndex="ValidDateTo" Header="有效期-终止" Width="80">
                                                            </ext:Column>
                                                            <ext:CommandColumn Header="下载" Align="Center" Width="50">
                                                                <Commands>
                                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                        <ToolTip Text="下载" />
                                                                    </ext:GridCommand>
                                                                </Commands>
                                                            </ext:CommandColumn>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" />
                                                    </SelectionModel>
                                                    <SaveMask ShowMask="true" />
                                                    <LoadMask ShowMask="true" Msg="加载中…" />
                                                    <Listeners>
                                                        <Command Handler=" if (command == 'DownLoad')
                                                                    {
                                                                        Ext.Msg.confirm('Message', '注意：DMS下载的产品注册证仅供蓝威代理商经营范围资质存档或产品使用单位验收备案使用，产品注册证的解释权归蓝威所有。\r\n  请即时下载打印产品注册证，以确为最新版本注册证。有任何疑问， 请联系 Chinacustomersupport@bsci.com 。 ',
                                                                                        function(e) { if (e == 'yes') { window.open(record.data.LinkUrl);}})
                                                                    }" />
                                                    </Listeners>
                                                </ext:GridPanel>
                                            </ext:FitLayout>
                                        </Body>
                                    </ext:Panel>
                                </Body>
                                <Listeners>
                                    <Activate Handler="SetPageRegNewActivate();" />
                                </Listeners>
                            </ext:Tab>
                            <%-- 新报关单查询--%>
                            <ext:Tab ID="TabLotNew" runat="server" AutoScroll="false" AutoWidth="true" AutoHeight="true" Title="报关单（新）" AutoShow="false">
                                <Body>
                                    <ext:Panel ID="Panel6" runat="server" Header="false" AutoHeight="true" Border="false">
                                        <Body>
                                            <ext:FitLayout ID="FitLayout5" runat="server">
                                                <ext:GridPanel ID="GridPanel5" runat="server"
                                                    StoreID="StoreRegistrationBylotNew" StripeRows="true" Collapsible="false" Border="false" Header="false" Height="355px" Width="900px"
                                                    Icon="Lorry">
                                                    <TopBar>
                                                        <ext:Toolbar ID="Toolbar2" runat="server" Height="30px">
                                                            <Items>
                                                                <ext:Label ID="Label3" runat="server" Text="产品批号:" />
                                                                <ext:TextField ID="windTfLotNew" runat="server" Width="200" />
                                                                <ext:Label runat="server" Width="100" Text="    "></ext:Label>
                                                                <ext:Button ID="Button3" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy" Pressed="true">
                                                                    <Listeners>
                                                                        <Click Handler="#{GridPanel5}.store.reload();" />
                                                                    </Listeners>
                                                                </ext:Button>
                                                                <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                            </Items>
                                                        </ext:Toolbar>
                                                    </TopBar>
                                                    <ColumnModel ID="ColumnModel5" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="SourceFileName" DataIndex="SourceFileName" Header="报关单名称" Width="170">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Category" DataIndex="Category" Header="类型" Width="80">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="UPN" DataIndex="UPN" Header="报关单UPN" Width="150">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Lot" DataIndex="Lot" Header="产品批号" Width="150">
                                                            </ext:Column>
                                                            <%--   <ext:Column ColumnID="ValidDateTo" DataIndex="ValidDateTo" Header="上传日期" Width="80">
                                                            </ext:Column>--%>
                                                            <ext:CommandColumn Header="下载" Align="Center" Width="50">
                                                                <Commands>
                                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                        <ToolTip Text="下载" />
                                                                    </ext:GridCommand>
                                                                </Commands>
                                                            </ext:CommandColumn>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel5" runat="server" />
                                                    </SelectionModel>
                                                    <SaveMask ShowMask="true" />
                                                    <LoadMask ShowMask="true" Msg="加载中…" />
                                                    <Listeners>
                                                        <Command Handler=" if (command == 'DownLoad')
                                                                    {
                                                                        window.open(record.data.LinkUrl);
                                                                    }" />
                                                    </Listeners>
                                                </ext:GridPanel>
                                            </ext:FitLayout>
                                        </Body>
                                    </ext:Panel>
                                </Body>
                                <Listeners>
                                    <Activate Handler="SetPageRegLotNewActivate();" />
                                </Listeners>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </Body>
                <Buttons>
                    <ext:Button ID="Button1" runat="server" Text="关闭" Icon="Delete">
                        <Listeners>
                            <Click Handler="#{windowRegistration}.hide();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
                <Listeners>
                    <BeforeHide Handler="#{GridPanel3}.clear();#{GridPanel2}.clear();" />
                </Listeners>
            </ext:Window>
        </div>
    </form>
</body>
</html>
