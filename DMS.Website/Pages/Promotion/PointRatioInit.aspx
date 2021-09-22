<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PointRatioInit.aspx.cs"
    Inherits="DMS.Website.Pages.Promotion.PointRatioInit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        .yellow-row
        {
            background: #FFD700;
        }
    </style>
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
           function getIsErrRowClassDealer(record, index) {
         
        if (record.data.ErrMsg!='')
        { 
      
           return 'yellow-row';
        }
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
         function SelectValueDealer(e) {
      
            var filterField = 'ChineseName';  //需进行模糊查询的字段
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
      
            var filterField = 'ChineseName';  //需进行模糊查询的字段
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
        
        
        
        var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            
            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

              if (t.className == 'imgEdit' && columnId == 'Authorizations') 
             {      
                //var href_editorPage = "DealerContractEditor.aspx?ct="+record.data["Id"]+"&dr="+record.data["DmaId"];
                //window.location.href = href_editorPage;
                
                  //window.parent.loadExample('/Pages/MasterDatas/DealerContractEditor.aspx?ct=' + record.data["Id"]+"&dr="+record.data["DmaId"],  'subMenu' + record.data["Id"], '授权列表');
                  top.createTab({id: 'subMenu' + record.data["Id"],title: '授权列表',url: 'Pages/MasterDatas/DealerContractEditor.aspx?ct=' + record.data["Id"]+"&dr="+record.data["DmaId"]});
             }   //the ajax event allowed
             else if(t.className == 'imgEdit' && columnId == 'Details')
             {
               openContractsDetails(record, t); 
             }
        }
        

        function CbRatioproductlineChange(){
          var hidProducdId=Ext.getCmp('<%= this.hidProducdId.ClientID %>');
          var CbRatioproductline=Ext.getCmp('<%= this.CbRatioproductline.ClientID %>');
          if(hidProducdId.getValue()!=CbRatioproductline.getValue())
          {
           Coolite.AjaxMethods.CbRatioproductlineChange({
           success:function(){
           hidProducdId.setValue(CbRatioproductline.getValue());
           },
           failure:function(err)
           {
           Ext.Msg.alert('Error', err);
           }
           
           })
          }
        }
        function wd7PointRatioUploadShow()
        {
           Coolite.AjaxMethods.wd7PointRatioUploadShow({
            success:function(){
            
            },
             failure:function(err)
           {
           Ext.Msg.alert('Error', err);
           }
           })
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
                        <ext:RecordField Name="ChineseName" />
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
        <ext:Store ID="PointRatiostore" runat="server" AutoLoad="false" OnRefreshData="PointRatiostore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="ID">
                    <Fields>
                        <ext:RecordField Name="ID" />
                        <ext:RecordField Name="BU" />
                        <ext:RecordField Name="PlatFormId" />
                        <ext:RecordField Name="Ratio" />
                        <ext:RecordField Name="CreateBy" />
                        <ext:RecordField Name="CreateTime" />
                        <ext:RecordField Name="ModifyBy" />
                        <ext:RecordField Name="ModifyDate" />
                        <ext:RecordField Name="Remark1" />
                         <ext:RecordField Name="ProductLineName" />
                         <ext:RecordField Name="ChineseName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="PointRatioDealerStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="统一加价率维护" Frame="true"
                            AutoHeight="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择" Width="220" Editable="true"
                                                            TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName"
                                                            ListWidth="300" Resizable="true" FieldLabel="经销商" Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                                <BeforeQuery Fn="SelectValueDealer" />
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
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel4" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:Panel runat="server">
                                                            <Buttons>
                                                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                                    <Listeners>
                                                                        <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                                                    </Listeners>
                                                                </ext:Button>
                                                                <ext:Button ID="btnInsert" runat="server" Text="添加" Icon="Add" IDMode="Legacy">
                                                                    <Listeners>
                                                                        <Click Handler="WindowShow('-1')" />
                                                                    </Listeners>
                                                                </ext:Button>
                                                                <ext:Button ID="btnImport" runat="server" Text="导入" Icon="PageExcel" IDMode="Legacy">
                                                                    <Listeners>
                                                                        <Click Handler="wd7PointRatioUploadShow();" />
                                                                    </Listeners>
                                                                </ext:Button>
                                                            </Buttons>
                                                        </ext:Panel>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Title="查询结果" Icon="HouseKey">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Header="false" StoreID="PointRatiostore"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="BU">
                                                  <%--  <Renderer Handler="return getNameFromStoreById(ProductLineStore,{Key:'Id',Value:'AttributeName'},value);" />--%>
                                                </ext:Column>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="经销商" Width="150">
                                                   <%-- <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />--%>
                                                </ext:Column>
                                                <ext:Column ColumnID="Ratio" DataIndex="Ratio" Header="加价率">
                                                </ext:Column>
                                                <ext:CommandColumn ColumnID="ID" Align="Center" Width="50" Header="编辑">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="查看明细" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="50" StoreID="PointRatiostore"
                                                DisplayInfo="true" EmptyMsg="稍等" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="稍等" />
                                        <Listeners>
                                            <Command Handler="if (command == 'Edit'){Coolite.AjaxMethods.Show(record.data.ID,{success:function(){Dtred();},failure:function(err){Ext.Msg.alert('Error', err);}});}
                                                               else if(command == 'Delete'){
                                                                Ext.Msg.confirm('Warning', '确定删除?', function(e){
                                                   if(e=='yes')
                                                          {
                                              Coolite.AjaxMethods.Delete(record.data.ID,{
                                     success: function() {},
                                           failure: function(err) {
                                             Ext.Msg.alert('Error', err); } })}}) }" />
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
        <ext:Window ID="ContractsEditorWindow" runat="server" Icon="Group" Title="新建" Closable="true"
            AutoShow="false" ShowOnLoad="false" Resizable="false" Height="150" Draggable="false"
            Width="400" Modal="true" BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                    <Body>
                        <ext:FormLayout ID="FormLayout4" runat="server" LabelPad="20">
                            <ext:Anchor Horizontal="100%">
                                <ext:ComboBox ID="CbRatioproductline" runat="server" EmptyText="请选择" Width="220"
                                    Editable="true" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName"
                                    ListWidth="300" Resizable="true" FieldLabel="产品线" Mode="Local" AllowBlank="false">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                        <Select Handler="CbRatioproductlineChange();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor Horizontal="100%">
                                <ext:ComboBox ID="cbChoiceDelare" runat="server" EmptyText="请选择" Width="220" Editable="true"
                                    AllowBlank="false" TypeAhead="true" StoreID="PointRatioDealerStore" ValueField="Id"
                                    DisplayField="ChineseName" ListWidth="300" Resizable="true" FieldLabel="经销商名称"
                                    Mode="Local">
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
                                <ext:NumberField AllowBlank="false" ID="txtRatio" runat="server" FieldLabel="加价率"
                                    Width="220">
                                </ext:NumberField>
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
                <ext:Button ID="CncelButton" runat="server" Text="取消" Icon="Disk">
                    <Listeners>
                        <Click Handler="#{ContractsEditorWindow}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="" />
            </Listeners>
        </ext:Window>
        <ext:Store ID="UpLoadPointRatioStore" runat="server" OnRefreshData="UpLoadPointRatioStore_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="SAPCode" />
                        <ext:RecordField Name="BU" />
                        <ext:RecordField Name="ErrMsg" />
                        <ext:RecordField Name="Ratio" />
                        <ext:RecordField Name="ProductLineName" />
                        <ext:RecordField Name="DMA_ChineseName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Window ID="wd7PointRatioUpload" runat="server" Icon="Group" Title="统一加价率导入"
            Hidden="true" Resizable="false" Header="false" Width="700" AutoHeight="true"
            AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout3" runat="server">
                    <ext:Anchor>
                        <ext:FormPanel ID="BasicFormDealer" runat="server" Frame="true" Header="false" AutoHeight="true"
                            MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                            <Defaults>
                                <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                            </Defaults>
                            <Body>
                                <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="50">
                                    <ext:Anchor>
                                        <ext:FileUploadField ID="FileUploadFieldPointRatio" runat="server" EmptyText="选择文件"
                                            FieldLabel="文件" Width="500" ButtonText="" Icon="ImageAdd">
                                        </ext:FileUploadField>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                            <Listeners>
                                <ClientValidation Handler="#{SaveButtonDealer}.setDisabled(!valid);" />
                            </Listeners>
                            <Buttons>
                                <ext:Button ID="SaveButtonDealer" runat="server" Text="上传">
                                    <AjaxEvents>
                                        <Click OnEvent="UploadDealerClick" Before="if(!#{BasicFormDealer}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传指定经销商...', '指定经销商上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{PagingToolBarDealer}.changePage(1);#{FileUploadFieldDealer}.setValue(''); Ext.Msg.show({ 
                                        title   : '成功', 
                                        msg     : '上传成功', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        buttons : Ext.Msg.OK 
                                    })">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="ResetButton" runat="server" Text="清除">
                                    <Listeners>
                                        <Click Handler="#{BasicFormDealer}.getForm().reset();#{SaveButtonDealer}.setDisabled(true);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="ButtonTopValueDownLoad" runat="server" Text="下载模板">
                                    <Listeners>
                                        <Click Handler="window.open('../../Upload/ExcelTemplate/Template_PromotionDealerPointRatio.xls')" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:Panel ID="PanelWd7PointRatioList" runat="server" BodyBorder="false" Header="false"
                            FormGroup="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout4" runat="server">
                                    <ext:GridPanel ID="GridWd7PointRatio" runat="server" StoreID="UpLoadPointRatioStore"
                                        Border="false" Title="列表" Icon="Lorry" StripeRows="true" Height="300" AutoScroll="true">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="SAPCode" DataIndex="SAPCode" Align="Left" Header="经销商Code"
                                                    Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="DMA_ChineseName" DataIndex="DMA_ChineseName" Align="Left" Header="经销商名称"
                                                    Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="BU" DataIndex="BU" Align="Left" Header="产品线" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Align="Left" Header="产品线名称"
                                                    Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="Ratio" DataIndex="Ratio" Align="Left" Header="加价率" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ErrMsg" DataIndex="ErrMsg" Align="Left" Header="错误信息" Width="200">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <View>
                                            <ext:GridView ID="GridView1" runat="server">
                                                <GetRowClass Fn="getIsErrRowClassDealer" />
                                            </ext:GridView>
                                        </View>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolPointRatio" runat="server" PageSize="20" StoreID="UpLoadPointRatioStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Buttons>
                <ext:Button ID="ButtonWd7Submint" runat="server" Text="提交" Icon="LorryAdd" Hidden="true">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.PointRatioSubmint({ success: function() { #{GridPanel1}.reload();#{GridWd7PointRatio}.reload();#{wd7PointRatioUpload}.hide(null);},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="Button1" runat="server" Text="关闭" Icon="LorryStop">
                    <Listeners>
                        <Click Handler="#{wd7PointRatioUpload}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
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
