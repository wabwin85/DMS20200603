<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerContractEditor.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.DealerContractEditor" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/PartsSelectorDialog.ascx" TagName="PartsSelectorDialog"
    TagPrefix="uc1" %>
<%@ Register Src="../../Controls/HospitalSelectorDialog.ascx" TagName="HospitalSelectorDialog"
    TagPrefix="uc1" %>
<%@ Register Src="../../Controls/HospitalSelectdDelDialog.ascx" TagName="HospitalSelectdDelDialog"
    TagPrefix="uc1" %>
<%@ Register Src="../../Controls/AuthorizationSelectorDialog.ascx" TagName="AuthSelectorDialog"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>DealerContractEditor</title>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript">
        var MsgList = {
			AuthorizationStore:{
				LoadExceptionTitle:"<%=GetLocalResourceObject("AuthorizationStore.LoadException.Alert").ToString()%>",
				CommitFailedTitle:"<%=GetLocalResourceObject("AuthorizationStore.CommitFailed.Alert").ToString()%>",
				SaveExceptionTitle:"<%=GetLocalResourceObject("AuthorizationStore.SaveException.Alert").ToString()%>",
				CommitDoneTitle:"<%=GetLocalResourceObject("AuthorizationStore.CommitDone.Alert").ToString()%>",
				CommitDoneMsg:"<%=GetLocalResourceObject("AuthorizationStore.CommitDone.Alert.body").ToString()%>"
			},
			Store2:{
				LoadExceptionTitle:"<%=GetLocalResourceObject("Store2.LoadException.Alert").ToString()%>"
			},
			btnDelete:{
				confirm:"<%=GetLocalResourceObject("plAuthorization.btnDelete.Confirm").ToString()%>",
				alert:"<%=GetLocalResourceObject("plAuthorization.btnDelete.Alert.Body").ToString()%>"
			},
			btnDeleteHospital:{
				confirm:"<%=GetLocalResourceObject("pnlSouth.gplAuthHospital.btnDeleteHospital.Confirm").ToString()%>"
			}
        }
        
        var authDetailsRender = function() {
            return '<img class="imgEdit" ext:qtip="<%=GetLocalResourceObject("authDetailsRender.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/note_edit.png" />';

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
        
        //Dialog:产品分类
        var showPartsSelectorDlg = function() {
            openPartsSelectorDlg(null);
        }

        //Dialog:医院
        var showHospitalSelectorDlg = function() {
        
           
            var lineId = <%= hiddenProductLine.ClientID %>.getValue();
            var dclId = <%= hiddenId.ClientID %>.getValue();
            
            if(dclId == null || dclId =="" || lineId == null || lineId == "")
              Ext.Msg.alert('<%=GetLocalResourceObject("showHospitalSelectorDlg.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("showHospitalSelectorDlg.Alert.Body").ToString()%>');
            else 
                openHospitalSelectorDlg(lineId);
        }
        //Dialog:删除医院
        var showHospitalSelectdDelDlg = function() {
           
            var lineId = <%= hiddenProductLine.ClientID %>.getValue();
            var dclId = <%= hiddenId.ClientID %>.getValue();
            
            if(dclId == null || dclId =="")
              Ext.Msg.alert('<%=GetLocalResourceObject("showHospitalSelectdDelDlg.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("showHospitalSelectdDelDlg.Alert.Body").ToString()%>');
            else 
                openHospitalSelectdDelDlg(dclId);
        }
        
        //Dialog:复制医院
        var showHospitalCopyDlg = function() {
           
            var contractId = <%= hiddenContractId.ClientID %>.getValue();
            var dclId = <%= hiddenId.ClientID %>.getValue();
            
            if(dclId == null || dclId =="")
              Ext.Msg.alert('<%=GetLocalResourceObject("showHospitalCopyDlg.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("showHospitalCopyDlg.Alert.Body").ToString()%>');
            else 
                openAuthSelectorDlg(contractId,dclId);
        }


       var currentRecord = null;
       var isCreated = false;
       
       var selectedAuthorization = function(grid,row, record)
       {
          <%= hiddenId.ClientID %>.setValue(record.data["Id"]);     
           var catoryId = record.data["PmaId"];    
          <%= hiddenCatagoryId.ClientID %>.setValue(record.data["PmaDesc"]);
          <%= hiddenProductLine.ClientID %>.setValue(record.data["ProductLineBumId"]);
          
          var btndel = Ext.getCmp("btnDelete");
          if(btndel != null)
            btndel.enable();
          
          Ext.getCmp("gplAuthHospital").reload();
          ReoladTab();
       }
       
        //编辑授权
        var openAuthorizationDialog =function(record, animTrg)
        {
            var window = <%= authorizationEditorWindow.ClientID %>;

            currentRecord = record;           

            var catoryId = record.data["PmaId"];

            <%= hiddenId.ClientID %>.setValue(record.data["Id"]);
            <%= hiddenCatagoryId.ClientID %>.setValue(catoryId);
            var catagoryName = record.data["PmaDesc"];
            <%= txtCatagoryName.ClientID %>.setValue(catagoryName);
            <%= txtProductDesc.ClientID %>.setValue(record.data["ProductDescription"]);
            <%= txtNote.ClientID %>.setValue(record.data["HospitalListDesc"]);

            var lineId = record.data["ProductLineBumId"];    
            <%= hiddenProductLine.ClientID %>.setValue(lineId);          
            var lineName = record.data["ProductLineDesc"];
            <%= txtProductLine.ClientID %>.setValue(lineName);

            if(record.data['StartDate'] != null && record.data['StartDate'] != '')
            {
                var dt1 = new Date(record.data['StartDate']);
                <%= dfAuthStartDate.ClientID %>.setValue(dt1);
            }
            else
            {
                <%= dfAuthStartDate.ClientID %>.setValue('');
            }

            if(record.data['EndDate'] != null && record.data['EndDate'] != '')
            {
                var dt2 = new Date(record.data['EndDate']);
                <%= dfAuthStopDate.ClientID %>.setValue(dt2);
            }
            else
            {
                <%= dfAuthStopDate.ClientID %>.setValue('');
            }

            <%= cbAuthTypeForEdit.ClientID %>.setValue(record.data["Type"]);
            
            if(isCreated)
            {
                <%= cbAuthTypeForEdit.ClientID %>.show();
                <%= txtAuthTypeForEdit.ClientID %>.hide();
            }
            else
            {
                <%= cbAuthTypeForEdit.ClientID %>.hide();
                <%= txtAuthTypeForEdit.ClientID %>.show();
                <%= txtAuthTypeForEdit.ClientID %>.setValue(getNameFromStoreById(<%= AuthTypeForSearchStore.ClientID %>,{Key:'Key',Value:'Value'},record.data["Type"]));
            }

            window.show(animTrg);
        }
        
       var cancelWindow =function()
        {
            isCreated = false;
            //added by bozhenfei on 20100827 取消窗口时要清除以下变量
<%= hiddenId.ClientID %>.setValue("");
<%= hiddenCatagoryId.ClientID %>.setValue("");
<%= hiddenProductLine.ClientID %>.setValue("");
//end
             <%= authorizationEditorWindow.ClientID %>.hide(null);
        }
            
        var saveAuthorization = function()
        {
            if ( <%= hiddenProductLine.ClientID %>.getValue() == "" || <%= hiddenCatagoryId.ClientID %>.getValue() == ""){
                Ext.Msg.alert('Warning', '请选择授权产品线或产品分类！');
                return;
            }
            if(<%= dfAuthStartDate.ClientID %>.getValue() == '')
            {
                Ext.Msg.alert('Warning', '请选择授权开始日期！');
                return;
            }
            if(<%= dfAuthStopDate.ClientID %>.getValue() == '')
            {
                Ext.Msg.alert('Warning', '请选择授权截止日期！');
                return;
            }
            if(<%= cbAuthTypeForEdit.ClientID %>.getValue() == '')
            {
                Ext.Msg.alert('Warning', '请选择授权类型！');
                return;
            }
                   
            Coolite.AjaxMethods.ValidAttachment(<%= hiddenId.ClientID %>.getValue(),
            {
                success: function(rtnMsg){
                    if(<%= cbAuthTypeForEdit.ClientID %>.getValue() != 'Normal'
                        && rtnMsg != 'Success')
                    {
                        Ext.Msg.alert('Warning', '请上传审批邮件！');
                    }
                    else
                    {
                        if (isCreated)
                        {
                            var productLine = <%= hiddenProductLine.ClientID %>.getValue();
                            var catagoryId = <%= hiddenCatagoryId.ClientID %>.getValue();

                            if (productLine == "" || catagoryId == ""){
                                Ext.Msg.alert('Warning', '请选择授权产品线或产品分类！');
                                return;
                            }
                            var dealerId = <%= hiddenDealer.ClientID %>.getValue();
                            var dclId = <%= hiddenContractId.ClientID %>.getValue();
                            var newid = <%= hiddenId.ClientID %>.getValue();

                            var grid = Ext.getCmp("gplAuthorization");
                            var record = grid.insertRecord(0, {});
                            currentRecord = record;

                            record.set('PmaId',catagoryId);
                            record.set('ProductLineBumId',productLine );

                            //如果分类Id等于产品线Id，则是按产品线授权的
                            var authorizationType = 1;
                            if(catagoryId==productLine) authorizationType = 0;                          
                            record.set('AuthorizationType',authorizationType);

                            record.set('DmaId',dealerId );
                            record.set('DclId',dclId);
                            record.set('Id',newid);

                            record.set('ProductDescription',<%= txtProductDesc.ClientID %>.getValue());
                            record.set('HospitalListDesc',<%= txtNote.ClientID %>.getValue());

                            record.set('StartDate',<%= dfAuthStartDate.ClientID %>.getValue());
                            record.set('EndDate',<%= dfAuthStopDate.ClientID %>.getValue());
                            record.set('Type',<%= cbAuthTypeForEdit.ClientID %>.getValue());

                            isCreated = false;
                            Ext.getCmp("gplAuthorization").save();
                            //grid.getSelectionModel().selectRow(0);
                            //grid.getView().focusRow(0);
                            <%= hiddenId.ClientID %>.setValue("");      
                            <%= hiddenCatagoryId.ClientID %>.setValue("");
                            <%= hiddenProductLine.ClientID %>.setValue("");
                            Ext.getCmp("gplAuthHospital").reload();
                        }
                        else 
                        {
                            var record = currentRecord ;
                            if(record != null)
                            {
                                var productLine =<%= hiddenProductLine.ClientID %>.getValue();
                                var catagoryId = <%= hiddenCatagoryId.ClientID %>.getValue();

                                record.set('PmaId',catagoryId);
                                record.set('PmaDesc',<%= txtCatagoryName.ClientID %>.getValue());
                                record.set('ProductLineBumId',productLine );
                                record.set('ProductLineDesc',<%= txtProductLine.ClientID %>.getValue());
                                record.set('ProductDescription',<%= txtProductDesc.ClientID %>.getValue() );
                                record.set('HospitalListDesc',<%= txtNote.ClientID %>.getValue() );

                                record.set('StartDate',<%= dfAuthStartDate.ClientID %>.getValue());
                                record.set('EndDate',<%= dfAuthStopDate.ClientID %>.getValue());
                                record.set('Type',<%= cbAuthTypeForEdit.ClientID %>.getValue());

                                //如果分类Id等于产品线Id，则是按产品线授权的
                                var authorizationType = 1;
                                if(catagoryId==productLine) authorizationType = 0;                          
                                record.set('AuthorizationType',authorizationType);

                                Ext.getCmp("gplAuthorization").save();
                            }       
                        }

                        <%= authorizationEditorWindow.ClientID %>.hide(null);
                        <%= gplAuthHospital.ClientID %>.reload();
                    }
                },
                failure: function(err){
                    Ext.Msg.alert('Error', err);
                }                
            });
       }
       
       
        //新建授权
        var createAuthorization = function() {

            var window = <%= authorizationEditorWindow.ClientID %>;
            
            <%= hiddenProductLine.ClientID %>.setValue("");   
            <%= txtProductLine.ClientID %>.setValue("");
            <%= hiddenCatagoryId.ClientID %>.setValue("");
            <%= txtCatagoryName.ClientID %>.setValue("");
            <%= txtProductDesc.ClientID %>.setValue("");
            <%= txtNote.ClientID %>.setValue("");
            
            <%= dfAuthStopDate.ClientID %>.setValue("");
            <%= dfAuthStartDate.ClientID %>.setValue("");
            
            <%= cbAuthTypeForEdit.ClientID %>.setValue("");
            <%= txtAuthTypeForEdit.ClientID %>.setValue("");
            <%= cbAuthTypeForEdit.ClientID %>.show();
            <%= txtAuthTypeForEdit.ClientID %>.hide();
            
            isCreated = true;
            window.show(null);

        }
        
 
        
        //render产品分类中文名称
        var renderParts = function(value) {
           var sName = "";
           var json_data =<%= hidCacheParts.ClientID %>.getValue() ;
           
           sName= getValueFromArray(json_data,value);
           return sName;
        }
        
       var renderLines = function(value)
       {
          var sName = "";
          var json_data =<%= hidCacheProductLines.ClientID %>.getValue() ; 
           sName= getValueFromArray(json_data,value);
           return sName;
       }
       
        var editId = '';
                        
        var renderEditControls=function(record){
            var tbHosStartDate = new Ext.form.DateField({id:"tbHosStartDate",xtype:"datefield",width:90,format:"Y-m-d",allowBlank:false,renderTo:'divHosStartDate'});
            var tbHosEndDate = new Ext.form.DateField({id:"tbHosEndDate",xtype:"datefield",width:90,format:"Y-m-d",allowBlank:false,renderTo:'divHosEndDate'});
            
            if(record.data.HosStartDate != null && record.data.HosStartDate != '')
            {
                var dt1 = new Date(record.data.HosStartDate);
                tbHosStartDate.setValue(dt1);
            }
            else
            {
                tbHosStartDate.setValue('');
            }
            if(record.data.HosStartDate != null && record.data.HosEndDate != '')
            {
                var dt2 = new Date(record.data.HosEndDate);
                tbHosEndDate.setValue(dt2);
            }
            else
            {
                tbHosEndDate.setValue('');
            }  
        }
                
        var renderData = function(value, meta, record, row, col, store){  
            
            if (editId == record.data.HosId){        
                return "<div id='div" + meta.id + "'><\/div>";
            }
            return Ext.util.Format.date(value,'Y-m-d');
        } 
        
        var rowCommand = function(command, record, row){
            if (command == "Edit"){
                editId = record.data.HosId;
                Ext.getCmp('<%=this.gplAuthHospital.ClientID %>').getView().refresh(true);
                renderEditControls(record);                
            }
            else if (command == "Cancel"){
                editId = '';
                Ext.getCmp('<%=this.gplAuthHospital.ClientID %>').getView().refresh(true);
            }   
            else if (command == "Save"){
                var tbHosStartDate = Ext.getCmp('tbHosStartDate');
                var tbHosEndDate = Ext.getCmp('tbHosEndDate');
                
                if (tbHosStartDate.isValid()
                        && tbHosEndDate.isValid())
                {
                    Coolite.AjaxMethods.SaveHosAuthDate(
                        record.data.HosId,
                        tbHosStartDate.getValue(),
                        tbHosEndDate.getValue(),
                        {
                            success: function(){
                                record.set('HosStartDate',tbHosStartDate.getRawValue());
                                record.set('HosEndDate',tbHosEndDate.getRawValue());
                                record.commit();
                                editId = '';
                                Ext.getCmp('<%=this.gplAuthHospital.ClientID %>').getView().refresh(true);
                                Ext.getCmp('<%=this.gplAuthHospital.ClientID %>').reload();
                                //renderEditControls(record);    
                            },
                            failure: function(err){
                                Ext.Msg.alert('Error', err);
                            }                            
                        }
                    );
                }
            }
        }   
        
        var prepareCommand = function(grid, command, record, row) {
            command.hidden = true;
          
            if (editId == record.id){
                if (command.command == "Save" || command.command == "Cancel"){
                    command.hidden = false;
                }
            }else{
                if (command.command == "Delete" || command.command == "Edit"){
                    command.hidden = false;
                }
            }
        }
        
        var ReoladTab = function() {
            Ext.getCmp('TabPanel1').setActiveTab(0);
            Ext.getCmp('TabAttachment').autoLoad.url = 'AttachmentList.aspx?AuthorizationId=' 
                        + Ext.getCmp('hiddenId').getValue() 
                        + '&FolderName=DealerAuthorization'
                        + '&CanUploadFile=1'
                        + '&CanDeleteFile=1';
        }
    </script>
    
    <ext:Store ID="AuthTypeForSearchStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="AuthTypeForEditStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
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
    <ext:Store ID="AuthorizationStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store1_RefershData"
        OnBeforeStoreChanged="Store1_BeforeStoreChanged">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="PmaId" />
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="DclId" />
                    <ext:RecordField Name="DmaId" />
                    <ext:RecordField Name="ProductLineBumId" />
                    <ext:RecordField Name="AuthorizationType" />
                    <ext:RecordField Name="HospitalListDesc" />
                    <ext:RecordField Name="ProductDescription" />
                    <ext:RecordField Name="PmaDesc" />
                    <ext:RecordField Name="ProductLineDesc" />
                    <ext:RecordField Name="StartDate" Type="Date" />
                    <ext:RecordField Name="EndDate" Type="Date" />
                    <ext:RecordField Name="Type" />
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
    <ext:Store ID="Store2" runat="server" UseIdConfirmation="false" OnRefreshData="Store2_RefershData"
        OnBeforeStoreChanged="Store2_BeforeStoreChanged" AutoLoad="false">
        <AutoLoadParams>
            <ext:Parameter Name="start" Value="={0}" />
            <ext:Parameter Name="limit" Value="={10}" />
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
                    <ext:RecordField Name="HosRemark" />
                    <ext:RecordField Name="HosStartDate" Type="Date" />
                    <ext:RecordField Name="HosEndDate" Type="Date" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.Store2.LoadExceptionTitle, e.message || e )" />
        </Listeners>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server" >
                <Center MarginsSummary="0 5 0 5" >
                    <ext:Panel ID="plAuthorization" runat="server" Header="true" Frame="true" Collapsible="true" AutoHeight="true" AutoScroll="true" BodyStyle="padding:5px;" >
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel3" runat="server" Border="true" Height="200" AutoScroll="true" >
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="120">
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:ComboBox ID="cbProductLine" runat="server" FieldLabel="产品线" Mode="Local" Resizable="true"
                                                        StoreID="ProductLineStore" DisplayField="AttributeName" ValueField="Id" >
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:ComboBox ID="cbAuthType" runat="server" FieldLabel="授权类型" Mode="Local" Resizable="true"
                                                        StoreID="AuthTypeForSearchStore" DisplayField="Value" ValueField="Key" >
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:DateField ID="dfAuthStartBeginDate" runat="server" FieldLabel="授权开始时间" ></ext:DateField>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:DateField ID="dfAuthStartEndDate" runat="server" FieldLabel="至" ></ext:DateField>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:DateField ID="dfAuthStopBeginDate" runat="server" FieldLabel="授权截止时间" ></ext:DateField>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:DateField ID="dfAuthStopEndDate" runat="server" FieldLabel="至" ></ext:DateField>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                        <Buttons>
                                            <ext:Button ID="btnSearch" runat="server" Text="查询" Icon="ArrowRefresh" CommandArgument=""
                                                CommandName="" IDMode="Legacy" >
                                                <Listeners>
                                                    <Click Handler="#{gplAuthorization}.reload();" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnAdd" runat="server" Text="<%$ Resources: plAuthorization.btnAdd.Text %>" Icon="Add" CommandArgument=""
                                                CommandName="" IDMode="Legacy" OnClientClick="">
                                                <AjaxEvents>
                                                    <Click Before="#{gplAuthorization}.getSelectionModel().clearSelections();createAuthorization();" OnEvent="SetContractId_Click" 
                                                        Success="ReoladTab();">
                                                    </Click>
                                                </AjaxEvents>
                                            </ext:Button>
                                            <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: plAuthorization.btnDelete.Text %>" Icon="Delete" CommandArgument=""
                                                CommandName="" IDMode="Legacy" OnClientClick="" Disabled="True">
                                                <AjaxEvents>
                                                    <Click Before="var result = confirm(MsgList.btnDelete.confirm)&& #{gplAuthorization}.hasSelection(); if (!result) return false;"
                                                        OnEvent="DeleteAuthorization_Click" Success="#{gplAuthorization}.reload();#{hiddenId}.setValue('');#{hiddenCatagoryId}.setValue('');#{hiddenProductLine}.setValue('');" Failure="Ext.Msg.alert('Message',MsgList.btnDelete.alert)">
                                                    </Click>
                                                </AjaxEvents>
                                            </ext:Button>
                                        </Buttons>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".65">
                                    <ext:Panel runat="server" Frame="True" Header="false" Title="<%$ Resources: plAuthorization.Title %>" Icon="Lorry" Height="200" ID="Panel2" IDMode="Legacy">
                                        <Body>
                                            <ext:FitLayout ID="FitLayout2" runat="server">
                                                <ext:GridPanel ID="gplAuthorization" runat="server" StoreID="AuthorizationStore"
                                                    Border="false" Icon="Lorry" Header="false" AutoExpandColumn="PmaDesc"
                                                    AutoExpandMax="250" AutoExpandMin="150" StripeRows="true" AutoScroll="true" >
                                                    <ColumnModel ID="ColumnModel1" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="ProductLineDesc" DataIndex="ProductLineDesc" Header="<%$ Resources: plAuthorization.gplAuthorization.ProductLineBumId.Header %>"
                                                                Width="150">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="PmaDesc" DataIndex="PmaDesc" Header="<%$ Resources: plAuthorization.gplAuthorization.PmaId.Header %>" Width="100">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="ProductDescription" DataIndex="ProductDescription" Header="<%$ Resources: plAuthorization.gplAuthorization.ProductDescription.Header %>" Width="100">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="HospitalListDesc" DataIndex="HospitalListDesc" Header="<%$ Resources: plAuthorization.gplAuthorization.HospitalListDesc.Header %>" Width="100">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="StartDate" DataIndex="StartDate" Header="授权开始日期" Width="90">
                                                                <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                            </ext:Column>
                                                            <ext:Column ColumnID="EndDate" DataIndex="EndDate" Header="授权终止日期" Width="90">
                                                                <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Type" DataIndex="Type" Header="授权类型" Width="90">
                                                                <Renderer Handler="return getNameFromStoreById(AuthTypeForSearchStore,{Key:'Key',Value:'Value'},value);" />
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Details" Header="<%$ Resources: plAuthorization.gplAuthorization.Details.Header %>" Width="50">
                                                                <Renderer Fn="authDetailsRender" />
                                                            </ext:Column>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true">
                                                            <Listeners>
                                                                <RowSelect Fn="selectedAuthorization" />
                                                            </Listeners>
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <LoadMask ShowMask="true" Msg="<%$ Resources: plAuthorization.gplAuthorization.LoadMask.Msg %>" />
                                                    <Listeners>
                                                        <CellClick Fn="cellClick" />
                                                    </Listeners>
                                                </ext:GridPanel>
                                             </ext:FitLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:Panel>
                </Center>
                <South MarginsSummary="0 5 5 5">
                    <ext:Panel ID="plSearch" runat="server" Title="<%$ Resources: pnlSouth.Title %>" Header="true" Frame="true" Collapsible="true" AutoHeight="true" Icon="Find" BodyStyle="padding:5px;" >
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel1" runat="server" Border="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="120">
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:TextField ID="tbHospitalName" runat="server" FieldLabel="医院名称" ></ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:DateField ID="dfHosStartBeginDate" runat="server" FieldLabel="医院授权开始时间" ></ext:DateField>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:DateField ID="dfHosStartEndDate" runat="server" FieldLabel="至" ></ext:DateField>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:DateField ID="dfHosStopBeginDate" runat="server" FieldLabel="医院授权截止时间" ></ext:DateField>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:DateField ID="dfHosStopEndDate" runat="server" FieldLabel="至" ></ext:DateField>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="95%">
                                                    <ext:Checkbox ID="cbNotHasHosDate" runat="server" FieldLabel="未设置医院授权时间" ></ext:Checkbox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                        <Buttons>
                                            <ext:Button ID="btnSearchHospital" runat="server" Text="查询" Icon="ArrowRefresh" CommandArgument=""
                                                CommandName="" IDMode="Legacy" >
                                                <Listeners>
                                                    <Click Handler="#{gplAuthHospital}.reload();" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnAddHospital" runat="server" Text="<%$ Resources: pnlSouth.gplAuthHospital.btnAddHospital.Text %>" Icon="Add" CommandArgument=""
                                                CommandName="" IDMode="Legacy">
                                                <Listeners>
                                                    <Click Fn="showHospitalSelectorDlg" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnCopyHospital" runat="server" Text="<%$ Resources: pnlSouth.gplAuthHospital.btnCopyHospital.Text %>" Icon="Add" CommandArgument=""
                                                CommandName="" IDMode="Legacy">
                                                <Listeners>
                                                    <Click Fn="showHospitalCopyDlg" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnSelectedDel" runat="server" Text="<%$ Resources: pnlSouth.gplAuthHospital.btnSelectedDel.Text %>" Icon="Delete" CommandArgument=""
                                                CommandName="" IDMode="Legacy">
                                                <Listeners>
                                                    <Click Fn="showHospitalSelectdDelDlg" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="btnDeleteHospital" runat="server" Text="<%$ Resources: pnlSouth.gplAuthHospital.btnDeleteHospital.Text %>" Icon="Delete" CommandArgument=""
                                                CommandName="" IDMode="Legacy">
                                                <Listeners>
                                                    <Click Handler="var result = confirm(MsgList.btnDeleteHospital.confirm); var grid = #{gplAuthHospital};if ( (result) && grid.hasSelection()) { grid.deleteSelected(); grid.save();}" />
                                                </Listeners>
                                            </ext:Button>
                                        </Buttons>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".65">
                                    <ext:Panel ID="pnlSouth" runat="server" Header="false" Frame="True" Title="<%$ Resources: pnlSouth.Title %>" Icon="Basket" Height="200" IDMode="Legacy">
                                        <Listeners>
                                            <Expand Handler="" />
                                        </Listeners>
                                        <Body>
                                            <ext:FitLayout ID="FitLayout1" runat="server">
                                                <ext:GridPanel ID="gplAuthHospital" runat="server" Title="<%$ Resources: pnlSouth.gplAuthHospital.Title %>" Header="false" AutoExpandColumn="HosHospitalName"
                                                    StoreID="Store2" Border="false" Icon="Lorry" StripeRows="true" AutoScroll="true" >
                                                    <ColumnModel ID="ColumnModel2" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="<%$ Resources: pnlSouth.gplAuthHospital.ColumnModel2.HosHospitalName.Header %>">
                                                            </ext:Column>
                                                            <ext:Column DataIndex="HosKeyAccount" Header="<%$ Resources: pnlSouth.gplAuthHospital.ColumnModel2.HosKeyAccount.Header %>">
                                                            </ext:Column>
                                                            <ext:Column DataIndex="HosStartDate" ColumnID="HosStartDate" Header="医院授权开始时间" Width="120" >
                                                                <Renderer Fn="renderData" />
                                                            </ext:Column>
                                                            <ext:Column DataIndex="HosEndDate" ColumnID="HosEndDate" Header="医院授权截止时间" Width="120" >
                                                                <Renderer Fn="renderData" />
                                                            </ext:Column>
                                                            <ext:Column DataIndex="HosGrade" Header="<%$ Resources: pnlSouth.gplAuthHospital.ColumnModel2.HosGrade.Header %>" Width="60" >
                                                            </ext:Column>
                                                            <ext:Column DataIndex="HosProvince" Header="<%$ Resources: pnlSouth.gplAuthHospital.ColumnModel2.HosProvince.Header %>" Width="60" >
                                                            </ext:Column>
                                                            <ext:Column DataIndex="HosCity" Header="<%$ Resources: pnlSouth.gplAuthHospital.ColumnModel2.HosCity.Header %>" Width="60" >
                                                            </ext:Column>
                                                            <ext:Column DataIndex="HosDistrict" Header="<%$ Resources: pnlSouth.gplAuthHospital.ColumnModel2.HosDistrict.Header %>" Width="60" >
                                                            </ext:Column>
                                                            <ext:Column DataIndex="HosRemark" Header="<%$ Resources: pnlSouth.gplAuthHospital.ColumnModel2.HosRemark.Header %>" Width="60" >
                                                            </ext:Column>
                                                            <ext:ImageCommandColumn Width="50" Header="操作">
                                                                <Commands>
                                                                    <ext:ImageCommand CommandName="Edit" Icon="TableEdit">
                                                                        <ToolTip Text="Edit" />
                                                                    </ext:ImageCommand>
                                                                    <ext:ImageCommand CommandName="Save" Icon="Disk">
                                                                        <ToolTip Text="Save" />
                                                                    </ext:ImageCommand>
                                                                    <ext:ImageCommand CommandName="Cancel" Icon="ArrowUndo">
                                                                        <ToolTip Text="Cancel" />
                                                                    </ext:ImageCommand>
                                                                </Commands>
                                                                <PrepareCommand Fn="prepareCommand" />
                                                            </ext:ImageCommandColumn>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel2" runat="server">
                                                            <Listeners>
                                                                <RowSelect Handler="var btndel = #{btnDelete}; if(btndel != null ) btndel.enable();" />
                                                            </Listeners>
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <Listeners>
                                                        <Command Fn="rowCommand"/>
                                                    </Listeners>
                                                    <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="Store2"
                                                            DisplayInfo="true" />
                                                    </BottomBar>
                                                    <LoadMask ShowMask="true" Msg="<%$ Resources: pnlSouth.gplAuthHospital.LoadMask.Msg %>" />
                                                </ext:GridPanel>
                                            </ext:FitLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:Panel>
                </South>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Window ID="authorizationEditorWindow" runat="server" Icon="Group" Title="<%$ Resources: authorizationEditorWindow.Title %>"
        Closable="false" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="350"
        Draggable="false" Width="620" Modal="true" BodyStyle="padding:5px;">
        <Body>
            <ext:TabPanel ID="TabPanel1" runat="server" Frame="true" ActiveTabIndex="0" Plain="true" Border="false" >
                <Tabs>
                    <ext:Tab ID="TabEdit" runat="server" Title="<%$ Resources: authorizationEditorWindow.Title %>" Frame="true" Height="250" ActiveIndex="1" AutoShow="true">
                        <Body>
                            <ext:FitLayout ID="FitLayout3" runat="server">
                                <ext:Panel ID="Panel4" runat="server" Border="false" Header="false" Frame="true" AutoHeight="true" >
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".5">
                                                <ext:Panel ID="Panel5" runat="server" Border="false" BodyStyle="padding:5px;">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="90">
                                                            <ext:Anchor Horizontal="100%">
                                                                <ext:Hidden ID="hiddenId" runat="server">
                                                                </ext:Hidden>
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="100%">
                                                                <ext:Hidden ID="hiddenProductLine" runat="server">
                                                                </ext:Hidden>
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="100%">
                                                                <ext:Hidden ID="hiddenCatagoryId" runat="server">
                                                                </ext:Hidden>
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="100%">
                                                                <ext:TextField ID="txtProductLine" runat="server" FieldLabel="<%$ Resources: authorizationEditorWindow.txtProductLine.FieldLabel %>" ReadOnly="true" />
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="100%">
                                                                <ext:DateField ID="dfAuthStartDate" runat="server" FieldLabel="授权开始时间"></ext:DateField>
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="100%">
                                                                <ext:TextField ID="txtProductDesc" runat="server" FieldLabel="<%$ Resources: authorizationEditorWindow.txtProductDesc.FieldLabel %>" />
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="100%">
                                                                <ext:TextArea ID="txtNote" runat="server" FieldLabel="<%$ Resources: authorizationEditorWindow.txtNote.FieldLabel %>" Height="60" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".5">
                                                <ext:Panel ID="Panel6" runat="server" Border="false" BodyStyle="padding:5px;">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="90">
                                                            <ext:Anchor Horizontal="100%">
                                                                <ext:TriggerField ID="txtCatagoryName" runat="server" FieldLabel="<%$ Resources: authorizationEditorWindow.txtCatagoryName.FieldLabel %>" ReadOnly="true">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Search" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Fn="showPartsSelectorDlg" />
                                                                    </Listeners>
                                                                </ext:TriggerField>
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="100%">
                                                                <ext:DateField ID="dfAuthStopDate" runat="server" FieldLabel="授权结束时间"></ext:DateField>
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="100%">
                                                                <ext:ComboBox ID="cbAuthTypeForEdit" runat="server" FieldLabel="授权类型" Mode="Local" Resizable="true"
                                                                    StoreID="AuthTypeForEditStore" DisplayField="Value" ValueField="Key" >
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor Horizontal="100%">
                                                                <ext:TextField ID="txtAuthTypeForEdit" runat="server" FieldLabel="授权类型" ReadOnly="true" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Tab>
                    <ext:Tab ID="TabAttachment" runat="server" Frame="true" Title="附件" Icon="BrickLink" Height="250" >
                        <AutoLoad Mode="IFrame" ShowMask="true" Url="AttachmentList.aspx" MaskMsg="加载中...">
                        </AutoLoad>
                        <Listeners>
                            <Activate Handler="this.reload();" />
                        </Listeners>
                    </ext:Tab>
                </Tabs>
                <Buttons>
                    <ext:Button ID="btnSaveButton" runat="server" Text="<%$ Resources: authorizationEditorWindow.btnSaveButton.FieldLabel %>" Icon="Disk">
                        <Listeners>
                            <Click Handler="saveAuthorization();" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="btnCancelButton" runat="server" Text="<%$ Resources: authorizationEditorWindow.btnCancelButton.FieldLabel %>" Icon="Cancel">
                        <Listeners>
                            <Click Handler="cancelWindow();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:TabPanel>
        </Body>
    </ext:Window>
    
    <uc1:PartsSelectorDialog ID="PartsSelectorDialog1" runat="server" />
    <uc1:HospitalSelectorDialog ID="HospitalSelectorDialog1" runat="server" />
    <uc1:HospitalSelectdDelDialog ID="HospitalSelectdDelDialog1" runat="server" />
    <uc1:AuthSelectorDialog ID="AuthSelectorDialog1" runat="server" />
    <ext:Hidden ID="hiddenContractId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenDealer" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidCacheParts" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidCacheProductLines" runat="server">
    </ext:Hidden>
    </form>
    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
   </script>
</body>
</html>
