<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HospitalList.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.HospitalList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>

<%@ Register Src="../../Controls/HospitalEditor.ascx" TagName="HospitalEditor" TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <style type="text/css">
        .list-item
        {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
            padding: 3px 10px 3px 10px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #555;
        }
        .list-item h3
        {
            display: block;
            font: inherit;
            font-weight: bold;
            color: #222;
        }
    </style>

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
				confirm:"<%=GetLocalResourceObject("plSearch.btnDelete.Confirm").ToString()%>"
			}
        }

        var hospitalDetailsRender = function() {
            return '<img class="imgEdit" ext:qtip="<%=GetLocalResourceObject("hospitalDetailsRender.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/vcard_edit.png" />';
        }

        var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

            if (t.className == 'imgEdit' && columnId == 'Details') {
                openHospitalDetails(record, t, test);

                //the ajax event allowed
                //return true;

            }
        }


        var createHospital = function() {
            var flag = "0";
            var record = Ext.getCmp("GridPanel1").insertRecord(0, {});

            record.set('HosLastModifiedDate', Ext.util.Format.date(Date(), "Y-m-d\\TH:i:s"));

            Ext.getCmp("GridPanel1").getView().focusRow(0);
            createHospitalDetails(record, "GridPanel1", null,flag);
            //Ext.getCmp("GridPanel1").startEditing(0, 0);

        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:JsonStore ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="Store1_RefershData"
            OnBeforeStoreChanged="Store1_BeforeStoreChanged"  AutoLoad="false">
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
                        <ext:RecordField Name="HosLastModifiedDate"/>
                        <ext:RecordField Name="LastUpdateUserName"/>
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert(MsgList.Store1.LoadExceptionTitle, e.message || e )" />
                <%--<CommitFailed Handler="Ext.Msg.alert(MsgList.Store1.CommitFailedTitle, MsgList.Store1.CommitFailedMsg + msg)" />--%>
                <CommitFailed Handler="" />
                <SaveException Handler="Ext.Msg.alert(MsgList.Store1.SaveExceptionTitle, e.message)" />
                <CommitDone Handler="Ext.Msg.alert(MsgList.Store1.CommitDoneTitle, MsgList.Store1.CommitDoneMsg);" />
            </Listeners>
        </ext:JsonStore>
        <ext:Store ID="Store2" runat="server" UseIdConfirmation="true" OnRefreshData="Store_HospitalGrade">
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
        <ext:Store ID="ReportUserStore" runat="server" OnRefreshData="ReportUserStore_RefreshData" AutoLoad="false" >
                <Reader><ext:JsonReader ><Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="HospitalId" />
                <ext:RecordField Name="HospitalName" />
                <ext:RecordField Name="Grade" />
                <ext:RecordField Name="Province" />
                <ext:RecordField Name="City" />
                <ext:RecordField Name="District" />
                <ext:RecordField Name="KeyAccount" />
                <ext:RecordField Name="UserName" />
                <ext:RecordField Name="Phone" />
                <ext:RecordField Name="HasBinding" />
                <ext:RecordField Name="WeChat" />
                <ext:RecordField Name="IsActive" />
                <ext:RecordField Name="IsDeleted" />
                <ext:RecordField Name="CreateUser" />
                <ext:RecordField Name="CreateDate" />
                <ext:RecordField Name="UpdateUser" />
                <ext:RecordField Name="UpdateDate" />
            </Fields></ext:JsonReader></Reader>
        </ext:Store>
        <ext:Store ID="ProvincesStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProvinces">
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
        <ext:Store ID="CitiesStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshCities">
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
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>" Frame="true" AutoHeight="true"
                        Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtSearchHospitalName" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout1.FieldLabel %>" Width="150" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cmbProvince" runat="server" FieldLabel="<%$ Resources:plSearch.FormLayout1.cmbProvince.FieldLabel %>" StoreID="ProvincesStore"
                                                            Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true"
                                                            Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources:plSearch.FormLayout1.cmbProvince.EmptyText %>" SelectOnFocus="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:plSearch.FormLayout1.cmbProvince.EmptyText.Qtip%>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <Select Handler="#{cmbCity}.clearValue(); #{CitiesStore}.reload(); #{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                                <TriggerClick Handler="this.clearValue(); #{cmbCity}.clearValue(); #{CitiesStore}.reload(); #{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
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
                                                        <ext:ComboBox ID="cmbGrade" runat="server" FieldLabel="<%$ Resources:plSearch.FormLayout2.cmbGrade.FieldLabel%>" StoreID="Store2" Editable="false"
                                                            DisplayField="Value" ValueField="Key" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                            TriggerAction="All" EmptyText="<%$ Resources:plSearch.FormLayout2.cmbGrade.EmptyText%>" ItemSelector="div.list-item" SelectOnFocus="true">
                                                            <Template ID="Template1" runat="server">
                                                            <tpl for=".">
                                                                <div class="list-item">
                                                                     {Value}
                                                                </div>
                                                            </tpl>
                                                            </Template>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:plSearch.FormLayout2.cmbGrade.EmptyText.Qtip%>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cmbCity" runat="server" FieldLabel="<%$ Resources:plSearch.FormLayout2.cmbCity.FieldLabel%>" StoreID="CitiesStore" Editable="false"
                                                            DisplayField="Description" ValueField="TerId" TypeAhead="true" Mode="Local" ForceSelection="true"
                                                            TriggerAction="All" EmptyText="<%$ Resources:plSearch.FormLayout2.cmbCity.EmptyText%>" SelectOnFocus="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:plSearch.FormLayout2.cmbCity.EmptyText.Qtip%>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <Select Handler="#{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
                                                                <TriggerClick Handler="this.clearValue(); #{cmbDistrict}.clearValue(); #{DistrictStore}.reload();" />
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
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtSearchDirector" runat="server" FieldLabel="<%$ Resources:plSearch.FormLayout3.txtSearchDirector.FieldLabel%>" Width="150" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cmbDistrict" runat="server" FieldLabel="<%$ Resources:plSearch.FormLayout3.cmbDistrict.FieldLabel%>" StoreID="DistrictStore"
                                                            Editable="false" DisplayField="Description" ValueField="TerId" TypeAhead="true"
                                                            Mode="Local" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources:plSearch.FormLayout3.cmbDistrict.EmptyText%>" SelectOnFocus="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:plSearch.FormLayout3.cmbDistrict.EmptyText.Qtip%>" />
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
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="<%$ Resources:plSearch.btnSearch.Text%>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                       <%-- <Click Handler="#{GridPanel1}.reload();" />--%>
                                       <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources:plSearch.btnInsert.Text%>" Icon="Add" CommandArgument=""
                                    CommandName="" IDMode="Legacy" OnClientClick="">
                                    <AjaxEvents >
                                         <Click OnEvent="GetHospitalID" Success="createHospital();"></Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnSave" runat="server" Text="<%$ Resources:plSearch.btnSave.Text%>" Icon="Disk" CommandArgument=""
                                    CommandName="" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{GridPanel1}.save();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources:plSearch.btnDelete.Text%>" Icon="Delete" IDMode="Legacy" >
                                    <Listeners>
                                        <Click Handler="var result = confirm(MsgList.btnDelete.confirm); if ( (result) && #{GridPanel1}.hasSelection()) { #{GridPanel1}.deleteSelected(); #{btnSave}.enable();}" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources:GridPanel1.Title%>" AutoExpandColumn="HosHospitalName"
                                        StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="<%$ Resources:GridPanel1.ColumnModel1.HosHospitalName.Header%>">
                                       
                                                </ext:Column>
                                                <ext:Column DataIndex="HosKeyAccount" Header="<%$ Resources:GridPanel1.ColumnModel1.HosKeyAccount.Header%>">
                                             
                                                </ext:Column>
                                                <ext:Column DataIndex="HosGrade" Header="<%$ Resources:GridPanel1.ColumnModel1.HosGrade.Header%>">
                                          
                                                </ext:Column>
                                                <ext:Column DataIndex="HosProvince" Header="<%$ Resources:GridPanel1.ColumnModel1.HosProvince.Header%>">
                                                  
                                                </ext:Column>
                                                <ext:Column DataIndex="HosCity" Header="<%$ Resources:GridPanel1.ColumnModel1.HosCity.Header%>">
                                                  
                                                </ext:Column>
                                                <ext:Column DataIndex="HosDistrict" Header="<%$ Resources:GridPanel1.ColumnModel1.HosDistrict.Header%>">
                                                </ext:Column>
                                                <ext:Column DataIndex="HosDirector" Header="<%$ Resources:GridPanel1.ColumnModel1.HosDirector.Header%>">
                                                  
                                                </ext:Column>
                                                <ext:Column DataIndex="HosDirectorContact" Header="<%$ Resources:GridPanel1.ColumnModel1.HosDirectorContact.Header%>">
                                                   
                                                </ext:Column>
                                                <ext:Column DataIndex="HosLastModifiedDate" Header="<%$ Resources:GridPanel1.ColumnModel1.HosLastModifiedDate.Header%>">
                                                  <Renderer  Fn="Ext.util.Format.dateRenderer('m/d/Y h:i')" />
                                                </ext:Column>
                                                
                                                
                                                <ext:Column DataIndex="LastUpdateUserName" Header="<%$ Resources:GridPanel1.ColumnModel1.LastUpdateUserName.Header%>">
                                                   
                                                </ext:Column>
                                                
                                                <ext:Column ColumnID="Details" Header="<%$ Resources:GridPanel1.ColumnModel1.Details.Header%>" Width="50" Align="Center" Fixed="true"
                                                    MenuDisabled="true" Resizable="false">
                                                    <Renderer Fn="hospitalDetailsRender" />
                                                </ext:Column>
                                                <ext:CommandColumn Header="医院上报人员" Align="Center" Hidden="true" >
                                                    <Commands>
                                                        <ext:GridCommand Icon="ReportUser" CommandName="ReportUser">
                                                            <ToolTip Text="用户" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources:GridPanel1.PagingToolBar1.EmptyMsg%>" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel1.LoadMask.Msg%>" />
                                        <Listeners>
                                            <CellClick Fn="cellClick" />
                                            <Command Handler="Coolite.AjaxMethods.ShowReportUserList(record.data.HosId,{success:function(){#{ReportUserWindow}.show();}});" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <uc1:HospitalEditor ID="HospitalEditor1" runat="server" />
        
        <ext:Hidden ID="hiddenHospId" runat="server"></ext:Hidden>
        <ext:Window ID="ReportUserWindow" runat="server" Icon="Group" Title="医院上报数据人员信息" Resizable="false" Header="false" 
            Width="790" Height="450" AutoShow="false" Modal="true" ShowOnLoad="false" >
            <Body>
                <ext:FitLayout ID="FitLayout2" runat="server">
                    <ext:GridPanel ID="ReportUserPanel" runat="server" Title="医院上报数据人员信息" StoreID="ReportUserStore" 
                        Border="false" Icon="Lorry" Width="755" AutoScroll="true" EnableHdMenu="false"  StripeRows="true" >
                        <TopBar>
                            <ext:Toolbar ID="Toolbar1" runat="server" Height="20" >
                                <Items>
                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                    <ext:Button ID="btnAddItem" runat="server" Text="添加" Icon="Add">
                                        <Listeners>
                                            <Click Handler="Coolite.AjaxMethods.ShowUserInfo('',{success:function(){#{UserDeatailWindows}.show();}});"/>
                                        </Listeners>
                                    </ext:Button>
                                </Items>
                            </ext:Toolbar>
                        </TopBar>
                        <ColumnModel ID="ColumnModel2" runat="server" >
                            <Columns>
                                 <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="医院名称" >
                                 </ext:Column>
                                 <ext:Column ColumnID="Grade" DataIndex="Grade" Header="医院等级" Width="70" >
                                 </ext:Column>
                                 <ext:Column ColumnID="KeyAccount" DataIndex="KeyAccount" Header="医院编号" Width="60" >
                                 </ext:Column>
                                 <ext:Column ColumnID="Province" DataIndex="Province" Header="省份" Width="60" >
                                 </ext:Column>
                                 <ext:Column ColumnID="City" DataIndex="City" Header="地区" Width="60" >
                                 </ext:Column>
                                 <ext:Column ColumnID="District" DataIndex="District" Header="区/县" Width="60" >
                                 </ext:Column>
                                 <ext:Column ColumnID="UserName" DataIndex="UserName" Header="用户名" Width="60" >
                                 </ext:Column>
                                 <ext:Column ColumnID="Phone" DataIndex="Phone" Header="手机号" >
                                 </ext:Column>
                                 <ext:CheckColumn ColumnID="HasBinding" DataIndex="HasBinding" Header="已绑定微信号" Width="90">
                                 </ext:CheckColumn>
                                 <ext:CheckColumn ColumnID="IsActive" DataIndex="IsActive" Header="是否有效" Width="60">
                                 </ext:CheckColumn>
                                 <ext:CommandColumn Width="50" Header="明细" Align="Center">
                                    <Commands>
                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit" ToolTip-Text="操作" />
                                        <ext:CommandSeparator />
                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                    </Commands>
                                </ext:CommandColumn>
                            </Columns>
                        </ColumnModel>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                            </ext:RowSelectionModel>
                        </SelectionModel>
                        <SaveMask ShowMask="true" />
                        <LoadMask ShowMask="true" Msg="正在执行中..." />
                        <Listeners>
                            <Command Handler="if (command == 'Delete'){
                                                Ext.Msg.confirm('警告', '是否要执行删除?',
                                                    function(e) {
                                                        if (e == 'yes') {
                                                            Coolite.AjaxMethods.DeleteUser(record.data.Id,{
                                                                success: function() {
                                                                    Ext.Msg.alert('Message', '删除成功！');
                                                                    #{ReportUserPanel}.reload();
                                                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                        }
                                                    });
                                                }
                                              else if(command == 'Edit'){
                                                Coolite.AjaxMethods.ShowUserInfo(record.data.Id,{success:function(){#{UserDeatailWindows}.show();}});
                                              }" />
                        </Listeners>
                    </ext:GridPanel>
                </ext:FitLayout>
            </body>
            <Listeners>
                <BeforeShow Handler="#{ReportUserPanel}.clear();" />
                <Show Handler="#{ReportUserPanel}.reload();" />
            </Listeners>
        </ext:Window>
        
        <ext:Hidden ID="hiddenReportUserId" runat="server"></ext:Hidden>
        <ext:Window ID="UserDeatailWindows" runat="server" Icon="Group" Title="人员明细" Resizable="false" Header="false" 
            Width="300" Height="190" AutoShow="false" Modal="true" ShowOnLoad="false" >
            <Body>
                <ext:FitLayout ID="FitLayout3" runat="server">
                    <ext:Panel ID="Panel5" runat="server" Header="false" Title="上报人员信息" Frame="true" AutoHeight="true" Icon="Group" >
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn >
                                    <ext:Panel ID="Panel4" runat="server" Border="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfWinUserName" runat="server" FieldLabel="姓名" ></ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfWinPhone" runat="server" FieldLabel="手机号" ></ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Checkbox ID="cbWinHasWebChat" runat="server" FieldLabel="是否已绑定" Disabled="true" ></ext:Checkbox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Checkbox ID="cbWinActive" runat="server" FieldLabel="是否有效"></ext:Checkbox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:Panel>
                </ext:FitLayout>
            </body>
            <Buttons>
                <ext:Button ID="btnWinSave" runat="server" Text="保存" Icon="Disk" >
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveUserInfo();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnWinCancel" runat="server" Text="返回" Icon="Cross" >
                    <Listeners>
                        <Click Handler="#{UserDeatailWindows}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
    </div>
    </form>
</body>
</html>
