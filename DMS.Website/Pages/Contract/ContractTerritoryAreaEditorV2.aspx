<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractTerritoryAreaEditorV2.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractTerritoryAreaEditorV2" %>

<%@ Register Src="../../Controls/HospitalSearchDialogDCMS.ascx" TagName="HospitalSearchDCMSDialog"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
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
        .lightyellow-row
        {
            background: #FFFFD8;
        }
        .x-panel-body
        {
            background-color: #dfe8f6;
        }
        .x-column-inner
        {
            height: auto !important;
            width: auto !important;
        }
        .list-item
        {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
            padding: 3px 10px 3px 10px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #555;
        }
    </style>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });
        var MsgList = {
            AuthorizationStore: {
                LoadExceptionTitle: "提示 - 数据加载失败",
                CommitFailedTitle: "提示 - 提交失败",
                SaveExceptionTitle: "提示 - 保存失败",
                CommitDoneTitle: "提示",
                CommitDoneMsg: "保存成功!"
            },
             AuthorizationHospitStore: {
                LoadExceptionTitle: "提示 - 数据加载失败",
                CommitFailedTitle: "提示 - 提交失败",
                SaveExceptionTitle: "提示 - 操作失败",
                CommitDoneTitle: "提示",
                CommitDoneMsg: "操作成功!"
            },
            Store2: {
                LoadExceptionTitle: "提示 - 数据加载失败"
            },
            btnDelete: {
                confirm: "确认删除授权产品？",
                alert: "删除失败，请先删除授权医院!"
            },
            btnDeleteHospital: {
                confirm: "你确信删除吗?"
            },
            btnAreaDelete:{
               confirm: "确认删除授权区域？",
                alert: "删除失败!"
            }
            ,
             btnAreaDeleteqb:{
               confirm: "将删除该BU下所有医院，是否确定？",
                alert: "删除失败!"
            }
        }
          var selectedAuthorization = function(grid,row, record)
        {
         
            <%= hiddenId.ClientID %>.setValue(record.data["Id"]);    
            var btndel = Ext.getCmp("btnDelete");
            var btaAddarea=Ext.getCmp("BtnAddArea");
            var btnDeleteArea=Ext.getCmp("BtnCaneArea");
          
            if(btndel != null)
            btndel.enable();
            if(btaAddarea!=null)
            btaAddarea.enable();
            if(btnDeleteArea !=null)
             btnDeleteArea.disable();
            
            Ext.getCmp("gplAuthHospital").reload();
             Ext.getCmp("GridPanel1").reload();
        }
        var selectedAuthorizationArea=function(grid,row, record)
        {
         var btndel = Ext.getCmp("BtnCaneArea");
         if(btndel !=null)
         btndel.enable();
        }
        var selectHospitrow=function(grid,row, record)
        {
         var btnDeleteHospital = Ext.getCmp("btnDeleteHospital");
         if(btnDeleteHospital !=null)
         btnDeleteHospital.enable();
        }
        
               var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
            if(t.className == 'imgEdit' && columnId == 'Details')
            {
                openAuthorizationDialog(record, t);
            }
        }
        
        var addItems = function(grid) {
            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
                var param = '';

                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.Id + ',';
                }

                Coolite.AjaxMethods.addProduct(param, {
                    success: function() {
                        Ext.getCmp('<%=this.gplAuthorization.ClientID%>').reload();
                    },
                    failure: function(err) {
                        Ext.Msg.alert('Error', err);
                    }
                });
             

            } else {
                Ext.MessageBox.alert('错误', '请选择要添加的产品');
            }
        }
        var addItemsArea=function(grid)
        {
            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
               
                var param = '';

                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.Id + ',';
                }
                Coolite.AjaxMethods.addArea(param, {
                    success: function() {
                        Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
                    },
                    failure: function(err) {
                        Ext.Msg.alert('Error', err);
                    }
                });
             

            } else {
                Ext.MessageBox.alert('错误', '请与管理员联系');
            }
        }
         var showHospitalSelectorDlg = function() {
            var AreaStore=  Ext.getCmp('<%=this.GridPanel1.ClientID%>').store;
            if(AreaStore.getCount()<=0)
          {
           Ext.Msg.alert('提醒', '请先选择授权区域!');
           return;
          }
            var lineId = <%= hiddenProductLine.ClientID %>.getValue();
            var dclId = <%= hiddenId.ClientID %>.getValue();
            
            if(dclId == null || dclId =="" || lineId == null || lineId == "")
              Ext.Msg.alert('提醒', '请选择授权产品分类!');
            else 
                openHospitalSearchDlg(lineId);
               
        }
             //Dialog:复制医院
        var showHospitalCopyDlg = function() {
           
            var contractId = <%= hiddenContractId.ClientID %>.getValue();
            var dclId = <%= hiddenId.ClientID %>.getValue();
            
            if(dclId == null || dclId =="")
              Ext.Msg.alert('提醒', '请选择授权分类!');
            else 
                openAuthSelectorDlg();
        }
        //复制区域
        var ShowAreaCopeShow=function() {
           
            var contractId = <%= hiddenContractId.ClientID %>.getValue();
            var dclId = <%= hiddenId.ClientID %>.getValue();
            
            if(dclId == null || dclId =="")
              Ext.Msg.alert('提醒', '请选择授权分类!');
            else 
                openAuthSelectorAreaDlg();
        }
         var openAuthSelectorDlg = function () {
            var window = <%= AuthSelectorDlg.ClientID %>;
            <%= GridPanel2.ClientID %>.clear();
            <%= GridPanel2.ClientID %>.reload();
            window.show(null);
        }
        var openAuthSelectorAreaDlg= function () {
            var window = <%= AuthAreaCopeWindow.ClientID %>;
            <%= GridPanel3.ClientID %>.clear();
            <%= GridPanel3.ClientID %>.reload();
            window.show(null);
        }
    </script>

    <ext:Hidden ID="hiddenContractId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenProductLine" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenDealer" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidDivisionID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidIsEmerging" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidIsChange" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidPartsContractCode" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidContractType" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidBeginDate" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidEndDate" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidLastContractId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenIsDeleteHospit" runat="server">
    </ext:Hidden>
      <ext:Hidden ID="hidPageOperation" runat="server">
    </ext:Hidden>
  
    <%--    <ext:Store ID="AreaStore" runat="server" UseIdConfirmation="false" OnRefreshData="AreaStore_OnRefreshData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="TerId">
                <Fields>
                    <ext:RecordField Name="TerId" />
                    <ext:RecordField Name="Description" />
                    <ext:RecordField Name="Selected" />
                </Fields>
            </ext:JsonReader>
        </Reader>--%>
    <%--    </ext:Store>--%>
    <%--添加授权产品--%>
    <ext:Store ID="AllProductStore" runat="server" UseIdConfirmation="false" OnRefreshData="AllProductStore_RefershData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="SubBuCode" />
                    <ext:RecordField Name="SubBuName" />
                    <ext:RecordField Name="CaCode" />
                    <ext:RecordField Name="CaName" />
                    <ext:RecordField Name="CaNameEn" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="AuthorizationHospitStore" runat="server" UseIdConfirmation="false"
        OnRefreshData="AuthorizationHospitStore_RefershData" OnBeforeStoreChanged="AuthorizationHospitStore_BeforeStoreChanged"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="HosId">
                <Fields>
                    <ext:RecordField Name="ID" />
                    <ext:RecordField Name="HosId" />
                    <ext:RecordField Name="HosHospitalShortName" />
                    <ext:RecordField Name="HosHospitalName" />
                    <ext:RecordField Name="HosGrade" />
                    <ext:RecordField Name="HosKeyAccount" />
                    <ext:RecordField Name="HosProvince" />
                    <ext:RecordField Name="HosCity" />
                    <ext:RecordField Name="HosDistrict" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.AuthorizationHospitStore.LoadExceptionTitle, e.message || e )" />
            <CommitFailed Handler="Ext.Msg.alert(MsgList.AuthorizationHospitStore.CommitFailedTitle, 'Reason: ' + msg)" />
            <SaveException Handler="Ext.Msg.alert(MsgList.AuthorizationHospitStore.SaveExceptionTitle, e.message || e)" />
            <CommitDone Handler="Ext.Msg.alert(MsgList.AuthorizationHospitStore.CommitDoneTitle, MsgList.AuthorizationHospitStore.CommitDoneMsg);" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="AuthorizationStore" runat="server" UseIdConfirmation="false" OnRefreshData="AuthorizationStore_RefershData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ProductLineSubDesc" />
                    <ext:RecordField Name="ProductLineSub" />
                    <ext:RecordField Name="PmaId" />
                    <ext:RecordField Name="DclId" />
                    <ext:RecordField Name="DmaId" />
                    <ext:RecordField Name="ProductLineBumId" />
                    <ext:RecordField Name="AuthorizationType" />
                    <ext:RecordField Name="PmaDesc" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.AuthorizationStore.LoadExceptionTitle, e.message || e )" />
            <CommitFailed Handler="Ext.Msg.alert(MsgList.AuthorizationStore.CommitFailedTitle, 'Reason: ' + msg)" />
            <SaveException Handler="Ext.Msg.alert(MsgList.AuthorizationStore.SaveExceptionTitle, e.message || e)" />
            <CommitDone Handler="Ext.Msg.alert(MsgList.AuthorizationStore.CommitDoneTitle, MsgList.AuthorizationStore.CommitDoneMsg);" />
        </Listeners>
    </ext:Store>
    <%--复制授权医院--%>
    <ext:Store ID="AuthorizationSelectorStore" runat="server" UseIdConfirmation="false"
        OnRefreshData="AuthorizationSelectorStore_RefershData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="PmaId" />
                    <ext:RecordField Name="PmaDesc" />
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="DmaId" />
                    <ext:RecordField Name="ProductLineBumId" />
                    <ext:RecordField Name="AuthorizationType" />
                    <ext:RecordField Name="HospitalListDesc" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('<%$ Resources: MSG.LoadException %>', e.message || e )" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="AreaTempStore" runat="server" UseIdConfirmation="false" OnRefreshData="AreaTempStore_RefershData"
        OnBeforeStoreChanged="AreaTempStore_BeforeStoreChanged">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Description" />
                    <ext:RecordField Name="Code" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.AuthorizationStore.LoadExceptionTitle, e.message || e );" />
            <CommitFailed Handler="Ext.Msg.alert(MsgList.AuthorizationStore.CommitFailedTitle, 'Reason: ' + msg);" />
            <SaveException Handler="Ext.Msg.alert(MsgList.AuthorizationStore.SaveExceptionTitle, e.message || e)" />
            <CommitDone Handler="Ext.Msg.alert(MsgList.AuthorizationStore.CommitDoneTitle, MsgList.AuthorizationStore.CommitDoneMsg);" />
            <BeforeLoad Handler="#{btnAddHospital}.disable();#{gplAuthorization}.disable();" />
            <Load Handler="#{btnAddHospital}.enable();;#{gplAuthorization}.enable();" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="TerritoryStore" runat="server" UseIdConfirmation="false" OnRefreshData="TerritoryStore_RefershData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Description" />
                    <ext:RecordField Name="Code" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.AuthorizationStore.LoadExceptionTitle, e.message || e )" />
            <CommitFailed Handler="Ext.Msg.alert(MsgList.AuthorizationStore.CommitFailedTitle, 'Reason: ' + msg)" />
            <SaveException Handler="Ext.Msg.alert(MsgList.AuthorizationStore.SaveExceptionTitle, e.message || e)" />
            <CommitDone Handler="Ext.Msg.alert(MsgList.AuthorizationStore.CommitDoneTitle, MsgList.AuthorizationStore.CommitDoneMsg);" />
        </Listeners>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <Center MarginsSummary="5 5 5 5">
                    <ext:Panel ID="Panel1" runat="server">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server" Split="true" FitHeight="true">
                                <Columns>
                                    <ext:LayoutColumn ColumnWidth="0.5">
                                        <ext:Panel runat="server" Frame="True" Title="授权产品" Icon="Lorry" ID="plAuthorization"
                                            IDMode="Legacy">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout1" runat="server">
                                                    <ext:GridPanel ID="gplAuthorization" runat="server" StoreID="AuthorizationStore"
                                                        Border="false" Icon="Lorry" Header="false" AutoExpandColumn="ProductDescription"
                                                        AutoExpandMax="250" AutoExpandMin="150" StripeRows="true">
                                                        <ColumnModel ID="ColumnModel1" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="ProductLineSubDesc" DataIndex="ProductLineSubDesc" Header="合同产品分类"
                                                                    Width="120">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="PmaDesc" DataIndex="PmaDesc" Header="授权产品分类" Width="120">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductDescription" DataIndex="ProductDescription" Header="产品描述">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="HospitalListDesc" DataIndex="HospitalListDesc" Header="授权区域描述"
                                                                    Width="150">
                                                                </ext:Column>
                                                                <%--  <ext:Column ColumnID="Details" Header="批量导入区域" Width="100">
                                                                     <Renderer Fn="authDetailsRender" />
                                                                </ext:Column>--%>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true">
                                                                <Listeners>
                                                                    <RowSelect Fn="selectedAuthorization" />
                                                                </Listeners>
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                        <Listeners>
                                                            <CellClick Fn="cellClick" />
                                                        </Listeners>
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                            <Buttons>
                                                <ext:Button ID="btnAdd" runat="server" Text="新增授权产品" Icon="Add" CommandArgument=""
                                                    CommandName="" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="#{authorizationEditorWindow}.show();#{GridAllProduct}.reload();" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="btnDelete" runat="server" Text="删除授权产品" Icon="Delete" CommandArgument=""
                                                    CommandName="" IDMode="Legacy" OnClientClick="" Disabled="True">
                                                    <AjaxEvents>
                                                        <Click Before="var result = confirm(MsgList.btnDelete.confirm)&& #{gplAuthorization}.hasSelection(); if (!result) return false;"
                                                            OnEvent="DeleteAreaAuthorization_Click" Success="#{gplAuthorization}.reload();#{hiddenId}.setValue('');#{btnDelete}.disable();#{BtnAddArea}.disable(); "
                                                            Failure="Ext.Msg.alert('Message',MsgList.btnDelete.alert)">
                                                        </Click>
                                                    </AjaxEvents>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth="0.5">
                                        <ext:Panel runat="server" Frame="True" Title="授权区域" Icon="Lorry" ID="plArea" IDMode="Legacy">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout2" runat="server">
                                                    <ext:GridPanel ID="GridPanel1" runat="server" StoreID="AreaTempStore" Border="false"
                                                        Icon="Lorry" Header="false" AutoExpandColumn="Description" AutoExpandMax="250"
                                                        AutoExpandMin="150" StripeRows="true" MultiSelect="true">
                                                        <ColumnModel ID="ColumnModel2" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Description" DataIndex="Description" Header="区域名称" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Code" DataIndex="Code" Header="区域编号" Width="70">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server">
                                                                <Listeners>
                                                                    <RowSelect Handler="var btndel = #{BtnCaneArea}; if(btndel != null ) btndel.enable();" />
                                                                </Listeners>
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                        <Listeners>
                                                            <CellClick Fn="cellClick" />
                                                        </Listeners>
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                            <Buttons>
                                                <ext:Button ID="BtnAddArea" runat="server" Text="新增授权区域" Icon="Add" CommandArgument=""
                                                    CommandName="" IDMode="Legacy" Disabled="True">
                                                    <Listeners>
                                                        <Click Handler="#{TerritoryAreaWindow}.show();#{gpTerritory}.reload();" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="Button1" runat="server" Text="复制授权区域" Icon="Add" CommandArgument=""
                                                    CommandName="" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Fn="ShowAreaCopeShow" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="BtnCaneArea" runat="server" Text="删除" Icon="Delete" CommandArgument=""
                                                    CommandName="" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="var result = confirm(MsgList.btnAreaDelete.confirm);
                                                         var grid = #{GridPanel1};if(grid.getSelectionModel().getSelections().length==#{GridPanel1}.store.getCount()){result =confirm(MsgList.btnAreaDeleteqb.confirm);#{hiddenIsDeleteHospit}.setValue('true');} if ( (result) && grid.hasSelection()) { grid.deleteSelected(); grid.save();}" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </Columns>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:Panel>
                </Center>
                <South Collapsible="True" Split="True" MarginsSummary="0 5 5 5">
                    <ext:Panel ID="pnlSouth" runat="server" Title="排除医院" Icon="Basket" Height="280" IDMode="Legacy">
                        <Body>
                            <ext:FitLayout ID="FitLayout3" runat="server">
                                <ext:GridPanel ID="gplAuthHospital" runat="server" Title="排除医院" Header="false" StoreID="AuthorizationHospitStore"
                                    Border="false" Icon="Lorry" StripeRows="true" AutoExpandColumn="HosKeyAccount">
                                    <ColumnModel ID="ColumnModel3" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="医院名称"
                                                Width="200">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosKeyAccount" ColumnID="HosKeyAccount" Header="医院编号">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosGrade" ColumnID="HosGrade" Header="等级">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosProvince" ColumnID="HosProvince" Header="省份">
                                            </ext:Column>
                                            <ext:Column DataIndex="HosCity" ColumnID="HosCity" Header="地区">
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel3" runat="server">
                                            <Listeners>
                                                <RowSelect Handler="var btndel = #{btnDeleteHospital}; if(btndel != null ) btndel.enable();" />
                                            </Listeners>
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <CellClick Fn="cellClick" />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="AuthorizationHospitStore"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <LoadMask ShowMask="true" Msg="处理中..." />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnAddHospital" runat="server" Text="添加医院" Icon="Add" CommandArgument=""
                                CommandName="" IDMode="Legacy">
                                <Listeners>
                                    <Click Fn="showHospitalSelectorDlg" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnCopyHospital" runat="server" Text="复制医院" Icon="Add" CommandArgument=""
                                CommandName="" IDMode="Legacy">
                                <Listeners>
                                    <Click Fn="showHospitalCopyDlg" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnDeleteHospital" runat="server" Text="删除" Icon="Delete" CommandArgument=""
                                CommandName="" IDMode="Legacy" OnClientClick="" Disabled="True">
                                <Listeners>
                                    <Click Handler="var result = confirm(MsgList.btnDeleteHospital.confirm); var grid = #{gplAuthHospital};if ( (result) && grid.hasSelection()) { grid.deleteSelected(); grid.save();}" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </South>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Window ID="authorizationEditorWindow" runat="server" Icon="Group" Title="授权产品"
        Closable="false" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="400"
        Draggable="false" Width="450" Modal="true" BodyStyle="padding:5px;">
        <Body>
            <ext:FitLayout ID="FitLayout4" runat="server">
                <ext:GridPanel ID="GridAllProduct" runat="server" Title="" AutoExpandColumn="CaName"
                    Header="false" StoreID="AllProductStore" Border="false" Icon="Lorry" StripeRows="true">
                    <ColumnModel ID="ColumnModel4" runat="server">
                        <Columns>
                            <ext:Column ColumnID="SubBuName" DataIndex="SubBuName" Header="合同产品分类">
                            </ext:Column>
                            <ext:Column ColumnID="CaName" DataIndex="CaName" Header="授权产品分类">
                            </ext:Column>
                        </Columns>
                    </ColumnModel>
                    <Plugins>
                        <ext:GridFilters runat="server" ID="GridFilters1" Local="true">
                            <Filters>
                                <ext:StringFilter DataIndex="SubBuName" />
                                <ext:StringFilter DataIndex="CaName" />
                            </Filters>
                        </ext:GridFilters>
                    </Plugins>
                    <SelectionModel>
                        <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                            <Listeners>
                                <RowSelect Handler="#{btnSaveButton}.enable();" />
                            </Listeners>
                        </ext:CheckboxSelectionModel>
                    </SelectionModel>
                    <LoadMask ShowMask="true" Msg="处理中..." />
                </ext:GridPanel>
            </ext:FitLayout>
        </Body>
        <Buttons>
            <ext:Button ID="btnSaveButton" runat="server" Text="确定" Icon="Disk">
                <Listeners>
                    <Click Handler="addItems(#{GridAllProduct});" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="btnCancelButton" runat="server" Text="取消" Icon="Cancel">
                <Listeners>
                    <Click Handler="#{authorizationEditorWindow}.hide(null);" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
    <ext:Window ID="TerritoryAreaWindow" runat="server" Icon="Group" Title="授权区域" Closable="false"
        AutoShow="false" ShowOnLoad="false" Resizable="false" Height="400" Draggable="false"
        Width="450" Modal="true" BodyStyle="padding:5px;">
        <Body>
            <ext:FitLayout ID="FitLayout5" runat="server">
                <ext:GridPanel ID="gpTerritory" runat="server" Title="" AutoExpandColumn="Description"
                    Header="false" StoreID="TerritoryStore" Border="false" Icon="Lorry" StripeRows="true">
                    <ColumnModel ID="ColumnModel5" runat="server">
                        <Columns>
                            <ext:Column ColumnID="Description" DataIndex="Description" Header="区域名称">
                            </ext:Column>
                            <ext:Column ColumnID="Code" DataIndex="Code" Header="编号">
                            </ext:Column>
                        </Columns>
                    </ColumnModel>
                    <Plugins>
                        <ext:GridFilters runat="server" ID="GridFilters2" Local="true">
                            <Filters>
                                <ext:StringFilter DataIndex="Description" />
                                <ext:StringFilter DataIndex="Code" />
                            </Filters>
                        </ext:GridFilters>
                    </Plugins>
                    <SelectionModel>
                        <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                            <Listeners>
                                <RowSelect Handler="#{BtnSaveArea}.enable();" />
                            </Listeners>
                        </ext:CheckboxSelectionModel>
                    </SelectionModel>
                    <LoadMask ShowMask="true" Msg="处理中..." />
                </ext:GridPanel>
            </ext:FitLayout>
        </Body>
        <Buttons>
            <ext:Button ID="BtnSaveArea" runat="server" Text="确定" Icon="Disk">
                <Listeners>
                    <Click Handler="addItemsArea(#{gpTerritory});" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="BtnCanceArea" runat="server" Text="取消" Icon="Cancel">
                <Listeners>
                    <Click Handler="#{TerritoryAreaWindow}.hide(null);" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
    <ext:Window ID="AuthSelectorDlg" runat="server" Icon="Group" Title="复制医院" Closable="true"
        Draggable="false" Resizable="true" Width="900" Height="480" AutoShow="false"
        Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
        <Body>
            <ext:ContainerLayout ID="ContainerLayout1" runat="server">
                <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Height="450" Header="false"
                    IDMode="Legacy">
                    <Body>
                        <ext:FitLayout ID="FitLayout6" runat="server">
                            <ext:GridPanel ID="GridPanel2" runat="server" Title="" AutoExpandColumn="ProductDescription"
                                Header="false" StoreID="AuthorizationSelectorStore" Border="false" Icon="Lorry"
                                StripeRows="true">
                                <ColumnModel ID="ColumnModel6" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="PmaDesc" DataIndex="PmaDesc" Header="产品分类" Width="150">
                                        </ext:Column>
                                        <ext:Column ColumnID="ProductDescription" DataIndex="ProductDescription" Header="产品描述">
                                        </ext:Column>
                                        <ext:Column ColumnID="HospitalListDesc" DataIndex="HospitalListDesc" Header="授权区域描述"
                                            Width="250">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel3" runat="server" SingleSelect="true">
                                        <Listeners>
                                            <RowSelect Handler="#{btnCopy}.enable();" />
                                        </Listeners>
                                    </ext:CheckboxSelectionModel>
                                </SelectionModel>
                                <LoadMask ShowMask="true" Msg="处理中..." />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnCopy" runat="server" Text="复制医院" Icon="Add" CommandArgument=""
                            CommandName="" IDMode="Legacy" OnClientClick="" Enabled="false">
                            <AjaxEvents>
                                <Click OnEvent="SubmitSelection" Success="#{AuthSelectorDlg}.hide(null);">
                                    <ExtraParams>
                                        <ext:Parameter Name="SelectValues" Value="Ext.encode(#{GridPanel2}.getRowsValues())"
                                            Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="btnCancel" runat="server" Text="取消" Icon="Cancel" CommandArgument=""
                            CommandName="" IDMode="Legacy" OnClientClick="">
                            <Listeners>
                                <Click Handler="#{AuthSelectorDlg}.hide(null);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </ext:ContainerLayout>
        </Body>
    </ext:Window>
    <ext:Window ID="AuthAreaCopeWindow" runat="server" Icon="Group" Title="复制授权区域" Closable="true"
        Draggable="false" Resizable="true" Width="900" Height="480" AutoShow="false"
        Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
        <Body>
            <ext:ContainerLayout ID="ContainerLayout2" runat="server">
                <ext:Panel runat="server" ID="Panel2" Border="false" Frame="true" Height="450" Header="false"
                    IDMode="Legacy">
                    <Body>
                        <ext:FitLayout ID="FitLayout7" runat="server">
                            <ext:GridPanel ID="GridPanel3" runat="server" Title="" AutoExpandColumn="ProductDescription"
                                Header="false" StoreID="AuthorizationSelectorStore" Border="false" Icon="Lorry"
                                StripeRows="true">
                                <ColumnModel ID="ColumnModel7" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="PmaDesc" DataIndex="PmaDesc" Header="产品分类" Width="150">
                                        </ext:Column>
                                        <ext:Column ColumnID="ProductDescription" DataIndex="ProductDescription" Header="产品描述">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel4" runat="server" SingleSelect="true">
                                        <Listeners>
                                            <RowSelect Handler="#{butAreaCopye}.enable();" />
                                        </Listeners>
                                    </ext:CheckboxSelectionModel>
                                </SelectionModel>
                                <LoadMask ShowMask="true" Msg="处理中..." />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="butAreaCopye" runat="server" Text="复制区域" Icon="Add" CommandArgument=""
                            CommandName="" IDMode="Legacy" OnClientClick="" Enabled="false">
                            <AjaxEvents>
                                <Click OnEvent="SubmitSelectionArea" Success="#{AuthAreaCopeWindow}.hide(null);">
                                    <ExtraParams>
                                        <ext:Parameter Name="SelectValues" Value="Ext.encode(#{GridPanel3}.getRowsValues())"
                                            Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="btnCanArea" runat="server" Text="取消" Icon="Cancel" CommandArgument=""
                            CommandName="" IDMode="Legacy" OnClientClick="">
                            <Listeners>
                                <Click Handler="#{AuthAreaCopeWindow}.hide(null);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </ext:ContainerLayout>
        </Body>
    </ext:Window>
    <uc1:HospitalSearchDCMSDialog ID="HospitalSearchDCMSDialog1" runat="server" />
    </form>
</body>
</html>
