<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerContractList.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.DealerContractList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>DealerContractList</title>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
        var MsgList = {
			btnDelete:{
				confirm:"<%=GetLocalResourceObject("plSearch.btnDelete.Confirm").ToString()%>",
				FailureTitle:"<%=GetLocalResourceObject("plSearch.btnDelete.Alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("plSearch.btnDelete.Alert.Body").ToString()%>"
			},
			SaveButton:{
				BeforeTitle:"<%=GetLocalResourceObject("ContractsEditorWindow.SaveButton.Alert.Title").ToString()%>",
				BeforeMsg:"<%=GetLocalResourceObject("ContractsEditorWindow.SaveButton.Alert.Body").ToString()%>"
			}
        }

        var contractAuthorizationsRender = function() {
            return '<img class="imgEdit" ext:qtip="<%=GetLocalResourceObject("contractAuthorizationsRender.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/vcard_edit.png" />';
            
            //return '<a href="DealerContractEditor.aspx">Details</a>';
            
        }   
        
        var contractDetailsRender = function() {
            return '<img class="imgEdit" ext:qtip="<%=GetLocalResourceObject("contractDetailsRender.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/note_edit.png" />';

        }
        
        
        
        var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            
            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

              if (t.className == 'imgEdit' && columnId == 'Authorizations') 
             {      
                //var href_editorPage = "DealerContractEditor.aspx?ct="+record.data["Id"]+"&dr="+record.data["DmaId"];
                //window.location.href = href_editorPage;
                
                //window.parent.loadExample('/Pages/MasterDatas/DealerContractEditor.aspx?ct=' + record.data["Id"]+"&dr="+record.data["DmaId"],  'subMenu' + record.data["Id"], '授权列表');
                top.createTab({id: 'subMenu'+ record.data["Id"],title: '授权列表',url: 'Pages/MasterDatas/DealerContractEditor.aspx?ct='+ record.data["Id"]+"&dr="+record.data["DmaId"]});
              }   //the ajax event allowed
             else if(t.className == 'imgEdit' && columnId == 'Details')
             {
               openContractsDetails(record, t);
             }
        }
        
        
        var renderDealer = function(value) {
           var dealerName = "";
           var json_data =<%= dealerData.ClientID %>.getValue() ;
           
           dealerName= getValueFromArray(json_data,value);
           return dealerName;
        }
        
        
    var openContractsDetails = function (dataRecord,animTrg) {
      
        var window = <%= ContractsEditorWindow.ClientID %>;
        var isNew = Ext.getCmp('<%= this.hidIsNew.ClientID %>');
        
        
        if(dataRecord != null)
        {
             isNew.setValue('0');
          //window.setTitle(String.format('Details: {0}',record.data['HosHospitalShortName']));
              
              <%= txtDealer.ClientID %>.setDisabled(true);
              
              <%= txtContractId.ClientID %>.setValue(dataRecord.data['Id']);
              <%= txtDealer.ClientID %>.setValue(dataRecord.data['DmaId']);
              <%= txtContractNumber.ClientID %>.setValue(dataRecord.data['ContractNumber']);
              <%= txtContractYears.ClientID %>.setValue(dataRecord.data['ContractYears']);
                         
             var dt1 = new Date(dataRecord.data['StartDate']);
              <%= dtStartDate.ClientID %>.setValue(dt1);
              
             var dt2 = new Date(dataRecord.data['StopDate']);              
              <%= dtStopDate.ClientID %>.setValue(dt2); 
        }
        else 
        {
                isNew.setValue('1');
              <%= txtDealer.ClientID %>.setDisabled(false);
              
              <%= txtContractId.ClientID %>.setValue("");
               <%= txtDealer.ClientID %>.setValue("");
              <%= txtContractNumber.ClientID %>.setValue("");
               <%= txtContractYears.ClientID %>.setValue("");
              
               var dtstart =new Date(); 
                     
              <%= dtStartDate.ClientID %>.setValue(dtstart);
              var years = dtstart.getYear()+1;  
              dtstart.setYear(years);
              <%= dtStopDate.ClientID %>.setValue(dtstart);
        
        }
        window.show(animTrg);
    }
    
   function afterSaveContractsDetails() {
        <%= ContractsEditorWindow.ClientID %>.hide(null);
        Ext.Msg.alert("<%=GetLocalResourceObject("afterSaveContractsDetails.Alert.Title").ToString()%>", "<%=GetLocalResourceObject("afterSaveContractsDetails.Alert.Body").ToString()%>");
        <%=GridPanel1.ClientID%>.reload();
   }
   
    var cancelWindow =function()
    {
         <%= ContractsEditorWindow.ClientID %>.hide(null);
    }
    
    function ComboxSelValue(e) {
        var combo = e.combo;
        combo.collapse();
        if (!e.forceAll) {
            var input = e.query;
            if (input != null && input != '') {
                // 检索的正则
                var regExp = new RegExp(".*" + input + ".*");
                // 执行检索
                combo.store.filterBy(function(record, id) {
                    // 得到每个record的项目名称值
                    var text = record.get(combo.displayField);
                    return regExp.test(text);
                });
            } else {
                    combo.store.clearFilter();
            }
            combo.expand();
            return false;
        }
    } 

    </script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Debug">
        </ext:ScriptManager>
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_DealerList"
            AutoLoad="true">
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
        <ext:JsonStore ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="Store1_RefershData"
            AutoLoad="false">
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={15}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="StartDate" Type="Date" />
                        <ext:RecordField Name="ApprovedBy" />
                        <ext:RecordField Name="StopDate" Type="Date" />
                        <ext:RecordField Name="ContractNumber" />
                        <ext:RecordField Name="ContractYears" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="ApprovalId" />
                        <ext:RecordField Name="CreateDate" Type="Date" />
                        <ext:RecordField Name="CreateUser" />
                        <ext:RecordField Name="BuName" />
                        <ext:RecordField Name="SubBuName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="CreateDate" Direction="DESC" />
        </ext:JsonStore>
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
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: plSearch.FormLayout1.cbDealer.EmptyText%>"
                                                            Width="220" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                                            DisplayField="ChineseShortName" ListWidth="300" Resizable="true" FieldLabel="<%$ Resources: plSearch.FormLayout1.cbDealer.FieldLabel %>"
                                                            Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.FormLayout1.cbDealer.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <BeforeQuery Fn="ComboxSelValue" />
                                                                <TriggerClick Handler="this.clearValue();" />
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
                                                        <ext:TextField ID="txtSearchContractNumber" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout2.txtSearchContractNumber.FieldLabel %>"
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
                                                        <ext:TextField ID="txtSearchContractYears" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout3.txtSearchContractYears.FieldLabel %>"
                                                            Width="150" />
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
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: plSearch.btnInsert.Text%>"
                                    Icon="Add" CommandArgument="" CommandName="" IDMode="Legacy" OnClientClick="">
                                    <AjaxEvents>
                                        <Click Before="openContractsDetails(null,null);" OnEvent="SetContractId_Click">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: plSearch.btnDelete.Text%>"
                                    Icon="Delete" CommandArgument="" CommandName="" IDMode="Legacy" OnClientClick="">
                                    <AjaxEvents>
                                        <Click Before="var result = confirm(MsgList.btnDelete.confirm)&& #{GridPanel1}.hasSelection(); if (!result) return false;"
                                            OnEvent="DeleteContracts_Click" Success="#{GridPanel1}.reload();" Failure="Ext.Msg.alert(MsgList.btnDelete.FailureTitle,MsgList.btnDelete.FailureMsg)">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Title="<%$ Resources:ctl46.Title%>"
                            Icon="HouseKey">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Header="false" StoreID="Store1" Border="false"
                                        Icon="Lorry" AutoExpandColumn="DmaId" AutoExpandMax="250" AutoExpandMin="150"
                                        StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DmaId" DataIndex="DmaId" Header="<%$ Resources:ctl46.GridPanel1.DmaId.Header%>">
                                                    <Renderer Fn="renderDealer" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ContractNumber" DataIndex="ContractNumber" Header="<%$ Resources:ctl46.GridPanel1.ContractNumber.Header%>"
                                                    Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ContractYears" DataIndex="ContractYears" Header="<%$ Resources:ctl46.GridPanel1.ContractYears.Header%>">
                                                </ext:Column>
                                                   <ext:Column ColumnID="BuName" DataIndex="BuName" Header="产品线">
                                                </ext:Column>
                                                   <ext:Column ColumnID="SubBuName" DataIndex="SubBuName" Header="合同分类">
                                                </ext:Column>
                                                <ext:Column ColumnID="StartDate" DataIndex="StartDate" Header="<%$ Resources:ctl46.GridPanel1.StartDate.Header%>">
                                                       <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="StopDate" DataIndex="StopDate" Header="<%$ Resources:ctl46.GridPanel1.StopDate.Header%>">
                                                     <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="<%$ Resources:ctl46.GridPanel1.CreateDate.Header%>">
                                                   <Renderer Fn="Ext.util.Format.dateRenderer('m/d/Y h:i')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Details" Header="<%$ Resources:ctl46.GridPanel1.Details.Header%>"
                                                    Width="150">
                                                    <Renderer Fn="contractDetailsRender" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Authorizations" Header="<%$ Resources:ctl46.GridPanel1.Authorizations.Header%>"
                                                    Width="150">
                                                    <Renderer Fn="contractAuthorizationsRender" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources:ctl46.GridPanel1.PagingToolBar1.EmptyMsg%>" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="<%$ Resources:ctl46.GridPanel1.LoadMask.Msg%>" />
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
        <ext:Window ID="ContractsEditorWindow" runat="server" Icon="Group" Title="<%$ Resources:ContractsEditorWindow.Title%>"
            Closable="false" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="250"
            Draggable="false" Width="400" Modal="true" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout4" runat="server" LabelPad="20">
                    <ext:Anchor Horizontal="100%">
                        <ext:TextField ID="txtContractId" runat="server" FieldLabel="<%$ Resources:ContractsEditorWindow.FormLayout4.txtContractId.FieldLabel%>"
                            Hidden="true" Disabled="true" />
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:ComboBox ID="txtDealer" runat="server" EmptyText="<%$ Resources:ContractsEditorWindow.FormLayout4.txtDealer.EmptyText%>"
                            Editable="true" TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName"
                            ListWidth="300" Resizable="true" FieldLabel="<%$ Resources:ContractsEditorWindow.FormLayout4.txtDealer.FieldLabel%>"
                            Mode="Local">
                        </ext:ComboBox>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:TextField ID="txtContractNumber" runat="server" FieldLabel="<%$ Resources:ContractsEditorWindow.FormLayout4.txtContractNumber.FieldLabel%>" />
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:NumberField ID="txtContractYears" runat="server" FieldLabel="<%$ Resources:ContractsEditorWindow.FormLayout4.txtContractYears.FieldLabel%>"
                            AllowNegative="false" AllowDecimals="false" />
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:DateField ID="dtStartDate" runat="server" Vtype="daterange" FieldLabel="<%$ Resources:ContractsEditorWindow.FormLayout4.dtStartDate.FieldLabel%>">
                            <Listeners>
                                <Render Handler="this.endDateField = '#{dtStopDate}'" />
                            </Listeners>
                        </ext:DateField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:DateField ID="dtStopDate" runat="server" Vtype="daterange" FieldLabel="<%$ Resources:ContractsEditorWindow.FormLayout4.dtStopDate.FieldLabel%>">
                            <Listeners>
                                <Render Handler="this.startDateField = '#{dtStartDate}'" />
                            </Listeners>
                        </ext:DateField>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Buttons>
                <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources:ContractsEditorWindow.SaveButton.Text%>"
                    Icon="Disk">
                    <AjaxEvents>
                        <Click OnEvent="SaveContracts_Click" Before="if(#{txtDealer}.getValue()==''){Ext.Msg.alert(MsgList.SaveButton.BeforeTitle, MsgList.SaveButton.BeforeMsg);return false;}"
                            Success="afterSaveContractsDetails();">
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources:ContractsEditorWindow.CancelButton.Text%>"
                    Icon="Cancel">
                    <Listeners>
                        <Click Handler="cancelWindow();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Hidden ID="dealerData" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsNew" runat="server">
        </ext:Hidden>
    </div>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
