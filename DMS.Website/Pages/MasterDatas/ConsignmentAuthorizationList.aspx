<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConsignmentAuthorizationList.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.ConsignmentAuthorizationList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
    
    
      
         function RefreshDetailWindow() {
            Ext.getCmp('<%=this.PagingToolBar1.ClientID%>').changePage(1);
            
        }
        function Dtred()
        {
         Ext.getCmp('<%=this.cbChoiceDelare.ClientID%>').store.reload();
        
        }
        function UpdateBtnclick()
        {
         Coolite.AjaxMethods.Update({
         success: function() {}
         ,
          failure: function(err) {
                         Ext.Msg.alert('Error', err);
                     }
         })
        };
        function stopBtnclick()
        {
          Ext.Msg.confirm('Warning', '确定终止?', function(e){
          if(e=='yes')
          {
           Coolite.AjaxMethods.Stop({
             success: function() {
               RefreshDetailWindow() ;
                 
                   Ext.getCmp('<%=this.ContractsEditorWindow.ClientID%>').hide();
             }
         ,
          failure: function(err) {
                         Ext.Msg.alert('Error', err);
                     }
           
           })
          }
          })
        };
        function recovery()
        {
          Ext.Msg.confirm('Warning', '确定恢复?', function(e){
          if(e=='yes')
          {
           Coolite.AjaxMethods.recovery({
             success: function() {
               RefreshDetailWindow() ;
                 
                   Ext.getCmp('<%=this.ContractsEditorWindow.ClientID%>').hide();
             }
         ,
          failure: function(err) {
                         Ext.Msg.alert('Error', err);
                     }
           
           })
          }
          })
        }
        function Sumbit()
        {
        
         var isForm1Valid = Ext.getCmp('<%=this.FormPanel2.ClientID%>').getForm().isValid();
        var rtnVal=Ext.getCmp('<%=this.hidrtnVal.ClientID%>');
        var rtnMesg=Ext.getCmp('<%=this.hidrtnMesg.ClientID%>');
        if(!isForm1Valid)
        {
        Ext.Msg.alert('Error', "请填写所有信息!");
        return false;
        }
          Ext.Msg.confirm('Warning', '确定提交?', function(e)
          {
          if(e=='yes')
          {
        Coolite.AjaxMethods.Sumbit({
        success: function() {
        
        if(rtnVal.getValue()=="Susses")
        {
                    RefreshDetailWindow() ;
                 
                   Ext.getCmp('<%=this.ContractsEditorWindow.ClientID%>').hide();
               
                    }
                    else if(rtnVal.getValue()=="Error")
                    {
                     Ext.Msg.alert('Error', rtnMesg.getValue());
                    }
                     }
                     ,
                     failure: function(err) {
                         Ext.Msg.alert('Error', err);
                     }
               })
              }
        }
        )
        }
      
        function Isstatus(obj)
        {
        if(obj)
        {
        return "发布";
        
        }
        else{
        return "取消";
        }
        }
        
        
             function WindowShow(id) {
            Coolite.AjaxMethods.Show(id,
                 {
                     success: function() {
            Dtred();
                     },
                     failure: function(err) {
                         Ext.Msg.alert('Error', err);
                     }
                 }
            );
        };
        ///模糊查询
        function SelectValue(e) {
      
            var filterField = 'Name';  //需进行模糊查询的字段
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var value = e.query;
                if (value != null && value != '') {
                    combo.store.filterBy(function(record, id) {
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
        
        function SelectValueDealer(e) {
      
            var filterField = 'ChineseShortName';  //需进行模糊查询的字段
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var value = e.query;
                if (value != null && value != '') {
                    combo.store.filterBy(function(record, id) {
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
        function ProductChang()
        {
       
        var hidProducdId=Ext.getCmp('<%=this.hidProducdId.ClientID%>');
        var cbProductid=Ext.getCmp('<%=this.cbChoiceProcductline.ClientID%>');
     
        if(hidProducdId.getValue()!=cbProductid.getValue())
        {
          
         Coolite.AjaxMethods.ProductLineChan({
         success:function(){
         hidProducdId.setValue(cbProductid.getValue());
         },
         failure: function(err) {
                         Ext.Msg.alert('Error', err);
                     }
         })
        }
        }
        function DealreChang ()
        {
       
        var hidDealare= Ext.getCmp('<%=this.hidDelare.ClientID%>');
        var cbDelare=Ext.getCmp('<%=this.cbChoiceDelare.ClientID%>');
       if(hidDealare.getValue()!=cbDelare.getValue())
       {
            Coolite.AjaxMethods.DelareChang(
                 {
                     success: function() {
                          hidDealare.setValue(cbDelare.getValue());
                     },
                     failure: function(err) {
                         Ext.Msg.alert('Error', err);
                     }
                 }
            );
            }
        };
        
        var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            
            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

              if (t.className == 'imgEdit' && columnId == 'Authorizations') 
             {      
                //var href_editorPage = "DealerContractEditor.aspx?ct="+record.data["Id"]+"&dr="+record.data["DmaId"];
                //window.location.href = href_editorPage;
                //window.parent.loadExample('/Pages/MasterDatas/DealerContractEditor.aspx?ct=' + record.data["Id"]+"&dr="+record.data["DmaId"],  'subMenu' + record.data["Id"], '授权列表');
                top.createTab({id: 'subMenu'+record.data["Id"],title: '授权列表',url: 'Pages/MasterDatas/DealerContractEditor.aspx?ct=' + record.data["Id"]+"&dr="+record.data["DmaId"]});


             }   //the ajax event allowed
             else if(t.className == 'imgEdit' && columnId == 'Details')
             {
               openContractsDetails(record, t); 
             }
        }
        

        
        
    var openContractsDetails = function (dataRecord,animTrg) {
      
        var window = <%= ContractsEditorWindow.ClientID %>;
        var isNew = Ext.getCmp('<%= this.hidIsNew.ClientID %>');
        
        
        if(dataRecord != null)
        {
             isNew.setValue('0');
          //window.setTitle(String.format('Details: {0}',record.data['HosHospitalShortName']));
              
              
        }
        else 
        {
                
        
        }
        window.show(animTrg);
    }
    

    var cancelWindow =function()
    {
         <%= ContractsEditorWindow.ClientID %>.hide(null);
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
                        <ext:RecordField Name="ChineseShortName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="ChoiceProceDuctLine" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Name" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="ChoiceConsignmenStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Name" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="StatusSotre" runat="server" UseIdConfirmation="true" AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Name" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true">
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
        <ext:Store ID="ConsignmentMasterStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="CMID">
                    <Fields>
                        <ext:RecordField Name="CMID" />
                        <ext:RecordField Name="Name" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="CMID" Direction="ASC" />
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
                        <ext:RecordField Name="ConsignmentName" />
                        <ext:RecordField Name="StartDate" Type="Date" />
                        <ext:RecordField Name="EndDate" Type="Date" />
                        <ext:RecordField Name="IsActive" />
                        <ext:RecordField Name="ChineseName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="StartDate" Direction="DESC" />
        </ext:JsonStore>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="经销商短期寄售规则授权列表" Frame="true"
                            AutoHeight="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择" Width="220" Editable="true"
                                                            TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                            ListWidth="300" Resizable="true" FieldLabel="经销商" Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbConsignmentName" runat="server" EmptyText="请选择" Width="220" Editable="true"
                                                            TypeAhead="true" StoreID="ConsignmentMasterStore" ValueField="CMID" DisplayField="Name"
                                                            ListWidth="300" Resizable="true" FieldLabel="寄售规则" Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
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
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProductline" runat="server" EmptyText="请选择" Width="220" Editable="true"
                                                            TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName"
                                                            ListWidth="300" Resizable="true" FieldLabel="产品线" Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
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
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbStatus"  runat="server" EmptyText="请选择"
                                                            Width="220" Editable="true" TypeAhead="true"
                                                            ListWidth="300" Resizable="true" FieldLabel="状态" Mode="Local">
                                                          <Items>
                                                          <ext:ListItem Value="1" Text="有效" />
                                                          <ext:ListItem Value="0" Text="无效" />
                                                          </Items>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
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
                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="添加" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="WindowShow('00000000-0000-0000-0000-000000000000')" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Title="查询结果" Icon="HouseKey">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Header="false" StoreID="Store1" Border="false"
                                        Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ConsignmentName" DataIndex="ConsignmentName" Header="短期寄售名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="经销商" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="StartDate" DataIndex="StartDate" Header="开始时间">
                                                    <Renderer Format="Date" FormatArgs="'Y/m/d'" />
                                                </ext:Column>
                                                <ext:Column ColumnID="EndDate" DataIndex="EndDate" Header="终止时间">
                                                    <Renderer Format="Date" FormatArgs="'Y/m/d'" />
                                                </ext:Column>
                                                <ext:CheckColumn ColumnID="IsActive" DataIndex="IsActive" Header="状态">
                                                </ext:CheckColumn>
                                                <ext:CommandColumn ColumnID="Id" Align="Center" Width="50" Header="明细">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="查看明细" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="50" StoreID="Store1"
                                                DisplayInfo="true" EmptyMsg="稍等" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="稍等" />
                                           <Listeners>
                                        <Command Handler="Coolite.AjaxMethods.Show(record.data.Id,{success:function(){Dtred();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                        <CellClick />
                                    </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Window ID="ContractsEditorWindow" runat="server" Icon="Group" Title="经销商短期寄售规则申请详情"
            Closable="true" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="250"
            Draggable="false" Width="400" Modal="true" BodyStyle="padding:5px;">
            <Body>
             <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                <Body>
                <ext:FormLayout ID="FormLayout4" runat="server" LabelPad="20">
                   
                    <ext:Anchor Horizontal="100%">
                        <ext:ComboBox ID="cbChoiceDelare" runat="server" EmptyText="请选择" Width="220" Editable="true"
                            AllowBlank="false" TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                            ListWidth="300" Resizable="true" FieldLabel="经销商名称" Mode="Local">
                            <Triggers>
                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                            </Triggers>
                            <Listeners>
                                <TriggerClick Handler="this.clearValue();" />
                                <Select Handler="DealreChang();" />
                                <BeforeQuery Fn="SelectValueDealer" />
                            </Listeners>
                        </ext:ComboBox>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:ComboBox ID="cbChoiceProcductline" runat="server" EmptyText="请选择" Width="220"
                            AllowBlank="false" Editable="true" TypeAhead="true" StoreID="ChoiceProceDuctLine"
                            ValueField="Id" DisplayField="Name" ListWidth="300" Resizable="true" FieldLabel="产品线名称"
                            Mode="Local">
                            <Triggers>
                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                            </Triggers>
                            <Listeners>
                                <TriggerClick Handler="this.clearValue();" />
                                <Select Handler="ProductChang();" />
                                <BeforeQuery Fn="SelectValue" />
                            </Listeners>
                        </ext:ComboBox>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:ComboBox ID="cbChoiceConsignmentName" runat="server" EmptyText="请选择" Width="220"
                            AllowBlank="false" Editable="true" TypeAhead="true" StoreID="ChoiceConsignmenStore"
                            ValueField="Id" DisplayField="Name" ListWidth="300" Resizable="true" FieldLabel="短期寄售名称"
                            Mode="Local">
                            <Triggers>
                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                            </Triggers>
                            <Listeners>
                                <TriggerClick Handler="this.clearValue();" />
                            </Listeners>
                        </ext:ComboBox>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:DateField ID="dtStartDate" runat="server" Vtype="daterange" FieldLabel="开始时间"
                            AllowBlank="false">
                            
                        </ext:DateField>
                    </ext:Anchor>
                    <ext:Anchor Horizontal="100%">
                        <ext:DateField ID="dtEndDate" runat="server" Vtype="daterange" FieldLabel="结束时间"
                            AllowBlank="false">
                          
                        </ext:DateField>
                    </ext:Anchor>
                       <ext:Anchor Horizontal="100%">
                       <ext:Checkbox runat="server" ID="cbxstatus" ReadOnly="true" Checked="true" FieldLabel="是否有效"></ext:Checkbox>
                       </ext:Anchor>
                </ext:FormLayout>
                </Body>
               </ext:FormPanel>
            </Body>
            <Buttons>
                <ext:Button ID="SaveButton" runat="server" Text="提交" Icon="Disk">
                    <Listeners>
                        <Click Handler="Sumbit();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="UpdataButton" runat="server" Text="修改授权" Icon="Disk">
                    <Listeners>
                        <Click Handler="UpdateBtnclick();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="StopButton" runat="server" Text="终止" Icon="Cancel">
                    <Listeners>
                        <Click Handler="stopBtnclick();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="Btnrecovery" runat="server" Text="恢复" Icon="Disk">
                    <Listeners>
                        <Click Handler="recovery();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="" />
            </Listeners>
        </ext:Window>
        <ext:Hidden ID="dealerData" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsNew" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidInstanceId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDelare" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidProducdId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidrtnVal" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidrtnMesg" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidAuthorizationStatus" runat="server">
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
